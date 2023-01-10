# To install the latest version from Github:
#install.packages("devtools")
#install.packages("sf")
#install.packages("tidyverse")
#install.packages("stars")
#install.packages("MetBrewer")
#install.packages("colorspace")
#install.packages("magick")
#library(devtools)

#remotes::install_github("tylermorganwall/rayrender")
#remotes::install_github("tylermorganwall/rayshader")


# Use the ray shader library
library(rayshader)
library(sf)
library(tidyverse)
library(stars)
library(MetBrewer)
library(colorspace)

# Load out geo data set
dataset <- st_read("R_Geographical_Mapping_Project/kontur_population_GB_20220630.gpkg")

# Define aspect ratio based on bounding box
bounding_box <- st_bbox(dataset)

# Bounding_box now gives us 4 values xmin ymin ymax xmax, which 
# allows us to calculate the aspect ratio of the width and height of the india data
# We need to convert the numbers (xmin, ymin etc) to point coordinates
# c() makes it a vector
bottom_left <- st_point(c(bounding_box[["xmin"]], bounding_box[["ymin"]])) |>
                        st_sfc(crs = st_crs(dataset))

bottom_right <- st_point(c(bounding_box[["xmax"]], bounding_box[["ymin"]])) |>
                        st_sfc(crs = st_crs(dataset))

# Calculate width using bottom left and right
width <- st_distance(bottom_left, bottom_right)

top_left <- st_point(c(bounding_box[["xmin"]], bounding_box[["ymax"]])) |>
                        st_sfc(crs = st_crs(dataset))

# Calculate height using bottom left and top left
height <- st_distance(bottom_left, top_left)

# Handle conditions of width or height being longer side
if(width > height) {
  w_ratio <- 1
  h_ratio <- height / width
} else {
  h_ratio <- 1
  w_ratio <- width / height
}

# Currently our data is in a spatial format coming form the geopackage however
# we want it in a matrix format, so we can take from a "raster" then to a matrix
# (a raster graphic represents a two-dimensional picture as a rectangular matrix or grid of square pixels)
size <- 1500

nx_value <- floor(size * w_ratio)
ny_value <- floor(size * h_ratio)

raster <- st_rasterize(dataset,
                       nx = 797,  # Had to hard code value  for nx/ny from above 2 nx/ny_value formulas
                       ny = 1500) # As it was giving a units are not convertible error

matrix <- matrix(raster$population, 
                 nrow = 797,
                 ncol = 1500)

# Plot the figure as 3D

# Create colour palette
c1 <- met.brewer("VanGogh3")
swatchplot(c1)

texture <- grDevices::colorRampPalette(c1, bias = 2)(256)
swatchplot(texture)

matrix |>
  height_shade(texture = texture) |>
  plot_3d(heightmap = matrix,
          zscale = 100 / 1.5,
          solid = FALSE,
          shadowdepth = 0)

# Adjust the rgl window for better view
render_camera(phi = 60, zoom = .8)

# Render plot in higher quality, and edit attributes such as lighting
outfile <- "R_Geographical_Mapping_Project/plot2.png"

if(!file.exists(outfile)){
  png::writePNG(matrix(1), target = outfile)
}

render_highquality(
  filename = outfile,
  lightdirection = 285,
  lightaltitude = c(20, 70),
  samples = 450,
  width = 2000,
  height = 2000,
  parallel = TRUE
)

















