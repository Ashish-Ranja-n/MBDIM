import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';
enum UserType {
  INVESTOR = 'INVESTOR',
  SHOP = 'SHOP',
  ADMIN = 'ADMIN'
}

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async startOtpFlow(contact: string) {
    // In development, always use '1234' as OTP
    const otp = process.env.NODE_ENV === 'development' ? '1234' : this.generateOtp();
    
    // Create OTP session with 5 minute expiry
    const session = await this.prisma.otpSession.create({
      data: {
        contact,
        otp,
        type: this.guessUserType(contact), // Phone = INVESTOR/SHOP, Email = ADMIN
        expiresAt: new Date(Date.now() + 5 * 60 * 1000),
      },
    });

    // TODO: Integrate with real SMS/email service
    console.log(`[DEV] OTP for ${contact}: ${otp}`);

    return { pendingId: session.id };
  }

  async verifyOtp(pendingId: string, otp: string) {
    const session = await this.prisma.otpSession.findUnique({
      where: { id: pendingId },
    });

    if (!session || session.expiresAt < new Date() || session.otp !== otp) {
      throw new UnauthorizedException('Invalid or expired OTP');
    }

    // Find or create user based on type
    const user = await this.findOrCreateUser(session.contact, session.type);
    
    // Generate tokens
    const [accessToken, refreshToken] = await Promise.all([
      this.generateAccessToken(user.id, session.type),
      this.generateRefreshToken(user.id, session.type),
    ]);

    // Delete used OTP session
    await this.prisma.otpSession.delete({
      where: { id: session.id },
    });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        role: session.type,
        ...user,
      },
      isNew: user.createdAt === user.updatedAt, // If dates match, profile not updated yet
    };
  }

  private generateOtp(): string {
    return Math.floor(1000 + Math.random() * 9000).toString();
  }

  private guessUserType(contact: string): UserType {
    return contact.includes('@') ? UserType.ADMIN : UserType.INVESTOR;
  }

  private async findOrCreateUser(contact: string, type: UserType) {
    switch (type) {
      case UserType.INVESTOR:
        return this.prisma.investor.upsert({
          where: { phone: contact },
          create: { phone: contact },
          update: {},
        });
      
      case UserType.SHOP:
        return this.prisma.shop.upsert({
          where: { phone: contact },
          create: { 
            phone: contact,
            shopName: '', // Will be filled in profile completion
            ownerName: '',
            city: '',
          },
          update: {},
        });

      case UserType.ADMIN:
        return this.prisma.admin.upsert({
          where: { email: contact },
          create: { 
            email: contact,
            name: contact.split('@')[0], // Temporary name from email
          },
          update: {},
        });
      
      default:
        throw new Error(`Invalid user type: ${type}`);
    }
  }

  private async generateAccessToken(userId: string, type: UserType): Promise<string> {
    return this.jwtService.signAsync({
      sub: userId,
      type,
    });
  }

  private async generateRefreshToken(userId: string, type: UserType): Promise<string> {
    const token = this.jwtService.sign(
      { sub: userId, type },
      { 
        secret: process.env.JWT_REFRESH_SECRET,
        expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
      },
    );

    // Store refresh token
    await this.prisma.refreshToken.create({
      data: {
        token,
        userId,
        userType: type,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
      },
    });

    return token;
  }

  async refreshToken(token: string) {
    const stored = await this.prisma.refreshToken.findUnique({
      where: { token },
    });

    if (!stored || stored.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }

    const accessToken = await this.generateAccessToken(stored.userId, stored.userType);

    return { accessToken };
  }
}
