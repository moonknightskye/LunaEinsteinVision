//
//  Command.swift
//  Luna
//
//  Created by Mart Civil on 2017/03/01.
//  Copyright © 2017年 salesforce.com. All rights reserved.
//

import Foundation

enum CommandStatus:Int {
    case RESOLVE    = 1
    case REJECT     = 0
    case UPDATE     = 2
}
enum CommandCode:Int {
    case UNDEFINED                  = -1
    case NEW_WEB_VIEW               = 0
    case LOAD_WEB_VIEW              = 1
    case ANIMATE_WEB_VIEW           = 2
    case WEB_VIEW_ONLOAD            = 3
    case WEB_VIEW_ONLOADED          = 4
    case WEB_VIEW_ONLOADING         = 5
    case CLOSE_WEB_VIEW             = 6
    case TAKE_PHOTO                 = 7
    case GET_FILE                   = 8
    case GET_HTML_FILE              = 9
    case GET_IMAGE_FILE				= 10
    case GET_EXIF_IMAGE             = 11
    case GET_BASE64_BINARY          = 12
    case GET_BASE64_RESIZED         = 13
    case GET_VIDEO_BASE64_BINARY    = 14
    case GET_VIDEO                  = 15
    case NEW_AV_PLAYER              = 16
    case APPEND_AV_PLAYER           = 17
    case AV_PLAYER_PLAY             = 18
    case AV_PLAYER_PAUSE            = 19
    case AV_PLAYER_SEEK             = 20
    case TAKE_VIDEO                 = 21
    case MEDIA_PICKER               = 22
    case CHANGE_ICON                = 23
    case GET_VIDEO_FILE             = 24
	case DOWNLOAD					= 25
    case GET_ZIP_FILE               = 26
    case ONDOWNLOAD                 = 27
    case ONDOWNLOADED               = 28
    case ONDOWNLOADING              = 29
    case MOVE_FILE                  = 30
    case RENAME_FILE                = 31
    case COPY_FILE                  = 32
    case DELETE_FILE                = 33
    case UNZIP                      = 34
    case ON_UNZIP                   = 35
    case ON_UNZIPPING               = 36
    case ON_UNZIPPED                = 37
    case GET_FILE_COL               = 38
	case SHARE_FILE					= 39
    case ZIP                        = 40
    case ON_ZIP                     = 41
    case ON_ZIPPING                 = 42
    case ON_ZIPPED                  = 43
	case CODE_READER				= 44
    case GET_AV_CAPTURE             = 45
    case APPEND_AV_CAPTURE          = 46
    case AV_CAPTURE_CONTROL         = 47
    case AV_CAPTURE_SCANCODE        = 48
    case AV_CAPTURE_SHOOT_IMAGE     = 49
    case SHAKE_BEGIN                = 50
    case SHAKE_END                  = 51
    case REMOVE_EVENT_LISTENER      = 52
    case OPEN_WITH_SAFARI           = 53
    case USER_SETTINGS              = 54
    case USER_SETTINGS_STARTUP_HTML = 55
//    case USER_SETTINGS_ADD          = 56
    case USER_SETTINGS_DELETE       = 57
    case USER_SETTINGS_SET          = 58
    case USER_SETTINGS_GET          = 59
    case SCREEN_EDGE_SWIPED         = 60
    case WEB_VIEW_RECIEVEMESSAGE    = 61
    case WEB_VIEW_POSTMESSAGE       = 62
    case USER_SETTINGS_LUNASETTINGS_HTML = 63
    case USER_NOTIFICATION          = 64
    case USER_NOTIFICATION_SHOWMSG  = 65
    case HTTP_POST                  = 66
	case AVAUDIO_RECORDER_INIT		= 67
	case AVAUDIO_RECORDER_RECORD	= 68
	case AVAUDIO_RECORDER_STOP		= 69
	case AUDIO_CONVERT_WAV			= 70
    case AVAUDIO_RECORDER_RECORDING = 71
	case SYSTEM_SETTINGS			= 72
	case SYSTEM_SETTINGS_SET		= 73
    case SF_SERVICESOS_INIT         = 74
    case SF_SERVICESOS_START        = 75
    case SF_SERVICESOS_STATECHANGE  = 76
    case SF_SERVICESOS_DIDSTOP      = 77
    case SF_SERVICESOS_DIDCONNECT   = 78
	case SF_SERVICESOS_STOP			= 79
    case SF_SERVICELIVEA_INIT       = 80
    case SF_SERVICELIVEA_START      = 81
    case LOGACCESS                  = 82
    case SF_SERVICELIVEA_ADDPREOBJ  = 83
    case SF_SERVICELIVEA_CLEARPREOBJ = 84
    case SF_SERVICELIVEA_STATECHANGE = 85
    case SF_SERVICELIVEA_DIDEND     = 86
    case SF_SERVICELIVEA_CHECKAVAIL = 87
    case BEACON_TRANSMIT            = 88
    case BEACON_STOP                = 89
    case BEACON_DIDUPDATE           = 90
    case BEACON_STARTMONITORING     = 91
    case BEACON_ONRANGE             = 92
    case BEACON_STARTRANGINGBEACON  = 93
    case BEACON_INIT                = 94
    case BEACON_ONMONITOR           = 95
    case BEACON_STOPRANGINGBEACON   = 96
    case BEACON_STOPMONITORINGBEACON = 97
    case BEACON_STOPALLSCAN         = 98
    case BEACON_GETBEACONS          = 99
    case TOGGLE_AUTOSLEEP           = 100
    case TOGGLE_STATUSBAR           = 101
    case HAPTIC_INIT                = 102
    case HAPTIC_FEEDBACK            = 103
    case NFC_INIT                   = 104
    case NFC_SCAN                   = 105
    case NFC_ONERROR                = 106
    case HOTSPOT_INIT               = 107
    case HOTSPOT_CONNECT            = 108
    case HOTSPOT_DISCONNECT         = 109
    case EINSTEIN_VISION_INIT       = 110
    case EINSTEIN_VISION_PREDICT    = 111
    case GENERATE_PDF417_BARCODE    = 112
    case BETA_SHOWEINSTEIN_AR       = 113
    case OPEN_APP_SETTINGS          = 114
    case EINSTEIN_VISION_DATASETS   = 115
    case EINSTEIN_VISION_MODELS     = 116
}
let FIX_VERSION = 0.1
let APP_VERSION = Double(CommandCode.EINSTEIN_VISION_MODELS.rawValue) + FIX_VERSION

