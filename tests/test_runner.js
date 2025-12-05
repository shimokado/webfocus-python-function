const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

// Configuration
const SRC_DIR = path.join(__dirname, '../src');
const SAMPLES_DIR = path.join(__dirname, '../samples');
const OUTPUT_DIR = path.join(__dirname, '../outputs');

// Ensure output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR);
}

console.log('Starting WebFOCUS Python Function Tests...');
console.log('----------------------------------------');

// List of tests to run
// Format: { script: 'path/to/script.py', func: 'function_name', input: 'path/to/input.csv', output: 'path/to/output.csv' }
// Note: This simple runner assumes the Python script has a main block or we call it via python -c
// For simplicity, we'll just run the python scripts that have __main__ blocks or use a wrapper.

// Since our scripts might not all have __main__ blocks configured for CLI args, 
// we will use a small python wrapper to invoke them dynamically.

const runTest = (scriptRelPath, funcName, inputRelPath, outputRelPath) => {
    const scriptPath = path.join(SRC_DIR, scriptRelPath);
    const inputPath = path.join(SAMPLES_DIR, inputRelPath);
    const outputPath = path.join(OUTPUT_DIR, outputRelPath);
    
    // Python wrapper code to import and run the function
    const pythonCode = `
import sys
import os
sys.path.append(r'${SRC_DIR}')
from ${scriptRelPath.replace('.py', '').replace('/', '.').replace('\\', '.')} import ${funcName}

print(f"Running ${funcName}...")
try:
    ${funcName}(r'${inputPath}', r'${outputPath}')
    print("Success")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
`;

    const pythonProcess = spawn('python', ['-c', pythonCode]);

    pythonProcess.stdout.on('data', (data) => {
        console.log(`[${funcName}] ${data.toString().trim()}`);
    });

    pythonProcess.stderr.on('data', (data) => {
        console.error(`[${funcName}] Error: ${data.toString().trim()}`);
    });

    pythonProcess.on('close', (code) => {
        if (code === 0) {
            console.log(`[${funcName}] Passed ✅`);
        } else {
            console.log(`[${funcName}] Failed ❌`);
        }
    });
};

// Define tests
runTest('basic/newfunc.py', 'kakezan', 'sample.csv', 'newfunc_kakezan_test.csv');
runTest('basic/newfunc.py', 'median', 'sample.csv', 'newfunc_median_test.csv');
// Add more tests as needed
