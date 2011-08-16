package com.express.model.request
{
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.express.service.dto.ThemesUpdateRequest")]
public class ThemesUpdateRequest {

   public function ThemesUpdateRequest() {
   }

   public var projectId : Number;

   public var themes : ArrayCollection;

}
}