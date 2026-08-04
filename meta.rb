class Meta < Formula
  desc "Project intelligence layer — instantly surface what any codebase is, how it's structured, and what you need to know."
  homepage "https://github.com/alkalescent/meta"
  url "https://github.com/alkalescent/meta/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "3e38425af0ced357e8a9cc8fedf4bf57d3f336d3568ea8010e0ebd7293f1b693"
  head "https://github.com/alkalescent/meta.git", branch: "master"
  
  depends_on "python@3.13"
  
  def install
    system "make", "build", "MODE=standalone", "CI=true"
    bin.install "cli.dist/meta"
    # Move the dist contents to libexec to avoid polluting bin
    libexec.install Dir["cli.dist/*"]
    # Create symlink from bin to libexec
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
