import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('user_profiles')
export class UserProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'float', nullable: true })
  weight: number;

  @Column({ type: 'float', nullable: true })
  height: number;

  @Column({ nullable: true })
  age: number;

  @Column({ nullable: true })
  fitnessLevel: string;

  @Column({ type: 'float', nullable: true })
  bodyFatPercentage: number;

  @Column({ type: 'float', nullable: true })
  muscleMass: number;

  @Column({ type: 'text', nullable: true })
  bio: string;
}
