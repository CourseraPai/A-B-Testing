CookieCat <-
  drake_plan(

   url = "https://raw.githubusercontent.com/VolodymyrGavrysh/DataCamp_projects/master/A.B%20Testing%20mobileGame%20Cookie%20Cats/datasets/cookie_cats.csv",
   cookie = get_data(url),
   save_file = saveRDS(cookie, file_out("cookie.RDS")),
   deployment = rsconnect::deployApp(
     appDir = "CookieCat",
     appFiles = file_in(
       "cookie.RDS",
       "app.R",
       "R/get_data.R",
       "R/get_plot.R"
     ),
     appName = "CookieCat",
     account="courserapai",
     forceUpdate = TRUE)

)