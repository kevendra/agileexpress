package com.express.model.request
{
import com.express.model.domain.Issue;

[RemoteClass(alias="com.express.service.dto.AddImpedimentRequest")]
public class AddImpedimentRequest
{
   public function AddImpedimentRequest() {
   }
   public var backlogItemId : Number;

   public var iterationId : Number;

   public var impediment : Issue;

}
}