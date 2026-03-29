import subprocess

subprocess.run([
    "python", "src/data_cleaning.py",
    "--input", "data/raw/diabetic_data.csv",
    "--output", "data/processed/clean_data.csv"
])

subprocess.run([
    "python", "src/feature_engineering.py",
    "--input", "data/processed/clean_data.csv",
    "--output", "data/processed/featured_data.csv"
])

subprocess.run([
    "python", "src/data_validation.py",
    "--input", "data/processed/featured_data.csv"
])