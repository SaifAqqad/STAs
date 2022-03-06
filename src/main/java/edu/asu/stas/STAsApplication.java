package edu.asu.stas;

import edu.asu.stas.data.dao.UserRepository;
import edu.asu.stas.data.models.User;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;

@SpringBootApplication
public class STAsApplication {

    public static void main(String[] args) {
        SpringApplication.run(STAsApplication.class, args);
    }

    @Bean
    public ApplicationRunner seedDataLoader(UserRepository userRepository,
                                            PasswordEncoder passwordEncoder) {
        return args -> {
            if (args.containsOption("addSeedData")) {
                User user1 = new User();
                user1.setFirstName("Saif");
                user1.setLastName("Aqqad");
                user1.setEmail("saif@gmail.com");
                user1.setPassword(passwordEncoder.encode("s1a2i3f4"));
                user1.setDateOfBirth(LocalDate.of(1999, 10, 14));
                user1.setRole(User.Roles.ADMIN);
                user1.setEnabled(true);
                userRepository.save(user1);
            }
        };
    }

}
