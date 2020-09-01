

# Descompresión del archivo de información --------------------------------


unzip(zipfile="getdata_projectfiles_UCI HAR Dataset.zip",exdir="./midtermdata")


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


# Invoación de archivos de información

feature <-  read.table(file.path(pathdata, "features.txt"),header = FALSE)
activityLabels <-  read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

# Asignación de encabezados o nombres de variables

colnames(xtrain) <-  features[,2]
colnames(ytrain) <-  "activityId"
colnames(subject_train) <-  "subjectId"

colnames(xtest) <-  features[,2]
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



# Lectura de la variable

NombresCol <-  colnames(DS_COMPLETO)

# Creación de subgrupo de datos con todas las medias y desviaciones estandars correspondientes a activityvID y subjectID

mean_and_std <- (grepl("activityId" , NombresCol) | grepl("subjectId" , NombresCol) | grepl("mean.." , NombresCol) | grepl("std.." , NombresCol))

#A subtset has to be created to get the required dataset
MediaYDesEst <- DS_COMPLETO[ , mean_and_std == TRUE]


BD_Activity_Nombres <-  merge(MediaYDesEst, activityLabels, by='activityId', all.x=TRUE)


# New tidy set has to be created 

BD_TIDY <- aggregate(. ~subjectId + activityId, BD_Activity_Nombres, mean)
# secTidySet <- aggregate(. ~subjectId + activityId, BD_Activity_Nombres, mean)

BD_TIDY <- BD_TIDY[order(BD_TIDY$subjectId, BD_TIDY$activityId), ]

View(BD_TIDY)
