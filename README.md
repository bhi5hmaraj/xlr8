# xlr8 - AI-Assisted Software Engineering

> Scripts, prompts, and tools for accelerating development with AI assistance

A curated collection of prompts, scripts, and workflows for building with LLMs. Covers developer experience, prompt engineering, brainstorming, and domain-specific applications.

## Directory Structure

```
xlr8/
├── devex/                      # Developer Experience & Tools
│   └── merge-fix-scripts/      # Fix git merges to preserve individual commits
├── prompts/                    # Prompt Collections
│   ├── brainstorm/            # Brainstorming & Ideation Prompts
│   ├── medhai/                # Medical AI Prompts & Expertise
│   └── prompt_eng_meta/       # Prompt Engineering Metadata & Patterns
└── README.md                   # This file
```

## Quick Start

### Using merge-fix-scripts

For fixing already-merged PRs that only show as 1 contribution:

```bash
cd devex/merge-fix-scripts
chmod +x step*.sh fix-merge.sh
./fix-merge.sh
```

Read the full guide:
```bash
cat devex/merge-fix-scripts/README.md
```

## Sections

### devex/ - Developer Experience
Workflows and scripts for improving development with AI:

- **merge-fix-scripts** - Complete toolkit for fixing git merges
  - 7-step guided process with human verification gates
  - Works for already-merged PRs
  - Emergency recovery and backup procedures
  - Full documentation and checklists

### prompts/ - Prompt Collections

#### brainstorm/
Ideation prompts and creative thinking tools for use with AI assistants

#### medhai/
Specialized prompts and techniques for medical AI and healthcare LLM applications

#### prompt_eng_meta/
Patterns, techniques, and metadata for effective prompt engineering

## Usage

Each folder contains its own documentation. Start with:
- Guides and README files in each folder
- Practical examples and use cases
- Step-by-step instructions for complex tasks
- Quick reference guides

## License

These are personal utilities and prompts - use as needed for your projects.

---

**Last Updated**: November 2025
