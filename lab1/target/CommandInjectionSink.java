package lab1.target;

import java.io.InputStream;
import java.io.ObjectInputStream;

// LAB FIXTURE, intentionally vulnerable and not compiled (outside src/). Planted so SAST has critical findings.
public class CommandInjectionSink {

    // OS command injection: untrusted host is concatenated into a shell command.
    public Process ping(String host) throws Exception {
        return Runtime.getRuntime().exec("sh -c 'ping -c 1 " + host + "'");
    }

    // Unsafe deserialization of untrusted bytes.
    public Object load(InputStream untrusted) throws Exception {
        return new ObjectInputStream(untrusted).readObject();
    }
}
