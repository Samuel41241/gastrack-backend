// 🔑 HARDENING: Load environment variables before anything else
import 'dotenv/config'; 
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe, Logger } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule);

  // 🛡️ GRACEFUL SHUTDOWN: Important for Railway's container management
  app.enableShutdownHooks();

  // Global validation
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Swagger (API Documentation)
  const config = new DocumentBuilder()
    .setTitle('GasTrack API')
    .setDescription('Gas tracking backend API')
    .setVersion('1.0')
    .addBearerAuth(
      { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
      'JWT-auth',
    )
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  // 🚀 LISTEN: Bind to 0.0.0.0 for Docker/Railway compatibility
  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');

  logger.log(`GasTrack API is live on port ${port}`);
}

bootstrap();