package com.express.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.remoting.RemoteAccessException;
import org.springframework.ui.Model;
import com.express.service.UserManager;
import com.express.service.dto.UserDto;

import java.util.Map;
import java.util.HashMap;

@Controller
public class RegisterController {
   private final UserManager userManager;

   @Autowired
   public RegisterController(UserManager userManager) {
      this.userManager = userManager;
   }

   @ModelAttribute("user")
   public  UserDto getUser() {
      return new UserDto();
   }

   @RequestMapping(value = "/register", method = RequestMethod.GET)
   public String setUp(@RequestParam(value = "msg",required = false)String message, Model model) {
      if(message != null) {
         model.addAttribute("msg", message);
      }
      return "/register";
   }

   @RequestMapping(value = "/register", method = RequestMethod.POST)
   public String register(@ModelAttribute("user")UserDto userDto, Model model) {
      try {
         userManager.register(userDto);
         model.addAttribute("msg","You have successfully registered. An email has been sent to " +
               "the address provided. Please use the link to confirm your registration.");
      }
      catch(RemoteAccessException re) {
         model.addAttribute("msg", re.getMessage());
      }
      return "redirect:register.html";
   }
}
