# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

library(devtools)
library(here)
# Set the option to display more digits
options(scipen=999)

script_dir <- here::here()

load_all(script_dir)

client_key <- 'Your_client_key'
client_secret <- 'Your_client_secret'

# Initialize the API client
research_api <- TikTokResearchAPI$new(client_key, client_secret)

# Define query object
username <- ""
user_liked_videos_request <- QueryUserLikedVideosRequest$new(
  username = username,
  max_count=100
)

# Query the API for liked videos matching the request
liked_videos <- research_api$query_user_liked_videos(user_liked_videos_request, fetch_all_pages = FALSE)

liked_videos <- liked_videos_results$aggregated_liked_videos
root_cursor <- liked_videos_results$root_cursor
has_more <- liked_videos_results$has_more
