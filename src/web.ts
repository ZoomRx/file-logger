import { WebPlugin } from '@capacitor/core';
import { FileLoggerPlugin } from './definitions';

export class FileLoggerWeb extends WebPlugin implements FileLoggerPlugin {
  constructor() {
    super({
      name: 'FileLogger',
      platforms: ['web'],
    });
  }

  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}

const FileLogger = new FileLoggerWeb();

export { FileLogger };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(FileLogger);
