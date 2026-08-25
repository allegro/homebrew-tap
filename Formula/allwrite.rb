# Generated with JReleaser 1.25.0 at 2026-08-25T08:53:41.965422536Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.6.0"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.0/pl.allegro.tech.allwrite.allwrite-cli-0.6.0-linux-x86_64.zip"
    sha256 "6d130bed2ca5568d7bfacbc85582cac442c11ef6c7d624d7c1966197548bd5c1"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.0/pl.allegro.tech.allwrite.allwrite-cli-0.6.0-osx-aarch_64.zip"
    sha256 "c9a6644caedf7ea653813c755a2b70c90c10f89382f2ee8f91c6f9078e71dd40"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.0/pl.allegro.tech.allwrite.allwrite-cli-0.6.0-osx-x86_64.zip"
    sha256 "3bcf4a3ff966729fdf3ca0bae551c6cbcc530aeb3532e6663664fe3ef4dc144d"
  end


  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/allwrite" => "allwrite"


    # auto completions
    system "_ALLWRITE_COMPLETE=bash #{libexec}/bin/allwrite > bash_completion.sh"
    system "_ALLWRITE_COMPLETE=zsh #{libexec}/bin/allwrite > zsh_completion.sh"
    system "_ALLWRITE_COMPLETE=fish #{libexec}/bin/allwrite > fish_completion.sh"
    bash_completion.install "bash_completion.sh" => "allwrite"
    zsh_completion.install "zsh_completion.sh" => "_allwrite"
    fish_completion.install "fish_completion.sh" => "allwrite.fish"
  end

  def post_install
    if OS.mac?
      Dir["#{libexec}/lib/**/*.dylib"].each do |dylib|
        chmod 0664, dylib
        MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
        MachO.codesign!(dylib)
        chmod 0444, dylib
      end
    end
  end

  test do
    output = shell_output("#{bin}/allwrite --version")
    assert_match "0.6.0", output
  end
end
