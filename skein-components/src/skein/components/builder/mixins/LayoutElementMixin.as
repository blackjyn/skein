/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 4/20/13
 * Time: 10:18 PM
 * To change this template use File | Settings | File Templates.
 */
package skein.components.builder.mixins
{
public interface LayoutElementMixin
{
    function left(value:Object):void;
    function leftAnchor(value:Object):void;

    function top(value:Object):void;
    function topAnchor(value:Object):void;

    function right(value:Object):void;
    function rightAnchor(value:Object):void;

    function bottom(value:Object):void;
    function bottomAnchor(value:Object):void;

    function horizontalCenter(value:Object):void;
    function horizontalCenterAnchor(value:Object):void;

    function verticalCenter(value:Object):void;
    function verticalCenterAnchor(value:Object):void;

    function includeInLayout(value:Object):void;
}
}
