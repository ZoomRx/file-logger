import Foundation
import Capacitor
import CocoaLumberjack

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FileLogger)
public class FileLogger: CAPPlugin {
    
    /// This inits the logger with default configuration
    @objc public override func load() {
        let directory = String(format: "%@/NoCloud/logs", NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last ?? "")
        let logFileManager = DDLogFileManagerDefault(logsDirectory: directory)
        let fileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.maximumFileSize = 1024 * 512;
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
        DDLog.add(fileLogger, with: .verbose)
        DDLog.add(DDOSLogger.sharedInstance as DDLogger, with: .all) // For xcode console
    }
    
    /// This method is used to log the given data into a file. This will be called from HTML
    /// - Parameter call: Keys - {message: String, level: String, data: [String:Any]}
    @objc func log(_ call: CAPPluginCall) {
        guard let message = call.getString("message") else {
            call.reject("Message key is required a logging")
            return
        }
        
        let level = call.getString("level") ?? "verbose"
        let data = call.getObject("data")
        FileLogger.log(level: level, message: message, data: data)
        #if DEBUG
        //In debug mode, The data can also be logged in console.
        //This can be useful for hybrid during development.
        var dataString = ""
        if let logData = data,
            let jsonData = try? JSONSerialization.data(withJSONObject: logData, options: []),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            dataString = jsonString
        }
        self.bridge.eval(js: "console.log(\"\(message)\", \(dataString))")
        #endif
        call.resolve()
    }
    
    /// This method returns the log file directory. This will be used by HTML for getting the log directory so that they can use them to upload those files
    /// - Parameter call: Keys - {}
    @objc func getLogDirectory(_ call: CAPPluginCall) {
        if let fileLogger = DDLog.allLoggers.filter({ (logger) -> Bool in
            logger is DDFileLogger
        }).first as? DDFileLogger {
            call.resolve([
                "path" : URL(fileURLWithPath: fileLogger.logFileManager.logsDirectory).absoluteString
            ])
            return
        }
        
        call.reject("No log directory found")
    }
    
    /// Static method to facilate native loggin
    /// - Parameters:
    ///   - level: The log level
    ///   - message: The log message
    ///   - data: The log data
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
