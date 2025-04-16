
import argparse
import glob
import os
from pathlib import Path
import datetime
parser = argparse.ArgumentParser()
parser.add_argument("--name", type=str, default="", required=False)
args = parser.parse_args()
name = args.name

if name == "":
    name = input("Enter the name of the new notebook: ")

parent = Path(__file__).parent
try:
    last_name = sorted([Path(f).parent.name for f in glob.glob(str(parent / "**" / "*.ipynb"), recursive=True)])[-1]
    last_number = int(last_name.split("-")[0])
    new_number = last_number + 1
except (IndexError, ValueError):
    # Start with 1 if no directories found or parsing error
    new_number = 1
new_name = f"{new_number:04d}-{name.replace(' ', '-').lower()}"

# Create yyyy-mm folder structure
current_date = datetime.datetime.now()
date_folder_path = parent / str(current_date.year) / f"{current_date.month:02d}"
new_folder_path = date_folder_path / new_name
os.makedirs(new_folder_path, exist_ok=True)

new_file_path = new_folder_path / (new_name + ".ipynb")

with open(new_file_path, "w") as f:
    f.write("")

os.system(f"cursor {new_file_path}")












