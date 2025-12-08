# IoTデータ統合と異常検知

## 概要

IoTデバイスからのセンサーデータを統合し、機械学習で異常を検知する関数。予知保全により、DXによる設備管理の効率化を実現。

## 必要なライブラリ

- pandas>=1.5.0
- scikit-learn>=1.0.0
- numpy>=1.21.0

## コードサンプル

```python
import csv
import pandas as pd
from sklearn.ensemble import IsolationForest
import numpy as np

def iot_data_integration_anomaly_detection(csvin, csvout):
    df = pd.read_csv(csvin)
    # センサーデータの異常検知
    features = df[['temperature', 'vibration', 'pressure']]
    model = IsolationForest(contamination=0.1)
    df['anomaly_score'] = model.fit_predict(features)
    df['is_anomaly'] = df['anomaly_score'] == -1
    
    # 異常データをフィルタ
    anomalies = df[df['is_anomaly']]
    anomalies.to_csv(csvout, index=False)
```

## 出来るようになること

- IoTデータの自動統合
- リアルタイム異常検知
- 予知保全の実現

## 企業データを用いた具体的な未来

製造設備のIoTデータを統合し、異常を自動検知。故障前の予防メンテナンスが可能になり、ダウンタイムを80%削減。DX推進により、人的監視からデータ駆動型管理へ移行。将来はデジタルツインと組み合わせ、仮想空間でのシミュレーション最適化を追加し、スマートファクトリーを実現。
