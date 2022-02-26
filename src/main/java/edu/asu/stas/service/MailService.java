package edu.asu.stas.service;

import edu.asu.stas.data.models.User;
import edu.asu.stas.data.models.UserVerificationToken;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;

import static javax.mail.internet.MimeMessage.RecipientType.TO;

@Component
@Log
public class MailService {
    private final JavaMailSender mailSender;
    private final Configuration configuration;

    @Value("${spring.mail.username}")
    private String fromEmail;


    public MailService(JavaMailSender mailSender, Configuration configuration) {
        this.mailSender = mailSender;
        this.configuration = configuration;
    }

    public void sendVerificationEmail(User user, UserVerificationToken token) {
        String baseUrl = ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString();
        String url = baseUrl + "/register/verify?token=" + token.getToken();
        try {
            String msg = getMessageFromTemplate("email/verify.ftl", Map.of("url", url, "user", user));
            MimeMessage message = mailSender.createMimeMessage();
            message.setFrom(fromEmail);
            message.setRecipients(TO, user.getEmail());
            message.setSubject("STAs - Verify your account");
            message.setContent(msg, "text/html");
            mailSender.send(message);
        } catch (IOException | MessagingException | TemplateException e) {
            log.fine("Error while sending verification email: " + e.getMessage());
        }
    }

    public String getMessageFromTemplate(String templateName, Map<String, Object> params) throws IOException, TemplateException {
        StringWriter stringWriter = new StringWriter();
        Template template = configuration.getTemplate(templateName);
        template.process(params, stringWriter);
        return stringWriter.toString();
    }

}
