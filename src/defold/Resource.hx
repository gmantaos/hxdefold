package defold;

import defold.types.Hash;
import defold.types.Buffer;
import defold.types.HashOrString;
import defold.types.ResourceReference;

/**
    Functions and constants to access resources.
**/
@:native("_G.resource")
extern class Resource {
    /**
        Constructor-like function with two purposes:

        - Load the specified resource as part of loading the script
        - Return a hash to the run-time version of the resource

        **Note:** This function can only be called within `@property()`.
    **/
    static function atlas(path:String):ResourceReference;

    /**
        Constructor-like function with two purposes:

        - Load the specified resource as part of loading the script
        - Return a hash to the run-time version of the resource

        **Note:** This function can only be called within `@property()`.
    **/
    static function font(path:String):ResourceReference;

    /**
        Return a reference to the Manifest that is currently loaded.

        @return reference to the Manifest that is currently loaded
    **/
    static function get_current_manifest():ResourceManifestReference;

    /**
        Loads the resource data for a specific resource.

        @param path The path to the resource
        @return the buffer stored on disc
    **/
    static function load(path:String):Buffer;

    /**
        Constructor-like function with two purposes:

        - Load the specified resource as part of loading the script
        - Return a hash to the run-time version of the resource

        **Note:** This function can only be called within `@property()`.
    **/
    static function material():ResourceReference;

    /**
        Sets the resource data for a specific resource

        @param path The path to the resource
        @param The buffer of precreated data, suitable for the intended resource type
    **/
    static function set(path:HashOrString, buffer:Buffer):Void;

    /**
        Sets the pixel data for a specific texture.

        @param path The path to the resource
        @param table A table containing info about the texture
        @param buffer The buffer of precreated pixel data

        *NOTE* Currently, only 1 mipmap is generated.
    **/
    static function set_texture(path:HashOrString, table:ResourceTextureInfo, buffer:Buffer):Void;

    /**
        Create, verify, and store a manifest to device.

        Create a new manifest from a buffer. The created manifest is verified
        by ensuring that the manifest was signed using the bundled public/private
        key-pair during the bundle process and that the manifest supports the current
        running engine version. Once the manifest is verified it is stored on device.
        The next time the engine starts (or is rebooted) it will look for the stored
        manifest before loading resources. Storing a new manifest allows the
        developer to update the game, modify existing resources, or add new
        resources to the game through LiveUpdate.

        @param manifest_buffer the binary data that represents the manifest
        @param callback the callback function executed once the engine has attempted to store the manifest.
    **/
    static function store_manifest<T>(manifest_buffer:String, callback:#if haxe4 (self:T, status:ResourceLiveUpdateStatus)->Void #else T->ResourceLiveUpdateStatus->Void #end):Void;

    /**
        Add a resource to the data archive and runtime index.

        The resource will be verified internally before being added to the data archive.

        @param manifest_reference The manifest to check against.
        @param data The resource data that should be stored.
        @param hexdigest The expected hash for the resource, retrieved through collectionproxy.missing_resources.
        @param callback  The callback function that is executed once the engine has been attempted to store
        the resource. Arguments:
         * `self` The current object.
         * `hexdigest` The hexdigest of the resource.
         * `status` Whether or not the resource was successfully stored.
    **/
    static function store_resource<T>(manifest_reference:ResourceManifestReference, data:String, hexdigest:String, callback:T->String->Bool->Void):Void;

    /**
        Constructor-like function with two purposes:

        - Load the specified resource as part of loading the script
        - Return a hash to the run-time version of the resource

        **Note:** This function can only be called within `@property()`.
    **/
    static function texture(path:String):ResourceReference;

    /**
        Constructor-like function with two purposes:

        - Load the specified resource as part of loading the script
        - Return a hash to the run-time version of the resource

        **Note:** This function can only be called within `@property()`.
    **/
    static function tile_source(path:String):ResourceReference;
}

/**
    Resource manifest reference used by the `Resource` module.
**/
typedef ResourceManifestReference = Int;

/**
    Texture info used by the `Resource.set_texture` method.
**/
typedef ResourceTextureInfo = {
    /**
        The texture type
    **/
    var type:ResourceTextureType;

    /**
        The width of the texture (in pixels)
    **/
    var width:Int;

    /**
        The height of the texture (in pixels)
    **/
    var height:Int;

    /**
        The texture format
    **/
    var format:ResourceTextureFormat;
}

/**
    Resource type used in `ResourceTextureInfo.type` field.
**/
@:native("_G.resource")
@:enum extern abstract ResourceTextureType(Int) {
    /**
        2D texture type.
    **/
    var TEXTURE_TYPE_2D;
}

/**
    Resource format used in `ResourceTextureInfo.format` field.
**/
@:native("_G.resource")
@:enum extern abstract ResourceTextureFormat(Int) {
    /**
        Luminance type texture format.
    **/
    var TEXTURE_FORMAT_LUMINANCE;

    /**
        RGB type texture format.
    **/
    var TEXTURE_FORMAT_RGB;

    /**
        RGBA type texture format.
    **/
    var TEXTURE_FORMAT_RGBA;
}

@:native("_G.resource")
@:enum extern abstract ResourceLiveUpdateStatus({}) {
    /**
        Mismatch between between expected bundled resources and actual bundled resources.
        The manifest expects a resource to be in the bundle, but it was not found in the bundle.
        This is typically the case when a non-excluded resource was modified between publishing the bundle and publishing the manifest.
    **/
    var LIVEUPDATE_BUNDLED_RESOURCE_MISMATCH;

    /**
        Mismatch between running engine version and engine versions supported by manifest.
    **/
    var LIVEUPDATE_ENGINE_VERSION_MISMATCH;

    /**
        Failed to parse manifest data buffer. The manifest was probably produced by a different engine version.
    **/
    var LIVEUPDATE_FORMAT_ERROR;

    /**
        The handled resource is invalid.
    **/
    var LIVEUPDATE_INVALID_RESOURCE;

    var LIVEUPDATE_OK;

    /**
        Mismatch between scheme used to load resources.
        Resources are loaded with a different scheme than from manifest, for example over HTTP or directly from file.
        This is typically the case when running the game directly from the editor instead of from a bundle.
    **/
    var LIVEUPDATE_SCHEME_MISMATCH;

    /**
        Mismatch between manifest expected signature and actual signature.
    **/
    var LIVEUPDATE_SIGNATURE_MISMATCH;

    /**
        Mismatch between manifest expected version and actual version.
    **/
    var LIVEUPDATE_VERSION_MISMATCH;
}
