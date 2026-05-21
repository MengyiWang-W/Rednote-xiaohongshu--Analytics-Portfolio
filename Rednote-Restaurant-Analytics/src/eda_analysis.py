#EDA
from pathlib import Path
import pandas as pd
import logging
logging.basicConfig(level=logging.INFO)
#univariate analysis
def eda_univariate(df, col):
    return (
        df.groupby(col)["engagement_score"]
        .mean()
        .reset_index()
        .rename(columns={col: "feature_value", "engagement_score": "avg_engagement"})
        .assign(feature=col)
        [["feature", "feature_value", "avg_engagement"]] 
    )

def build_summary_univariate(df, feature_list):
    return pd.concat(
        [eda_univariate(df, col) for col in feature_list],ignore_index=True)

#bivariate analysis/interaction analysis
def eda_interaction (df,col1,col2):
    return(
        df.groupby([col1,col2])["engagement_score"]
        .agg(["mean","count"])
        .reset_index()
        .rename(columns={col1:"feature_value_1",col2:"feature_value_2","mean":"avg_engagement","count": "sample_size"})
        .assign(feature_1=col1,feature_2=col2)
        [["feature_1","feature_value_1","feature_2","feature_value_2","avg_engagement","sample_size"]]
    )

def build_summary_interaction(df,feature_pairs):
    return pd.concat([eda_interaction(df,f1,f2) for f1,f2 in feature_pairs],ignore_index=True)

def save_eda_outputs(summary_df, interaction_df, output_dir):
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    summary_df.to_csv(output_dir / "summary_df_univariate.csv", index=False, encoding="utf-8-sig")
    summary_df.to_excel(output_dir / "summary_df_univariate.xlsx", index=False)

    interaction_df.to_csv(output_dir / "interaction_df.csv", index=False, encoding="utf-8-sig")
    interaction_df.to_excel(output_dir / "interaction_df.xlsx", index=False)

    logging.info("Saved EDA outputs")