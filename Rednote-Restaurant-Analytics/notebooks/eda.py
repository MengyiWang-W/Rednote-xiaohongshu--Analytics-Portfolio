from pathlib import Path
import sys
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROJECT_ROOT))

from src.eda_analysis import (
    build_summary_univariate,
    build_summary_interaction,
    save_eda_outputs
)

DATA_PATH = PROJECT_ROOT / "data" / "processed" / "xhs_posts_features.csv"
OUTPUT_DIR = PROJECT_ROOT / "outputs"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA_PATH)

feature_list = [
    "has_price",
    "is_weekend",
    "content_length_bucket",
    "image_count_bucket",
    "novelty_score",
    "restaurant_popularity",
    "structured_content_flag"
]

feature_pairs = [
    ("content_length_bucket", "image_count_bucket"),
    ("novelty_score", "restaurant_popularity"),
    ("structured_content_flag", "content_length_bucket"),
]

summary_df = build_summary_univariate(df, feature_list)
interaction_df = build_summary_interaction(df, feature_pairs)

save_eda_outputs(summary_df, interaction_df, OUTPUT_DIR)

univariate_export = summary_df.rename(columns={
    "feature": "Feature",
    "feature_value": "Value",
    "avg_engagement": "Avg_Engagement"
})

univariate_export = univariate_export[
    ["Feature", "Value", "Avg_Engagement"]
].sort_values(
    ["Feature", "Value"]
)

univariate_export.to_csv(
    OUTPUT_DIR / "eda_univariate_results.csv",
    index=False,
    encoding="utf-8-sig"
)

univariate_export.to_excel(
    OUTPUT_DIR / "eda_univariate_results.xlsx",
    index=False
)

interaction_export = interaction_df.rename(columns={
    "feature_1": "Feature_1",
    "feature_value_1": "Value_1",
    "feature_2": "Feature_2",
    "feature_value_2": "Value_2",
    "avg_engagement": "Avg_Engagement",
    "sample_size": "Sample_Size"
})

interaction_export = interaction_export[
    ["Feature_1", "Value_1", "Feature_2", "Value_2", "Avg_Engagement", "Sample_Size"]
].sort_values(
    ["Feature_1", "Feature_2", "Avg_Engagement"],
    ascending=[True, True, False]
)

interaction_export.to_csv(
    OUTPUT_DIR / "eda_interaction_results.csv",
    index=False,
    encoding="utf-8-sig"
)

interaction_export.to_excel(
    OUTPUT_DIR / "eda_interaction_results.xlsx",
    index=False
)

print("\nUnivariate EDA results saved:")
print(OUTPUT_DIR / "eda_univariate_results.xlsx")

print("\nInteraction EDA results saved:")
print(OUTPUT_DIR / "eda_interaction_results.xlsx")