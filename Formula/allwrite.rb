# Generated with JReleaser 1.24.0 at 2026-07-07T12:06:51.173989891Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.3.0"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.3.0/pl.allegro.tech.allwrite.allwrite-cli-0.3.0-linux-x86_64.zip"
    sha256 "b79ee1cb8cd0931d597540ed704e8b56c854671327bee232a7b41271ed0adf2f"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.3.0/pl.allegro.tech.allwrite.allwrite-cli-0.3.0-osx-aarch_64.zip"
    sha256 "304539beb52cdb9b405df75ee17b52addaf8291951be9954d3a398ca959b1bac"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.3.0/pl.allegro.tech.allwrite.allwrite-cli-0.3.0-osx-x86_64.zip"
    sha256 "d949c8189eb455246409125f37ae7d4f7add32f2a4aa2f9f785f39f4eb1d37af"
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
    assert_match "0.3.0", output
  end
end
