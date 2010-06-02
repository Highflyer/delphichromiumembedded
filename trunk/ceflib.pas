{$IFDEF FPC}
   {$MODE DELPHI}{$H+}
{$ENDIF}
unit ceflib;
{$ALIGN ON}
{$MINENUMSIZE 4}

interface
uses
  Classes, Windows;

type
{$IFDEF UNICODE}
  ustring = type string;
{$ELSE}
  ustring = type WideString;
{$ENDIF}

  ICefBase = interface
    ['{1F9A7B44-DCDC-4477-9180-3ADD44BDEB7B}']
    function Wrap: Pointer;
  end;

  // CEF strings are NUL-terminated wide character strings prefixed with a size
  // value, similar to the Microsoft BSTR type.  Use the below API functions for
  // allocating, managing and freeing CEF strings.
  PCefString = ^TCefString;
  TCefString = PWideChar;

  // CEF string maps are a set of key/value string pairs.
  TCefStringMap = Pointer;

  // CEF string maps are a set of key/value string pairs.
  TCefStringList = Pointer;

  // Class representing window information.
  PCefWindowInfo = ^TCefWindowInfo;
  TCefWindowInfo = record
    // Standard parameters required by CreateWindowEx()
    ExStyle: DWORD;
    windowName: TCefString;
    Style: DWORD;
    x: Integer;
    y: Integer;
    Width: Integer;
    Height: Integer;
    WndParent: HWND;
    Menu: HMENU;
    // Handle for the new browser window.
    Wnd: HWND ;
  end;

  // Class representing print context information.
  TCefPrintInfo = record
    DC: HDC;
    Rect: TRect;
    Scale: double;
  end;

  // Window handle.
  CefWindowHandle = HWND;

  // Define handler return value types. Returning RV_HANDLED indicates
  // that the implementation completely handled the method and that no further
  // processing is required.  Returning RV_CONTINUE indicates that the
  // implementation did not handle the method and that the default handler
  // should be called.
  PCefRetval = ^TCefRetval;
  TCefRetval = (
    RV_HANDLED   = 0,
    RV_CONTINUE  = 1
  );

  // Various browser navigation types supported by chrome.
  TCefHandlerNavtype = (
    NAVTYPE_LINKCLICKED = 0,
    NAVTYPE_FORMSUBMITTED,
    NAVTYPE_BACKFORWARD,
    NAVTYPE_RELOAD,
    NAVTYPE_FORMRESUBMITTED,
    NAVTYPE_OTHER
  );

  // Supported error code values. See net\base\net_error_list.h for complete
  // descriptions of the error codes.
  TCefHandlerErrorcode = Integer;

const
  ERR_FAILED = -2;
  ERR_ABORTED = -3;
  ERR_INVALID_ARGUMENT = -4;
  ERR_INVALID_HANDLE = -5;
  ERR_FILE_NOT_FOUND = -6;
  ERR_TIMED_OUT = -7;
  ERR_FILE_TOO_BIG = -8;
  ERR_UNEXPECTED = -9;
  ERR_ACCESS_DENIED = -10;
  ERR_NOT_IMPLEMENTED = -11;
  ERR_CONNECTION_CLOSED = -100;
  ERR_CONNECTION_RESET = -101;
  ERR_CONNECTION_REFUSED = -102;
  ERR_CONNECTION_ABORTED = -103;
  ERR_CONNECTION_FAILED = -104;
  ERR_NAME_NOT_RESOLVED = -105;
  ERR_INTERNET_DISCONNECTED = -106;
  ERR_SSL_PROTOCOL_ERROR = -107;
  ERR_ADDRESS_INVALID = -108;
  ERR_ADDRESS_UNREACHABLE = -109;
  ERR_SSL_CLIENT_AUTH_CERT_NEEDED = -110;
  ERR_TUNNEL_CONNECTION_FAILED = -111;
  ERR_NO_SSL_VERSIONS_ENABLED = -112;
  ERR_SSL_VERSION_OR_CIPHER_MISMATCH = -113;
  ERR_SSL_RENEGOTIATION_REQUESTED = -114;
  ERR_CERT_COMMON_NAME_INVALID = -200;
  ERR_CERT_DATE_INVALID = -201;
  ERR_CERT_AUTHORITY_INVALID = -202;
  ERR_CERT_CONTAINS_ERRORS = -203;
  ERR_CERT_NO_REVOCATION_MECHANISM = -204;
  ERR_CERT_UNABLE_TO_CHECK_REVOCATION = -205;
  ERR_CERT_REVOKED = -206;
  ERR_CERT_INVALID = -207;
  ERR_CERT_END = -208;
  ERR_INVALID_URL = -300;
  ERR_DISALLOWED_URL_SCHEME = -301;
  ERR_UNKNOWN_URL_SCHEME = -302;
  ERR_TOO_MANY_REDIRECTS = -310;
  ERR_UNSAFE_REDIRECT = -311;
  ERR_UNSAFE_PORT = -312;
  ERR_INVALID_RESPONSE = -320;
  ERR_INVALID_CHUNKED_ENCODING = -321;
  ERR_METHOD_NOT_SUPPORTED = -322;
  ERR_UNEXPECTED_PROXY_AUTH = -323;
  ERR_EMPTY_RESPONSE = -324;
  ERR_RESPONSE_HEADERS_TOO_BIG = -325;
  ERR_CACHE_MISS = -400;
  ERR_INSECURE_RESPONSE = -501;

type
  // Structure representing menu information.
  TCefHandlerMenuInfo = record
    typeFlags: Integer;
    x: Integer;
    y: Integer;
    linkUrl: PWideChar;
    imageUrl: PWideChar;
    pageUrl: PWideChar;
    frameUrl: PWideChar;
    selectionText: PWideChar;
    misspelledWord: PWideChar;
    editFlags: Integer;
    securityInfo: PWideChar;
  end;

  // The TCefHandlerMenuInfo typeFlags value will be a combination of the
  // following values.
  TCefHandlerMenuTypeBits = (
    // No node is selected
    MENUTYPE_NONE = $0,
    // The top page is selected
    MENUTYPE_PAGE = $1,
    // A subframe page is selected
    MENUTYPE_FRAME = $2,
    // A link is selected
    MENUTYPE_LINK = $4,
    // An image is selected
    MENUTYPE_IMAGE = $8,
    // There is a textual or mixed selection that is selected
    MENUTYPE_SELECTION = $10,
    // An editable element is selected
    MENUTYPE_EDITABLE = $20,
    // A misspelled word is selected
    MENUTYPE_MISSPELLED_WORD = $40,
    // A video node is selected
    MENUTYPE_VIDEO = $80,
    // A video node is selected
    MENUTYPE_AUDIO = $100
  );

  // The TCefHandlerMenuInfo editFlags value will be a combination of the
  // following values.
  TCefHandlerMenuCapabilityBits = (
    MENU_CAN_DO_NONE = $0,
    MENU_CAN_UNDO = $1,
    MENU_CAN_REDO = $2,
    MENU_CAN_CUT = $4,
    MENU_CAN_COPY = $8,
    MENU_CAN_PASTE = $10,
    MENU_CAN_DELETE = $20,
    MENU_CAN_SELECT_ALL = $40,
    MENU_CAN_GO_FORWARD = $80,
    MENU_CAN_GO_BACK = $100
  );

  // Supported menu ID values.
  TCefHandlerMenuId = (
    MENU_ID_NAV_BACK = 10,
    MENU_ID_NAV_FORWARD = 11,
    MENU_ID_NAV_RELOAD = 12,
    MENU_ID_NAV_STOP = 13,
    MENU_ID_UNDO = 20,
    MENU_ID_REDO = 21,
    MENU_ID_CUT = 22,
    MENU_ID_COPY = 23,
    MENU_ID_PASTE = 24,
    MENU_ID_DELETE = 25,
    MENU_ID_SELECTALL = 26,
    MENU_ID_PRINT = 30,
    MENU_ID_VIEWSOURCE = 31
  );

  // Post data elements may represent either bytes or files.
  TCefPostDataElementType = (
    PDE_TYPE_EMPTY  = 0,
    PDE_TYPE_BYTES,
    PDE_TYPE_FILE
  );

  // Key event types.
  TCefHandlerKeyEventType = (
    KEYEVENT_RAWKEYDOWN = 0,
    KEYEVENT_KEYDOWN,
    KEYEVENT_KEYUP,
    KEYEVENT_CHAR
  );

  // Key event modifiers.
  TCefHandlerKeyEventModifiers = (
    KEY_SHIFT = 1 shl 0,
    KEY_CTRL  = 1 shl 1,
    KEY_ALT   = 1 shl 2,
    KEY_META  = 1 shl 3
  );

(*******************************************************************************
   capi
 *******************************************************************************)
