// Phoenix rule-coverage test fixture. NOT part of the application, NOT wired in anywhere.
// Companion to PathTraversal01Vulnerable.js — requested by peer "Hook-part3" (ASPMAIN-8207).
//
// TARGET CWE-22 (Path Traversal) — A KNOWN LIMITATION, NOT A FIX. path.basename() strips
// directory segments from the string, but does not confine the result to any base directory —
// the caller can still ask for any file that happens to share a basename. Expected to STILL be
// flagged.

const express = require('express');
const fs = require('fs');
const path = require('path');
const router = express.Router();

router.get('/download', (req, res) => {
  const name = path.basename(req.query.name);
  const data = fs.readFileSync(name, 'utf8');
  res.send(data);
});

module.exports = router;
