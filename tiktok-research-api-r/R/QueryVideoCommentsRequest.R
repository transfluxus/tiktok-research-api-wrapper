# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' QueryVideoCommentsRequest Reference Class
#'
#' A class to represent a request for video comments with various parameters.
#'
#' @field video_id A int64 string representing the video ID.
#' @field max_count An optional  numeric value representing the maximum count of comments to retrieve.
#' @field cursor An optional character string for the cursor.
#' @field fields An optional character string representing the fields to retrieve.
#'
#' @name QueryVideoCommentsRequest
#' @export
QueryVideoCommentsRequest <- setRefClass(
  "QueryVideoCommentsRequest",
  fields = list(
    video_id = "integer64",
    max_count = "numeric",
    cursor = "character",
    fields = "character"
  ),
  methods = list(
    initialize = function(
        video_id,
        max_count = 20,
        fields = NA_character_,
        cursor = NA_character_) {
      .self$video_id <- as.integer64(video_id)
      .self$max_count <- max_count
      .self$cursor <- cursor
      .self$fields <- if (is.na(fields)) {
        "id,video_id,text,like_count,reply_count,parent_comment_id,create_time"
      } else {
        fields
      }
    }
  )
)
