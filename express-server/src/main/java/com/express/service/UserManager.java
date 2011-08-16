package com.express.service;

import com.express.service.dto.ChangePasswordRequest;
import com.express.service.dto.LoginRequest;
import com.express.service.dto.UserDto;
import org.springframework.security.userdetails.UserDetailsService;

public interface UserManager {
   
   /**
    * @param request containing all login details
    * @return valid User with the username and password in the credentials. If this is a password
    * reminder request it will return null.
    * @throws org.springframework.remoting.RemoteAccessException containing details of login failure
    * if it occurs.
    */
   UserDto login(LoginRequest request);
   
   /**
    * Creates a new user based on the fields in the UserDto provided.
    * @param dto containing fields to be used to create the new User
    * @return Long which is the id of the new User created.
    */
   Long register(UserDto dto);
   
   /**
    * Causes the user account identified by the userId provided to be set to active.
    * @param userId of the User who's registration is to be confirmed
    */
   void confirmRegistration(Long userId);
   
   
   /**
    * @param dto containing all fields for the user to be updated (must also contain the id and
    * version no)
    * @return a dto representing the User after the update
    */
   UserDto updateUserDetails(UserDto dto);
   
   
   /**
    * @param request details of the user who's password is to be changed
    * @return a dto of the User who's password was changed
    */
   UserDto changePassword(ChangePasswordRequest request);

   /**
    * Resets the User identified by the password provied
    * @param userId
    * @return
    */
   UserDto resetPassword(Long userId);

}
