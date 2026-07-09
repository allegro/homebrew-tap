# Generated with JReleaser 1.25.0 at 2026-07-09T11:45:20.49803866Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.3.1"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.3.1/pl.allegro.tech.allwrite.allwrite-cli-0.3.1-linux-x86_64.zip"
    sha256 "fe2d21a6dd338d0ff700b3eba324fda917be3a36ea29dabcceb94a5df2c06d67"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.3.1/pl.allegro.tech.allwrite.allwrite-cli-0.3.1-osx-aarch_64.zip"
    sha256 "7ea8c135aa11412af8d8ef20f59c4a4d5d92dc465852e4d466407c0b0d01ee18"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.3.1/pl.allegro.tech.allwrite.allwrite-cli-0.3.1-osx-x86_64.zip"
    sha256 "ee75ffcfb0373b67514d9f5d7abe36bf7da32075ccd957c4395d4ca79447c69d"
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
    assert_match "0.3.1", output
  end
end
