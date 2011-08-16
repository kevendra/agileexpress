package com.express.service;

import java.util.List;

import com.express.service.dto.*;

public interface ProjectManager {
   
   /**
    * @return List of all ProjectDtos which are available to the currently logged in user. These 
    * Projects will be loaded using a shallow loading policy.
    */
   List<ProjectDto> findAllProjects();
   
   /**
    * @return ProjectAccessData which contains Lists of all ProjectDtos which are available,
    * pending or granted for a user. These projects wil be loaded using a shallow loading policy.
    */
   ProjectAccessData findAccessRequestData();
   
   
   /**
    * @param id of the Project to be found
    * @return Fully loaded ProjectDto using a deep loading policy (Iterations will only be loaded shallowly)
    */
   ProjectDto findProject(Long id);

   /**
    * Generates an access request for the Project(s) provided or generates a create project request
    * for the system administrator if a new project name is provided in the request object.
    * @param request containing project access request details
    */
   void projectAccessRequest(ProjectAccessRequest request);

   /**
    *
    * @param id of the request to respond to
    * @param response indicating whether to accept the request.
    */
   void projectAccessResponse(Long id, Boolean response);

   /**
    *
    * @param projectId the projectId of the project whos access requests are to be returned
    * @return list of AccessRequestDtos for the project identified by the id provided
    */
   List<AccessRequestDto> loadAccessRequests(Long projectId);
   
   /**
    * Updates the project fields based on the fields of the ProjectDto provided.
    * @param projectDto with the parameters which should be used for updating the Project
    * @return projectDto which results from the completion of this update
    */
   ProjectDto updateProject(ProjectDto projectDto);
   
   /**
    * @param request containing all fields required to determine the load loevel
    * @return List of BacklogItems
    */
   List<BacklogItemDto> loadBacklog(LoadBacklogRequest request);

   /**
    * Service to create EffortRecords for all Iterations which are currently active
    */
   void createHistoryRecords();

   /**
    * Update the list of themes for a project
    * @param request containing the projectId of the project and the Themes to update the project
    * with.
    */
   void updateThemes(ThemesUpdateRequest request);

   /**
    *
    * @param projectId id of the project whos themes are to be returned
    * @return list of themeDtos for the project identified by the id provided
    */
   List<ThemeDto> loadThemes(Long projectId);

   /**
    * Updates the project workers in the project identified by the projectId provided
    * @param request containing the id of the project to update and the list of ProjectWorkers.
    */
   void updateProjectWorkers(ProjectWorkersUpdateRequest request);

   /**
    *
    * @param request containing request parameters
    * @return String containing comma separated list
    */
   String getCSV(CSVRequest request);

   /**
    * Update data for the issue provided
    * @param issueDto
    */
   void updateImpediment(IssueDto issueDto);
}
