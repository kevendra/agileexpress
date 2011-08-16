package com.express.controller
{
import com.express.model.ProjectProxy;
import com.express.model.domain.Project;

import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ProjectCreateCommand extends SimpleCommand implements IResponder
{
   override public function execute(notification : INotification) : void {
      var project : Project = notification.getBody() as Project;
      //TODO: do remote call for create and take the next line(s) out.
      var proxy : ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      //proxy.extraProjects.addItem(project);
      var data : Object = new Object();
      var newProject : Project = new Project();
      newProject.title = project.title;
      newProject.description = project.description;
      newProject.startDate = project.startDate;
      newProject.reference = project.reference;
      data.result = newProject;
      this.result(data);
   }

   public function result(data : Object) : void {
      var proxy : ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      proxy.selectedProject = data.result as Project;
   }

   public function fault(info : Object) : void {
      var fault : Fault = (info as FaultEvent).fault;
   }
}
}