package codexateam.listings.vehicles;

import com.intuit.karate.junit5.Karate;

public class VehiclesRunner {
    @Karate.Test
    Karate testVehicles() {
        return Karate.run("vehicles").relativeTo(getClass());
    }
}
