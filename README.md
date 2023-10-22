# web-site-checker

簡易Webサイト監視用Lambda

## 構成

```
[EventBridge] --定期実行--> [Lambda] --Webページ取得--> [監視対象Webページ]
                               |
                         履歴データ管理
                               |
                           [DynamoDB]
```

## デプロイ

* SAM用のバケットを作成しておく
* `samconfig.toml` を生成

```sh
sed -e 's/@@env@@/<任意>/' -e 's/@@bucket@@/<SAM用バケット名>/' samconfig.tmpl.toml > samconfig.toml
```

* 下記コマンドでビルド、デプロイする

```sh
sam build
sam package
sam deploy
```

## 設定

EventBridgeで `{env}-web-site-checker-function` をターゲットにした定期実行ルールを作成する  
その際の入力で対象URL、xpathを渡す

```json
例)

{
  "url": "https://example.com/",
  "xpath": "//div[@class=\"hoge\"]",
  "subject": "Webサイト監視"
}
```

Amazon SNSにて `{env}-web-site-checker-notification` のサブスクリプションを作成する
