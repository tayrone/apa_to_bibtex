library(tidyverse)
library(RefManageR)

refs <- tibble(reference = read_lines("references_apa.txt")) %>% 
  filter(reference != "")

refs <- refs %>% 
  mutate(doi = str_extract(reference, "doi.*$"),
         doi = str_remove(doi, "doi: "),
         doi = str_remove(doi, "doi.org"),
         doi = str_remove(doi, "doi"),
         doi = word(doi, 1),
         doi = str_remove(doi, "\\.$"))

bibs <- refs %>% 
  #drop_na() %>% 
  pull(doi) %>% 
  GetBibEntryWithDOI()

bibtex <- toBibtex(bibs)

conn <- file("bibtex.txt")
writeLines(bibtex, conn)
close(conn)

# In the and, manually add any bibtex information for references not previously 
# found by the package.