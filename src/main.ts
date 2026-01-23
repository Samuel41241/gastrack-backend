// 🛡️ Standard: Load env vars first to bridge Prisma WASM engine timing
import 'dotenv/config'; 
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe, Logger } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule);

  // 🛡️ Standard: Enable Graceful Shutdown
  app.enableShutdownHooks();

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  const config = new DocumentBuilder()
    .setTitle('GasTrack API')
    .setVersion('1.0')
    .addBearerAuth({ type: 'http', scheme: 'bearer', bearerFormat: 'JWT' }, 'JWT-auth')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = process.env.PORT || 3000;
  // 🛡️ Standard: Bind to 0.0.0.0 for containerized environments
  await app.listen(port, '0.0.0.0');

  logger.log(`GasTrack API is live and production-hardened on port ${port}`);
}
bootstrap();