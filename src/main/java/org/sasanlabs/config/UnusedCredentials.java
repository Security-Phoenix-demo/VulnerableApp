package org.sasanlabs.config;

/**
 * INTENTIONALLY VULNERABLE — credentials defined but never invoked anywhere.
 * Scanner should detect these but mark as DEFINED_ONLY (lower severity).
 * All values are FAKE/SYNTHETIC.
 */
public class UnusedCredentials {

    // ── SCENARIO 5: Slack bot token — defined, never used (→ HIGH, DEFINED_ONLY) ──
    // intentionally vulnerable — CWE-798 test fixture (synthetic value)
    public static final String SLACK_BOT_TOKEN = "xoxb-EXAMPLE_FAKE-NOT_REAL_TOKEN-SyntheticSlackBotToken123456";

    // ── SCENARIO 6: GitHub PAT — defined, never passed to any client (→ HIGH, DEFINED_ONLY) ──
    public static final String GITHUB_PAT = "github_pat_11AFAKETOKEN000000_abcDefGhiJklMnoPqrStUvWxYz0123456789AbCdEfGhIjKlMnOpQr";

    // ── SCENARIO 7: OpenAI key — defined, never called (→ HIGH, DEFINED_ONLY) ──
    public static final String OPENAI_API_KEY = "sk-proj-FAKEKEY1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZab";

    // ── SCENARIO 8: Database connection string — defined, never used (→ HIGH, DEFINED_ONLY) ──
    public static final String DATABASE_URL = "postgresql://admin:S3cretP@ssw0rd!@prod-db.internal.phoenix.io:5432/phoenix_prod";

    // These are intentionally never referenced from any other class.
    // The call graph should show zero outgoing edges from these symbols.
}
