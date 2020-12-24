declare module '@capacitor/core' {
  interface PluginRegistry {
    FileLogger: FileLoggerPlugin;
  }
}

export interface FileLoggerPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
