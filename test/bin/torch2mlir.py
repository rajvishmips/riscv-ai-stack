#!/usr/bin/env python3
import argparse
import os
import sys
import torch
import importlib.util
from torch_mlir.fx import export_and_import

def parse_arguments():
    parser = argparse.ArgumentParser(description = "Compile a PyTorch model to MLIR using Torch-MLIR Fx importer")
    parser.add_argument('--model-file',
                         type=str,
                         required=True,
                         help='Path to the Pytorch Model file.'
                        )
    parser.add_argument('--dialect',
                        type=str,
                        required=True,
                        choices=['linalg','tosa','torch','stablehlo'],
                        help='Target MLIR dialect'
                        )
    parser.add_argument('--dest-dir',
                        type=str,
                        required = True,
                        help ='Destination Directory for the compiled MLIR file'
                        )
    parser.add_argument('--model-def',
                        type=str,
                        required = True,
                        help = 'Path to the Python file containing Model Class definition'
                        )
    return parser.parse_args()

    
def load_model_class(model_def_path, class_name):
    spec = importlib.util.spec_from_file_location("model_def", model_def_path)
    if spec is None:
        raise ImportError(f"Cannot find module at {model_def_path}")
    module = importlib.util.module_from_spec(spec) 
    spec.loader.exec_module(module)
    if not hasattr(module, class_name):
        raise AttributeError(f"Module '{model_def_path}' does not have a class named '{class_name}'")
    return getattr(module, class_name)

def main():

    args = parse_arguments()
    if not os.path.isfile(args.model_file):
        print(f"Error: Model file '{args.model_file}' does not exist")
        sys.exit(1)
    if not os.path.isdir(args.dest_dir):
        print(f"Error: Destination directory' {args.dest_dir} 'does not exist")
        sys.exit(1)
    
    model_filename = os.path.basename(args.model_file)
    model_name,_ = os.path.splitext(model_filename)
    class_name = model_name

    try:
        ModelClass = load_model_class(args.model_def,class_name)
    except Exception as e:
        print(f"Error loading model class '{class_name}': {e}")
        sys.exit(1)
    
    model = ModelClass()
    try:
        state_dict = torch.load(args.model_file)
        model.load_state_dict(state_dict)
        model.eval()
    except Exception as e:
        print(f"Error loading the model state_dict: {e}")
        sys.exit(1)

    # Create a sample input tensor
    # Adjust the input size as per your model's requirement
    example_input = torch.randn(1, 3, 224, 224)

    # Map dialect to output_type
    dialect_map = {
        'linalg': 'linalg-on-tensors',
        'tosa': 'tosa',
        'torch': 'torch',
        'stablehlo': 'stablehlo'
    }
    output_type = dialect_map[args.dialect]

    #Compile the model to MLIR
    try:
        mlir_module = export_and_import(model,example_input,output_type=output_type)
    except Exception as e:
        print(f"Error during MLIR compilation: {e} ")
        sys.exit(1)

    #Generate the output MLIR file path
    output_filename  = f"{model_name}_{args.dialect}_mlir.mlir"
    out_file = os.path.join(args.dest_dir,output_filename)
    
    print("Saving to Output file = ",out_file)
    try:
        with open(out_file,"w") as f:
            f.write(str(mlir_module))
        print(f"MLIR file saved to {out_file} ")
    except Exception as e:
        print(f" Error saving the MLIR file: {e} ")
        sys.exit(1)
if __name__ == "__main__":
    main()
    
    
        