enum CommandPriority:Int {
    case CRITICAL                   = 0         //sync Instant execution
    case HIGH                       = 1         //async instantenious (animations, ui change)
    case NORMAL                     = 2         //async few seconds (ui events)
    case LOW                        = 3         //async download, save data
    case BACKGROUND                 = 4         //async backups/sync
}

class Command {
    
    private static var command_id_counter = 0

    private var commandID:Int = -1
    private var sourceGlobalID:String = ""
    private var commandCode:CommandCode = CommandCode.UNDEFINED
    private var priority:CommandPriority = .NORMAL
    private var sourceWebViewID:Int = -1
    private var targetWebViewID:Int = -1
    private var callbackMethod:String = "fallback"
    private var parameter:Any!
    private var onResolveFn:((Any)->Void)?
    private var onUpdateFn:((Any)->Void)?
    private var onRejectFn:((String)->Void)?
    
    public init( command: NSObject ) {
        print( command )
        
        setCommandID( commandID: command.value(forKey: "command_id") as! Int )
        setSourceGlobalID(sourceGlobalID: command.value(forKey: "source_global_id") as! String)
        setCommandCode( commandCode: command.value(forKey: "command_code") as! Int )
        setPriority( priority: CommandPriority(rawValue: command.value(forKey: "priority") as! Int)! )
        setSourceWebViewID( sourceWebViewID: command.value(forKey: "source_webview_id") as! Int )
        setTargetWebViewID( targetWebViewID: command.value(forKey: "target_webview_id") as! Int )
        setParameter( parameter: command.value(forKey: "parameter") as! NSObject )
        setCallbackMethod( callbackMethod: command.value(forKey: "callback_method") as! String )
    }

    public init( commandCode:CommandCode, targetWebViewID:Int?=nil, parameter:NSObject?=nil, priority:CommandPriority?=CommandPriority.NORMAL) {
        print(commandCode)
        print(parameter ?? "[NO PARAMETER]")
        Command.command_id_counter += 1
        setCommandID( commandID: Command.command_id_counter )
        setCommandCode( commandCode: commandCode )
        setSourceWebViewID(sourceWebViewID: WebViewManager.SYSTEM_WEBVIEW)
        setPriority(priority: priority!)
        if targetWebViewID != nil {
            setTargetWebViewID( targetWebViewID: targetWebViewID! )
        } else {
            setTargetWebViewID( targetWebViewID: WebViewManager.SYSTEM_WEBVIEW )
        }
        if parameter != nil {
            setParameter( parameter:parameter! )
        }
    }
    
    
    func setPriority( priority: CommandPriority ) {
        self.priority = priority
    }
    func getPriority() -> CommandPriority {
        return self.priority
    }
    
