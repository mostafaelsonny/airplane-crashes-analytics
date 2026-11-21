#!/usr/bin/env bash
# ==============================================================================
# Setup GitHub Repository - Real-Time Airplane Crashes Analytics
# ==============================================================================
# Automates repo creation, pushing main + develop, labels, milestones, rulesets.
#
# Usage:
#   ./scripts/setup_github.sh [repo-name] [public|private]        (default: public)
#   COLLABORATORS="rony-user rovan-user ebrahim-user febronia-user monzer-user" ./scripts/setup_github.sh
#
set -euo pipefail

REPO_NAME="${1:-airplane-crashes-analytics}"
VISIBILITY="${2:-public}"

command -v git >/dev/null || { echo "git is not installed"; exit 1; }
command -v gh  >/dev/null || { echo "Install GitHub CLI first: https://cli.github.com"; exit 1; }
gh auth status >/dev/null 2>&1 || gh auth login

cd "$(dirname "$0")/.."

if [ ! -d .git ]; then
  git init -b main
fi
git add -A
git commit -m "chore: initial project scaffold and architecture governance" || echo "(nothing new to commit)"

# Create repository on GitHub
gh repo create "$REPO_NAME" "--$VISIBILITY" --source=. --remote=origin --push

# Push develop branch & set as default branch for daily integration
git checkout -B develop
git push -u origin develop
gh repo edit --default-branch develop

# Setup Project Labels
mk_label() { gh label create "$1" --color "$2" --description "$3" --force >/dev/null; }
mk_label "sprint-1"          "1d76db" "Sprint 1 — Foundation & PoC"
mk_label "sprint-2"          "0e8a16" "Sprint 2 — Analytics & Processing"
mk_label "sprint-3"          "fbca04" "Sprint 3 — Integration & Optimization"
mk_label "leader"            "2cbe4e" "Team Leader & Architecture Review"
mk_label "data-engineering"   "e3b341" "Data Producer & Dataset Inspection"
mk_label "infrastructure"    "f66a0a" "Docker, Kafka & Networking"
mk_label "etl-nifi"          "d73a4a" "Apache NiFi ETL & Routing"
mk_label "spark-processing"  "8250df" "Apache Spark Structured Streaming"
mk_label "database"          "0969da" "PostgreSQL & Database Schema"
mk_label "data-contract"     "5319e7" "Unified Data Contract"
mk_label "task"              "ededed" "Sprint Task"
mk_label "bug"               "b60205" "Something is broken or failing"
mk_label "blocked"           "d73a4a" "Blocked by dependency"
mk_label "needs-fixes"       "e99695" "Reviewed by Mostafa - changes requested"

# Setup Milestones
for s in 1 2 3; do
  gh api "repos/{owner}/{repo}/milestones" -f title="Sprint $s" >/dev/null || true
done

# Apply Rulesets (protect main & develop)
for b in main develop; do
  gh api -X POST "repos/{owner}/{repo}/rulesets" --input ".github/rulesets/protect-$b.json" >/dev/null \
    && echo "Ruleset applied: protect-$b" \
    || echo "WARN: Could not apply ruleset for '$b'. Import manually via Settings -> Rulesets."
done

# Add Collaborators
for u in ${COLLABORATORS:-}; do
  gh api -X PUT "repos/{owner}/{repo}/collaborators/$u" -f permission=push >/dev/null \
    && echo "Invited $u (Write access)" || echo "WARN: Could not invite $u"
done

echo
echo "=============================================================================="
echo "Done! Repository: $(gh repo view --json url -q .url)"
echo "Rulesets active: main and develop are fully protected."
echo "Only Mostafa (@mostafaelsonny) can review and merge PRs."
echo "=============================================================================="
