import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TrainerProfile } from './entities/trainer-profile.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class TrainersService {
  constructor(
    @InjectRepository(TrainerProfile)
    private trainerProfileRepository: Repository<TrainerProfile>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async findAll() {
    return this.trainerProfileRepository.find({
      relations: ['user'],
    });
  }

  async findOne(id: string) {
    const trainer = await this.trainerProfileRepository.findOne({
      where: { id },
      relations: ['user'],
    });
    if (!trainer) {
      throw new NotFoundException('Trainer not found');
    }
    return trainer;
  }

  async findNearby(latitude: number, longitude: number, radiusInKm: number = 10) {
    // Simple distance calculation using SQL
    const trainers = await this.trainerProfileRepository
      .createQueryBuilder('trainer')
      .where(
        `(
          6371 * acos(
            cos(radians(:latitude)) * cos(radians(trainer.latitude)) *
            cos(radians(trainer.longitude) - radians(:longitude)) +
            sin(radians(:latitude)) * sin(radians(trainer.latitude))
          )
        ) < :radius`,
        { latitude, longitude, radius: radiusInKm }
      )
      .getMany();

    return trainers;
  }

  async create(userId: string, data: Partial<TrainerProfile>) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const trainerProfile = this.trainerProfileRepository.create({
      ...data,
      user,
    });

    await this.trainerProfileRepository.save(trainerProfile);
    user.role = 'trainer';
    await this.userRepository.save(user);

    return trainerProfile;
  }

  async update(id: string, data: Partial<TrainerProfile>) {
    const trainer = await this.findOne(id);
    Object.assign(trainer, data);
    return this.trainerProfileRepository.save(trainer);
  }

  async remove(id: string) {
    const trainer = await this.findOne(id);
    await this.trainerProfileRepository.remove(trainer);
  }
}
