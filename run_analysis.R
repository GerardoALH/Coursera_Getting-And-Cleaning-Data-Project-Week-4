

# Descompresión del archivo de información --------------------------------


unzip(zipfile="getdata_projectfiles_UCI HAR Dataset.zip",exdir="./data")


# Creación de fichero de trabajo

List_Docs <- list.files("./data/UCI HAR Dataset/")

pathdata <- file.path("./data/UCI HAR Dataset/")

Docs <- list.files(pathdata, recursive = TRUE)


# Invocación de bases de datos carpeta "train" y asignación a objetos

xtrain <-  read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain <-  read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train <-  read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)

# Invocación de datos de la carpeta "test" y asignación a objetos

xtest <- read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest <-  read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test <-  read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)


# Invoación de archivos de información y asignación a objetos

feature <-  read.table(file.path(pathdata, "features.txt"),header = FALSE)
activityLabels <-  read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

# Asignación de encabezados o nombres de variables

colnames(xtrain) <-  feature[,2]
colnames(ytrain) <-  "activityId"
colnames(subject_train) <-  "subjectId"

colnames(xtest) <-  feature[,2]
colnames(ytest) <-  "activityId"
colnames(subject_test) <-  "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

mrg_train <-  cbind(ytrain, subject_train, xtrain)
mrg_test <-  cbind(ytest, subject_test, xtest)


# Creación de bases de datos "train" y "test"

DS_train <-  cbind(ytrain, subject_train, xtrain)
DS_test <-  cbind(ytest, subject_test, xtest)

# Base de datos principal
DS_COMPLETO <-  rbind(mrg_train, mrg_test)


# Extracción de media y desviación estandar para cada medida ---------------------------------------------------

colNames <-  colnames(DS_COMPLETO)


mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

#Media_Y_DesEst = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))


setForMeanAndStd <- DS_COMPLETO[ , mean_and_std == TRUE]


#DS_PorMediaYDesEst <- DS_COMPLETO[ , Media_Y_DesEst == TRUE]


setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

View(setWithActivityNames)

# DS_AtivityNames <- merge(DS_PorMediaYDesEst, activityLabels, by='activityId', all.x=TRUE)




# Nuevo data set creado



secTidySet <- setWithActivityNames[order(secTidySet$subjectId, secTidySet$activityId),]


# Se escribe la salida de la nueva base de datos en formato de texto
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)







