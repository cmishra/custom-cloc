library(stringr)
library(data.table)

filesDT <- data.table(fileName=c("test"), length=c(1))

countRecursive <- function(dir, suffix) {
  files <- list.files(dir, full.names=T)
  dirs <- files[file.info(files)$isdir]
  files <- files[!files %in% dirs]

  files <- files[str_detect(files, suffix)]
  
  filesDT <<- rbind(filesDT, rbindlist(lapply(files, function(file) {
    data.frame(fileName=file, length=length(readLines(file)))
  })), fill=T)
    
  if (length(dirs) > 0)  {
    for (d in dirs) {
      countRecursive(d, suffix)
    }
  }
}

setwd("C://Users/cheta_000/Dropbox/")
countRecursive(".", ".R$")
countRecursive(".", ".java$")
countRecursive(".", ".py$")

# deleting files i didn't write
filesDT[str_detect(fileName,
  "./College/3_Third Year/05_Fifth Semester/R Working Directory/3080_Lectures"),
  length:=0]
filesDT[str_detect(fileName,
  "./College/3_Third Year/05_Fifth Semester/R Working Directory/4021_lectures/"),
  length:=0]
filesDT[str_detect(fileName,
  "snowball|json|opennlp|django-downloadview-master"),
  length:=0]

filesDT[,"lang":=str_extract(fileName, "\\..{1,4}$")]
filesDT <- filesDT[length != 0]

filesDT[,sum(length), by=lang]