type
  PCefv8Handler = ^TCefv8Handler;
  PCefv8Value = ^TCefv8Value;
  PPcef_v8value_t = ^PCefv8Value;
  PCefSchemeHandlerFactory = ^TCefSchemeHandlerFactory;
  PCefHandler = ^TCefHandler;
  PCefFrame = ^TCefFrame;
  PCefRequest = ^TCefRequest;
  PCefStreamReader = ^TCefStreamReader;
  PCefHandlerMenuInfo = ^TCefHandlerMenuInfo;
  PCefPrintInfo = ^TCefPrintInfo;
  PCefPostData = ^TCefPostData;
  PCefPostDataElement = ^TCefPostDataElement;
  PCefReadHandler = ^TCefReadHandler;
  PCefWriteHandler = ^TCefWriteHandler;
  PCefStreamWriter = ^TCefStreamWriter;
  PCefSchemeHandler = ^TCefSchemeHandler;
  PCefBase = ^TCefBase;
  PCefBrowser = ^TCefBrowser;

  TCefBase = record
    // Size of the data structure.
    size: Cardinal;

    // Increment the reference count.
    add_ref: function(self: PCefBase): Integer; stdcall;
    // Decrement the reference count.  Delete this object when no references
    // remain.
    release: function(self: PCefBase): Integer; stdcall;
    // Returns the current number of references.
    get_refct: function(self: PCefBase): Integer; stdcall;
  end;

  // Structure used to represent a browser window.  All functions exposed by this
  // structure should be thread safe.
  TCefBrowser = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if the browser can navigate backwards.
    can_go_back: function(self: PCefBrowser): Integer; stdcall;

    // Navigate backwards.
    go_back: procedure(self: PCefBrowser); stdcall;

    // Returns true (1) if the browser can navigate forwards.
    can_go_forward: function(self: PCefBrowser): Integer; stdcall;

    // Navigate backwards.
    go_forward: procedure(self: PCefBrowser); stdcall;

    // Reload the current page.
    reload: procedure(self: PCefBrowser); stdcall;

    // Stop loading the page.
    stop_load: procedure(self: PCefBrowser); stdcall;

    // Set focus for the browser window.  If |enable| is true (1) focus will be
    // set to the window.  Otherwise, focus will be removed.
    set_focus: procedure(self: PCefBrowser; enable: Integer); stdcall;

    // Retrieve the window handle for this browser.
    get_window_handle: function(self: PCefBrowser): CefWindowHandle; stdcall;

    // Returns true (1) if the window is a popup window.
    is_popup: function(self: PCefBrowser): Integer; stdcall;

    // Returns the handler for this browser.
    get_handler: function(self: PCefBrowser): PCefHandler; stdcall;

    // Returns the main (top-level) frame for the browser window.
    get_main_frame: function(self: PCefBrowser): PCefFrame; stdcall;

    // Returns the focused frame for the browser window.
    get_focused_frame: function (self: PCefBrowser): PCefFrame; stdcall;

    // Returns the frame with the specified name, or NULL if not found.
    get_frame: function(self: PCefBrowser; const name: PWideChar): PCefFrame; stdcall;

    // Returns the names of all existing frames.
    get_frame_names: procedure(self: PCefBrowser; names: TCefStringList); stdcall;
  end;

  // Structure used to represent a frame in the browser window.  All functions
  // exposed by this structure should be thread safe.
  TCefFrame = record
    // Base structure.
    base: TCefBase;

    // Execute undo in this frame.
    undo: procedure(self: PCefFrame); stdcall;

    // Execute redo in this frame.
    redo: procedure(self: PCefFrame); stdcall;

    // Execute cut in this frame.
    cut: procedure(self: PCefFrame); stdcall;

    // Execute copy in this frame.
    copy: procedure(self: PCefFrame); stdcall;

    // Execute paste in this frame.
    paste: procedure(self: PCefFrame); stdcall;

    // Execute delete in this frame.
    del: procedure(self: PCefFrame); stdcall;

    // Execute select all in this frame.
    select_all: procedure(self: PCefFrame); stdcall;

    // Execute printing in the this frame.  The user will be prompted with the
    // print dialog appropriate to the operating system.
    print: procedure(self: PCefFrame); stdcall;

    // Save this frame's HTML source to a temporary file and open it in the
    // default text viewing application.
    view_source: procedure(self: PCefFrame); stdcall;

    // Returns this frame's HTML source as a string.
    // The resulting string must be freed by calling cef_string_free().
    get_source: function(self: PCefFrame): TCefString; stdcall;

    // Returns this frame's display text as a string.
    // The resulting string must be freed by calling cef_string_free().
    get_text: function(self: PCefFrame): TCefString; stdcall;

    // Load the request represented by the |request| object.
    load_request: procedure(self: PCefFrame; request: PCefRequest); stdcall;

    // Load the specified |url|.
    load_url: procedure(self: PCefFrame; const url: PWideChar); stdcall;

    // Load the contents of |string| with the optional dummy target |url|.
    load_string: procedure(self: PCefFrame; const string_, url: PWideChar); stdcall;

    // Load the contents of |stream| with the optional dummy target |url|.
    load_stream: procedure(self: PCefFrame; stream: PCefStreamReader; const url: PWideChar); stdcall;

    // Execute a string of JavaScript code in this frame. The |script_url|
    // parameter is the URL where the script in question can be found, if any. The
    // renderer may request this URL to show the developer the source of the
    // error.  The |start_line| parameter is the base line number to use for error
    // reporting.
    execute_java_script: procedure(self: PCefFrame; const jsCode, scriptUrl: PWideChar; startLine: Integer); stdcall;

    // Returns true (1) if this is the main frame.
    is_main: function(self: PCefFrame): Integer; stdcall;

    // Returns true (1) if this is the focused frame.
    is_focused: function(self: PCefFrame): Integer; stdcall;

    // Returns this frame's name.
    // The resulting string must be freed by calling cef_string_free().
    get_name: function(self: PCefFrame): TCefString; stdcall;

    // Return the URL currently loaded in this frame.
    // The resulting string must be freed by calling cef_string_free().
    get_url: function(self: PCefFrame): TCefString; stdcall;
  end;

  // Structure that should be implemented to handle events generated by the
  // browser window.  All functions exposed by this structure should be thread
  // safe. Each function in the structure returns a RetVal value.
  TCefHandler = record
    // Base structure.
    base: TCefBase;

    // Event called before a new window is created. The |parentBrowser| parameter
    // will point to the parent browser window, if any. The |popup| parameter will
    // be true (1) if the new window is a popup window. If you create the window
    // yourself you should populate the window handle member of |createInfo| and
    // return RV_HANDLED.  Otherwise, return RV_CONTINUE and the framework will
    // create the window.  By default, a newly created window will recieve the
    // same handler as the parent window.  To change the handler for the new
    // window modify the object that |handler| points to.
    handle_before_created: function(
        self: PCefHandler; parentBrowser: PCefBrowser;
        var windowInfo: TCefWindowInfo; popup: Integer;
        var handler: PCefHandler; var url: TCefString): TCefRetval; stdcall;

    // Event called after a new window is created. The return value is currently
    // ignored.
    handle_after_created: function(self: PCefHandler;
      browser: PCefBrowser): TCefRetval; stdcall;

    // Event called when a frame's address has changed. The return value is
    // currently ignored.
    handle_address_change: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; const url: PWideChar): TCefRetval; stdcall;

    // Event called when the page title changes. The return value is currently
    // ignored.
    handle_title_change: function(
        self: PCefHandler; browser: PCefBrowser;
        const title: PWideChar): TCefRetval; stdcall;

    // Event called before browser navigation. The client has an opportunity to
    // modify the |request| object if desired.  Return RV_HANDLED to cancel
    // navigation.
    handle_before_browse: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; request: PCefRequest;
        navType: TCefHandlerNavtype; isRedirect: Integer): TCefRetval; stdcall;

    // Event called when the browser begins loading a page.  The |frame| pointer
    // will be NULL if the event represents the overall load status and not the
    // load status for a particular frame.  The return value is currently ignored.
    handle_load_start: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame): TCefRetval; stdcall;

    // Event called when the browser is done loading a page. The |frame| pointer
    // will be NULL if the event represents the overall load status and not the
    // load status for a particular frame. This event will be generated
    // irrespective of whether the request completes successfully. The return
    // value is currently ignored.
    handle_load_end: function(self: PCefHandler;
        browser: PCefBrowser; frame: PCefFrame): TCefRetval; stdcall;

    // Called when the browser fails to load a resource.  |errorCode| is the error
    // code number and |failedUrl| is the URL that failed to load.  To provide
    // custom error text assign the text to |errorText| and return RV_HANDLED.
    // Otherwise, return RV_CONTINUE for the default error text.
    handle_load_error: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; errorCode: TCefHandlerErrorcode;
        const failedUrl: PWideChar; var errorText: TCefString): TCefRetval; stdcall;

    // Event called before a resource is loaded.  To allow the resource to load
    // normally return RV_CONTINUE. To redirect the resource to a new url populate
    // the |redirectUrl| value and return RV_CONTINUE.  To specify data for the
    // resource return a CefStream object in |resourceStream|, set |mimeType| to
    // the resource stream's mime type, and return RV_CONTINUE. To cancel loading
    // of the resource return RV_HANDLED.
    handle_before_resource_load: function(
        self: PCefHandler; browser: PCefBrowser;
        request: PCefRequest; var redirectUrl: TCefString;
        var resourceStream: PCefStreamReader; var mimeType: TCefString;
        loadFlags: Integer): TCefRetval; stdcall;

    // Event called before a context menu is displayed.  To cancel display of the
    // default context menu return RV_HANDLED.
    handle_before_menu: function(
        self: PCefHandler; browser: PCefBrowser;
        const menuInfo: PCefHandlerMenuInfo): TCefRetval; stdcall;

    // Event called to optionally override the default text for a context menu
    // item.  |label| contains the default text and may be modified to substitute
    // alternate text.  The return value is currently ignored.
    handle_get_menu_label: function(
        self: PCefHandler; browser: PCefBrowser;
        menuId: TCefHandlerMenuId; var label_: TCefString): TCefRetval; stdcall;

    // Event called when an option is selected from the default context menu.
    // Return RV_HANDLED to cancel default handling of the action.
    handle_menu_action: function(
        self: PCefHandler; browser: PCefBrowser;
        menuId: TCefHandlerMenuId): TCefRetval; stdcall;

    // Event called to format print headers and footers.  |printInfo| contains
    // platform-specific information about the printer context.  |url| is the URL
    // if the currently printing page, |title| is the title of the currently
    // printing page, |currentPage| is the current page number and |maxPages| is
    // the total number of pages.  Six default header locations are provided by
    // the implementation: top left, top center, top right, bottom left, bottom
    // center and bottom right.  To use one of these default locations just assign
    // a string to the appropriate variable.  To draw the header and footer
    // yourself return RV_HANDLED.  Otherwise, populate the approprate variables
    // and return RV_CONTINUE.
    handle_print_header_footer: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; printInfo: PCefPrintInfo;
        url, title: PWideChar; currentPage, maxPages: Integer;
        var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
        bottomRight: TCefString): TCefRetval; stdcall;

    // Run a JS alert message.  Return RV_CONTINUE to display the default alert or
    // RV_HANDLED if you displayed a custom alert.
    handle_jsalert: function(self: PCefHandler;
        browser: PCefBrowser; frame: PCefFrame;
        const message: PWideChar): TCefRetval; stdcall;

    // Run a JS confirm request.  Return RV_CONTINUE to display the default alert
    // or RV_HANDLED if you displayed a custom alert.  If you handled the alert
    // set |retval| to true (1) if the user accepted the confirmation.
    handle_jsconfirm: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; const message: PWideChar;
        var retval: Integer): TCefRetval; stdcall;

    // Run a JS prompt request.  Return RV_CONTINUE to display the default prompt
    // or RV_HANDLED if you displayed a custom prompt.  If you handled the prompt
    // set |retval| to true (1) if the user accepted the prompt and request and
    // |result| to the resulting value.
    handle_jsprompt: function(self: PCefHandler;
        browser: PCefBrowser; frame: PCefFrame;
        const message, defaultValue: PWideChar; var retval: Integer;
        var result: TCefString): TCefRetval; stdcall;

    // Called just before a window is closed. The return value is currently
    // ignored.
    handle_before_window_close: function(
        self: PCefHandler; browser: PCefBrowser): TCefRetval; stdcall;

    // Called when the browser component is about to loose focus. For instance, if
    // focus was on the last HTML element and the user pressed the TAB key. The
    // return value is currently ignored.
    handle_take_focus: function(
        self: PCefHandler; browser: PCefBrowser;
        reverse: Integer): TCefRetval; stdcall;

    // Called when the browser component is requesting focus. |isWidget| will be
    // true (1) if the focus is requested for a child widget of the browser
    // window. Return RV_CONTINUE to allow the focus to be set or RV_HANDLED to
    // cancel setting the focus.
    handle_set_focus: function(
        self: PCefHandler; browser: PCefBrowser;
        isWidget: Integer): TCefRetval; stdcall;

    // Called when the browser component receives a keyboard event. |type| is the
    // type of keyboard event (see |KeyEventType|). |code| is the windows scan-
    // code for the event. |modifiers| is a set of bit-flags describing any
    // pressed modifier keys. |isSystemKey| is set if Windows considers this a
    // 'system key' message;
    //   (see http://msdn.microsoft.com/en-us/library/ms646286(VS.85).aspx)
    // Return RV_HANDLED if the keyboard event was handled or RV_CONTINUE to allow
    // the browser component to handle the event.
    handle_key_event: function(
        self: PCefHandler; browser: PCefBrowser;
        event: TCefHandlerKeyEventType; code, modifiers,
        isSystemKey: Integer): TCefRetval; stdcall;
  end;

  // Structure used to represent a web request.
  TCefRequest = record
    // Base structure.
    base: TCefBase;

    // Fully qualified URL to load.
    // The resulting string must be freed by calling cef_string_free().
    get_url: function(self: PCefRequest): TCefString; stdcall;
    set_url: procedure(self: PCefRequest; const url: PWideChar); stdcall;

    // Optional request function type, defaulting to POST if post data is provided
    // and GET otherwise.
    // The resulting string must be freed by calling cef_string_free().
    get_method: function(self: PCefRequest): TCefString; stdcall;
    set_method: procedure(self: PCefRequest; const method: PWideChar); stdcall;

    // Optional post data.
    get_post_data: function(self: PCefRequest): PCefPostData; stdcall;
    set_post_data: procedure(self: PCefRequest; postData: PCefPostData); stdcall;

    // Optional header values.
    get_header_map: procedure(self: PCefRequest; headerMap: TCefStringMap); stdcall;
    set_header_map: procedure(self: PCefRequest; headerMap: TCefStringMap); stdcall;

    // Set all values at one time.
    set_: procedure(self: PCefRequest; const url, method: PWideChar;
      postData: PCefPostData;  headerMap: TCefStringMap); stdcall;

  end;

  // Structure used to represent post data for a web request.
  TCefPostData = record
    // Base structure.
    base: TCefBase;

    // Returns the number of existing post data elements.
    get_element_count: function(self: PCefPostData): Cardinal; stdcall;

    // Retrieve the post data elements.
    get_elements: function(self: PCefPostData;
      elementIndex: Integer): PCefPostDataElement; stdcall;

    // Remove the specified post data element.  Returns true (1) if the removal
    // succeeds.
    remove_element: function(self: PCefPostData;
      element: PCefPostDataElement): Integer; stdcall;

    // Add the specified post data element.  Returns true (1) if the add succeeds.
    add_element: function(self: PCefPostData;
        element: PCefPostDataElement): Integer; stdcall;

    // Remove all existing post data elements.
    remove_elements: procedure(self: PCefPostData); stdcall;

  end;

  // Structure used to represent a single element in the request post data.
  TCefPostDataElement = record
    // Base structure.
    base: TCefBase;

    // Remove all contents from the post data element.
    set_to_empty: procedure(self: PCefPostDataElement); stdcall;

    // The post data element will represent a file.
    set_to_file: procedure(self: PCefPostDataElement;
        const fileName: PWideChar); stdcall;

    // The post data element will represent bytes.  The bytes passed in will be
    // copied.
    set_to_bytes: procedure(self: PCefPostDataElement;
        size: Cardinal; const bytes: Pointer); stdcall;

    // Return the type of this post data element.
    get_type: function(self: PCefPostDataElement): TCefPostDataElementType; stdcall;

    // Return the file name.
    // The resulting string must be freed by calling cef_string_free().
    get_file: function(self: PCefPostDataElement): TCefString; stdcall;

    // Return the number of bytes.
    get_bytes_count: function(self: PCefPostDataElement): Cardinal; stdcall;

    // Read up to |size| bytes into |bytes| and return the number of bytes
    // actually read.
    get_bytes: function(self: PCefPostDataElement;
        size: Cardinal; bytes: Pointer): Cardinal; stdcall;
  end;

  // Structure the client can implement to provide a custom stream reader.
  TCefReadHandler = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefReadHandler; ptr: Pointer;
      size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefReadHandler; offset: LongInt;
      whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefReadHandler): LongInt; stdcall;

    // Return non-zero if at end of file.
    eof: function(self: PCefReadHandler): Integer; stdcall;
  end;

  // Structure used to read data from a stream.
  TCefStreamReader = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefStreamReader; ptr: Pointer;
        size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Returns zero on success and non-zero on failure.
    seek: function(self: PCefStreamReader; offset: LongInt;
        whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefStreamReader): LongInt; stdcall;

    // Return non-zero if at end of file.
    eof: function(self: PCefStreamReader): Integer; stdcall;
  end;

  // Structure the client can implement to provide a custom stream writer.
  TCefWriteHandler = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefWriteHandler;
        const ptr: Pointer; size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefWriteHandler; offset: LongInt;
        whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefWriteHandler): LongInt; stdcall;

    // Flush the stream.
    flush: function(self: PCefWriteHandler): Integer; stdcall;
  end;

  // Structure used to write data to a stream.
  TCefStreamWriter = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefStreamWriter;
        const ptr: Pointer; size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefStreamWriter; offset: LongInt;
        whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefStreamWriter): LongInt; stdcall;

    // Flush the stream.
    flush: function(self: PCefStreamWriter): Integer; stdcall;
  end;

  // Structure that should be implemented to handle V8 function calls.
  TCefv8Handler = record
    // Base structure.
    base: TCefBase;

    // Execute with the specified argument list and return value.  Return true (1)
    // if the function was handled.
    execute: function(self: PCefv8Handler;
        const name: PWideChar; obj: PCefv8Value; argumentCount: Cardinal;
        const arguments, retval: PPcef_v8value_t;
        exception: PCefString): Integer; stdcall;
  end;

  // Structure representing a V8 value.
  TCefv8Value = record
    // Base structure.
    base: TCefBase;

    // Check the value type.
    is_undefined: function(self: PCefv8Value): Integer; stdcall;
    is_null: function(self: PCefv8Value): Integer; stdcall;
    is_bool: function(self: PCefv8Value): Integer; stdcall;
    is_int: function(self: PCefv8Value): Integer; stdcall;
    is_double: function(self: PCefv8Value): Integer; stdcall;
    is_string: function(self: PCefv8Value): Integer; stdcall;
    is_object: function(self: PCefv8Value): Integer; stdcall;
    is_array: function(self: PCefv8Value): Integer; stdcall;
    is_function: function(self: PCefv8Value): Integer; stdcall;

    // Return a primitive value type.  The underlying data will be converted to
    // the requested type if necessary.
    get_bool_value: function(self: PCefv8Value): Integer; stdcall;
    get_int_value: function(self: PCefv8Value): Integer; stdcall;
    get_double_value: function(self: PCefv8Value): double; stdcall;
    // The resulting string must be freed by calling cef_string_free().
    get_string_value: function(self: PCefv8Value): TCefString; stdcall;


    // OBJECT METHODS - These functions are only available on objects. Arrays and
    // functions are also objects. String- and integer-based keys can be used
    // interchangably with the framework converting between them as necessary.
    // Keys beginning with "Cef::" and "v8::" are reserved by the system.

    // Returns true (1) if the object has a value with the specified identifier.
    has_value_bykey: function(self: PCefv8Value; const key: PWideChar): Integer; stdcall;
    has_value_byindex: function(self: PCefv8Value; index: Integer): Integer; stdcall;

    // Delete the value with the specified identifier.
    delete_value_bykey: function(self: PCefv8Value; const key: PWideChar): Integer; stdcall;
    delete_value_byindex: function(self: PCefv8Value; index: Integer): Integer; stdcall;

    // Returns the value with the specified identifier.
    get_value_bykey: function(self: PCefv8Value; const key: PWideChar): PCefv8Value; stdcall;
    get_value_byindex: function(self: PCefv8Value; index: Integer): PCefv8Value; stdcall;

    // Associate value with the specified identifier.
    set_value_bykey: function(self: PCefv8Value;
       const key: PWideChar; value: PCefv8Value): Integer; stdcall;
    set_value_byindex: function(self: PCefv8Value; index: Integer;
       value: PCefv8Value): Integer; stdcall;

    // Read the keys for the object's values into the specified vector. Integer-
    // based keys will also be returned as strings.
    get_keys: function(self: PCefv8Value;
        keys: TCefStringList): Integer; stdcall;

    // Returns the user data, if any, specified when the object was created.
    get_user_data: function(
        self: PCefv8Value): PCefBase; stdcall;


    // ARRAY METHODS - These functions are only available on arrays.

    // Returns the number of elements in the array.
    get_array_length: function(self: PCefv8Value): Integer; stdcall;


    // FUNCTION METHODS - These functions are only available on functions.

    // Returns the function name.
    // The resulting string must be freed by calling cef_string_free().
    get_function_name: function(self: PCefv8Value): TCefString; stdcall;

    // Returns the function handler or NULL if not a CEF-created function.
    get_function_handler: function(
        self: PCefv8Value): PCefv8Handler; stdcall;

    // Execute the function.
    execute_function: function(self: PCefv8Value;
        obj: PCefv8Value; argumentCount: Cardinal;
        const arguments: PPcef_v8value_t; retval: PPcef_v8value_t;
        exception: PCefString): Integer; stdcall;
  end;

  // Structure that creates TCefSchemeHandler instances.
  TCefSchemeHandlerFactory = record
    // Base structure.
    base: TCefBase;

    // Return a new scheme handler instance to handle the request.
    create: function(self: PCefSchemeHandlerFactory): PCefSchemeHandler; stdcall;
  end;

  // Structure used to represent a custom scheme handler structure.
  TCefSchemeHandler = record
    // Base structure.
    base: TCefBase;

    // Process the request. All response generation should take place in this
    // function. If there is no response set |response_length| to zero and
    // read_response() will not be called. If the response length is not known
    // then set |response_length| to -1 and read_response() will be called until
    // it returns false (0) or until the value of |bytes_read| is set to 0.
    // Otherwise, set |response_length| to a positive value and read_response()
    // will be called until it returns false (0), the value of |bytes_read| is set
    // to 0 or the specified number of bytes have been read. If there is a
    // response set |mime_type| to the mime type for the response.
    process_request: function(self: PCefSchemeHandler;
        request: PCefRequest; var mime_type: TCefString;
        var response_length: Integer): Integer; stdcall;

    // Cancel processing of the request.
    cancel: procedure(self: PCefSchemeHandler); stdcall;

    // Copy up to |bytes_to_read| bytes into |data_out|. If the copy succeeds set
    // |bytes_read| to the number of bytes copied and return true (1). If the copy
    // fails return false (0) and read_response() will not be called again.
    read_response: function(self: PCefSchemeHandler;
        data_out: Pointer; bytes_to_read: Integer; var bytes_read: Integer): Integer; stdcall;
  end;

  ICefBrowser = interface;
  ICefFrame = interface;
  ICefRequest = interface;

  ICefBrowser = interface(ICefBase)
    ['{BA003C2E-CF15-458F-9D4A-FE3CEFCF3EEF}']
    function CanGoBack: Boolean;
    procedure GoBack;
    function CanGoForward: Boolean;
    procedure GoForward;
    procedure Reload;
    procedure StopLoad;
    procedure SetFocus(enable: Boolean);
    function GetWindowHandle: CefWindowHandle;
    function IsPopup: Boolean;
    function GetHandler: ICefBase;
    function GetMainFrame: ICefFrame;
    function  GetFocusedFrame: ICefFrame;
    function GetFrame(const name: ustring): ICefFrame;
    procedure GetFrameNames(const names: TStrings);
    property MainFrame: ICefFrame read GetMainFrame;
    property Frame[const name: ustring]: ICefFrame read GetFrame;
  end;

  ICefPostDataElement = interface(ICefBase)
    ['{3353D1B8-0300-4ADC-8D74-4FF31C77D13C}']
    procedure SetToEmpty;
    procedure SetToFile(const fileName: ustring);
    procedure SetToBytes(size: Cardinal; bytes: Pointer);
    function GetType: TCefPostDataElementType;
    function GetFile: ustring;
    function GetBytesCount: Cardinal;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal;
  end;

  ICefPostData = interface(ICefBase)
    ['{1E677630-9339-4732-BB99-D6FE4DE4AEC0}']
    function GetCount: Cardinal;
    function GetElement(Index: Integer): ICefPostDataElement;
    function RemoveElement(const element: ICefPostDataElement): Integer;
    function AddElement(const element: ICefPostDataElement): Integer;
    procedure RemoveElements;
  end;

  ICefRequest = interface(ICefBase)
    ['{FB4718D3-7D13-4979-9F4C-D7F6C0EC592A}']
    function GetUrl: ustring;
    function GetMethod: ustring;
    function GetPostData: ICefPostData;
    procedure GetHeaderMap(HeaderMap: TCefStringMap);
    procedure SetUrl(const value: ustring);
    procedure SetMethod(const value: ustring);
    procedure SetPostData(const value: ICefPostData);
    procedure SetHeaderMap(HeaderMap: TCefStringMap);
    property Url: ustring read GetUrl write SetUrl;
    property Method: ustring read GetMethod write SetMethod;
    property PostData: ICefPostData read GetPostData write SetPostData;
  end;

  ICefFrame = interface(ICefBase)
    ['{8FD3D3A6-EA3A-4A72-8501-0276BD5C3D1D}']
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Del;
    procedure SelectAll;
    procedure Print;
    procedure ViewSource;
    function GetSource: ustring;
    function getText: ustring;
    procedure LoadRequest(const request: ICefRequest);
    procedure LoadUrl(const url: ustring);
    procedure LoadString(const str, url: ustring);
    procedure LoadStream(const stream: TStream; const url: ustring);
    procedure LoadFile(const filename, url: ustring);
    procedure ExecuteJavaScript(const jsCode, scriptUrl: ustring; startLine: Integer);
    function IsMain: Boolean;
    function IsFocused: Boolean;
    function GetName: ustring;
    function GetUrl: ustring;
    property Name: ustring read GetName;
    property Url: ustring read GetUrl;
    property Source: ustring read GetSource;
    property Text: ustring read getText;
  end;

  ICefStreamReader = interface(ICefBase)
    ['{DD5361CB-E558-49C5-A4BD-D1CE84ADB277}']
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal;
    function Seek(offset: LongInt; whence: Integer): Integer;
    function Tell: LongInt;
    function Eof: Boolean;
  end;


  ICefSchemeHandler = interface(ICefBase)
  ['{A965F2A8-1675-44AE-AA54-F4C64B85A263}']
    function ProcessRequest(const Request: ICefRequest; var MimeType: ustring;
      var ResponseLength: Integer): Boolean;
    procedure Cancel;
    function ReadResponse(DataOut: Pointer; BytesToRead: Integer;
      var BytesRead: Integer): Boolean;
  end;

  ICefSchemeHandlerFactory = interface(ICefBase)
    ['{4D9B7960-B73B-4EBD-9ABE-6C1C43C245EB}']
    function New: ICefSchemeHandler;
  end;

  TCefBaseOwn = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
    FCriticaSection: TRTLCriticalSection;
  protected
    function Wrap: Pointer;
    procedure Lock;
    procedure Unlock;
  public
    constructor CreateData(size: Cardinal); virtual;
    destructor Destroy; override;
    property Data: Pointer read Wrap;
  end;

  TCefBaseRef = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
  protected
    function Wrap: Pointer;
  public
    constructor Create(data: Pointer); virtual;
    destructor Destroy; override;
    class function UnWrap(data: Pointer): ICefBase;
  end;

  TCefBrowserRef = class(TCefBaseRef, ICefBrowser)
  protected
    function CanGoBack: Boolean;
    procedure GoBack;
    function CanGoForward: Boolean;
    procedure GoForward;
    procedure Reload;
    procedure StopLoad;
    procedure SetFocus(enable: Boolean);
    function GetWindowHandle: CefWindowHandle;
    function IsPopup: Boolean;
    function GetHandler: ICefBase;
    function GetMainFrame: ICefFrame;
    function  GetFocusedFrame: ICefFrame;
    function GetFrame(const name: ustring): ICefFrame;
    procedure GetFrameNames(const names: TStrings);
  public
    class function UnWrap(data: Pointer): ICefBrowser;
  end;

  TCefFrameRef = class(TCefBaseRef, ICefFrame)
  protected
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Del;
    procedure SelectAll;
    procedure Print;
    procedure ViewSource;
    function GetSource: ustring;
    function getText: ustring;
    procedure LoadRequest(const request: ICefRequest);
    procedure LoadUrl(const url: ustring);
    procedure LoadString(const str, url: ustring);
    procedure LoadStream(const stream: TStream; const url: ustring);
    procedure LoadFile(const filename, url: ustring);
    procedure ExecuteJavaScript(const jsCode, scriptUrl: ustring; startLine: Integer);
    function IsMain: Boolean;
    function IsFocused: Boolean;
    function GetName: ustring;
    function GetUrl: ustring;
  public
    class function UnWrap(data: Pointer): ICefFrame;
  end;

  TCefPostDataRef = class(TCefBaseRef, ICefPostData)
  protected
    function GetCount: Cardinal;
    function GetElement(Index: Integer): ICefPostDataElement;
    function RemoveElement(const element: ICefPostDataElement): Integer;
    function AddElement(const element: ICefPostDataElement): Integer;
    procedure RemoveElements;
  public
    class function UnWrap(data: Pointer): ICefPostData;
  end;

  TCefPostDataElementRef = class(TCefBaseRef, ICefPostDataElement)
  protected
    procedure SetToEmpty;
    procedure SetToFile(const fileName: ustring);
    procedure SetToBytes(size: Cardinal; bytes: Pointer);
    function GetType: TCefPostDataElementType;
    function GetFile: ustring;
    function GetBytesCount: Cardinal;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal;
  public
    class function UnWrap(data: Pointer): ICefPostDataElement;
  end;

  TCefRequestRef = class(TCefBaseRef, ICefRequest)
  protected
    function GetUrl: ustring;
    function GetMethod: ustring;
    function GetPostData: ICefPostData;
    procedure GetHeaderMap(HeaderMap: TCefStringMap);
    procedure SetUrl(const value: ustring);
    procedure SetMethod(const value: ustring);
    procedure SetPostData(const value: ICefPostData);
    procedure SetHeaderMap(HeaderMap: TCefStringMap);
  public
    class function UnWrap(data: Pointer): ICefRequest;
  end;

  TCefStreamReaderRef = class(TCefBaseRef, ICefStreamReader)
  protected
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal;
    function Seek(offset: LongInt; whence: Integer): Integer;
    function Tell: LongInt;
    function Eof: Boolean;
  public
    class function UnWrap(data: Pointer): ICefStreamReader;
  end;

  TCefHandlerOwn = class(TCefBaseOwn)
  protected
    function doOnBeforeCreated(const parentBrowser: ICefBrowser;
      var windowInfo: TCefWindowInfo; popup: Boolean;
      var handler: ICefBase; var url: ustring): TCefRetval; virtual;
    function doOnAfterCreated(const browser: ICefBrowser): TCefRetval; virtual;
    function doOnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring): TCefRetval; virtual;
    function doOnTitleChange(const browser: ICefBrowser;
      const title: ustring): TCefRetval; virtual;
    function doOnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navType: TCefHandlerNavtype;
      isRedirect: boolean): TCefRetval; virtual;
    function doOnLoadStart(const browser: ICefBrowser; const frame: ICefFrame): TCefRetval; virtual;
    function doOnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame): TCefRetval; virtual;
    function doOnLoadError(const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
      const failedUrl: ustring; var errorText: ustring): TCefRetval; virtual;
    function doOnBeforeResourceLoad(const browser: ICefBrowser;
      const request: ICefRequest; var redirectUrl: ustring;
      var resourceStream: ICefStreamReader; var mimeType: ustring;
      loadFlags: Integer): TCefRetval; virtual;
    function doOnBeforeMenu(const browser: ICefBrowser;
      const menuInfo: PCefHandlerMenuInfo): TCefRetval; virtual;
    function doOnGetMenuLabel(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId; var caption: ustring): TCefRetval; virtual;
    function doOnMenuAction(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId): TCefRetval; virtual;
    function doOnPrintHeaderFooter(const browser: ICefBrowser;
      const frame: ICefFrame; printInfo: PCefPrintInfo;
      const url, title: ustring; currentPage, maxPages: Integer;
      var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
      bottomRight: ustring): TCefRetval; virtual;
    function doOnJsAlert(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring): TCefRetval; virtual;
    function doOnJsConfirm(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring; var retval: Boolean): TCefRetval; virtual;
    function doOnJsPrompt(const browser: ICefBrowser; const frame: ICefFrame;
      const message, defaultValue: ustring; var retval: Boolean;
      var return: ustring): TCefRetval; virtual;
    function doOnBeforeWindowClose(const browser: ICefBrowser): TCefRetval; virtual;
    function doOnTakeFocus(const browser: ICefBrowser; reverse: Integer): TCefRetval; virtual;
    function doOnSetFocus(const browser: ICefBrowser; isWidget: Boolean): TCefRetval; virtual;
    function doOnKeyEvent(const browser: ICefBrowser; event: TCefHandlerKeyEventType;
      code, modifiers: Integer; isSystemKey: Boolean): TCefRetval; virtual;
  public
    constructor Create; virtual;
  end;

  TCefStreamReaderOwn = class(TCefBaseOwn, ICefStreamReader)
  private
    FStream: TStream;
    FOwned: Boolean;
  protected
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal; virtual;
    function Seek(offset: LongInt; whence: Integer): Integer; virtual;
    function Tell: LongInt; virtual;
    function Eof: Boolean; virtual;
  public
    constructor Create(Stream: TStream; Owned: Boolean); overload; virtual;
    constructor Create(const filename: string); overload; virtual;
    destructor Destroy; override;
  end;

  TCefPostDataElementOwn = class(TCefBaseOwn, ICefPostDataElement)
  private
    FDataType: TCefPostDataElementType;
    FValue: Pointer;
    FSize: Cardinal;
    procedure Clear;
  protected
    procedure SetToEmpty; virtual;
    procedure SetToFile(const fileName: ustring); virtual;
    procedure SetToBytes(size: Cardinal; bytes: Pointer); virtual;
    function GetType: TCefPostDataElementType; virtual;
    function GetFile: ustring; virtual;
    function GetBytesCount: Cardinal; virtual;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal; virtual;
  public
    constructor Create; virtual;
  end;

  TCefSchemeHandlerOwn = class(TCefBaseOwn, ICefSchemeHandler)
  private
    FCancelled: Boolean;
  protected
    function ProcessRequest(const Request: ICefRequest; var MimeType: ustring;
      var ResponseLength: Integer): Boolean; virtual;
    procedure Cancel; virtual;
    function ReadResponse(DataOut: Pointer; BytesToRead: Integer;
      var BytesRead: Integer): Boolean; virtual;
  public
    constructor Create; virtual;
    property Cancelled: Boolean read FCancelled;
  end;
  TCefSchemeHandlerClass = class of TCefSchemeHandlerOwn;


  TCefSchemeHandlerFactoryOwn = class(TCefBaseOwn, ICefSchemeHandlerFactory)
  private
    FClass: TCefSchemeHandlerClass;
  protected
    function New: ICefSchemeHandler; virtual;
  public
    constructor Create(const AClass: TCefSchemeHandlerClass); virtual;
  end;

