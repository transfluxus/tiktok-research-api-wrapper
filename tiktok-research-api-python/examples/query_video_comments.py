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
    video_comments_request = QueryVideoCommentsRequest(
        video_id=video_id,
        max_count=10,
    )

    # Query the API for comments matching the request
    videos, cursor, has_more = research_api.query_video_comments(
        video_comments_request, fetch_all_pages=False
    )
    print(cursor, has_more)
    print(videos)
