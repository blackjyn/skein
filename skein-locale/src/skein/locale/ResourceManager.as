/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 7/5/13
 * Time: 12:01 PM
 * To change this template use File | Settings | File Templates.
 */
package skein.locale
{
import flash.events.EventDispatcher;

import skein.core.skein_internal;

import skein.locale.core.*;

import flash.events.Event;

import skein.locale.core.Bundle;
import skein.locale.core.bundle.MapBasedBundleContent;
import skein.locale.core.bundle.SimpleBundleContent;

import skein.utils.StringUtil;

use namespace skein_internal;

[Event(name="change", type="flash.events.Event")]

public class ResourceManager extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Singleton
    //
    //--------------------------------------------------------------------------

    private static var _instance:ResourceManager;

    public static function get instance():ResourceManager
    {
        if (_instance == null)
            _instance = new ResourceManager();

        return _instance;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ResourceManager() {
        super();
    }

    private var bundleMap:Object = {};

    private var availableLocales:Array = [];

    [Bindable(event="change")]
    public function getString(bundle: String, key: String, params: Array = null): String {
        var b: Bundle = findBundle(bundle, key);

        if (b == null) {
            return key;
        }

        var string: String = params && params.length > 0
            ? StringUtil.substitute(b.content.getResource(key), params)
            : b.content.getResource(key);

        return string || key;
    }

    //--------------------------------------------------------------------------
    //
    //  Config
    //
    //--------------------------------------------------------------------------

    public var shouldPreferMapBasedBundleContent: Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var parsers:ParserChain = new ParserChain();

    private var locales:Array;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _defaultLocale:String;

    public function get defaultLocale():String
    {
        return _defaultLocale;
    }

    public function set defaultLocale(value:String):void
    {
        if (value == _defaultLocale) return;

        _defaultLocale = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function getLocale():String
    {
        return locales && locales.length > 0 ? locales[0] : null;
    }

    public function setLocale(locale:String):void
    {
        if (locale == null)
            locale = _defaultLocale;

        if (locale == getLocale()) return;

        setLocales([locale]);
    }

    [Bindable(event="change")]
    public function getLocales():Array
    {
        return locales;
    }

    public function setLocales(chain:Array):void
    {
        locales = chain;

        dispatchEvent(new Event(Event.CHANGE));
    }

    [Bindable(event="change")]
    public function getAvailableLocales():Array
    {
        return availableLocales;
    }

    public function addSource(source:Source):void
    {
        if (source.isLoaded())
        {
            parseSource(source);
        }
        else
        {
            source.addEventListener(Event.COMPLETE, source_completeHandler);

            source.load();
        }
    }

    private function parseSource(source:Source):void {
        var BundleContentType: Class = shouldPreferMapBasedBundleContent ? MapBasedBundleContent : SimpleBundleContent;

        var bundles:Vector.<Bundle> = parsers.parse(source.getData(), BundleContentType);

        addBundles(bundles);
    }

    internal function addBundles(bundles: Vector.<Bundle>): void {
        if (bundles == null || bundles.length == 0) {
            return;
        }

        for (var i: int = 0, n: int = bundles.length; i < n; i++) {
            var b: Bundle = bundles[i];

            if (!bundleMap.hasOwnProperty(b.locale)) {
                bundleMap[b.locale] = {};
                availableLocales.push(b.locale);
            }

            if (bundleMap[b.locale].hasOwnProperty(b.name)) {
                Bundle(bundleMap[b.locale][b.name]).merge(b, BundleMergeStrategy.keepExistingOne);
            } else {
                bundleMap[b.locale][b.name] = b;
            }
        }
    }

    private function findBundle(name:String, resource:String):Bundle
    {
        var locales:Array = this.locales || [];

        if (locales.indexOf(_defaultLocale) == -1) {
            locales.push(_defaultLocale);
        }

        for (var i:uint = 0, n:uint = locales ? locales.length : 0; i < n; i++)
        {
            var locale:String = locales[i];

            var bundles:Object = bundleMap[locale];

            if (bundles == null)
                continue;

            var bundle:Bundle = bundles[name];

            if (bundle == null)
                continue;

            if (bundle.content && bundle.content.hasResource(resource))
                return bundle;
        }

        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function source_completeHandler(event:Event):void
    {
        var source:Source = event.target as Source;

        source.removeEventListener(Event.COMPLETE, source_completeHandler);

        parseSource(source);
    }
}
}
