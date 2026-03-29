import pandas as pd
import numpy as np
import argparse
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


def load_data(path):
    return pd.read_csv(path)


def clean_data(df):
    df.replace("?", np.nan, inplace=True)

    cols = ["weight", "payer_code", "medical_specialty"]
    df.drop(columns=[c for c in cols if c in df.columns], inplace=True)

    return df


def save_data(df, path):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(path, index=False)


def main(input_path, output_path):
    logging.info("Starting data cleaning...")
    df = load_data(input_path)
    df = clean_data(df)
    save_data(df, output_path)
    logging.info("Data cleaning completed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, help="Path to raw data")
    parser.add_argument("--output", required=True, help="Path to save cleaned data")

    args = parser.parse_args()
    main(args.input, args.output)