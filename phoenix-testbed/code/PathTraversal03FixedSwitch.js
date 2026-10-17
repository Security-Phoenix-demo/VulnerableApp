// Phoenix rule-coverage test fixture. NOT part of the application, NOT wired in anywhere.
// Companion to PathTraversal01Vulnerable.js — requested by peer "Hook-part3" (ASPMAIN-8207).
//
// TARGET CWE-22 (Path Traversal) — A SECOND FIX SHAPE. A switch statement over fixed string
// literals only. User input never reaches fs here either. No finding expected.

const express = require('express');
const fs = require('fs');
const router = express.Router();

router.get('/download', (req, res) => {
  const key = req.query.name;
  let filePath;
  switch (key) {
    case 'readme':
      filePath = '/app/docs/README.md';
      break;
    case 'license':
      filePath = '/app/docs/LICENSE.md';
      break;
    default:
      return res.status(404).send('not found');
  }
  const data = fs.readFileSync(filePath, 'utf8');
  res.send(data);
});

module.exports = router;
