library(magick)
library(MetBrewer)
library(colorspace)

##################
# For IN Plot #
##################

# Read in image, save to `img` object
img1 <- image_read("R_Geographical_Mapping_Project/India_Population_Plot.png")

# Adjust the color of text
c1 <- met.brewer("Benedictus")
swatchplot(c1)

text_color <- darken(c1[1], .25)

# Title
img_ <- image_annotate(img1, "A Portrait of", font = "Cinzel Decorative",
                       color = text_color, size = 35, gravity = "west",
                       location = "+295-755")

# Subtitle
img_ <- image_annotate(img_, "India Population Density", weight = 700, 
                       font = "Cinzel Decorative", location = "+0-700",
                       color = text_color, size = 55, gravity = "west")

# Caption
img_ <- image_annotate(img_, "Graphic by Mathews Joy | Data from www.kontur.io (Released June 30, 2022)", 
                       font = "Cinzel Decorative", location = "+0+50",
                       color = text_color, size = 25, gravity = "south")

image_write(img_, "R_Geographical_Mapping_Project/fully_IN_annotated.png")
                      

##################
# For GB Plot #
##################

# Read in image, save to `img` object
img1 <- image_read("R_Geographical_Mapping_Project/plot2.png")

# Adjust the color of text
c1 <- met.brewer("VanGogh3")
swatchplot(c1)

text_color <- darken(c1[4], .25)

# Title
img_ <- image_annotate(img1, "A Portrait of", font = "Cinzel Decorative",
                       color = text_color, size = 35, gravity = "north",
                       location = "+0+280")

# Subtitle
img_ <- image_annotate(img_, "Great Britain Population Density", weight = 700, 
                       font = "Cinzel Decorative",
                       color = text_color, size = 55, gravity = "north",
                       location = "+0+330")

# Caption
img_ <- image_annotate(img_, "Graphic by Mathews Joy | Data from www.kontur.io (Released June 30, 2022)", 
                       font = "Cinzel Decorative", location = "+0+50",
                       color = text_color, size = 25, gravity = "south")

image_write(img_, "R_Geographical_Mapping_Project/fully_GB_annotated.png")






