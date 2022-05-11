package edu.asu.stas.studentprofile.profilesearch;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController

public class ProfileSearchController {
    private final ProfileSearchService profileSearchService;

    public ProfileSearchController(ProfileSearchService profileSearchService) {
        this.profileSearchService = profileSearchService;
    }

    @GetMapping("/search")
    public ResponseEntity<ProfileSearch> searchForProfile(ProfileSearch searchParams) {
        var result = profileSearchService.searchForProfile(searchParams);
        return ResponseEntity.ok(result);
    }
}
