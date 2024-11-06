dat <- vroom::vroom("articles/template_report/data2/metamax_tm012.csv") |>
  janitor::clean_names() |>
  dplyr::select(t, test, vo2, vco2, rer, fc) |>
  dplyr::mutate(
    t = stringr::str_replace(t, ",", ".") |>
      lubridate::parse_date_time("HMS")
  ) |>
  dplyr::group_by(test) |>
  dplyr::group_split()

library(echarts4r)
grp <- function(dat, title) {
  dat |>
    e_charts(t) |>
    e_line(serie = vo2, y_index = 0, name = "VO2 (L/min)", color = "green", symbol = "none") |>
    e_line(serie = vco2, y_index = 1, name = "VCO2 (L/min)", color = "blue", symbol = "none") |>
    e_line(serie = rer, y_index = 2, name = "RER", color = "yellow", symbol = "none") |>
    e_line(serie = fc, y_index = 3, name = "Fréquence Cardiaque (bpm)", color = "red", symbol = "none") |>
    # e_line(serie = puissance, y_index = 4, name = "Puissance (W)", color = "blue", symbol = "none") |>
    # e_line(serie = cadence, y_index = 5, name = "Cadence (rpm)", color = "orange", symbol = "none") |>
    e_y_axis(index = 0, name = "VO2 (L/min)", min = 0) |>
    e_y_axis(index = 1, name = "VCO2 (L/min)", min = 0, offset = 0) |>
    e_y_axis(index = 2, name = "RER", min = 0, offset = 80) |>
    e_y_axis(index = 3, name = "Fréquence Cardiaque (bpm)", min = 0, , offset = 180) |>
    # e_y_axis(index = 4, name = "Puissance (W)", min = 0) |>
    # e_y_axis(index = 5, name = "Cadence (rpm)", min = 0, offset = 180) |>
    e_title(title) |>
    e_x_axis(name = "Time (minutes)") |>
    e_legend(show = TRUE) |>
    # e_tooltip(trigger = "axis") |>
    # e_datazoom(type = "slider") |>
    e_toolbox_feature(feature = "saveAsImage") |>
    e_grid(right = "20%") # |> # Adjust grid to accommodate multiple y-axes
  # e_theme("dark") #|>
  # e_legend(selectedMode = "single") |> # Allows toggling between sessions
}

grp(dat[[1]], "FTP20")
grp(dat[[2]], "FTP60")
grp(dat[[3]], "RAMP")
grp(dat[[4]], "VO2max")
