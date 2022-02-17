package edu.asu.stas;

import edu.asu.stas.data.models.User;
import edu.asu.stas.data.repositories.UserConnectionRepository;
import edu.asu.stas.data.repositories.UserRepository;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class STAsApplication {

    public static void main(String[] args) {
        SpringApplication.run(STAsApplication.class, args);
    }

    @Bean
    public ApplicationRunner seedDataLoader(UserRepository userRepository,
                                            UserConnectionRepository userConnectionRepository,
                                            PasswordEncoder passwordEncoder) {
        return args -> {
            if (args.containsOption("addSeedData")) {
                User user1 = new User(
                        "Saif",
                        "Aqqad",
                        "saif@gmail.com",
                        passwordEncoder.encode("s1a2i3f4"),
                        "ADMIN");
                userRepository.save(user1);
            }
        };
    }

}
