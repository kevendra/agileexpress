package com.express.model.request
{
import com.express.model.domain.Project;

[RemoteClass(alias="com.express.service.dto.ProjectAccessRequest")]
public class ProjectAccessRequest {

   public function ProjectAccessRequest() {
   }

   public var newProject : Project;

   public var existingProjects : Array;

}
}