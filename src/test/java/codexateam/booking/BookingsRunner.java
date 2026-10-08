package codexateam.booking;

import com.intuit.karate.junit5.Karate;

public class BookingsRunner {
    @Karate.Test
    Karate testBookings() {
        return Karate.run("bookings").relativeTo(getClass());
    }
}
