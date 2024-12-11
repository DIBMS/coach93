import { Controller, Get, Post, Body, Param, UseGuards, Query } from '@nestjs/common';
import { ClassesService } from './classes.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Class } from './entities/class.entity';

@Controller('classes')
export class ClassesController {
  constructor(private readonly classesService: ClassesService) {}

  @Get()
  findAll() {
    return this.classesService.findAll();
  }

  @Get('upcoming')
  findUpcoming() {
    return this.classesService.findUpcoming();
  }

  @Get('trainer/:trainerId')
  findByTrainer(@Param('trainerId') trainerId: string) {
    return this.classesService.findByTrainer(trainerId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.classesService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(
    @Body('trainerId') trainerId: string,
    @Body() data: Partial<Class>,
  ) {
    return this.classesService.create(trainerId, data);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/book')
  bookClass(
    @Param('id') classId: string,
    @Body('userId') userId: string,
  ) {
    return this.classesService.bookClass(classId, userId);
  }

  @UseGuards(JwtAuthGuard)
  @Post('bookings/:id/cancel')
  cancelBooking(
    @Param('id') bookingId: string,
    @Body('userId') userId: string,
  ) {
    return this.classesService.cancelBooking(bookingId, userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('user/:userId/bookings')
  getUserBookings(@Param('userId') userId: string) {
    return this.classesService.getUserBookings(userId);
  }
}
