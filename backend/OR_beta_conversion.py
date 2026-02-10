import pandas as pd
import numpy as np
import argparse

def convert_or_to_beta(gwas_file, output_file):
    # Load GWAS summary statistics
    try:
        gwas_data = pd.read_csv(gwas_file, sep='\t')
    except FileNotFoundError:
        raise FileNotFoundError(f"The file {gwas_file} does not exist. Please check the file path.")
    
    # Check if the required columns exist
    if 'OR' not in gwas_data.columns:
        raise ValueError("The GWAS file does not contain an 'OR' (Odds Ratio) column.")
    
    if 'SNP' not in gwas_data.columns:
        raise ValueError("The GWAS file does not contain an 'SNP' column.")
    
    # Convert OR to Beta (log(OR))
    gwas_data['Beta'] = np.log(gwas_data['OR'])
    
    # Reorder columns so Beta appears after OR
    columns = gwas_data.columns.tolist()
    if 'Beta' in columns:
        columns.remove('Beta')
    columns.insert(columns.index('OR') + 1, 'Beta')
    
    gwas_data = gwas_data[columns]
    
    # Save to new file
    gwas_data.to_csv(output_file, sep='\t', index=False)
    print(f"GWAS file with Beta values saved to {output_file}")

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(description='Convert GWAS OR column to Beta.')
    
    # Define input file argument
    parser.add_argument('gwas_file', type=str, help='Path to the GWAS summary statistics file (tab-delimited).')
    
    # Define output file argument
    parser.add_argument('output_file', type=str, help='Path to save the output file with Beta values.')
    
    # Parse the command line arguments
    args = parser.parse_args()
    
    # Call the function to convert OR to Beta
    convert_or_to_beta(args.gwas_file, args.output_file)

# Execute the script from the command line
if __name__ == "__main__":
    main()

