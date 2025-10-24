
#libraries
library(recipes2)
library(ggplot2)
library(readxl)
library(rio)
library(moments)
library(lattice)
library(stargazer)
library(car)
library(lmtest)
library(corrplot)
library(survival)
library(caret)
library(ROCR)
library(dplyr)

# Load data
file_path <- ("C:/Users/91884/Desktop/BAIS/ISM 4300/Assignment 3/data.xlsx") 
data <- read_excel(file_path)
str(data)

#correlation
correlation_matrix <- cor(data[c("YearsCode", "YearsCodePro","PreviousSalary")])
corrplot(correlation_matrix,
         method = "color",                     
         col = brewer.pal(n = 9, name = "Set3"), # same palette as your CountryGroup chart
         addCoef.col = "black",                
         number.cex = 0.8,                     
         tl.col = "black",                     
         tl.srt = 45,                          
         title = "Correlation Matrix of Coding Experience and Salary",
         mar = c(0, 0, 2, 0))               # add a little space for title
print(correlation_matrix)

#asfactor
data$Employment = factor(data$Employment)
data$Employed = factor(data$Employed)

str(data)

#Creating a column Countrygroup

data <- data %>%
  mutate(CountryGroup = case_when(
    Country %in% c('United States of America', 'Canada', 'Mexico') ~ 'NorthAmerica',
    Country %in% c('United Kingdom of Great Britain and Northern Ireland', 'France', 'Germany', 'Spain', 'Italy', 'Portugal',
                   'Belgium', 'Netherlands', 'Austria', 'Switzerland', 'Denmark', 'Ireland', 'Norway', 'Sweden',
                   'Finland', 'Greece', 'Czech Republic', 'Slovakia', 'Hungary', 'Poland') ~ 'Europe',
    Country %in% c('Brazil', 'Argentina', 'Chile', 'Colombia', 'Peru', 'Venezuela, Bolivarian Republic of...', 'Bolivia') ~ 'South America',
    Country %in% c('China', 'Japan', 'South Korea', 'Viet Nam', 'India', 'Sri Lanka', 'Pakistan', 'Bangladesh', 
                   'Indonesia', 'Malaysia', 'Philippines', 'Taiwan', 'Thailand', 'Cambodia', 'Myanmar', 
                   'Laos', 'Singapore', 'Hong Kong (S.A.R.)') ~ 'Asia',
    Country %in% c('Australia', 'New Zealand', 'Fiji', 'Papua New Guinea', 'Solomon Islands', 'Vanuatu', 'Samoa', 'Tonga') ~ 'Australia',
    TRUE ~ 'Others'
  ))

ggplot(data, aes(x = CountryGroup, fill = CountryGroup)) +
  geom_bar(show.legend = FALSE) +
  labs(title = "Distribution of Respondents by Country Group",
       x = "Country Group", y = "Count") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  scale_fill_brewer(palette = "Set3")

#models

set.seed(1024) #setting seed as mentioned in the question as 1024
sample_size = floor(0.75 * nrow(data))
train_index = sample(seq_len(nrow(data)), size=sample_size)
train_data = data[train_index, ]
test_data = data[-train_index, ]



model1 = glm(Employed ~ Gender + Employment + MentalHealth + 
                    MainBranch + YearsCodePro + CountryGroup + 
                    PreviousSalary + ComputerSkills, data=train_data,
                   family=binomial (link="logit"))

model2 = glm(Employed ~ Gender + Employment + MentalHealth + 
               MainBranch + YearsCodePro*PreviousSalary + CountryGroup + 
                ComputerSkills, data=train_data,
             family=binomial (link="logit"))


# Summary of the models
stargazer(model1,model2,
          type = "text", single.row=TRUE,
          title = "Comparison of Models",
          align = TRUE)

# Exponentiated coefficients 
exp_coef_model1 <- exp(coef(model1))
exp_coef_model2 <- exp(coef(model2))

exp_coef_model1
exp_coef_model2


#Classification metrics
#model 1
predlogit <- predict(model1, newdata = test_data, type = "response")
predlogit <- ifelse(predlogit > 0.5, 1, 0)

length(predlogit)
length(test_data$Employed)
table(test_data$Employed, predlogit)

cm <- confusionMatrix(as.factor(predlogit), reference = test_data$Employed)
cm$byClass['Recall']                           
cm$byClass['Precision']                        
cm$byClass['F1']                               

pr <- ROCR::prediction(predlogit, test_data$Employed)
prf <- ROCR::performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf, main = "ROC Curve - Model 1")                                                 
auc <- ROCR::performance(pr, measure = "auc")
auc@y.values[[1]]

#model 2
predlogit <- predict(model2, newdata = test_data, type = "response")
predlogit <- ifelse(predlogit > 0.5, 1, 0)

table(test_data$Employed, predlogit)

cm <- confusionMatrix(as.factor(predlogit), reference = test_data$Employed)
cm$byClass['Recall']                           
cm$byClass['Precision']                        
cm$byClass['F1']                               

pr <- ROCR::prediction(predlogit, test_data$Employed)
prf <- ROCR::performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf, main = "ROC Curve - Model 2")
auc <- ROCR::performance(pr, measure = "auc")
auc@y.values[[1]]




