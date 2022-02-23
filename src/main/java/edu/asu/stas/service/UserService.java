package edu.asu.stas.service;

import edu.asu.stas.data.dto.AccountDetails;
import edu.asu.stas.data.models.User;
import edu.asu.stas.data.models.UserConnection;
import edu.asu.stas.data.dao.UserConnectionRepository;
import edu.asu.stas.data.dao.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;
    private final UserConnectionRepository userConnectionRepository;

    @Autowired
    public UserService(UserRepository userRepository, UserConnectionRepository userConnectionRepository) {
        this.userRepository = userRepository;
        this.userConnectionRepository = userConnectionRepository;
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    public List<UserConnection> getUserConnections(User user) {
        return userConnectionRepository.findAllByUserId(user.getId());
    }


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return Objects.requireNonNullElseGet(findByEmail(username.toLowerCase()), () -> {
            throw new UsernameNotFoundException("User not found");
        });
    }

    public void updateUserByAccountDetails(User user, AccountDetails accountDetails) {
        user.setFirstName(accountDetails.getFirstName());
        user.setLastName(accountDetails.getLastName());
        user.setEmail(accountDetails.getEmail());
        user.setDateOfBirth(accountDetails.getDateOfBirth());
        userRepository.save(user);
    }

}
