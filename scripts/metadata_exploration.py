#!/usr/bin/env python


# libraries
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from pathlib import Path

# ---------- Load data ------------
PROJECT_ROOT = Path(__file__).resolve().parent.parent

FILE = (
    PROJECT_ROOT
    / "data"
    / "Lm_disinfectant_tolerance_Supplementary_material_11052024.xlsx"
)

raw = pd.read_excel(
    FILE,
    sheet_name="Table S1"
)


# First row contains true headers
raw.columns = raw.iloc[0]
df = raw.iloc[1:].copy()

# ---------- Select metadata -----------

metadata = df[
    [
        "Accession_number",
        "Isolation_year",
        "Country_of_collection",
        "Isolation_source"
    ]
].copy()


# -------- Clean data -------------

#danish isolates
metadata = metadata[
    metadata["Country_of_collection"] == "Denmark"
].copy()

#year groups
metadata["Isolation_year"] = pd.to_numeric(
    metadata["Isolation_year"],
    errors="coerce"
)

metadata = metadata.dropna(
    subset=["Isolation_year"]
)

metadata["Year_group"] = pd.cut(
    metadata["Isolation_year"],
    bins=[1980, 1990, 2000, 2010, 2020],
    labels=[
        "1980-1989",
        "1990-1999",
        "2000-2009",
        "2010-2019"
    ]
)

# --------- Color palette ----------

palette = {
    "Human": "#1f77b4",
    "Food": "#ff7f0e",
    "Environment": "#2ca02c",
    "Animal": "#d62728"
}


# ---------- Create figure bases -------

fig, axes = plt.subplots(
    2,
    2,
    figsize=(14, 10)
)


# ------------ A. Isolation year dist ----------

sns.histplot(
    metadata["Isolation_year"],
    bins=20,
    ax=axes[0, 0],
    color="steelblue"
)

axes[0, 0].set_title("A. Isolates by year")
axes[0, 0].set_xlabel("Isolation year")


# ---------- B. Isolates by time periode ---------------

year_counts = (
    metadata["Year_group"]
    .value_counts()
    .sort_index()
)

sns.barplot(
    x=year_counts.index,
    y=year_counts.values,
    ax=axes[0, 1],
    color="cornflowerblue"
)

axes[0, 1].set_title("B. Isolates by period")
axes[0, 1].set_xlabel("Isolation period")
axes[0, 1].set_ylabel("Number of isolates")

axes[0, 1].tick_params(
    axis="x",
    rotation=45
)

# ---------- C. Isolate source dist ----------

source_counts = (
    metadata["Isolation_source"]
    .value_counts()
)

sns.barplot(
    x=source_counts.values,
    y=source_counts.index,
    ax=axes[1, 0],
    palette="viridis"
)

axes[1, 0].set_title("C. Isolation source")
axes[1, 0].set_xlabel("Number of isolates")
axes[1, 0].set_ylabel("")

# ----------- D. source over time ----------------

source_year = pd.crosstab(
    metadata["Year_group"],
    metadata["Isolation_source"]
)

source_year.plot(
    kind="bar",
    stacked=True,
    ax=axes[1, 1]
)

axes[1, 1].set_title("D. Isolation source by period")
axes[1, 1].set_xlabel("Isolation period")
axes[1, 1].set_ylabel("Number of isolates")

axes[1, 1].tick_params(
    axis="x",
    rotation=45
)

# ----------- final formatting -----------------

OUT_DIR = Path("figures")
OUT_DIR.mkdir(exist_ok=True)

plt.tight_layout()

plt.savefig(
    OUT_DIR / "metadata_overview.png",
    dpi=300,
    bbox_inches="tight"
)

plt.show()