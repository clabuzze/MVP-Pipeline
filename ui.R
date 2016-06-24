library(shiny)
library(shinydashboard)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Getting Started", tabName = "start", icon = icon("home")),
    menuItemOutput("dataDisplay"),
    menuItem("Predict Unknowns", tabName = "unknowns", icon = icon("magic"),
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Cross Validation", tabName = "validation", icon = icon("line-chart"),
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Clone via Github", icon = icon("github"), 
             href = "https://github.com/clabuzze/Phenotype-Prediction-Pipeline.git"),
    menuItem("Publication", icon = icon("flask"), href = NULL,
             badgeLabel = "coming soon", badgeColor = "blue"),
    fileInput(inputId = "data", label="1. Upload training dataset"),
    
    uiOutput("pheno1slider"),
    uiOutput("pheno2slider")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "start",
            tags$div(
              HTML("<center><h2>Getting Started with MVP</h2></center>")
            ),
            strong("Overview:"), 
            p("The Most Valuable Predictors (MVP) Pipeline provides an accurate and efficient technique
              to predict the disease state or phenotype of unknown patient samples. Using machine learning
              methods, the expression of genes and/or isoforms may be analyzed to identify biomarker candidates
              having significant differential expression between each phenotype. The MVP Pipeline uses a
              univariate filtering method to select these genes or isoforms with consistent expression patterns
              as the most valuable predictors while increasing the accuracy of the predictions.
              "),br(),
            strong("Requirements:"),
            tags$ul(tags$li("Experiment with two phenotypes and sample replicates"), tags$li("Expression Matrix: Samples in Columns, Transcripts in Rows"),
                    tags$li(strong("Goal: "), "Predict the phenotype of unlabeled samples")),br(),
            strong("Recommended Process:"),
            p("RNA-Seq  -->  TopHat2  -->  RSEM  -->  Isoform Expression Matrix"),br(),
            strong("Alternative Processes:"),
            p("RNA-Seq  -->  Tophat2  --> Cufflinks  -->  CuffMerge  -->  CuffDiff  -->  Isoform Expression Matrix"),br(),
            actionButton("simulateData", "Simulate a dataset"),
            uiOutput("download"),br(),
            strong("How to use MVP Pipeline:"),
            p("The prediction function of the MVP Pipeline analyzes unknown samples and provides a phenotype
              prediction using both the elastic net and random forest machine learning algorithms. We suggest
              running using the cross-validation function on the samples of known phenotype before predicting 
              unknown samples to assess the accuracy of the MVP Pipeline on the uploaded dataset."),
            tags$ol(tags$li("Upload a previously generated expression matrix or simulate one above"), 
                    tags$li("Follow the steps in the Cross Validation tab to assess accuracy"),
                    tags$li("Further assess accuracy using the Predict Unknowns tab to test the method on known samples"),
                    tags$li("Predict phenotypes of unknown samples using the Predict Unknowns tab")),br()
            ),
    tabItem(tabName = "display",
            tags$div(
              HTML("<center><h2>Uploaded Data</h2></center>")
            ),
            dataTableOutput("dataTable")),
    tabItem(tabName = "unknowns",
            tags$div(
              HTML("<center><h2>Predict Phenotype of Unknown Sample</h2></center>")
            ),
            box(
              title = "Inputs", status = "warning", solidHeader = TRUE, width = NULL,
              column(width = 6,
                     strong("1. Upload training dataset via sidebar"), p(), strong("2. Select column of unknown sample"),
                     #fileInput(inputId = "testing", label="2. Upload testing dataset"),
                     uiOutput("unknown")
              ),
              column(width = 6,
                     textInput("pValue", label = "3. Input p value for differential expression", value = 0.05, placeholder = 0.05),
                     radioButtons("SelFil",label = "4. Select filtering method", choices = list("MVP", "None"), inline = TRUE, selected = "MVP"),
                     uiOutput("predict")
              )
            ),
            box(
              title = "Prediction", status = "warning", solidHeader = TRUE, width = NULL,
              textOutput("predRF"), br(),
              textOutput("predEN")
            )
    ),
    
    tabItem(tabName = "validation",
            tags$div(
              HTML("<center><h2>Cross Validate Machine Learning Methods</h2></center>")
            ),
            box(
              title = "Inputs", status = "warning", solidHeader = TRUE, width = NULL,
              column(width = 6,
                     strong("1. Upload training dataset via sidebar"),p(),
                     textInput("pValue", label = "2. Input p value for differential expression", value = 0.05, placeholder = 0.05)
              ),
              column(width = 6,
                     radioButtons("SelFilValidate", label = "3. Select filtering method", choices = list("MVP", "None"), inline = TRUE, selected = "MVP"),
                     uiOutput("validation")
              )
            ),
            box(
              title = "Random Forest ROC Curve Analysis", status = "primary", solidHeader = TRUE,
              collapsible = TRUE, width = 6, collapsed = FALSE,
              plotOutput("rocRF.plot", height = 250), 
              textOutput("rocRF.mla"),
              textOutput("rocRF.roc")
            ),
            box(
              title = "Elastic Net ROC Curve Analysis", status = "primary", solidHeader = TRUE,
              collapsible = TRUE, width = 6, collapsed = FALSE,
              plotOutput("rocEN.plot", height = 250),
              textOutput("rocEN.mla"),
              textOutput("rocEN.roc")
            )
    )
    )
  )


ui <- dashboardPage(
  dashboardHeader(title = "MVP Pipeline"), sidebar, body
)
