# homebrew-tap

Homebrew formulae for [ianjwhite99](https://github.com/ianjwhite99) projects.

```bash
brew tap ianjwhite99/tap
```

## Formulae

| Formula | Description |
| --- | --- |
| [`opencode-with-claude`](Formula/opencode-with-claude.rb) | [OpenCode](https://opencode.ai) plugin to use your Claude Max subscription via the Meridian proxy |

```bash
brew install ianjwhite99/tap/opencode-with-claude
```

After installing, `brew info opencode-with-claude` prints the `file://` plugin
path to add to your `opencode.json`. See the
[opencode-with-claude README](https://github.com/ianjwhite99/opencode-with-claude#quick-start)
for the full setup.

## Updating

```bash
brew update && brew upgrade
```

Formula versions are bumped automatically by the release workflow of each
project, so `brew upgrade` tracks new releases.
