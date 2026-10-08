package codexateam.iam.roles;

import com.intuit.karate.junit5.Karate;

public class RolesRunner {
    @Karate.Test
    Karate testRoles() {
        return Karate.run("roles").relativeTo(getClass());
    }
}
