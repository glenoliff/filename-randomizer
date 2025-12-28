#!/usr/bin/env ruby
# frozen_string_literal: true

# Example: Using FilenameRandomizer as a Ruby library

require_relative '../lib/filename_randomizer'

# Example 1: Basic usage
puts "Example 1: Basic usage"
puts "-" * 50
# randomizer = FilenameRandomizer.new('/path/to/your/directory')
# randomizer.randomize!

# Example 2: Dry-run mode (preview changes without renaming)
puts "\nExample 2: Dry-run mode"
puts "-" * 50
# randomizer = FilenameRandomizer.new('/path/to/directory', dry_run: true)
# result = randomizer.randomize!
# result.each do |item|
#   puts "#{item[:old]} -> #{item[:new]}"
# end

# Example 3: Recursive mode (process subdirectories)
puts "\nExample 3: Recursive mode"
puts "-" * 50
# randomizer = FilenameRandomizer.new('/path/to/directory', recursive: true)
# randomizer.randomize!

# Example 4: Don't preserve extensions
puts "\nExample 4: Don't preserve extensions"
puts "-" * 50
# randomizer = FilenameRandomizer.new('/path/to/directory', preserve_extensions: false)
# randomizer.randomize!

# Example 5: Custom length for random names
puts "\nExample 5: Custom length (longer random names)"
puts "-" * 50
# randomizer = FilenameRandomizer.new('/path/to/directory', length: 16)
# randomizer.randomize!

# Example 6: All options combined
puts "\nExample 6: All options combined"
puts "-" * 50
# randomizer = FilenameRandomizer.new('/path/to/directory', {
#   recursive: true,
#   dry_run: false,
#   preserve_extensions: true,
#   length: 12
# })
# result = randomizer.randomize!
# puts "Renamed #{result.length} file(s)"

puts "\nNote: Uncomment the examples above and replace '/path/to/directory' with an actual path to test."
