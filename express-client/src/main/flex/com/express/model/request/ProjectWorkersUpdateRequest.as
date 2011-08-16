package com.express.model.request
{
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.express.service.dto.ProjectWorkersUpdateRequest")]
public class ProjectWorkersUpdateRequest {

   public function ProjectWorkersUpdateRequest() {
   }

   public var projectId : Number;

   public var workers : ArrayCollection;

}
}