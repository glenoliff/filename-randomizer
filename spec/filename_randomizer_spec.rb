# frozen_string_literal: true

require_relative '../lib/filename_randomizer'
require 'fileutils'
require 'tmpdir'

# Simple test framework
class TestFilenameRandomizer
  attr_reader :failures, :passes

  def initialize
    @failures = []
    @passes = 0
  end

  def assert(condition, message)
    if condition
      @passes += 1
      print "."
    else
      @failures << message
      print "F"
    end
  end

  def assert_equal(expected, actual, message)
    assert(expected == actual, "#{message}\n  Expected: #{expected.inspect}\n  Got: #{actual.inspect}")
  end

  def assert_raises(error_class, message)
    yield
    @failures << "#{message}\n  Expected #{error_class} to be raised"
    print "F"
  rescue error_class
    @passes += 1
    print "."
  end

  def run
    puts "Running FilenameRandomizer tests..."
    
    run_test(:test_initialization)
    run_test(:test_validate_directory)
    run_test(:test_collect_files_non_recursive)
    run_test(:test_collect_files_recursive)
    run_test(:test_generate_random_name_with_extension)
    run_test(:test_generate_random_name_without_extension)
    run_test(:test_dry_run_mode)
    run_test(:test_actual_rename)
    
    puts "\n\n#{@passes} tests passed"
    
    if @failures.any?
      puts "\n#{@failures.length} tests failed:"
      @failures.each_with_index do |failure, i|
        puts "\n#{i + 1}. #{failure}"
      end
      exit 1
    else
      puts "\nAll tests passed!"
    end
  end

  def run_test(test_method)
    setup
    send(test_method)
    teardown
  end

  def setup
    @test_dir = Dir.mktmpdir('filename_randomizer_test')
  end

  def teardown
    FileUtils.rm_rf(@test_dir) if @test_dir && File.exist?(@test_dir)
  end

  def test_initialization
    randomizer = FilenameRandomizer.new(@test_dir)
    assert_equal(@test_dir, randomizer.directory, "Directory should be set correctly")
    assert_equal(false, randomizer.options[:recursive], "Recursive should default to false")
    assert_equal(false, randomizer.options[:dry_run], "Dry run should default to false")
    assert_equal(true, randomizer.options[:preserve_extensions], "Preserve extensions should default to true")
    assert_equal(8, randomizer.options[:length], "Length should default to 8")
  end

  def test_validate_directory
    assert_raises(ArgumentError, "Should raise error for non-existent directory") do
      randomizer = FilenameRandomizer.new('/nonexistent/directory')
      randomizer.randomize!
    end

    file_path = File.join(@test_dir, 'test.txt')
    File.write(file_path, 'test')
    
    assert_raises(ArgumentError, "Should raise error when path is a file") do
      randomizer = FilenameRandomizer.new(file_path)
      randomizer.randomize!
    end
  end

  def test_collect_files_non_recursive
    # Create test files
    File.write(File.join(@test_dir, 'file1.txt'), 'content1')
    File.write(File.join(@test_dir, 'file2.jpg'), 'content2')
    
    # Create subdirectory with file
    subdir = File.join(@test_dir, 'subdir')
    Dir.mkdir(subdir)
    File.write(File.join(subdir, 'file3.txt'), 'content3')
    
    randomizer = FilenameRandomizer.new(@test_dir, recursive: false)
    files = randomizer.send(:collect_files)
    
    assert_equal(2, files.length, "Should collect 2 files non-recursively")
  end

  def test_collect_files_recursive
    # Create test files
    File.write(File.join(@test_dir, 'file1.txt'), 'content1')
    
    # Create subdirectory with file
    subdir = File.join(@test_dir, 'subdir')
    Dir.mkdir(subdir)
    File.write(File.join(subdir, 'file2.txt'), 'content2')
    
    randomizer = FilenameRandomizer.new(@test_dir, recursive: true)
    files = randomizer.send(:collect_files)
    
    assert_equal(2, files.length, "Should collect 2 files recursively")
  end

  def test_generate_random_name_with_extension
    randomizer = FilenameRandomizer.new(@test_dir, preserve_extensions: true, length: 8)
    new_name = randomizer.send(:generate_random_name, 'test.txt')
    
    assert(new_name.end_with?('.txt'), "Should preserve .txt extension")
    assert_equal(20, new_name.length, "Should have correct length (length: 8 * 2 = 16 hex chars + 4 for .txt)")
  end

  def test_generate_random_name_without_extension
    randomizer = FilenameRandomizer.new(@test_dir, preserve_extensions: false, length: 8)
    new_name = randomizer.send(:generate_random_name, 'test.txt')
    
    assert(!new_name.include?('.'), "Should not include extension")
    assert_equal(16, new_name.length, "Should have correct length (length: 8 * 2 = 16 hex chars)")
  end

  def test_dry_run_mode
    File.write(File.join(@test_dir, 'file1.txt'), 'content1')
    File.write(File.join(@test_dir, 'file2.jpg'), 'content2')
    
    randomizer = FilenameRandomizer.new(@test_dir, dry_run: true)
    result = randomizer.randomize!
    
    # Files should still exist with original names
    assert(File.exist?(File.join(@test_dir, 'file1.txt')), "Original file1.txt should still exist in dry run")
    assert(File.exist?(File.join(@test_dir, 'file2.jpg')), "Original file2.jpg should still exist in dry run")
    assert_equal(2, result.length, "Should return rename information for 2 files")
  end

  def test_actual_rename
    file1_path = File.join(@test_dir, 'file1.txt')
    file2_path = File.join(@test_dir, 'file2.jpg')
    
    File.write(file1_path, 'content1')
    File.write(file2_path, 'content2')
    
    randomizer = FilenameRandomizer.new(@test_dir, dry_run: false)
    result = randomizer.randomize!
    
    # Original files should not exist
    assert(!File.exist?(file1_path), "Original file1.txt should not exist after rename")
    assert(!File.exist?(file2_path), "Original file2.jpg should not exist after rename")
    
    # New files should exist
    assert(File.exist?(result[0][:new]), "New file should exist")
    assert(File.exist?(result[1][:new]), "New file should exist")
    
    # Content should be preserved
    new_files = Dir.glob(File.join(@test_dir, '*')).select { |f| File.file?(f) }
    assert_equal(2, new_files.length, "Should have 2 files after rename")
  end
end

# Run tests
TestFilenameRandomizer.new.run
