# Generated with JReleaser 1.26.0 at 2026-09-03T13:57:39.220513468Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.6.1"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.1/pl.allegro.tech.allwrite.allwrite-cli-0.6.1-linux-x86_64.zip"
    sha256 "f47adb35d33a3400c3cd3b33a979ec77689778ad3a8fdb5e932f52f19bc5d3c6"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.1/pl.allegro.tech.allwrite.allwrite-cli-0.6.1-osx-aarch_64.zip"
    sha256 "a3178899aa2569327e8754845ed38a229ba76dcba02de004e7237abb7fbe1bf6"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.1/pl.allegro.tech.allwrite.allwrite-cli-0.6.1-osx-x86_64.zip"
    sha256 "03ca1abd273e2291defb1c1fd79eeaa398ee530cfed7e51ae0bb130aeebfb545"
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
    assert_match "0.6.1", output
  end
end
