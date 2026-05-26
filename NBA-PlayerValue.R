library(tidyverse)

df <- read_csv("nba_value_2526.csv")

library(tidyverse)
library(ggrepel)

# ── Salary tiers ───────────────────────────────────────────────────────────────
df <- df %>%
  mutate(
    salary_tier = case_when(
      Salary_2526 >= 40000000 ~ "Max ($40M+)",
      Salary_2526 >= 25000000 ~ "Near-Max ($25–40M)",
      Salary_2526 >= 10000000 ~ "Starter ($10–25M)",
      Salary_2526 >= 3000000  ~ "Role Player ($3–10M)",
      TRUE                    ~ "Minimum (<$3M)"
    ),
    salary_tier = factor(salary_tier, levels = c(
      "Max ($40M+)", "Near-Max ($25–40M)", "Starter ($10–25M)",
      "Role Player ($3–10M)", "Minimum (<$3M)"
    )),
    salary_M = Salary_2526 / 1000000
  )

# ── Residuals ──────────────────────────────────────────────────────────────────
model <- lm(VORP ~ salary_M, data = df)
df$predicted_VORP <- predict(model, df)
df$residual <- df$VORP - df$predicted_VORP

# ── Team colors ────────────────────────────────────────────────────────────────
team_colors <- c(
  "ATL" = "#e03a3e", "BOS" = "#008348", "BRK" = "#1d1d1d",
  "CHO" = "#008ca8", "CHI" = "#ce1141", "CLE" = "#860038",
  "DAL" = "#0053bc", "DEN" = "#FEC524", "DET" = "#c8102e",
  "GSW" = "#1d428a", "HOU" = "#ce1141", "IND" = "#FDBB30",
  "LAC" = "#c8102e", "LAL" = "#552583", "MEM" = "#5d76a9",
  "MIA" = "#98002e", "MIL" = "#00471b", "MIN" = "#0c2340",
  "NOP" = "#85714d", "NYK" = "#f58426", "OKC" = "#007ac1",
  "ORL" = "#0077c0", "PHI" = "#006bb6", "PHO" = "#e56020",
  "POR" = "#e03a3e", "SAC" = "#5a2d81", "SAS" = "#8a8d8f",
  "TOR" = "#753bbd", "UTA" = "#00471b", "WAS" = "#002b5c"
)

# ── Tier colors ────────────────────────────────────────────────────────────────
tier_colors <- c(
  "Max ($40M+)"          = "#1d3461",
  "Near-Max ($25–40M)"   = "#1f6feb",
  "Starter ($10–25M)"    = "#58a4b0",
  "Role Player ($3–10M)" = "#a8dadc",
  "Minimum (<$3M)"       = "#e0e0e0"
)

# ══════════════════════════════════════════════════════════════════════════════
# CHART 1: Salary vs VORP Scatter
# ══════════════════════════════════════════════════════════════════════════════
ggplot(df %>% filter(G >= 40),
       aes(x = salary_M, y = VORP, color = salary_tier)) +
  
  geom_point(alpha = 0.7, size = 2.5) +
  
  geom_smooth(method = "lm", se = FALSE,
              color = "black",
              linetype = "dashed",
              linewidth = 0.8) +
  
  geom_text_repel(
    data = df %>%
      filter(G >= 40,
             residual >= 2.6 |
               (residual <= -1.5 & salary_M >= 18)),
    aes(label = Player),
    size = 3,
    max.overlaps = 20,
    box.padding = 0.35,
    point.padding = 0.25,
    segment.color = "grey60"
  ) +
  
  scale_color_manual(values = tier_colors) +
  
  scale_x_continuous(
    labels = scales::dollar_format(suffix = "M", prefix = "$"),
    limits = c(0, 65),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  
  scale_y_continuous(
    limits = c(-3, 10),
    expand = expansion(mult = c(0.02, 0.02))
  ) +
  
  guides(
    color = guide_legend(nrow = 2)
  ) +
  
  labs(
    title = "Salary vs. Impact: Who's Delivering Value?",
    subtitle = "Notable over/underperformers | 2025–26 NBA (min. 40 games)",
    x = "2025–26 Salary",
    y = "VORP (Value Over Replacement Player)",
    color = NULL,
    caption = "Dashed line = expected VORP by salary | Source: Basketball Reference"
  ) +
  
  theme_minimal(base_size = 13) +
  
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", hjust = 0.5, size = 20, margin = margin(b = 4)),
    plot.subtitle = element_text(hjust = 0.5, size = 11, margin = margin(b = 10)),
    legend.position = "top",
    legend.justification = "center",
    legend.text = element_text(size = 9),
    legend.spacing.x = unit(0.3, "cm"),
    plot.caption = element_text(size = 8),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold"),
    plot.margin = margin(5, 8, 5, 5)
  )

