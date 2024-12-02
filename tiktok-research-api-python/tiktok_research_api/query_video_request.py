# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

__all__ = ["QueryVideoRequest"]


class QueryVideoRequest:
    def __init__(
        self,
        query,
        start_date,
        end_date,
        max_count,
        max_total=1000000,
        cursor=None,
        is_random=None,
        search_id=None,
        fields=None,
    ):
        self.query = query
        self.start_date = start_date
        self.end_date = end_date
        self.max_count = max_count
        self.max_total = max_total
        self.cursor = cursor
        self.search_id = search_id
        self.is_random = is_random
        self.fields = (
            "id,video_description,create_time, region_code,share_count,view_count,like_count,comment_count, music_id,hashtag_names, username,effect_ids,playlist_id,voice_to_text"
            if not fields
            else fields
        )
