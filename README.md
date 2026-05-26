# Paid to Produce: Measuring True NBA Player Value Against the 2025-26 Salary Landscape

**By Elijah Wekstein**  
CU Boulder — Business Analytics & Information Management

---

## Overview

Every summer, NBA front offices make decisions worth hundreds of millions of dollars. A max contract handed to the wrong player doesn't just hurt the salary cap — it affects the entire direction of a franchise. This project explores how individual players' value stacks up against their 2025-26 NBA salaries, examining whether contract size tracks with actual impact and identifying which players are outperforming or underperforming their deals by the widest margins.

**Data source:** [Basketball Reference](https://www.basketball-reference.com)

---

## Tools

- R (tidyverse, ggplot2, ggrepel)

---

## Objectives

- Measure each player's on-court value relative to their 2025-26 salary
- Identify the most underpaid players in the league
- Identify the biggest contract albatrosses
- Explore whether max contracts are justified as a tier

---

## Methodology

To measure each player's individual on-court impact, I used **VORP (Value Over Replacement Player)** — a modern advanced statistic that estimates how many points per 100 possessions a player contributes above or below a replacement-level player, scaled to actual minutes played.

- A VORP of **0** = replacement-level performance
- **Positive** values = adding real value above replacement
- **Negative** values = a replacement-level player would contribute more

VORP is a natural fit for contract value analysis because it rewards sustained impact over volume stats. A raw points-per-game average doesn't tell you whether a player is worth $40 million. VORP gets closer to that answer.

To measure over/underperformance, I fit a linear regression of VORP on salary and calculated each player's **residual** — the gap between their actual VORP and the VORP their salary predicted. That residual is the core metric of this analysis.

---

## Analysis

### The Full Picture: Salary vs. Impact

Plotting every qualifying player's salary against their VORP reveals an upward trend — higher pay correlates with greater impact in the aggregate. But the scatter around that line is where the real story lives.

![Salary vs Impact Scatter](WhosDeliveringValue.pdf)

Players above the line are outperforming their contracts. Players below it are underperforming relative to salary expectations. The distance from the line — not the raw salary or raw VORP — is the most important measure of value.

---

### The Best Bargains: Most Underpaid Players

The 15 biggest positive residuals in the league — players delivering the most value above and beyond what their paycheck expects.

![Most Underpaid Players](MostUnderpaid.pdf)

Nikola Jokic leads the list. Even at $55.2M, one of the largest contracts in the league, his VORP of 9.2 against a predicted value of ~3.1 represents the largest positive gap of any player this season. Shai Gilgeous-Alexander and Victor Wembanyama follow closely — Wembanyama still on his rookie deal at $13.4M is the most extreme example of production outpacing salary. That gap closes dramatically when he hits free agency.

The more actionable names are the mid-tier bargains: Jalen Duren ($6.5M), Amen Thompson ($9.7M), Payton Pritchard ($7.2M), and Neemias Queta ($2.3M) are all delivering impacts that would justify contracts three or more times their current size.

---

### The Biggest Albatrosses: Most Overpaid Players

The 15 biggest negative residuals among players earning at least $15M — the contracts front offices lose sleep over.

![Biggest Overpays](BiggestOverpays.pdf)

Khris Middleton sits at the bottom with the largest negative residual among players earning $15M or more. At $33.3M, the expectation is meaningful positive contribution. What he provided was a VORP of -0.9 — below replacement level. The list around him tells a familiar story: Darius Garland ($39.4M), Jaren Jackson Jr. ($35M), and DeAndre Ayton ($33.7M) are all being paid near-max money while delivering worse production than their salary predicts.

---

### Are Max Players Worth It?

Grouping players into salary tiers and comparing their BPM (Box Plus/Minus) distributions reveals whether the max tier justifies its price tag on average.

![Are Max Players Worth It](AreMaxPlayersWorthIt.pdf)

Max contracts are generally justified on average — but the variance within the tier is large enough that individual decisions matter enormously. Paying $40M to the right player is an investment. Paying it to the wrong one is a multi-year setback.

---

## Key Findings

- **Max contracts are justified on average, but variance is high.** The difference between the best and worst max contracts is enormous — the tier average masks individual outcomes that can make or break a franchise.
- **Rookie and team-friendly deals are the highest ROI in the NBA.** Wembanyama, Duren, and Thompson are producing at levels that would command dramatically higher salaries on the open market. The window to extend them affordably is narrow.
- **VORP relative to salary expectation is the most honest measure of contract value.** A $20M player underperforming by 2 VORP units can be more damaging than a $50M player underperforming by 1, depending on the team's cap situation.
- **The worst contracts share a common thread:** they were signed based on reputation and past performance rather than current trajectory. Middleton, Garland, and Ayton were all reasonable bets at signing. The data suggests those bets haven't paid off this season.

---

## Conclusion

The 2025-26 NBA season shows something front offices already know but sometimes forget: contracts are commitments made for the future, and the future doesn't always go as planned. The gap between expected and actual VORP is where franchises are built or broken.

What stands out most isn't the superstars outperforming their contracts — Jokic being Jokic is not a surprise. It's the middle of the roster where the real deals are made. The teams that find Deni Avdija's and Payton Pritchard's before the market adjusts are the ones that build sustainable contenders. The teams that keep chasing past performance with max money are the ones that spend years trying to trade out of mistakes.

---

## Repository Contents

| File | Description |
|------|-------------|
| `NBA-PlayerValue.R` | Full R script for data processing and all visualizations |
| `nba_value_2526.csv` | Raw player salary and advanced stats data |
| `WhosDeliveringValue.pdf` | Salary vs. VORP scatter chart |
| `MostUnderpaid.pdf` | Top 15 most underpaid players |
| `BiggestOverpays.pdf` | Top 15 biggest contract overpays |
| `AreMaxPlayersWorthIt.pdf` | BPM distribution by salary tier |
| `README.md` | Project writeup and analysis |

---

## About

**Elijah Wekstein** — [LinkedIn](https://www.linkedin.com/in/elijah-wekstein) | [Portfolio](https://ewekstein.github.io)
