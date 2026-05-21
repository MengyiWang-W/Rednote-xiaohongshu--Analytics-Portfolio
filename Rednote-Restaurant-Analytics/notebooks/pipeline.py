from pathlib import Path
import sys
import logging

logging.basicConfig(level=logging.INFO)

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

from src.data_cleaning import ingest_data, clean_data, save_cleaned
from src.validation import run_validation
from src.feature_engineering import engineer_features, save_features

DATA_PATH = PROJECT_ROOT / "data" / "raw" / "raw.xlsx"
PROCESSED_DIR = PROJECT_ROOT / "data" / "processed"

df = ingest_data(DATA_PATH)
df = clean_data(df)
save_cleaned(df, PROCESSED_DIR)

validation_results = run_validation(df)
print(validation_results)

df_features = engineer_features(df)
save_features(df_features, PROCESSED_DIR)

print(df_features.head())

