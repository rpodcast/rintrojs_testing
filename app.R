library(rintrojs)
library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
  introjsUI(),
  tags$style(HTML(
    ".newClass {
      min-width: 800px;
      max-width: 800px;
    }"
  )),
  
  # Application title
  introBox(
    titlePanel("Old Faithful Geyser Data"),
    data.step = 1,
    data.intro = includeMarkdown("test.md")
  ),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(sidebarPanel(
    introBox(
      introBox(
        sliderInput(
          "bins",
          "Number of bins:",
          min = 1,
          max = 50,
          value = 30
        ),
        data.step = 3,
        data.intro = "This is a slider",
        data.hint = "You can slide me"
      ),
      introBox(
        actionButton("help", "Press for instructions"),
        data.step = 4,
        data.intro = "This is a button",
        data.hint = "You can press me"
      ),
      data.step = 2,
      data.intro = "This is the sidebar. Look how intro elements can nest"
    )
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    introBox(
      plotOutput("distPlot"),
      data.step = 5,
      data.intro = "This is the main plot"
    )
  ))
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {
  # initiate hints on startup with custom button and event
  hintjs(session, options = list("hintButtonLabel"="Hope this hint was helpful"),
         events = list("onhintclose"='alert("Wasn\'t that hint helpful")'))
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x,
         breaks = bins,
         col = 'darkgray',
         border = 'white')
  })
  
  # start introjs when button is pressed with custom options and events
  observeEvent(input$help,
               introjs(session, options = list("nextLabel"="Onwards and Upwards",
                                               "prevLabel"="Did you forget something?",
                                               "skipLabel"="Don't be a quitter",
                                               "tooltipClass" = "newClass"),
                       events = list("oncomplete"='alert("Glad that is over")',
                                     "onbeforechange"='
                                     if (targetElement.getAttribute("data-step")==="1") {
                                      $(".newClass").css("max-width", "800px").css("min-width","800px");  
                                     } else {
                                      $(".newClass").css("max-width", "500px").css("min-width","500px");
                                     }'))
  )
})

# Run the application
shinyApp(ui = ui, server = server)