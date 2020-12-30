import { WebPlugin } from '@capacitor/core';
import { FileLoggerPlugin } from './definitions';

export class FileLoggerWeb extends WebPlugin implements FileLoggerPlugin {
  constructor() {
    super({
      name: 'FileLogger',
      platforms: ['web'],
    });
  }

  async log(options: { level: string, message: string, data: object }): Promise<void> {
    console.log(options);
  }

  async getLogDirectory(): Promise<{ path: string }> {
    return new Promise((_resolve, reject) => reject);
  }
}

const FileLogger = new FileLoggerWeb();

export { FileLogger };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(FileLogger);
