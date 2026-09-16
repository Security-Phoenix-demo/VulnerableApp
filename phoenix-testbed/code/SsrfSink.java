// INTENTIONALLY VULNERABLE — Phoenix correlation test fixture. NOT part of the application.
// NOT COMPILED: outside src/main/java by design. See SqlInjectionSink.java's header.
//
// TARGET CWE-918 (SSRF). Chains to a DAST finding of the same CWE via edge A.
//
// The cloud-metadata endpoint in the comment below is the reason SSRF matters here rather than
// being a generic outbound-request smell: an SSRF that reaches 169.254.169.254 on an instance with
// the IAM role from iac/terraform/02-iam-wildcard-apigw-no-waf.tf yields wildcard AWS credentials.
// That is the cross-domain story the correlation engine exists to surface — code finding plus IaC
// misconfiguration being materially worse together than apart.

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class SsrfSink {

    // Fully attacker-controlled URL, no scheme check, no host allow-list, redirects followed.
    public String fetch(String rawUrl) throws Exception {
        URL url = new URL(rawUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setInstanceFollowRedirects(true);
        conn.setRequestMethod("GET");

        BufferedReader r = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = r.readLine()) != null) {
            out.append(line).append('\n');
        }
        return out.toString();
        // Reachable target on a real instance: http://169.254.169.254/latest/meta-data/iam/security-credentials/
    }
}
