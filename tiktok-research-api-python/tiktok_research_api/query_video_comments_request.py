# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

__all__ = ["QueryVideoCommentsRequest"]


class QueryVideoCommentsRequest:
    def __init__(
        self,
        video_id,
        max_count=20,
        cursor=None,
        fields=None,
    ):
        self.video_id = video_id
        self.max_count = max_count
        self.cursor = cursor
        self.fields = (
            "id, video_id, text, like_count, reply_count, parent_comment_id, create_time"
            if not fields
            else fields
        )
