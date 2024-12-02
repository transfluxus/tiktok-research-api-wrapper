# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

from tiktok_research_api import *
import os


if __name__ == "__main__":
    client_key = 'Your_client_key'
    client_secret = 'Your_client_secret'

    # Initialize the API client
    research_api = TikTokResearchAPI(client_key, client_secret)

    # Define query object
    username = ""
    user_following_request = QueryUserFollowingRequest(username=username)

    # Query the API for users matching the request
    user_following, cursor, has_more = research_api.query_user_following(
        user_following_request, fetch_all_pages=False
    )
    print(cursor, has_more)
    print(user_following)
