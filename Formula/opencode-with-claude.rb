# Homebrew formula for opencode-with-claude.
#
# The `url` and `sha256` lines are rewritten automatically by the Release
# workflow in ianjwhite99/opencode-with-claude after each npm publish
# (scripts/update-homebrew-formula.sh in that repository). Do not edit them
# by hand.
class OpencodeWithClaude < Formula
  desc "OpenCode plugin to use your Claude Max subscription via Meridian proxy"
  homepage "https://github.com/ianjwhite99/opencode-with-claude"
  url "https://registry.npmjs.org/opencode-with-claude/-/opencode-with-claude-1.10.0.tgz"
  sha256 "a02756b412ff37ec724a077d1c001bd03122b76771523dfe6942527f1c3e390a"
  license "MIT"

  depends_on "node"

  def install
    # Installs the published package (prebuilt dist/) and its runtime
    # dependencies (Meridian, the Claude Agent SDK, ...) into
    # libexec/lib/node_modules/opencode-with-claude. The package ships no
    # executable, so nothing is linked into bin.
    system "npm", "install", *std_npm_args
  end

  # Version-stable path to the plugin entry point. `opt_libexec` survives
  # `brew upgrade`, so users only ever configure this path once.
  def plugin_entry
    opt_libexec/"lib/node_modules/opencode-with-claude/dist/index.js"
  end

  def caveats
    <<~EOS
      Add the plugin to your OpenCode config (~/.config/opencode/opencode.json):

        {
          "$schema": "https://opencode.ai/config.json",
          "plugin": ["file://#{plugin_entry}"],
          "provider": {
            "anthropic": {
              "options": {
                "baseURL": "http://127.0.0.1:3456",
                "apiKey": "dummy"
              }
            }
          }
        }

      The plugin needs the Claude Code CLI and an authenticated Claude Max
      session:

        brew install --cask claude-code   # or: npm install -g @anthropic-ai/claude-code
        claude auth login

      `brew upgrade opencode-with-claude` updates the plugin in place; the
      path above does not change between versions.
    EOS
  end

  test do
    entry = libexec/"lib/node_modules/opencode-with-claude/dist/index.js"
    assert_path_exists entry

    # Importing the module must succeed and expose the plugin factory without
    # starting the proxy (that only happens when OpenCode calls the factory).
    script = "import('#{entry}').then(m => console.log(Object.keys(m).join(',')))"
    assert_match "ClaudeMaxPlugin", shell_output("node -e \"#{script}\"")
  end
end
