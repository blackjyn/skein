/**
 * Created by Max Rozdobudko on 10/20/15.
 */
package skein.rest.logger.impl
{
import skein.rest.logger.LogEvent;
import skein.rest.logger.Logger;
import skein.rest.logger.LoggerAppender;

public class DefaultLogger implements Logger
{
    public function DefaultLogger()
    {
        super();
    }

    private var _appenders:Vector.<LoggerAppender>;

    public function get appenders():Vector.<LoggerAppender>
    {
        return _appenders;
    }

    public function set appenders(value:Vector.<LoggerAppender>):void
    {
        _appenders = value;
    }

    public function log(event:LogEvent):void
    {
        if (_appenders != null && _appenders.length > 0)
        {
            for (var i:int = 0, n:int = _appenders.length; i < n; i++)
            {
                _appenders[i].append(event);
            }
        }
    }
}
}
