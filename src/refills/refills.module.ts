import { Module } from '@nestjs/common';
import { RefillsService } from './refills.service';
import { RefillsController } from './refills.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [RefillsController],
  providers: [RefillsService],
})
export class RefillsModule {}
