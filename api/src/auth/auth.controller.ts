import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';

// DTOs
class StartOtpDto {
  contact!: string;
}

class VerifyOtpDto {
  pendingId!: string;
  otp!: string;
}

class RefreshTokenDto {
  refreshToken!: string;
}

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('start')
  async startOtp(@Body() dto: StartOtpDto) {
    return this.authService.startOtpFlow(dto.contact);
  }

  @Post('verify')
  async verifyOtp(@Body() dto: VerifyOtpDto) {
    return this.authService.verifyOtp(dto.pendingId, dto.otp);
  }

  @Post('refresh')
  async refresh(@Body() dto: RefreshTokenDto) {
    return this.authService.refreshToken(dto.refreshToken);
  }
}
