import { Entity, Column, PrimaryGeneratedColumn, OneToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { UserProfile } from './user-profile.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ nullable: true, type: 'varchar', default: null })
  name: string | null;

  @Column()
  password: string;

  @Column({ nullable: true, type: 'varchar', default: null })
  profilePicture: string | null;

  @Column({ default: 'user' })
  role: string;

  @OneToOne(() => UserProfile, { cascade: true, nullable: true })
  @JoinColumn()
  profile: UserProfile | null;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
