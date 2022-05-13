package edu.asu.stas.studentprofile.profilesearch;

import edu.asu.stas.studentprofile.StudentProfile;
import edu.asu.stas.studentprofile.StudentProfileRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
public class ProfileSearchService {
    private static final int SEARCH_PAGE_SIZE = 6;
    private static final ProfileSearch EMPTY_SEARCH = new ProfileSearch(null, null, 0, 0);
    private final StudentProfileRepository studentProfileRepository;

    public ProfileSearchService(StudentProfileRepository profileRepository) {
        this.studentProfileRepository = profileRepository;
    }

    public ProfileSearch searchForProfile(ProfileSearch profileSearch) {
        sanitizeSearch(profileSearch);
        if (profileSearch.getQuery().isBlank()) {
            return EMPTY_SEARCH;
        }
        Page<StudentProfile> page = studentProfileRepository.searchForProfile(
                profileSearch.getQuery(),
                PageRequest.of(profileSearch.getPage(), SEARCH_PAGE_SIZE)
        );
        return new ProfileSearch(profileSearch.getQuery(),
                                 page.get().map(ProfileInfo::new).toList(),
                                 page.getNumber(),
                                 page.getTotalElements());
    }

    private void sanitizeSearch(ProfileSearch profileSearch) {
        String query = Objects.requireNonNullElse(profileSearch.getQuery(), "");
        profileSearch.setQuery(query.replaceAll("[@!#$%^&*(){}~`\":;./?\\\\]", "\s"));
    }
}
