![アプリアイコン](assets/ic_launch.png)  
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&style=flat&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&style=flat&logoColor=white)

# RecordToTalk
[record-to-text](https://github.com/hotdrop/record-to-text)の会話録音版です。
record-to-textと同様`Flutter for macOS`でアプリを作っているのでMacでのみ動作します。
単に会話を録音して画面表示するのみとしローカルストレージへの保存はありません。検証のため機能を必要最小限としています。
文字起こしの間隔は設定画面でカスタマイズできます。

# 設計
基本的には`record-to-text`と同じで、オーディオインタフェースの入力と出力を同時に録音するよう`RecordController`を2つ並走しています。

# スクリーンショット
