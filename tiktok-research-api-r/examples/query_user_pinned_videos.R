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
user_pinned_videos_request <- QueryUserPinnedVideosRequest$new(
  username = username,
  fields = "id,create_time,username,region_code,video_description,music_id,like_count,comment_count,share_count,view_count,hashtag_names" # Default fields
)

# Query the API for videos matching the request
pinned_videos <- research_api$query_user_pinned_videos(user_pinned_videos_request)

print(pinned_videos)
