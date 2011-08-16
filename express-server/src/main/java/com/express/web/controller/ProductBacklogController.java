package com.express.web.controller;

import com.express.service.ProjectManager;
import com.express.service.dto.ProjectDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 
 */
@Controller
public class ProductBacklogController {
   private final ProjectManager projectManager;

   @Autowired
   public ProductBacklogController(ProjectManager projectManager) {
      this.projectManager = projectManager;
   }

   @RequestMapping(value = "/productbacklog/{projectId}", method = RequestMethod.GET)
   public String findSale(@PathVariable("projectId") Long projectId, Model model) {

      ProjectDto project = projectManager.findProject(projectId);
      model.addAttribute("productBacklog", project.getProductBacklog());
      return "/productBacklog/show";
   }
}
