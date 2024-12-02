# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

__all__ = ["QueryUserFollowersRequest"]


class QueryUserFollowersRequest:
    def __init__(
        self,
        username,
        max_count=20,
        cursor=None,
    ):
        self.username = username
        self.max_count = max_count
        self.cursor = cursor
