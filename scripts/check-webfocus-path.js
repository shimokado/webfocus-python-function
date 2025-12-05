const fs = require('fs');
const path = require('path');

const configPath = path.join(__dirname, '..', 'project.config.json');

console.log('🔍 WebFOCUS Python パス設定の確認');
console.log('='.repeat(60));
console.log('');

if (!fs.existsSync(configPath)) {
    console.log('❌ project.config.json が見つかりません');
    console.log('');
    console.log('📝 設定ファイルの作成が必要です:');
    console.log('');
    console.log('プロジェクトルートに project.config.json を作成し、以下の内容を記述してください:');
    console.log('');
    console.log('{');
    console.log('  "webfocusPythonPath": "C:\\\\Users\\\\<username>\\\\AppData\\\\Local\\\\Programs\\\\Python\\\\Python39"');
    console.log('}');
    console.log('');
    console.log('💡 パスの見つけ方:');
    console.log('1. WebFOCUS Hubでアダプタ設定画面を開く');
    console.log('2. Pythonアダプタのプロパティを表示');
    console.log('3. 表示されているパスをコピー');
    console.log('');
    console.log('詳細は docs/09_python_adapter_configuration.md を参照してください');
    process.exit(1);
}

const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const webfocusPythonPath = config.webfocusPythonPath;

if (!webfocusPythonPath) {
    console.log('❌ webfocusPythonPath が project.config.json に設定されていません');
    console.log('');
    console.log('project.config.json を以下のように編集してください:');
    console.log('');
    console.log('{');
    console.log('  "webfocusPythonPath": "C:\\\\Users\\\\<username>\\\\AppData\\\\Local\\\\Programs\\\\Python\\\\Python39"');
    console.log('}');
    process.exit(1);
}

const pythonExe = path.join(webfocusPythonPath, 'python.exe');

console.log(`設定されているパス: ${webfocus PythonPath}`);
console.log(`Python実行ファイル: ${ pythonExe }`);
console.log('');

if (fs.existsSync(pythonExe)) {
    console.log('✅ Python が見つかりました');
    
    const { spawn } = require('child_process');
    const version = spawn(pythonExe, ['--version']);
    
    version.stdout.on('data', (data) => {
        console.log(`📌 ${ data.toString().trim() }`);
    });
    
    version.stderr.on('data', (data) => {
        console.log(`📌 ${ data.toString().trim() }`);
    });
    
    version.on('close', (code) => {
        if (code === 0) {
            console.log('');
            console.log('💡 この Python環境が WebFOCUS で使用されます');
            console.log('   npm run install:webfocus でライブラリをインストールできます');
        }
        process.exit(code);
    });
} else {
    console.log('❌ Python が見つかりません');
    console.log('');
    console.log('project.config.json の webfocusPythonPath を確認してください:');
    console.log(`現在の設定: ${ webfocusPythonPath }`);
    console.log(`確認した場所: ${ pythonExe }`);
    process.exit(1);
}
