package edu.asu.stas.shared;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

@Controller
public class ErrorHandler implements ErrorController {

    @GetMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        if (model.containsAttribute("oauthError")) {
            return "home/error";
        } else if (status != null) {
            int statusCode = Integer.parseInt(status.toString());
            model.addAttribute("errorTitle", "Error " + statusCode);
            model.addAttribute("error", HttpStatus.valueOf(statusCode).getReasonPhrase());
            return "home/error";
        }
        return "redirect:/";
    }
}
