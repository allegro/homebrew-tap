# Generated with JReleaser 1.26.0 at 2026-09-09T06:52:38.051939868Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.6.2"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.2/pl.allegro.tech.allwrite.allwrite-cli-0.6.2-linux-x86_64.zip"
    sha256 "20f2762eb8cd4721508bfc51e3f5d600292c8266f6a4251b0ec0f2a1faf905e4"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.2/pl.allegro.tech.allwrite.allwrite-cli-0.6.2-osx-aarch_64.zip"
    sha256 "cc3bf1e803d1026b03f829580122e16b8507db70e0f035f75d432de903231ff3"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.6.2/pl.allegro.tech.allwrite.allwrite-cli-0.6.2-osx-x86_64.zip"
    sha256 "99ae48c992c7e4f023a972ec32764f81e3026be4edf936d75482a7645c1fb250"
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
    assert_match "0.6.2", output
  end
end
