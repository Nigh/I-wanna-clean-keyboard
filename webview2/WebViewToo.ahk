;///////////////////////////////////////////////////////////////////////////////////////////
; WebViewToo.ahk v1.0.1-git
; Copyright (c) 2025 Ryan Dingman (known also as Panaku, The-CoDingman)
; https://github.com/The-CoDingman/WebViewToo
;
; MIT License
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;///////////////////////////////////////////////////////////////////////////////////////////

#Requires AutoHotkey v2
#Include WebView2.ahk

class WebViewGui extends Gui {
    /**
     * Creates a new Gui with a WebViewCtrl and necessary custom handling attached.
     * @param Options AlwaysOnTop Border Caption Disabled -DPIScale LastFound
     * MaximizeBox MinimizeBox MinSize600x600 MaxSize800x800 Resize
     * OwnDialogs '+Owner' OtherGui.hwnd +Parent
     * SysMenu Theme ToolWindow
     * @param Title The window title. If omitted, it defaults to the current value of A_ScriptName.
     * @param EventObj OnEvent, OnNotify and OnCommand can be used to register methods of EventObj to be called when an event is raised
     * @param {Object} WebViewSettings May contain a CreatedEnvironment, DataDir, EdgeRuntime, Options, or DllPath
     * @returns {WebViewGui}
     */
    __New(Options?, Title?, EventObj?, WebViewSettings := {}) {
        super.__New(Options?, Title?, EventObj?)
        DefaultWidth := WebViewSettings.HasProp("DefaultWidth") ? WebViewSettings.DefaultWidth : 640
        DefaultHeight := WebViewSettings.HasProp("DefaultHeight") ? WebViewSettings.DefaultHeight : 480
        /** @type {WebViewCtrl} */
        this.Control := WebViewCtrl(this, "w" DefaultWidth " h" DefaultHeight " vWebViewCtrl", WebViewSettings?)
        this.Control.IsNonClientRegionSupportEnabled := True
        this.Control.wv.AddHostObjectToScript("gui", {
            __Call: ((Hwnd, Th, Name, Q) => GuiFromHwnd(Hwnd).%Name%(Q*)).Bind(this.Hwnd)
        })
        this.Sizers := WebViewSizer("-Caption +Resize +Parent" this.Hwnd)
        this.OnEvent("Size", this.Size)
        for Prop in this.Control.OwnProps() {
            if (!this.HasProp(Prop)) {
                this.DefineProp(Prop, this.Control.GetOwnPropDesc(Prop))
            }
        }
        DllCall("Dwmapi.dll\DwmSetWindowAttribute", "Ptr", this.Hwnd, "UInt", DWMWA_WINDOW_CORNER_PREFERENCE := 33, "Ptr*", pvAttribute := 2, "UInt", 4)
        this.Move(,, DefaultWidth, DefaultHeight) ;Sets an initial size that is somewhat reasonable
        this.Control.wvc.Fill() ;Fill the window after setting initial size
        WebViewSizer.ToggleSizer(this) ;Toggle Sizers
        return this
    }
    LastMinMax := ""
    Size(MinMax, Width, Height) {
        ; Resize the WebView2 to fit the GUI
        this.Control.Move(0, 0, Width, Height)

        ;Resize the sizing handles to fit the GUI
        this.Sizers.Move(0, 0, Width, Height)

        if (MinMax == this.LastMinMax) {
            return
        }
        this.LastMinMax := MinMax

        ; When not visible, WebView2 stops rendering reducing its CPU load. When
        ; added to a hidden window, like we do in this class, the WebView2 is
        ; created non-visible by default and must be made visible before it will
        ; appear. This handler satisfies both situations.
        this.control.wvc.IsVisible := MinMax != -1

        if (MinMax == 1) { ; -1, 0, 1
            try this.Control.ExecuteScriptAsync("document.body.classList.add('ahk-maximized')")
            this.Sizers.Hide() ;Always hide the Sizers if the window is maximized
        } else {
            try this.Control.ExecuteScriptAsync("document.body.classList.remove('ahk-maximized')")
            WebViewSizer.ToggleSizer(this) ;Check if Sizers should be displayed or not
        }
    }

    __Delete() {
        ; Placeholder
    }

    ;-------------------------------------------------------------------------------------------
    ;Default GUI Overrides
    /** @throws {Error} Not applicable for a WebViewGui. */
    NotApplicableError(Msg := "") {
        throw Error("Not applicable for a WebViewGui. " Msg, -2)
    }

