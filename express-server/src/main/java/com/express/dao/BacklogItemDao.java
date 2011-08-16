package com.express.dao;

import com.express.domain.BacklogItem;


public interface BacklogItemDao {
   
   BacklogItem findById(Long id);

   void save(BacklogItem item);

}
