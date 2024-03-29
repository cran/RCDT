% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{plotDelaunay}
\alias{plotDelaunay}
\title{Plot 2D Delaunay triangulation}
\usage{
plotDelaunay(
  del,
  col_edges = "black",
  col_borders = "red",
  col_constraints = "green",
  fillcolor = "random",
  distinctArgs = list(seedcolors = c("#ff0000", "#00ff00", "#0000ff")),
  randomArgs = list(hue = "random", luminosity = "dark"),
  lty_edges = par("lty"),
  lwd_edges = par("lwd"),
  lty_borders = par("lty"),
  lwd_borders = par("lwd"),
  lty_constraints = par("lty"),
  lwd_constraints = par("lwd"),
  ...
)
}
\arguments{
\item{del}{an output of \code{\link{delaunay}} without constraints 
(\code{edges=NULL}) or with constraints}

\item{col_edges}{the color of the edges of the triangles which are not
border edges nor constraint edges; \code{NULL} for no color}

\item{col_borders}{the color of the border edges; note that the border
edges can contain the constraint edges for a constrained
Delaunay triangulation; \code{NULL} for no color}

\item{col_constraints}{for a constrained Delaunay triangulation, the color
of the constraint edges which are not border edges;
\code{NULL} for no color}

\item{fillcolor}{controls the filling colors of the triangles, either
\code{NULL} for no color, a single color, \code{"random"} to get multiple
colors with \code{\link[colorsGen]{randomColor}}, \code{"distinct"}
get multiple colors with \code{\link[Polychrome]{createPalette}}, 
or a vector of colors, one color for each triangle; in this case the 
the colors will be assigned in the order they are provided but after the 
triangles have been circularly ordered (see the last example)}

\item{distinctArgs}{if \code{fillcolor = "distinct"}, a list of arguments
passed to \code{\link[Polychrome]{createPalette}}}

\item{randomArgs}{if \code{fillcolor = "random"}, a list of arguments passed
to \code{\link[colorsGen]{randomColor}}}

\item{lty_edges, lwd_edges}{graphical parameters for the edges which are not
border edges nor constraint edges}

\item{lty_borders, lwd_borders}{graphical parameters for the border edges}

\item{lty_constraints, lwd_constraints}{in the case of a constrained Delaunay
triangulation, graphical parameters for the constraint edges which are
not border edges}

\item{...}{arguments passed to \code{\link{plot}} for the vertices, such as
\code{type="n"}, \code{asp=1}, \code{axes=FALSE}, etc}
}
\value{
No value, just renders a 2D plot.
}
\description{
Plot a constrained or unconstrained 2D Delaunay triangulation.
}
\examples{
library(RCDT)
# random points in a square ####
square <- rbind(
  c(-1, 1), c(1, 1), c(1, -1), c(-1, -1)
)
library(uniformly)
set.seed(314)
pts_in_square <- runif_in_cube(10L, d = 2L)
pts <- rbind(square, pts_in_square)
d <- delaunay(pts)
opar <- par(mar = c(0, 0, 0, 0))
plotDelaunay(
  d, type = "n", xlab = NA, ylab = NA, axes = FALSE, asp = 1, 
  fillcolor = "random", lwd_borders = 3
)
par(opar)

# a constrained Delaunay triangulation: pentagram ####
# vertices
R <- sqrt((5-sqrt(5))/10)     # outer circumradius
r <- sqrt((25-11*sqrt(5))/10) # circumradius of the inner pentagon
k <- pi/180 # factor to convert degrees to radians
X <- R * vapply(0L:4L, function(i) cos(k * (90+72*i)), numeric(1L))
Y <- R * vapply(0L:4L, function(i) sin(k * (90+72*i)), numeric(1L))
x <- r * vapply(0L:4L, function(i) cos(k * (126+72*i)), numeric(1L))
y <- r * vapply(0L:4L, function(i) sin(k * (126+72*i)), numeric(1L))
vertices <- rbind(
  c(X[1L], Y[1L]),
  c(x[1L], y[1L]),
  c(X[2L], Y[2L]),
  c(x[2L], y[2L]),
  c(X[3L], Y[3L]),
  c(x[3L], y[3L]),
  c(X[4L], Y[4L]),
  c(x[4L], y[4L]),
  c(X[5L], Y[5L]),
  c(x[5L], y[5L])
)
# constraint edge indices (= boundary)
edges <- cbind(1L:10L, c(2L:10L, 1L))
# constrained Delaunay triangulation
del <- delaunay(vertices, edges)
# plot
opar <- par(mar = c(0, 0, 0, 0))
plotDelaunay(
  del, type = "n", asp = 1, fillcolor = "distinct", lwd_borders = 3,
  xlab = NA, ylab = NA, axes = FALSE
)
par(opar)
# interactive plot with 'rgl'
mesh <- del[["mesh"]]
library(rgl)
open3d(windowRect = c(100, 100, 612, 612))
shade3d(mesh, color = "red", specular = "orangered")
wire3d(mesh, color = "black", lwd = 3, specular = "black")
# plot only the border edges - we could find them in `del[["edges"]]` 
  # but we use the 'rgl' function `getBoundary3d` instead
open3d(windowRect = c(100, 100, 612, 612))
shade3d(mesh, color = "darkred", specular = "firebrick")
shade3d(getBoundary3d(mesh), lwd = 3)

# an example where `fillcolor` is a vector of colors ####
n <- 50L # number of sides of the outer polygon
angles1 <- head(seq(0, 2*pi, length.out = n + 1L), -1L)
outer_points <- cbind(cos(angles1), sin(angles1))
m <- 5L # number of sides of the inner polygon
angles2 <- head(seq(0, 2*pi, length.out = m + 1L), -1L)
phi <- (1+sqrt(5))/2 # the ratio  2-phi  will yield a perfect pentagram
inner_points <- (2-phi) * cbind(cos(angles2), sin(angles2))
points <- rbind(outer_points, inner_points)
# constraint edges
indices <- 1L:n
edges_outer <- cbind(indices, c(indices[-1L], indices[1L]))
indices <- n + 1L:m
edges_inner <- cbind(indices, c(indices[-1L], indices[1L]))
edges <- rbind(edges_outer, edges_inner)
# constrained Delaunay triangulation
del <- delaunay(points, edges) 
# there are 55 triangles:
del[["mesh"]]
# we make a cyclic palette of colors:
colors <- viridisLite::turbo(28)
colors <- c(colors, rev(colors[-1L]))
# plot
opar <- par(mar = c(0, 0, 0, 0))
plotDelaunay(
  del, type = "n", asp = 1, lwd_borders = 3, col_borders = "black", 
  fillcolor = colors, col_edges = "black", lwd_edges = 1.5, 
  axes = FALSE, xlab = NA, ylab = NA
)
par(opar)
}
\seealso{
The \code{mesh} field in the output of \code{\link{delaunay}} 
  for an interactive plot. Other examples of \code{plotDelaunay} are given 
  in the examples of \code{\link{delaunay}}.
}
