import { UserType } from '@prisma/client';

export interface JwtPayload {
  sub: string;
  type: UserType;
  iat?: number;
  exp?: number;
}

export interface JwtUser {
  id: string;
  type: UserType;
}
