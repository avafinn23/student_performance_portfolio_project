import pandas as pd

#load data
df=pd.read_csv('/Users/avafinn/PycharmProjects/student_performance_portfolio_project/data/raw/student_exam_scores.csv')

# standardize column names
df.columns = [c.strip().lower().replace(" ", "_").replace("-", "_") for c in df.columns]

# clean text columns
for c in df.select_dtypes(include=["object"]).columns:
    df[c] = df[c].str.strip()

# scale numeric columns
for c in df.select_dtypes(include=["float","int"]).columns:
    if df[c].max() <= 1:
        df[c] = (df[c] * 100).round(1)

# scale exam scores
if "exam_score" in df.columns:
    df["exam_score"] = pd.to_numeric(df["exam_score"], errors="coerce")
    df["exam_score_percent"] = (df["exam_score"] / 60 * 100).round(1)

# feature engineering
if "exam_score_percent" in df.columns:
    df["overall_score_mean"] = df["exam_score_percent"]
    df["overall_score_median"] = df["exam_score_percent"]
    df["passed_70"] = (df["overall_score_mean"] >= 70).astype(int)

from pathlib import Path
OUT_DIR = Path("/Users/avafinn/PycharmProjects/student_performance_portfolio_project/data/processed")
OUT_DIR.mkdir(parents=True, exist_ok=True)
df.to_csv(OUT_DIR / "student_exam_scores_clean.csv", index=False)
