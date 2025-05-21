#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# genz-commit.sh
#
# Reads your staged git diff, sends it to Gemini 2.0 Flash on Google’s
# Generative Language API, then commits with a gitmoji-decorated message.
#
# Prereqs:
#  • jq
#  • $GEMINI_API_KEY set to your Google API key
# -----------------------------------------------------------------------------

MODEL="gemini-2.5-flash-preview-05-20"
THINKING_BUDGET=200

if [[ -z "${GEMINI_API_KEY:-}" ]]; then
  echo "Error: GEMINI_API_KEY is not set." >&2
  exit 1
fi

diff=$(git diff --staged)
if [[ -z "$diff" ]]; then
  echo "No staged changes to commit."
  exit 0
fi

PROMPT=$(
  cat <<'EOF'
You are an assistant that writes concise git commit messages using gitmoji.
Given the following git diff, output exactly one commit message:
    - Begin with the correct gitmoji (e.g. 🔥, ✨, 🐛).
    - Follow with a short (≤50 characters) description.
    - Do NOT include any extra emojis or commentary.

Specification
A gitmoji commit message consists is composed using the following pieces:

intention: The intention you want to express with the commit, using an emoji from the list. Either in the :shortcode: or unicode format.
scope: An optional string that adds contextual information for the scope of the change.
message: A brief explanation of the change.
<intention> [scope?][:?] <message>


Examples
⚡️ Lazyload home screen images.
🐛 Fix `onClick` event handler
🔖 Bump version `1.2.0`
♻️ (components): Transform classes to hooks
📈 Add analytics to the dashboard
🌐 Support Japanese language
♿️ (account): Improve modals a11y

Scan the diff to choose the emoji matching the change.
Write an Effective Subject Line
	•	≤ 50 characters (excluding emoji and scope).
	•	Use imperative mood (“Add,” not “Added” or “Adding”).
	•	Present tense (“Fix bug,” not “Fixed bug”).
	•	No trailing period.
Include a Scope When Helpful
	•	If the change targets a specific module or component: (api), (auth), (ui), etc.
	•	Helps others locate affected area quickly.
Keep It Atomic
	•	One logical change per commit.
	•	Split unrelated changes into multiple commits for clarity.

These are the available gitmoji codes and the intent of each (ONLY EVER USE ONE OF THESE):

🎨 :art:
Improve structure / format of the code.

⚡️ :zap:
Improve performance.

🔥 :fire:
Remove code or files.

🐛 :bug:
Fix a bug.

🚑️ :ambulance:
Critical hotfix.

✨ :sparkles:
Introduce new features.

📝 :memo:
Add or update documentation.

🚀 :rocket:
Deploy stuff.

💄 :lipstick:
Add or update the UI and style files.

🎉 :tada:
Begin a project.

✅ :white_check_mark:
Add, update, or pass tests.

🔒️ :lock:
Fix security or privacy issues.

🔐 :closed_lock_with_key:
Add or update secrets.

🔖 :bookmark:
Release / Version tags.

🚨 :rotating_light:
Fix compiler / linter warnings.

🚧 :construction:
Work in progress.

💚 :green_heart:
Fix CI Build.

⬇️ :arrow_down:
Downgrade dependencies.

⬆️ :arrow_up:
Upgrade dependencies.

📌 :pushpin:
Pin dependencies to specific versions.

👷 :construction_worker:
Add or update CI build system.

📈 :chart_with_upwards_trend:
Add or update analytics or track code.

♻️ :recycle:
Refactor code.

➕ :heavy_plus_sign:
Add a dependency.

➖ :heavy_minus_sign:
Remove a dependency.

🔧 :wrench:
Add or update configuration files.

🔨 :hammer:
Add or update development scripts.

🌐 :globe_with_meridians:
Internationalization and localization.

✏️ :pencil2:
Fix typos.

💩 :poop:
Write bad code that needs to be improved.

⏪️ :rewind:
Revert changes.

🔀 :twisted_rightwards_arrows:
Merge branches.

📦️ :package:
Add or update compiled files or packages.

👽️ :alien:
Update code due to external API changes.

🚚 :truck:
Move or rename resources (e.g.: files, paths, routes).

📄 :page_facing_up:
Add or update license.

💥 :boom:
Introduce breaking changes.

🍱 :bento:
Add or update assets.

♿️ :wheelchair:
Improve accessibility.

💡 :bulb:
Add or update comments in source code.

🍻 :beers:
Write code drunkenly.

💬 :speech_balloon:
Add or update text and literals.

🗃️ :card_file_box:
Perform database related changes.

🔊 :loud_sound:
Add or update logs.

🔇 :mute:
Remove logs.

👥 :busts_in_silhouette:
Add or update contributor(s).

🚸 :children_crossing:
Improve user experience / usability.

🏗️ :building_construction:
Make architectural changes.

📱 :iphone:
Work on responsive design.

🤡 :clown_face:
Mock things.

🥚 :egg:
Add or update an easter egg.

🙈 :see_no_evil:
Add or update a .gitignore file.

📸 :camera_flash:
Add or update snapshots.

⚗️ :alembic:
Perform experiments.

🔍️ :mag:
Improve SEO.

🏷️ :label:
Add or update types.

🌱 :seedling:
Add or update seed files.

🚩 :triangular_flag_on_post:
Add, update, or remove feature flags.

🥅 :goal_net:
Catch errors.

💫 :dizzy:
Add or update animations and transitions.

🗑️ :wastebasket:
Deprecate code that needs to be cleaned up.

🛂 :passport_control:
Work on code related to authorization, roles and permissions.

🩹 :adhesive_bandage:
Simple fix for a non-critical issue.

🧐 :monocle_face:
Data exploration/inspection.

⚰️ :coffin:
Remove dead code.

🧪 :test_tube:
Add a failing test.

👔 :necktie:
Add or update business logic.

🩺 :stethoscope:
Add or update healthcheck.

🧱 :bricks:
Infrastructure related changes.

🧑‍💻 :technologist:
Improve developer experience.

💸 :money_with_wings:
Add sponsorships or money related infrastructure.

🧵 :thread:
Add or update code related to multithreading or concurrency.

🦺 :safety_vest:
Add or update code related to validation.

✈️ :airplane:
Improve offline support.

Diff:
EOF
)
PROMPT+=$'\n'"$diff"

