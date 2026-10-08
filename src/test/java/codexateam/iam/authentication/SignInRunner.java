package codexateam.iam.authentication;

import com.intuit.karate.junit5.Karate;

public class SignInRunner {
    @Karate.Test
    Karate testSignIn() {
        return Karate.run("sign-in").relativeTo(getClass());
    }
}
