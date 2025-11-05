import gzip
import csv
import sys
import os

def is_gzipped(file_path):
    """
    Check if the file is gzipped by reading its magic number.
    """
    with open(file_path, 'rb') as f:
        magic = f.read(2)
    return magic == b'\x1f\x8b'


def filter_tsv(input_file, output_file, column1, threshold1, column2, threshold2):
    # Counters for reporting
    total_rows = 0
    removed_by_threshold1 = 0
    removed_by_threshold2 = 0
    retained_rows = 0

    # Determine if input file is gzipped
    open_func = gzip.open if is_gzipped(input_file) else open
    write_func = gzip.open if output_file.endswith(".gz") else open

    # Open the input file
    with open_func(input_file, 'rt', encoding='utf-8') as infile:
        reader = csv.DictReader(infile, delimiter=' ')

        # Open the output file
        with write_func(output_file, 'wt', encoding='utf-8', newline='') as outfile:
            writer = csv.DictWriter(outfile, fieldnames=reader.fieldnames, delimiter='\t')
            writer.writeheader()

            # Filter and write rows
            for row in reader:
                total_rows += 1
                try:
                    col1_value = float(row[column1]) if column1 in row else None
                    col2_value = float(row[column2]) if column2 in row else None

                    # Evaluate conditions
                    cond1 = True if threshold1 is None else (col1_value is not None and col1_value >= threshold1)
                    cond2 = True if threshold2 is None else (col2_value is not None and col2_value >= threshold2)

                    if not cond1:
                        removed_by_threshold1 += 1
                    if not cond2:
                        removed_by_threshold2 += 1

                    # Write the row if it satisfies both conditions
                    if cond1 and cond2:
                        writer.writerow(row)
                        retained_rows += 1
                except ValueError:
                    # Skip rows where numeric conversion fails
                    continue

    # Print the filtering report
    print("Filtering Report:")
    print(f"  Total rows processed: {total_rows}")
    print(f"  Rows removed by {column1} < {threshold1}: {removed_by_threshold1}")
    print(f"  Rows removed by {column2} < {threshold2}: {removed_by_threshold2}")
    print(f"  Rows retained: {retained_rows}")


if __name__ == "__main__":
    DEFAULT_THRESHOLD1 = 0.01  # Default threshold for column1
    DEFAULT_THRESHOLD2 = 0.6  # Default threshold for column2

    if len(sys.argv) < 5 or len(sys.argv) > 7:
        print("Usage: python filter_tsv.py <input_file> <output_file> <column1> <threshold1> <column2> <threshold2>")
        print("Set threshold1 or threshold2 to 'None' to skip filtering for that column.")
        print("Omit threshold arguments to use default thresholds.")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    column1 = sys.argv[3]
    threshold1 = (
        float(sys.argv[4]) if len(sys.argv) > 4 and sys.argv[4].lower() != "none" else DEFAULT_THRESHOLD1
    )
    column2 = sys.argv[5] if len(sys.argv) > 5 else None
    threshold2 = (
        float(sys.argv[6]) if len(sys.argv) > 6 and sys.argv[6].lower() != "none" else DEFAULT_THRESHOLD2
    )

    filter_tsv(input_file, output_file, column1, threshold1, column2, threshold2)
