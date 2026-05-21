from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO)


def add_bi_keys(df):
    df = df.reset_index(drop=True).copy()

    df["post_id"] = ["P" + str(i).zfill(4) for i in range(1, len(df) + 1)]

    restaurant_dim = (
        df[["restaurant_name"]]
        .drop_duplicates()
        .reset_index(drop=True)
    )

    restaurant_dim["restaurant_id"] = [
        "R" + str(i).zfill(3) for i in range(1, len(restaurant_dim) + 1)
    ]

    df = df.merge(restaurant_dim, on="restaurant_name", how="left")

    return df, restaurant_dim


def save_bi_ready_data(df, restaurant_dim, output_dir):
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    df.to_csv(output_dir / "xhs_posts_bi_ready.csv", index=False, encoding="utf-8-sig")
    df.to_excel(output_dir / "xhs_posts_bi_ready.xlsx", index=False)

    restaurant_dim.to_csv(output_dir / "dim_restaurant.csv", index=False, encoding="utf-8-sig")
    restaurant_dim.to_excel(output_dir / "dim_restaurant.xlsx", index=False)

    logging.info("Saved BI-ready fact table and restaurant dimension")