# Stratum V2 Reference Implementation Fuzzing Corpus

[![License](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue.svg)](https://github.com/stratum-mining/stratum-fuzzing-corpus)

This repository contains the fuzzing corpus for the [Stratum V2 Reference Implementation (SRI)](https://github.com/stratum-mining/stratum), a next-generation Bitcoin mining protocol implementation.

## 📋 Overview

This corpus is used for continuous fuzz testing of the Stratum V2 protocol implementation to discover edge cases, parsing vulnerabilities, and potential security issues. The corpus contains inputs that have been discovered during fuzzing campaigns and represent interesting test cases for protocol message parsing and handling.

## 🎯 Purpose

The corpus serves multiple purposes:

- **Regression Testing**: Ensures that previously discovered edge cases continue to be handled correctly
- **Fuzzing Seed Corpus**: Provides high-quality starting inputs for fuzzing campaigns
- **Documentation**: Demonstrates real-world protocol message patterns and edge cases
- **Community Collaboration**: Allows the community to contribute interesting test cases

Each directory contains binary files representing inputs that exercise different code paths in the respective fuzz targets.

## 🚀 Using This Corpus

### With cargo-fuzz

To use this corpus with the Stratum repository:

1. Clone both repositories:
```bash
git clone https://github.com/stratum-mining/stratum.git
git clone https://github.com/stratum-mining/stratum-fuzzing-corpus.git
```

2. Copy or link the corpus into the stratum fuzz directory:
```bash
cd stratum
cp -r ../stratum-fuzzing-corpus/* fuzz/corpus/
# Or create a symlink:
# ln -s ../../stratum-fuzzing-corpus/* fuzz/corpus/
```

3. Run fuzzing with the corpus (e.g.: `deserialize_sv2frame` target)
```bash
cd stratum
cargo +nightly fuzz run deserialize_sv2frame
```

### Continuous Fuzzing

For 24/7 fuzzing operations, the corpus provides a solid foundation:

```bash
# Run with multiple jobs using all CPU cores
cargo +nightly fuzz run deserialize_sv2frame -- \
  -max_total_time=0 \
  -jobs=$(nproc) \
  -workers=$(nproc)
```

## 🤝 Contributing

We welcome contributions to expand and improve the fuzzing corpus!

### Adding New Corpus Entries

If you discover interesting test cases during fuzzing:

1. Fork this repository
2. Add your corpus files to the appropriate fuzz target directory
3. Ensure files are minimal (run `cargo fuzz cmin <target_name>` to minimize)
4. Submit a pull request with a description of what makes the input interesting

### Guidelines

- **Minimize inputs**: Use `cargo fuzz cmin <target_name>` to reduce corpus bloat
- **Binary format**: Corpus files should be raw binary inputs
- **Privacy**: Ensure corpus files don't contain sensitive information

## 🔍 Corpus Maintenance

The corpus is periodically minimized and deduplicated to:
- Keep repository size manageable
- Maintain high-quality, diverse inputs

## 🐛 Found a Bug?

If the corpus reveals a bug in the Stratum implementation:

1. **Do not** include the crashing input directly in this repository
2. Report the issue to [stratum-mining/stratum](https://github.com/stratum-mining/stratum/issues)
3. Follow responsible disclosure practices
4. After the bug is fixed, the input can be added to the corpus

## 🔗 Related Resources

- [Stratum V2 Reference Implementation](https://github.com/stratum-mining/stratum)
- [Stratum V2 Specification](https://github.com/stratum-mining/sv2-spec)
- [Stratum Protocol Website](https://stratumprotocol.org)
- [cargo-fuzz Documentation](https://rust-fuzz.github.io/book/cargo-fuzz.html)

## 💬 Community

Join the Stratum V2 community:

- **Discord**: [SV2 Discord Community](https://discord.gg/fsEW23wFYs)
- **Twitter**: [@Stratumv2](https://twitter.com/Stratumv2)
- **Website**: [stratumprotocol.org](https://stratumprotocol.org)

## 📄 License

This corpus is released under the same license as the Stratum V2 Reference Implementation:

Licensed under either of:
- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

## 🙏 Acknowledgments

This fuzzing corpus is maintained by the Stratum V2 community with support from contributors who run continuous fuzzing infrastructure and discover valuable test cases.

---

**Note**: This is an evolving corpus. Inputs are added as fuzzing campaigns discover new interesting cases. The corpus aims for quality over quantity, prioritizing inputs that maximize code coverage and edge case discovery.
