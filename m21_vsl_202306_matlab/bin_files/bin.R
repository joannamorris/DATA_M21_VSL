library(readr)
flist <- read_csv("filelist.txt",col_names = FALSE)
flist2 <- flist$X1

for (file in flist2) {
  read_csv(file)
  
}