# Mirror X

**Mirror X** is a Bash script designed to clone websites quickly and efficiently. It is a simple yet powerful tool for mirroring websites, filtering file types, excluding unwanted files, and even searching for specific strings in the downloaded content.

This project was created as a practice exercise but can be useful for developers, pentesters, or anyone who needs to download and analyze website content.

---

## Features

- **Website Cloning**: Downloads all website content, including HTML, CSS, JavaScript, and other files.
- **File Filtering**: Allows specifying file types to download or exclude.
- **String Search**: Searches for specific strings in the downloaded files.
- **Authentication Support**: Supports basic authentication (username and password).
- **Rate Limiting**: Controls download speed to avoid server overload.
- **Recursive Download**: Allows setting the depth of recursive downloads.
- **Compression**: Creates a ZIP archive of the downloaded files.
- **Safe Deletion**: Removes downloaded files after use, if desired.

---

## Requirements

- **Bash**: The script is designed to run on Unix-like environments (Linux, macOS).
- **wget**: The script relies on `wget` for downloading. Ensure it is installed on your system.

To install `wget`, run:

```bash
sudo apt install wget  # For Debian/Ubuntu-based systems
brew install wget      # For macOS (using Homebrew)
```

---

## Usage

### Basic Syntax

```bash
./mirrorx.sh <URL> [options]
```

### Available Options

| Option                  | Description                                                                 |
|-------------------------|-----------------------------------------------------------------------------|
| `-h`, `--help`          | Displays the help message.                                                  |
| `-f`, `--file-types`    | Specifies file types to download (e.g., `html,css,js`).                     |
| `-e`, `--exclude`       | Excludes specific file types from the download (e.g., `jpg,png`).           |
| `-s`, `--search`        | Searches for a specific string in the downloaded files.                     |
| `-r`, `--recursive`     | Sets the depth of recursive downloads (e.g., `2` for 2 levels).             |
| `-l`, `--limit-rate`    | Limits the download rate (e.g., `100k` for 100 KB/s).                       |
| `-a`, `--auth`          | Provides authentication credentials in the format `username:password`.      |
| `-v`, `--version`       | Displays the script version.                                                |

### Usage Examples

1. **Basic Website Clone**:
   ```bash
   ./mirrorx.sh https://example.com
   ```

2. **Clone with File Type Filter**:
   ```bash
   ./mirrorx.sh https://example.com -f html,css,js
   ```

3. **Clone with Excluded File Types**:
   ```bash
   ./mirrorx.sh https://example.com -e jpg,png
   ```

4. **Clone with String Search**:
   ```bash
   ./mirrorx.sh https://example.com -s "keyword"
   ```

5. **Clone with Authentication**:
   ```bash
   ./mirrorx.sh https://example.com -a user:password
   ```

6. **Clone with Rate Limiting**:
   ```bash
   ./mirrorx.sh https://example.com -l 500k
   ```

7. **Recursive Clone with Defined Depth**:
   ```bash
   ./mirrorx.sh https://example.com -r 2
   ```

---

## Project Structure

After running the script, the downloaded files will be saved in the current directory, inside a folder named after the website's domain. For example:

```
.
└── example.com/
    ├── index.html
    ├── styles/
    │   └── style.css
    └── images/
        └── logo.png
```

---

## Contributing

Contributions are welcome! If you'd like to improve **Mirror X**, follow these steps:

1. Fork the repository.
2. Create a branch for your feature (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a Pull Request.

---

## Acknowledgments

- Inspired by mirroring tools like `wget` and `httrack`.
- Credits to the open-source community for providing resources and inspiration.

---
