# typed: false
# frozen_string_literal: true

class ClaudeKit < Formula
  desc "Scaffold projects with Claude Code skills, agents & hooks"
  homepage "https://github.com/pjcau/claude-kit"
  url "https://github.com/pjcau/claude-kit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "092fdaec9e3fe6587b62aaefa095a804e1be59510ac217c00f092adcefb77b21"
  license "MIT"

  depends_on "git"

  def install
    bin.install "bin/claude-kit"
    # Install data files so `claude-kit list` works outside a project
    (share/"claude-kit").install "skills", "agents", "hooks", "templates", "settings.json"
  end

  test do
    assert_match "claude-kit", shell_output("#{bin}/claude-kit version")
  end
end
