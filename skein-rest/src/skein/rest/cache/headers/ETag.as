/**
 * Created by Max Rozdobudko on 10/5/15.
 */
package skein.rest.cache.headers
{
public class ETag
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    public static const NAME:String = "ETag";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    public static function valueOf(string:String):ETag
    {
        var etag:ETag = new ETag();

        etag.value = string;

        return etag;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ETag()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public var value:String;
}
}
