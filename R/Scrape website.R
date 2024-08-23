#' GOV.UK statistics pre-announcements calendar scraping tool
#' 
#' Function to scrape information from the pre-announcements calendar, exporting this information into a useful spreadsheet
#' @param org The organisation that you wish to get pre-announcements for. This must be in the same format that the organisation appears in the URL of the pre-announcements page (https://www.gov.uk/search/research-and-statistics), when the organisation is selected as a filter. For example, "uk-health-security-agency".
#' 
#' @return A .csv file, saved to your working directory.
#' 
#' @importFrom magrittr `%>%` 
#' @import rvest
#' 
#' @author Ben Cuff
 

#' @export
scrape_preannouncements <- function(org = NA){
  
  #Stop if no org is given
  if(is.na(org)){
    stop("You must provide a valid organisation string.\nThis must be in the same format that the organisation appears in the URL of the pre-announcements page (https://www.gov.uk/search/research-and-statistics), when the organisation is selected as a filter. For example, 'uk-health-security-agency'.")
  }
  
  #Set URL for org
  string <- paste0("https://www.gov.uk/search/research-and-statistics?content_store_document_type=upcoming_statistics&order=release-date-oldest&organisations%5B%5D=",
                   org)
  
  #Set up empty dataframe for the output
  output <- data.frame(Title = as.character(),
                       URL = as.character(),
                       Type = as.character(),
                       Organisation = as.character(),
                       Date = as.character(),
                       Time = as.character(),
                       Status = as.character())
  
  i <- 1 #start the loop on page 1
  results <- 0 #monitor how many results are returned on each page
  
  
  #This will loop through pages until zero results are returned (i.e., the end of the list) 
  repeat{
    
    #Set URL of page to scrape (i is used for page number)
    page <- read_html(paste0(string, "&page=", i))
    
    #Check number of items to see if a result will be returned
    items <- html_nodes(page, '.gem-c-document-list__item')
    results <- length(unlist(items))
    if(results == 0){
      stop("You must provide a valid organisation string.\nThis must be in the same format that the organisation appears in the URL of the pre-announcements page (https://www.gov.uk/search/research-and-statistics), when the organisation is selected as a filter. For example, 'uk-health-security-agency'.")
    }
    
    
    #Get titles
    titles <- page %>% html_nodes(".gem-c-document-list__item-title a") %>% html_text() %>% tidy_up()
    
    #Get URLs
    urls <- page %>% html_nodes(".gem-c-document-list__item-title a") %>% html_attr("href") %>% tidy_up() %>% paste0("https://www.gov.uk", .)
    
    #Get descriptions
    descriptions <- page %>% html_nodes(".gem-c-document-list__item p") %>% html_text() %>% tidy_up()
    
    #Get types
    types <- page %>% html_nodes(".gem-c-document-list__item ul li:nth-child(1)") %>% html_text() %>% tidy_up()
    
    #Get orgs
    orgs <- page %>% html_nodes(".gem-c-document-list__item ul li:nth-child(2)") %>% html_text() %>% tidy_up()
    
    #Get dates
    dates <- page %>% html_nodes(".gem-c-document-list__item ul li:nth-child(3)") %>% html_text() %>% tidy_up() %>% str_replace_all(., " \\d{1,2}:\\d{2}[a|p]m$", "") 
    
    #Get times
    times <- page %>% html_nodes(".gem-c-document-list__item ul li:nth-child(3)") %>% html_text() %>% tidy_up() %>% str_replace_all(., ".* ", "")
    
    #Get statuses
    statuses <- page %>% html_nodes(".gem-c-document-list__item ul li:nth-child(4)") %>% html_text() %>% tidy_up()
    
    
    #Bind outputs for this page into the master list
    output <- rbind(output,
                    data.frame(Title = titles,
                               URL = urls,
                               Type = types,
                               Organisation = orgs,
                               Date = dates,
                               Time = times,
                               Status = statuses))
    
    
    #Print confirmation message and move to next page
    print(paste("Done page", i))
    i <- i+1 
    
  }
  
  #Create list
  list <- output
  
  #If you wish to filter by date:
  #If uncommenting this, you will need to add lubridate to the list of imports
  # today <- Sys.Date()
  # date_to_include <- today+days(7) #set number of days in future you want to include
  # 
  # Filtered_list <- list %>% 
  #   mutate(Date = dmy(Date)) %>%  
  #   #You will get messages here that some have failed to parse. 
  #   #That's due to future provisional dates not being in a standard date format.
  #   #Shouldn't be an issue as everything should be confirmed within 28 days of release.
  #   filter(Date <= date_to_include)
  
  #Save csv output
  write.csv(list, paste0("release_calendar_", org, Sys.Date(), ".csv"), row.names = F)
  
  #Save markdown output
  # text <- ""
  # 
  # for(i in 1:nrow(list)){
  #   text <- paste(text, "|", list[i, 'Date'], "|", list[i, 'Title'], "|", "\n")
  # }
  # 
  # cat(text, file="markdown.txt")
}