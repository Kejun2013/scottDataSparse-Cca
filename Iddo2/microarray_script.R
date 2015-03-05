
#has normalization procedures
library(preprocessCore)

#get the names of the samples...
sample_names=read.table("~/Desktop/ChapkinLab/Iddo/Mead_Johnson/file_names.csv", stringsAsFactors=FALSE,sep=',',comment.char="#")$V1

#scratch: this is how we load a data set.
X=read.table("~/Desktop/ChapkinLab/Iddo/Mead_Johnson/Txt_files_of_all_pts/2008_T00340956_BF3.TXT", stringsAsFactors=FALSE,sep='\t',comment.char="#",quote='"',
skip=7,nrows=-1,header=TRUE)
X=X[c(1:4,16,21,27,32)]

names(X)
dim(X)

#scratch: it's the standard codelink normalization
use4normalize = (X$Quality_flag!='M') & (X$Probe_type=='DISCOVERY')
plot(X$VALUE[use4normalize],X$Raw_intensity[use4normalize]/median(X$Raw_intensity[use4normalize]))
abline(0,1)


#importing data: making the data set accessible
samples_RawVals = NULL 
samples_NormVals = NULL 
#samples_probeTypes = samples #actually, redundant: these should are constant across...
samples_flags = NULL
for(i in sample_names)
{
	sample = 
	read.table(
	paste("~/Desktop/ChapkinLab/Iddo/Mead_Johnson/Txt_files_of_all_pts/",i,sep=''), 
			stringsAsFactors=FALSE,sep='\t',comment.char="#",quote='"',
skip=7,nrows=-1,header=TRUE,fill=TRUE)
	#sample
	dim(sample)

#only 2:4 should vary between samples... the rest are fixed identifiers... let's hope 
	sample = 	sample[,c(1:4,16,21,27,32)]
	names(sample)=c("ID_REF", "Raw_intensity", "VALUE", "Quality_flag", "Probe_name",  "Annotation_NCBI_Acc", "Probe_type","Annotation_Pub_Probe_Targets")
#[1] "ID_REF"                       "Raw_intensity"               
#[3] "VALUE"                        "Quality_flag"                
#[5] "Probe_name"                   "Annotation_NCBI_Acc"         
#[7] "Probe_type"                   "Annotation_Pub_Probe_Targets"

	print(length(sample$Raw_intensity))
		
	samples_RawVals = cbind(samples_RawVals, sample$Raw_intensity) 
	samples_NormVals = cbind(samples_NormVals, sample$VALUE) 
	samples_flags = cbind(samples_flags, sample$Quality_flag)

	print(i)	
	
	sum(X$ID_REF==sample$ID_REF)	
	sum(X$Probe_name==sample$Probe_name)	
	sum(X$Annotation_NCBI_Acc==sample$Annotation_NCBI_Acc)
	sum(X$Probe_type==sample$Probe_type)	
	sum(X$Annotation_Pub_Probe_Targets==sample$Annotation_Pub_Probe_Targets)
}


samples_probeTypes = sample$Probe_type #actually, redundant: these are constant across samples since all are on the same chip.
samples_probeNames = sample$Probe_name #actually, redundant: these are constant across samples since all are on the same chip.
samples_NCBIanno = sample$Annotation_NCBI_acc #actually, redundant: these are constant across samples since all are on the same chip.
samples_ProbeInfo = sample$Annotation_Pub_Probe_Targets #actually, redundant: these are constant across samples since all are on the same chip.
samples_IDref = sample$ID_REF #actually, redundant: these are constant across samples since all are on the same chip.

samples_RawVals = data.frame(samples_RawVals)
samples_NormVals = data.frame(samples_NormVals)
samples_flags = data.frame(samples_flags)
names(samples_RawVals)= sample_names
names(samples_NormVals)= sample_names
names(samples_flags)= sample_names




boxplot(log(samples_RawVals,2))



