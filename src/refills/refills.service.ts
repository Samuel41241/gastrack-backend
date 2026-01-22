import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateRefillDto } from './dto/create-refills.dto';

@Injectable()
export class RefillsService {
  constructor(private readonly prisma: PrismaService) {}

  // 🔐 Create refill (user-scoped)
  create(userId: string, dto: CreateRefillDto) {
    return this.prisma.refill.create({
      data: {
        vendorId: dto.vendorId,
        volumeKg: dto.volumeKg,
        amountPaid: dto.amountPaid,
        refillDate: new Date(),
        userId,
      },
    });
  }

  // 🔐 Get all refills for a user
  findAllByUser(userId: string) {
    return this.prisma.refill.findMany({
      where: { userId },
      orderBy: { refillDate: 'desc' },
    });
  }
}
