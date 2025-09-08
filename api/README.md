# MBDIM API

A minimal, well-documented backend API for the MBDIM project using NestJS, TypeScript, and Prisma with PostgreSQL.

## Models Overview

- `Investor`: Core user type for investors with wallet support
- `Shop`: Business profile for shops seeking investment
- `Listing`: Investment opportunities created by shops
- `Investment`: Records of investments made by investors
- `Transaction`: Ledger entries for all financial transactions
- `DailyRevenue`: (Future) Daily revenue tracking for return calculations

## Local Development Setup

1. Install dependencies:
   ```bash
   cd api
   npm install
   ```

2. Set up environment:
   - Copy `.env.example` to `.env`
   - Update DATABASE_URL with your PostgreSQL connection string
   - Set JWT secrets

3. Run database migrations:
   ```bash
   npx prisma migrate dev
   ```

4. Seed demo data:
   ```bash
   npm run prisma:seed
   ```

5. Start development server:
   ```bash
   npm run start:dev
   ```

## Demo Data

The seed creates:
- Investor with ₹5,000 wallet balance (phone: +919876543210)
- Shop "Ashish's Chai Point" with ₹12,000 avg daily UPI (phone: +919876543211)
- LIVE listing with ₹5,000 ticket price, ₹50,000 target (₹32,000 raised)

## API Endpoints

### Auth Flow
```
POST /api/auth/start  { contact }
← { pendingId }

POST /api/auth/verify { pendingId, otp }
← { accessToken, refreshToken, user, isNew }
```

### Listings & Investment
```
GET  /api/listings
GET  /api/listings/:id
POST /api/listings/:id/invest { numTickets, useWallet }
```

Example investment flow:
1. Get listing: `GET /api/listings/123`
2. Invest using wallet:
   ```
   POST /api/listings/123/invest
   {
     "numTickets": 2,
     "useWallet": true
   }
   ```

## Production TODOs

- [ ] Integrate payment gateway for non-wallet investments
- [ ] Implement KYC upload and verification flow
- [ ] Build daily returns calculation job using DailyRevenue
- [ ] Add rate limiting and additional security headers
- [ ] Set up monitoring and alerting
- [ ] Configure proper logging
