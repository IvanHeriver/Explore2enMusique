# credits: coded by Benjamin Renard and modified/adapted by Ivan Horner

createWave <- function(
    values,
    anomalies,
    instrument_positive_anomalies,
    instrument_negative_anomalies,
    instrument_bass,
    instrument_drums,
    style = "oriental",
    spb, # seconds per beat
    pow = 2, # volume power scaling
    t0 = 0 # starting time step
    ) {
  values[values == 0] <- 0.1 * min(values[values > 0])
  if (style == "oriental") {
    n1 <- c("E3", "G3", "A3", "B3", "C4", "Eb4", "E4", "Gb4", "G4", "A4", "B4", "C5")
    n2 <- c("E3", "G3", "A3", "B3", "C4", "Eb4", "E4", "Gb4", "G4", "A4", "B4", "C5")
    n3 <- c("E1", "G1", "A1", "B1", "C2", "Eb2", "E2", "Gb2", "G2", "A2", "B2", "C3")
  } else if (style == "major") {
    n1 <- c("E3", "E3", "B3", "Eb4", "E4", "Ab4", "B4", "B4")
    n2 <- c("E3", "E3", "B3", "Eb4", "E4", "Ab4", "B4", "B4")
    n3 <- c("E1", "Ab1", "A1", "B1", "Db2", "E2", "Ab2", "A2", "B2", "Db3")
  } else if (style == "minor") {
    n1 <- c("E3", "B3", "E4", "B4", "D4", "E4", "G4", "B4")
    n2 <- c("E3", "B3", "E4", "B4", "D4", "E4", "G4", "B4")
    n3 <- c("E1", "G1", "A1", "B1", "D2", "E2", "G2", "A2", "B2", "D3")
  }

  spt <- spb / 8 # seconds per time step (here time step = 16th note i.e. 1/4 of a beat)

  # Time
  time_sequence <- t0 + ((seq_len(length(values))) - 1) * spt

  # compute pich from actual values
  pitch <- sequenceR::rescale(log10(values))

  # Instrument 1 highlights positive anomalies
  message("Creating positive anomalies sounds...")
  flush.console()

  notes_indices <- as.integer(pitch * (length(n1) - 1)) + 1

  volume_instrument_1 <- sequenceR::rescale(anomalies * (anomalies > 0))^pow

  instrument_1 <- sequenceR::play.instrument(
    inst = instrument_positive_anomalies,
    notes = n1[notes_indices],
    time = time_sequence,
    volume = volume_instrument_1,
    pan = rep(0, length(notes_indices)),
    fadeout = max(notes_indices) - notes_indices + 1
  )

  # Instrument 2 highlights negative anomalies
  message("Creating negative anomalies sounds...")
  flush.console()

  notes_indices <- as.integer(pitch * (length(n2) - 1)) + 1

  volume_instrument_2 <- sequenceR::rescale(-1 * anomalies * (anomalies < 0))^pow

  instrument_2 <- sequenceR::play.instrument(
    inst = instrument_negative_anomalies,
    notes = n2[notes_indices],
    time = time_sequence,
    volume = volume_instrument_2,
    pan = rep(0, length(notes_indices)),
    fadeout = 0 * notes_indices + Inf
  )

  # Instrument 3 (Bass) highlights negative anomalies
  message("Creating bass sounds...")
  flush.console()
  threshold <- quantile(anomalies, 1 / 8)
  bass_playing_mask <- anomalies < threshold
  time_sequence_bass <- time_sequence[bass_playing_mask]
  volume <- 0 * time_sequence_bass + 1
  pitch <- log10(values[bass_playing_mask])
  bass_notes_indices <- as.integer(sequenceR::rescale(pitch) * (length(n3) - 1)) + 1
  bass <- sequenceR::play.instrument(
    inst = instrument_bass,
    notes = n3[bass_notes_indices],
    time = time_sequence_bass,
    volume = volume,
    fadein = rep(0.1, length(bass_notes_indices)),
    fadeout = rep(0.5, length(bass_notes_indices))
  )

  # DRUMS
  message("Creating kick drums sounds...")
  flush.console()
  volume_both_instruments <- (volume_instrument_1 + volume_instrument_2) / 2
  # volume_negative_rescaled <- sequenceR::rescale(volume_instrument_2, 0.1, 1)

  seq_bass <- rep_len(
    c(
      TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
      TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE
    ),
    length(time_sequence)
  )
  drum_bass <- sequenceR::play.instrument(
    inst = instrument_drums,
    notes = rep("bass", sum(seq_bass)),
    time = time_sequence[seq_bass],
    volume = volume_instrument_2[seq_bass]
  )
  message("Creating snare drums sounds...")
  flush.console()
  seq_snare <- rep_len(
    c(
      FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
      FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE
    ),
    length(time_sequence)
  )
  drum_snare <- sequenceR::play.instrument(
    inst = instrument_drums,
    notes = rep("snare", sum(seq_snare)),
    time = time_sequence[seq_snare],
    volume = volume_instrument_2[seq_snare]
  )
  message("Creating hihat drums sounds...")
  flush.console()
  seq_hithat <- rep_len(
    c(
      TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE,
      TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE
    ),
    length(time_sequence)
  )
  drum_hithat <- sequenceR::play.instrument(
    inst = instrument_drums,
    notes = rep("hihat_f", sum(seq_hithat)),
    time = time_sequence[seq_hithat],
    volume = volume_instrument_1[seq_hithat]
  )
  message("Creating ride drums sounds...")
  flush.console()
  seq_ride <- rep_len(
    c(
      TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE,
      TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE
    ),
    length(time_sequence)
  )
  panning <- sequenceR::rescale(volume_instrument_1[seq_ride], -0, -0.5) +
    sequenceR::rescale(volume_instrument_2[seq_ride], 0, 0.5)
  drum_ride <- sequenceR::play.instrument(
    inst = instrument_drums,
    notes = rep("ride", sum(seq_ride)),
    time = time_sequence[seq_ride],
    volume = volume_both_instruments[seq_ride],
    pan = panning,
    fadeout = rep(Inf, sum(seq_ride))
  )

  message("Mixing all sounds...")
  flush.console()

  final_wave <- sequenceR::mix(
    waves = c(list(instrument_1, instrument_2, bass, drum_bass, drum_snare, drum_hithat, drum_ride)),
    vol = c(0.7, 1, 1, 1, 0.5, 0.5, 0.5),
    pan = c(-0.5, 0.5, 0, 0, 0, 0, 0)
  )

  return(final_wave)
}


