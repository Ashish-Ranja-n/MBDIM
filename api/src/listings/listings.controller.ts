import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ListingsService } from './listings.service';
import { JwtAuthGuard } from '../auth/guards/jwt.guard';

@Controller('listings')
export class ListingsController {
  constructor(private readonly listingsService: ListingsService) {}

  @Get()
  async findAll() {
    return this.listingsService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.listingsService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(@Body() data: any) {
    return this.listingsService.create(data.shopId, data);
  }

  @Post(':id/invest')
  @UseGuards(JwtAuthGuard)
  async invest(
    @Param('id') id: string,
    @Body() dto: { numTickets: number; useWallet: boolean },
  ) {
    // TODO: Get investorId from JWT claims
    const investorId = 'mock-investor-id';
    return this.listingsService.invest(id, investorId, dto);
  }
}
