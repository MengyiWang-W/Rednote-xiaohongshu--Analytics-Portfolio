from pathlib import Path
import pandas as pd
import logging

logging.basicConfig(level=logging.INFO)

def ingest_data(path):
    path = Path(path)
    if not path.exists():
        raise FileNotFoundError(f"{path} not found")

    df = pd.read_excel(path, header=1)
    logging.info(f"Raw shape: {df.shape}")
    return df


def clean_data(df):
    df = df.iloc[1:].copy()
    df.reset_index(drop=True, inplace=True)

    if "raw_price" in df.columns:
        df["raw_price"] = df["raw_price"].astype(str)

    logging.info(f"Cleaned shape: {df.shape}")
    return df


def save_cleaned(df, output_dir):
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    df.to_csv(output_dir / "xhs_posts_cleaned.csv", index=False, encoding="utf-8-sig")
    df.to_excel(output_dir / "xhs_posts_cleaned.xlsx", index=False)

    logging.info("Saved cleaned data")