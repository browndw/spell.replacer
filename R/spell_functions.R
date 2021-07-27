#' Helper functions for processing text

#' Replaces the readtext::readtext function that reads a lists of text files into a data frame
#' @param paths A vector of paths to text files that are to be read in
#' @return A readtext data.frame
#' @export
spell_replace <- function(txt, word_list=coca_list, ignore_names=TRUE, threshold=.12, ignore_punct=FALSE){
  bad_words <- unlist(hunspell::hunspell_find(txt))
  if(ignore_names==T){
    bad_words <- bad_words[!((duplicated(bad_words) | duplicated(bad_words, fromLast = T)) & stringr::str_starts(bad_words, "[A-Z]"))]
  }
  replace_with <- sapply(bad_words, correct, sorted_words=word_list, threshold = threshold, ignore_punct = ignore_punct, USE.NAMES = F)
  to_replace <- sapply(seq_along(bad_words), function(i) {paste0("\\b", bad_words[i], "\\b")})
  clean_text <- textclean::mgsub_regex(txt, to_replace, replace_with)
  return(clean_text)
}

#' A simple function that requires a readtext object.
#' It then processes the text column using basic regex substitutions.
#' The default is to add a space before possessives and contractions.
#' This will force their tokenization in quanteda.
#' So that "Shakespeare's" will be counted as two tokens rather than a single one.
#' It is easy to add or delete subsitions as fits your analytical needs.
#' @param txt A character vector
#' @param contractions A logical value to separate contractions into two tokens
#' @param hypens A logical value to separate hypenated words into two tokens
#' @param punctuation A logical value to remove punctuation
#' @param lower_case A logical value to make all tokens lower case
#' @param accent_replace A logical value to replace accented characters with un-accented ones
#' @param letters_only A logical value to extract only letter sequences
#' @return A character vector
#' @export
correct <- function(word, sorted_words, ignore_punct=FALSE, threshold=.12) {
  is_upper <- stringr::str_starts(word, "[A-Z]")
  word <- tolower(word)
  if(ignore_punct==T){
    edit_dist <- suppressWarnings(stringdist::stringdist(stringr::str_remove_all(word, "[[:punct:]]"), stringr::str_remove_all(sorted_words, "[[:punct:]]"), method = "jw", p=.1))
  } else {
    edit_dist <- suppressWarnings(stringdist::stringdist(word, sorted_words, method = "jw", p=.1))
  }
  candidates <- sorted_words[edit_dist <= threshold]
  if(length(candidates)==0) candidates <- word
  candidates_idx <- which(edit_dist <= threshold)
  replacement_idx <- which.min(as.vector(scale(candidates_idx))*((1-edit_dist[edit_dist <= threshold])^2))
  replacement <- ifelse(length(candidates)==1, candidates, candidates[replacement_idx])
  replacement <- ifelse(is_upper==T, stringr::str_to_title(replacement), replacement)
  return(replacement)
}

