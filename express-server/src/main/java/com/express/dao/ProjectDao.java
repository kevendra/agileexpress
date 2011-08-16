package com.express.dao;

import java.util.List;

import com.express.domain.Project;
import com.express.domain.User;

public interface ProjectDao extends GenericDao<Project> {
   
   List<Project> findAll(User user);

   List<Project> findAll();

   List<Project> findAvailable(User user);

}
