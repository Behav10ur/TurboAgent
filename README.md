# TurboAgent

Русская версия: [README.ru.md](README.ru.md)

TurboAgent is a terminal agent written in Swift that works with a **local LLM — no cloud involved**. It is a mini-agent for mini-tasks you can start and walk away from: it is designed to run unattended, unlike cloud agents (Claude Code, Codex) that need supervision. It is not a replacement for cloud agents — more of a complement for small local jobs.

**Status: work in progress (pre-MVP).** Stage 1 is done and lives in this repo: the package skeleton, the `@main` entry point and an interactive REPL. The model integration and file tools are not implemented yet. There is deliberately no roadmap — the project is early-stage and may change or stop at any time.

## Backend: TurboFieldfare + Gemma

The backend is **TurboFieldfare**, a local inference server (a separate project in `~/Developer/turbo-fieldfare`). It serves the quantized model **`gemma-4-26b-a4b-it`** (`gemma4.gturbo`) at `http://127.0.0.1:8080/v1` — an OpenAI-compatible chat-completions API with `/health` and `/v1/models` endpoints; no API key is required. Gemma only, no other models.

The model file itself (`gemma4.gturbo`, ~14 GB) is not in this repo and is not fetched automatically — download it beforehand and place it as `scratch/gemma4.gturbo` inside the TurboFieldfare project. Run the server with: `.build/release/TurboFieldfareServer --model scratch/gemma4.gturbo --port 8080`.

The client integration in this repo is not implemented yet.

## What works today

- Build and run: `swift build` / `swift run turboagent`
- Interactive REPL: banner with the working directory, prompt, and commands:
  - `/help` — list commands
  - `/exit` or `/quit` — quit (Ctrl+D works too)
- Plain input is echoed back (`you: ...`) for now — a placeholder until the model is connected
- Colored output in a terminal, clean plain text when piped

## Design principles

The agent itself is not implemented yet — these are the principles it will follow:

- Text protocol (`@READ path`, `@EDIT` blocks with search/replace) instead of JSON function calling
- Edits are search/replace only — files are never rewritten wholesale
- The transcript is strictly append-only, for prefix reuse on the server
- No interactive y/n while working — the mode is set by a CLI flag at startup
- Plain colored REPL, no TUI or alternate screen

## Requirements

- macOS 14+
- Swift 6.x toolchain
- Dependency: [swift-argument-parser](https://github.com/apple/swift-argument-parser) (pinned in `Package.resolved`)

## Quick start

```bash
git clone https://github.com/Behav10ur/TurboAgent.git
cd TurboAgent
swift build
swift run turboagent
```

Or run the built binary directly: `.build/debug/turboagent`

Note: what is in this repo right now (stage 1, the REPL shell) runs without the model. To actually talk to the model, you will also need the TurboFieldfare server running with the model file in place — see Backend above.

## Repository layout

```
├── Package.swift            — package manifest (executable target "turboagent")
├── Sources/turboAgent/
│   ├── TurboAgent.swift     — @main entry point, passes the current directory to the REPL
│   └── REPL.swift           — input loop, slash-commands, TTY-aware ANSI styles
├── Tests/turboAgentTests/   — swift-testing placeholder
└── Notes.md                 — notes on the chat-completion response schema
```

## Contributing

Issues and pull requests are welcome. If you want to look around, finish something, or take the project in your own direction — feel free to.
