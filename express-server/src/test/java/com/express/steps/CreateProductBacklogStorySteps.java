package com.express.steps;

import com.express.service.dto.BacklogItemDto;
import com.express.service.dto.CreateBacklogItemRequest;
import org.jbehave.scenario.annotations.Given;
import org.jbehave.scenario.annotations.When;
import org.jbehave.scenario.steps.Steps;

/**
 *
 */
public class CreateProductBacklogStorySteps extends Steps {

   private CreateBacklogItemRequest request;

   @Given("a new story request")
   public void createNewStoryRequest() {
      BacklogItemDto story = new BacklogItemDto();
      story.setTitle("test one");
      story.setAsA("As a User");
      story.setWant("I want to test");
      story.setSoThat("so that I can be happy");
      story.setEffort(2);
      story.setBusinessValue(3);
      request = new CreateBacklogItemRequest();
      request.setType(CreateBacklogItemRequest.PRODUCT_BACKLOG_STORY);
      request.setParentId(1l);
   }

   @When("the save request is complete")
   public void saveCreateStoryRequest() {

   }
}
