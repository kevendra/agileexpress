package com.express.service.mapping.converters;

import com.express.dao.ThemeDao;
import com.express.domain.Theme;
import com.express.service.dto.ThemeDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ThemeDtoToThemeConverter extends AbstractObjectConverter<ThemeDto, Theme> {

   private final ThemeDao themeDao;

   @Autowired
   public ThemeDtoToThemeConverter(ThemeDao themeDao) {
      this.themeDao = themeDao;
   }

   @Override
   public Theme createDestinationObject(ThemeDto dto) {
      return dto.getId() == 0 ? new Theme() : themeDao.findById(dto.getId());
   }

   @Override
   public void convert(ThemeDto themeDto, Theme theme) {
      super.convert(themeDto, theme);
      if(theme.getId() == 0) {
         theme.setId(null);
         theme.setVersion(null);
      }
   }
}
