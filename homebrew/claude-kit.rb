# typed: false
# frozen_string_literal: true

class ClaudeKit < Formula
  desc "Scaffold projects with Claude Code skills, agents & hooks"
  homepage "https://github.com/pjcau/claude-kit"
  url "https://github.com/pjcau/claude-kit/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "319647bd7bfbe826a51a8eeb5fbb0f48e22653df3932f01f36c2b0c5881abc6c"
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
