# Generated with JReleaser 1.25.0 at 2026-07-27T13:24:14.315365577Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.4.0"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.4.0/pl.allegro.tech.allwrite.allwrite-cli-0.4.0-linux-x86_64.zip"
    sha256 "0eeb182c1a8b604248277205ee39e6f6831c9439871df457b654f590674a4e62"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.4.0/pl.allegro.tech.allwrite.allwrite-cli-0.4.0-osx-aarch_64.zip"
    sha256 "ea8cee680ba836b2582afd2cd2cda09412b6ee3fec9400729635c1dfd589b8ed"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.4.0/pl.allegro.tech.allwrite.allwrite-cli-0.4.0-osx-x86_64.zip"
    sha256 "45cefe44d02a3f0fb9738f642aae77333e707bb2147a4d7379b8bee946febbfa"
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
    assert_match "0.4.0", output
  end
end
