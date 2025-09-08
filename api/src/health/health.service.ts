import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';

export interface HealthCheckResult {
  status: 'ok' | 'error';
  timestamp: string;
  uptime: number;
  environment: string;
  database: {
    status: 'connected' | 'disconnected';
    latencyMs?: number;
    error?: string;
  };
  memory: {
    heapUsed: number;
    heapTotal: number;
    external: number;
  };
}

@Injectable()
export class HealthService {
  private startTime: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
  ) {
    this.startTime = Date.now();
  }

  async check(): Promise<HealthCheckResult> {
    try {
      const dbCheckStart = Date.now();
      await this.prisma.$queryRaw`SELECT 1`;
      const dbLatency = Date.now() - dbCheckStart;

      const memoryUsage = process.memoryUsage();

      return {
        status: 'ok',
        timestamp: new Date().toISOString(),
        uptime: (Date.now() - this.startTime) / 1000, // in seconds
        environment: this.config.get('NODE_ENV', 'development'),
        database: {
          status: 'connected',
          latencyMs: dbLatency,
        },
        memory: {
          heapUsed: Math.round(memoryUsage.heapUsed / 1024 / 1024), // MB
          heapTotal: Math.round(memoryUsage.heapTotal / 1024 / 1024), // MB
          external: Math.round(memoryUsage.external / 1024 / 1024), // MB
        },
      };
    } catch (error) {
      return {
        status: 'error',
        timestamp: new Date().toISOString(),
        uptime: (Date.now() - this.startTime) / 1000,
        environment: this.config.get('NODE_ENV', 'development'),
        database: {
          status: 'disconnected',
          error: error instanceof Error ? error.message : 'Unknown error',
        },
        memory: {
          heapUsed: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
          heapTotal: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
          external: Math.round(process.memoryUsage().external / 1024 / 1024),
        },
      };
    }
  }
}
