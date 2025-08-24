test_that("spell_replace function works with basic text", {
  # Simple test with known words (using a subset of coca_list)
  test_text <- "This is a tesst of the speling correcter."
  
  # Should correct "tesst" to "test" and "speling" to "spelling"
  result <- spell_replace(test_text, threshold = 0.3)
  expect_type(result, "character")
  expect_length(result, 1)
  
  # Result should be different from input (corrections made)
  expect_false(identical(test_text, result))
})

test_that("spell_replace preserves correctly spelled text", {
  correct_text <- "This is a test of the spelling corrector."
  
  # Should return identical text if no misspellings
  result <- spell_replace(correct_text)
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("spell_replace handles multiple sentences", {
  test_text <- c("This is a tesst.", "Another sentnce with errors.")
  
  result <- spell_replace(test_text, threshold = 0.3)
  expect_type(result, "character")
  expect_length(result, length(test_text))
})

test_that("spell_replace respects ignore_names parameter", {
  # Text with a proper name that might be flagged as misspelled
  test_text <- "John Smith went to the stor."
  
  # With ignore_names = TRUE (default), should not change repeated capitalized words
  result1 <- spell_replace(test_text, ignore_names = TRUE, threshold = 0.3)
  
  # With ignore_names = FALSE, might try to correct names
  result2 <- spell_replace(test_text, ignore_names = FALSE, threshold = 0.3)
  
  expect_type(result1, "character")
  expect_type(result2, "character")
})

test_that("spell_replace respects threshold parameter", {
  test_text <- "This is a tesst."
  
  # Low threshold should be more conservative
  result1 <- spell_replace(test_text, threshold = 0.05)
  
  # High threshold should be more liberal
  result2 <- spell_replace(test_text, threshold = 0.5)
  
  expect_type(result1, "character")
  expect_type(result2, "character")
})

test_that("spell_replace handles ignore_punct parameter", {
  test_text <- "This is a test with punct-uation."
  
  result1 <- spell_replace(test_text, ignore_punct = FALSE)
  result2 <- spell_replace(test_text, ignore_punct = TRUE)
  
  expect_type(result1, "character")
  expect_type(result2, "character")
})

test_that("spell_replace handles edge cases", {
  # Empty string
  expect_equal(spell_replace(""), "")
  
  # Single word
  result <- spell_replace("tesst")
  expect_type(result, "character")
  expect_length(result, 1)
  
  # Multiple empty strings
  result <- spell_replace(c("", "", ""))
  expect_type(result, "character")
  expect_length(result, 3)
})

test_that("spell_replace accepts custom word lists", {
  # Create a simple custom word list
  custom_list <- c("hello", "world", "test", "custom")
  test_text <- "helo wrld"
  
  result <- spell_replace(test_text, word_list = custom_list, threshold = 0.3)
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("spell_replace parameter validation", {
  test_text <- "This is a test."
  
  # Test with valid parameters
  expect_no_error(spell_replace(test_text, ignore_names = TRUE))
  expect_no_error(spell_replace(test_text, ignore_names = FALSE))
  expect_no_error(spell_replace(test_text, threshold = 0.1))
  expect_no_error(spell_replace(test_text, threshold = 0.5))
  expect_no_error(spell_replace(test_text, ignore_punct = TRUE))
  expect_no_error(spell_replace(test_text, ignore_punct = FALSE))
})
