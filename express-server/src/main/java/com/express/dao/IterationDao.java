package com.express.dao;

import com.express.domain.Iteration;

import java.util.List;

public interface IterationDao {
   
   Iteration findById(Long iterationId);

   List<Iteration> findOpenIterations();

}
