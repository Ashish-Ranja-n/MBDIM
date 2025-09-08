import { Controller, Get, HttpStatus, ServiceUnavailableException } from '@nestjs/common';
import {
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { HealthService } from './health.service';
import type { HealthCheckResult } from './health.service';

@ApiTags('System')
@Controller('health')
export class HealthController {
  static HealthCheckSchema = {
    schema: {
      example: {
        status: 'ok',
        timestamp: '2025-09-08T10:00:00.000Z',
        uptime: 3600,
        environment: 'development',
        database: {
          status: 'connected',
          latencyMs: 5,
        },
        memory: {
          heapUsed: 50,
          heapTotal: 100,
          external: 10,
        },
      },
    },
  };
  constructor(private readonly healthService: HealthService) {}

  @Get()
  @ApiOperation({ summary: 'Get system health status' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'System is healthy',
    ...HealthController.HealthCheckSchema,
  })
  @ApiResponse({
    status: HttpStatus.SERVICE_UNAVAILABLE,
    description: 'System is unhealthy or database is disconnected',
    ...HealthController.HealthCheckSchema,
  })
  async check(): Promise<HealthCheckResult> {
    const health = await this.healthService.check();
    
    if (health.status === 'error' || health.database.status === 'disconnected') {
      throw new ServiceUnavailableException(health);
    }
    
    return health;
  }
}
