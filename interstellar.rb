# typed: false
# frozen_string_literal: true

# Homebrew formula for interstellar
# Auto-generated from .github/templates/formula.rb.template
# Supports both release (url/sha256) and HEAD (head) modes

class Interstellar < Formula
  include Language::Python::Virtualenv

  desc "A command-line tool for managing cryptocurrency mnemonics using BIP39 and SLIP39 standards"
  homepage "https://github.com/alkalescent/interstellar"
  url "https://github.com/alkalescent/interstellar/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "211b828bc1153807ca709571a4efee1a949cbb8cbdda8d4542b45d268136a2e1"
  head "https://github.com/alkalescent/interstellar.git", branch: "master"
  license "MIT"

  depends_on "python@3.13"

  def install
    # Create venv with pip included (not --without-pip)
    python3 = "python3.13"
    system python3, "-m", "venv", libexec
    
    # Install the package and all dependencies
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    system libexec/"bin/pip", "install", buildpath.to_s
    
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
