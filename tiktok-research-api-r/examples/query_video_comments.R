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
video_comments_request <- QueryVideoCommentsRequest$new(
  video_id = "",
  max_count = 10
)

# Query the API for comments matching the request
comment_results <- research_api$query_video_comments(video_comments_request, fetch_all_pages = FALSE)

comments <- comment_results$aggregated_comments
root_cursor <- comment_results$root_cursor
has_more <- comment_results$has_more
