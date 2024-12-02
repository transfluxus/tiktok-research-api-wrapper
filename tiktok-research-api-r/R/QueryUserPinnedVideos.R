# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' QueryUserPinnedVideosRequest Reference Class
#'
#' A class to represent a request for user pinned videos with various parameters.
#'
#' @field username A character string representing the username.
#' @field fields An optional character string representing the fields to retrieve.
#'
#' @name QueryUserPinnedVideosRequest
#' @export
QueryUserPinnedVideosRequest <- setRefClass(
  "QueryUserPinnedVideosRequest",
  fields = list(
    username = "character",
    fields = "character"
  ),
  methods = list(
    initialize = function(
        username,
        fields = NA_character_) {
      .self$username <- username
      .self$fields <- if (is.na(fields)) {
        "id,create_time,username,region_code,video_description,music_id,like_count,comment_count,share_count,view_count,hashtag_names"
      } else {
        fields
      }
    }
  )
)
