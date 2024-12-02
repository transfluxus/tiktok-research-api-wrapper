# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' QueryUserFollowersRequest Reference Class
#'
#' A class to represent a request for the list of users that a specific user is following.
#'
#' @field username A character string representing the username.
#' @field max_count An optional numeric value representing the maximum count of users to retrieve.
#' @field cursor An optional character string for the cursor.
#'
#' @name QueryUserFollowersRequest
#' @export
QueryUserFollowersRequest <- setRefClass(
  "QueryUserFollowersRequest",
  fields = list(
    username = "character",
    max_count = "numeric",
    cursor = "character"
  ),
  methods = list(
    initialize = function(
        username,
        max_count = 20,
        cursor = NA_character_) {
      .self$username <- username
      .self$max_count <- max_count
      .self$cursor <- cursor
    }
  )
)
