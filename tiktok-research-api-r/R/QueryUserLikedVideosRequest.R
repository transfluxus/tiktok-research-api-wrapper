# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' QueryUserLikedVideosRequest Reference Class
#'
#' A class to represent a request for user liked videos with various parameters.
#'
#' @field username A character string representing the username.
#' @field max_count An optional  numeric value representing the maximum count of videos to retrieve.
#' @field cursor An optional character string for the cursor.
#' @field fields An optional character string representing the fields to retrieve.
#'
#' @name QueryUserLikedVideosRequest
#' @export
QueryUserLikedVideosRequest <- setRefClass(
  "QueryUserLikedVideosRequest",
  fields = list(
    username = "character",
    max_count = "numeric",
    cursor = "character",
    fields = "character"
  ),
  methods = list(
    initialize = function(
        username,
        max_count = 20,
        cursor = NA_character_,
        fields = NA_character_) {
      .self$username <- username
      .self$max_count <- max_count
      .self$cursor <- cursor
      .self$fields <- if (is.na(fields)) {
        "id,create_time,username,region_code,video_description,music_id,like_count,comment_count,share_count,view_count,hashtag_names"
      } else {
        fields
      }
    }
  )
)
