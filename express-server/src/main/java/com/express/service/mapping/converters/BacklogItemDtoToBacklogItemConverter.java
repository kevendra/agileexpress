package com.express.service.mapping.converters;

import com.express.dao.BacklogItemDao;
import com.express.domain.BacklogItem;
import com.express.service.dto.BacklogItemDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BacklogItemDtoToBacklogItemConverter extends AbstractObjectConverter<BacklogItemDto, BacklogItem> {

   private final BacklogItemDao backlogItemDao;

   @Autowired
   public BacklogItemDtoToBacklogItemConverter(BacklogItemDao backlogItemDao) {
      this.backlogItemDao = backlogItemDao;
   }

   @Override
   public BacklogItem createDestinationObject(BacklogItemDto dto) {
      return dto.getId() == 0 ? new BacklogItem() : backlogItemDao.findById(dto.getId());
   }

   @Override
   public void convert(BacklogItemDto backlogItemDto, BacklogItem backlogItem) {
      super.convert(backlogItemDto, backlogItem);
      if(backlogItem.getId() == 0) {
         backlogItem.setId(null);
         backlogItem.setVersion(null);
      }
   }
}
