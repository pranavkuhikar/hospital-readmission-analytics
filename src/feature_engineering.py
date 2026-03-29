import pandas as pd
import argparse
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


def convert_age(age):
    if pd.isna(age):
        return None
    age = age.strip("[]()")
    low, high = age.split("-")
    return (int(low) + int(high)) // 2


def feature_engineering(df):
    df["age_numeric"] = df["age"].apply(convert_age)

    df["readmit_high_risk"] = df["readmitted"].apply(lambda x: 1 if x == "<30" else 0)

    df["severity_index"] = df["number_diagnoses"].apply(
        lambda x: "High" if x >= 8 else "Medium" if x >= 4 else "Low"
    )

    df["total_visits"] = (
        df["number_outpatient"]
        + df["number_emergency"]
        + df["number_inpatient"]
    )

    return df


def main(input_path, output_path):
    logging.info("Starting feature engineering...")
    df = pd.read_csv(input_path)
    df = feature_engineering(df)

    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_path, index=False)

    logging.info("Feature engineering completed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)

    args = parser.parse_args()
    main(args.input, args.output)