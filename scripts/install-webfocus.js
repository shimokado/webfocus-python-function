const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

// project.config.jsonからWebFOCUS Pythonパスを読み込む
const configPath = path.join(__dirname, '..', 'project.config.json');

if (!fs.existsSync(configPath)) {
    console.error('❌ project.config.json が見つかりません。');
    console.error('プロジェクトルートに project.config.json を作成し、WebFOCUS Python パスを設定してください。');
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
    console.error('project.config.json の webfocusPythonPath を確認してください。');
    process.exit(1);
}

console.log('📦 WebFOCUS用Python環境にライブラリをインストールしています...');
console.log(`Python: ${pythonExe}`);
console.log('');

const install = spawn(pythonExe, ['-m', 'pip', 'install', '-r', 'requirements.txt']);

install.stdout.on('data', (data) => {
    process.stdout.write(data);
});

install.stderr.on('data', (data) => {
    process.stderr.write(data);
});

install.on('close', (code) => {
    if (code === 0) {
        console.log('');
        console.log('✅ WebFOCUS用Python環境へのライブラリインストールが完了しました。');
        console.log('⚠️  WebFOCUS Serverの再起動を忘れずに実行してください。');
    } else {
        console.error('❌ ライブラリのインストールに失敗しました。');
        process.exit(code);
    }
});
