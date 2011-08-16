package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.Theme;
import com.express.service.dto.ProjectDto;
import com.express.service.dto.ThemeDto;
import org.junit.Before;
import org.junit.Test;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/ThemeMappingTest.xml"})
public class DomainFactoryImplCreateThemeTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private DomainFactoryImpl domainFactory;
   
   private static final Long EXISTING_THEME_ID = 33l;
   private static final Long NON_EXISTING_THEME_ID = 22l;
   private static final Long VERSION = 11l;
   private static final String TITLE = "test title";
   private static final String DESCRIPTION = "description";

   private ThemeDto dto;

   @Before
   public void setUp() {
      dto = new ThemeDto();
      dto.setVersion(VERSION);
      dto.setTitle(TITLE);
      dto.setDescription(DESCRIPTION);
   }

   @Test
   public void shouldCreateNewThemeIfDtoHasNoId() throws Exception {
      Theme theme = domainFactory.createTheme(dto);
      assertThat(theme.getId(), is(nullValue()));
   }

   @Test
   public void shouldLoadThemeFromDBIfDtoHasId() throws Exception {
      dto.setId(EXISTING_THEME_ID);
      Theme theme = domainFactory.createTheme(dto);
      assertThat(theme, not(nullValue()));
   }

   @Test(expected = ObjectRetrievalFailureException.class)
   public void shouldFailIfDtoHasIdThatIsNotInDB() throws Exception {
      dto.setId(NON_EXISTING_THEME_ID);
      Theme theme = domainFactory.createTheme(dto);
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(domainFactory.createTheme(dto).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapDescriptionField() {
      assertThat(domainFactory.createTheme(dto).getDescription(), is(equalTo(DESCRIPTION)));
   }

   @Test
   public void shouldNotMapProjectFields() {
      dto.setProject(new ProjectDto());
      assertThat(domainFactory.createTheme(dto).getProject(), is(nullValue()));
   }
}
