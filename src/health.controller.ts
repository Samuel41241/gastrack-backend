import { Controller, Get } from '@nestjs/common';

@Controller()
export class HealthController {
  @Get('health')
  health() {
    return {
      status: 'ok',
      service: 'gastrack-backend',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    };
  }
}
