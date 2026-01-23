import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleDestroy
{
  constructor() {
    super({
      log:
        process.env.NODE_ENV === 'development'
          ? ['query', 'error', 'warn']
          : ['error'],
    });
  }

  /**
   * Prisma should NOT force a connection on startup.
   * It will connect lazily when the first query runs.
   */

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
