package com.express.service.mapping.converters;

import com.express.domain.Methodology;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.stereotype.Component;

@Component
public class MethodologyToStringConverter extends AbstractObjectConverter<Methodology, String> {
   @Override
   public String createDestinationObject(Methodology methodology) {
      return methodology.getTitle();
   }
}
