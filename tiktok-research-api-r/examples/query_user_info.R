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
user_info_request <- QueryUserInfoRequest$new(
  username = username
)

# Query the API for user matching the request
userinfo <- research_api$query_user_info(user_info_request)

print(userinfo)
