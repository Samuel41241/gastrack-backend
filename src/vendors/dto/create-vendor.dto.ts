import { IsNotEmpty, IsOptional } from 'class-validator';

export class CreateVendorDto {
  @IsNotEmpty()
  name: string;

  @IsOptional()
  location?: string;
}
