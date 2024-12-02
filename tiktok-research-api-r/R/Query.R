# Copyright 2024 TikTok Pte. Ltd.
#
# This source code is licensed under the MIT license found in
# the LICENSE file in the root directory of this source tree.

#' Query Reference Class
#'
#' A class to represent a query with AND, OR, and NOT criteria.
#'
#' @field and_criteria A list of Criteria objects for AND conditions.
#' @field or_criteria A list of Criteria objects for OR conditions.
#' @field not_criteria A list of Criteria objects for NOT conditions.
#'
#' @name Query
#' @export
Query <- setRefClass(
  "Query",
  fields = list(
    and_criteria = "list",
    or_criteria = "list",
    not_criteria = "list"
  ),
  methods = list(
    initialize = function(and_criteria = list(), or_criteria = list(), not_criteria = list()) {
      .self$and_criteria <- and_criteria
      .self$or_criteria <- or_criteria
      .self$not_criteria <- not_criteria
    },
    to_list = function() {
      return(list(
        and = lapply(.self$and_criteria, function(criteria) criteria$to_list()),
        or = lapply(.self$or_criteria, function(criteria) criteria$to_list()),
        not = lapply(.self$not_criteria, function(criteria) criteria$to_list())
      ))
    }
  )
)
