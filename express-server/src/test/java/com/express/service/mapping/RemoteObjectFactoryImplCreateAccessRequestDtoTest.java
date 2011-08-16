package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.AccessRequest;
import org.junit.Before;
import org.junit.Test;
import org.unitils.spring.annotation.SpringBeanByName;

import java.util.Calendar;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class RemoteObjectFactoryImplCreateAccessRequestDtoTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private RemoteObjectFactoryImpl remoteObjectFactory;
   
   private static final Long THEME_ID = 33l;
   private static final String REASON = "reason";
   private static final Calendar REQUESTED = Calendar.getInstance();
   private static final Calendar RESOLVED = Calendar.getInstance();

   private AccessRequest request;

   @Before
   public void setUp() {
      request = new AccessRequest();
      request.setId(THEME_ID);
      request.setReason(REASON);
      request.setRequestDate(REQUESTED);
      request.setResolvedDate(RESOLVED);
   }

   @Test
   public void shouldMapIdField() throws Exception {
      assertThat(remoteObjectFactory.createAccessRequestDto(this.request).getId(), is(THEME_ID));
   }

   @Test
   public void shouldMapReasonField() throws Exception {
      assertThat(remoteObjectFactory.createAccessRequestDto(this.request).getReason(), is(REASON));
   }
   
   @Test
   public void shouldMapRequestDateField() throws Exception {
      assertThat(remoteObjectFactory.createAccessRequestDto(this.request).getRequestDate(), is(REQUESTED));
   }
   
   @Test
   public void shouldMapResolvedDateField() throws Exception {
      assertThat(remoteObjectFactory.createAccessRequestDto(this.request).getResolvedDate(), is(RESOLVED));
   }

}
