
## Create the network using NLP in python

install.packages("igraph")
library("igraph")

## Load the csv file created using NLP from interview data

data <- as.matrix(read.csv("final_matrix.csv",row.names = 1))

attributes <- read.csv("updated_attributes_famiy.csv")


diag(data) <- NA


graphMatrix <- graph.adjacency(data, mode="undirected",
                            weighted=NULL, diag=FALSE)
graphMatrix

graphMatrixFamily <- graph.adjacency(data, mode="undirected",
                            weighted=NULL, diag=FALSE)
graphMatrixFamily

between <- betweenness(graphMatrix)
between

eig_centrality <- evcent(graphMatrix)
eig_centrality


V(graphMatrix)$country=as.character(attributes$birthplace_country[match(V(graphMatrix)$name,attributes$full)])

V(graphMatrix)$color <- V(graphMatrix)$country
V(graphMatrix)$color <- gsub("USA", 'red', V(graphMatrix)$color)
V(graphMatrix)$color <- gsub("Canada", 'blue', V(graphMatrix)$color)
V(graphMatrix)$color <- gsub("Greece", "green", V(graphMatrix)$color)

V(graphMatrixFamily)$country=as.character(attributes$parents_country[match(V(graphMatrixFamily)$name,attributes$full)])

V(graphMatrixFamily)$color <- V(graphMatrixFamily)$country
V(graphMatrixFamily)$color <- gsub("USA", 'red', V(graphMatrixFamily)$color)
V(graphMatrixFamily)$color <- gsub("Canada", 'blue', V(graphMatrixFamily)$color)
V(graphMatrixFamily)$color <- gsub("Greece", "green", V(graphMatrixFamily)$color)

png(file="national.png", width=1500, height=1500, res=300)
plot.igraph(graphMatrix, layout=layout.fruchterman.reingold, 
            edge.width = .25,
            vertex.size = 4,
            vertex.label=V(graphMatrix)$name, 
            vertex.label.cex = .25,
            asp = 0
            )
legend("topleft", 
       legend = c("USA", "Canada", "Greece"),
       xpd=TRUE,
       cex = 0.75,
       col = c("red", "blue", "green"),
       pch = 15)
dev.off()

png(file="familyCountry.png", width=1500, height=1500, res=300)
plot.igraph(graphMatrixFamily, layout=layout.fruchterman.reingold, 
            edge.width = .25,
            vertex.size = 4,
            vertex.label=V(graphMatrixFamily)$name, 
            vertex.label.cex = .25,
            asp = 0
            )
legend("topleft", 
       legend = c("USA", "Canada", "Greece"),
       xpd=TRUE,
       cex = 0.45,
       col = c("red", "blue", "green"),
       pch = 15)
dev.off()
