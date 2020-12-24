declare module '@capacitor/core' {
  interface PluginRegistry {
    FileLogger: FileLoggerPlugin;
  }
}

export interface FileLoggerPlugin {
  log(options: { level: string, message: string, data: object }): Promise<void>;
}
