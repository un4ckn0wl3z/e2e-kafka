import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';

import { KafkaContainer } from '@testcontainers/kafka'; 


async function bootstrap() {

  const kafkaContainer = await new KafkaContainer().withExposedPorts(9093).start();
  const app = await NestFactory.createMicroservice<MicroserviceOptions>(AppModule, {
    transport: Transport.KAFKA,
    options: {
      client: {
        brokers: ['localhost:9093'],
      }
    }
  });

  app.listen();
  
}
bootstrap();
