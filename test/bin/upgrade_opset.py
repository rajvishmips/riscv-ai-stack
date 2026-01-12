import argparse
import onnx
from onnx import version_converter

def main():
    # Create argument parser
    parser = argparse.ArgumentParser(description='Process input and output files')
    
    # Add arguments
    parser.add_argument('-i', '--input', required=True, help='Input file name')
    parser.add_argument('-o', '--output', required=True, help='Output file name')
    
    # Parse arguments
    args = parser.parse_args()
    
    # Access the file names
    input_file = args.input
    output_file = args.output
    
    print(f"Input file: {input_file}")
    print(f"Output file: {output_file}")
    
    model = onnx.load(input_file)
    print(f"Current opset: {model.opset_import[0].version}")

    # Convert to opset 17 (recommended)
    converted_model = version_converter.convert_version(model, 17)

    # Save the upgraded model
    onnx.save(converted_model, output_file)

if __name__ == "__main__":
    main()
