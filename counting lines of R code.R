library(stringr)
library(data.table)

filesDT <- data.table(fileName=c("test"), length=c(1))

countRecursive <- function(dir, suffix) {
  files <- list.files(dir, full.names=T)
  dirs <- files[file.info(files)$isdir]
  files <- files[!files %in% dirs]

  files <- files[str_detect(files, suffix)]
  
  filesDT <<- rbind(filesDT, rbindlist(lapply(files, function(file) {
    fileLines <- readLines(file)
    fileLines <- fileLines[!str_trim(fileLines) == ""]
    data.frame(fileName=file, length=length(fileLines))
    
  })), fill=T)
    
  if (length(dirs) > 0)  {
    for (d in dirs) {
      countRecursive(d, suffix)
    }
  }
}

setwd("C://Users/cheta_000/Dropbox/")
countRecursive(".", "\\.R$|\\.java$|\\.py$|\\.cpp$|\\.h$")

# deleting files in subdirectories i didn't write
filesDT[str_detect(fileName,
  "3080_Lectures|4021_lectures|old django|conflicted copy|hlda-cpp2|lda-c-dist|plda"),
  length:=0]
filesDT[str_detect(fileName,
  "snowball|json|opennlp|django-downloadview-master|pdr|google|tango_w_django"),
  length:=0]

filesDT[,"lang":=str_extract(fileName, "\\..{1,4}$")]
filesDT <- filesDT[length != 0]

filesDT[,sum(length), by=lang]
