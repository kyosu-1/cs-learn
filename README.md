# CS Learn

コンピューターサイエンスを体系的に学べるクロスプラットフォーム学習アプリ。Web / iOS / Android 対応。

## Features

- **体系的なレッスン** - マークダウン + コードブロック + 図解による段階的な教材（初級〜大学院レベル）
- **インタラクティブ可視化** - ソート、木の走査、グラフ探索のアニメーション（再生/一時停止/ステップ/速度調整）
- **クイズ** - 選択問題、穴埋め、真偽問題で知識を確認。自動採点付き
- **進捗トラッキング** - XP / レベルシステム、正答率、弱点分析

## Topics

| トピック | カテゴリ | レッスン | クイズ |
|---------|---------|---------|-------|
| アルゴリズム & データ構造 | 8 | 12 | 7 |
| オペレーティングシステム | 5 | 8 | 4 |
| コンピュータネットワーク | 5 | 6 | 4 |

## Tech Stack

| | 技術 |
|---|---|
| Frontend | React Native + Expo (Expo Router), TypeScript, Zustand, TanStack Query |
| Backend | Go (chi, pgx, golang-jwt) |
| Database | PostgreSQL 17 |
| Dev | Docker Compose |

## Getting Started

```bash
# 1. PostgreSQL を起動
docker compose up -d

# 2. バックエンドを起動（自動マイグレーション + シードデータ投入）
cd backend && go run ./cmd/server

# 3. フロントエンドを起動（別ターミナル）
cd frontend && npm install && npm start
```

- Backend API: http://localhost:8080
- Frontend (Web): http://localhost:8081

モバイルで確認する場合は Expo Go アプリで QR コードをスキャン。

## Project Structure

```
cs-learn/
├── backend/
│   ├── cmd/server/          # エントリーポイント
│   ├── internal/
│   │   ├── config/          # 環境変数
│   │   ├── handler/         # HTTP ハンドラー
│   │   ├── service/         # ビジネスロジック
│   │   ├── repository/      # データアクセス
│   │   ├── model/           # ドメインモデル
│   │   ├── router/          # ルーティング
│   │   └── db/migrations/   # SQL マイグレーション + シードデータ
│   └── go.mod
├── frontend/
│   ├── app/                 # Expo Router (画面)
│   ├── components/          # UI コンポーネント
│   ├── hooks/               # カスタムフック
│   ├── lib/                 # API クライアント, 型定義
│   └── stores/              # Zustand ストア
└── docker-compose.yml
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/v1/auth/register` | ユーザー登録 |
| POST | `/api/v1/auth/login` | ログイン |
| GET | `/api/v1/topics` | トピック一覧 |
| GET | `/api/v1/topics/:slug/categories` | カテゴリ一覧 |
| GET | `/api/v1/categories/:id/lessons` | レッスン一覧 |
| GET | `/api/v1/lessons/:id/blocks` | レッスン内容 |
| GET | `/api/v1/quizzes/:id` | クイズ + 問題 |
| POST | `/api/v1/quizzes/:id/submit` | 回答提出 (要認証) |
| GET | `/api/v1/me/progress` | 学習進捗 (要認証) |

## License

MIT
