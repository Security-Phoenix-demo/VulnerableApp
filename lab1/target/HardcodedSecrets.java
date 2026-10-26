package lab1.target;

// Credentials come from the environment, never from source.
public class HardcodedSecrets {
    static final String AWS_ACCESS_KEY_ID = System.getenv("AWS_ACCESS_KEY_ID");
    static final String AWS_SECRET_ACCESS_KEY = System.getenv("AWS_SECRET_ACCESS_KEY");
}
// rescan marker 1792961502
