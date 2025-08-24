# spell.replacer

[![R-CMD-check](https://github.com/browndw/spell.replacer/workflows/R-CMD-check/badge.svg)](https://github.com/browndw/spell.replacer/actions)
[![Tests](https://github.com/browndw/spell.replacer/workflows/Tests/badge.svg)](https://github.com/browndw/spell.replacer/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/spell.replacer)](https://CRAN.R-project.org/package=spell.replacer)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/spell.replacer)](https://cran.r-project.org/package=spell.replacer)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

**spell.replacer** provides fast probabilistic spelling correction for character vectors in R. This package automatically replaces misspelled words based on their string distance from a frequency-ordered word list derived from the Corpus of Contemporary American English (COCA).

The package is inspired by [Peter Norvig's classic probabilistic spell checker](https://norvig.com/spell-correct.html), but adapted for R with some key differences in implementation and optimization for speed over perfect accuracy.

## Key Features

- **Fast correction**: Optimized for speed, trading some accuracy for performance
- **Probabilistic approach**: Uses frequency-based word rankings from COCA
- **Flexible thresholds**: Adjustable string distance thresholds for correction sensitivity
- **Proper name handling**: Option to ignore potential proper names (capitalized repeated words)
- **Punctuation handling**: Option to ignore punctuation when calculating string distances

## Important Limitations

⚠️ **American English bias**: Since the word list is based on COCA (Corpus of Contemporary American English), the package will convert spellings to American English variants (e.g., "colour" → "color", "realise" → "realize").

⚠️ **Speed vs. Accuracy trade-off**: This package prioritizes speed over perfect accuracy. For applications requiring maximum accuracy, consider more sophisticated spell checkers.

## Installation

### From CRAN (when available)
```r
install.packages("spell.replacer")
```

### Development version from GitHub
```r
# install.packages("devtools")
devtools::install_github("browndw/spell.replacer")
```

## Quick Start

```r
library(spell.replacer)

# Basic spelling correction
text <- "The quik brown fox jumps over the lasy dog."
corrected <- spell_replace(text)
print(corrected)
#> "The quick brown fox jumps over the lazy dog."

# Correct individual words
correct("recieve", coca_list)
#> "receive"

# More examples
examples <- c(
  "This is a tesst of the speling correcter.",
  "The algorithim should work wel on diferent sentances."
)
spell_replace(examples)
```

## Usage

### Basic Correction

```r
spell_replace(text, 
              word_list = coca_list,     # Default word list from COCA
              ignore_names = TRUE,       # Ignore potential proper names
              threshold = 0.12,          # String distance threshold
              ignore_punct = FALSE)      # Consider punctuation in distance
```

### Parameter Tuning

```r
# More conservative correction (higher accuracy, fewer corrections)
conservative <- spell_replace(text, threshold = 0.08)

# More aggressive correction (lower accuracy, more corrections)
aggressive <- spell_replace(text, threshold = 0.20)

# Ignore punctuation when calculating string distance
spell_replace("can't", ignore_punct = TRUE)
```

### Custom Word Lists

```r
# Use your own word list (must be frequency-ordered)
custom_words <- c("hello", "world", "custom", "words")
spell_replace("helo wrld", word_list = custom_words)
```

## How It Works

The spell correction algorithm:

1. **Identifies potential misspellings** using `hunspell`
2. **Filters proper names** (optional, based on capitalization patterns)
3. **Calculates string distances** using Jaro-Winkler distance
4. **Finds candidates** within the specified threshold
5. **Ranks candidates** by frequency (position in COCA list) and string distance
6. **Selects best correction** using a weighted scoring system

This approach builds on Peter Norvig's probabilistic spell checker but differs in:
- Using Jaro-Winkler instead of edit distance
- Incorporating corpus frequency directly in ranking
- Adding options for proper name and punctuation handling
- Optimizing for batch processing of text vectors

## Relationship to Peter Norvig's Work

This package is inspired by [Peter Norvig's "How to Write a Spelling Corrector"](https://norvig.com/spell-correct.html), which demonstrates a simple but effective probabilistic approach to spell checking. Key similarities and differences:

### Similarities
- **Probabilistic approach**: Both use word frequency to inform corrections
- **Edit distance concept**: Both consider similarity between misspelled and candidate words
- **Simple and fast**: Both prioritize simplicity and speed

### Differences
- **String distance metric**: Uses Jaro-Winkler instead of simple edit distance
- **Language/Platform**: R implementation vs. Python
- **Corpus**: Uses COCA frequency data vs. other corpora
- **Batch processing**: Optimized for processing multiple texts at once
- **Additional features**: Proper name handling, punctuation options, etc.

## Data Source

The default word list (`coca_list`) contains the 100,000 most frequent words from the [Corpus of Contemporary American English (COCA)](https://www.english-corpora.org/coca/), sorted by frequency. COCA is a large, balanced corpus of American English containing over one billion words from 1990-2019.

## Performance

The package is optimized for speed:
- Vectorized operations where possible
- Efficient string distance calculations
- Pre-sorted frequency lists for fast ranking

Typical performance: ~1000 words corrected per second (varies by text complexity and hardware).

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests on [GitHub](https://github.com/browndw/spell.replacer).

## License

This package is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Citation

If you use this package in your research, please cite:

```r
citation("spell.replacer")
```

## Related Packages

- **hunspell**: More accurate but slower spell checking
- **textclean**: General text cleaning and preprocessing
- **spelling**: Another R spell checking package with different trade-offs
