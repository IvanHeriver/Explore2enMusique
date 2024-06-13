# required packages
# dplyr, tidyr, ggplot2,
# patchwork, gganimate,
# av, sequenceR, qrcode,
# lubridate, extrafont,
# stringr

# required functions
source("./src/f.R")

# Loading sound samples (lists of sequenceR soundSample objects)
instruments_dir <- file.path("data", "instruments")
load(file.path(instruments_dir, "bassStandup.RData"), verbose = TRUE)
load(file.path(instruments_dir, "pianoSteinway.RData"), verbose = TRUE)
load(file.path(instruments_dir, "drumkitStahl.RData"), verbose = TRUE)
load(file.path(instruments_dir, "hangDrum.RData"), verbose = TRUE)

# Making some necessary font available
extrafont::font_import(pattern = "timesi", prompt = FALSE)
extrafont::loadfonts(device = "win")

catchment_info <- read.table(file.path("data", "bv_info.txt"), header = TRUE, sep = ";", quote = "")

chain_piece_regex <- "[A-Za-z0-9-]+"

data_files <- list.files(
  file.path("data", "discharge"),
  pattern = sprintf(
    "^data_QM_%s_%s_%s_%s_%s_%s.csv$",
    chain_piece_regex,
    chain_piece_regex,
    chain_piece_regex,
    chain_piece_regex,
    chain_piece_regex,
    chain_piece_regex
  )
)

data_files <- stringr::str_match(data_files, sprintf(
  "^data_QM_(%s)_(%s)_(%s)_(%s)_(%s)_(%s).csv$",
  chain_piece_regex,
  chain_piece_regex,
  chain_piece_regex,
  chain_piece_regex,
  chain_piece_regex,
  chain_piece_regex
))


for (k in seq_len(nrow(data_files))) {
  code <- data_files[k, 2]
  title <- catchment_info$Nom[catchment_info$Code == code]
  subtitle <- sprintf(
    "(%s | %s | %s | %s | %s)",
    data_files[k, 3],
    data_files[k, 4],
    data_files[k, 5],
    data_files[k, 6],
    data_files[k, 7]
  )
  data_path <- file.path("data", "discharge", data_files[k, 1])
  folder <- sprintf(
    "%s__%s_%s_%s_%s_%s",
    code,
    data_files[k, 3],
    data_files[k, 4],
    data_files[k, 5],
    data_files[k, 6],
    data_files[k, 7]
  )
  processDatasetIntoMusicAndVideo(
    folder,
    title,
    subtitle,
    data_path,
    pos_inst = pianoSteinway,
    neg_inst = hangDrum,
    bass_inst = bassStandup,
    drum_inst = drumkitStahl,
    bpm = 90,
    style = "oriental",
    memory = 10,
    end = 20,
    res_factor = 1
  )
}

# Load necessary library
library(tools)

# Set paths
input_folder <- "path/to/your/videos"
overlay_image <- "path/to/your/overlay.png"
output_folder <- "path/to/output/folder"

# Create the output folder if it doesn't exist
if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

# List all MP4 files in the input folder
video_files <- list.files(input_folder, pattern = "\\.mp4$", full.names = TRUE)

# Function to add overlay to a single video
add_overlay <- function(video_file, overlay_image, output_folder) {
  # Get the filename without extension
  filename <- file_path_sans_ext(basename(video_file))

  # Define the output file path
  output_file <- file.path(output_folder, paste0(filename, "_with_overlay.mp4"))

  # Build the FFmpeg command
  command <- "ffmpeg"
  args <- c(
    "-i", shQuote(video_file),
    "-i", shQuote(overlay_image),
    "-filter_complex", "overlay=W-w-10:H-h-10",
    "-codec:a", "copy",
    shQuote(output_file)
  )

  # Run the command
  system2(command, args)
}

# Process each video file
for (video_file in video_files) {
  add_overlay(video_file, overlay_image, output_folder)
}

cat("All videos processed successfully!\n")


# title <- "LA SEINE A POSES [APRES CREATION GRANDS LACS]"
# name <- "H322011003"

# processDatasetIntoMusicAndVideo(
#   name,
#   title,
#   data_path,
#   pos_inst = pianoSteinway,
#   neg_inst = handDrum,
#   bass_inst = bassStandup,
#   drum_inst = drumkitStahl,
#   bpm = 90,
#   style = "oriental",
#   memory = 10,
#   end = 20,
#   res_factor = 1
# )


# pos_inst <- pianoSteinway
# neg_inst <- hangDrum
# bass_inst <- bassStandup
# drum_inst <- drumkitStahl
# bpm <- 90
# style <- "oriental"
# memory <- 10
# end <- 20
# res_factor <- 1



# # possible combination
# global_cilmate_models <- c("CNRM-CM5", "EC-EARTH", "HadGEM2-ES")
# climate_projections <- c("historical-rcp85")
# regional_climate_models <- c("ALADIN63", "HadREM3-GA7", "CCLM4-8-17")
# bias_correction_methods <- c("ADAMONT")
# hydrological_models <- c("ORCHIDEE")

# # modelisation chains
# modelisation_chains <- c(
#   "CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
#   "EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_ORCHIDEE",
#   "HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
#   "HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_ORCHIDEE"
# )


# required packages
library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)
library(gganimate)
library(av)
library(sequenceR) # https://github.com/benRenard/sequenceR
library(qrcode)
library(lubridate)
library(extrafont)
