package codexateam.iot;

import com.intuit.karate.junit5.Karate;

public class TelemetryRunner {
    @Karate.Test
    Karate testTelemetry() {
        return Karate.run("telemetry").relativeTo(getClass());
    }
}