request_body=$(jq -nc --arg txt "$PROMPT" --arg thinkingBudget "$THINKING_BUDGET" '{
  contents: [
    {
      parts: [
        { text: $txt }
      ]
    }
  ],
  "generationConfig": {
    "thinkingConfig": {
      "thinkingBudget": $thinkingBudget
    }
  }
}')

echo ...
# https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/inference
response=$(curl -sS \
  -H "Content-Type: application/json" \
  -X POST "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY}" \
  -d "$request_body")

commit_msg=$(printf '%s' "$response" |
  jq -r '.candidates[0].content.parts[0].text // empty' |
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [[ -z "$commit_msg" ]]; then
  echo "Error: no commit message returned." >&2
  echo "$response" >&2
  exit 1
fi

# Clear input buffer to prevent accidental commands
while read -t 0.1 -n 1 && [[ $REPLY == $'\n' ]]; do :; done

while true; do
  echo
  echo "$commit_msg"
  echo

  # Extract emoji and find its textual representation
  emoji_char=${commit_msg:0:1}
  emoji_text=""
  emoji_meaning=""

  # Map emoji to its text representation and meaning
  case "$emoji_char" in
  "🎨")
    emoji_text=":art:"
    emoji_meaning="Improve structure/format of code"
    ;;
  "⚡️")
    emoji_text=":zap:"
    emoji_meaning="Improve performance"
    ;;
  "🔥")
    emoji_text=":fire:"
    emoji_meaning="Remove code or files"
    ;;
  "🐛")
    emoji_text=":bug:"
    emoji_meaning="Fix a bug"
    ;;
  "🚑️")
    emoji_text=":ambulance:"
    emoji_meaning="Critical hotfix"
    ;;
  "✨")
    emoji_text=":sparkles:"
    emoji_meaning="Introduce new features"
    ;;
  "📝")
    emoji_text=":memo:"
    emoji_meaning="Add or update documentation"
    ;;
  "🚀")
    emoji_text=":rocket:"
    emoji_meaning="Deploy stuff"
    ;;
  "💄")
    emoji_text=":lipstick:"
    emoji_meaning="Add or update UI and style files"
    ;;
  "🎉")
    emoji_text=":tada:"
    emoji_meaning="Begin a project"
    ;;
  "✅")
    emoji_text=":white_check_mark:"
    emoji_meaning="Add, update, or pass tests"
    ;;
  "🔒️")
    emoji_text=":lock:"
    emoji_meaning="Fix security or privacy issues"
    ;;
  "🔐")
    emoji_text=":closed_lock_with_key:"
    emoji_meaning="Add or update secrets"
    ;;
  "🔖")
    emoji_text=":bookmark:"
    emoji_meaning="Release / Version tags"
    ;;
  "🚨")
    emoji_text=":rotating_light:"
    emoji_meaning="Fix compiler/linter warnings"
    ;;
  "🚧")
    emoji_text=":construction:"
    emoji_meaning="Work in progress"
    ;;
  "💚")
    emoji_text=":green_heart:"
    emoji_meaning="Fix CI Build"
    ;;
  "⬇️")
    emoji_text=":arrow_down:"
    emoji_meaning="Downgrade dependencies"
    ;;
  "⬆️")
    emoji_text=":arrow_up:"
    emoji_meaning="Upgrade dependencies"
    ;;
  "📌")
    emoji_text=":pushpin:"
    emoji_meaning="Pin dependencies"
    ;;
  "👷")
    emoji_text=":construction_worker:"
    emoji_meaning="Add or update CI build system"
    ;;
  "📈")
    emoji_text=":chart_with_upwards_trend:"
    emoji_meaning="Add or update analytics"
    ;;
  "♻️")
    emoji_text=":recycle:"
    emoji_meaning="Refactor code"
    ;;
  "➕")
    emoji_text=":heavy_plus_sign:"
    emoji_meaning="Add a dependency"
    ;;
  "➖")
    emoji_text=":heavy_minus_sign:"
    emoji_meaning="Remove a dependency"
    ;;
  "🔧")
    emoji_text=":wrench:"
    emoji_meaning="Add or update configuration files"
    ;;
  "🔨")
    emoji_text=":hammer:"
    emoji_meaning="Add or update development scripts"
    ;;
  "🌐")
    emoji_text=":globe_with_meridians:"
    emoji_meaning="Internationalization and localization"
    ;;
  "✏️")
    emoji_text=":pencil2:"
    emoji_meaning="Fix typos"
    ;;
  "💩")
    emoji_text=":poop:"
    emoji_meaning="Write bad code that needs improvement"
    ;;
  "⏪️")
    emoji_text=":rewind:"
    emoji_meaning="Revert changes"
    ;;
  "🔀")
    emoji_text=":twisted_rightwards_arrows:"
    emoji_meaning="Merge branches"
    ;;
  "📦️")
    emoji_text=":package:"
    emoji_meaning="Add or update compiled files or packages"
    ;;
  "👽️")
    emoji_text=":alien:"
    emoji_meaning="Update code due to external API changes"
    ;;
  "🚚")
    emoji_text=":truck:"
    emoji_meaning="Move or rename resources"
    ;;
  "📄")
    emoji_text=":page_facing_up:"
    emoji_meaning="Add or update license"
    ;;
  "💥")
    emoji_text=":boom:"
    emoji_meaning="Introduce breaking changes"
    ;;
  "🍱")
    emoji_text=":bento:"
    emoji_meaning="Add or update assets"
    ;;
  "♿️")
    emoji_text=":wheelchair:"
    emoji_meaning="Improve accessibility"
    ;;
  "💡")
    emoji_text=":bulb:"
    emoji_meaning="Add or update comments in source code"
    ;;
  "🍻")
    emoji_text=":beers:"
    emoji_meaning="Write code drunkenly"
    ;;
  "💬")
    emoji_text=":speech_balloon:"
    emoji_meaning="Add or update text and literals"
    ;;
  "🗃️")
    emoji_text=":card_file_box:"
    emoji_meaning="Perform database related changes"
    ;;
  "🔊")
    emoji_text=":loud_sound:"
    emoji_meaning="Add or update logs"
    ;;
  "🔇")
    emoji_text=":mute:"
    emoji_meaning="Remove logs"
    ;;
  "👥")
    emoji_text=":busts_in_silhouette:"
    emoji_meaning="Add or update contributor(s)"
    ;;
  "🚸")
    emoji_text=":children_crossing:"
    emoji_meaning="Improve user experience"
    ;;
  "🏗️")
    emoji_text=":building_construction:"
    emoji_meaning="Make architectural changes"
    ;;
  "📱")
    emoji_text=":iphone:"
    emoji_meaning="Work on responsive design"
    ;;
  "🤡")
    emoji_text=":clown_face:"
    emoji_meaning="Mock things"
    ;;
  "🥚")
    emoji_text=":egg:"
    emoji_meaning="Add or update an easter egg"
    ;;
  "🙈")
    emoji_text=":see_no_evil:"
    emoji_meaning="Add or update .gitignore file"
    ;;
  "📸")
    emoji_text=":camera_flash:"
    emoji_meaning="Add or update snapshots"
    ;;
  "⚗️")
    emoji_text=":alembic:"
    emoji_meaning="Perform experiments"
    ;;
  "🔍️")
    emoji_text=":mag:"
    emoji_meaning="Improve SEO"
    ;;
  "🏷️")
    emoji_text=":label:"
    emoji_meaning="Add or update types"
    ;;
  "🌱")
    emoji_text=":seedling:"
    emoji_meaning="Add or update seed files"
    ;;
  "🚩")
    emoji_text=":triangular_flag_on_post:"
    emoji_meaning="Add/update/remove feature flags"
    ;;
  "🥅")
    emoji_text=":goal_net:"
    emoji_meaning="Catch errors"
    ;;
  "💫")
    emoji_text=":dizzy:"
    emoji_meaning="Add or update animations and transitions"
    ;;
  "🗑️")
    emoji_text=":wastebasket:"
    emoji_meaning="Deprecate code that needs to be cleaned up"
    ;;
  "🛂")
    emoji_text=":passport_control:"
    emoji_meaning="Work on authorization/permissions"
    ;;
  "🩹")
    emoji_text=":adhesive_bandage:"
    emoji_meaning="Simple fix for a non-critical issue"
    ;;
  "🧐")
    emoji_text=":monocle_face:"
    emoji_meaning="Data exploration/inspection"
    ;;
  "⚰️")
    emoji_text=":coffin:"
    emoji_meaning="Remove dead code"
    ;;
  "🧪")
    emoji_text=":test_tube:"
    emoji_meaning="Add a failing test"
    ;;
  "👔")
    emoji_text=":necktie:"
    emoji_meaning="Add or update business logic"
    ;;
  "🩺")
    emoji_text=":stethoscope:"
    emoji_meaning="Add or update healthcheck"
    ;;
  "🧱")
    emoji_text=":bricks:"
    emoji_meaning="Infrastructure related changes"
    ;;
  "🧑‍💻")
    emoji_text=":technologist:"
    emoji_meaning="Improve developer experience"
    ;;
  "💸")
    emoji_text=":money_with_wings:"
    emoji_meaning="Add sponsorships or money related infrastructure"
    ;;
  "🧵")
    emoji_text=":thread:"
    emoji_meaning="Add/update code for multithreading/concurrency"
    ;;
  "🦺")
    emoji_text=":safety_vest:"
    emoji_meaning="Add or update code related to validation"
    ;;
  "✈️")
    emoji_text=":airplane:"
    emoji_meaning="Improve offline support"
    ;;
  *)
    emoji_text="Unknown emoji"
    emoji_meaning="No description available"
    ;;
  esac

  echo "$emoji_text - $emoji_meaning"
  echo

  read -p "Action? [c]ommit/[e]dit/e[x]plain/[q]uit: " action

  case "${action,,}" in
  "" | "c" | "commit")
    git commit -m "$commit_msg"
    break
    ;;
  "e" | "edit")
    echo
    read -e -i "$commit_msg" -p "Edit commit message: " commit_msg
    ;;
  "x" | "explain")
    echo "Getting explanation..."
    explain_prompt="You provided this commit message: '$commit_msg'

    based on the following prompt:
    '$PROMPT'

    Please explain in plain text (no markdown):
    1. THE GITMOJI: What does this specific gitmoji (${commit_msg:0:1}) represent? What type of change does it indicate?
    2. THE MESSAGE: How does this message relate to the git diff? What specific changes is it highlighting?

Keep your explanation under 5 lines total. Use simple language. No justifications needed - just explain what the emoji means and how the message relates to the actual code changes."

    explain_body=$(jq -nc --arg txt "$explain_prompt" '{
        contents: [
          {
            parts: [
              { text: $txt }
            ]
          }
        ]
      }')

    # Request explanation from Gemini
    explain_response=$(curl -sS \
      -H "Content-Type: application/json" \
      -X POST "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY}" \
      -d "$explain_body")

    explanation=$(printf '%s' "$explain_response" |
      jq -r '.candidates[0].content.parts[0].text // empty')

    echo
    echo "Explanation:"
    echo "-------------"
    echo "$explanation"
    echo "-------------"

    # Clear input buffer after explanation to prevent accidental actions
    while read -t 0.1 -n 1 && [[ $REPLY == $'\n' ]]; do :; done
    ;;
  "q" | "quit")
    echo "Commit cancelled."
    exit 0
    ;;
  *)
    echo "Invalid option. Try again."
    ;;
  esac
done
