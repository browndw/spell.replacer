#' spell.replacer: Probabilistic Spelling Correction
#'
#' This package provides functions for automatic spelling correction in
#' character vectors using probabilistic methods based on string distance and
#' word frequency data from the Corpus of Contemporary American English (COCA).
#'
#' @keywords internal
"_PACKAGE"

# Declare global variables to avoid R CMD check NOTEs
utils::globalVariables("coca_list")

#' @importFrom hunspell hunspell_find
#' @importFrom stringr str_starts str_remove_all str_to_title
#' @importFrom stringdist stringdist
#' @importFrom textclean mgsub_regex
NULL

#' COCA Word List
#'
#' A character vector containing the 100,000 most frequent words from the
#' Corpus of Contemporary American English (COCA), sorted by frequency from
#' most to least frequent. This word list serves as the default reference
#' for spelling correction in the spell_replace function.
#'
#' @format A character vector with 100,000 elements:
#' \describe{
#'   Each element is a word from COCA, with the first element being the most
#'   frequent word ("the") and subsequent elements decreasing in frequency.
#' }
#' @source Corpus of Contemporary American English (COCA)
#'   \url{https://www.english-corpora.org/coca/}
#' @examples
#' # View the first 10 most frequent words
#' head(coca_list, 10)
#'
#' # Check if a word is in the list
#' "hello" %in% coca_list
#'
#' # Find the rank of a specific word
#' which(coca_list == "hello")
"coca_list"

#' Probabilistic Spelling Correction
#'
#' Automatically replaces misspelled words in a character vector based on their
#' string distance from a list of words sorted by frequency in a corpus.
#'
#' @param txt A character vector containing text to be spell-checked
#' @param word_list A character vector of correctly spelled words sorted by
#'   frequency (default: coca_list)
#' @param ignore_names Logical. If TRUE, ignores potential proper names
#'   (capitalized words that appear multiple times)
#' @param threshold Numeric. Maximum string distance threshold for considering
#'   a word as a correction candidate (default: 0.12)
#' @param ignore_punct Logical. If TRUE, ignores punctuation when calculating
#'   string distance
#' @return A character vector with corrected spellings
#' @export
spell_replace <- function(txt, word_list = coca_list, ignore_names = TRUE,
                          threshold = 0.12, ignore_punct = FALSE) {
  bad_words <- unlist(hunspell::hunspell_find(txt))
  if (ignore_names == TRUE) {
    bad_words <- bad_words[!((duplicated(bad_words) |
                                duplicated(bad_words, fromLast = TRUE)) &
                               stringr::str_starts(bad_words, "[A-Z]"))]
  }
  replace_with <- sapply(bad_words, correct, sorted_words = word_list,
                         threshold = threshold, ignore_punct = ignore_punct,
                         USE.NAMES = FALSE)
  to_replace <- sapply(seq_along(bad_words), function(i) {
    paste0("\\b", bad_words[i], "\\b")
  })
  clean_text <- textclean::mgsub_regex(txt, to_replace, replace_with)
  return(clean_text)
}

#' Correct a Single Misspelled Word
#'
#' Finds the best correction for a single misspelled word using string distance
#' and frequency-based ranking from a sorted word list.
#'
#' @param word A character string representing the misspelled word
#' @param sorted_words A character vector of correctly spelled words sorted
#'   by frequency
#' @param ignore_punct Logical. If TRUE, ignores punctuation when calculating
#'   string distance
#' @param threshold Numeric. Maximum string distance threshold for considering
#'   a word as a correction candidate
#' @return A character string with the corrected word
#' @export
correct <- function(word, sorted_words, ignore_punct = FALSE,
                    threshold = 0.12) {
  is_upper <- stringr::str_starts(word, "[A-Z]")
  word <- tolower(word)
  if (ignore_punct == TRUE) {
    edit_dist <- suppressWarnings(
      stringdist::stringdist(
        stringr::str_remove_all(word, "[[:punct:]]"),
        stringr::str_remove_all(sorted_words, "[[:punct:]]"),
        method = "jw", p = 0.1
      )
    )
  } else {
    edit_dist <- suppressWarnings(
      stringdist::stringdist(word, sorted_words, method = "jw", p = 0.1)
    )
  }
  candidates <- sorted_words[edit_dist <= threshold]
  if (length(candidates) == 0) candidates <- word
  candidates_idx <- which(edit_dist <= threshold)
  replacement_idx <- which.min(
    as.vector(scale(candidates_idx)) *
      ((1 - edit_dist[edit_dist <= threshold])^2)
  )
  replacement <- ifelse(length(candidates) == 1, candidates,
                        candidates[replacement_idx])
  replacement <- ifelse(is_upper == TRUE, stringr::str_to_title(replacement),
                        replacement)
  return(replacement)
}
