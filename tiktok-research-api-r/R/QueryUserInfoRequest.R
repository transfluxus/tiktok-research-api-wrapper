# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' QueryUserInfoRequest Reference Class
#'
#' A class to represent a user info request with various parameters.
#'
#' @field username A character string representing the username.
#' @field fields An optional character string of fields to be retrieved.
#'
#' @name QueryUserInfoRequest
#' @export
QueryUserInfoRequest <- setRefClass(
  "QueryUserInfoRequest",
  fields = list(
    username = "character",
    fields = "character"
  ),
  methods = list(
    initialize = function(username, fields = NA_character_) {
      .self$username <- username
      .self$fields <- if (is.na(fields)) {
        "display_name,bio_description,avatar_url,is_verified,follower_count,following_count,likes_count,video_count"
      } else {
        fields
      }
    }
  )
)
