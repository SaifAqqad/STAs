package edu.asu.stas.studentprofile.profilesearch;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller

public class ProfileSearchController {
    private final ProfileSearchService profileSearchService;

    public ProfileSearchController(ProfileSearchService profileSearchService) {
        this.profileSearchService = profileSearchService;
    }

    @GetMapping("/search")
    public String getSearchPage(@RequestParam(required = false) String query, Model model) {
        model.addAttribute("query", query);
        return "home/search";
    }

    @GetMapping(value = "/profile/search")
    @ResponseBody
    public ResponseEntity<ProfileSearch> searchForProfile(ProfileSearch searchParams) {
        var result = profileSearchService.searchForProfile(searchParams);
        return ResponseEntity.ok(result);
    }
}