procedure CefLoadLib(const cache: ustring);
function CefGetObject(ptr: Pointer): TObject;
function CefStringAlloc(const str: ustring): TCefString;
procedure CefStringFree(const str: TCefString);
function CefStringFreeAndGet(const str: TCefString): ustring;
function CefBrowserCreate(windowInfo: PCefWindowInfo; popup: Boolean;
  handler: PCefHandler; const url: ustring): Boolean;
function CefRegisterScheme(const SchemeName, HostName: ustring;
  const handler: TCefSchemeHandlerClass): Boolean;


var
  CefCache: ustring;

implementation
uses SysUtils;

const
  LIBCEF = 'libcef.dll';

var
  // Create a new browser window using the window parameters specified by
  // |windowInfo|. All values will be copied internally and the actual window will
  // be created on the UI thread.  The |popup| parameter should be true (1) if the
  // new window is a popup window. This function call will not block.
  cef_browser_create: function(windowInfo: PCefWindowInfo; popup: Integer; handler: PCefHandler; const url: PWideChar): Integer; cdecl;

  // Create a new browser window using the window parameters specified by
  // |windowInfo|. The |popup| parameter should be true (1) if the new window is a
  // popup window. This function call will block and can only be used if the
  // |multi_threaded_message_loop| parameter to cef_initialize() is false (0).
  cef_browser_create_sync: function(windowInfo: PCefWindowInfo; popup: Integer; handler: PCefHandler; const url: PWideChar): PCefBrowser; cdecl;

  // Perform message loop processing.  Has no affect if the browser UI loop is
  // running in a separate thread.
  cef_do_message_loop_work: procedure(); cdecl;

  // This function should only be called once when the application is started.
  // Create the thread to host the UI message loop.  A return value of true (1)
  // indicates that it succeeded and false (0) indicates that it failed. Set
  // |multi_threaded_message_loop| to true (1) to have the message loop run in a
  // separate thread.  If |multi_threaded_message_loop| is false (0) than the
  // cef_do_message_loop_work() function must be called from your message loop.
  // Set |cache_path| to the location where cache data will be stored on disk. If
  // |cache_path| is NULL an in-memory cache will be used for cache data.
  cef_initialize: function(multi_threaded_message_loop: Integer; cache_path: PWideChar): Integer; cdecl;

  // This function should only be called once before the application exits. Shut
  // down the thread hosting the UI message loop and destroy any created windows.
  cef_shutdown: procedure(); cdecl;

  // Return the wide character length of the CEF string as allocated by
  // cef_string_alloc_len(). The returned value does not include the NUL
  // terminating character. This length may differ from the string length
  // as returned by wcslen().
  cef_string_length: function(str: TCefString): Cardinal; cdecl;

  // Allocate and return a new CEF string that is a copy of |str|.  If |str| is
  // NULL or if allocation fails NULL will be returned.  If |str| is of length
  // 0 a valid empty CEF string will be returned.
  cef_string_alloc: function(const str: PWideChar): TCefString; cdecl;

  // Allocate and return a new CEF string that is a copy of |str|. |len| is the
  // wide character length of the new CEF string not including the NUL
  // terminating character. |str| will be copied without checking for a NUL
  // terminating character. If |str| is NULL or if allocation fails NULL will
  // be returned.  If |str| is of length 0 a valid empty CEF string will be
  // returned.
  cef_string_alloc_length: function(const str: PWideChar; len: Cardinal): TCefString; cdecl;

  // Reallocate an existing CEF string.  The contents of |oldstr| will be
  // replaced with the contents of |newstr|; |newstr| may not be NULL. Returns 1
  // on success and 0 on failure.
  cef_string_realloc: function(oldstr: PCefString; const newstr: PWideChar): Integer; cdecl;

  // Reallocate an existing CEF string.  If |newstr| is NULL the contents of
  // |oldstr| will remain unchanged; otherwise, they will be replaced with the
  // contents of |newstr|. |len| is the new wide character length of the string
  // not including the NUL terminating character.  Returns 1 on success and 0
  // on failure.
  cef_string_realloc_length: function(oldstr: PCefString; const newstr: PWideChar; len: Cardinal): Integer; cdecl;

  // Free a CEF string.  If |str| is NULL this function does nothing.
  cef_string_free: procedure(str: TCefString); cdecl;

  // Allocate a new string map.
  cef_string_map_alloc: function(): TCefStringMap; cdecl;
  //function cef_string_map_size(map: TCefStringMap): Integer; cdecl;
  cef_string_map_size: function(map: TCefStringMap): Integer; cdecl;
  // Return the value assigned to the specified key.
  cef_string_map_find: function(map: TCefStringMap; const key: PWideChar): TCefString; cdecl;
  // Return the key at the specified zero-based string map index.
  cef_string_map_key: function(map: TCefStringMap; index: Integer): TCefString; cdecl;
  // Return the value at the specified zero-based string map index.
  cef_string_map_value: function(map: TCefStringMap; index: Integer): TCefString; cdecl;
  // Append a new key/value pair at the end of the string map.
  cef_string_map_append: procedure(map: TCefStringMap; const key, value: PWideChar); cdecl;
  // Clear the string map.
  cef_string_map_clear: procedure(map: TCefStringMap); cdecl;
  // Free the string map.
  cef_string_map_free: procedure(map: TCefStringMap); cdecl;

  // Allocate a new string map.
  cef_string_list_alloc: function(): TCefStringList; cdecl;
  // Return the number of elements in the string list.
  cef_string_list_size: function(list: TCefStringList): Integer; cdecl;
  // Return the value at the specified zero-based string list index.
  cef_string_list_value: function(list: TCefStringList; index: Integer): TCefString; cdecl;
  // Append a new key/value pair at the end of the string list.
  cef_string_list_append: procedure(list: TCefStringList; const value: PWideChar); cdecl;
  // Clear the string list.
  cef_string_list_clear: procedure(list: TCefStringList); cdecl;
  // Free the string list.
  cef_string_list_free: procedure(list: TCefStringList); cdecl;

  // Register a new V8 extension with the specified JavaScript extension code and
  // handler. Functions implemented by the handler are prototyped using the
  // keyword 'native'. The calling of a native function is restricted to the scope
  // in which the prototype of the native function is defined.
  //
  // Example JavaScript extension code:
  //
  //   // create the 'example' global object if it doesn't already exist.
  //   if (!example)
  //     example = {};
  //   // create the 'example.test' global object if it doesn't already exist.
  //   if (!example.test)
  //     example.test = {};
  //   (function() {
  //     // Define the function 'example.test.myfunction'.
  //     example.test.myfunction = function() {
  //       // Call CefV8Handler::Execute() with the function name 'MyFunction'
  //       // and no arguments.
  //       native function MyFunction();
  //       return MyFunction();
  //     };
  //     // Define the getter function for parameter 'example.test.myparam'.
  //     example.test.__defineGetter__('myparam', function() {
  //       // Call CefV8Handler::Execute() with the function name 'GetMyParam'
  //       // and no arguments.
  //       native function GetMyParam();
  //       return GetMyParam();
  //     });
  //     // Define the setter function for parameter 'example.test.myparam'.
  //     example.test.__defineSetter__('myparam', function(b) {
  //       // Call CefV8Handler::Execute() with the function name 'SetMyParam'
  //       // and a single argument.
  //       native function SetMyParam();
  //       if(b) SetMyParam(b);
  //     });
  //
  //     // Extension definitions can also contain normal JavaScript variables
  //     // and functions.
  //     var myint = 0;
  //     example.test.increment = function() {
  //       myint += 1;
  //       return myint;
  //     };
  //   })();
  //
  // Example usage in the page:
  //
  //   // Call the function.
  //   example.test.myfunction();
  //   // Set the parameter.
  //   example.test.myparam = value;
  //   // Get the parameter.
  //   value = example.test.myparam;
  //   // Call another function.
  //   example.test.increment();
  //
  cef_register_extension: function(const extension_name, javascript_code: PWideChar; handler: PCefv8Handler): Integer; cdecl;

  // Register a custom scheme handler factory for the specified |scheme_name| and
  // |host_name|. All URLs beginning with scheme_name://host_name/ can be handled
  // by TCefSchemeHandler instances returned by the factory. Specify an NULL
  // |host_name| value to match all host names.
  cef_register_scheme: function(const scheme_name, host_name: PWideChar; factory: PCefSchemeHandlerFactory): Integer; cdecl;

  // Create a new TCefRequest object.
  cef_request_create: function(): PCefRequest; cdecl;

  // Create a new TCefPostData object.
  cef_post_data_create: function(): PCefPostData; cdecl;

  // Create a new cef_post_data_tElement object.
  cef_post_data_element_create: function(): PCefPostDataElement; cdecl;

  // Create a new TCefStreamReader object.
  cef_stream_reader_create_for_file: function(const fileName: PWideChar): PCefStreamReader; cdecl;
  cef_stream_reader_create_for_data: function(data: Pointer; size: Cardinal): PCefStreamReader; cdecl;
  cef_stream_reader_create_for_handler: function(handler: PCefReadHandler): PCefStreamReader; cdecl;

  // Create a new TCefStreamWriter object.
  cef_stream_writer_create_for_file: function(const fileName: PWideChar): PCefStreamWriter; cdecl;
  cef_stream_writer_create_for_handler: function(handler: PCefWriteHandler): PCefStreamWriter; cdecl;

  // Create a new TCefv8Value object of the specified type.  These functions
  // should only be called from within the JavaScript context in a
  // TCefv8Handler::execute() callback.
  cef_v8value_create_undefined: function(): PCefv8Value; cdecl;
  cef_v8value_create_null: function(): PCefv8Value; cdecl;
  cef_v8value_create_bool: function(value: Integer): PCefv8Value; cdecl;
  cef_v8value_create_int: function(value: Integer): PCefv8Value; cdecl;
  cef_v8value_create_double: function(value: Double): PCefv8Value; cdecl;
  cef_v8value_create_string: function(const value: PWideChar): PCefv8Value; cdecl;
  cef_v8value_create_object: function(user_data: PCefBase): PCefv8Value; cdecl;
  cef_v8value_create_array: function(): PCefv8Value; cdecl;
  cef_v8value_create_function: function(const name: PWideChar; handler: PCefv8Handler): PCefv8Value; cdecl;

