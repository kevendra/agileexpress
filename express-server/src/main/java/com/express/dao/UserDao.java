package com.express.dao;

import com.express.domain.User;

public interface UserDao extends GenericDao<User>{
   User findByUsername(String username);

}
