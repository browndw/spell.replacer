test_that("correct function works with basic misspellings", {
  # Create a test word list where "hello" is early (more frequent)
  test_words <- c("hello", "world", "the", "and", "of", "to", "a", "in", "that", "is")
  
  # Test basic correction
  expect_equal(correct("helo", test_words, threshold = 0.3), "hello")
  expect_equal(correct("wrold", test_words, threshold = 0.3), "world")
  
  # Test exact matches return unchanged
  expect_equal(correct("hello", test_words), "hello")
  expect_equal(correct("world", test_words), "world")
})

test_that("correct function handles capitalization correctly", {
  test_words <- c("hello", "world", "the", "and")
  
  # Test capitalized input
  expect_equal(correct("Hello", test_words, threshold = 0.3), "Hello")
  expect_equal(correct("HELLO", test_words, threshold = 0.3), "Hello")
  
  # Test lowercase input
  expect_equal(correct("hello", test_words), "hello")
})

test_that("correct function respects threshold parameter", {
  test_words <- c("hello", "world", "the", "and")
  
  # With low threshold, should not correct very different words
  expect_equal(correct("xyz", test_words, threshold = 0.1), "xyz")
  
  # With high threshold, should correct more liberally
  expect_equal(correct("helo", test_words, threshold = 0.5), "hello")
})

test_that("correct function handles punctuation correctly", {
  test_words <- c("hello", "world", "can't", "don't")
  
  # Test with ignore_punct = FALSE (default)
  result1 <- correct("cant", test_words, threshold = 0.3)
  
  # Test with ignore_punct = TRUE
  result2 <- correct("cant", test_words, ignore_punct = TRUE, threshold = 0.3)
  expect_equal(result2, "can't")
})

test_that("correct function handles edge cases", {
  test_words <- c("hello", "world")
  
  # Empty string
  expect_type(correct("", test_words), "character")
  
  # Single character
  expect_type(correct("a", test_words), "character")
  
  # Very long word
  long_word <- paste0(rep("a", 50), collapse = "")
  expect_type(correct(long_word, test_words), "character")
})

test_that("correct function parameter validation", {
  test_words <- c("hello", "world")
  
  # Test with valid parameters
  expect_no_error(correct("helo", test_words, ignore_punct = FALSE, threshold = 0.12))
  expect_no_error(correct("helo", test_words, ignore_punct = TRUE, threshold = 0.5))
})
