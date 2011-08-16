package com.express.scenarios;

import com.express.steps.CreateProductBacklogStorySteps;
import org.jbehave.scenario.Scenario;

/**
 *
 */
public class CreateProductBacklogStory extends Scenario {

   public CreateProductBacklogStory() {
      super(new CreateProductBacklogStorySteps());
   }
}
