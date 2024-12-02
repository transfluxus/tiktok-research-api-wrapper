# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

library(devtools)
library(here)

script_dir <- here::here()

load_all(script_dir)

client_key <- 'Your_client_key'
client_secret <- 'Your_client_secret'

# Initialize the API client
research_api <- TikTokResearchAPI$new(client_key, client_secret)

# Define query object
username <- ""
user_following_request <- QueryUserFollowingRequest$new(
  username = username
)

# Query the API for users matching the request
user_following_results <- research_api$query_user_following(user_following_request, fetch_all_pages = FALSE)

user_following <- user_following_results$aggregated_following
root_cursor <- user_following_results$root_cursor
has_more <- user_following_results$has_more
