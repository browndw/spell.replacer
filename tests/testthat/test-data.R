test_that("coca_list data object is properly loaded", {
  # Check that coca_list exists
  expect_true(exists("coca_list"))
  
  # Check that it's a character vector
  expect_type(coca_list, "character")
  
  # Check that it has the expected length
  expect_length(coca_list, 100000)
})

test_that("coca_list contains expected frequent words", {
  # Check that common English words are in the list
  expect_true("the" %in% coca_list)
  expect_true("and" %in% coca_list)
  expect_true("of" %in% coca_list)
  expect_true("to" %in% coca_list)
  expect_true("a" %in% coca_list)
})

test_that("coca_list is sorted by frequency", {
  # The most frequent word should be "the"
  expect_equal(coca_list[1], "the")
  
  # Check that some very common words are near the beginning
  top_10 <- coca_list[1:10]
  expect_true("the" %in% top_10)
  expect_true("and" %in% top_10)
  expect_true("of" %in% top_10)
})

test_that("coca_list has no missing values", {
  expect_false(any(is.na(coca_list)))
  expect_false(any(coca_list == ""))
  expect_false(any(is.null(coca_list)))
})

test_that("coca_list contains only valid character data", {
  # Check that all elements are non-empty strings
  expect_true(all(nchar(coca_list) > 0))
  
  # Check that there are no duplicates (each word should appear only once)
  expect_equal(length(coca_list), length(unique(coca_list)))
})
