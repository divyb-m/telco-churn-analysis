# Telco Customer Churn Analysis

A SQL-based exploratory analysis of customer churn using the IBM Telco Customer Churn dataset. The purpose was to practice a churn analysis to identify (1) which customer segments are most likely to churn,  (2) what factors are driving that churn from a business retention perspective.

## Dataset

- **Source:** [IBM Telco Customer Churn dataset](https://www.kaggle.com/datasets/yeanzc/telco-customer-churn-ibm-dataset) (via Kaggle)
- **Size:** 7,043 customers, 33 columns
- **Tools:** PostgreSQL, DBeaver

## Approach

All analysis was done in SQL. Numeric columns were loaded as VARCHAR to avoid import errors caused by empty string values, then cast to `numeric` within queries as needed. The full set of queries is in [`churn_analysis.sql`](./churn_analysis.sql).

## Key Findings

**1. Overall churn rate is 26.5%** — roughly 1 in 4 customers left, which is high relative to typical telecom industry benchmarks (10-15%).

**2. The top churn drivers fall into two categories:**
- Competitive pressure (better speeds, more data, better offers from competitors)
- Customer service quality ("attitude of support person" was the single most common churn reason)

**3. Contract type is a major predictor of churn:**
| Contract Type | Churn Rate |
| Month-to-month | 42.7% |
| One year | 11.3% |
| Two year | 2.8% |

Month-to-month customers churn at roughly **15x the rate** of two-year contract customers, likely due to the absence of early termination fees.

**4. Churn decreases steadily with tenure:**
| Tenure | Churn Rate |

| Year 1 | 47.4% |
| Year 2 | 28.7% |
| Year 3 | 21.6% |
| Year 4 | 19.0% |
| Year 5 | 14.4% |
| Year 6 | 6.6% |

First-year customers churn at nearly **7x the rate** of six-year customers, reflecting the vulnerability of the early customer relationship.

**5. Fiber optic customers churn at the highest rate:**
| Internet Service | Churn Rate |

| Fiber optic | 41.9% |
| DSL | 19.0% |
| No internet | 7.4% |

Fiber optic is both the largest customer segment and the highest-churn segment, suggesting the issue is pricing/competition rather than product quality.

**6. Tech Support significantly reduces churn:**
| Tech Support | Churn Rate |

| No | 41.6% |
| Yes | 15.2% |
| (No internet service) | 7.4% |

Customers without tech support churn at nearly **3x the rate** of those with it. The effect is even more pronounced among fiber optic customers specifically (49.4% without tech support vs. 22.6% with it).

## Business Implications

The customers most at risk of churning are **new, month-to-month, fiber optic customers without tech support** — and they're leaving primarily due to competitor offers and service quality issues. Potential retention strategies include:

- Incentivizing contract upgrades from month-to-month to annual plans
- Bundling or upselling tech support, particularly for fiber optic customers
- Reviewing customer service training and processes
- Reassessing fiber optic pricing relative to competitors

## Next Steps

A Tableau dashboard visualizing these findings is in progress.

