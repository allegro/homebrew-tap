# Generated with JReleaser 1.24.0 at 2026-06-29T08:58:28.260285656Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.2.3"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.3/pl.allegro.tech.allwrite.allwrite-cli-0.2.3-linux-x86_64.zip"
    sha256 "21677be923e26d46f92993f4f839be47d5f67ed7e33708013fc25832467b8d04"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.3/pl.allegro.tech.allwrite.allwrite-cli-0.2.3-osx-aarch_64.zip"
    sha256 "df920f28ae20ac7571608ef9fe8f6e67b518eb6568193dae77a8939e957a4b14"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.3/pl.allegro.tech.allwrite.allwrite-cli-0.2.3-osx-x86_64.zip"
    sha256 "ecbf6e1b6c6f2d0ef610e037acda02670afee42a24ff32ae52a8fdba6975c4b2"
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
    assert_match "0.2.3", output
  end
end
