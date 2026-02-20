# typed: false
# frozen_string_literal: true

# Homebrew formula for silicon
# Auto-generated from .github/templates/formula.rb.template
# Supports both release (url/sha256) and HEAD (head) modes

class Silicon < Formula
  include Language::Python::Virtualenv

  desc "A Python CLI hello world template"
  homepage "https://github.com/alkalescent/silicon"
  url "https://github.com/alkalescent/silicon/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "c07d105708e10cb736741f39d6282ba6ca1f8ad663e58fd846522e80f9d79bfc"
  head "https://github.com/alkalescent/silicon.git", branch: "master"
  license "MIT"

  depends_on "python@3.13"

  def install
    # Create venv with pip included (not --without-pip)
    python3 = "python3.13"
    system python3, "-m", "venv", libexec
    
    # Install the package and all dependencies
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    # Set version for setuptools-scm since archive tarballs lack .git metadata
    # Skip for HEAD builds — they use git clone, so setuptools-scm reads tags directly
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s unless build.head?
    system libexec/"bin/pip", "install", buildpath.to_s
    
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
