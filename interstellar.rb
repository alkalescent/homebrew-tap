# typed: false
# frozen_string_literal: true

# Homebrew formula for interstellar
# Auto-generated from .github/templates/formula.rb.template
# Supports both release (url/sha256) and HEAD (head) modes

class Interstellar < Formula
  include Language::Python::Virtualenv

  desc "A command-line tool for managing cryptocurrency mnemonics using BIP39 and SLIP39 standards"
  homepage "https://github.com/alkalescent/interstellar"
  url "https://github.com/alkalescent/interstellar/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "756ce7e8e7257cccd1bfd6c4672cad3ccbf406bc41f1a47f4a0cff7ac9ddb8b7"
  head "https://github.com/alkalescent/interstellar.git", branch: "master"
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
    bin.install_symlink Dir[libexec/"bin/interstellar"]
  end

  test do
    # Test version command
    assert_match(/v\d+\.\d+\.\d+/, shell_output("#{bin}/interstellar version"))

    # Test help command shows expected subcommands
    help_output = shell_output("#{bin}/interstellar --help")
    assert_match "deconstruct", help_output
    assert_match "reconstruct", help_output
  end
end
