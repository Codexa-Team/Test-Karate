package codexateam.reviews;

import com.intuit.karate.junit5.Karate;

public class ReviewsRunner {
    @Karate.Test
    Karate testReviews() {
        return Karate.run("reviews").relativeTo(getClass());
    }
}
