import { Controller, Get, Post, Body, Param, Put, Delete, Query, UseGuards } from '@nestjs/common';
import { TrainersService } from './trainers.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { TrainerProfile } from './entities/trainer-profile.entity';

@Controller('trainers')
export class TrainersController {
  constructor(private readonly trainersService: TrainersService) {}

  @Get()
  findAll() {
    return this.trainersService.findAll();
  }

  @Get('nearby')
  findNearby(
    @Query('latitude') latitude: number,
    @Query('longitude') longitude: number,
    @Query('radius') radius?: number,
  ) {
    return this.trainersService.findNearby(latitude, longitude, radius);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.trainersService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body('userId') userId: string, @Body() data: Partial<TrainerProfile>) {
    return this.trainersService.create(userId, data);
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  update(@Param('id') id: string, @Body() data: Partial<TrainerProfile>) {
    return this.trainersService.update(id, data);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.trainersService.remove(id);
  }
}