# ══════════════════════════════════════════════════════════════════════════════
# CHART 2: Most Underpaid Players
# ══════════════════════════════════════════════════════════════════════════════
underpaid <- df %>%
  filter(G >= 40) %>%
  arrange(desc(residual)) %>%
  head(15) %>%
  mutate(
    Player = fct_reorder(Player, residual)
  )
ggplot(underpaid, aes(x = Player, y = residual, fill = Team)) +
  geom_col(
    alpha = 0.9,
    width = 0.7
  ) +
  geom_text(
    aes(label = paste0("$", round(salary_M, 1), "M")),
    hjust = 1.1,
    size = 3.2,
    color = "white",
    fontface = "bold"
  ) +
  coord_flip() +
  scale_fill_manual(values = team_colors) +
  scale_y_continuous(
    limits = c(0, 7.5),
    expand = expansion(mult = c(0, 0.05))
  ) +
  labs(
    title = "The Most Underpaid Players in the NBA",
    subtitle = "VORP above what their salary predicts\n2025–26 NBA (min. 40 games)",
    x = NULL,
    y = "VORP Above Expected",
    caption = "Bar color = team | salary shown inside bar | Source: Basketball Reference"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(
      face = "bold",
      hjust = 0.5,
      size = 20),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 11),
    legend.position = "none",
    plot.caption = element_text(
      size = 8),
    axis.text.y = element_text(
      size = 10),
    axis.title.x = element_text(
      face = "bold"),
    plot.margin = margin(10, 20, 10, 20)
  )

# ══════════════════════════════════════════════════════════════════════════════
# CHART 3: Biggest Overpays
# ══════════════════════════════════════════════════════════════════════════════
overpays <- df %>%
  filter(G >= 40, salary_M >= 15) %>%
  arrange(residual) %>%
  head(15) %>%
  mutate(
    overpay = abs(residual),
    Player = fct_reorder(Player, overpay)
  )
ggplot(overpays, aes(x = Player, y = overpay, fill = Team)) +
  geom_col(
    alpha = 0.9,
    width = 0.7
  ) +
  geom_text(
    aes(label = paste0("$", round(salary_M, 1), "M")),
    hjust = 1.1,
    size = 3.2,
    color = "white",
    fontface = "bold"
  ) +
  coord_flip() +
  scale_fill_manual(values = team_colors) +
  scale_y_continuous(
    limits = c(0, 3.5),
    expand = expansion(mult = c(0, 0.05))
  ) +
  labs(
    title = "The Biggest Overpays in the NBA",
    subtitle = "VORP below what their salary predicts\n2025–26 NBA (min. 40 games, min. $15M salary)",
    x = NULL,
    y = "VORP Below Expected",
    caption = "Bar color = team | salary shown inside bar | Source: Basketball Reference"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(
      face = "bold",
      hjust = 0.5,
      size = 20),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 11),
    legend.position = "none",
    plot.caption = element_text(
      size = 8),
    axis.text.y = element_text(
      size = 10),
    axis.title.x = element_text(
      face = "bold"),
    plot.margin = margin(10, 20, 10, 20)
  )