function CefGetData(const i: ICefBase): Pointer;
begin
  if i <> nil then
    Result := i.Wrap else
    Result := nil;
end;

function CefGetObject(ptr: Pointer): TObject;
begin
  Dec(PByte(ptr), SizeOf(Pointer));
  Result := TObject(PPointer(ptr)^);
end;

{ cef_base }

function cef_base_add_ref(self: PCefBase): Integer; stdcall;
begin
  Result := TCefBaseOwn(CefGetObject(self))._AddRef;
end;

function cef_base_release(self: PCefBase): Integer; stdcall;
begin
  Result := TCefBaseOwn(CefGetObject(self))._Release;
end;

function cef_base_get_refct(self: PCefBase): Integer; stdcall;
begin
  Result := TCefBaseOwn(CefGetObject(self)).FRefCount;
end;

{ cef_handler }

function cef_handler_handle_before_created(
    self: PCefHandler; parentBrowser: PCefBrowser;
    var windowInfo: TCefWindowInfo; popup: Integer;
    var handler: PCefHandler; var url: TCefString): TCefRetval; stdcall;
var
  _handler: ICefBase;
  _url: ustring;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    if handler <> nil then
      _handler := TCefBaseRef.UnWrap(handler) else
      _handler := nil;
    _url := url;

    Result := doOnBeforeCreated(
      TCefBrowserRef.UnWrap(parentBrowser),
      windowInfo,
      popup <> 0,
      _handler,
      _url);

    if Result = RV_HANDLED then
    begin
      if _handler <> nil then
        handler := _handler.Wrap;
      if url <> nil then
        cef_string_free(url);
      url := CefStringAlloc(_url);
    end;
  end;

