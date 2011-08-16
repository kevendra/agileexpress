package com.express.domain;

import org.junit.Test;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class StatusTest {

   @Test
   public void shouldGetStatusForOpenTitle() {
      assertThat(Status.getStatus("OPEN"), is(Status.OPEN));
   }

   @Test
   public void shouldGetStatusForInProgressTitle() {
      assertThat(Status.getStatus("IN PROGRESS"), is(Status.IN_PROGRESS));
   }

   @Test
   public void shouldGetStatusForTestTitle() {
      assertThat(Status.getStatus("TEST"), is(Status.TEST));
   }

   @Test
   public void shouldGetStatusForDoneTitle() {
      assertThat(Status.getStatus("DONE"), is(Status.DONE));
   }
}
