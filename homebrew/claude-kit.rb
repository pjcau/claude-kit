# typed: false
# frozen_string_literal: true

class ClaudeKit < Formula
  desc "Scaffold projects with Claude Code skills, agents & hooks"
  homepage "https://github.com/pjcau/claude-kit"
  url "https://github.com/pjcau/claude-kit/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "5470a195a7306c284b2f7f06446f1836e9ed3f6cfe5ba0a6085cf8a3580fa637"
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
