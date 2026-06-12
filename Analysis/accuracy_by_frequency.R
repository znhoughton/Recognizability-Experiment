library(tidyverse)
library(mgcv)

d <- read_csv("D:/PhD Stuff/Linguistics Stuff/Recognizability-Experiment/Data/data_analysis_cleaned.csv")

pv <- d %>%
  filter(Type == "Phrasal Verb", !is.na(log_freq), !is.na(response.corr))

cat("N trials:", nrow(pv), "\n")
cat("N participants:", n_distinct(pv$participant), "\n")
cat("Overall accuracy:", round(mean(pv$response.corr), 3), "\n\n")

m_acc_freq <- bam(response.corr ~ s(log_freq) + s(participant, bs = "re"),
                  data = pv,
                  family = binomial,
                  method = "fREML")

cat("=== Logistic GAM summary (frequency) ===\n")
print(summary(m_acc_freq))

saveRDS(m_acc_freq, "D:/PhD Stuff/Linguistics Stuff/Recognizability-Experiment/Models/m_acc_freq.rds")

pred_df <- data.frame(
  log_freq    = seq(min(pv$log_freq), max(pv$log_freq), length.out = 200),
  participant = pv$participant[1]
)
pred_df$fit <- predict(m_acc_freq, newdata = pred_df, type = "response",
                       exclude = "s(participant)")

write.csv(pred_df[, c("log_freq", "fit")],
          "C:/Users/zacha/AppData/Local/Temp/acc_preds_freq.csv",
          row.names = FALSE)

cat("\nPredicted accuracy at log_freq quantiles:\n")
quants <- quantile(pv$log_freq, c(0.1, 0.25, 0.5, 0.75, 0.9))
pred_q <- data.frame(log_freq = quants, participant = pv$participant[1])
pred_q$pred_acc <- predict(m_acc_freq, newdata = pred_q, type = "response",
                           exclude = "s(participant)")
print(pred_q)