createLinearAxisDataMapper <- function(data_range, plot_range) {
  return(function(data_value) {
    return(
      (data_value - data_range[1]) /
        diff(data_range) *
        diff(plot_range) +
        plot_range[1]
    )
  })
}

createArrow <- function(range, x = NULL, y = NULL, ...) {
  stopifnot(xor(is.null(x), is.null(y)))
  data <- data.frame(
    x = ifelse(is.null(x), range[1], x),
    xend = ifelse(is.null(x), range[2], x),
    y = ifelse(is.null(x), y, range[1]),
    yend = ifelse(is.null(x), y, range[2])
  )
  return(ggplot2::geom_segment(
    data = data,
    ggplot2::aes(x = x, y = y, xend = xend, yend = yend), # nolint
    ...,
    arrow = ggplot2::arrow(type = "closed"),
  ))
}


initalizePlot <- function(
    title,
    subtitle,
    time,
    values,
    anomalies,
    color_low = "#FF9933",
    color_mid = "#339966",
    color_high = "#3366CC",
    color_bg = "#1A1A2E",
    color_line = "#CCCCCC",
    color_point = "#CCCCCC") {
  xlim <- c(0, 100)
  ylim <- c(0, 100)

  xlim_time <- c(5, 99)
  ylim_values <- c(40, 80)
  ylim_anomalies <- c(0, 40)

  color_high_light <- colorspace::lighten(color_high, 0.4)
  color_low_light <- colorspace::lighten(color_low, 0.4)

  time_axis <- createLinearAxisDataMapper(range(time), xlim_time)
  values_axis <- createLinearAxisDataMapper(range(values), ylim_values)
  anomalies_abs_max <- max(abs(anomalies))
  anomalies_fill_axis <- createLinearAxisDataMapper(c(-anomalies_abs_max, anomalies_abs_max), c(-1, 1))
  anomalies_axis <- createLinearAxisDataMapper(c(-anomalies_abs_max, anomalies_abs_max), ylim_anomalies)
  pos_anomalies_axis <- createLinearAxisDataMapper(
    c(0, anomalies_abs_max),
    c(mean(ylim_anomalies), max(ylim_anomalies))
  )
  neg_anomalies_axis <- createLinearAxisDataMapper(
    c(-anomalies_abs_max, 0),
    c(min(ylim_anomalies), mean(ylim_anomalies))
  )
  anomalies_ymin <- sapply(anomalies, function(x) ifelse(x > 0, mean(ylim_anomalies), neg_anomalies_axis(x)))
  anomalies_ymax <- sapply(anomalies, function(x) ifelse(x > 0, pos_anomalies_axis(x), mean(ylim_anomalies)))

  data <- data.frame(
    time = time_axis(time),
    year = floor(time),
    values = values_axis(values),
    anomalies_ymin = anomalies_ymin,
    anomalies_ymax = anomalies_ymax,
    anomalies_fill = anomalies_fill_axis(anomalies),
    anomalies = anomalies_axis(anomalies)
  )
  timestep_half_width <- diff(range(data$time)) / nrow(data) / 2
  data$time <- data$time + timestep_half_width * 2

  g <- ggplot2::ggplot()

  g <- g +
    ggplot2::scale_x_continuous(limits = xlim) +
    ggplot2::scale_y_continuous(limits = ylim) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = color_bg, color = color_bg),
      legend.position = "none"
    )

  g <- g +
    ggplot2::annotate("text",
      label = title,
      x = mean(xlim),
      y = 100,
      color = color_line,
      size = 15,
      alpha = 0.8
    )

  g <- g +
    ggplot2::annotate("text",
      label = subtitle,
      x = mean(xlim),
      y = 95,
      color = color_line,
      size = 10,
      alpha = 0.4
    )

  g <- g +
    ggplot2::annotate("text",
      label = "Moyennes\nsaisonnières",
      x = 0,
      y = mean(ylim_values),
      color = color_line,
      size = 12,
      angle = 90,
    )

  g <- g + ggplot2::annotate("text",
    label = "Anomalies saisonnières",
    x = 0,
    y = mean(ylim_anomalies),
    color = color_line,
    size = 12,
    angle = 90,
    vjust = -1
  )

  g <- g + createArrow(
    range = c(mean(ylim_anomalies) + 0.5, max(ylim_anomalies)), x = min(xlim_time),
    color = color_high_light,
    linewidth = 1
  )

  g <- g + createArrow(
    range = c(mean(ylim_anomalies) - 0.5, min(ylim_anomalies)), x = min(xlim_time),
    color = color_low_light,
    linewidth = 1
  )

  g <- g + ggplot2::annotate("text",
    label = "Plus que\nd'habitude",
    x = 0,
    y = quantile(ylim_anomalies, p = 0.75),
    color = color_high_light,
    size = 10,
    angle = 90,
    vjust = 1
  )

  g <- g + ggplot2::annotate("text",
    label = "Moins que\nd'habitude",
    x = 0,
    y = quantile(ylim_anomalies, p = 0.25),
    color = color_low_light,
    size = 10,
    angle = 90,
    vjust = 1
  )

  return(list(
    g = g,
    data = data,
    color_line = color_line,
    color_point = color_point,
    color_low = color_low,
    color_mid = color_mid,
    color_high = color_high,
    timestep_half_width = timestep_half_width
  ))
}

