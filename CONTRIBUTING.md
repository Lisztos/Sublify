# Contributing to Sublify

Thank you for your interest in contributing to Sublify! This project aims to democratize subliminal messaging techniques for personal empowerment.

## 🚀 Getting Started

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- Basic knowledge of Swift and SwiftUI

### Setting Up Development Environment

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/Sublify.git
   cd Sublify
   ```

2. **Open in Xcode**
   ```bash
   open Sublify.xcodeproj
   ```

3. **Build and Run**
   ```bash
   make build
   make run
   ```

## 🛠️ Development Workflow

### Building
```bash
# Development build
make build

# Release build
make release

# Clean build artifacts
make clean
```

### Testing Your Changes
```bash
# Build and run immediately
make run

# Test the release version
make release
open build/Sublify.app
```

## 📝 Code Style

- Follow Swift naming conventions
- Use SwiftUI best practices
- Keep functions focused and small
- Add comments for complex logic
- Use meaningful variable names

### File Structure
```
Sources/
├── SublifyApp.swift          # App entry point
├── ContentView.swift         # Main interface
├── SettingsView.swift        # Settings interface
├── OverlayView.swift         # Fullscreen overlay
├── SublifyManager.swift      # Core logic
└── SublifyDesignSystem.swift # UI components
```

## 🎯 Areas for Contribution

### High Priority
- [ ] App notarization and signing
- [ ] Additional timing presets based on research
- [ ] Accessibility improvements
- [ ] Performance optimizations
- [ ] Unit tests

### Medium Priority
- [ ] Dark mode support
- [ ] Multiple monitor support improvements
- [ ] Export/import settings
- [ ] Statistics and usage tracking
- [ ] Additional image formats

### Research & Science
- [ ] New subliminal timing research integration
- [ ] A/B testing framework for effectiveness
- [ ] Biometric integration (heart rate, etc.)
- [ ] Academic collaboration opportunities

## 🧪 Submitting Changes

### Pull Request Process

1. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Write clean, documented code
   - Test thoroughly on your machine
   - Ensure the app builds and runs

3. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: brief description of your change"
   ```

4. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a pull request on GitHub.

### Commit Message Format
```
Type: Brief description

Longer description if needed

- Specific change 1
- Specific change 2
```

Types: `Add`, `Fix`, `Update`, `Remove`, `Refactor`, `Docs`

## 🔬 Research Contributions

We especially welcome contributions that:
- Reference peer-reviewed research
- Include proper citations
- Explain the psychological mechanisms
- Propose evidence-based timing or features

### Adding Research
1. Find relevant neuroscience/psychology papers
2. Summarize key findings in layman's terms
3. Propose how it could improve Sublify
4. Update documentation with proper citations

## 🐛 Bug Reports

### Before Reporting
- Check existing issues
- Test on a clean macOS install if possible
- Try building from the latest main branch

### Bug Report Template
```markdown
## Bug Description
Brief description of the issue

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- macOS version:
- Sublify version:
- Hardware:

## Additional Context
Any other relevant information
```

## 💡 Feature Requests

We love new ideas! Please:
- Check if it's already been suggested
- Explain the use case and benefits
- Include research backing if applicable
- Consider implementation complexity

## 📚 Documentation

Help improve our documentation:
- Fix typos and unclear explanations
- Add examples and use cases
- Translate to other languages
- Create video tutorials

## 🤝 Community

- Be respectful and inclusive
- Help others learn and contribute
- Share your success stories
- Provide constructive feedback

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Questions?** Open an issue or start a discussion. We're here to help! 🚀
