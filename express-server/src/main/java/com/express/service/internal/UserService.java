package com.express.service.internal;

import org.springframework.security.userdetails.UserDetailsService;
import com.express.domain.User;

/**
 * Service for authentication and retrieving the currently logged in user.
 */
public interface UserService  extends UserDetailsService {

   User getAuthenticatedUser();

}
