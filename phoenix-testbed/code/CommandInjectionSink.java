// INTENTIONALLY VULNERABLE — Phoenix correlation test fixture. NOT part of the application.
// NOT COMPILED: outside src/main/java by design. See SqlInjectionSink.java's header.
//
// TARGET CWE-78 (OS Command Injection). Chains to a DAST finding of the same CWE via edge A.
//
// This is the CWE that carries the test bed's ONLY CONFIRMED-confidence chain: when a
// dast_validation_link row exists linking a code finding to a DAST finding, edge A's branch 1
// returns proof key DAST_VALIDATION_LINK at confidence CONFIRMED — the single strongest evidence
// the engine can record. CWE equality alone only ever reaches LOW/VERY_LOW.

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class CommandInjectionSink {

    // Untrusted host string concatenated into a shell command line.
    public String ping(String host) throws Exception {
        Process p = Runtime.getRuntime().exec("ping -c 1 " + host);
        BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = r.readLine()) != null) {
            out.append(line).append('\n');
        }
        return out.toString();
    }

    // Explicit shell invocation — `sh -c` makes every shell metacharacter live, so this is the
    // more severe of the two even though it looks more deliberate.
    public String archive(String path) throws Exception {
        String[] cmd = {"/bin/sh", "-c", "tar -czf /tmp/backup.tgz " + path};
        Process p = Runtime.getRuntime().exec(cmd);
        p.waitFor();
        return "exit=" + p.exitValue();
    }
}
