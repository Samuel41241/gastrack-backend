import {
  Controller,
  Post,
  Get,
  Patch,
  Delete,
  Body,
  UseGuards,
  Req,
  Param,
} from '@nestjs/common';
import { VendorsService } from './vendors.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CreateVendorDto } from './dto/create-vendor.dto';

@Controller('vendors')
@UseGuards(JwtAuthGuard)
export class VendorsController {
  constructor(private readonly vendorsService: VendorsService) {}

  // ✅ Any authenticated user
  @Get()
  findAll(@Req() req) {
    return this.vendorsService.findAll(req.user.id);
  }

  // 🔐 ADMIN only — create vendor
  @Post()
  @UseGuards(RolesGuard)
  @Roles('ADMIN')
  create(@Req() req, @Body() dto: CreateVendorDto) {
    return this.vendorsService.create(req.user.id, dto);
  }

  // 🔐 ADMIN only — update vendor
  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles('ADMIN')
  update(@Param('id') id: string, @Body() dto: Partial<CreateVendorDto>) {
    return this.vendorsService.update(id, dto);
  }

  // 🔐 ADMIN only — delete vendor
  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles('ADMIN')
  remove(@Param('id') id: string) {
    return this.vendorsService.remove(id);
  }
}
