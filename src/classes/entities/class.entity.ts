import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { TrainerProfile } from '../../trainers/entities/trainer-profile.entity';

@Entity('classes')
export class Class {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column('text')
  description: string;

  @Column({ type: 'datetime' })
  startTime: Date;

  @Column({ type: 'datetime' })
  endTime: Date;

  @Column()
  maxParticipants: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @Column('simple-array')
  tags: string[];

  @ManyToOne(() => TrainerProfile)
  trainer: TrainerProfile;

  @Column({ type: 'decimal', nullable: true })
  latitude: number;

  @Column({ type: 'decimal', nullable: true })
  longitude: number;

  @Column({ default: 'scheduled' })
  status: string; // scheduled, ongoing, completed, cancelled

  @Column({ type: 'datetime', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @Column({ type: 'datetime', default: () => 'CURRENT_TIMESTAMP' })
  updatedAt: Date;
}
