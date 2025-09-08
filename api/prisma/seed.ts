import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // Create demo investor with ₹5,000 wallet balance
  const investor = await prisma.investor.upsert({
    where: { phone: '+919876543210' },
    update: {},
    create: {
      phone: '+919876543210',
      name: 'Demo Investor',
      walletBalancePaise: 500000n, // ₹5,000
      kycStatus: 'APPROVED',
    },
  });

  // Create demo shop
  const shop = await prisma.shop.upsert({
    where: { phone: '+919876543211' },
    update: {},
    create: {
      phone: '+919876543211',
      ownerName: 'Ashish',
      shopName: "Ashish's Chai Point",
      city: 'Bangalore',
      avgUpiDayPaise: 1200000n, // ₹12,000
    },
  });

  // Create a LIVE listing for the shop
  const listing = await prisma.listing.create({
    data: {
      shopId: shop.id,
      title: 'Expand Chai Point Location',
      description: 'Help us expand our successful chai point with new equipment and larger space',
      ticketPricePaise: 500000n, // ₹5,000
      targetAmountPaise: 5000000n, // ₹50,000
      raisedAmountPaise: 3200000n, // ₹32,000
      status: 'LIVE',
      startAt: new Date(),
      endAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
    },
  });

  console.log('Seed data created:', {
    investor: { id: investor.id, phone: investor.phone },
    shop: { id: shop.id, name: shop.shopName },
    listing: { id: listing.id, title: listing.title },
  });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
