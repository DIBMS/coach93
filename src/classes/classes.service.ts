import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual, MoreThanOrEqual, Between } from 'typeorm';
import { Class } from './entities/class.entity';
import { ClassBooking } from './entities/class-booking.entity';
import { TrainerProfile } from '../trainers/entities/trainer-profile.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class ClassesService {
  constructor(
    @InjectRepository(Class)
    private classRepository: Repository<Class>,
    @InjectRepository(ClassBooking)
    private bookingRepository: Repository<ClassBooking>,
    @InjectRepository(TrainerProfile)
    private trainerRepository: Repository<TrainerProfile>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async create(trainerId: string, data: Partial<Class>) {
    const trainer = await this.trainerRepository.findOne({
      where: { id: trainerId },
    });
    if (!trainer) {
      throw new NotFoundException('Trainer not found');
    }

    const newClass = this.classRepository.create({
      ...data,
      trainer,
    });

    return this.classRepository.save(newClass);
  }

  async findAll() {
    return this.classRepository.find({
      relations: ['trainer', 'trainer.user'],
    });
  }

  async findOne(id: string) {
    const classEntity = await this.classRepository.findOne({
      where: { id },
      relations: ['trainer', 'trainer.user'],
    });
    if (!classEntity) {
      throw new NotFoundException('Class not found');
    }
    return classEntity;
  }

  async findByTrainer(trainerId: string) {
    return this.classRepository.find({
      where: { trainer: { id: trainerId } },
      relations: ['trainer', 'trainer.user'],
    });
  }

  async findUpcoming() {
    const now = new Date();
    return this.classRepository.find({
      where: {
        startTime: MoreThanOrEqual(now),
        status: 'scheduled',
      },
      relations: ['trainer', 'trainer.user'],
      order: { startTime: 'ASC' },
    });
  }

  async bookClass(classId: string, userId: string) {
    const classEntity = await this.findOne(classId);
    const user = await this.userRepository.findOne({ where: { id: userId } });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Check if class is full
    const bookings = await this.bookingRepository.count({
      where: { class: { id: classId }, status: 'confirmed' },
    });

    if (bookings >= classEntity.maxParticipants) {
      throw new BadRequestException('Class is full');
    }

    // Check if user already booked
    const existingBooking = await this.bookingRepository.findOne({
      where: { class: { id: classId }, user: { id: userId } },
    });

    if (existingBooking) {
      throw new BadRequestException('You have already booked this class');
    }

    const booking = this.bookingRepository.create({
      class: classEntity,
      user,
      paidAmount: classEntity.price,
      status: 'confirmed',
    });

    return this.bookingRepository.save(booking);
  }

  async cancelBooking(bookingId: string, userId: string) {
    const booking = await this.bookingRepository.findOne({
      where: { id: bookingId, user: { id: userId } },
      relations: ['class'],
    });

    if (!booking) {
      throw new NotFoundException('Booking not found');
    }

    // Check if class hasn't started yet
    if (new Date() >= booking.class.startTime) {
      throw new BadRequestException('Cannot cancel a class that has already started');
    }

    booking.status = 'cancelled';
    return this.bookingRepository.save(booking);
  }

  async getUserBookings(userId: string) {
    return this.bookingRepository.find({
      where: { user: { id: userId } },
      relations: ['class', 'class.trainer', 'class.trainer.user'],
      order: { createdAt: 'DESC' },
    });
  }
}
