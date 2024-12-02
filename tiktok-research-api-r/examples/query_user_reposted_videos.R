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
reposted_videos_request <- QueryUserRepostedVideosRequest$new(
  username = ""
)

# Query the API for videos matching the request
reposted_videos_results <- research_api$query_user_reposted_videos(reposted_videos_request)

reposted_videos <- reposted_videos_results$aggregated_reposted_videos
root_cursor <- reposted_videos_results$root_cursor
has_more <- reposted_videos_results$has_more
