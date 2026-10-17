// Phoenix rule-coverage test fixture. NOT part of the application, NOT wired in anywhere.
// Companion to PathTraversal01Vulnerable.js — requested by peer "Hook-part3" (ASPMAIN-8207).
//
// TARGET CWE-22 (Path Traversal) — THE FIX. The key the caller supplies only ever selects among
// fixed string-literal paths in a closed object. User input never reaches fs. No finding expected.

const express = require('express');
const fs = require('fs');
const router = express.Router();

const ALLOWED_FILES = {
  readme: '/app/docs/README.md',
  license: '/app/docs/LICENSE.md',
  changelog: '/app/docs/CHANGELOG.md',
};

router.get('/download', (req, res) => {
  const key = req.query.name;
  const filePath = ALLOWED_FILES[key];
  if (!filePath) {
    return res.status(404).send('not found');
  }
  const data = fs.readFileSync(filePath, 'utf8');
  res.send(data);
});

module.exports = router;
