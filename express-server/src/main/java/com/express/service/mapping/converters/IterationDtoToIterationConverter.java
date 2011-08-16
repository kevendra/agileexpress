package com.express.service.mapping.converters;

import com.express.dao.IterationDao;
import com.express.domain.Iteration;
import com.express.service.dto.IterationDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class IterationDtoToIterationConverter extends AbstractObjectConverter<IterationDto, Iteration> {

   private final IterationDao iterationDao;

   @Autowired
   public IterationDtoToIterationConverter(IterationDao iterationDao) {
      this.iterationDao = iterationDao;
   }

   @Override
   public Iteration createDestinationObject(IterationDto dto) {
      return dto.getId() == 0 ? new Iteration() : iterationDao.findById(dto.getId());
   }

   @Override
   public void convert(IterationDto iterationDto, Iteration iteration) {
      super.convert(iterationDto, iteration);
      if(iteration.getId() == 0) {
         iteration.setId(null);
         iteration.setVersion(null);
      }
   }
}
