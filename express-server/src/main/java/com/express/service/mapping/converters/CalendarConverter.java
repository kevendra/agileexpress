package com.express.service.mapping.converters;

import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.stereotype.Component;

import java.util.Calendar;

@Component
public class CalendarConverter extends AbstractObjectConverter<Calendar, Calendar> {

   @Override
   public Calendar createDestinationObject(Calendar calendar) {
      return Calendar.getInstance();
   }

   @Override
   public void convert(Calendar source, Calendar destination) {
      destination.setTimeInMillis(source.getTimeInMillis());
   }

   @Override
   protected boolean disableAutoMapping() {
      return true;
   }
}
