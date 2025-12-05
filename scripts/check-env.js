const fs = require('fs');
const path = require('path');
const { spawn, exec } = require('child_process');
const util = require('util');
const execPromise = util.promisify(exec);

const configPath = path.join(__dirname, '..', 'project.config.json');

console.log('🔍 環境情報チェック');
console.log('='.repeat(60));
console.log('');

// Check venv
const venvPython = path.join(__dirname, '..', 'venv', 'Scripts', 'python.exe');
console.log('【venv環境】');
if (fs.existsSync(venvPython)) {
    console.log(`✅ venv Python: ${venvPython}`);

    exec(`"${venvPython}" --version`, (error, stdout, stderr) => {
        if (!error) {
            console.log(`   バージョン: ${stdout.trim()}`);
        }

        exec(`"${venvPython}" -m pip list | find /c /v ""`, (error, stdout) => {
            if (!error) {
                console.log(`   インストール済みライブラリ数: ${parseInt(stdout.trim()) - 2} パッケージ`);
            }
            console.log('');
            checkWebFOCUS();
        });
    });
} else {
    console.log(`❌ venv環境が見つかりません`);
    console.log(`   予想される場所: ${venvPython}`);
    console.log(`   セットアップ: .\\tools\\setup_env.ps1`);
    console.log('');
    checkWebFOCUS();
}

function checkWebFOCUS() {
    console.log('【WebFOCUS用Python】');

    if (!fs.existsSync(configPath)) {
        console.log('❌ project.config.json が見つかりません');
        console.log('   プロジェクトルートに project.config.json を作成してください');
        return;
    }

    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    const webfocusPythonPath = config.webfocusPythonPath;

    if (!webfocusPythonPath) {
        console.log('❌ webfocusPythonPath が設定されていません');
        return;
    }

    const pythonExe = path.join(webfocusPythonPath, 'python.exe');

    if (fs.existsSync(pythonExe)) {
        console.log(`✅ WebFOCUS Python: ${pythonExe}`);

        exec(`"${pythonExe}" --version`, (error, stdout, stderr) => {
            if (!error) {
                console.log(`   バージョン: ${stdout.trim()}`);
            }

            exec(`"${pythonExe}" -m pip list | find /c /v ""`, (error, stdout) => {
                if (!error) {
                    console.log(`   インストール済みライブラリ数: ${parseInt(stdout.trim()) - 2} パッケージ`);
                }
                console.log('');
                console.log('='.repeat(60));
                console.log('');
                console.log('💡 npm コマンド:');
                console.log('   npm run install:venv      - venv環境にライブラリをインストール');
                console.log('   npm run install:webfocus  - WebFOCUS環境にライブラリをインストール');
                console.log('   npm run install:all       - 両環境にライブラリをインストール');
                console.log('   npm run list:venv         - venv環境のライブラリ一覧');
                console.log('   npm run list:webfocus     - WebFOCUS環境のライブラリ一覧');
                console.log('   npm test                  - pytestテスト実行');
            });
        });
    } else {
        console.log(`❌ Python が見つかりません: ${pythonExe}`);
        console.log('   project.config.json の webfocusPythonPath を確認してください');
    }
}
