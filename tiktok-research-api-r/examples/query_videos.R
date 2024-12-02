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
qps <- 5
research_api <- TikTokResearchAPI$new(client_key, client_secret, qps)

query_criteria <- Criteria$new(
  operation = "EQ",
  field_name = "hashtag_name",
  field_values = list("tiktok")
)

# Define query object
query <- Query$new(
  and_criteria = list(query_criteria)
)

video_request <- QueryVideoRequest$new(
  fields="view_count",
  query = query,
  start_date = "20240501",
  end_date = "20240630",
  max_count = 10,
  max_total = 100
)

# Query the API for videos matching the request
video_results <- research_api$query_videos(video_request, fetch_all_pages = TRUE)

videos <- video_results$aggregated_videos
search_id <- video_results$search_id
cursor <- video_results$root_cursor
has_more <- video_results$has_more
start_date = video_results$start_date
end_date = video_results$end_date
