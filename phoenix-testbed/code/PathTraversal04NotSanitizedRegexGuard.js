// Phoenix rule-coverage test fixture. NOT part of the application, NOT wired in anywhere.
// Companion to PathTraversal01Vulnerable.js — requested by peer "Hook-part3" (ASPMAIN-8207).
//
// TARGET CWE-22 (Path Traversal) — A KNOWN LIMITATION, NOT A FIX. A regex character-class guard
// is not a real path sanitizer (it does not resolve "..", drive letters, or absolute paths on
// every platform the same way). This is expected to STILL be flagged.

const express = require('express');
const fs = require('fs');
const router = express.Router();

router.get('/download', (req, res) => {
  const name = req.query.name;
  if (!/^[a-zA-Z0-9_.-]+$/.test(name)) {
    return res.status(400).send('bad name');
  }
  const data = fs.readFileSync(name, 'utf8');
  res.send(data);
});

module.exports = router;
