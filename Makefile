.PHONY: init validate install uninstall publish release list help

PLUGIN_NAME := praxis
PLUGIN_JSON := .claude-plugin/plugin.json
CLAUDE_DIR  := $(HOME)/.claude
SKILLS_LINK := $(CLAUDE_DIR)/skills/$(PLUGIN_NAME)
AGENTS_DIR  := $(CLAUDE_DIR)/agents
REMOTE      := origin
BRANCH      := main

# ──────────────────────────────────────────────
# Help
# ──────────────────────────────────────────────

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

# ──────────────────────────────────────────────
# Setup
# ──────────────────────────────────────────────

init: ## First-time setup — git remote, initial commit
	@if ! git remote get-url $(REMOTE) >/dev/null 2>&1; then \
		git remote add $(REMOTE) git@github.com:0x4139/praxis.git; \
		echo "Remote $(REMOTE) added"; \
	else \
		echo "Remote $(REMOTE) already set"; \
	fi
	@if [ -z "$$(git log --oneline -1 2>/dev/null)" ]; then \
		git add -A && git commit -m "Initial commit — $(PLUGIN_NAME) plugin"; \
		echo "Initial commit created"; \
	fi

# ──────────────────────────────────────────────
# Validate
# ──────────────────────────────────────────────

validate: ## Lint all skill and agent frontmatter
	@echo "Validating plugin manifest..."
	@test -f $(PLUGIN_JSON) || { echo "FAIL: $(PLUGIN_JSON) not found"; exit 1; }
	@echo "  $(PLUGIN_JSON) exists"
	@# Check plugin.json has required fields
	@for field in name description version; do \
		grep -q "\"$$field\"" $(PLUGIN_JSON) || { echo "FAIL: missing '$$field' in $(PLUGIN_JSON)"; exit 1; }; \
	done
	@echo "  manifest fields OK"
	@echo ""
	@echo "Validating skills..."
	@FAIL=0; \
	for skill_dir in skills/*/; do \
		skill_file="$$skill_dir/SKILL.md"; \
		skill_name=$$(basename "$$skill_dir"); \
		if [ ! -f "$$skill_file" ]; then \
			echo "  FAIL: $$skill_dir missing SKILL.md"; \
			FAIL=1; continue; \
		fi; \
		if ! head -1 "$$skill_file" | grep -q '^---$$'; then \
			echo "  FAIL: $$skill_name — missing frontmatter"; \
			FAIL=1; continue; \
		fi; \
		fm=$$(sed -n '1,/^---$$/p' "$$skill_file" | tail -n +2); \
		if ! echo "$$fm" | grep -q '^name:'; then \
			echo "  FAIL: $$skill_name — missing 'name' in frontmatter"; \
			FAIL=1; \
		fi; \
		if ! echo "$$fm" | grep -q '^description:'; then \
			echo "  FAIL: $$skill_name — missing 'description' in frontmatter"; \
			FAIL=1; \
		fi; \
		if echo "$$fm" | grep -q '^origin:'; then \
			echo "  FAIL: $$skill_name — has 'origin' field (not allowed)"; \
			FAIL=1; \
		fi; \
		echo "  $$skill_name OK"; \
	done; \
	echo ""; \
	echo "Validating agents..."; \
	for agent_file in agents/*.md; do \
		agent_name=$$(basename "$$agent_file" .md); \
		if ! head -1 "$$agent_file" | grep -q '^---$$'; then \
			echo "  FAIL: $$agent_name — missing frontmatter"; \
			FAIL=1; continue; \
		fi; \
		fm=$$(sed -n '1,/^---$$/p' "$$agent_file" | tail -n +2); \
		if ! echo "$$fm" | grep -q '^name:'; then \
			echo "  FAIL: $$agent_name — missing 'name' in frontmatter"; \
			FAIL=1; \
		fi; \
		if ! echo "$$fm" | grep -q '^description:'; then \
			echo "  FAIL: $$agent_name — missing 'description' in frontmatter"; \
			FAIL=1; \
		fi; \
		skills_line=$$(echo "$$fm" | grep '^skills:' | sed 's/^skills: *//'); \
		if [ -n "$$skills_line" ]; then \
			for s in $$(echo "$$skills_line" | tr ',' ' '); do \
				s=$$(echo "$$s" | xargs); \
				if [ ! -d "skills/$$s" ]; then \
					echo "  FAIL: $$agent_name — references missing skill '$$s'"; \
					FAIL=1; \
				fi; \
			done; \
		fi; \
		echo "  $$agent_name OK"; \
	done; \
	echo ""; \
	if [ $$FAIL -eq 1 ]; then \
		echo "Validation FAILED"; exit 1; \
	else \
		echo "All checks passed"; \
	fi

