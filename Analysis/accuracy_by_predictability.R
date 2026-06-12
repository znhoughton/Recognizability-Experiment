library(tidyverse)
library(mgcv)

d <- read_csv("D:/PhD Stuff/Linguistics Stuff/Recognizability-Experiment/Data/data_analysis_cleaned.csv")

pv <- d %>%
  filter(Type == "Phrasal Verb", !is.na(log_predic), !is.na(response.corr))

cat("N trials:", nrow(pv), "\n")
cat("N participants:", n_distinct(pv$participant), "\n")
cat("Overall accuracy:", round(mean(pv$response.corr), 3), "\n\n")

m_acc <- bam(response.corr ~ s(log_predic) + s(participant, bs = "re"),
             data = pv,
             family = binomial,
             method = "fREML")

cat("=== Logistic GAM summary (predictability) ===\n")
print(summary(m_acc))

saveRDS(m_acc, "D:/PhD Stuff/Linguistics Stuff/Recognizability-Experiment/Models/m_acc_predic.rds")
saveRDS(pv,    "D:/PhD Stuff/Linguistics Stuff/Recognizability-Experiment/Models/acc_data_pv.rds")

pred_df <- data.frame(
  log_predic  = seq(min(pv$log_predic), max(pv$log_predic), length.out = 200),
  participant = pv$participant[1]
)
pred_df$fit <- predict(m_acc, newdata = pred_df, type = "response",
                       exclude = "s(participant)")

write.csv(pred_df[, c("log_predic", "fit")],
          "C:/Users/zacha/AppData/Local/Temp/acc_preds.csv",
          row.names = FALSE)

cat("\nPredicted accuracy at log_predic quantiles:\n")
quants <- quantile(pv$log_predic, c(0.1, 0.25, 0.5, 0.75, 0.9))
pred_q <- data.frame(log_predic = quants, participant = pv$participant[1])
pred_q$pred_acc <- predict(m_acc, newdata = pred_q, type = "response",
                           exclude = "s(participant)")
print(pred_q)
