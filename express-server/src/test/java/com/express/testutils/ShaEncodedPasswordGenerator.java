package com.express.testutils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.providers.dao.SaltSource;
import org.springframework.security.providers.dao.salt.ReflectionSaltSource;
import org.springframework.security.providers.encoding.PasswordEncoder;
import org.springframework.security.providers.encoding.ShaPasswordEncoder;
import org.springframework.security.userdetails.User;

/**
 *
 */
public class ShaEncodedPasswordGenerator {
   private static final Log LOG = LogFactory.getLog(ShaEncodedPasswordGenerator.class);

   private final SaltSource saltSource;

   private PasswordEncoder passwordEncoder;

   public static void main(String[] args) {
      ShaEncodedPasswordGenerator generator = new ShaEncodedPasswordGenerator();
      if (LOG.isWarnEnabled()) {
         LOG.warn("Password:" + generator.generatePassword("nstrybosch@aconex.com", "password"));
      }
   }

   public ShaEncodedPasswordGenerator() {
      this.saltSource = new ReflectionSaltSource();
      ((ReflectionSaltSource) this.saltSource).setUserPropertyToUse("getUsername");
      this.passwordEncoder = new ShaPasswordEncoder();
   }

   @SuppressWarnings("deprecation")
   public String generatePassword(String username, String password) {
      Object saltObject = this.saltSource.getSalt(new User(username, password, true, true, true, true,
            new GrantedAuthority[0]));
      String encodedPassword = passwordEncoder.encodePassword(password, saltObject);
      return encodedPassword;
   }
}
