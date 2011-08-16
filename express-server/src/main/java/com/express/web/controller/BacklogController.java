package com.express.web.controller;

import com.express.service.ProjectManager;
import com.express.service.dto.CSVRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 */
@Controller
public class BacklogController {

   private ProjectManager projectManager;
   private static final Log LOG = LogFactory.getLog(BacklogController.class);

   @Autowired
   public void setProjectManager(ProjectManager projectManager) {
      this.projectManager = projectManager;
   }

   @RequestMapping(value = "/iteration/{id}/backlog", method = RequestMethod.GET)
   public void getCSVForIterationBacklog(@PathVariable("id") Long id, HttpServletResponse response) {
      CSVRequest request = new CSVRequest();
      request.setType(CSVRequest.TYPE_ITERATION_BACKLOG);
      request.setId(id);
      writeStringToResponse(projectManager.getCSV(request), response);
   }

   @RequestMapping(value = "/project/{id}/backlog", method = RequestMethod.GET)
   public void getCSVForProductBacklog(@PathVariable("id") Long id, HttpServletResponse response) {
      CSVRequest request = new CSVRequest();
      request.setType(CSVRequest.TYPE_PRODUCT_BACKLOG);
      request.setId(id);
      writeStringToResponse(projectManager.getCSV(request), response);
   }

   private void writeStringToResponse(String csv, HttpServletResponse response) {
      try {
         response.setContentType("text/x-csv");
         response.setHeader("Content-Disposition", "inline; filename=\"backlog.csv\"");
         response.getOutputStream().write(csv.getBytes());
      }
      catch (IOException e) {
         LOG.error("ERROR", e);
      }
   }
}