timeStepPlot <- function(plot_config, memory, current_timestep) {
  total_timesteps <- nrow(plot_config$data)

  keep <- seq_len(current_timestep)
  data <- plot_config$data[keep, ]
  data_memory <- data[
    seq.int(
      min(total_timesteps, max(1, current_timestep - memory + 1)),
      min(total_timesteps, current_timestep),
      1
    ),
  ]
  if (current_timestep > total_timesteps + memory) {
    data_memory <- data_memory[c(), ]
  }

  g <- plot_config$g

  g <- g +
    ggplot2::annotate("text",
      label = ifelse(current_timestep > 0 && current_timestep < total_timesteps,
        data$year[current_timestep], ""
      ),
      x = 50,
      y = 85,
      color = plot_config$color_line,
      family = "Times New Roman",
      size = 45,
      alpha = 0.3
    )

  g <- g +
    ggplot2::geom_line(
      data = data,
      ggplot2::aes(time, values), # nolint
      colour = plot_config$color_line,
      alpha = 0.5
    ) +
    ggplot2::geom_line(
      data = data_memory,
      ggplot2::aes(time, values, alpha = time),
      color = plot_config$color_point
    ) +
    ggplot2::geom_point(
      data = data_memory,
      ggplot2::aes(time, values, alpha = time, size = time),
      color = plot_config$color_point
    )

  g <- g +
    ggplot2::geom_rect(
      data = data,
      ggplot2::aes(
        xmin = time - plot_config$timestep_half_width,
        xmax = time + plot_config$timestep_half_width,
        ymin = anomalies_ymin, # nolint
        ymax = anomalies_ymax, # nolint
        fill = anomalies_fill # nolint
      ),
    ) +
    ggplot2::geom_rect(
      data = data_memory,
      ggplot2::aes(
        xmin = time - plot_config$timestep_half_width * 2,
        xmax = time + plot_config$timestep_half_width * 2,
        ymin = anomalies_ymin,
        ymax = anomalies_ymax,
        fill = anomalies_fill,
        alpha = time,
      ),
    ) +
    ggplot2::scale_fill_gradient2(
      low = plot_config$color_low,
      mid = plot_config$color_mid,
      high = plot_config$color_high
    ) +
    ggplot2::geom_point(
      data = data_memory,
      ggplot2::aes(
        time,
        anomalies, # nolint
        alpha = time,
        size = time,
        color = anomalies_fill
      )
    ) +
    ggplot2::scale_color_gradient2(
      low = plot_config$color_low,
      mid = plot_config$color_mid,
      high = plot_config$color_high
    )

  return(g)
}


