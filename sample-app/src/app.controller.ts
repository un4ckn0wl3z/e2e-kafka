import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { Ctx, EventPattern, KafkaContext, Payload } from '@nestjs/microservices';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @EventPattern('aaa')
  consumeAAA(@Payload() data: any, @Ctx() context: KafkaContext): any {
    console.log('consumeAAA', data);
    const kafkaProducer = context.getProducer();
    kafkaProducer.send({
      topic: 'bbb',
      messages: [{ value: JSON.stringify({processed1: true}) }],
    });
    
  }

  @EventPattern('ccc')
  consumeCCC(@Payload() data: any, @Ctx() context: KafkaContext): any {
    console.log('consumeCCC', data);
    const kafkaProducer = context.getProducer();
    kafkaProducer.send({
      topic: 'ddd',
      messages: [{ value: JSON.stringify({processed2: true}) }],
    });
    
  }
}
