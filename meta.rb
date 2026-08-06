class Meta < Formula
  desc "Project intelligence layer — instantly surface what any codebase is, how it's structured, and what you need to know."
  homepage "https://github.com/alkalescent/meta"
  url "https://github.com/alkalescent/meta/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "506eec2f6f2440990e13c3209d4bfa675c3e88371d5ab4ae4e2bd03358b88cca"
  head "https://github.com/alkalescent/meta.git", branch: "master"
  
  depends_on "python@3.13"
  depends_on "uv"
  
  def install
    system "make", "build", "MODE=standalone", "CI=true"
    # Install the whole dist dir (binary + its support files) into libexec
    # to avoid polluting bin, then symlink just the binary into bin.
    libexec.install Dir["cli.dist/*"]
    bin.install_symlink libexec/"meta"
  end

  test do
    # Test version command
    assert_match(/v\d+\.\d+\.\d+/, shell_output("#{bin}/meta version"))

    # Test help command shows expected subcommands
    help_output = shell_output("#{bin}/meta --help")
    assert_match "deps", help_output
    assert_match "health", help_output
    assert_match "size", help_output
  end
end
