// INTENTIONALLY VULNERABLE — Phoenix rule-coverage test fixture. NOT part of the application.
// NOT WIRED IN: this router is never require()'d or mounted anywhere. See SsrfSink.java's header
// for why fixtures in this directory are real files meant to be really scanned.
//
// TARGET CWE-22 (Path Traversal). Requested by peer "Hook-part3" (ASPMAIN-8207) to confirm rule
// phx-js-express-path-traversal-fs still fires on this exact shape, and that the unrelated
// detect-non-literal-fs-filename rule does NOT also fire on it.

const express = require('express');
const fs = require('fs');
const router = express.Router();

// VULNERABLE: the query parameter flows straight into fs.readFileSync with no check at all.
router.get('/download', (req, res) => {
  const name = req.query.name;
  const data = fs.readFileSync(name, 'utf8');
  res.send(data);
});

module.exports = router;
