#pacotes necessários devem em outra maquina ser instalados
#install.packages(c("quanteda","pdftools","stringr","tm", dependencies = T)
library(pdftools)
library(stringr)
library(tm)


# coleta e organização dos atributos dos dados
lahurdcsv<-read.csv(file.choose(), sep = ",", header = T, encoding = "UTF-8")

url<-c(as.character(lahurdcsv$url))

nm<-as.character(lahurdcsv$titulo)

nm<-str_c(nm,".pdf")

setwd("C:/Users/kraia/Documents/lahurd/corpus")

download.file(url , nm, method = "libcurl", mode= "wb")

######################################################################


dest<-"C:/Users/kraia/Documents/lahurd/corpus"

myfiles <- list.files(path = dest, pattern = "pdf",  full.names = TRUE)


lapply(myfiles, function(i) system(paste('"C:/Users/kraia/Documents/lahurd/xpdf/bin64/pdftotext.exe"', paste0('"', i, '"')), wait = FALSE) )



mytxtfiles<- list.files(path = dest, pattern = "txt",  full.names = TRUE)


file.copy(mytxtfiles,"C:/Users/kraia/Documents/lahurd/corpustxt")

file.remove(mytxtfiles,"C:/Users/kraia/Documents/lahurd/corpus")


corpus2 = VCorpus(DirSource("C:/Users/kraia/Documents/lahurd/corpustxt", encoding = "latin1"),readerControl = list(reader=readPlain,language = "por"))

dest1 <- "C:/Users/kraia/Documents/lahurd/corpustxt"

mytxtfiles1<- list.files(path = dest1, pattern = "txt",  full.names = TRUE)

abstracts <- lapply(mytxtfiles1, function(i) {
  j <- paste0(scan(i, what = character()), collapse = " ")
  regmatches(j, gregexpr("(?<=Abstract).*?(?=keywords)", j, perl=TRUE))
})
Resumo <- lapply(mytxtfiles1, function(i) {
  j <- paste0(scan(i, what = character()), collapse = " ")
  regmatches(j, gregexpr("(?<=Resumo).*?(?=Palavras-chave)", j, perl=TRUE))
})

nomes<-list.files(path = dest1,pattern = "txt")

Resumo<- as.character(Resumo)

Resumo= gsub('list','',Resumo)

Resultadofinal<-data.frame(Resumo)

Resultadofinal[,"Id"]<-nomes

setwd("C:/Users/kraia/Documents/lahurd")

Abstracts<- as.character(abstracts)

Abstracts= gsub('list','',Abstracts)

Resultadofinal[,"abstracts"]<-Abstracts

write.table(Resultadofinal,file = "Resultado.csv",sep = "|", row.names = F,col.names = T)