# ──────────────────────────────────────────────
# Install / Uninstall (local dev)
# ──────────────────────────────────────────────

install: validate ## Symlink plugin into ~/.claude for local testing
	@mkdir -p $(CLAUDE_DIR)/plugins/cache/local
	@# Symlink entire plugin as a local plugin
	@ln -sfn $(CURDIR) $(CLAUDE_DIR)/plugins/cache/local/$(PLUGIN_NAME)
	@echo "Installed: $(CLAUDE_DIR)/plugins/cache/local/$(PLUGIN_NAME) -> $(CURDIR)"
	@echo ""
	@echo "To activate, run inside Claude Code:"
	@echo "  claude --plugin-dir $(CURDIR)"
	@echo ""
	@echo "Or add to ~/.claude/settings.json manually."

uninstall: ## Remove local plugin symlink
	@rm -f $(CLAUDE_DIR)/plugins/cache/local/$(PLUGIN_NAME)
	@echo "Uninstalled $(PLUGIN_NAME) from local cache"

# ──────────────────────────────────────────────
# Publish
# ──────────────────────────────────────────────

publish: ## Bump version, commit, tag, push to GitHub
	@# Read current version
	$(eval CURRENT := $(shell grep '"version"' $(PLUGIN_JSON) | head -1 | sed 's/.*: *"\(.*\)".*/\1/'))
	@echo "Current version: $(CURRENT)"
	@# Parse semver
	$(eval MAJOR := $(shell echo $(CURRENT) | cut -d. -f1))
	$(eval MINOR := $(shell echo $(CURRENT) | cut -d. -f2))
	$(eval PATCH := $(shell echo $(CURRENT) | cut -d. -f3))
	$(eval NEW_PATCH := $(shell echo $$(($(PATCH) + 1))))
	$(eval NEW_VERSION := $(MAJOR).$(MINOR).$(NEW_PATCH))
	@# Allow override: make publish VERSION=2.0.0
	$(eval VERSION := $(or $(VERSION),$(NEW_VERSION)))
	@echo "Publishing version: $(VERSION)"
	@# Update plugin.json
	@sed -i 's/"version": *"[^"]*"/"version": "$(VERSION)"/' $(PLUGIN_JSON)
	@# Stage, commit, tag, push
	@git add -A
	@git commit -m "Release v$(VERSION)" || echo "Nothing to commit"
	@git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	@git push $(REMOTE) $(BRANCH)
	@git push $(REMOTE) "v$(VERSION)"
	@echo ""
	@echo "Published v$(VERSION) to $(REMOTE)"
	@echo "Install with: claude plugin marketplace add 0x4139/praxis"

release: validate publish ## Validate then publish (the safe path)

# ──────────────────────────────────────────────
# Info
# ──────────────────────────────────────────────

list: ## Show all agents and skills with descriptions
	@echo "Agents:"
	@echo "-------"
	@for f in agents/*.md; do \
		name=$$(basename "$$f" .md); \
		desc=$$(sed -n '/^description:/s/^description: *//p' "$$f" | head -1); \
		printf "  \033[36m%-16s\033[0m %s\n" "$$name" "$$desc"; \
	done
	@echo ""
	@echo "Skills:"
	@echo "-------"
	@for d in skills/*/; do \
		name=$$(basename "$$d"); \
		desc=$$(sed -n '/^description:/s/^description: *//p' "$$d/SKILL.md" 2>/dev/null | head -1); \
		invocable=$$(sed -n '/^user-invocable:/s/^user-invocable: *//p' "$$d/SKILL.md" 2>/dev/null); \
		if [ "$$invocable" = "false" ]; then tag="[ref]"; else tag="[cmd]"; fi; \
		printf "  \033[36m%-22s\033[0m %-5s %s\n" "$$name" "$$tag" "$$desc"; \
	done

version: ## Show current version
	@grep '"version"' $(PLUGIN_JSON) | head -1 | sed 's/.*: *"\(.*\)".*/\1/'