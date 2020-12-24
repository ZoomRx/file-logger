import Foundation
import Capacitor
import CocoaLumberjack

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FileLogger)
public class FileLogger: CAPPlugin {
    
    @objc public override func load() {
        let directory = String(format: "%@/NoCloud/logs", NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last ?? "")
        let logFileManager = DDLogFileManagerDefault(logsDirectory: directory)
        let fileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.maximumFileSize = 1024 * 512;
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
        DDLog.add(fileLogger, with: .verbose)
        DDLog.add(DDOSLogger.sharedInstance as DDLogger, with: .all) // For xcode console
    }
    
    @objc func log(_ call: CAPPluginCall) {
        guard let message = call.getString("message") else {
            call.reject("Message key is required a logging")
            return
        }
        
        let level = call.getString("level") ?? "verbose"
        let data = call.getObject("data")
        FileLogger.log(level: level, message: message, data: data)
        call.success()
    }
    
    public static func log(level: String?, message: String, data: [String:Any]?) {
        let logData = data ?? [:]
        switch level {
        case "error":
            DDLogError("\(message) - \(logData)")
        case "warning":
            DDLogWarn("\(message) - \(logData)")
        case "info":
            DDLogInfo("\(message) - \(logData)")
        case "debug":
            DDLogDebug("\(message) - \(logData)")
        default:
            DDLogVerbose("\(message) - \(logData)")
        }
    }
}
