import pandas as pd
import argparse
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


def validate(df):
    logging.info("Running validation checks...")

    logging.info(f"Missing values:\n{df.isnull().sum()}")
    logging.info(f"Duplicate rows: {df.duplicated().sum()}")

    if "age_numeric" in df.columns:
        logging.info(f"Age range: {df['age_numeric'].min()} - {df['age_numeric'].max()}")


def main(input_path):
    df = pd.read_csv(input_path)
    validate(df)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)

    args = parser.parse_args()
    main(args.input)