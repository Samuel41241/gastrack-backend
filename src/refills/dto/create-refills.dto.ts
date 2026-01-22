import { IsNumber, IsUUID } from 'class-validator';

export class CreateRefillDto {
  @IsUUID()
  vendorId: string;

  @IsNumber()
  volumeKg: number;

  @IsNumber()
  amountPaid: number;
}
