require 'zip/zipfilesystem'
require 'fileutils'
require 'pathname'

module CodePwn
  class IPA
    attr_reader :path

    def initialize(path)
      @path = path
      @zip = Zip::ZipFile.open(@path)
    end

    def resign(identity_name, provision_path, output_file)
      Dir.mktmpdir do |working_dir|
        working_pathname = Pathname.new(working_dir)

        @zip.each do |entry|
          target_path = File.join(working_dir, entry.name)
          parent_path = File.dirname(target_path)
          Dir.mkdir(parent_path) unless Dir.exist?(parent_path)
          @zip.extract(entry, target_path)
        end

        app_path = Dir.glob(working_pathname.join("**", "*.app")).first or raise "Unable to locate application"

        target_privision_path = File.join(app_path, "embedded.mobileprovision")
        # remove any existing embedded.mobileprovision
        FileUtils.rm(target_privision_path) if File.exist?(target_privision_path)
        # copy the new one
        FileUtils.cp(provision_path, target_privision_path)

        # resign
        bin_path = working_pathname.join(File.join(app_path, File.basename(app_path, ".app")))
        system "/usr/bin/codesign", "-fs", identity_name, "--resource-rules", File.join(File.dirname(__FILE__), "..", "..", "share", "ResourceRules.xml"), bin_path.to_s

        Zip::ZipFile.open(output_file, Zip::ZipFile::CREATE) do |zip|
          Pathname.glob(File.join(working_dir, "**", "*")).each do |file_pathname|
            zip.add(file_pathname.relative_path_from(working_pathname), working_pathname.join(file_pathname))
          end
        end
      end
    end

    def close
      @zip.close
    end
  end
end