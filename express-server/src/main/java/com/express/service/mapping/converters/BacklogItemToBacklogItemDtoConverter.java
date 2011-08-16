package com.express.service.mapping.converters;

import com.express.domain.BacklogItem;
import com.express.service.dto.BacklogItemDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.stereotype.Component;

import java.util.Collections;

@Component
public class BacklogItemToBacklogItemDtoConverter extends AbstractObjectConverter<BacklogItem, BacklogItemDto> {
   @Override
   public void convert(BacklogItem backlogItem, BacklogItemDto backlogItemDto) {
      super.convert(backlogItem, backlogItemDto);
      Collections.sort(backlogItemDto.getThemes());
   }
}
