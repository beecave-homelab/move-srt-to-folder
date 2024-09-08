# srt2dir.sh

A bash script that moves `.srt` files into corresponding directories based on matching file names.

## Versions
**Current version**: 1.1.0

## Table of Contents
- [Badges](#badges)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)
- [Contributing](#contributing)

## Badges
![Bash](https://img.shields.io/badge/Bash-5.1+-blue)
![Version](https://img.shields.io/badge/Version-1.1.0-brightgreen)
![License](https://img.shields.io/github/license/beecave-homelab/srt2dir)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/beecave-homelab/srt2dir.git
   ```

2. Navigate to the cloned directory:

   ```bash
   cd srt2dir
   ```

3. Make the script executable:

   ```bash
   chmod +x srt2dir.sh
   ```

4. Run the script:

   ```bash
   ./srt2dir.sh --help
   ```

## Usage

The script moves `.srt` files into directories that match the file name.

### Basic Usage:

```bash
./srt2dir.sh [-d DIRECTORY] [-sd SRT_DIRECTORY] [-r] [--dry-run]
```

### Options:

- `-d, --directory DIRECTORY` - Specify the root directory to scan for folders (default: current directory).
- `-sd, --srt-directory SRT_DIR` - Specify the directory to scan for `.srt` files (default: same as the folder directory).
- `-r, --recursive` - Recursively search for `.srt` files in subdirectories.
- `-dr, --dry-run` - Perform a dry run without moving files, shows found matches.
- `-h, --help` - Display help information.

### Examples:

- Move `.srt` files from a specific directory:

  ```bash
  ./srt2dir.sh -d /path/to/root_directory -sd /path/to/srt_directory
  ```

- Perform a dry run in recursive mode:

  ```bash
  ./srt2dir.sh -r --dry-run
  ```

## License

This project is licensed under the MIT license. See [LICENSE](LICENSE) for more information.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.