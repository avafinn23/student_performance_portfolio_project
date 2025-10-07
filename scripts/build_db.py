# scripts/build_db_verbose.py  (you can overwrite build_db.py or save as this name)
import sys
import sqlite3
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
CSV  = ROOT / "data" / "processed" / "student_exam_scores_clean.csv"
DB   = ROOT / "data" / "processed" / "student_analytics.db"
TABLE = "student_exam_scores"


print("Working dir:   ", Path.cwd())
print("Script root:   ", ROOT)
print("CSV path:      ", CSV)
print("DB path:       ", DB)

# 1) Check CSV exists
if not CSV.exists():
    print("CSV not found at:", CSV)
    sys.exit(1)

# 2) Load CSV
try:
    df = pd.read_csv(CSV)
except Exception as e:
    print("Failed to read CSV:", e)
    sys.exit(1)

print(f" Loaded CSV with {len(df):,} rows and {len(df.columns)} columns.")

# 3) Write to SQLite
try:
    DB.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(DB) as conn:
        df.to_sql(TABLE, conn, if_exists="replace", index=False)
        # verify
        cur = conn.cursor()
        cur.execute(f"SELECT COUNT(*) FROM {TABLE};")
        n = cur.fetchone()[0]
        print(f" Wrote table '{TABLE}' with {n:,} rows to {DB}")
except Exception as e:
    print(" Failed writing to SQLite:", e)
    sys.exit(1)

print(" Done.")
