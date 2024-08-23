# scrapeR

This package contains a function that can be used to scrape the information from the [gov.uk pre-announcements pages for official statistics](https://www.gov.uk/search/research-and-statistics?content_store_document_type=upcoming_statistics&organisations%5B%5D=uk-health-security-agency&order=updated-newest).

Call the function using `scrapeR::scrape_preannouncements("uk-health-security-agency")`. 
For preannouncement calendars of a different organisation, follow the link above, change the filter to the organsation you want, and replace the `org` parameter with however the organisation is presented in the page URL. It will usually be in the format of the organisation name, with each word separated by a hyphen. 

## Installation

To install this package, use: 

```
devtools::install_github("BenCuff/scrape-gov.uk-preannouncements")
```
