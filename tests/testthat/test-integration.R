test_that("package integration works end-to-end", {
  # Test the full workflow with realistic text
  test_text <- "The quik brown fox jumps over the lasy dog."
  
  # Should make corrections
  result <- spell_replace(test_text, threshold = 0.2)
  
  expect_type(result, "character")
  expect_length(result, 1)
  
  # Result should be different from input (some corrections should be made)
  expect_false(identical(test_text, result))
  
  # Should still contain the main structure
  expect_true(grepl("brown fox", result, ignore.case = TRUE))
  expect_true(grepl("jumps over", result, ignore.case = TRUE))
})

test_that("package handles complex text scenarios", {
  # Test with multiple types of text issues
  complex_text <- c(
    "This is a tesst of the speling correcter.",
    "The algorithim should work wel on diferent sentances.",
    "It shoud handle multipul paragraphs too."
  )
  
  result <- spell_replace(complex_text, threshold = 0.25)
  
  expect_type(result, "character")
  expect_length(result, length(complex_text))
  
  # Each element should be a string
  expect_true(all(sapply(result, is.character)))
})

test_that("package performance is reasonable", {
  # Test with longer text to ensure reasonable performance
  long_text <- paste(rep("This is a tesst of the speling correcter", 10), collapse = " ")
  
  # Should complete in reasonable time
  start_time <- Sys.time()
  result <- spell_replace(long_text, threshold = 0.2)
  end_time <- Sys.time()
  
  expect_type(result, "character")
  expect_lt(as.numeric(end_time - start_time), 10) # Should take less than 10 seconds
})

test_that("functions work together correctly", {
  # Test that correct() works with the same word list as spell_replace()
  test_word <- "tesst"
  
  # Using the full coca_list
  result1 <- correct(test_word, coca_list, threshold = 0.2)
  
  # Using spell_replace with same parameters
  result2 <- spell_replace(test_word, word_list = coca_list, threshold = 0.2)
  
  expect_type(result1, "character")
  expect_type(result2, "character")
  
  # Both should handle the word
  expect_true(nchar(result1) > 0)
  expect_true(nchar(result2) > 0)
})
