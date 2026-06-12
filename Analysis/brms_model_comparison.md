# Brms Model Comparison: Log Odds vs. Log Conditional Probability

All models use `log_rt` as the outcome, `adapt_delta = 0.99`, and uncorrelated (`||`) or LKJ-correlated random effects by participant. All models converged (Rhat ≤ 1.003, 0 divergent transitions). "% > 0" = percentage of posterior samples greater than zero.

---

## Model 1: Full quadratic model (uncorrelated REs)

**Log Odds:** `log_rt ~ log_freq + log_predic + Duration + I(log_predic^2) + I(log_freq^2) + (1 + log_freq + log_predic + Duration + I(log_predic^2) + I(log_freq^2) || participant)`

**Log Cond Prob:** same structure with `log_cond_prob` replacing `log_predic`

| Parameter | LO Est | LO 95% CI | LO % > 0 | CP Est | CP 95% CI | CP % > 0 |
|---|---|---|---|---|---|---|
| Intercept | −0.102 | [−0.161, −0.046] | 0.0% | −0.091 | [−0.165, −0.016] | 0.8% |
| log_freq | 0.019 | [−0.002, 0.041] | 96.2% | 0.020 | [−0.002, 0.042] | 96.6% |
| log_predic / log_cond_prob | 0.009 | [−0.013, 0.032] | 79.0% | 0.018 | [−0.018, 0.054] | 84.3% |
| Duration | −0.135 | [−0.328, 0.057] | 8.3% | −0.087 | [−0.277, 0.105] | 18.6% |
| log_predic² / log_cond_prob² | 0.003 | [0.000, 0.007] | 96.9% | 0.004 | [0.000, 0.009] | 96.2% |
| log_freq² | 0.005 | [−0.002, 0.012] | 92.9% | 0.006 | [−0.002, 0.013] | 93.9% |

---

## Model 2: Frequency-only quadratic model (uncorrelated REs)

*No log conditional probability analogue (frequency is the same predictor in both frameworks).*

**Log Odds:** `log_rt ~ log_freq + Duration + I(log_freq^2) + (1 + log_freq + Duration + I(log_freq^2) || participant)`

| Parameter | Est | 95% CI | % > 0 |
|---|---|---|---|
| Intercept | −0.102 | [−0.150, −0.054] | 0.0% |
| log_freq | 0.016 | [−0.005, 0.038] | 93.3% |
| Duration | −0.084 | [−0.274, 0.108] | 19.4% |
| log_freq² | 0.006 | [−0.001, 0.013] | 95.2% |

---

## Model 3: Predictability-only quadratic model (uncorrelated REs)

**Log Odds:** `log_rt ~ log_predic + Duration + I(log_predic^2) + (1 + log_predic + Duration + I(log_predic^2) || participant)`

**Log Cond Prob:** same structure with `log_cond_prob` replacing `log_predic`

| Parameter | LO Est | LO 95% CI | LO % > 0 | CP Est | CP 95% CI | CP % > 0 |
|---|---|---|---|---|---|---|
| Intercept | −0.110 | [−0.163, −0.058] | 0.0% | −0.097 | [−0.167, −0.030] | 0.2% |
| log_predic / log_cond_prob | 0.008 | [−0.014, 0.029] | 75.7% | 0.013 | [−0.022, 0.048] | 77.4% |
| Duration | −0.089 | [−0.280, 0.102] | 18.4% | −0.090 | [−0.280, 0.099] | 17.8% |
| log_predic² / log_cond_prob² | 0.003 | [0.000, 0.006] | 96.1% | 0.004 | [−0.001, 0.008] | 93.7% |

---

## Model 4: Predictability-only quadratic model (LKJ correlated REs)

**Log Odds:** same formula as Model 3 but with `(1 + log_predic + Duration + I(log_predic^2) | participant)`

**Log Cond Prob:** same with `log_cond_prob`

| Parameter | LO Est | LO 95% CI | LO % > 0 | CP Est | CP 95% CI | CP % > 0 |
|---|---|---|---|---|---|---|
| Intercept | −0.108 | [−0.160, −0.056] | 0.0% | −0.099 | [−0.167, −0.031] | 0.3% |
| log_predic / log_cond_prob | 0.007 | [−0.015, 0.029] | 74.0% | 0.013 | [−0.022, 0.048] | 77.0% |
| Duration | −0.090 | [−0.281, 0.101] | 17.7% | −0.089 | [−0.282, 0.103] | 18.3% |
| log_predic² / log_cond_prob² | 0.003 | [0.000, 0.006] | 95.6% | 0.004 | [−0.001, 0.008] | 93.4% |

---

## Summary

The log conditional probability models replicate the log odds results in every substantive respect:

- **Frequency effects** (Models 1 & 2): Consistent positive effect of log_freq (~96% > 0) and log_freq² (~93–95% > 0) across both frameworks.
- **Predictability linear effects** (Models 1, 3, 4): Both log odds and log conditional probability show weak, uncertain linear effects (~74–84% > 0) with CIs spanning zero.
- **Predictability quadratic effects** (Models 1, 3, 4): Despite the 95% CI marginally crossing zero, both frameworks show strong directional evidence for a positive quadratic effect — log odds² ~96% > 0 and log cond prob² ~93–96% > 0. This suggests a U-shaped relationship between predictability and recognition time that replicates across both measures.
- **LKJ vs. uncorrelated REs** (Models 3 vs. 4): Estimates are nearly identical within each framework, consistent with Barr et al. (2013).

Note: Intercepts differ in scale between frameworks because log conditional probability (log P(up|V)) is always ≤ 0, whereas log odds is approximately centered at 0.