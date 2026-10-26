// INTENTIONALLY VULNERABLE — Phoenix correlation test fixture. NOT part of the application.
//
// NOT COMPILED: this file lives outside src/main/java, so Gradle's default sourceSet never sees it.
// It exists only to be READ by a scanner. Do not move it under src/ — it would break the build
// (no package, unresolved imports by design) and change what the app ships.
//
// TARGET CWE-89 (SQL Injection). Chains to a DAST finding of the same CWE via correlation edge A
// (CODE_DAST, proof key CWE_ONLY).
//
// WHICH SCANNER IS EXPECTED TO CATCH THIS, AND WHICH IS NOT:
//   HUNT (the LLM exploit pass) — EXPECTED. It assigns a CWE per finding, and CWE is the join key
//     edge A hash-joins on. This is the realistic code side of an edge-A chain in this repo.
//   SAST (OpenGrep/semgrep) — will very likely produce a finding, but that finding is expected to
//     be UNCHAINABLE. CorrelatableFinding.cwe for SAST is DERIVED by a /(?i)(CWE-\d+)/ regex over
//     the RULE ID, not from a column — and 0 of 121 real SAST rule ids in this repo contain a
//     CWE token. A SAST hit here therefore carries cwe = null and cannot satisfy edge A.
//     Writing "CWE-89" in this comment does NOT change that: the regex reads the rule id, never
//     the source text.

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

public class SqlInjectionSink {

    // Value bound as a parameter, so input cannot change the statement.
    public ResultSet findUserById(Connection conn, String userId) throws Exception {
        PreparedStatement ps = conn.prepareStatement("SELECT id, username, email FROM users WHERE id = ?");
        ps.setString(1, userId);
        return ps.executeQuery();
    }

    // ORDER BY cannot be parameterised, so the column comes from a fixed allow-list.
    public ResultSet listUsersSorted(Connection conn, String sortColumn) throws Exception {
        String column = java.util.Set.of("id", "username").contains(sortColumn) ? sortColumn : "id";
        return conn.createStatement().executeQuery("SELECT id, username FROM users ORDER BY " + column);
    }
}
