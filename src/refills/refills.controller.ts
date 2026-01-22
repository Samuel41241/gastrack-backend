import {
  Body,
  Controller,
  Post,
  Get,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';

import { RefillsService } from './refills.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateRefillDto } from './dto/create-refills.dto';

@ApiTags('Refills')
@ApiBearerAuth('JWT-auth')
@UseGuards(JwtAuthGuard)
@Controller('refills')
export class RefillsController {
  constructor(private readonly service: RefillsService) {}

  @Post()
  create(@Req() req: any, @Body() dto: CreateRefillDto) {
    return this.service.create(req.user.id, dto);
  }

  @Get()
  findMyRefills(@Req() req: any) {
    return this.service.findAllByUser(req.user.id);
  }
}
