const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

// project.config.jsonからWebFOCUS Pythonパスを読み込む
const configPath = path.join(__dirname, '..', 'project.config.json');

if (!fs.existsSync(configPath)) {
    console.error('❌ project.config.json が見つかりません。');
    process.exit(1);
}

const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const webfocusPythonPath = config.webfocusPythonPath;

if (!webfocusPythonPath) {
    console.error('❌ project.config.json に webfocusPythonPath が設定されていません。');
    process.exit(1);
}

const pythonExe = path.join(webfocusPythonPath, 'python.exe');

if (!fs.existsSync(pythonExe)) {
    console.error(`❌ Python が見つかりません: ${pythonExe}`);
    process.exit(1);
}

console.log('📋 WebFOCUS用Python環境のライブラリ一覧:');
console.log(`Python: ${pythonExe}`);
console.log('');

const list = spawn(pythonExe, ['-m', 'pip', 'list']);

list.stdout.on('data', (data) => {
    process.stdout.write(data);
});

list.stderr.on('data', (data) => {
    process.stderr.write(data);
});

list.on('close', (code) => {
    process.exit(code);
});