end;

function cef_handler_handle_after_created(self: PCefHandler;
  browser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnAfterCreated(TCefBrowserRef.UnWrap(browser));
end;

function cef_handler_handle_address_change(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; const url: PWideChar): TCefRetval; stdcall;
begin
   with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnAddressChange(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      url)
end;

function cef_handler_handle_title_change(
    self: PCefHandler; browser: PCefBrowser;
    const title: PWideChar): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnTitleChange(TCefBrowserRef.UnWrap(browser), title);
end;

function cef_handler_handle_before_browse(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; request: PCefRequest;
    navType: TCefHandlerNavtype; isRedirect: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnBeforeBrowse(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request),
      navType,
      isRedirect <> 0)
end;

function cef_handler_handle_load_start(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnLoadStart(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame));
end;

function cef_handler_handle_load_end(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnLoadEnd(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame));
end;

function cef_handler_handle_load_error(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; errorCode: TCefHandlerErrorcode;
    const failedUrl: PWideChar; var errorText: TCefString): TCefRetval; stdcall;
var
  err: ustring;
begin
  err := errorText;
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnLoadError(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      errorCode,
      failedUrl,
      err);
    if Result = RV_HANDLED then
    begin
      if errorText <> nil then
        cef_string_free(errorText);
      errorText := CefStringAlloc(err);
    end;
  end;
end;

function cef_handler_handle_before_resource_load(
    self: PCefHandler; browser: PCefBrowser;
    request: PCefRequest; var redirectUrl: TCefString;
    var resourceStream: PCefStreamReader; var mimeType: TCefString;
    loadFlags: Integer): TCefRetval; stdcall;
var
  _redirectUrl: ustring;
  _resourceStream: ICefStreamReader;
  _mimeType: ustring;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    _redirectUrl := redirectUrl;
    _resourceStream := TCefStreamReaderRef.UnWrap(resourceStream);
    _mimeType := mimeType;

    Result := doOnBeforeResourceLoad(
      TCefBrowserRef.UnWrap(browser),
      TCefRequestRef.UnWrap(request),
      _redirectUrl,
      _resourceStream,
      _mimeType,
      loadFlags
      );

    if Result = RV_HANDLED then
    begin
      if _redirectUrl <> '' then
        redirectUrl := CefStringAlloc(_redirectUrl);

      if _resourceStream <> nil then
        resourceStream := _resourceStream.Wrap;

      if _mimeType <> '' then
        mimeType := CefStringAlloc(_mimeType);
    end;
  end;
end;

function cef_handler_handle_before_menu(
    self: PCefHandler; browser: PCefBrowser;
    const menuInfo: PCefHandlerMenuInfo): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnBeforeMenu(
      TCefBrowserRef.UnWrap(browser),
      menuInfo);
end;

function cef_handler_handle_get_menu_label(
    self: PCefHandler; browser: PCefBrowser;
    menuId: TCefHandlerMenuId; var label_: TCefString): TCefRetval; stdcall;
var
  str: ustring;
begin
  str := label_;
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnGetMenuLabel(
      TCefBrowserRef.UnWrap(browser),
      menuId,
      str);
    if Result = RV_HANDLED then
    begin
      if label_ <> nil then cef_string_free(label_);
      label_ := CefStringAlloc(str);
    end;
  end;
end;

function cef_handler_handle_menu_action(
    self: PCefHandler; browser: PCefBrowser;
    menuId: TCefHandlerMenuId): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnMenuAction(
      TCefBrowserRef.UnWrap(browser),
      menuId);
end;

function cef_handler_handle_print_header_footer(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; printInfo: PCefPrintInfo;
    url, title: PWideChar; currentPage, maxPages: Integer;
    var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
    bottomRight: TCefString): TCefRetval; stdcall;
var
  _topLeft, _topCenter, _topRight, _bottomLeft, _bottomCenter, _bottomRight: ustring;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnPrintHeaderFooter(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      printInfo, url, title, currentPage, maxPages,
      _topLeft, _topCenter, _topRight, _bottomLeft, _bottomCenter, _bottomRight
    );
    if Result = RV_HANDLED then
    begin
      topLeft := CefStringAlloc(_topLeft);
      topCenter := CefStringAlloc(_topCenter);
      topRight := CefStringAlloc(_topRight);
      bottomLeft := CefStringAlloc(_bottomLeft);
      bottomCenter := CefStringAlloc(_bottomCenter);
      bottomRight := CefStringAlloc(_bottomRight);
    end;
  end;
end;

function cef_handler_handle_jsalert(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame;
    const message: PWideChar): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnJsAlert(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      message);
end;

function cef_handler_handle_jsconfirm(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; const message: PWideChar;
    var retval: Integer): TCefRetval; stdcall;
var
  ret: Boolean;
begin
  ret := retval <> 0;
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnJsConfirm(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      message, ret);
  if Result = RV_HANDLED then
    retval := Ord(ret);

end;

function cef_handler_handle_jsprompt(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame;
    const message, defaultValue: PWideChar; var retval: Integer;
    var return: TCefString): TCefRetval; stdcall;
var
  ret: Boolean;
  str: ustring;
begin
  ret := retval <> 0;
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnJsPrompt(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      message, defaultValue, ret, str);
    if Result = RV_HANDLED then
    begin
      retval := Ord(ret);
      return := CefStringAlloc(str)
    end;
  end;
end;

function cef_handler_handle_before_window_close(
    self: PCefHandler; browser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnBeforeWindowClose(
      TCefBrowserRef.UnWrap(browser))
end;

function cef_handler_handle_take_focus(
    self: PCefHandler; browser: PCefBrowser;
    reverse: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnTakeFocus(
      TCefBrowserRef.UnWrap(browser), reverse);
end;

function cef_handler_handle_set_focus(
    self: PCefHandler; browser: PCefBrowser;
    isWidget: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnSetFocus(
      TCefBrowserRef.UnWrap(browser), isWidget <> 0);
end;

function cef_handler_handle_key_event(
    self: PCefHandler; browser: PCefBrowser;
    event: TCefHandlerKeyEventType; code, modifiers,
    isSystemKey: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnKeyEvent(
      TCefBrowserRef.UnWrap(browser),
      event, code, modifiers, isSystemKey <> 0);
end;

{  cef_stream_reader }

function cef_stream_reader_read(self: PCefStreamReader; ptr: Pointer; size, n: Cardinal): Cardinal; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Read(ptr, size, n);
end;

function cef_stream_reader_seek(self: PCefStreamReader; offset: LongInt; whence: Integer): Integer; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Seek(offset, whence);
end;

function cef_stream_reader_tell(self: PCefStreamReader): LongInt; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Tell;
end;

function cef_stream_reader_eof(self: PCefStreamReader): Integer; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Ord(eof);
end;

{ cef_post_data_element }

procedure cef_post_data_element_set_to_empty(self: PCefPostDataElement); stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToEmpty;
end;

procedure cef_post_data_element_set_to_file(self: PCefPostDataElement; const fileName: PWideChar); stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToFile(fileName);
end;

procedure cef_post_data_element_set_to_bytes(self: PCefPostDataElement; size: Cardinal; const bytes: Pointer); stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToBytes(size, bytes);
end;

function cef_post_data_element_get_type(self: PCefPostDataElement): TCefPostDataElementType; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetType;
end;

function cef_post_data_element_get_file(self: PCefPostDataElement): TCefString; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := CefStringAlloc(GetFile);
end;

function cef_post_data_element_get_bytes_count(self: PCefPostDataElement): Cardinal; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytesCount;
end;

function cef_post_data_element_get_bytes(self: PCefPostDataElement; size: Cardinal; bytes: Pointer): Cardinal; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytes(size, bytes)
end;

{ cef_scheme_handler_factory}

function cef_scheme_handler_factory_create(self: PCefSchemeHandlerFactory): PCefSchemeHandler; stdcall;
begin
  with TCefSchemeHandlerFactoryOwn(CefGetObject(self)) do
    Result := New.Wrap;
end;

{ cef_scheme_handler }

function cef_scheme_handler_process_request(self: PCefSchemeHandler;
  request: PCefRequest; var mime_type: TCefString;
  var response_length: Integer): Integer; stdcall;
var
  _mime_type: ustring;

begin
  with TCefSchemeHandlerOwn(CefGetObject(self)) do
    Result := Ord(ProcessRequest(TCefRequestRef.UnWrap(request),
      _mime_type, response_length));
  if _mime_type <> '' then
    mime_type := CefStringAlloc(_mime_type);
end;

procedure cef_scheme_handler_cancel(self: PCefSchemeHandler); stdcall;
begin
  with TCefSchemeHandlerOwn(CefGetObject(self)) do
    Cancel;
end;

function cef_scheme_handler_read_response(self: PCefSchemeHandler; data_out: Pointer; bytes_to_read: Integer; var bytes_read: Integer): Integer; stdcall;
begin
  with TCefSchemeHandlerOwn(CefGetObject(self)) do
    Result := Ord(ReadResponse(data_out, bytes_to_read, bytes_read));
end;

{ TCefBaseOwn }

constructor TCefBaseOwn.CreateData(size: Cardinal);
begin
  InitializeCriticalSection(FCriticaSection);
  GetMem(FData, size + SizeOf(Pointer));
  PPointer(FData)^ := Self;
  inc(PByte(FData), SizeOf(Pointer));
  FillChar(FData^, size, 0);
  PCefBase(FData)^.size := size;
  PCefBase(FData)^.add_ref := @cef_base_add_ref;
  PCefBase(FData)^.release := @cef_base_release;
  PCefBase(FData)^.get_refct := @cef_base_get_refct;
end;

destructor TCefBaseOwn.Destroy;
begin
  Dec(PByte(FData), SizeOf(Pointer));
  FreeMem(FData);
  DeleteCriticalSection(FCriticaSection);
  inherited;
end;

function TCefBaseOwn.Wrap: Pointer;
begin
  Result := FData;
  if Assigned(PCefBase(FData)^.add_ref) then
    PCefBase(FData)^.add_ref(PCefBase(FData));
end;

procedure TCefBaseOwn.Lock;
begin
  EnterCriticalSection(FCriticaSection);
end;

procedure TCefBaseOwn.Unlock;
begin
  LeaveCriticalSection(FCriticaSection);
end;

{ TCefHandlerOwn }

constructor TCefHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefHandler));
  with PCefHandler(FData)^ do
  begin
    handle_before_created := @cef_handler_handle_before_created;
    handle_after_created := @cef_handler_handle_after_created;
    handle_address_change := @cef_handler_handle_address_change;
    handle_title_change := @cef_handler_handle_title_change;
    handle_before_browse := @cef_handler_handle_before_browse;
    handle_load_start := @cef_handler_handle_load_start;
    handle_load_end := @cef_handler_handle_load_end;
    handle_load_error := @cef_handler_handle_load_error;
    handle_before_resource_load := @cef_handler_handle_before_resource_load;
    handle_before_menu := @cef_handler_handle_before_menu;
    handle_get_menu_label := @cef_handler_handle_get_menu_label;
    handle_menu_action := @cef_handler_handle_menu_action;
    handle_print_header_footer := @cef_handler_handle_print_header_footer;
    handle_jsalert := @cef_handler_handle_jsalert;
    handle_jsconfirm := @cef_handler_handle_jsconfirm;
    handle_jsprompt := @cef_handler_handle_jsprompt;
    handle_before_window_close := @cef_handler_handle_before_window_close;
    handle_take_focus := @cef_handler_handle_take_focus;
    handle_set_focus := @cef_handler_handle_set_focus;
    handle_key_event := @cef_handler_handle_key_event;
  end;
end;

function TCefHandlerOwn.doOnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnAfterCreated(const browser: ICefBrowser): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeBrowse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; navType: TCefHandlerNavtype;
  isRedirect: boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeCreated(const parentBrowser: ICefBrowser;
  var windowInfo: TCefWindowInfo; popup: Boolean; var handler: ICefBase; var url: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeMenu(const browser: ICefBrowser;
  const menuInfo: PCefHandlerMenuInfo): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeResourceLoad(const browser: ICefBrowser;
  const request: ICefRequest; var redirectUrl: ustring;
  var resourceStream: ICefStreamReader; var mimeType: ustring;
  loadFlags: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeWindowClose(
  const browser: ICefBrowser): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnGetMenuLabel(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId; var caption: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnJsAlert(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnJsConfirm(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring;
  var retval: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnJsPrompt(const browser: ICefBrowser;
  const frame: ICefFrame; const message, defaultValue: ustring;
  var retval: Boolean; var return: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnKeyEvent(const browser: ICefBrowser;
  event: TCefHandlerKeyEventType; code, modifiers: Integer;
  isSystemKey: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnLoadError(const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: TCefHandlerErrorcode; const failedUrl: ustring;
  var errorText: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnMenuAction(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnPrintHeaderFooter(const browser: ICefBrowser;
  const frame: ICefFrame; printInfo: PCefPrintInfo; const url, title: ustring;
  currentPage, maxPages: Integer; var topLeft, topCenter, topRight, bottomLeft,
  bottomCenter, bottomRight: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnSetFocus(const browser: ICefBrowser;
  isWidget: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnTakeFocus(const browser: ICefBrowser;
  reverse: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnTitleChange(const browser: ICefBrowser;
  const title: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

{ TCefBaseRef }

constructor TCefBaseRef.Create(data: Pointer);
begin
  FData := data;
  if Assigned(PCefBase(FData)^.add_ref) then
    PCefBase(FData)^.add_ref(PCefBase(FData));
end;

destructor TCefBaseRef.Destroy;
begin
  if Assigned(PCefBase(FData)^.release) then
    PCefBase(FData)^.release(PCefBase(FData));
  inherited;
end;

class function TCefBaseRef.UnWrap(data: Pointer): ICefBase;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

function TCefBaseRef.Wrap: Pointer;
begin
  Result := FData;
  if Assigned(PCefBase(FData)^.add_ref) then
    PCefBase(FData)^.add_ref(PCefBase(FData));
end;

{ TCefBrowserRef }

function TCefBrowserRef.CanGoBack: Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_back(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.CanGoForward: Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_forward(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.GetFocusedFrame: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_focused_frame(PCefBrowser(FData)))
end;

function TCefBrowserRef.GetFrame(const name: ustring): ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_frame(PCefBrowser(FData), PWideChar(name)));
end;

procedure TCefBrowserRef.GetFrameNames(const names: TStrings);
var
  list: TCefStringList;
  i: Integer;
begin
  list := cef_string_list_alloc;
  try
    PCefBrowser(FData)^.get_frame_names(PCefBrowser(FData), list);
    for i := 0 to cef_string_list_size(list) - 1 do
      names.Add(cef_string_list_value(list, i));
  finally
    cef_string_list_free(list);
  end;
end;

function TCefBrowserRef.GetHandler: ICefBase;
begin
  Result := TInterfacedObject(CefGetObject(PCefBrowser(FData)^.get_handler(PCefBrowser(FData)))) as ICefBase;
end;

function TCefBrowserRef.GetMainFrame: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_main_frame(PCefBrowser(FData)))
end;

function TCefBrowserRef.GetWindowHandle: CefWindowHandle;
begin
  Result := PCefBrowser(FData)^.get_window_handle(PCefBrowser(FData));
end;

procedure TCefBrowserRef.GoBack;
begin
  PCefBrowser(FData)^.go_back(PCefBrowser(FData));
end;

procedure TCefBrowserRef.GoForward;
begin
  PCefBrowser(FData)^.go_forward(PCefBrowser(FData));
end;

function TCefBrowserRef.IsPopup: Boolean;
begin
  Result := PCefBrowser(FData)^.is_popup(PCefBrowser(FData)) <> 0;
end;

procedure TCefBrowserRef.Reload;
begin
  PCefBrowser(FData)^.reload(PCefBrowser(FData));
end;

procedure TCefBrowserRef.SetFocus(enable: Boolean);
begin
  PCefBrowser(FData)^.set_focus(PCefBrowser(FData), ord(enable));
end;

procedure TCefBrowserRef.StopLoad;
begin
  PCefBrowser(FData)^.stop_load(PCefBrowser(FData));
end;

class function TCefBrowserRef.UnWrap(data: Pointer): ICefBrowser;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefFrameRef }

procedure TCefFrameRef.Copy;
begin
  PCefFrame(FData)^.copy(PCefFrame(FData));
end;

procedure TCefFrameRef.Cut;
begin
  PCefFrame(FData)^.cut(PCefFrame(FData));
end;

procedure TCefFrameRef.Del;
begin
  PCefFrame(FData)^.del(PCefFrame(FData));
end;

procedure TCefFrameRef.ExecuteJavaScript(const jsCode, scriptUrl: ustring;
  startLine: Integer);
begin
  PCefFrame(FData)^.execute_java_script(PCefFrame(FData), PWideChar(jsCode), PWideChar(scriptUrl), startline);
end;

function TCefFrameRef.GetName: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_name(PCefFrame(FData)));
end;

function TCefFrameRef.GetSource: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_source(PCefFrame(FData)));
end;

function TCefFrameRef.getText: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_text(PCefFrame(FData)));
end;

function TCefFrameRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_url(PCefFrame(FData)));
end;

function TCefFrameRef.IsFocused: Boolean;
begin
  Result := PCefFrame(FData)^.is_focused(PCefFrame(FData)) <> 0;
end;

function TCefFrameRef.IsMain: Boolean;
begin
  Result := PCefFrame(FData)^.is_main(PCefFrame(FData)) <> 0;
end;

procedure TCefFrameRef.LoadFile(const filename, url: ustring);
var
  strm: ICefStreamReader;
begin
  strm := TCefStreamReaderOwn.Create(filename);
  PCefFrame(FData)^.load_stream(PCefFrame(FData), strm.Wrap, PWideChar(url));
end;

procedure TCefFrameRef.LoadRequest(const request: ICefRequest);
begin
  PCefFrame(FData)^.load_request(PCefFrame(FData), request.Wrap);
end;

procedure TCefFrameRef.LoadStream(const stream: TStream; const url: ustring);
var
  strm: ICefStreamReader;
begin
  strm := TCefStreamReaderOwn.Create(stream, False);
  PCefFrame(FData)^.load_stream(PCefFrame(FData), strm.Wrap, PWideChar(url));
end;

procedure TCefFrameRef.LoadString(const str, url: ustring);
begin
  PCefFrame(FData)^.load_string(PCefFrame(FData), PWideChar(str), PWideChar(url));
end;

procedure TCefFrameRef.LoadUrl(const url: ustring);
begin
  PCefFrame(FData)^.load_url(PCefFrame(FData), PWideChar(url));
end;

procedure TCefFrameRef.Paste;
begin
  PCefFrame(FData)^.paste(PCefFrame(FData));
end;

procedure TCefFrameRef.Print;
begin
  PCefFrame(FData)^.print(PCefFrame(FData));
end;

procedure TCefFrameRef.Redo;
begin
  PCefFrame(FData)^.redo(PCefFrame(FData));
end;

procedure TCefFrameRef.SelectAll;
begin
  PCefFrame(FData)^.select_all(PCefFrame(FData));
end;

procedure TCefFrameRef.Undo;
begin
  PCefFrame(FData)^.undo(PCefFrame(FData));
end;

procedure TCefFrameRef.ViewSource;
begin
  PCefFrame(FData)^.view_source(PCefFrame(FData));
end;

class function TCefFrameRef.UnWrap(data: Pointer): ICefFrame;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefStreamReaderOwn }

constructor TCefStreamReaderOwn.Create(Stream: TStream; Owned: Boolean);
begin
  inherited CreateData(SizeOf(TCefStreamReader));
  FStream := stream;
  FOwned := Owned;
  with PCefStreamReader(FData)^ do
  begin
    read := @cef_stream_reader_read;
    seek := @cef_stream_reader_seek;
    tell := @cef_stream_reader_tell;
    eof := @cef_stream_reader_eof;
  end;
end;

constructor TCefStreamReaderOwn.Create(const filename: string);
begin
  Create(TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite), True);
end;

destructor TCefStreamReaderOwn.Destroy;
begin
  if FOwned then
    FStream.Free;
  inherited;
end;

function TCefStreamReaderOwn.Eof: Boolean;
begin
  Lock;
  try
    Result := FStream.Position = FStream.size;
  finally
    Unlock;
  end;
end;

function TCefStreamReaderOwn.Read(ptr: Pointer; size, n: Cardinal): Cardinal;
begin
  Lock;
  try
    result := Cardinal(FStream.Read(ptr^, n * size)) div size;
  finally
    Unlock;
  end;
end;

function TCefStreamReaderOwn.Seek(offset, whence: Integer): Integer;
begin
  Lock;
  try
    Result := FStream.Seek(offset, whence);
  finally
    Unlock;
  end;
end;

function TCefStreamReaderOwn.Tell: LongInt;
begin
  Lock;
  try
    Result := FStream.Position;
  finally
    Unlock;
  end;
end;

{ TCefPostDataRef }

function TCefPostDataRef.AddElement(
  const element: ICefPostDataElement): Integer;
begin
  Result := PCefPostData(FData)^.add_element(PCefPostData(FData), element.Wrap);
end;

function TCefPostDataRef.GetCount: Cardinal;
begin
  Result := PCefPostData(FData)^.get_element_count(PCefPostData(FData))
end;

function TCefPostDataRef.GetElement(Index: Integer): ICefPostDataElement;
begin
  Result := TCefPostDataElementRef.UnWrap(PCefPostData(FData)^.get_elements(PCefPostData(FData), Index))
end;

function TCefPostDataRef.RemoveElement(
  const element: ICefPostDataElement): Integer;
begin
  Result := PCefPostData(FData)^.remove_element(PCefPostData(FData), element.Wrap);
end;

procedure TCefPostDataRef.RemoveElements;
begin
  PCefPostData(FData)^.remove_elements(PCefPostData(FData));
end;

class function TCefPostDataRef.UnWrap(data: Pointer): ICefPostData;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefPostDataElementRef }

function TCefPostDataElementRef.GetBytes(size: Cardinal;
  bytes: Pointer): Cardinal;
begin
  Result := PCefPostDataElement(FData)^.get_bytes(PCefPostDataElement(FData), size, bytes);
end;

function TCefPostDataElementRef.GetBytesCount: Cardinal;
begin
  Result := PCefPostDataElement(FData)^.get_bytes_count(PCefPostDataElement(FData));
end;

function TCefPostDataElementRef.GetFile: ustring;
begin
  Result := CefStringFreeAndGet(PCefPostDataElement(FData)^.get_file(PCefPostDataElement(FData)));
end;

function TCefPostDataElementRef.GetType: TCefPostDataElementType;
begin
  Result := PCefPostDataElement(FData)^.get_type(PCefPostDataElement(FData));
end;

procedure TCefPostDataElementRef.SetToBytes(size: Cardinal; bytes: Pointer);
begin
  PCefPostDataElement(FData)^.set_to_bytes(PCefPostDataElement(FData), size, bytes);
end;

procedure TCefPostDataElementRef.SetToEmpty;
begin
  PCefPostDataElement(FData)^.set_to_empty(PCefPostDataElement(FData));
end;

procedure TCefPostDataElementRef.SetToFile(const fileName: ustring);
begin
  PCefPostDataElement(FData)^.set_to_file(PCefPostDataElement(FData), PWideChar(fileName));
end;

class function TCefPostDataElementRef.UnWrap(data: Pointer): ICefPostDataElement;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefPostDataElementOwn }

procedure TCefPostDataElementOwn.Clear;
begin
  case FDataType of
    PDE_TYPE_BYTES:
      if (FValue <> nil) then
        FreeMem(FValue);
    PDE_TYPE_FILE:
      if (FValue <> nil) then
        cef_string_free(FValue)
  end;
  FDataType := PDE_TYPE_EMPTY;
  FValue := nil;
  FSize := 0;
end;

constructor TCefPostDataElementOwn.Create;
begin
  inherited CreateData(SizeOf(TCefPostDataElement));
  FDataType := PDE_TYPE_EMPTY;
  FValue := nil;
  FSize := 0;
  with PCefPostDataElement(FData)^ do
  begin
    set_to_empty := @cef_post_data_element_set_to_empty;
    set_to_file := @cef_post_data_element_set_to_file;
    set_to_bytes := @cef_post_data_element_set_to_bytes;
    get_type := @cef_post_data_element_get_type;
    get_file := @cef_post_data_element_get_file;
    get_bytes_count := @cef_post_data_element_get_bytes_count;
    get_bytes := @cef_post_data_element_get_bytes;
  end;
end;

function TCefPostDataElementOwn.GetBytes(size: Cardinal;
  bytes: Pointer): Cardinal;
begin
  Lock;
  try
    if (FDataType = PDE_TYPE_BYTES) and (FValue <> nil) then
    begin
      if size > FSize then
        Result := FSize else
        Result := size;
      Move(FValue^, bytes^, Result);
    end else
      Result := 0;
  finally
    Unlock;
  end;
end;

function TCefPostDataElementOwn.GetBytesCount: Cardinal;
begin
  if (FDataType = PDE_TYPE_BYTES) then
    Result := FSize else
    Result := 0;
end;

function TCefPostDataElementOwn.GetFile: ustring;
begin
  Lock;
  try
    if (FDataType = PDE_TYPE_FILE) then
      Result := PWideChar(FValue) else
      Result := '';
  finally
    Unlock;
  end;
end;

function TCefPostDataElementOwn.GetType: TCefPostDataElementType;
begin
  Result := FDataType;
end;

procedure TCefPostDataElementOwn.SetToBytes(size: Cardinal; bytes: Pointer);
begin
  Lock;
  try
    Clear;
    if (size > 0) and (bytes <> nil) then
    begin
      GetMem(FValue, size);
      Move(bytes^, FValue, size);
      FSize := size;
    end else
    begin
      FValue := nil;
      FSize := 0;
    end;
    FDataType := PDE_TYPE_BYTES;
  finally
    Unlock;
  end;
end;

procedure TCefPostDataElementOwn.SetToEmpty;
begin
  Lock;
  try
    Clear;
  finally
    Unlock;
  end;
end;

procedure TCefPostDataElementOwn.SetToFile(const fileName: ustring);
begin
  Lock;
  try
    Clear;
    FSize := 0;
    FValue := cef_string_alloc(PWideChar(fileName));
    FDataType := PDE_TYPE_FILE;
  finally
    Unlock;
  end;
end;

{ TCefRequestRef }

procedure TCefRequestRef.GetHeaderMap(HeaderMap: TCefStringMap);
begin
  PCefRequest(FData)^.get_header_map(PCefRequest(FData), HeaderMap);
end;

function TCefRequestRef.GetMethod: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_method(PCefRequest(FData)))
end;

function TCefRequestRef.GetPostData: ICefPostData;
begin
  Result := TCefPostDataRef.UnWrap(PCefRequest(FData)^.get_post_data(PCefRequest(FData)));
end;

function TCefRequestRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_url(PCefRequest(FData)))
end;

procedure TCefRequestRef.SetHeaderMap(HeaderMap: TCefStringMap);
begin
  PCefRequest(FData)^.set_header_map(PCefRequest(FData), HeaderMap);
end;

procedure TCefRequestRef.SetMethod(const value: ustring);
begin
  PCefRequest(FData)^.set_method(PCefRequest(FData), PWideChar(value));
end;

procedure TCefRequestRef.SetPostData(const value: ICefPostData);
begin
  if value <> nil then
    PCefRequest(FData)^.set_post_data(PCefRequest(FData), value.Wrap);
end;

procedure TCefRequestRef.SetUrl(const value: ustring);
begin
  PCefRequest(FData)^.set_url(PCefRequest(FData), PWideChar(value));
end;

class function TCefRequestRef.UnWrap(data: Pointer): ICefRequest;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefStreamReaderRef }

function TCefStreamReaderRef.Eof: Boolean;
begin
  Result := PCefStreamReader(FData)^.eof(PCefStreamReader(FData)) <> 0;
end;

function TCefStreamReaderRef.Read(ptr: Pointer; size, n: Cardinal): Cardinal;
begin
  Result := PCefStreamReader(FData)^.read(PCefStreamReader(FData), ptr, size, n);
end;

function TCefStreamReaderRef.Seek(offset, whence: Integer): Integer;
begin
  Result := PCefStreamReader(FData)^.seek(PCefStreamReader(FData), offset, whence);
end;

function TCefStreamReaderRef.Tell: LongInt;
begin
  Result := PCefStreamReader(FData)^.tell(PCefStreamReader(FData));
end;

class function TCefStreamReaderRef.UnWrap(data: Pointer): ICefStreamReader;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefLib }

function CefInitialize(multi_threaded_message_loop: Boolean;
  const cache_path: ustring): Boolean;
begin
  Result := cef_initialize(Ord(multi_threaded_message_loop), PWideChar(cache_path)) <> 0;
end;

var
  LibHandle: THandle = INVALID_HANDLE_VALUE;

procedure CefLoadLib(const cache: ustring);
begin
  if LibHandle = INVALID_HANDLE_VALUE then
  begin
    LibHandle := LoadLibrary(LIBCEF);
    Assert(LibHandle <> INVALID_HANDLE_VALUE);
    cef_string_length := GetProcAddress(LibHandle, 'cef_string_length');
    cef_string_alloc := GetProcAddress(LibHandle, 'cef_string_alloc');
    cef_string_alloc_length := GetProcAddress(LibHandle, 'cef_string_alloc_length');
    cef_string_realloc := GetProcAddress(LibHandle, 'cef_string_realloc');
    cef_string_realloc_length := GetProcAddress(LibHandle, 'cef_string_realloc_length');
    cef_string_free := GetProcAddress(LibHandle, 'cef_string_free');
    cef_string_map_alloc := GetProcAddress(LibHandle, 'cef_string_map_alloc');
    cef_string_map_size := GetProcAddress(LibHandle, 'cef_string_map_size');
    cef_string_map_find := GetProcAddress(LibHandle, 'cef_string_map_find');
    cef_string_map_key := GetProcAddress(LibHandle, 'cef_string_map_key');
    cef_string_map_value := GetProcAddress(LibHandle, 'cef_string_map_value');
    cef_string_map_append := GetProcAddress(LibHandle, 'cef_string_map_append');
    cef_string_map_clear := GetProcAddress(LibHandle, 'cef_string_map_clear');
    cef_string_map_free := GetProcAddress(LibHandle, 'cef_string_map_free');
    cef_string_list_alloc := GetProcAddress(LibHandle, 'cef_string_list_alloc');
    cef_string_list_size := GetProcAddress(LibHandle, 'cef_string_list_size');
    cef_string_list_value := GetProcAddress(LibHandle, 'cef_string_list_value');
    cef_string_list_append := GetProcAddress(LibHandle, 'cef_string_list_append');
    cef_string_list_clear := GetProcAddress(LibHandle, 'cef_string_list_clear');
    cef_string_list_free := GetProcAddress(LibHandle, 'cef_string_list_free');
    cef_initialize := GetProcAddress(LibHandle, 'cef_initialize');
    cef_shutdown := GetProcAddress(LibHandle, 'cef_shutdown');
    cef_do_message_loop_work := GetProcAddress(LibHandle, 'cef_do_message_loop_work');
    cef_register_extension := GetProcAddress(LibHandle, 'cef_register_extension');
    cef_register_scheme := GetProcAddress(LibHandle, 'cef_register_scheme');
    cef_browser_create := GetProcAddress(LibHandle, 'cef_browser_create');
    cef_browser_create_sync := GetProcAddress(LibHandle, 'cef_browser_create_sync');
    cef_request_create := GetProcAddress(LibHandle, 'cef_request_create');
    cef_post_data_create := GetProcAddress(LibHandle, 'cef_post_data_create');
    cef_post_data_element_create := GetProcAddress(LibHandle, 'cef_post_data_element_create');
    cef_stream_reader_create_for_file := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_file');
    cef_stream_reader_create_for_data := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_data');
    cef_stream_reader_create_for_handler := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_handler');
    cef_stream_writer_create_for_file := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_file');
    cef_stream_writer_create_for_handler := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_handler');
    cef_v8value_create_undefined := GetProcAddress(LibHandle, 'cef_v8value_create_undefined');
    cef_v8value_create_null := GetProcAddress(LibHandle, 'cef_v8value_create_null');
    cef_v8value_create_bool := GetProcAddress(LibHandle, 'cef_v8value_create_bool');
    cef_v8value_create_int := GetProcAddress(LibHandle, 'cef_v8value_create_int');
    cef_v8value_create_double := GetProcAddress(LibHandle, 'cef_v8value_create_double');
    cef_v8value_create_string := GetProcAddress(LibHandle, 'cef_v8value_create_string');
    cef_v8value_create_object := GetProcAddress(LibHandle, 'cef_v8value_create_object');
    cef_v8value_create_array := GetProcAddress(LibHandle, 'cef_v8value_create_array');
    cef_v8value_create_function := GetProcAddress(LibHandle, 'cef_v8value_create_function');

    Assert(
      Assigned(cef_string_length) and
      Assigned(cef_string_alloc) and
      Assigned(cef_string_alloc_length) and
      Assigned(cef_string_realloc) and
      Assigned(cef_string_realloc_length) and
      Assigned(cef_string_free) and
      Assigned(cef_string_map_alloc) and
      Assigned(cef_string_map_size) and
      Assigned(cef_string_map_find) and
      Assigned(cef_string_map_key) and
      Assigned(cef_string_map_value) and
      Assigned(cef_string_map_append) and
      Assigned(cef_string_map_clear) and
      Assigned(cef_string_map_free) and
      Assigned(cef_string_list_alloc) and
      Assigned(cef_string_list_size) and
      Assigned(cef_string_list_value) and
      Assigned(cef_string_list_append) and
      Assigned(cef_string_list_clear) and
      Assigned(cef_string_list_free) and
      Assigned(cef_initialize) and
      Assigned(cef_shutdown) and
      Assigned(cef_do_message_loop_work) and
      Assigned(cef_register_extension) and
      Assigned(cef_register_scheme) and
      Assigned(cef_browser_create) and
      Assigned(cef_browser_create_sync) and
      Assigned(cef_request_create) and
      Assigned(cef_post_data_create) and
      Assigned(cef_post_data_element_create) and
      Assigned(cef_stream_reader_create_for_file) and
      Assigned(cef_stream_reader_create_for_data) and
      Assigned(cef_stream_reader_create_for_handler) and
      Assigned(cef_stream_writer_create_for_file) and
      Assigned(cef_stream_writer_create_for_handler) and
      Assigned(cef_v8value_create_undefined) and
      Assigned(cef_v8value_create_null) and
      Assigned(cef_v8value_create_bool) and
      Assigned(cef_v8value_create_int) and
      Assigned(cef_v8value_create_double) and
      Assigned(cef_v8value_create_string) and
      Assigned(cef_v8value_create_object) and
      Assigned(cef_v8value_create_array) and
      Assigned(cef_v8value_create_function));

    CefInitialize(True, cache);
  end;
end;

function CefBrowserCreate(windowInfo: PCefWindowInfo; popup: Boolean;
  handler: PCefHandler; const url: ustring): Boolean;
begin
  CefLoadLib(CefCache);
  Result :=
    cef_browser_create(
      windowInfo,
      Ord(popup),
      handler,
      PWideChar(url)) <> 0;
end;

function CefStringAlloc(const str: ustring): TCefString;
begin
  if str <> '' then
    Result := cef_string_alloc(PWideChar(str)) else
    Result := nil;
end;

function CefStringFreeAndGet(const str: TCefString): ustring;
begin
  if str <> nil then
  begin
    Result := str;
    cef_string_free(str);
  end else
    Result := '';
end;

procedure CefStringFree(const str: TCefString);
begin
  if str <> nil then
    cef_string_free(str);
end;

function CefRegisterScheme(const SchemeName, HostName: ustring;
  const handler: TCefSchemeHandlerClass): Boolean;
begin
  Result := cef_register_scheme(
    PWideChar(SchemeName),
    PWideChar(HostName),
    (TCefSchemeHandlerFactoryOwn.Create(handler) as ICefBase).Wrap) <> 0;
end;

{ TCefSchemeHandlerFactoryOwn }

constructor TCefSchemeHandlerFactoryOwn.Create(const AClass: TCefSchemeHandlerClass);
begin
  inherited CreateData(SizeOf(TCefSchemeHandlerFactory));
  with PCefSchemeHandlerFactory(FData)^ do
    create := @cef_scheme_handler_factory_create;
  FClass := AClass;
end;

function TCefSchemeHandlerFactoryOwn.New: ICefSchemeHandler;
begin
  Result := FClass.Create;
end;

{ TCefSchemeHandlerOwn }

procedure TCefSchemeHandlerOwn.Cancel;
begin
  // do not lock
  FCancelled := True;
end;

constructor TCefSchemeHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefSchemeHandler));
  FCancelled := False;
  with PCefSchemeHandler(FData)^ do
  begin
    process_request := @cef_scheme_handler_process_request;
    cancel := @cef_scheme_handler_cancel;
    read_response := @cef_scheme_handler_read_response;
  end;
end;

function TCefSchemeHandlerOwn.ProcessRequest(const Request: ICefRequest;
  var MimeType: ustring; var ResponseLength: Integer): Boolean;
begin
  Result := False;
end;

function TCefSchemeHandlerOwn.ReadResponse(DataOut: Pointer;
  BytesToRead: Integer; var BytesRead: Integer): Boolean;
begin
  Result := False;
end;

initialization
  IsMultiThread := True;

finalization
  if LibHandle <> INVALID_HANDLE_VALUE then
  begin
    cef_shutdown;
    FreeLibrary(LibHandle);
  end;

end.
