# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' TikTok Research API Client
#'
#' A class to interact with the TikTok Research API.
#'
#'
source("R/Errors.R")

#' @import methods
#' @export TikTokResearchAPI
TikTokResearchAPI <- setRefClass(
  "TikTokResearchAPI",
  fields = list(
    url = "character",
    client_key = "character",
    client_secret = "character",
    client_token = "character",
    requests = "numeric",
    start_time = "POSIXct",
    qps = "numeric"
  ),
  methods = list(
    initialize = function(client_key, client_secret, qps = 10) {
      if (missing(client_key) || client_key == "" || missing(client_secret) || client_secret == "") {
        stop("2 CLIENT_KEY and CLIENT_SECRET environment variables must be set.")
      }
      if (qps <= 0) {
        stop("QPS must be a positive number")
      }

      .self$url <- "https://open.tiktokapis.com"
      .self$client_key <- client_key
      .self$client_secret <- client_secret
      .self$qps <- qps
      .self$requests <- 0
      .self$start_time <- Sys.time()
      .self$client_token <- .self$get_client_token()
    },
    .fromJSON = function(response) {
      content_text <- httr::content(response, as = "text", encoding = "UTF-8")
      parsed_response <- jsonlite::fromJSON(content_text, simplifyVector = FALSE, bigint_as_char = TRUE)

      convert_to_int64 <- function(x) {
        if (is.character(x) && grepl("^[0-9]+$", x)) {
          x <- bit64::as.integer64(x)
        }
        return(x)
      }

      parsed_response <- rapply(parsed_response, convert_to_int64, how = "replace")

      return(parsed_response)
    },
    get_client_token = function() {
      endpoint <- paste0(.self$url, "/v2/oauth/token/")
      token_headers <- c("Content-Type" = "application/x-www-form-urlencoded")
      token_payload <- list(
        client_key = .self$client_key,
        client_secret = .self$client_secret,
        grant_type = "client_credentials"
      )
      .self$rate_limiter()
      response <- httr::POST(endpoint, httr::add_headers(.headers = token_headers), body = token_payload, encode = "form")
      httr::stop_for_status(response)
      get_token_response <- httr::content(response, as = "parsed", type = "application/json")
      error_code <- get_token_response$error
      if (!is.null(error_code) && error_code != APIErrorResponse$OK) {
        description <- get_token_response$error_description
        stop(sprintf(
          "Error fetching client token: error code=%s, error description=%s",
          error_code, description
        ))
      }
      access_token <- get_token_response$access_token
      return(access_token)
    },
    rate_limiter = function() {
      current_time <- Sys.time()
      elapsed_time <- as.numeric(difftime(current_time, .self$start_time, units = "secs"))

      if (elapsed_time > 1) {
        # Reset the counter and start time if the time window has passed
        .self$requests <- 0
        .self$start_time <- current_time
      }

      if (.self$requests >= .self$qps) {
        # Enforce delay if the limit is reached
        wait_time <- 1 - elapsed_time
        cat(sprintf("Rate limit reached. Waiting for %.2f seconds...\n", wait_time))
        Sys.sleep(wait_time)
        # Reset the counter and start time after waiting
        .self$requests <- 0
        .self$start_time <- Sys.time()
      }

      .self$requests <- .self$requests + 1
    },
    refresh_token = function() {
      .self$client_token <- .self$get_client_token()
    },
    headers = function() {
      return(c(
        "Content-Type" = "application/json",
        "Authorization" = paste("Bearer", .self$client_token)
      ))
    },
    .is_response_valid = function(response) {
      response_content <- httr::content(response, as = "parsed", type = "application/json")
      error_code <- response_content$error$code
      log_id <- response_content$error$log_id
      message <- response_content$error$message


      if (!is.null(error_code) && error_code != APIErrorResponse$OK) {
        logging::logerror(sprintf(
          "API call error: %s: %s (Log ID: %s)",
          error_code,message,log_id
        ))
        return(FALSE)
      }
      return(TRUE)
    },
    query_user_info = function(user_info_request) {
      endpoint <- paste0(.self$url, "/v2/research/user/info/?fields=", user_info_request$fields)
      body <- list(
        username = user_info_request$username
      )
      .self$rate_limiter()
      response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
      if (!.self$.is_response_valid(response)) {
        return(NULL)
      }
      response_data <- .self$.fromJSON(response)$data
      return(response_data)
    },
query_videos = function(video_request, fetch_all_pages = FALSE) {
      endpoint <- paste0(.self$url, "/v2/research/video/query/?fields=", video_request$fields)
      max_days <- 30
      current_start <- as.Date(video_request$start_date, format = "%Y%m%d")
      end_date <- as.Date(video_request$end_date, format = "%Y%m%d")
      aggregate_videos <- list()
      while (current_start <= end_date) {
        if (length(aggregate_videos) > video_request$max_total) break
        current_end <- min(current_start + max_days - 1, end_date)
        start_str <- format(current_start, "%Y%m%d")
        end_str <- format(current_end, "%Y%m%d")
        query_dict <- video_request$query$to_list()
        body <- list(
          query = query_dict,
          start_date =start_str,
          end_date = end_str
        )
        if (!is.na(video_request$cursor)) {
          body$cursor <- video_request$cursor
        }
        if (!is.na(video_request$is_random)) {
          body$is_random <- video_request$is_random
        }
        if (!is.na(video_request$search_id)) {
          body$search_id <- video_request$search_id
        }
        if (!is.na(video_request$max_count)) {
          body$max_count <- video_request$max_count
        }

      retries <- 0
      MAX_RETRIES <- 60
      page <- 0 
      show_search_id = TRUE
      max_retries_hit <- FALSE 
      repeat {
        .self$rate_limiter()

        response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
        response_content <- httr::content(response, as = "parsed", type = "application/json")
        
        error_code <- response_content$error$code
        if (!is.null(error_code) && error_code != APIErrorResponse$OK) {
          retries <- retries + 1
          if (retries >= MAX_RETRIES) {
            logging::logerror(sprintf("%s",jsonlite::toJSON(response_content, auto_unbox = TRUE)))
            max_retries_hit <- TRUE
            break
          }
          Sys.sleep(1)
          next
        }

        response_data <- .self$.fromJSON(response)$data
        videos <- response_data$videos
        aggregate_videos <- c(aggregate_videos, videos)
        has_more <- response_data$has_more
        root_cursor <- response_data$cursor
        search_id <- as.character(response_data$search_id)

        if (!is.null(search_id) && show_search_id) {
          logging::loginfo(paste("searchID:", search_id))
          show_search_id = FALSE
        }

        retries <- 0 # Reset retries on success
        page <- page + 1
        if (!has_more) break
        if (length(aggregate_videos) > video_request$max_total) break
        if (!fetch_all_pages) break
        logging::loginfo(sprintf("Page %d got %d videos and has_more %s", page, length(videos), has_more))
        flush.console()
        if (!is.null(root_cursor)) {
          body$cursor <- root_cursor
          body$search_id <- search_id
        }
      }
      if (max_retries_hit == TRUE) {
        logging::logerror(sprintf("Max retries hit for query_videos"))
        break 
      } else {
        current_start <- current_end + 1 
      }

      }
      return_list <- list(aggregated_videos = aggregate_videos, search_id = search_id, root_cursor = root_cursor,
                          has_more = has_more, start_date = start_str, end_date = end_str)
      return(return_list)
    },
    query_video_comments = function(comment_info_request, fetch_all_pages = FALSE) {
      endpoint <- paste0(.self$url, "/v2/research/video/comment/list/?fields=", comment_info_request$fields)
      aggregate_comments <- list()
      body <- list(
        video_id = comment_info_request$video_id
      )
      if (!is.na(comment_info_request$cursor)) {
        body$cursor <- comment_info_request$cursor
      }
      if (!is.na(comment_info_request$max_count)) {
        body$max_count <- comment_info_request$max_count
      }
      repeat {
        .self$rate_limiter()
        response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
        if (!.self$.is_response_valid(response)) {
          return(NULL)
        }
        response_data <- .self$.fromJSON(response)$data
        video_comments <- response_data$comments
        aggregate_comments <- c(aggregate_comments, video_comments)
        has_more <- response_data$has_more
        root_cursor <- response_data$cursor
        if (!fetch_all_pages || !has_more) {
          break
        }
        if (!is.null(root_cursor)) {
          body$cursor <- root_cursor
        }
      }
      return_list <- list(aggregated_comments = aggregate_comments, root_cursor = root_cursor, has_more = has_more)
      return(return_list)
    },
    query_user_liked_videos = function(user_liked_videos_request, fetch_all_pages = FALSE) {
      endpoint <- paste0(.self$url, "/v2/research/user/liked_videos/?fields=", user_liked_videos_request$fields)
      aggregate_liked_videos <- list()
      body <- list(
        username = user_liked_videos_request$username
      )
      if (!is.na(user_liked_videos_request$cursor)) {
        body$cursor <- user_liked_videos_request$cursor
      }
      if (!is.na(user_liked_videos_request$max_count)) {
        body$max_count <- user_liked_videos_request$max_count
      }
      repeat {
        .self$rate_limiter()
        response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
        if (!.self$.is_response_valid(response)) {
          return(NULL)
        }

        response_data <- .self$.fromJSON(response)$data
        user_liked_videos <- response_data$user_liked_videos
        aggregate_liked_videos <- c(aggregate_liked_videos, user_liked_videos)
        has_more <- response_data$has_more
        root_cursor <- response_data$cursor
        if (!fetch_all_pages || !has_more) {
          break
        }
        if (!is.null(root_cursor)) {
          body$cursor <- root_cursor
        }
      }
      return_list <- list(aggregated_liked_videos = aggregate_liked_videos, root_cursor = root_cursor, has_more = has_more)
      return(return_list)
    },
    query_user_followers = function(query_user_followers_request, fetch_all_pages = FALSE) {
      endpoint <- paste0(.self$url, "/v2/research/user/followers/")
      aggregate_followers <- list()
      body <- list(
        username = query_user_followers_request$username
      )
      if (!is.na(query_user_followers_request$cursor)) {
        body$cursor <- query_user_followers_request$cursor
      }
      if (!is.na(query_user_followers_request$max_count)) {
        body$max_count <- query_user_followers_request$max_count
      }
      repeat {
        .self$rate_limiter()
        response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
        if (!.self$.is_response_valid(response)) {
          return(NULL)
        }
        response_data <- .self$.fromJSON(response)$data
        user_followers <- response_data$user_followers
        aggregate_followers <- c(aggregate_followers, user_followers)
        has_more <- response_data$has_more
        root_cursor <- response_data$cursor
        if (!fetch_all_pages || !has_more) {
          break
        }
        if (!is.null(root_cursor)) {
          body$cursor <- root_cursor
        }
      }
      return_list <- list(aggregated_followers = aggregate_followers, root_cursor = root_cursor, has_more = has_more)
      return(return_list)
    },
    query_user_following = function(query_user_following_request, fetch_all_pages = FALSE) {
      endpoint <- paste0(.self$url, "/v2/research/user/following/")
      aggregate_following <- list()
      body <- list(
        username = query_user_following_request$username
      )
      if (!is.na(query_user_following_request$cursor)) {
        body$cursor <- query_user_following_request$cursor
      }
      if (!is.na(query_user_following_request$max_count)) {
        body$max_count <- query_user_following_request$max_count
      }
      repeat {
        .self$rate_limiter()
        response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
        if (!.self$.is_response_valid(response)) {
          return(NULL)
        }
        response_data <- .self$.fromJSON(response)$data
        user_followers <- response_data$user_following
        aggregate_following <- c(aggregate_following, user_followers)
        has_more <- response_data$has_more
        root_cursor <- response_data$cursor
        if (!fetch_all_pages || !has_more) {
          break
        }
        if (!is.null(root_cursor)) {
          body$cursor <- root_cursor
        }
      }
      return_list <- list(aggregated_following = aggregate_following, root_cursor = root_cursor, has_more = has_more)
      return(return_list)
    },
    query_user_pinned_videos = function(user_pinned_videos_request) {
      endpoint <- paste0(.self$url, "/v2/research/user/pinned_videos/?fields=", user_pinned_videos_request$fields)
      aggregate_pinned_videos <- list()
      body <- list(
        username = user_pinned_videos_request$username
      )
      .self$rate_limiter()
      response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
      if (!.self$.is_response_valid(response)) {
        return(NULL)
      }
      response_data <- .self$.fromJSON(response)$data
      user_followers <- response_data$pinned_videos_list
      aggregate_pinned_videos <- c(aggregate_pinned_videos, user_followers)
      return(aggregate_pinned_videos)
    },
    query_user_reposted_videos = function(reposted_videos_request, fetch_all_pages = FALSE) {
      endpoint <- paste0(.self$url, "/v2/research/user/reposted_videos/?fields=", reposted_videos_request$fields)
      body <- list(
        username = reposted_videos_request$username
      )
      if (!is.na(reposted_videos_request$cursor)) {
        body$cursor <- reposted_videos_request$cursor
      }
      if (!is.na(reposted_videos_request$max_count)) {
        body$max_count <- reposted_videos_request$max_count
      }
      aggregated_reposted_videos <- list()
      repeat {
        .self$rate_limiter()
        response <- httr::POST(endpoint, body = body, encode = "json", httr::add_headers(.headers = .self$headers()))
        if (!.self$.is_response_valid(response)) {
          return(NULL)
        }
        response_data <- .self$.fromJSON(response)$data
        videos <- response_data$reposted_videos
        aggregated_reposted_videos <- c(aggregated_reposted_videos, videos)
        has_more <- response_data$has_more
        root_cursor <- response_data$cursor
        if (!fetch_all_pages || !has_more) {
          break
        }
        if (!is.null(root_cursor)) {
          body$cursor <- root_cursor
        }
      }
      return_list <- list(aggregated_reposted_videos = aggregated_reposted_videos, root_cursor = root_cursor, has_more = has_more)
      return(return_list)
    }
  )
)