    /** @throws {Error} Not applicable for a WebViewGui. */
    Add(ControlType := "", Options := "", Value := "") => this.NotApplicableError("Did you mean AddRoute()?")

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddActiveX(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddButton(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddCheckbox(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddComboBox(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddCustom(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddDateTime(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddDropDownList(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddDDL(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddEdit(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddGroupBox(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddHotkey(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddLink(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddListBox(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddListView(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddMonthCal(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddPicture(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddPic(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddProgress(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddRadio(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddSlider(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddStatusBar(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddTab(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddTab2(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddTab3(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddText(Options := "", Value := "") => this.NotApplicableError("Did you mean AddTextRoute()?")

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddTreeView(Options := "", Value := "") => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    AddUpDown(Options := "", Value := "") => this.NotApplicableError()

    /** Close WebView2 instance and delete the window. */
    Destroy() {
        this.Sizers.Destroy()
        this.Sizers := 0
        Super.Destroy()
    }

    /** @throws {Error} Not applicable for a WebViewGui. */
    SetFont(Options := "", FontName := "") => this.NotApplicableError()

    /**
     * Display window. It can also minimize, maximize or move the window.
     * @param Options (Optional Parameter) Positioning: Xn Yn Wn Hn  Center xCenter yCenter AutoSize
     * Minimize Maximize Restore NoActivate NA Hide
     */
    Show(Options := "") {
        if (!((Style := WinGetStyle(this.Hwnd)) & 0x00800000)) {
            this.GetClientPos(&gX, &gY, &gWidth, &gHeight)
            Width := RegExMatch(Options, "w\s*\K\d+", &Match) ? Match[] : gWidth
            Height := RegExMatch(Options, "h\s*\K\d+", &Match) ? Match[] : gHeight

            Rect := Buffer(16, 0)
            DllCall("AdjustWindowRectEx",
                "Ptr", Rect,    ; LPRECT lpRect
                "UInt", Style,  ; DWORD dwStyle
                "UInt", 0,      ; BOOL bMenu
                "UInt", 0,      ; DWORD dwExStyle
                "UInt"          ; BOOL
            )
            Options .= " w" Width += (NumGet(Rect, 0, "Int") - NumGet(Rect, 8, "Int"))
            Options .= " h" Height += (NumGet(Rect, 4, "Int") - NumGet(Rect, 12, "Int"))
        }

        Super.Show(Options)
    }

    /** @throws {Error} Not applicable for a WebViewGui. */
    Submit(Hide := true) => this.NotApplicableError()

    /** @throws {Error} Not applicable for a WebViewGui. */
    FocusedCtrl {
        get => this.NotApplicableError()
    }

    /** @throws {Error} Not applicable for a WebViewGui. */
    MarginX {
        get => this.NotApplicableError()
        set => this.NotApplicableError()
    }

    /** @throws {Error} Not applicable for a WebViewGui. */
    MarginY {
        get => this.NotApplicableError()
        set => this.NotApplicableError()
    }
}

class WebViewSizer extends Gui {
    /**
     * Helper class for adding sizing handles to a caption-free WebViewGui
     */
    static __New() {
        OnMessage(0x0024, (Params*) => WebViewSizer.WM_GETMINMAXINFO(Params*))
        OnMessage(0x0083, (Params*) => WebViewSizer.WM_NCCALCSIZE(Params*))
        OnMessage(0x00A1, (Params*) => WebViewSizer.WM_NCLBUTTONDOWN(Params*))
        OnMessage(0x007D, (Params*) => WebViewSizer.WM_STYLECHANGED(Params*))
    }

    /** Tests if the cursor intersects with the sizing handles */
    static HitTest(lParam, Hwnd, &X?, &Y?) {
        static BorderSize := 29
        X := lParam << 48 >> 48, Y := lParam << 32 >> 48
        WinGetPos &gX, &gY, &gW, &gH, Hwnd
        Hit := (X < gX + BorderSize && 1) + (X >= gX + gW - BorderSize && 2)
            + (Y < gY + BorderSize && 3) + (Y >= gy + gH - BorderSize && 6)
        return Hit ? Hit + 9 : ""
    }

    /**
     * Ensures the borderless window does not turn into a borderless
     * fullscreen window
     */
    static WM_GETMINMAXINFO(wParam, lParam, Msg, Hwnd) {
        if (!((CurrGui := GuiFromHwnd(Hwnd)) is WebViewGui) || (WinGetStyle(Hwnd) & 0x00800000)) {
            return
        }

        if (ParentHwnd := DllCall("GetParent", "Int", CurrGui.Hwnd)) {
            ;If window has a parent, use it's parent's size
            WinGetPos(,, &ParentWidth, &ParentHeight, ParentHwnd)
            MaximizedXPos := 0, MaximizedYPos := 0, MaximizedWidth := ParentWidth, MaximizedHeight := ParentHeight
        } else {
            ;If window does not have a parent, use it's monitor's size
            MonitorInfo := Buffer(40), NumPut("UInt", MonitorInfo.Size, MonitorInfo)
            hMonitor := DllCall("MonitorFromWindow", "UInt", Hwnd, "UInt", Mode := 2)
            DllCall("GetMonitorInfo", "Ptr", hMonitor, "Ptr", MonitorInfo)
            MonitorLeft := NumGet(MonitorInfo, 4, "Int"), MonitorTop := NumGet(MonitorInfo, 8, "Int")
            MonitorRight := NumGet(MonitorInfo, 12, "Int"), MonitorBottom := NumGet(MonitorInfo, 16, "Int")
            MonitorWorkLeft := NumGet(MonitorInfo, 20, "Int"), MonitorWorkTop := NumGet(MonitorInfo, 24, "Int")
            MonitorWorkRight := NumGet(MonitorInfo, 28, "Int"), MonitorWorkBottom := NumGet(MonitorInfo, 32, "Int")
            MaximizedWidth := MonitorWorkRight - MonitorLeft, MaximizedHeight := MonitorWorkBottom - MonitorTop
            MaximizedXPos := MonitorWorkLeft - MonitorLeft, MaximizedYPos := MonitorWorkTop - MonitorTop
        }

        NumPut(
            "Int", MaximizedWidth,  ; Maximized Width
            "Int", MaximizedHeight, ; Maximized Height
            "Int", MaximizedXPos,   ; Maximized xPos
            "Int", MaximizedYPos,   ; Maximized yPos
            lParam, 8
        )
        return
    }

    /** Redirects sizing area clicks to sizer's associated parent GUI */
    static WM_NCLBUTTONDOWN(wParam, lParam, Msg, Hwnd) {
        if (!(GuiFromHwnd(Hwnd) is WebViewSizer)) {
            return
        }

        if (Hit := this.HitTest(lParam, Parent := DllCall("GetParent", "Ptr", Hwnd, "Ptr"), &X, &Y)) {
            Buf := Buffer(4), NumPut("Short", X, "Short", Y, Buf)
            PostMessage(0x00A1, Hit, Buf, Parent)
            return 0
        }
    }

    /** Hides or shows sizers in sync with parent GUI style */
    static WM_STYLECHANGED(wParam, lParam, Msg, Hwnd) {
        if (!((CurrGui := GuiFromHwnd(Hwnd)) is WebViewGui)) {
            return
        }

        WebViewSizer.ToggleSizer(CurrGui)
    }

    /**
     * Checks the Parent GUI for WM_SIZEBOX and WM_BORDER styles
     * and toggles the Parent's Sizers' visibility as needed.
     *
     * @param Parent Parent GUI of a intialized Sizer
     */
    static ToggleSizer(Parent) {
        if (!(Parent is WebViewGui)) {
            return
        }

        if (((Style := WinGetStyle(Parent)) & 0x00040000) && !(Style & 0x00800000)) {
            Parent.Sizers.Show()
        } else {
            Parent.Sizers.Hide()
        }
    }

    /**
     * When a GUI has -Caption and +Resize, it normally shows a wonky looking
     * default sizing border. This handler recalculates the window size to
     * render the client area over top of where that sizing border would
     * normally be, so that it is hidden.
     */
    static WM_NCCALCSIZE(wParam, lParam, Msg, Hwnd) {
        if (!((CurrGui := GuiFromHwnd(Hwnd)) is WebViewGui) || (WinGetStyle(Hwnd) & 0x00800000)) {
            return
        }

        return 0
    }

    __New(p*) {
        super.__New(p*)
    }

    __Delete() {
        ; Placeholder
    }

    Move(X, Y, Width, Height) {
        ; Adjust the sizing handles to fit the GUI, first punching a big hole
        ; in the center for click-through, then resizing it to fit the GUI.
        hRgn1 := DllCall("CreateRectRgn", "Int", 0, "Int", 0, "Int", Width, "Int", Height, "Ptr")
        hRgn2 := DllCall("CreateRectRgn", "Int", 6, "Int", 6, "Int", Width - 6, "Int", Height - 6, "Ptr")
        DllCall("CombineRgn", "Ptr", hRgn1, "Ptr", hRgn1, "Ptr", hRgn2, "Int", RGN_DIFF := 4)
        DllCall("SetWindowRgn", "Ptr", this.Hwnd, "Ptr", hRgn1, "Int", true)

        DllCall("SetWindowPos",
            "Ptr", this.Hwnd, "Ptr", 0,
            "Int", 0, "Int", 0, "Int", Width, "Int", Height,
            "UInt", 0x4210 ; SWP_ASYNCWINDOWPOS | SWP_NOACTIVATE | SWP_NOOWNERZORDER
        )
    }
}

class WebViewCtrl extends Gui.Custom {
    /**
     * Creates a WebControl instance around a Gui.Custom control
     * @param Target The Gui you want to attach the control to
     * @param {String} Options Control options such as width, height, vName
     * @param {Object} WebViewSettings May contain a CreatedEnvironment, DataDir, EdgeRuntime, Options, or DllPath
     * @returns {WebViewCtrl}
     */
    static Call(Target, Options := "", WebViewSettings := {}) {
        Container := Gui.Prototype.AddCustom.Call(Target, "ClassStatic " Options)
        for Prop in this.Prototype.OwnProps() {
            Container.DefineProp(Prop, this.Prototype.GetOwnPropDesc(Prop))
        }
        Container.__Init(), Container.__New(WebViewSettings?)
        return Container
    }

    static __New() {
        OnExit((*) => WebViewCtrl.CloseAllWebViewCtrls())
    }

    static Template := {}
    static Template.Framework := "
    (
        <!DOCTYPE html>
        <html>
            <head>
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <style>{2}</style>
            </head>

            <body>
                <div class="main">{1}</div>
                <script>{3}</script>
            </body>
        </html>
    )"

    static Template.Css := "html, body {width: 100%; height: 100%;margin: 0; padding: 0;font-family: sans-serif;} body {display: flex;flex-direction: column;} .main {flex-grow: 1;overflow: hidden;}"
    static Template.Name := "Template.html"
    static Template.Html := "<div style='padding:100px;'>The documentation for <b>WebViewToo</b> is currently being reworked. Sorry for the inconvenience.</div>"
    static Template.JavaScript := ""

    static UniqueId => WebViewCtrl.CreateUniqueID()
    static CreateUniqueId() {
        SplitPath(A_ScriptName,,,, &OutNameNoExt)
        Loop Parse, OutNameNoExt {
            Id .= Mod(A_Index, 3) ? Format("{:X}", Ord(A_LoopField)) : "-" Format("{:X}", Ord(A_LoopField))
        }
        return RTrim(StrLower(Id), "-")
    }
    static TempDir := A_Temp "\" WebViewCtrl.UniqueId

    static ActiveHwnds := Map()

    __New(WebViewSettings?) {
        DllPath := WebViewSettings.HasProp("DllPath") ? WebViewSettings.DllPath : "WebView2Loader.dll"
        DataDir := WebViewSettings.HasProp("DataDir") ? WebViewSettings.DataDir : ""
        Options := WebViewSettings.HasProp("Options") ? WebViewSettings.Options : 0
        EdgeRuntime := WebViewSettings.HasProp("EdgeRuntime") ? WebViewSettings.EdgeRuntime : ""
        CreatedEnvironment := WebViewSettings.HasProp("CreatedEnvironment") ? WebViewSettings.CreatedEnvironment : 0
        Html := WebViewSettings.HasProp("Html") ? WebViewSettings.Html : WebViewCtrl.Template.Html
        Css := WebViewSettings.HasProp("Css") ? WebViewSettings.Css : WebViewCtrl.Template.Css
        JavaScript := WebViewSettings.HasProp("JavaScript") ? WebViewSettings.JavaScript : WebViewCtrl.Template.JavaScript
        Url := WebViewSettings.HasProp("Url") ? WebViewSettings.Url : ""

        this.wvc := WebView2.Create(this.Hwnd,, CreatedEnvironment, DataDir, EdgeRuntime, Options, DllPath)
        this.wv := this.wvc.CoreWebView2
        WebViewCtrl.ActiveHwnds[this.Hwnd] := this.wvc
        this.wv.InjectAhkComponent().await()
        this.wvc.IsVisible := 1
        if (A_IsCompiled) {
            this.BrowseExe()
        } else {
            this.BrowseFolder(A_WorkingDir)
        }

        this.wv.add_NavigationStarting(InstallGlobal)
        InstallGlobal(ICoreWebView2, Args) {
            static Proxy := { __Get: (this, Name, *) => %Name% }
            Host := WebViewCtrl.ParseUri(Args.Uri).Host
            if (Host ~= "i)\.localhost$" || this._AllowGlobalHosts.Has(Host)) {
                try ICoreWebView2.AddHostObjectToScript("global", Proxy)
            } else {
                try ICoreWebView2.RemoveHostObjectFromScript("global")
            }
        }

        ; Add the request router
        this.wv.add_WebResourceRequested((p*) => this._Router(p*))
        if (Url) {
            this.Navigate(Url)
        } else {
            this.NavigateToString(Format(WebViewCtrl.Template.Framework, Html, Css, JavaScript))
        }
        return this
    }

    ;This never seems to be called
    __Delete() {
        ; Placeholder
    }

    ;-------------------------------------------------------------------------------------------
    ;Custom Uri Routing

    _DefaultHost := "ahk.localhost"

    /**
     * Adds folder access into the WebView2 environment under the given host
     * name. Host names provided here should end with `.localhost` for best
     * performance.
     *
     * Folders added by this method cannot easily be used in compiled scripts.
     *
     * @param Path The path to the folder to add
     * @param Host The host name to add the folder under, e.g. `ahk.localhost`
     *
     */
    BrowseFolder(Path, Host := this._DefaultHost) {
        this.wv.SetVirtualHostNameToFolderMapping(Host, NormalizePath(Path), WebView2.HOST_RESOURCE_ACCESS_KIND.ALLOW)

        NormalizePath(Path) {
            cc := DllCall("GetFullPathName", "str", Path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
            buf := Buffer(cc * 2)
            DllCall("GetFullPathName", "str", path, "uint", cc, "ptr", buf, "ptr", 0)
            return StrGet(buf)
        }
    }

    /**
     * Adds exe resource access into the WebView2 environment under the given
     * host name.
     *
     * @param {String} Path Path to the exe to load resources from
     * @param {String} Host Host to make the resources available on
     */
    BrowseExe(Path?, Host := this._DefaultHost) {
        if (IsSet(Path)) {
            throw Error("Not yet supported")
        }

        this._CompileRoutesForHost(Host, [['**', (Uri) => WebViewCtrl.ExeRead(Uri.Path)]])
    }

    /**
     * Adds access to an individual file.
     *
     * @param {String} FilePath The path to load the file from
     * @param {String} Route    The route to make the file available under, if
     *                          different than the name of filePath.
     * @param {String} Host     The host name to add the file under
     */
    AddFileRoute(FilePath, Route?, Host := this._DefaultHost) {
        SplitPath(FilePath, &Name)
        if (A_IsCompiled) {
            this.AddRoute(Route ?? Name, (Uri) => WebViewCtrl.ExeRead(FilePath))
        } else {
            this.AddRoute(Route ?? Name, (Uri) => FileRead(FilePath, "RAW"))
        }
    }

    /**
     * Adds a text resource at the specified route
     *
     * @param {String} Route The route to make the resource available under
     * @param {String} Text  The text content for the resource
     * @param {String} Host  The host name to add the file under
     */
    AddTextRoute(Route, Text, Host := this._DefaultHost) {
        this.AddRoute(Route, Text, Host)
    }

    /**
     * Adds a resource at the specified route
     *
     * @param {String} Route    The route to make the resource available under
     * @param          Resource The resource to make available
     * @param {String} Host     The host name to add the resource under
     */
    AddRoute(Route, Resource, Host := this._DefaultHost) {
        this._Routes[Host].Dirty := true
        this._Routes[Host].InsertAt(1, [Route, Resource])
        if (!this._Routes.Dirty) {
            this._Routes.Dirty := true
            SetTimer(() => this._SaveUnsavedRoutes(), -1)
        }
    }

    /**
     * Allow pages at the given host to access the `ahk.global` object.
     * @param Host The host name to allow access under
     */
    AllowGlobalAccessFor(Host := this._DefaultHost) {
        this._AllowGlobalHosts[Host] := true
        ; TODO: Make change on any active page
    }

    /**
     * Shows a specified resource in the web view
     *
     * @param Path The path to the resource, not including any leading slash
     */
    Navigate(Path) {
        this._SaveUnsavedRoutes()
        if (!(Path ~= "i)^[^\/\\:]+:")) {
            Path := "https://" this._DefaultHost "/" LTrim(Path, "/\")
        }
        this.wv.Navigate(Path)
    }

    /** List of hosts allowed to access names in AHK's global scope */
    _AllowGlobalHosts := Map()

    /** Map of hosts to route lists */
    _Routes := WebViewCtrl._RouteMap()
    class _RouteMap extends Map {
        Dirty := false ; Has not been compiled since last change
        __Item[Name] => (
            this.Has(Name) || this.Set(Name, WebViewCtrl._RouteList()),
            this.Get(Name)
        )
    }

    /**
     * Contains a list of route objects. Route objects are a two-element array
     * pairing a route string and a resource.
     */
    class _RouteList extends Array {
        Dirty := false ; Has not been compiled since last change
    }

    /** Map of hosts to compiled regular expressions */
    _CompiledRoutes := Map()

    /**
     * Compiles any routes that have been changed since the last time they
     * were compiled
     */
    _SaveUnsavedRoutes() {
        if (!this._Routes.Dirty) {
            return
        }

        this._Routes.Dirty := false
        for Host, RouteList in this._Routes {
            if (!RouteList.Dirty) {
                continue
            }
            RouteList.Dirty := false
            this._CompileRoutesForHost(Host, RouteList)
        }
    }

    /** Compiles the routes for a specified host */
    _CompileRoutesForHost(Host, Routes) {
        ; Clear any overriding folder mappings that would prevent custom routing
        try this.wv.ClearVirtualHostNameToFolderMapping(Host)

        FullReg := ""
        for Route in Routes {
            Pattern := "^[\/\\]{0,}(\Q" StrReplace(Route[1], "\E", "\E\\E\Q") "\E)$(?C" A_Index ":Callout)"
            Pattern := StrReplace(Pattern, "**", "\E.{0,}?\Q")
            Pattern := StrReplace(Pattern, "*", "\E[^\/\\]{0,}?\Q")
            FullReg .= "|" Pattern
        }

        this._CompiledRoutes[Host] := {Pattern: "S)" SubStr(fullReg, 2), Routes: Routes.Clone()}

        ; Register the router to handle requests made against this domain
        this.wv.AddWebResourceRequestedFilter("http://" Host "/*", 0)
        this.wv.AddWebResourceRequestedFilter("https://" Host "/*", 0)
    }

    /** Connects requests to target resources */
    _Router(ICoreWebView2, Args) {
        Parsed := WebViewCtrl.ParseUri(Args.Request.Uri)
        Path := Parsed.Path, Host := Parsed.host
        
        Target := unset
        CompiledRoutes := this._CompiledRoutes[Host]
        RegExMatch(Path, CompiledRoutes.Pattern)
        if (!IsSet(Target)) {
            return
        }
        
        if (Target is Object && !(Target is Buffer)) {
            try Target := Target(Parsed)
        }

        if (Target is Buffer) {
            Stream := WebView2.CreateMemStream(Target)
            Args.Response := ICoreWebView2.Environment.CreateWebResourceResponse(Stream, 200, "OK", "")
            return
        }

        if (Target is String) {
            Headers := ""
            if (RegExMatch(Path, "i)\.([a-z0-9]+)$", &m)) {
                ext := StrLower(m[1])
                if (ext = "js" || ext = "mjs") {
                    Headers .= "Content-Type: text/javascript;"
                } else if (ext = "css") {
                    Headers .= "Content-Type: text/css;"
                } else if (ext = "html" || ext = "htm") {
                    Headers .= "Content-Type: text/html;"
                } else if (ext = "json" || ext = "map") {
                    Headers .= "Content-Type: application/json;"
                }
            }
            Stream := WebView2.CreateTextStream(Target)
            Args.Response := ICoreWebView2.Environment.CreateWebResourceResponse(Stream, 200, "OK", Headers)
            return
        }

        if (Target is WebView2.Stream) {
            Headers := ""
            ; Determine content type from requested path (ignore querystring)
            if (RegExMatch(Path, "i)\.([a-z0-9]+)$", &m)) {
                ext := StrLower(m[1])
                if (ext = "js" || ext = "mjs") {
                    Headers .= "Content-Type: text/javascript;"
                } else if (ext = "css") {
                    Headers .= "Content-Type: text/css;"
                } else if (ext = "html" || ext = "htm") {
                    Headers .= "Content-Type: text/html;"
                } else if (ext = "svg") {
                    Headers .= "Content-Type: image/svg+xml;"
                } else if (ext = "png") {
                    Headers .= "Content-Type: image/png;"
                } else if (ext = "jpg" || ext = "jpeg") {
                    Headers .= "Content-Type: image/jpeg;"
                } else if (ext = "gif") {
                    Headers .= "Content-Type: image/gif;"
                } else if (ext = "webp") {
                    Headers .= "Content-Type: image/webp;"
                } else if (ext = "ico") {
                    Headers .= "Content-Type: image/x-icon;"
                } else if (ext = "json" || ext = "map") {
                    Headers .= "Content-Type: application/json;"
                } else if (ext = "wasm") {
                    Headers .= "Content-Type: application/wasm;"
                } else if (ext = "pdf") {
                    Headers .= "Content-Type: application/pdf;"
                } else if (ext = "txt" || ext = "log") {
                    Headers .= "Content-Type: text/plain;"
                } else if (ext = "xml") {
                    Headers .= "Content-Type: application/xml;"
                } else if (ext = "csv") {
                    Headers .= "Content-Type: text/csv;"
                } else if (ext = "mp3") {
                    Headers .= "Content-Type: audio/mpeg;"
                } else if (ext = "wav") {
                    Headers .= "Content-Type: audio/wav;"
                } else if (ext = "ogg" || ext = "oga") {
                    Headers .= "Content-Type: audio/ogg;"
                } else if (ext = "mp4") {
                    Headers .= "Content-Type: video/mp4;"
                } else if (ext = "webm") {
                    Headers .= "Content-Type: video/webm;"
                } else if (ext = "woff") {
                    Headers .= "Content-Type: font/woff;"
                } else if (ext = "woff2") {
                    Headers .= "Content-Type: font/woff2;"
                } else if (ext = "ttf") {
                    Headers .= "Content-Type: font/ttf;"
                } else if (ext = "otf") {
                    Headers .= "Content-Type: font/otf;"
                }
            }
            Args.Response := ICoreWebView2.Environment.CreateWebResourceResponse(Target, 200, "OK", Headers)
            return
        }

        Callout(Match, Num, Pos, Haystack, Needle) {
            Target := CompiledRoutes.Routes[Num][2]
            return -1
        }
    }

    ;-------------------------------------------------------------------------------------------
    ;Static WebViewCtrl Methods
    static CloseAllWebViewCtrls() {
        for Hwnd, WebView in this.ActiveHwnds {
            try WebView.Close()
        }
    }

    static ConvertColor(RGB) => (RGB := RGB ~= "^0x" ? RGB : "0x" RGB, (((RGB & 0xFF) << 16) | (RGB & 0xFF00) | (RGB >> 16 & 0xFF)) << 8 | 0xFF) ;Must be a string

    static CreateFileFromResource(ResourceName, DestinationDir := WebViewCtrl.TempDir) { ;Create a file from an installed resource -- works like a dynamic `FileInstall()`
        if (!A_IsCompiled) {
            return
        }

        ResourceName := StrReplace(ResourceName, "/", "\")
        SplitPath(ResourceName, &OutFileName, &OutDir, &OutExt)
        ResourceType := OutExt = "bmp" || OutExt = "dib" ? 2 : OutExt = "ico" ? 14 : OutExt = "htm" || OutExt = "html" || OutExt = "mht" ? 23 : OutExt = "manifest" ? 24 : 10
        Module := DllCall("GetModuleHandle", "Ptr", 0, "Ptr")
        Resource := DllCall("FindResource", "Ptr", Module, "Str", ResourceName, "UInt", ResourceType, "Ptr")
        ResourceSize := DllCall("SizeofResource", "Ptr", Module, "Ptr", Resource)
        ResourceData := DllCall("LoadResource", "Ptr", Module, "Ptr", Resource, "Ptr")
        ConvertedData := DllCall("LockResource", "Ptr", ResourceData, "Ptr")
        ; TextData := StrGet(ConvertedData, ResourceSize, "UTF-8")

        if (!DirExist(DestinationDir "\" OutDir)) {
            DirCreate(DestinationDir "\" OutDir)
        }

        if (FileExist(DestinationDir "\" ResourceName)) {
            ExistingFile := FileOpen(DestinationDir "\" ResourceName, "r")
            ExistingFile.RawRead(TempBuffer := Buffer(ResourceSize))
            ExistingFile.Close()
            if (DllCall("ntdll\memcmp", "Ptr", TempBuffer, "Ptr", ConvertedData, "Ptr", ResourceSize)) {
                FileSetAttrib("-R", DestinationDir "\" ResourceName)
                FileDelete(DestinationDir "\" ResourceName)
            }
        }

        if (!FileExist(DestinationDir "\" ResourceName)) {
            TempFile := FileOpen(DestinationDir "\" ResourceName, "w", "CP0")
            TempFile.RawWrite(ConvertedData, ResourceSize)
            TempFile.Close()
            FileSetAttrib("+HR", DestinationDir "\" OutDir)
            FileSetAttrib("+HR", DestinationDir "\" ResourceName)
        }
    }

    static EscapeHtml(Text) => StrReplace(StrReplace(StrReplace(StrReplace(StrReplace(Text, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), "`"", "&quot;"), "'", "&#039;")

    static EscapeJavaScript(Text) => StrReplace(StrReplace(StrReplace(Text, '\', '\\'), '"', '\"'), '`n', '\n')

    static ExeRead(ResourcePath) {
        ResourcePath := StrReplace(StrUpper(LTrim(StrReplace(ResourcePath, "/", "\"), "\")), "%20", " ")
        SplitPath(ResourcePath,,, &OutExt)
        ResourceType := (OutExt = "bmp" || OutExt = "dib") ? 2 : (OutExt = "ico") ? 14 : (OutExt = "htm" || OutExt = "html" || OutExt = "mht") ? 23 : (OutExt = "manifest") ? 24 : 10
        Module := DllCall("GetModuleHandle", "Ptr", 0, "Ptr")
        Resource := DllCall("FindResource", "Ptr", Module, "Str", ResourcePath, "UInt", ResourceType, "Ptr")
        if (!Resource) {
            return
        }
        ResourceSize := DllCall("SizeofResource", "Ptr", Module, "Ptr", Resource)
        ResourceData := DllCall("LoadResource", "Ptr", Module, "Ptr", Resource, "Ptr")
        ConvertedData := DllCall("LockResource", "Ptr", ResourceData, "Ptr")
        return WebView2.CreateMemStream(ConvertedData, ResourceSize)
    }

    static ForEach(Obj, Parent := "Default", Depth := 0) {
        if(!IsObject(Obj) || (Type(Obj) = "ComObject")) {
            return
        }

        Output := ""
        for Key, Value, in Obj.OwnProps() {
            try Output .= "`n" Parent " >> " Key
            try Output .= ": " Value
            try Output .= WebViewCtrl.ForEach(Value, Parent " >> " Key, Depth + 1)
        }
        for Key, Value in base_props(Obj) {
            try Output .= "`n" Parent " >> " Key
            try Output .= ": " Value
            try Output .= WebViewCtrl.ForEach(Value, Parent " >> " Key, Depth + 1)
        }
        return Depth ? Output : Trim(Output, "`n")

        base_props(Obj) {
            iter := Obj.Base.OwnProps(), iter() ;skip `__Class`
            return next

            next(&Key, &Value, *) {
                while (iter(&Key))
                    ; try if !((Value := Obj.%Key%) is Func)
                        return true
                return false
            }
        }
    }

    static FormatHtml(FormatStr, Values*) {
        for Index, Value, in Values {
            Values[Index] := WebViewCtrl.EscapeHtml(Value)
        }
        return Format(FormatStr, Values*)
    }

    static ParseUri(Uri) {
        static Pattern := "^(?:(?<Scheme>\w+):)?(?://(?:(?<UserInfo>[^@]+)@)?(?<Host>[^:/?#]+)(?::(?<Port>\d+))?)?(?<Path>[^?#]*)?(?:\?(?<Query>[^#]*))?(?:#(?<Fragment>.*))?$"
        if (!RegExMatch(String(Uri), Pattern, &Match)) {
            return
        }
        Parsed := {}
        Parsed.Scheme := Match["Scheme"], Parsed.UserInfo := Match["UserInfo"], Parsed.Host := Match["Host"]
        Parsed.Port := Match["Port"], Parsed.Path := Match["Path"], Parsed.Query := Match["Query"]
        Parsed.Fragment := Match["Fragment"], Parsed.Authority := (Parsed.UserInfo != "" ? Parsed.UserInfo "@" : "") . Parsed.Host . (Parsed.Port != "" ? ":" Parsed.Port : "")
        return Parsed
    }

    ;-------------------------------------------------------------------------------------------
    ;WebViewCtrl class assignments
    AddCallbackToScript(CallbackName, Callback) => this.AddHostObjectToScript(CallbackName, Callback.Bind(this)) ;Similar to `AddHostObjectToScript()`, but only registers a callback
    RemoveCallbackFromScript(CallbackName) => this.RemoveHostObjectFromScript(CallbackName) ;Removes a registered callback
    Debug() {
        this.OpenDevToolsWindow()
    }

    DragParentWindow() {
        DllCall("ReleaseCapture")
        AncestorHwnd := DllCall("GetAncestor", "Int", this.Hwnd, "Int", GA_ROOT := 2)
        PostMessage(0x00A1, 2, 0,, AncestorHwnd) ;WM_NCLBUTTONDOWN
    }
    IsParentWindowDraggingEnabled {
        get => this._IsParentWindowDraggingEnabled
        set {
            if (!IsNumber(Value)) {
                throw ValueError("Expected a Number but got a String.", -1)
            }
            this._IsParentWindowDraggingEnabled := Value
            if (Value) {
                this.AddCallbackToScript("DragParentWindow", this.DragParentWindow)
            } else {
                this.RemoveCallbackFromScript("DragParentWindow")
            }
        }
    }
    _IsParentWindowDraggingEnabled := false

    Move(Params*) => (Super.Move(Params*), this.wvc.Fill())

    SimplePrintToPdf(FileName := "", Orientation := "Portrait", Timeout := 5000) {
        Loop {
            FileName := FileSelect("S", tFileName := IsSet(FileName) ? FileName : "",, "*.pdf")
            if (FileName = "") {
                return CancelMsg()
            }

            SplitPath(FileName, &OutFileName, &OutDir, &OutExt)
            FileName := OutExt = "" ? FileName ".pdf" : Filename
            if (FileExist(FileName)) {
                Overwrite := OverwriteMsg()
                if (Overwrite = "No") {
                    continue
                } else if (Overwrite = "Cancel") {
                    return CancelMsg()
                }
            }
            break
        }

        Settings := this.Environment.CreatePrintSettings()
        Settings.Orientation := Orientation = "Portrait" ? WebView2.PRINT_ORIENTATION.PORTRAIT : WebView2.PRINT_ORIENTATION.LANDSCAPE
        PrintPromise := this.PrintToPdfAsync(FileName, Settings)
        try PrintPromise.await(Timeout)
        if (!PrintPromise.Result) {
            ErrorMsg()
        } else {
            if (MsgBox("Would you like to open this PDF?", "Print to PDF", "262148") = "Yes") {
                Run(FileName)
            }
        }

        ErrorMsg() => MsgBox("An error occurred while attempting to save the file.`n" FileName, "Print to PDF", "262144")
        CancelMsg() => MsgBox("Print Canceled", "Print to PDF", "262144")
        OverwriteMsg() => MsgBox(OutFileName " already exist.`nWould you like to overwrite it?", "Confirm Save As", "262195")
    }

    ;-------------------------------------------------------------------------------------------
    ;Controller class assignments
    Fill() => this.wvc.Fill()
    CoreWebView2 => this.wvc.CoreWebView2 ;Gets the CoreWebView2 associated with this CoreWebView2Controller

    /**
     * Returns a boolean representing if the WebView2 instance is visible
     */
    IsVisible { ;Boolean => Determines whether to show or hide the WebView
        get => this.wvc.IsVisible
        set => this.wvc.IsVisible := Value
    }
    Bounds { ;Rectangle => Gets or sets the WebView bounds
        /**
         * Returns a Buffer()
         * You can extract the X, Y, Width, and Height using NumGet()
         * X is at offset 0, Y at offset 4, Width at offset 8, Height at offset 12.
        **/
        get => this.wvc.Bounds

        /**
         * Value must be a Buffer(16) that you've inserted values into
         * using NumPut(). See the above notes regarding the appropriate offsets.
        **/
        set => this.wvc.Bounds := Value
    }

    Bounds(X?, Y?, Width?, Height?) { ;Get: Object with X, Y, Width, Height properties; Set:
        tBounds := this.wvc.Bounds
        if (IsSet(X) || IsSet(Y) || IsSet(Width) || IsSet(Height)) {
            IsSet(X) ? NumPut("Int", X, tBounds, 0) : 0
            IsSet(Y) ? NumPut("Int", Y, tBounds, 4) : 0
            IsSet(Width) ? NumPut("Int", Width, tBounds, 8) : 0
            IsSet(Height) ? NumPut("Int", Height, tBounds, 12) : 0
            this.Bounds := tBounds
        } else {
            return Bounds := {
                X: NumGet(tBounds, 0, "Int"),
                Y: NumGet(tBounds, 4, "Int"),
                Width: NumGet(tBounds, 8, "Int"),
                Height: NumGet(tBounds, 12, "Int")
            }
        }
    }
    ZoomFactor { ;Double => Gets or sets the zoom factor for the WebView
        get => this.wvc.ZoomFactor
        set => this.wvc.ZoomFactor := Value
    }
    ParentWindow { ;Integer => Gets the parent window provided by the app or sets the parent window that this WebView is using to render content
        get => this.wvc.ParentWindow ;Returns the `Hwnd` of the Ctrl this instance is attached to
        set => this.wvc.ParentWindow := Value ;Not recommened to use set => because it dettaches the WebView2 window and can break the software
    }
    DefaultBackgroundColor { ;HexColorCode => Gets or sets the WebView default background color.
        get {
            BGRA := Format("{:X}", this.wvc.DefaultBackgroundColor)
            return SubStr(BGRA, 5, 2) SubStr(BGRA, 3, 2) SubStr(BGRA, 1, 2)
        }
        set => this.wvc.DefaultBackgroundColor := WebViewCtrl.ConvertColor(Value)
    }

    /**
     * RasterizationScale, ShouldDetectMonitorScaleChanges, and BoundsMode all work together
     * If you want to use set => (RasterizationScale||ShouldDetectMonitorScaleChanges||BoundsMode)
     * you will need to turn on DPI Awareness for your script by using the following DllCall
     * DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr") ;**NOTE: DpiAwareness Now causes fatal error, good luck**
    **/
    RasterizationScale { ;Double => Gets or sets the WebView rasterization scale
        get => this.wvc.RasterizationScale
        set => this.wvc.RasterizationScale := Value
    }
    ShouldDetectMonitorScaleChanges { ;Boolean => Determines whether the WebView will detect monitor scale changes
        get => this.wvc.ShouldDetectMonitorScaleChanges
        set => this.wvc.ShouldDetectMonitorScaleChanges := Value
    }
    BoundsMode { ;Boolean => Gets or sets the WebView bounds mode
        /**
         * 0: UseRawPixels; Bounds property represents raw pixels. Physical size of Webview is not impacted by RasterizationScale
         * 1: UseRasterizationScale; Bounds property represents logical pixels and the RasterizationScale property is used to get the physical size of the WebView.
        **/
        get => this.wvc.BoundsMode
        set => this.wvc.BoundsMode := Value
    }
    AllowExternalDrop { ;Boolean => Gets or sets the WebView allow external drop property
        get => this.wvc.AllowExternalDrop
        set => this.wvc.AllowExternalDrop := Value
    }
    SetBoundsAndZoomFactor(Bounds, ZoomFactor) => this.wvc.SetBoundsAndZoomFactor(Bounds, ZoomFactor) ;Updates Bounds and ZoomFactor properties at the same time

    /**
     * MoveFocus()
     * 1: Next; Specifies that the focus is moved due to Tab traversal forward
     * 2: Previous; Specifies that the focus is moved due to Tab traversal backward
     * 0: Programmatic; Specifies that the code is setting focus into WebView
    **/
    MoveFocus(Reason) => this.wvc.MoveFocus(Reason) ;Moves focus into WebView

    /**
     * NotifyParentWindowPositionChanged()
     * Notifies the WebView that the parent (or any ancestor) HWND moved
     * Example: Calling this method updates dialog windows such as the DownloadDialog
    **/
    NotifyParentWindowPositionChanged() => this.wvc.NotifyParentWindowPositionChanged()

    ;-------------------------------------------------------------------------------------------
    ;WebView2Core class assignments
    Settings => this.wv.Settings ;Returns Map() of Settings
        AreBrowserAcceleratorKeysEnabled { ;Boolean => Determines whether browser-specific accelerator keys are enabled
            get => this.Settings.AreBrowserAcceleratorKeysEnabled
            set => this.Settings.AreBrowserAcceleratorKeysEnabled := Value
        }
        AreDefaultContextMenusEnabled { ;Boolean => Determines whether the default context menus are shown to the user in WebView
            get => this.Settings.AreDefaultContextMenusEnabled
            set => this.Settings.AreDefaultContextMenusEnabled := Value
        }
        AreDefaultScriptDialogsEnabled { ;Boolean => Determines whether WebView renders the default JavaScript dialog box
            get => this.Settings.AreDefaultScriptDialogsEnabled
            set => this.Settings.AreDefaultScriptDialogsEnabled := Value
        }
        AreDevToolsEnabled { ;Boolean => Determines whether the user is able to use the context menu or keyboard shortcuts to open the DevTools window
            get => this.Settings.AreDevToolsEnabled
            set => this.Settings.AreDevToolsEnabled := Value
        }
        AreHostObjectsAllowed { ;Boolean => Determines whether host objects are accessible from the page in WebView
            get => this.Settings.AreHostObjectsAllowed
            set => this.Settings.AreHostObjectsAllowed := Value
        }
        HiddenPdfToolbarItems { ;Integer => Used to customize the PDF toolbar items
            /**
             * None:         0
             * Save:         1
             * Print:        2
             * SaveAs:       4
             * ZoomIn:       8
             * ZoomOut:      16
             * Rotate:       32
             * FitPage:      64
             * PageLayout:   128
             * Bookmarks:    256 ;This option is broken in the current runtime. See: https://github.com/MicrosoftEdge/WebView2Feedback/issues/2866
             * PageSelector  512
             * Search:       1024
             * FullScreen:   2048
             * MoreSettings: 4096
             * Add up numbers if you want to hide multiple items, Ex: 257 to hide Bookmarks and Save
            **/
            get => this.Settings.HiddenPdfToolbarItems
            set => this.Settings.HiddenPdfToolbarItems := Value
        }
        IsBuiltInErrorPageEnabled { ;Boolean => Determines whether to disable built in error page for navigation failure and render process failure
            get => this.Settings.IsBuiltInErrorPageEnabled
            set => this.Settings.IsBuiltInErrorPageEnabled := Value
        }
        IsGeneralAutofillEnabled { ;Boolean => Determines whether general form information will be saved and autofilled
            get => this.Settings.IsGeneralAutofillEnabled
            set => this.Settings.IsGeneralAutofillEnabled := Value
        }
        IsNonClientRegionSupportEnabled { ;Boolean => The IsNonClientRegionSupportEnabled property enables web pages to use the app-region CSS style
            get => this.wv.Settings.IsNonClientRegionSupportEnabled
            set => this.wv.Settings.IsNonClientRegionSupportEnabled := Value
        }
        IsPasswordAutosaveEnabled { ;Boolean => Determines whether password information will be autosaved
            get => this.Settings.IsPasswordAutosaveEnabled
            set => this.Settings.IsPasswordAutosaveEnabled := Value
        }
        IsPinchZoomEnabled { ;Boolean => Determines the ability of the end users to use pinching motions on touch input enabled devices to scale the web content in the WebView2
            get => this.Settings.IsPinchZoomEnabled
            set => this.Settings.IsPinchZoomEnabled := Value
        }
        IsReputationCheckingRequired { ;Boolean => Determines whether SmartScreen is enabled when visiting web pages
            get => this.Settings.IsReputationCheckingRequired
            set => this.Settings.IsReputationCheckingRequired := Value
        }
        IsScriptEnabled { ;Boolean => Determines whether running JavaScript is enabled in all future navigations in the WebView
            get => this.Settings.IsScriptEnabled
            set => this.Settings.IsScriptEnabled := Value
        }
        IsStatusBarEnabled { ;Boolean => Determines whether the status bar is displayed
            get => this.Settings.IsStatusBarEnabled
            set => this.Settings.IsStatusBarEnabled := Value
        }
        IsSwipeNavigationEnabled { ;Boolean => Determines whether the end user to use swiping gesture on touch input enabled devices to navigate in WebView2
            get => this.Settings.IsSwipeNavigationEnabled
            set => this.Settings.IsSwipeNavigationEnabled := Value
        }
        IsWebMessageEnabled { ;Boolean => Determines whether communication from the host to the top-level HTML document of the WebView is allowed
            get => this.Settings.IsWebMessageEnabled
            set => this.Settings.IsWebMessageEnabled := Value
        }
        IsZoomControlEnabled { ;Boolean => Determines whether the user is able to impact the zoom of the WebView
            get => this.Settings.IsZoomControlEnabled
            set => this.Settings.IsZoomControlEnabled := Value
        }
        UserAgent { ;String => Determines WebView2's User Agent
            get => this.Settings.UserAgent
            set => this.Settings.UserAgent := Value
        }

    Source => this.wv.Source ;Returns Uri of current page
    NavigateToString(HtmlContent) => this.wv.NavigateToString(HtmlContent) ;Navigate to text (essentially create a webpage from a string)
    AddScriptToExecuteOnDocumentCreatedAsync(JavaScript) => this.wv.AddScriptToExecuteOnDocumentCreatedAsync(JavaScript) ;Adds JavaScript to run when the DOM is created
    AddScriptToExecuteOnDocumentCreated(JavaScript) {
        AddScriptToExecuteOnDocumentCreatedPromise := this.wv.AddScriptToExecuteOnDocumentCreatedAsync(JavaScript)
        AddScriptToExecuteOnDocumentCreatedPromise.await()
        return Trim(AddScriptToExecuteOnDocumentCreatedPromise.Result, "`"")
    }
    RemoveScriptToExecuteOnDocumentCreated(Id) => this.wv.RemoveScriptToExecuteOnDocumentCreated(Id)
    ExecuteScriptAsync(JavaScript) => this.wv.ExecuteScriptAsync(JavaScript) ;Execute code on the current Webpage
    ExecuteScript(JavaScript, Timeout := -1) {
        ExecuteScriptPromise := this.wv.ExecuteScriptAsync(JavaScript)
        try {
            ExecuteScriptPromise.await(Timeout)
        } catch {
            ExecuteScriptPromise.Result := "Timeout Error"
        }
        return Trim(ExecuteScriptPromise.Result, "`"")
    }
    CapturePreviewAsync(ImageFormat, ImageStream) => this.wv.CapturePreviewAsync(ImageFormat, ImageStream) ;Take a "screenshot" of the current WebView2 content
    CapturePreview(ImageFormat, ImageStream) {
        CapturePreviewPromise := this.wv.CapturePreviewAsync(ImageFormat, ImageStream)
        CapturePreviewPromise.await()
        return CapturePreviewPromise.Result
    }
    Reload() => this.wv.Reload() ;Reloads the current page

    /**
     * In order to use PostWebMessageAsJson() or PostWebMessageAsString(), you'll need to setup your webpage to listen to messages
     * First, MyWindow.Settings.IsWebMessageEnabled must be set to true
     * On your webpage itself, you'll need to setup an EventListner and Handler for the WebMessages
     *     window.chrome.webview.addEventListener('message', ahkWebMessage);
     *     function ahkWebMessage(Msg) {
     *         console.log(Msg);
     *     }
    **/
    PostWebMessageAsJson(WebMessageAsJson) => this.wv.PostWebMessageAsJson(WebMessageAsJson) ;Posts the specified JSON message to the top level document in this WebView
    PostWebMessageAsString(WebMessageAsString) => this.wv.PostWebMessageAsString(WebMessageAsString) ;Posts the specified STRING message to the top level document in this WebView
    CallDevToolsProtocolMethodAsync(MethodName, ParametersAsJson) => this.wv.CallDevToolsProtocolMethodAsync(MethodName, ParametersAsJson) ;Runs an DevToolsProtocol method

    /**
     * @returns {Boolean} The process ID of the browser process that hosts the WebView2.
     * @see {@link https://learn.microsoft.com/en-us/dotnet/api/microsoft.web.webview2.core.corewebview2.browserprocessid|BrowserProcessId}
     */
    BrowserProcessId => this.wv.BrowserProcessId ;Returns the process ID of the browser process that hosts the WebView2

    CanGoBack => this.wv.CanGoBack ;Returns true if the WebView is able to navigate to a previous page in the navigation history
    CanGoForward => this.wv.CanGoForward ;Returns true if the WebView is able to navigate to a next page in the navigation history

    /**
     * Navigates the WebView to the previous page in the navigation history.
     * @see {@link https://learn.microsoft.com/en-us/dotnet/api/microsoft.web.webview2.core.corewebview2.goback|GoBack}
     */
    GoBack() => this.wv.GoBack() ;GoBack to the previous page in the navigation history
    GoForward() => this.wv.GoForward() ;GoForward to the next page in the navigation history
    GetDevToolsProtocolEventReceiver(EventName) => this.wv.GetDevToolsProtocolEventReceiver(EventName) ;Gets a DevTools Protocol event receiver that allows you to subscribe to a DevToolsProtocol event
    Stop() => this.wv.Stop() ;Stops all navigations and pending resource fetches
    DocumentTitle => this.wv.DocumentTitle ;Returns the DocumentTitle of the current webpage
    AddHostObjectToScript(ObjName, Obj) => this.wv.AddHostObjectToScript(ObjName, Obj) ;Create object link between the WebView2 and the AHK Script
    RemoveHostObjectFromScript(ObjName) => this.wv.RemoveHostObjectFromScript(ObjName) ;Delete object link from the WebView2
    OpenDevToolsWindow() => this.wv.OpenDevToolsWindow() ;Opens DevTools for the current WebView2
    ContainsFullScreenElement => this.wv.ContainsFullScreenElement ;Returns true if the WebView contains a fullscreen HTML element
    AddWebResourceRequestedFilter(Uri, ResourceContext) => this.wv.AddWebResourceRequestedFilter(Uri, ResourceContext) ;Adds a URI and resource context filter for the WebResourceRequested event
    RemoveWebResourceRequestedFilter(Uri, ResourceContext) => this.wv.RemoveWebResourceRequestedFilter(Uri, ResourceContext) ;Removes a matching WebResource filter that was previously added for the WebResourceRequested event
    NavigateWithWebResourceRequest(Request) => this.wv.NavigateWithWebResourceRequest(Request) ;Navigates using a constructed CoreWebView2WebResourceRequest object
    CookieManager => this.wv.CookieManager ;Gets the CoreWebView2CookieManager object associated with this CoreWebView2
        GetCookiesAsync(Uri) => this.CookieManager.GetCookies(Uri) ;Gets a list of cookies matching the specific URI

    Environment => this.wv.Environment ;Returns Map() of Environment settings
        CreateCoreWebView2ControllerAsync(ParentWindow) => this.Environment.CreateWebView2ControllerAsync(ParentWindow)
        CreateWebResourceResponse(Content, StatusCode, ReasonPhrase, Headers) => this.Environment.CreateWebResourceResponse(Content, StatusCode, ReasonPhrase, Headers)
        BrowserVersionString => this.Environment.BrowserVersionString ;Returns the browser version info of the current CoreWebView2Environment, including channel name if it is not the stable channel
        FailureReportFolderPath => this.Environment.FailureReportFolderPath ;Returns the failure report folder that all CoreWebView2s created from this environment are using
        UserDataFolder => this.Environment.UserDataFolder ;Returns the user data folder that all CoreWebView2s created from this environment are using
        CreateWebResourceRequest(Uri, Method, PostData, Headers) => this.Environment.CreateWebResourceRequest(Uri, Method, PostData, Headers) ;Creates a new CoreWebView2WebResourceRequest object
        CreateCoreWebView2CompositionControllerAsync(ParentWindow) => this.Environment.CreateCoreWebView2CompositionControllerAsync(ParentWindow) ;Creates a new WebView for use with visual hosting
        CreateCoreWebView2PointerInfo() => this.Environment.CreateCoreWebView2PointerInfo() ;Returns Map() of a combined win32 POINTER_INFO, POINTER_TOUCH_INFO, and POINTER_PEN_INFO object
        GetAutomationProviderForWindow(Hwnd) => this.Environment.GetAutomationProviderForWindow(Hwnd) ;PRODUCES ERROR, REACH OUT TO THQBY
        CreatePrintSettings() => this.Environment.CreatePrintSettings() ;Creates the CoreWebView2PrintSettings used by the PrintToPdfAsync(String, CoreWebView2PrintSettings) method
        GetProcessInfos() => this.Environment.GetProcessInfos() ;Returns the list of all CoreWebView2ProcessInfo using same user data folder except for crashpad process
        CreateContextMenuItem(Label, IconStream, Kind) => this.Environment.CreateContextMenuItem(Label, IconStream, Kind) ;PRODUCES ERROR, REACH OUT TO THQBY
        CreateCoreWebView2ControllerOptions() => this.Environment.CreateCoreWebView2ControllerOptions() ;PRODUCES ERROR, REACH OUT TO THQBY
        CreateCoreWebView2ControllerWithOptionsAsync(ParentWindow, Options) => this.Environment.CreateCoreWebView2ControllerWithOptionsAsync(ParentWindow, Options) ;PRODUCES ERROR, REACH OUT TO THQBY -- I think the issue is part of the `CreateCoreWEbView2ControllerOptions()` method
        CreateCoreWebView2CompositionControllerWithOptionsAsync(ParentWindow, Options) => this.Environment.CreateCoreWebView2CompositionControllerWithOptionsAsync(ParentWindow, Options) ;PRODUCES ERROR, REACH OUT TO THQBY -- I think the issue is part of the `CreateCoreWEbView2ControllerOptions()` method
        CreateSharedBuffer(Size) => this.Environment.CreateSharedBuffer(Size) ;Create a shared memory based buffer with the specified size in bytes -- PRODUCES ERROR, REACH OUT TO THQBY

    TrySuspendAsync() => this.wv.TrySuspendAsync() ;Must set `IsVisible := 0` before trying to call
    Resume() => this.wv.Resume() ;Resumes the WebView so that it resumes activities on the web page. Will fail unless you set `IsVisible := 1`
    IsSuspended => this.wv.IsSuspended ;Returns true if the WebView is suspended
    SetVirtualHostNameToFolderMapping(HostName, FolderPath, AccessKind) => this.wv.SetVirtualHostNameToFolderMapping(HostName, FolderPath, AccessKind) ;Sets a mapping between a virtual host name and a folder path to make available to web sites via that host name
    ClearVirtualHostNameToFolderMapping(HostName) => this.wv.ClearVirtualHostNameToFolderMapping(HostName) ;Clears a host name mapping for local folder that was added by SetVirtualHostNameToFolderMapping()
    OpenTaskManagerWindow() => this.wv.OpenTaskManagerWindow() ;Opens the Browser Task Manager view as a new window in the foreground
    IsMuted { ;Indicates whether all audio output from this CoreWebView2 is muted or not. Set to true will mute this CoreWebView2, and set to false will unmute this CoreWebView2. true if audio is muted
        get => this.wv.IsMuted
        set => this.wv.IsMuted := Value
    }
    IsDocumentPlayingAudio => this.wv.IsDocumentPlayingAudio ;Returns true if audio is playing even if IsMuted is true
    IsDefaultDownloadDialogOpen => this.wv.IsDefaultDownloadDialogOpen ;Returns true if the default download dialog is currently open
    OpenDefaultDownloadDialog() => this.wv.OpenDefaultDownloadDialog() ;Opens the DownloadDialog Popup Window
    CloseDefaultDownloadDialog() => this.wv.CloseDefaultDownloadDialog() ;Closes the DownloadDialog Popup Window
    DefaultDownloadDialogCornerAlignment { ;Position of DownloadDialog does not update until after the WebView2 position or size has changed
        get => this.wv.DefaultDownloadDialogCornerAlignment ;Return the current corner the DownloadDialog will show up in (0 := TopLeft, 1 := TopRight, 2 := BottomLeft, 3 := BottomRight)
        set => this.wv.DefaultDownloadDialogCornerAlignment := Value ;Set the corner of the WebView2 that the DownloadDialog will show up in (0 := TopLeft, 1 := TopRight, 2 := BottomLeft, 3 := BottomRight)
    }
    DefaultDownloadDialogMargin { ;Working, but I don't know how to accurately assign a new Margin yet. We can assign one via an Integer, but it's hit and miss to get the position correct
        get => this.wv.DefaultDownloadDialogMargin
        set => this.wv.DefaultDownloadDialogMargin := Value
    }
    CallDevToolsProtocolMethodForSessionAsync(SessionId, MethodName, ParametersAsJson) => this.wv.CallDevToolsProtocolMethodForSessionAsync(SessionId, MethodName, ParametersAsJson) ;Runs a DevToolsProtocol method for a specific session of an attached target
    StatusBarText => this.wv.StatusBarText ;Returns the current text of the WebView2 StatusBar
    Profile => this.wv.Profile ;Returns the associated CoreWebView2Profile object of CoreWebView2
    ClearServerCertificateErrorActionsAsync() => this.wv.ClearServerCertificateErrorActionsAsync()
    FaviconUri => this.wv.FaviconUri ;Returns the Uri as a string of the current Favicon. This will be an empty string if the page does not have a Favicon
    GetFaviconAsync(Format) => this.wv.GetFaviconAsync(Format) ;Get the downloaded Favicon image for the current page and copy it to the image stream
    PrintAsync(PrintSettings) => this.wv.PrintAsync(PrintSettings) ;Print the current web page asynchronously to the specified printer with the provided settings
    PrintToPdfAsync(ResultFilePath, PrintSettings) => this.wv.PrintToPdfAsync(ResultFilePath, PrintSettings) ;Print the current page to PDF with the provided settings
    ShowPrintUI(PrintDialogKind) => this.wv.ShowPrintUI(PrintDialogKind) ;Opens the print dialog to print the current web page. Browser printDialogKind := 0, System printDialogKind := 1
    PrintToPdfStreamAsync(PrintSettings) => this.wv.PrintToPdfStreamAsync(PrintSettings) ;Provides the PDF data of current web page for the provided settings to a Stream
    PostSharedBufferToScript(SharedBuffer, Access, AdditionalDataAsJson) => this.wv.PostSharedBufferToScript(SharedBuffer, Access, AdditionalDataAsJson) ;Share a shared buffer object with script of the main frame in the WebView
    MemoryUsageTargetLevel { ;0 = Normal, 1 = Low; Low can be used for apps that are inactive to conserve memory usage
        get => this.wv.MemoryUsageTargetLevel
        set => this.wv.MemoryUsageTargetLevel := Value
    }

    ;-------------------------------------------------------------------------------------------
    ;Handler Assignments
    static PlaceholderHandler(Handler, ICoreWebView2, Args) {
        ;MsgBox(handler, "WebviewWindow.PlaceholderHandler()", "262144")
    }

    ;Controller
    ZoomFactorChanged(Handler) => this.wvc.add_ZoomFactorChanged(Handler)
    MoveFocusRequested(Handler) => this.wvc.add_MoveFocusRequested(Handler)
    GotFocus(Handler) => this.wvc.add_GotFocus(Handler)
    LostFocus(Handler) => this.wvc.add_LostFocus(Handler)
    AcceleratorKeyPressed(Handler) => this.wvc.add_AcceleratorKeyPressed(Handler)
    RasterizationScaleChanged(Handler) => this.wvc.add_RasterizationScaleChanged(Handler)

    ;Core
    NavigationStarting(Handler) => this.wv.add_NavigationStarting(Handler)
    ContentLoading(Handler) => this.wv.add_ContentLoading(Handler)
    SourceChanged(Handler) => this.wv.add_SourceChanged(Handler)
    HistoryChanged(Handler) => this.wv.add_HistoryChanged(Handler)
    NavigationCompleted(Handler) => this.wv.add_NavigationCompleted(Handler)
    ScriptDialogOpening(Handler) => this.wv.add_ScriptDialogOpening(Handler)
    PermissionRequested(Handler) => this.wv.add_PermissionRequested(Handler)
    ProcessFailed(Handler) => this.wv.add_ProcessFailed(Handler)
    WebMessageReceived(Handler) => this.wv.add_WebMessageReceived(Handler)
    NewWindowRequested(Handler) => this.wv.add_NewWindowRequested(Handler)
    DocumentTitleChanged(Handler) => this.wv.add_DocumentTitleChanged(Handler)
    ContainsFullScreenElementChanged(Handler) => this.wv.add_ContainsFullScreenElementChanged(Handler)
    WebResourceRequested(Handler) => this.wv.add_WebResourceRequested(Handler)
    WindowCloseRequested(Handler) => this.wv.add_WindowCloseRequested(Handler)
    WebResourceResponseReceived(Handler) => this.wv.add_WebResourceResponseReceived(Handler)
    DOMContentLoaded(Handler) => this.wv.add_DOMContentLoaded(Handler)
    FrameCreated(Handler) => this.wv.add_FrameCreated(Handler)
    DownloadStarting(Handler) => this.wv.add_ownloadStarting(Handler)
    ClientCertificateRequested(Handler) => this.wv.add_ClientCertificateRequested(Handler)
    IsMutedChanged(Handler) => this.wv.add_IsMutedChanged(Handler)
    IsDocumentPlayingAudioChanged(Handler) => this.wv.add_IsDocumentPlayingAudioChanged(Handler)
    IsDefaultDownloadDialogOpenChanged(Handler) => this.wv.add_IsDefaultDownloadDialogOpenChanged(Handler)
    BasicAuthenticationRequested(Handler) => this.wv.add_BasicAuthenticationRequested(Handler)
    ContextMenuRequested(Handler) => this.wv.add_ContextMenuRequested(Handler)
    StatusBarTextChanged(Handler) => this.wv.add_StatusBarTextChanged(Handler)
    ServerCertificateErrorDetected(Handler) => this.wv.add_ServerCertificateErrorDetected(Handler)
    FaviconChanged(Handler) => this.wv.add_FaviconChanged(Handler)
    LaunchingExternalUriScheme(Handler) => this.wv.add_LaunchingExternalUriScheme(Handler)
}
