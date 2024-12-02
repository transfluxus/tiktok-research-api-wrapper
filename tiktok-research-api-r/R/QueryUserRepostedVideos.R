# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' QueryUserRepostedVideosRequest Reference Class
#'
#' A class to represent a request for user reposted videos with various parameters.
#'
#' @field username A character string representing the username.
#' @field fields An optional character string representing the fields to retrieve.
#' @field cursor An optional character string for the cursor.
#' @field max_count An optional numeric value representing the maximum count of videos to retrieve.
#'
#' @name QueryUserRepostedVideosRequest
#' @export
QueryUserRepostedVideosRequest <- setRefClass(
  "QueryUserRepostedVideosRequest",
  fields = list(
    username = "character",
    fields = "character",
    cursor = "character",
    max_count = "numeric"
  ),
  methods = list(
    initialize = function(
        username,
        fields = NA_character_,
        cursor = NA_character_,
        max_count = NA_integer_ ) {
      .self$username <- username
      .self$fields <- if (is.na(fields)) {
        "id,create_time,region_code,music_id,like_count,comment_count,share_count,view_count,hashtag_names"
      } else {
        fields
      }
      .self$cursor <- cursor
      .self$max_count <- max_count
    }
  )
)
