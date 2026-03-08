# typed: false
# frozen_string_literal: true

# Homebrew formula for silicon
# Auto-generated from .github/templates/formula.rb.template
# Supports both release (url/sha256) and HEAD (head) modes

class Silicon < Formula
  include Language::Python::Virtualenv

  desc "A Python CLI hello world template"
  homepage "https://github.com/alkalescent/silicon"
  url "https://github.com/alkalescent/silicon/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "792f92f9f964b53bc44f9ce9e8c4bb5bfbefb1444159a1e022eca43d370dfe15"
  head "https://github.com/alkalescent/silicon.git", branch: "master"
  license "MIT"

  depends_on "python@3.13"
  depends_on "uv" => :build

  def install
    # Point uv's venv at Homebrew's libexec directory and use a local cache
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec.to_s
    ENV["UV_CACHE_DIR"] = (buildpath/".uv_cache").to_s
    # Install dependencies first (without pretend version to avoid leaking into deps)
    system "uv", "sync", "--frozen", "--no-dev", "--no-editable", "--no-install-project", "--python", "python3.13"
    # Set version for setuptools-scm since archive tarballs lack .git metadata
    # Skip for HEAD builds — they use git clone, so setuptools-scm reads tags directly
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s unless build.head?
    # Install project (dependencies already satisfied, won't be rebuilt)
    system "uv", "sync", "--frozen", "--no-dev", "--no-editable", "--python", "python3.13"

    # Create wrapper scripts in bin that use the venv
    bin.install_symlink Dir[libexec/"bin/silicon"]
  end

  test do
    # Test version command
    assert_match(/v\d+\.\d+\.\d+/, shell_output("#{bin}/silicon version"))

    # Test help command shows expected subcommands
    help_output = shell_output("#{bin}/silicon --help")
    assert_match "hello", help_output
    assert_match "goodbye", help_output
  end
end
