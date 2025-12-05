# WebFOCUS Python Adapter リファレンス

## Python Adapter 設定
このアダプターを使用すると、アプリケーションはローカルサーバー上でPythonスクリプトを実行できます。

アダプターにはPythonのインストールが必要です（詳細は後述）。

### Python Installation Directory (Pythonインストールディレクトリ)
Pythonインストールディレクトリのフルパス名。

### Create Synonym Parameters (シノニム作成パラメータ)

#### PYTHON Script (Pythonスクリプト)
`.py` 拡張子を持つPythonスクリプトの絶対パス。

#### Function Name (関数名)
関数名。

#### File with sample input data for the Python Script (Pythonスクリプト用サンプル入力データファイル)
メタデータを作成するために、指定されたPythonスクリプトを実行するのに必要なサンプルファイル。ファイルはWebFOCUS Reporting Serverからローカルにアクセス可能である必要があります。

#### CSV files with header (ヘッダー付きCSVファイル)
ヘッダー行の使用を無効にするには、ファイルのチェックを外します。

#### Synonym Name (シノニム名)
指定されたPythonスクリプトが提供されたサンプルデータを正常に処理した後に作成されるシノニムの名前。

---

## Python Adapter 要件とセットアップ

Pythonアダプターは **Windows x64** および **Linux Intel x64** でのみサポートされており、バージョン9.3.0以降、その他のプラットフォームではサポートされなくなりました。

さらに、バージョン9.3.0以降、Windows x64およびLinux Intel x64用のReporting Serverには、`EDAHOME etc/python` 配下にプリインストールされたPythonリリースが提供されなくなりました。

### 重要な注意点
Windowsにおいて、システムDLLの欠落によりPythonの実行に失敗するケースが報告されています。これは単に `python.exe` を実行するだけで再現でき（欠落しているDLL名を含むポップアップメッセージが表示されます）、テストによると、クリーンインストールされたWindows 10/11やWindows Server環境では発生しません。したがって、これは誤った削除、不完全なアンインストール、またはシステムアップデートが最新でないことによって引き起こされる可能性が高く、ibi™ WebFOCUS© ソフトウェアの制御外であり、調査と修正はサイト自身の責任となります。

欠落している特定のシステムDLLはマシンによって異なる場合があるため、適切な修正措置を調査する必要があります（ただし、Microsoftの最新のVisual Studio C++再頒布可能パッケージまたはUniversal C Runtimeパッケージをインストールすることで修正される可能性が高いです）。

AnacondaにはPythonリリースが含まれていますが、Anacondaベースのインストールを使用する場合は、Python 3.9.xバージョンを使用するバージョンである必要があります。アダプター設定のテストボタンはAnacondaでテストされていますが、完全にテストされた構成ではないため、推奨される構成ではありません。

### 一般的なアダプター要件とセットアップ

