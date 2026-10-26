package lab1.target;

import java.io.InputStream;
import java.io.ObjectInputStream;

// LAB FIXTURE, intentionally vulnerable and not compiled (outside src/). Planted so SAST has critical findings.
public class CommandInjectionSink {

    private static final java.util.regex.Pattern HOST = java.util.regex.Pattern.compile("[A-Za-z0-9.-]{1,253}");

    // No shell: fixed argument array, host checked against an allow-list pattern.
    public Process ping(String host) throws Exception {
        if (!HOST.matcher(host).matches() || host.startsWith("-")) {
            throw new IllegalArgumentException("invalid host");
        }
        return new ProcessBuilder("ping", "-c", "1", host).start();
    }

    // Deserialization limited to an allow-list of classes; everything else is rejected.
    public Object load(InputStream untrusted) throws Exception {
        ObjectInputStream in = new ObjectInputStream(untrusted);
        in.setObjectInputFilter(java.io.ObjectInputFilter.Config.createFilter("java.lang.String;java.util.*;!*"));
        return in.readObject();
    }
}
