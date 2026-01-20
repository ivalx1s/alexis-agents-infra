---
name: web-search
description: Search the web for current information, documentation, Stack Overflow answers, GitHub issues, and any info not in training data. Use when user asks to search/look up/find something online, check current state, or needs recent information.
---

# Web Search

Use when you need current information that's not in your training data.

## When to use
- User explicitly asks to search/google/look up something
- Need current information (news, releases, versions, docs)
- Stack Overflow, GitHub issues, error messages
- API documentation, package info
- Any "what's the latest" or "how to" questions

## Available tools
You have `web_search` and `web_fetch` tools available.

## Usage
1. Use `web_search` with concise query (1-6 words)
2. If need full page content, use `web_fetch` with URL from results
3. Synthesize answer from results

## Examples
```bash
# Search for error
web_search "swift package manager duplicate symbols"

# Get full docs page
web_fetch "https://developer.apple.com/documentation/..."

# Check current version
web_search "fastlane latest version 2025"
```

## Notes
- Keep queries short and specific
- Prefer official docs over forums when available
- Use web_fetch for complete page content if snippets insufficient
