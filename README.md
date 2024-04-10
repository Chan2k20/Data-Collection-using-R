Project Title: Data Collection using R

Description/Problem Statement:
The project involved developing two scripts: Scrapping.R and After.R, for comprehensive data collection from the Mobile DNA journal. The Scrapping.R script utilizes various R packages such as stringr, xml2, XML, writexl, and rvest to retrieve article information, including title, authors, affiliations, publication date, abstract, keywords, and more, from Mobile DNA articles for a specified year. The collected data is then organized into a dataframe and exported to both a plain text file (Summary.txt) and an Excel file (summary.xlsx), excluding full-text due to character limitations.

Skills Utilized:
- Data Scraping
- R Programming
- Data Manipulation
- Package Management (stringr, xml2, XML, writexl, rvest)

Solution:
- The Scrapping.R script first retrieves the URLs for all articles published in Mobile DNA for a specified year provided by the user.
- It then crawls each URL to extract relevant information about each article, such as title, authors, affiliations, publication date, abstract, and keywords.
- The collected data is structured into a dataframe and exported to a plain text file (Summary.txt) and an Excel file (summary.xlsx), omitting the full-text due to Excel's character limit.
- To collect data for multiple years, the After.R script interacts with the user, prompting for an input year. It then iterates through all years from the input year to 2020, calling Scrapping.R for each year.
- Upon completion, Summary.txt contains comprehensive information for all Mobile DNA articles published in and after the input year.
