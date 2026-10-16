// Renders the profile card shown on the account page.
//
// Added for the Phoenix Security enforcement demo. This file exists to be
// caught: it is the ONLY change in its pull request, so the scan result is one
// finding rather than a wall of pre-existing fixtures.

function renderProfileCard(user) {
  const card = document.getElementById("profileCard");

  // The finding. `user.displayName` and `user.bio` are attacker-controlled —
  // both come straight from the profile form with no encoding — and they are
  // written into innerHTML, so any markup in them is parsed and executed.
  // CWE-79, cross-site scripting.
  //
  // The repository already carries a guardrail for exactly this pattern:
  //   guardrail-enforcement/guardrails/claude_code/.claude/rules/guardrail-new_threat-1.md
  // whose globs are ["src/main/resources/static/**/*.js"] — this very path.
  // That rule is ADVISORY. It is guidance text competing for the model's
  // attention, and here it lost. That is the point of the demo: advisory alone
  // does not hold, which is why the other two layers exist.
  card.innerHTML =
    "<h2>" + user.displayName + "</h2>" +
    "<p class='bio'>" + user.bio + "</p>";

  return card;
}

// The safe version, for the "after" half of the demo. Swap the call above for
// this one and the finding goes away: textContent assigns a string, never
// markup, so there is no parser to trick.
function renderProfileCardSafely(user) {
  const card = document.getElementById("profileCard");
  const heading = document.createElement("h2");
  heading.textContent = user.displayName;
  const bio = document.createElement("p");
  bio.className = "bio";
  bio.textContent = user.bio;
  card.replaceChildren(heading, bio);
  return card;
}
