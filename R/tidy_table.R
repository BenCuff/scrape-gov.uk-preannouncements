#' GOV.UK statistics pre-announcements calendar scraping tool
#' 
#' Internal helper function for tidying up outputs. Does not need to be run by hand. 
#' @param df The table to tidy up
#' 
#' @importFrom magrittr `%>%` 
#' @importFrom stringr `str_replace`
#' 
#' @author Ben Cuff
 
tidy_up <- function(df){
  return(
    df %>% 
      str_replace(., "\n", "") %>% 
      str_replace(., "Document type: |Organisation: |Release date: |State: ", "") %>% 
      trimws()
  )
}