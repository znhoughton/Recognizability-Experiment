args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Usage: Rscript fix_ampersands.R <input.bib> [output.bib]")
}

input_bib <- args[1]
output_bib <- ifelse(length(args) >= 2, args[2], input_bib)

# Read the .bib file
bib_lines <- readLines(input_bib, warn = FALSE)

# Escape & except in lines with url =
bib_escaped <- ifelse(
  grepl("url\\s*=", bib_lines, ignore.case = TRUE),
  bib_lines,
  gsub("&", "\\\\&", bib_lines)
)

# Write to output file
writeLines(bib_escaped, output_bib)

cat("✅ Escaped ampersands in:", output_bib, "\n")
