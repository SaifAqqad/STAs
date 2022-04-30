package edu.asu.stas.connnection;

import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import lombok.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Objects;

import static edu.asu.stas.lib.RestUtils.requireNonNull;

@Controller
public class ConnectionController {
    private final ConnectionRepository connectionRepository;

    @Autowired
    public ConnectionController(ConnectionRepository connectionRepository) {
        this.connectionRepository = connectionRepository;
    }

    @GetMapping("/connections")
    @ResponseBody
    public List<ConnectionDto> getConnections() {
        User authedUser = Objects.requireNonNull(UserService.getAuthenticatedUser());
        return connectionRepository.findAllByUser(authedUser)
                .stream()
                .map(conn -> new ConnectionDto(conn.getId(),
                                               conn.getServiceName(),
                                               conn.getServiceUserProfile()))
                .toList();
    }

    @GetMapping("/connections/{serviceName}")
    @ResponseBody
    public ConnectionDto getConnection(@PathVariable @NonNull String serviceName) {
        User authedUser = Objects.requireNonNull(UserService.getAuthenticatedUser());
        var connection = requireNonNull(connectionRepository.findByUserAndServiceName(authedUser, serviceName));
        return new ConnectionDto(connection.getId(),
                                 connection.getServiceName(),
                                 connection.getServiceUserProfile());
    }
}