    public func resolve( value:Any?=true, raw:Any?=nil ) {
        respond( status:CommandStatus.RESOLVE, value: value! )
        
        if self.onResolveFn != nil {
            if raw != nil {
                self.onResolveFn!( raw! )
            } else {
                self.onResolveFn!( value! )
            }
        }
    }
    
    public func reject( errorMessage:String?="Rejected command" ) {
        respond( status:CommandStatus.REJECT, value: errorMessage! )
        
        if self.onRejectFn != nil {
            self.onRejectFn!( errorMessage! )
        }
    }
    
    public func update( value:Any?=true ) {
        if self.onUpdateFn != nil {
            self.onUpdateFn!( value! )
        }
        respond( status:CommandStatus.UPDATE, value: value! )
    }
    
    private func respond( status:CommandStatus, value:Any ) {
        if let sourceWebView = getSourceWebView() {
            let params = NSMutableDictionary();
            params.setValue(getCommandID(), forKey: "command_id")
            params.setValue(getSourceGlobalID(), forKey: "source_global_id")
            params.setValue(getCommandCode().rawValue, forKey: "command_code")
            
            let result = NSMutableDictionary();
            result.setValue( status.rawValue, forKey: "status" )
            if status == CommandStatus.RESOLVE || status == CommandStatus.UPDATE {
                result.setValue( value, forKey: "value" )
            } else if status == CommandStatus.REJECT {
                //result.setValue( (value as! String).replacingOccurrences(of: "\'", with: ""), forKey: "message" )
                result.setValue( value, forKey: "message" )
            }
            params.setValue( result, forKey: "result" )
            sourceWebView.getWebview().runJSCommand(commandName: getCallbackMethod(), params: params, onComplete: { result, error in
                if status != CommandStatus.UPDATE {
                    CommandProcessor.remove(command: self)
                }
            })
        } else {            
            print( "[WARN] No webview to send response" );
			if( status != CommandStatus.UPDATE ) {
				CommandProcessor.remove(command: self)
			}
		}
    }
    
    private func setCommandID( commandID: Int ) {
        self.commandID = commandID
    }
    func getCommandID() -> Int {
        return self.commandID
    }
    
    private func setSourceWebViewID( sourceWebViewID: Int ) {
        self.sourceWebViewID = sourceWebViewID
    }
    func getSourceWebViewID() -> Int {
        return self.sourceWebViewID
    }
    
    private func setCommandCode( commandCode: CommandCode ) {
        self.commandCode = commandCode
    }
    private func setCommandCode( commandCode: Int ) {
        if let code = CommandCode(rawValue: commandCode) {
            self.commandCode = code
        }
    }
    func getCommandCode() -> CommandCode {
        return self.commandCode
    }
    
    func getSourceWebView() -> WebViewManager? {
        return WebViewManager.getManager( webview_id: getSourceWebViewID() )
    }
    
    private func setSourceGlobalID( sourceGlobalID: String ) {
        self.sourceGlobalID = sourceGlobalID
    }
    func getSourceGlobalID() -> String {
        return self.sourceGlobalID
    }
    
    private func setTargetWebViewID( targetWebViewID: Int ) {
        self.targetWebViewID = targetWebViewID
    }
    func getTargetWebViewID() -> Int {
        return self.targetWebViewID
    }
    
    private func setParameter( parameter: Any ) {
        self.parameter = parameter
    }
    func getParameter() -> Any {
        return self.parameter
    }
    
    private func setCallbackMethod( callbackMethod: String ) {
        self.callbackMethod = callbackMethod
    }
    func getCallbackMethod() -> String {
        return self.callbackMethod
    }
    
    public func onResolve( fn: @escaping ((Any)->Void) ) {
        self.onResolveFn = fn
    }
    public func onUpdate( fn: @escaping ((Any)->Void) ) {
        self.onUpdateFn = fn
    }
    public func onReject( fn: @escaping ((String)->Void) ) {
        self.onRejectFn = fn
    }
}
