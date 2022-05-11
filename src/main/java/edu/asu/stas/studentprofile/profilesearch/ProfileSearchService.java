package edu.asu.stas.studentprofile.profilesearch;

import edu.asu.stas.studentprofile.StudentProfileRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Objects;

@Service
public class ProfileSearchService {
    private static final int SEARCH_PAGE_SIZE = 6;
    private final StudentProfileRepository studentProfileRepository;

    public ProfileSearchService(StudentProfileRepository profileRepository) {
        this.studentProfileRepository = profileRepository;
    }

    @Transactional
    public ProfileSearch searchForProfile(ProfileSearch profileSearch) {
        PageRequest request = PageRequest.of(profileSearch.getPage(), SEARCH_PAGE_SIZE);
        if (Objects.isNull(profileSearch.getQuery())) {
            return new ProfileSearch(null, null, 0);
        }
        Page<ProfileInfo> page = studentProfileRepository.searchForProfile(profileSearch.getQuery(), request);
        return new ProfileSearch(profileSearch.getQuery(), page.getContent(), page.getNumber());
    }
}
