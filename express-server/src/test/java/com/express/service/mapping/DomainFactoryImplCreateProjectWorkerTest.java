package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.ProjectWorker;
import com.express.service.dto.PermissionsDto;
import com.express.service.dto.ProjectWorkerDto;
import com.express.service.dto.UserDto;
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

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/ProjectWorkerMappingTest.xml"})
public class DomainFactoryImplCreateProjectWorkerTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private DomainFactoryImpl domainFactory;
   
   private static final Long EXISTING_THEME_ID = 11l;
   private static final Long NON_EXISTING_THEME_ID = 22l;
   private static final Long VERSION = 11l;
   private static final PermissionsDto PERMISSIONS_DTO = new PermissionsDto();
   private ProjectWorkerDto dto;

   @Before
   public void setUp() {
      dto = new ProjectWorkerDto();
      dto.setVersion(VERSION);
      PERMISSIONS_DTO.setIterationAdmin(true);
      PERMISSIONS_DTO.setProjectAdmin(true);
      dto.setPermissions(PERMISSIONS_DTO);
   }

   @Test
   public void shouldCreateNewProjectWorkerIfDtoHasNoId() throws Exception {
      ProjectWorker theme = domainFactory.createProjectWorker(dto);
      assertThat(theme.getId(), is(nullValue()));
   }

   @Test
   public void shouldLoadProjectWorkerFromDBIfDtoHasId() throws Exception {
      dto.setId(EXISTING_THEME_ID);
      ProjectWorker theme = domainFactory.createProjectWorker(dto);
      assertThat(theme, not(nullValue()));
   }

   @Test(expected = ObjectRetrievalFailureException.class)
   public void shouldFailIfDtoHasIdThatIsNotInDB() throws Exception {
      dto.setId(NON_EXISTING_THEME_ID);
      ProjectWorker theme = domainFactory.createProjectWorker(dto);
   }

   @Test
   public void shouldMapProjectAdminPermissionField() {
      assertThat(domainFactory.createProjectWorker(dto).getPermissions().getProjectAdmin(), is(equalTo(true)));
   }

   @Test
   public void shouldMapIterationAdminPermissionField() {
      assertThat(domainFactory.createProjectWorker(dto).getPermissions().getIterationAdmin(), is(equalTo(true)));
   }

   @Test
   public void shouldMapWorkerFieldShallowly() {
      UserDto userDto = new UserDto();
      userDto.setId(102l);
      userDto.setEmail("something bogus");
      dto.setWorker(userDto);
      assertThat(domainFactory.createProjectWorker(dto).getWorker().getEmail(), is(equalTo("testuser1@test.com")));
   }
}
