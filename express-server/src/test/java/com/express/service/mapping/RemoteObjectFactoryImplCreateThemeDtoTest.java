package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.Theme;
import org.junit.Before;
import org.junit.Test;
import org.unitils.spring.annotation.SpringBeanByName;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class RemoteObjectFactoryImplCreateThemeDtoTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private RemoteObjectFactoryImpl remoteObjectFactory;
   
   private static final Long THEME_ID = 33l;
   private static final Long VERSION = 11l;
   private static final String TITLE = "test title";
   private static final String DESCRIPTION = "description";

   private Theme theme;

   @Before
   public void setUp() {
      theme = new Theme();
      theme.setId(THEME_ID);
      theme.setVersion(VERSION);
      theme.setTitle(TITLE);
      theme.setDescription(DESCRIPTION);
   }

   @Test
   public void shouldMapIdField() throws Exception {
      assertThat(remoteObjectFactory.createThemeDto(this.theme).getId(), is(THEME_ID));
   }

   @Test
   public void shouldMapVersionField() throws Exception {
      assertThat(remoteObjectFactory.createThemeDto(this.theme).getVersion(), is(VERSION));
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(remoteObjectFactory.createThemeDto(theme).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapDescriptionField() {
      assertThat(remoteObjectFactory.createThemeDto(theme).getDescription(), is(equalTo(DESCRIPTION)));
   }
}
