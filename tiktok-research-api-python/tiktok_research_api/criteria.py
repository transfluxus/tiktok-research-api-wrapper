# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

__all__ = ["Criteria"]


class Criteria:
    def __init__(self, operation, field_name, field_values):
        self.operation = operation
        self.field_name = field_name
        self.field_values = field_values

    def to_dict(self):
        return {
            "operation": self.operation,
            "field_name": self.field_name,
            "field_values": self.field_values,
        }
