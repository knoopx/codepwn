require "thor"
require 'codepwn/ipa'

module CodePwn
  class CLI < Thor
    desc "resign [IDENTITY NAME] [PROVISION FILE] [IPA FILE OR DIR]", "Resign IPA"

    def resign(identity, provision_path, ipa_or_directory)
      files = []

      if File.directory?(ipa_or_directory)
        files = Dir.glob(File.join(ipa_or_directory, "**", "*.ipa"))
      else
        files << ipa_or_directory
      end

      files.each do |file|
        ipa = IPA.new(file)
        output_file = File.join(File.dirname(ipa_or_directory), [File.basename(ipa_or_directory, ".ipa"), "-resigned.ipa"].join)
        ipa.resign(identity, provision_path, output_file)
        ipa.close
      end
    end
  end
end