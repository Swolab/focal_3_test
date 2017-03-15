##############################################
# Code author: Erin Stearns
# Code objective: Develop functions for each chunk to streamline code
# Date: 2.7.17
#############################################



# figuring out if autonum_ref unique in site data and if corresponds to record_id in jorge's data -------------------------------

uniref <- unique(gahi_prev, by="Autonum_ref") #2914, so truly unique
unirec <- unique(test1, by="Record_ID") #3283 rows in test1, 2911 unique record ids

#testing if 2 vars above refer to same rows
uniref <- uniref[, c(1:4, 20:21, 28, 41:51, 59)]
unirec <- unirec[,c(1:6, 17:18, 23, 28:29,35:37, 45)]

colnames <- list(names(unirec))
for (col in colnames) {
  colnew <- paste0(col, "_jorge")
}

names(unirec) <- colnew

test7 <- merge(uniref, unirec, by.x = "Autonum_ref", by.y = "Record_ID_jorge", all = TRUE) #all = true important, 3450 rows, 2375 rows if do not specify all=true
#found 2914 that appear to have matched, remaining pertain to jorge
#Confirmed that 'Autonum_ref'(site) and 'Record_ID'(Jorge) do correspond to one another


# Creating var to establish diagnostic used ------------------------------------------------------------------------------------------------------------------------------------

#first need to re-create dx terms
j_dx <- jorge_simpl

j_dx <- as.data.table(j_dx)

mfMethods <- c("Blood smear", "Filtration", "PCR", "Chamber", "Knott")
j_dx[Method_2 %in% mfMethods, dx:='mf']
j_dx[Method_2 %in% "Brugia Rapid", dx:='BR']
j_dx[Method_2 %in% "ICT", dx:='ICT']
j_dx[Method_2 %in% "ELISA", dx:= "ELISA"]
j_dx[is.na(Method_2), dx:="unknown"]