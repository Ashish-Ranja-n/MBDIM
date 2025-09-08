import { Module, ValidationPipe } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_PIPE, APP_INTERCEPTOR, APP_GUARD } from '@nestjs/core';
import { ThrottlerModule, ThrottlerGuard, ThrottlerModuleOptions } from '@nestjs/throttler';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { ListingsModule } from './listings/listings.module';
import { HealthModule } from './health/health.module';
import { LoggingInterceptor } from './interceptors/logging.interceptor';

const envFilePath = ['.env'];
if (process.env.NODE_ENV) {
  envFilePath.unshift(`.env.${process.env.NODE_ENV}`);
}

@Module({
  imports: [
    // Configuration with validation and multiple env files support
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath,
      validate: (config: Record<string, unknown>) => {
        const required = ['DATABASE_URL', 'JWT_SECRET'];
        for (const key of required) {
          if (!config[key]) {
            throw new Error(`Missing required environment variable: ${key}`);
          }
        }
        return config;
      },
    }),
    
    // Rate limiting
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService): ThrottlerModuleOptions => ({
        throttlers: [{
          ttl: config.get<number>('RATE_LIMIT_TTL', 60),
          limit: config.get<number>('RATE_LIMIT_MAX', 100),
        }],
      }),
    }),

    // Core modules
    PrismaModule,
    AuthModule,
    ListingsModule,
    HealthModule,
  ],
  providers: [
    // Global validation pipe
    {
      provide: APP_PIPE,
      useValue: new ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
        transformOptions: {
          enableImplicitConversion: true,
        },
      }),
    },
    // Global rate limiting
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    // Global logging
    {
      provide: APP_INTERCEPTOR,
      useClass: LoggingInterceptor,
    },
  ],
})
export class AppModule {}
