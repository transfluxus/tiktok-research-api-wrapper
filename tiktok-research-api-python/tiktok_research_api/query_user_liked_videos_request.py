# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

__all__ = ["QueryUserLikedVideosRequest"]


class QueryUserLikedVideosRequest:
    def __init__(
        self,
        username,
        max_count=20,
        cursor=None,
        fields=None,
    ):
        self.username = username
        self.max_count = max_count
        self.cursor = cursor
        self.fields = (
            "id,create_time,username,region_code,video_description,music_id,like_count,comment_count,share_count,view_count,hashtag_names"
            if not fields
            else fields
        )
