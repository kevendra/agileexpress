package com.express.skin
{
import flash.display.DisplayObject;
import flash.display.Shape;

import mx.core.EdgeMetrics;
import mx.core.IChildList;
import mx.core.IContainer;
import mx.core.IRawChildrenContainer;
import mx.skins.halo.HaloBorder;

public class HaloBorderWithImagePositioning extends HaloBorder {
   override public function layoutBackgroundImage():void {
      super.layoutBackgroundImage();
      if (!hasBackgroundImage) {
         return;
      }

      var style:Object = getStyle("backgroundPosition");
      // the default alignment is center center
      if (!(style is Array) || (style[0] == 'center' && style[1] == 'center')) {
         return;
      }
      var posHorizontal:String = style[0];
      var posVertical:String = style[1];

      var p:DisplayObject = parent;
      var bm:EdgeMetrics;
      if (p is IContainer) {
         bm = IContainer(p).viewMetrics;
      }
      else {
         bm = borderMetrics;
      }
      var childrenList:IChildList = parent is IRawChildrenContainer ?
                                    IRawChildrenContainer(parent).rawChildren : IChildList(parent);

      var backgroundImage:DisplayObject = childrenList.getChildAt(1);

      // default position is center center, or middle,middle
      var bgX:int = backgroundImage.x;
      var bgY:int = backgroundImage.y;

      if (posHorizontal == 'left') {
         bgX = bm.left;
      }
      if (posHorizontal == 'right') {
         bgX = p.width - bm.right - backgroundImage.width;
      }

      if (posVertical == 'top') bgY = bm.top;
      if (posVertical == 'bottom') bgY = p.height - bm.bottom - backgroundImage.height;

      backgroundImage.x = bgX;
      backgroundImage.y = bgY;

      const backgroundMask:Shape = Shape(backgroundImage.mask);
      backgroundMask.x = bgX;
      backgroundMask.y = bgY;
   }

}
}
