# VoxClean AI (MATLAB Version)

## 1. Project Overview
VoxClean AI is a speech background-noise suppression project utilizing Deep Learning. This is the MATLAB-native conversion of the original Python project.

## 2. MATLAB Version Requirement
- MATLAB R2022a or newer is recommended.

## 3. Required MATLAB Toolboxes
- Deep Learning Toolbox (for model training and inference)
- Audio Toolbox (for audio processing, reading, and STFT)
- Signal Processing Toolbox (for general DSP functions)

## 4. Folder Structure
- `app/` - Contains the programmatic MATLAB GUI (`VoxCleanApp.m`)
- `data/` - Training dataset (place your WAV files in `clean/` and `noise/`)
- `models/` - Saved `.mat` network checkpoints
- `outputs/` - Generated enhanced audio and evaluations
- `src/` - Core MATLAB functions for preprocessing and ML logic
- `notebooks/` - Live Scripts for exploration (provided as `.m` files formatted for MATLAB Live Editor)

## 5. How to add the dataset
Place your clean speech `.wav` files into `data/clean/` and your background noise `.wav` files into `data/noise/`.

## 6. How to run dataset analysis
Open `notebooks/01_dataset_analysis.m` in MATLAB and run the sections.

## 7. How to preprocess data
Preprocessing logic is handled dynamically. Test it via `notebooks/02_preprocessing.m`.

## 8. How to train the model
Run `trainModel()` in the Command Window, or execute `notebooks/03_model_training.m`.
*Note:* The training script sets up the architecture. You must uncomment the training command in `src/trainModel.m` to actually run it, ensuring you don't accidentally train before data is ready.

## 9. How to evaluate the model
Run `evaluateModel()` or execute `notebooks/04_evaluation.m`.

## 10. How to use the App GUI
Run `VoxCleanApp` from the Command Window to launch the application interface.

## 11. How to enhance a new audio file
You can use the GUI, or programmatically run:
```matlab
enhanced = enhanceSpeech('path/to/noisy.wav', 'outputs/enhanced/clean.wav');
```
