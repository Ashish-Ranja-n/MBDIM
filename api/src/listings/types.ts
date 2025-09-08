import { Prisma, PrismaClient } from '@prisma/client';

export interface ListingWithProgress {
  id: string;
  shopId: string;
  title: string;
  description: string;
  ticketPricePaise: bigint;
  targetAmountPaise: bigint;
  raisedAmountPaise: bigint;
  status: string;
  startAt: Date | null;
  endAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
  progressPercent: number;
  shop?: {
    shopName: string;
    city: string;
    avgUpiDayPaise: bigint | null;
  };
}

export interface InvestmentDto {
  numTickets: number;
  useWallet: boolean;
}

export type PrismaTransaction = Omit<
  PrismaClient,
  '$connect' | '$disconnect' | '$on' | '$transaction' | '$use'
>;
