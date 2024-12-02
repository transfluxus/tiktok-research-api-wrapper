# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' Criteria Reference Class
#'
#' A class to represent criteria with an operation, field name, and field values.
#'
#' @field operation A character string representing the operation.
#' @field field_name A character string representing the field name.
#' @field field_values A list of values for the field.
#'
#' @name Criteria
#' @export
Criteria <- setRefClass(
  "Criteria",
  fields = list(
    operation = "character",
    field_name = "character",
    field_values = "list"
  ),
  methods = list(
    initialize = function(operation, field_name, field_values) {
      .self$operation <- operation
      .self$field_name <- field_name
      .self$field_values <- field_values
    },
    to_list = function() {
      return(list(
        operation = .self$operation,
        field_name = .self$field_name,
        field_values = .self$field_values
      ))
    }
  )
)
