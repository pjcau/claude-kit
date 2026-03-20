# typed: false
# frozen_string_literal: true

class ClaudeKit < Formula
  desc "Scaffold projects with Claude Code skills, agents & hooks"
  homepage "https://github.com/pjcau/claude-kit"
  url "https://github.com/pjcau/claude-kit/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "25ad5266f67a2e0fb381259dd203cff15e7454e2a296619a9a615a9fb8d50130"
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
