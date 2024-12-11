import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Class } from './class.entity';

@Entity('class_bookings')
export class ClassBooking {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Class)
  class: Class;

  @ManyToOne(() => User)
  user: User;

  @Column({ default: 'pending' })
  status: string; // pending, confirmed, cancelled, completed

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  paidAmount: number;

  @Column({ default: false })
  attended: boolean;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @Column({ type: 'datetime', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @Column({ type: 'datetime', default: () => 'CURRENT_TIMESTAMP' })
  updatedAt: Date;
}
