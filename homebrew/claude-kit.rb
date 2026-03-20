# typed: false
# frozen_string_literal: true

class ClaudeKit < Formula
  desc "Scaffold projects with Claude Code skills, agents & hooks"
  homepage "https://github.com/pjcau/claude-kit"
  url "https://github.com/pjcau/claude-kit/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2f0f94257fee71bd8b688329be9f9a0f9d71147f29784c1f2a7f3f1a49c28c5c"
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