processDataset <- function(data_path) {
  raw_data <- read.table(data_path, header = TRUE, quote = "\"", sep = ";")

  # transforming into long table
  raw_data_long <- c()
  for (k in seq.int(1, ncol(raw_data), 3)) {
    chunk <- raw_data[, k:(k + 2)]
    colnames(chunk) <- c("year", "month", "value") # names used by BFunk package
    raw_data_long <- rbind(raw_data_long, chunk)
  }
  summary(raw_data_long)

  # computing seasons
  seasons <- list(
    "SON" = c(9, 10, 11),
    "DJF" = c(12, 1, 2),
    "MAM" = c(3, 4, 5),
    "JJA" = c(6, 7, 8)
  )
  hdro_year_start_month <- 9

  raw_data_long$hyear <- raw_data_long$year
  is_previous_year <- raw_data_long$month < hdro_year_start_month
  raw_data_long$hyear[is_previous_year] <- raw_data_long$hyear[is_previous_year] - 1

  raw_data_long_seasons <- cbind(raw_data_long, "season" = rep(NA_real_, nrow(raw_data)))
  for (k in seq_along(seasons)) {
    in_season <- raw_data_long$month %in% seasons[[k]]
    raw_data_long_seasons[in_season, "season"] <- names(seasons)[[k]]
  }

  seasonal_data <- raw_data_long_seasons |>
    dplyr::group_by(hyear, season) |> # nolint
    dplyr::summarise(mean = mean(value)) |> # nolint
    dplyr::ungroup() |>
    as.data.frame()

  seasonal_data$time_index <- match(seasonal_data$season, names(seasons)) / 4 - 0.125 + seasonal_data$hyear
  seasonal_data <- seasonal_data[order(seasonal_data$time_index), ]

  # computing anomalies
  seasonal_data <- seasonal_data |>
    dplyr::group_by(season) |> # nolint
    dplyr::mutate(anomalies = qnorm((rank(mean) - 0.5) / length(mean))) |>
    dplyr::ungroup() |>
    as.data.frame()

  return(seasonal_data)
}


processDatasetIntoMusicAndVideo <- function(
    folder,
    title,
    subtitle,
    data_path,
    pos_inst,
    neg_inst,
    bass_inst,
    drum_inst,
    bpm = 80,
    style = "oriental",
    memory = 10,
    end = 20,
    res_factor = 1) {
  # ---------------------------------------------
  # loading dataset

  message(rep("#", 70))
  message("Reading and processing dataset...")
  flush.console()
  seasonal_data <- processDataset(data_path)

  # ---------------------------------------------
  # creating sounds
  message(rep("#", 70))
  message("Creating sound from data...")
  flush.console()

  final_wave <- createWave(
    values = seasonal_data$mean,
    anomalies = seasonal_data$anomalies,
    instrument_positive_anomalies = pos_inst,
    instrument_negative_anomalies = neg_inst,
    instrument_bass = bass_inst,
    instrument_drums = drum_inst,
    style = "oriental",
    spb = 120 / bpm,
    pow = 2
  )

  # tuneR::play(final_wave)

  tmpdir <- file.path("tmp", folder)
  dir.create(tmpdir, recursive = TRUE)

  tuneR::writeWave(final_wave, file.path(tmpdir, "sound.wav"))

  # ---------------------------------------------
  # creating plot
  message(rep("#", 70))
  message("Creating video from data...")
  flush.console()

  plot_config <- initalizePlot( # nolint
    title = title,
    subtitle = subtitle,
    time = seasonal_data$time_index,
    values = seasonal_data$mean,
    anomalies = seasonal_data$anomalies
  )

  expr <- expression({
    for (tstep in seq_len(nrow(plot_config$data) + end)) {
      message(sprintf("Processing image %d/%d", tstep, nrow(plot_config$data)))
      flush.console()
      print(timeStepPlot(plot_config, memory, tstep))
    }
  })

  width <- 1920 * res_factor
  height <- 1080 * res_factor

  imgdir <- file.path(tmpdir, "imgs")
  dir.create(imgdir)

  filename <- file.path(imgdir, "tmpimg_%05d.png")
  grDevices::png(filename, width = width, height = height)
  graphics::par(ask = FALSE)
  tryCatch(eval(expr), finally = grDevices::dev.off())

  images <- list.files(imgdir, pattern = "tmpimg_\\d{5}.png", full.names = TRUE)
  av::av_encode_video(
    images,
    output = file.path(tmpdir, "video.mp4"),
    framerate = bpm / 60 * 4,
    audio = file.path(tmpdir, "sound.wav"),
    vfilter = "null",
    verbose = FALSE
  )

  unlink(imgdir, recursive = TRUE)
}
