# filename-randomizer

A Ruby utility that randomizes filenames in a directory. Useful for anonymizing files, testing file processing systems, or creating unique identifiers for files.

## Features

- 🎲 Randomizes filenames using secure random generation
- 📁 Supports recursive directory traversal
- 🔒 Preserves file extensions by default
- 🧪 Dry-run mode to preview changes
- ⚙️ Configurable random name length
- 🚀 No external dependencies - uses Ruby standard library only

## Installation

Clone this repository:

```bash
git clone https://github.com/glenoliff/filename-randomizer.git
cd filename-randomizer
```

Make sure you have Ruby 2.7 or higher installed:

```bash
ruby --version
```

## Usage

### Command Line

Basic usage:

```bash
./bin/filename-randomizer /path/to/directory
```

#### Options

- `-r, --recursive` - Randomize files recursively in subdirectories
- `-d, --dry-run` - Show what would be renamed without actually renaming
- `-n, --no-preserve-extensions` - Don't preserve file extensions
- `-l, --length LENGTH` - Length of random name (default: 8)
- `-h, --help` - Show help message

#### Examples

Randomize files in a directory:

```bash
./bin/filename-randomizer ~/Documents/photos
```

Dry-run to preview changes:

```bash
./bin/filename-randomizer --dry-run ~/Documents/photos
```

Randomize recursively in subdirectories:

```bash
./bin/filename-randomizer --recursive ~/Documents
```

Use longer random names:

```bash
./bin/filename-randomizer --length 16 ~/Documents/photos
```

Don't preserve extensions:

```bash
./bin/filename-randomizer --no-preserve-extensions ~/Documents/photos
```

### As a Ruby Library

You can also use the `FilenameRandomizer` class in your Ruby code:

```ruby
require_relative 'lib/filename_randomizer'

# Basic usage
randomizer = FilenameRandomizer.new('/path/to/directory')
randomizer.randomize!

# With options
randomizer = FilenameRandomizer.new('/path/to/directory', {
  recursive: true,
  dry_run: false,
  preserve_extensions: true,
  length: 12
})

result = randomizer.randomize!
# Returns array of hashes: [{ old: 'old_path', new: 'new_path' }, ...]
```

## Examples

Before:
```
photos/
├── vacation-2023.jpg
├── family-dinner.jpg
└── sunset.png
```

After running `./bin/filename-randomizer photos`:
```
photos/
├── 4f3a8b9c1e2d5a7f.jpg
├── 9d1c2e4f7a8b3c5d.jpg
└── 2e5f8a9b3c7d1f4e.png
```

## Testing

Run the test suite:

```bash
ruby spec/filename_randomizer_spec.rb
```

## How It Works

1. The utility scans the specified directory for files
2. For each file, it generates a random hexadecimal name using Ruby's `SecureRandom`
3. If preserving extensions (default), it keeps the original file extension
4. It ensures no filename collisions occur
5. Files are renamed using Ruby's `FileUtils.mv`

## Safety Features

- ✅ Validates that the directory exists before processing
- ✅ Checks for filename collisions and generates new names if needed
- ✅ Dry-run mode to preview changes before applying them
- ✅ Only processes files, not directories
- ✅ Uses secure random generation for filenames

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.