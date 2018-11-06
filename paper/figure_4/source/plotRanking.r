library("plyr")
library("calibrate")
library("scales")
library("graphics")
library("RColorBrewer")
library("data.table")

color_palett= brewer.pal(11,"RdYlGn")[c(1,4,8,11)]

options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) 

salmonella_path="/project/owlmayerTemporary/Bressin/Salmonella/feature_importance/Result/feature_weights/feature_weights_590_train.txt"
human_path="/project/owlmayerTemporary/Bressin/Salmonella/feature_importance/Result/feature_weights/feature_weights_9606_train.txt"
conservedKmer_path = "/project/salmonella/kmer_enriched_human.txt"

salmonella_path = args[1]
human_path = args[2]
conservedKmer_path = args[3]
out = args[4]

human = read.table(human_path, header = T, stringsAsFactors = F)
salmonella = read.table(salmonella_path, header=T, stringsAsFactors = F)

table = merge(salmonella, human, all = T)
table[is.na(table)] = 0

conservedKmer = read.table(conservedKmer_path,colClasses = c("character"))

names = colnames(table)
names[!(colnames(table) %in% conservedKmer[,1])]=""
indexConservedKmer = colnames(table) %in% conservedKmer[,1]

xrange = 1.5
yrange = 2

pdf(out3)
smoothScatter(table[1,],table[2,], xlim=c(-xrange,+xrange), ylim=c(-yrange,+yrange),
              xlab="Salmonella", nbin = 200,
              ylab="Human", colramp = colorRampPalette(c("white", "gray30")),
              nrpoints=0, pch= 20)
abline(h=0)
abline(v=0)
lines(table[1,conservedKmer[,1]], t="p", pch=17, cex = 1,
      table[2,indexConservedKmer], col="red")
textxy(table[1,conservedKmer[,1]],table[2,conservedKmer[,1]],
       conservedKmer[,1],cex=1)
dev.off()
