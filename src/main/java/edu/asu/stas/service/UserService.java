package edu.asu.stas.service;

import edu.asu.stas.data.models.User;
import edu.asu.stas.data.models.UserConnection;
import edu.asu.stas.data.repositories.UserConnectionRepository;
import edu.asu.stas.data.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;
    private final UserConnectionRepository userConnectionRepository;

    @Autowired
    public UserService(UserRepository userRepository, UserConnectionRepository userConnectionRepository) {
        this.userRepository = userRepository;
        this.userConnectionRepository = userConnectionRepository;
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public List<UserConnection> getUserConnections(User user) {
        return userConnectionRepository.findAllByUserId(user.getId());
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return findByEmail(username.toLowerCase()).orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }
}
