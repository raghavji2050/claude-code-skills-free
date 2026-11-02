# Free Claude Code Skills (Laravel, Next.js, PR review)

3 free, ready-to-use [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills for web developers.

## What are Claude Code skills?

A skill is a folder with a `SKILL.md` file: a short Markdown playbook with a `name` and a `description` in its frontmatter. Claude Code reads each description and loads the matching skill automatically when your request fits ("review my changes before I open a PR"). You can also call one directly by typing `/` and its name, e.g. `/pr-review`.

## Included skills

| Skill | What it does |
|---|---|
| `laravel-safe-migration` | Writes and reviews Laravel migrations so they are reversible and safe on tables that already hold production data. |
| `nextjs-route-handler` | Creates Next.js App Router route handlers (`app/**/route.ts`) with input validation, correct status codes and typed responses. |
| `pr-review` | Reviews a PR or local diff for bugs, security issues, missing tests and maintainability, ranked by severity with file and line references. |

## Install

Skills live in a `skills` folder inside `.claude`. Each skill is its own folder containing `SKILL.md`.

```bash
git clone https://github.com/raghavji2050/claude-code-skills-free.git
cd claude-code-skills-free
./install.sh                     # all your projects: ~/.claude/skills/
./install.sh /path/to/your/repo  # one project: /path/to/your/repo/.claude/skills/
```

Manual install (any OS): copy each folder from `skills/` into `~/.claude/skills/` (Windows: `%USERPROFILE%\.claude\skills\`) or into `.claude/skills/` at your repo root, keeping the structure `.claude/skills/pr-review/SKILL.md`. The installer never overwrites an existing skill folder unless you run `FORCE=1 ./install.sh`.

Restart Claude Code, then ask: `What skills are available?`

## Want more?

- Full Claude Code Skills Pack for Web Devs (25 skills + 3 CLAUDE.md templates): https://raghavji.gumroad.com/l/claude-code-skills-pack?utm_source=github
- Same 3 free skills as a zip download: https://raghavji.gumroad.com/l/free-claude-code-skills-lite?utm_source=github

Issues and suggestions are welcome.

## License

MIT, see [LICENSE](LICENSE). This repo contains only the 3 free skills.