#### Pythonのダウンロード
- **WindowsおよびLinux Intel x64上のPython 3.9のみがサポートされています。**
- Windowsの場合は、[Python Downloads](https://www.python.org/downloads/windows/)（一般的なダウンロードページ）からダウンロードしてください。
- Linuxの場合は、[Python Downloads](https://www.python.org/downloads/source/)（一般的なダウンロードページ）からダウンロードしてください。ただし、一部のLinuxベンダーは使用可能なPython 3.9パッケージも提供しています。
- ビットバージョンは、Reporting Serverのビットサイズと一致するように **64ビット** である必要があります。

#### Pythonのインストール
- PythonはReporting Server (WFRS) と同じボックスにローカルにインストールする必要がありますが、`EDAHOME` 配下にはインストールしないでください。
- 上記のダウンロードと以下のプラットフォーム固有の手順を使用してPythonをインストールしてください。

#### Pythonパッケージの追加/更新
Pythonのインストール後、以下のパッケージをインストールしてください（手順は後述）：
`cycler`, `fonttools`, `joblib`, `kiwisolver`, `matplotlib`, `memory-profiler`, `numpy`, `packaging`, `pandas`, `patsy`, `Pillow`, `pip`, `psutil`, `pyparsing`, `python-dateutil`, `pytz`, `scikit-learn`, `scipy`, `seaborn`, `setuptools`, `six`, `statsmodels`, `threadpoolctl`, `wheel`, `xgboost`

※ これらのパッケージの一部は、追加のパッケージを自動的に取り込むことに注意してください。

サーバーのPythonアダプター設定ページで、Pythonインストール場所を指定し、「Configure」ボタンをクリックします。

サーバーを再起動します（Workspace -> Server Actions -> Restart）。アダプターとテストボタンを有効にするには再起動が必要です。
サーバーの再起動時に、該当する場所がサーバーのPATH（およびLinuxの場合はライブラリパス）に自動的に追加されます。

### WindowsでのPythonインストールと設定
*(Reporting Serverの起動/再起動前)*

インストールする推奨の最小Python 3.9.xリリースレベルは、Python 3.9.13のビルド済みWindowsインストーラーx64リリースです。

1. カスタムインストールを行う場合は、**pipオプションの選択を解除しないでください**。
2. デフォルトのWindowsインストールディレクトリは、Python GUIインストーラーの最初の画面に表示されます。このドキュメントではこれを `{pythoninstallpath}` と呼びます。
3. カスタムインストールを行い、インストール場所を変更する場合は、後の手順で `{pythoninstallpath}` を参照するためにその場所をメモしておいてください。
4. "add to PATH option"（PATHに追加するオプション）のチェックは必須ではありません。他の目的でこの機能が必要な場合に選択してください。
5. Pythonがすでにインストールされており、場所が不明な場合、デフォルトの場所は `%USERPROFILE%\appdata\local\programs\python\python39` の解決された値です。そうでない場合は、マシンで `python39.exe` を検索する必要があります。

**アダプターを使用する前に、以下のコマンド（DOSコマンドウィンドウ）を使用して追加のPythonパッケージをインストールしてください:**

```cmd
{pythoninstallpath}\python.exe -m pip install cycler fonttools joblib kiwisolver matplotlib memory-profiler numpy packaging pandas patsy Pillow pip psutil pyparsing python-dateutil pytz scikit-learn scipy seaborn setuptools six statsmodels threadpoolctl wheel xgboost
```

または

```cmd
{pythoninstallpath}\python.exe -m pip install --upgrade --force-reinstall cycler fonttools joblib kiwisolver matplotlib memory-profiler numpy packaging pandas patsy Pillow pip psutil pyparsing python-dateutil pytz scikit-learn scipy seaborn setuptools six statsmodels threadpoolctl wheel xgboost
```

アップグレードする場合、またはインストールが破損している可能性がある場合は、2番目の形式のコマンドを使用してください。

**以下のコマンド（DOSコマンドウィンドウ）を使用して、インストールされたPythonパッケージを確認します:**

```cmd
{pythoninstallpath}\python.exe -m pip list
```

Pythonドキュメントに従った追加のPython環境設定（PYTHONPATHなど）は許可されていますが、必須ではありません。これらの変数は、サーバーの起動前にシステムレベルで設定するか、サーバーの `edaenv.cfg` 環境設定ファイルで設定できますが、設定された値がサーバーが必要とする標準パッケージまたはリリースレベルへのアクセスを妨げないようにする必要があります。

サーバーのデータソースアダプター設定ページで、Pythonインストールディレクトリ (`{pythoninstallpath}`) を指定し、「Configure」ボタンをクリックしてサーバーを再起動（リサイクル）します。

※ Windowsでは、`{pythoninstallpath}` ディレクトリは具体的には `python.exe` コマンドライン実行可能ファイルと `python*.dll` DLLを含むディレクトリです。

### LinuxでのPythonインストールと設定
*(Reporting Serverの起動/再起動前)*

インストールする推奨の最小Python 3.9.xリリースレベルは、Python 3.9.16の「ソースからのビルド」リリースです。

LinuxのPythonリリースは通常、ソースビルドか、該当するLinuxベンダーからの「パッケージ済み」ビルドのいずれかであり、一般的にシステム管理者によるビルド/インストールが必要です。
通常、Linuxシステムには、オペレーティングシステムが一部の機能に使用するあるレベルのPythonがプリインストールされています。そのため、システム管理者は通常、元のデフォルトのPythonバージョンを別のPythonリリースで変更することを望みません。したがって、管理者は通常、`configure --prefix=` オプションを使用して、`/usr/local/python39` などのPATH上にない別の場所にビルド/インストールします。このインストール場所はこのドキュメントでは `{pythoninstallpath}` と呼ばれ、使用された場所はインストールを行った管理者から入手する必要があります。

**一般的なビルド手順:**

```bash
cd $HOME
wget -c https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tgz
tar -xzf Python-3.9.13.tgz
cd python-3.9.13-sources
./configure "--srcdir=`pwd`" --enable-shared "--prefix=/usr/local/python39" --with-openssl=/usr/local/ssl64/1.1.1 --with-openssl-rpath=auto
make clean
make
make quicktest
make altinstall
```

- `--enable-shared` オプションは、.so DLLを作成するために必要です。
- `--prefix={dir}` オプションは、別の場所にインストールするために必要です。
- `--with-openssl={dir}` オプションは、指定しないと多くの機能のビルドに失敗するため必要です（SSLの実際の場所を使用してください）。
- `--with-openssl-rpath=auto` オプションもSSLのために必要です。

Linuxでは、`patchelf` ツール（インストールされていない場合はインストールしてください）を使用して、`python` コマンドとそのコアDLLの `$ORIGIN` を設定する必要があります。これにより、ソフトウェアの一般的な使用に `LD_LIBRARY_PATH` の設定が不要になります。

**`patchelf` 手順の例（実際のインストール済みPython場所に合わせて調整してください）:**

```bash
patchelf --set-rpath '$ORIGIN' /usr/local/python39/lib/libpython3.so
patchelf --set-rpath '$ORIGIN/../lib' /usr/local/python39/bin/python3.9
```

**アダプターを使用する前に、以下を使用して追加のPythonパッケージをインストールしてください:**

```bash
{pythoninstallpath}/bin/python -m pip install cycler fonttools joblib kiwisolver matplotlib memory-profiler numpy packaging pandas patsy Pillow pip psutil pyparsing python-dateutil pytz scikit-learn scipy seaborn setuptools six statsmodels threadpoolctl wheel xgboost
```

または

```bash
{pythoninstallpath}/bin/python -m pip install --upgrade --force-reinstall cycler fonttools joblib kiwisolver matplotlib memory-profiler numpy packaging pandas patsy Pillow pip psutil pyparsing python-dateutil pytz scikit-learn scipy seaborn setuptools six statsmodels threadpoolctl wheel xgboost
```

アップグレードする場合、またはインストールが破損している可能性がある場合は、2番目の形式のコマンドを使用してください。

**以下を使用して、インストールされたPythonパッケージを確認します:**

```bash
{pythoninstallpath}/bin/python -m pip list
```

Pythonドキュメントに従った追加のPython環境設定（PYTHONPATHなど）は許可されていますが、必須ではありません。これらの変数は、サーバーの起動前またはサーバーの `edaenv.cfg` 環境設定ファイルで設定できますが、設定された値がサーバーが必要とする標準パッケージまたはリリースレベルへのアクセスを妨げないようにする必要があります。

アダプター設定ページで、Pythonインストールディレクトリ (`{pythoninstallpath}`) を指定し、「Configure」ボタンをクリックしてサーバーを再起動（リサイクル）します。

※ UNIX/Linuxでは、`{pythoninstallpath}` ディレクトリは具体的には `bin/python` 実行可能ファイルの親ディレクトリであり、`.so` Python DLLを含む `lib` ディレクトリ（および親ディレクトリ内のその他のディレクトリ）を含むディレクトリです。
