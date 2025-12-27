#!/usr/bin/env ruby
# frozen_string_literal: true

require 'securerandom'
require 'fileutils'

# FilenameRandomizer - A utility to randomize filenames in a directory
class FilenameRandomizer
  attr_reader :directory, :options

  def initialize(directory, options = {})
    @directory = File.expand_path(directory)
    @options = {
      recursive: options.fetch(:recursive, false),
      dry_run: options.fetch(:dry_run, false),
      preserve_extensions: options.fetch(:preserve_extensions, true),
      length: options.fetch(:length, 8)
    }
    @renamed_files = []
  end

  def randomize!
    validate_directory!
    
    files = collect_files
    
    if files.empty?
      puts "No files found in #{directory}"
      return []
    end

    puts "Found #{files.length} file(s) to randomize"
    puts "Running in DRY RUN mode - no files will be renamed" if @options[:dry_run]
    
    files.each do |file_path|
      rename_file(file_path)
    end
    
    @renamed_files
  end

  private

  def validate_directory!
    unless File.exist?(@directory)
      raise ArgumentError, "Directory does not exist: #{@directory}"
    end

    unless File.directory?(@directory)
      raise ArgumentError, "Path is not a directory: #{@directory}"
    end
  end

  def collect_files
    pattern = @options[:recursive] ? "#{@directory}/**/*" : "#{@directory}/*"
    Dir.glob(pattern).select { |path| File.file?(path) }
  end

  def rename_file(file_path)
    old_name = File.basename(file_path)
    directory_path = File.dirname(file_path)
    
    new_name = generate_random_name(old_name)
    new_path = File.join(directory_path, new_name)
    
    # Ensure no collision with existing files
    while File.exist?(new_path)
      new_name = generate_random_name(old_name)
      new_path = File.join(directory_path, new_name)
    end
    
    if @options[:dry_run]
      puts "Would rename: #{file_path} -> #{new_path}"
    else
      FileUtils.mv(file_path, new_path)
      puts "Renamed: #{old_name} -> #{new_name}"
    end
    
    @renamed_files << { old: file_path, new: new_path }
  end

  def generate_random_name(original_name)
    if @options[:preserve_extensions]
      extension = File.extname(original_name)
      random_base = SecureRandom.hex(@options[:length])
      extension.empty? ? random_base : "#{random_base}#{extension}"
    else
      SecureRandom.hex(@options[:length])
    end
  end
end
