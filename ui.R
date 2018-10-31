
shinyUI(navbarPage("NYPD COLLISIONS (An Analysis on Vision Zero)", id="nav",
                   tabPanel("Map",icon = icon("map-pin"),
                            div(class="outer",
                                tags$head(
                                  includeCSS("styles.css")
                                  ),
                                leafletOutput("map", width="100%", height="100%"),
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = FALSE, top = 60, left = "auto", right = 5, bottom = "auto",
                                              width = 280, height = "auto",
                                              h2("Collisions"),
                                              selectizeInput('borough1',
                                                             'BOROUGH',
                                                             choice, selected = "MANHATTAN"),
                                              
                                              selectizeInput('year',
                                                             'YEAR',
                                                             choice1, selected = "2012"),
                                              helpText("Select layer option for year from layer menu on left side."),
                                              
                                              plotOutput("hist", height = 200)
                                              
                                              ),
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = FALSE, draggable = FALSE, 
                                              top = 'auto', left = 'auto', right = '5', bottom = "5",
                                              width = 'auto', height = '30',
                                              h6('"NYPD Motor Vehicle Collisions"| NYC Open Data.Details of Motor Vehicle 
                                                 Collisions in New York City provided by the Police Department (NYPD)')
                                              ),
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = FALSE, draggable = FALSE, 
                                            top = '15', left = '50', right = 'auto', bottom = "20",
                                            width = 'auto', height = '30',
                                            sprintf("%s ", quote[sample(1:50,1,replace=T)])
                                            )
                            )
                   ),
                   
                   tabPanel("Graph",icon = icon("signal"),
                            absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                          draggable = FALSE, top = 60, left = "auto", right = 5, bottom = "auto",
                                          width = 270, height = "auto",
                                          h3("Graph By Category"),
                                          br(),
                                          h4(menuSubItem("Collision by Year",tabName = "plot1", icon = icon("line-chart"))),
                                          br(),
                                          h4(menuSubItem("Collision by Borough",tabName = "plot7", icon = icon("bar-chart"))),
                                          br(),
                                          h4(menuSubItem("Collision by Day",tabName = "plot2", icon = icon("area-chart"))),
                                          br(),
                                          h4(menuSubItem("Collision by Hour",tabName = "plot3", icon = icon("line-chart"))),
                                          br(),
                                          h4(menuSubItem("Contributing Factor", tabName = "plot4", icon = icon("bar-chart"))),
                                          br(),
                                          h4(menuSubItem("Collision by Month", tabName = "plot9", icon = icon("area-chart"))),
                                          br(),
                                          h4(menuSubItem("Collision by Weather type", tabName = "plot8", icon = icon("bar-chart"))),
                                          br(),
                                          h4(menuSubItem("Factor affecting Injury", tabName = "plot6", icon = icon("line-chart"))),
                                          br()
                                          #h4(menuSubItem("Are pedestrians safe?", tabName = "plot5", icon = icon("area-chart")))
                                          
                                          ),
                            tabItems(
                              tabItem(tabName = "plot1",
                               fluidRow(box(
                                 plotOutput("plot1",height = 650),
                                 width = 10))),
                              tabItem(tabName = "plot2",
                               fluidRow(box(
                                 plotOutput("plot2",height = 650),
                                 width = 10))),
                              tabItem(tabName = "plot3",
                               fluidRow(box(
                                 plotOutput("plot3",height = 650),
                                 width = 10))),
                              tabItem(tabName = "plot4",
                               fluidRow(box(
                                 plotOutput("plot4",height = 650),
                                 width = 10))),
                              tabItem(tabName = "plot5",
                               fluidRow(box(
                                 plotOutput("plot5",height = 650),
                                 width = 10))),
                              tabItem(tabName = "plot6",
                               fluidRow(box(
                                 plotOutput("plot6",height = 650),
                                 width = 10))),
                              tabItem(tabName = "plot9",
                                fluidRow(box(
                                  plotOutput("plot9",height = 650),
                                  width = 10))),
                              tabItem(tabName = "plot7",
                               fluidRow(box(
                                 plotOutput("plot7",height = 650),
                                 width = 10))),
                              tabItem(tabName = "plot8",
                               fluidRow(box(
                                 plotOutput("plot8",height = 650),
                                 width = 10)))
                              )
                            ),
                   tabPanel("Data",icon = icon("database"),
                            h2("NYPD Collisions Data (2012 - 2018)"),
                            DT::dataTableOutput("mytable")
                            ),
                   
                   tabPanel("Dangerous Intersections",icon = icon("exclamation-triangle"),
                            h2("Top 10 Locations of Most Accidents (2018)"),
                            helpText("Click ACTION BUTTON to view the intersection on the map"),
                            hr(),
                            DT::dataTableOutput("toptable")
                   ),
                   
                   tabPanel("Reference",icon = icon("info"),
                            br(),
                            h3("Data From:"),
                            p("Source: ",a("NYPD Motor Vehicle Collisions | NYC Open Data.",href=
                                             "https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95")),
                            p("Dataset downloaded on 10/18/2018."),
                            p("Records from 07/01/2012 to 07/01/2018."),
                            p("Original DataSet contains 1.37M observations and 29 columns."),
                            p("After filtering data and adding a Weather column it came to 663001 observations and 24 Columns."), 
                            p("Because of processing time this app only use a random sample of 10000 observations from original Dataset."),
                            br(),
                            h3("App by:"),
                            h4("Nilesh Patel"),
                            p("Email: patelnilesh1810@gmail.com"),
                            p("Github:", a('https://github.com/patelnilesh1810'))
                            )
                   )
        )

