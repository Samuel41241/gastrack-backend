import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateVendorDto } from './dto/create-vendor.dto';

@Injectable()
export class VendorsService {
  constructor(private prisma: PrismaService) {}

  // ✅ Create vendor (ADMIN only via controller)
  create(userId: string, dto: CreateVendorDto) {
    return this.prisma.vendor.create({
      data: {
        ...dto,
        userId,
      },
    });
  }

  // ✅ List vendors (scoped to user)
  findAll(userId: string) {
    return this.prisma.vendor.findMany({
      where: { userId },
    });
  }

  // 🔐 Update vendor (ADMIN only)
  async update(id: string, dto: Partial<CreateVendorDto>) {
    const vendor = await this.prisma.vendor.findUnique({
      where: { id },
    });

    if (!vendor) {
      throw new NotFoundException('Vendor not found');
    }

    return this.prisma.vendor.update({
      where: { id },
      data: dto,
    });
  }

  // 🔐 Delete vendor (ADMIN only)
  async remove(id: string) {
    const vendor = await this.prisma.vendor.findUnique({
      where: { id },
    });

    if (!vendor) {
      throw new NotFoundException('Vendor not found');
    }

    return this.prisma.vendor.delete({
      where: { id },
    });
  }
}
