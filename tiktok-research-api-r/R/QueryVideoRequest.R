# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' QueryVideoRequest Reference Class
#'
#' A class to represent a query video request with various parameters.
#'
#' @field query A Query object representing the query.
#' @field start_date A character string representing the start date.
#' @field end_date A character string representing the end date.
#' @field max_count An optional  numeric value representing the maximum count.
#' @field max_total An optional  numeric value representing the maximum count on pagination.
#' @field cursor An optional character string for the cursor.
#' @field is_random An optional character value indicating if the request is random.
#' @field search_id An optional character string for the search ID.
#' @field fields An optional character string representing the fields to retrieve.
#'
#' @name QueryVideoRequest
#' @export
QueryVideoRequest <- setRefClass(
  "QueryVideoRequest",
  fields = list(
    query = "ANY",
    start_date = "character",
    end_date = "character",
    max_count = "numeric",
    max_total = "numeric",
    cursor = "numeric",
    is_random = "character",
    search_id = "character",
    fields = "character"
  ),
  methods = list(
    initialize = function(
        query,
        start_date,
        end_date,
        max_count = 20,
        max_total = 100000,
        cursor = 0,
        is_random = NA_character_,
        search_id = NA_character_,
        fields = NA_character_) {
      .self$query <- query
      .self$start_date <- start_date
      .self$end_date <- end_date
      .self$max_count <- max_count
      .self$max_total <- max_total
      .self$cursor <- cursor
      .self$search_id <- search_id
      .self$is_random <- is_random
      .self$fields <- if (is.na(fields)) {
        "id,video_description,create_time,region_code,share_count,view_count,like_count,comment_count,music_id,hashtag_names,username,effect_ids,playlist_id,voice_to_text"
      } else {
        fields
      }
    }
  )
)
