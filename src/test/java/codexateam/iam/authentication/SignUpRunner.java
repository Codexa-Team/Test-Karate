package codexateam.iam.authentication;

import com.intuit.karate.junit5.Karate;

public class SignUpRunner {
    @Karate.Test
    Karate testSignUp() {
        return Karate.run("sign-up").relativeTo(getClass());
    }
}
