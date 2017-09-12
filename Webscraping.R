# 1. For URLs that have multiple links within the page:
#Eg.: http://www.gesundheit-in-fuerth.de/eintraege/optionen/aenf-mitglied.html
#Download the free chrome extension “Linkclump”. This has options like opening all the links within a page into new tabs/new windows/copying the URLs on clipboard. I formed a column of URLs in an excel sheet and then imported it into R.
#R code for reading, scraping and partly cleaning the data. Example code for extracting Telephone no. and Fax no.
library(xlsx)
a<-read.xlsx2(file="D:/Users/preethi.ra/Desktop/domain/projects/German/rough.xlsx", sheetIndex=3, header=TRUE)
library(rvest)
#Run the function to save it
webscrape<-function(sourcepage,node){
  src<-read_html(sourcepage)
  src %>%
    html_node(node) %>%
    html_text() %>%
    as.character()
}
a$URLs<-as.character(a$URLs)
#sourcepage= our URL, node= css selector
# here .d is the node in which Tel no. and fax no. is present
a$ph<-sapply(a$URLs, function(x) {webscrape(x,".d")})
a$tel<-sapply(strsplit(a$ph, "Fax: "), "[", 1)
a$fax<-sapply(strsplit(a$ph, "Fax: "), "[", 2)
a$tel<-sapply(strsplit(a$tel,"Tel.: "),"[",2)
write.csv(a,file="D:/Users/preethi.ra/Desktop/domain/projects/German/tel.csv", row.names = F)
#Download chrome extension “Selectorgadget”. This helps us in identifying the html node in which our data is present.
#Further cleaning can be done in Excel using commands such as “Find and replace”, Substitute function, etc.
#2. For URLs that have the data on the page itself:
#Eg.: http://aengie.net/mitgliedschaft/aengie-mitglieder/
#R code for extracting and partially cleaning
doc<-read_html("http://aengie.net/mitgliedschaft/aengie-mitglieder/")
#two vectors are formed with all details in one separated by \n and speciality in another
a<-doc %>%
  html_nodes(".column-1") %>%
  html_text()
b<-doc %>%
  html_nodes(".column-2") %>%
  html_text()
doc<-data.frame(Details=a,Speciality=b)
doc<-doc[-1,]
write.csv(doc,file="D:/Users/preethi.ra/Desktop/domain/projects/German/link.csv",row.names=F)
doc$Details1<-gsub("\n"," | ", doc$Details)
#Excel’s text to columns functionality and flash fill can be used for the rest of the cleaning process.
