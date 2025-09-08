import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';
import { InvestmentDto, PrismaTransaction } from './types';

@Injectable()
export class ListingsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(filters: { status?: string } = {}) {
    const listings = await this.prisma.listing.findMany({
      where: {
        status: filters.status as any || 'LIVE',
      },
      include: {
        shop: {
          select: {
            shopName: true,
            city: true,
            avgUpiDayPaise: true,
          },
        },
      },
    });

    return listings.map((listing: any) => ({
      ...listing,
      progressPercent: Number((listing.raisedAmountPaise * 100n) / listing.targetAmountPaise),
    }));
  }

  async findOne(id: string) {
    const listing = await this.prisma.listing.findUnique({
      where: { id },
      include: {
        shop: true,
        investments: {
          select: {
            id: true,
            numTickets: true,
            amountPaidPaise: true,
            status: true,
            createdAt: true,
          },
        },
      },
    });

    if (!listing) {
      throw new NotFoundException(`Listing #${id} not found`);
    }

    return {
      ...listing,
      progressPercent: Number((listing.raisedAmountPaise * 100n) / listing.targetAmountPaise),
    };
  }

  async create(shopId: string, data: any) {
    return this.prisma.listing.create({
      data: {
        ...data,
        shopId,
      },
    });
  }

  async invest(listingId: string, investorId: string, dto: { numTickets: number; useWallet: boolean }) {
    const listing = await this.prisma.listing.findUnique({
      where: { id: listingId },
    });

    if (!listing || listing.status !== 'LIVE') {
      throw new NotFoundException(`Active listing #${listingId} not found`);
    }

    const amountPaise = BigInt(dto.numTickets) * listing.ticketPricePaise;

    // Start a transaction for wallet-based investment
    if (dto.useWallet) {
      return this.prisma.$transaction(async (tx) => {
        const investor = await tx.investor.findUnique({
          where: { id: investorId },
        });

        if (!investor || investor.walletBalancePaise < amountPaise) {
          throw new Error('Insufficient wallet balance');
        }

        // Create investment record
        const investment = await tx.investment.create({
          data: {
            listingId,
            investorId,
            numTickets: dto.numTickets,
            amountPaidPaise: amountPaise,
            paymentReference: `WALLET-${Date.now()}`,
            status: 'CONFIRMED',
          },
        });

        // Update investor wallet
        await tx.investor.update({
          where: { id: investorId },
          data: {
            walletBalancePaise: {
              decrement: amountPaise,
            },
          },
        });

        // Update listing raised amount
        await tx.listing.update({
          where: { id: listingId },
          data: {
            raisedAmountPaise: {
              increment: amountPaise,
            },
          },
        });

        // Create transaction record
        await tx.transaction.create({
          data: {
            type: 'INVESTMENT',
            userType: 'INVESTOR',
            userId: investorId,
            shopId: listing.shopId,
            amountPaise,
            metadata: {
              listingId,
              investmentId: investment.id,
            },
          },
        });

        return investment;
      });
    } else {
      // TODO: Integrate payment gateway
      // For now, create a pending investment that we'll mark confirmed
      const investment = await this.prisma.investment.create({
        data: {
          listingId,
          investorId,
          numTickets: dto.numTickets,
          amountPaidPaise: amountPaise,
          paymentReference: `MOCK-${Date.now()}`,
          status: 'PENDING',
        },
      });

      // Mock: Immediately mark as confirmed (in prod, payment gateway webhook would do this)
      return this.confirmInvestment(investment.id);
    }
  }

  // In production, this would be called by payment gateway webhook
  private async confirmInvestment(investmentId: string) {
    return this.prisma.$transaction(async (tx) => {
      const investment = await tx.investment.update({
        where: { id: investmentId },
        data: { status: 'CONFIRMED' },
        include: { listing: true },
      });

      await tx.listing.update({
        where: { id: investment.listingId },
        data: {
          raisedAmountPaise: {
            increment: investment.amountPaidPaise,
          },
        },
      });

      await tx.transaction.create({
        data: {
          type: 'INVESTMENT',
          userType: 'INVESTOR',
          userId: investment.investorId,
          shopId: investment.listing.shopId,
          amountPaise: investment.amountPaidPaise,
          metadata: {
            listingId: investment.listingId,
            investmentId: investment.id,
          },
        },
      });

      return investment;
    });
  }
}
