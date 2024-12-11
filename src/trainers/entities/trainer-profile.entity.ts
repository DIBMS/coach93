import { Entity, Column, PrimaryGeneratedColumn, OneToOne, JoinColumn, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('trainer_profiles')
export class TrainerProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @OneToOne(() => User)
  @JoinColumn()
  user: User;

  @Column('simple-array')
  specializations: string[];

  @Column('text', { nullable: true })
  bio: string;

  @Column('decimal', { precision: 10, scale: 2 })
  hourlyRate: number;

  @Column({ nullable: true })
  yearsOfExperience: number;

  @Column('simple-array', { nullable: true })
  certifications: string[];

  @Column({ default: false })
  isVerified: boolean;

  @Column({ type: 'decimal', nullable: true })
  latitude: number;

  @Column({ type: 'decimal', nullable: true })
  longitude: number;

  @Column({ default: true })
  isAvailableForHire: boolean;

  @Column({ type: 'datetime', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @Column({ type: 'datetime', default: () => 'CURRENT_TIMESTAMP' })
  updatedAt: Date;
}
