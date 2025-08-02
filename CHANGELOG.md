# Changelog

All notable changes to Docker Claude Sandbox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.2.3] - 2024-12-XX

### Added
- LICENSE file (MIT license)
- GitHub issue templates (bug report, feature request, platform support)
- Comprehensive CONTRIBUTING.md with development guidelines
- Professional documentation structure
- CHANGELOG.md with complete version history
- Professional badges in README (license, platform, Node.js, issues, stars)

### Changed
- Enhanced README with professional GitHub standards
- Improved repository presentation and credibility

## [v1.2.2] - 2024-12-XX

### Fixed
- Documentation consistency audit - all files now reference Node.js 20+ consistently
- Version synchronization across all documentation files
- Updated outdated references in AIINSTALL.md

### Changed
- Improved AIINSTALL.md with current status and fixed issues section

## [v1.2.1] - 2024-12-XX

### Fixed
- **CRITICAL**: Volume collision bug causing data corruption between containers
- Each container now gets isolated workspace volume using `${CONTAINER_NAME}_data`
- Improved external volume handling in docker-compose.yml

### Added
- Comprehensive development task tracking in CLAUDE.md
- Issues fixed documentation section

### Changed
- Updated container readiness timeout from 30 to 60 seconds
- Enhanced volume validation and error handling

## [v1.2.0] - 2024-12-XX

### Added
- Cache-busting URL command (`cbl`) for immediate updates
- Professional versioning system with SemVer compliance
- Version tracking across all files (run.sh, README.md)

### Changed
- Improved user experience with simplified output format
- Removed "Other commands" section to focus on Claude Code
- Enhanced documentation with comprehensive platform testing results

## [v1.1.3] - 2024-12-XX

### Removed
- "Other commands" section from output to focus purely on Claude Code usage

### Changed
- Streamlined user messaging and instructions

## [v1.1.1] - 2024-12-XX

### Added
- Complete SemVer versioning system documentation in CLAUDE.md
- Version tracking requirements for all commits

### Changed
- Switched to proper semantic versioning (v1.1.1 instead of v1.11)

## [v1.1.0] - 2024-12-XX

### Fixed
- **CRITICAL**: Node.js compatibility issue - upgraded from Node.js 18 to Node.js 20
- npm version conflict preventing Docker builds on Ubuntu in Parallels
- All tested platforms now work with npm compatibility

### Added
- Node.js 20+ support with latest npm version
- Comprehensive platform testing validation

### Changed
- Updated Dockerfile to use Node.js 20 instead of 18
- Enhanced build process with npm update step

## [v1.0.0] - 2024-12-XX

### Added
- Initial release of Docker Claude Sandbox
- Cross-platform Docker environment for Claude Code development
- Ubuntu 22.04 base with Claude Code pre-installed
- Intelligent setup script with platform-specific optimizations
- Support for Linux ARM64/x86_64 and macOS Intel/Apple Silicon
- TTY intelligence for auto-entry vs manual commands
- Persistent workspace with volume mounting
- Non-root security model with `coder` user
- Beautiful welcome banner and user experience
- Comprehensive documentation suite

### Platform Support
- ✅ Ubuntu 22.04 ARM64 (Raspberry Pi)
- ✅ Ubuntu 22.04 x86_64
- ✅ Linux Mint Intel x86_64
- ✅ Ubuntu in Parallels (Virtual machine)
- ✅ macOS Intel (Docker Desktop + Colima)
- ✅ macOS Apple Silicon
- ✅ All major Linux distributions (Debian, Fedora, Arch)

### Features
- 🤖 Claude Code pre-installed globally
- ⚡ Node.js runtime environment
- 🐍 Python 3 development stack
- 📝 Git version control
- 🍎 macOS compatibility fixes (buildx, Colima)
- 🐧 Linux native optimizations
- 🎨 Interactive container naming
- 🔄 Intelligent image detection
- 📂 Persistent workspace directory

---

## Version History Summary

- **v1.0.0**: Initial stable release with cross-platform support
- **v1.1.0**: Node.js 20 upgrade for npm compatibility
- **v1.1.1**: Professional versioning system implementation
- **v1.1.3**: Streamlined user experience focus
- **v1.2.0**: Major milestone with cache-busting and documentation
- **v1.2.1**: Critical volume collision bug fix
- **v1.2.2**: Documentation consistency and professionalization
- **v1.2.3**: GitHub professionalization with LICENSE, issue templates, badges

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and how to contribute to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.