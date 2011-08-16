package com.express.service.mapping.converters;

import com.express.domain.Status;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.stereotype.Component;

@Component
public class StatusToStringConverter extends AbstractObjectConverter<Status, String> {

   @Override
   public String createDestinationObject(Status source) {
      return source.getTitle();
   }

   @Override
   protected boolean disableAutoMapping() {
      return true;
   }
}
