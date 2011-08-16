package com.express.service;

import com.express.service.dto.IterationDto;

/**
 *
 */
public interface IterationManager {

   /**
    * @param id of the Iteration to be found
    * @return Fully loaded IterationDto using a deep loading policy
    */
   IterationDto findIteration(Long id);

   /**
    * Creates a new Iteration based on the fields in the IterationDto provided.
    * @param iterationDto with the parameters which should be used for the creation of the new Iteration.
    * @return iterationDto which results from the completion of this create
    */
   IterationDto createIteration(IterationDto iterationDto);

   /**
    *
    * @param iterationDto representing the Iteration and containing the information to be updated
    * @return iteratioinDto base on the results of this update
    */
   IterationDto updateIteration(IterationDto iterationDto);
}
