package com.express.service.mapping.converters;

import com.express.dao.UserDao;
import com.express.domain.User;
import com.express.service.dto.UserDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UserDtoToUserConverter extends AbstractObjectConverter<UserDto, User> {

   private final UserDao userDao;

   @Autowired
   public UserDtoToUserConverter(UserDao userDao) {
      this.userDao = userDao;
   }

   @Override
   public User createDestinationObject(UserDto dto) {
      return dto.getId() == 0 ? new User() : userDao.findById(dto.getId());
   }

   @Override
   public void convert(UserDto userDto, User user) {
      super.convert(userDto, user);
      if(user.getId() == 0) {
         user.setId(null);
         user.setVersion(null);
      }
   }
}
