from confluent_kafka import Producer, Consumer, KafkaException
import json
import time

class KafkaLibrary:

    def __init__(self):
        self.producer = None
        self.consumer = None

    def connect_producer(self, bootstrap_servers):
        """Connect to Kafka as a producer"""
        self.producer = Producer({'bootstrap.servers': bootstrap_servers})

    def produce_message(self, topic, key, message):
        """Produce a message to a topic"""
        self.producer.produce(topic, key=key, value=json.dumps(message))
        self.producer.flush()

    def connect_consumer(self, bootstrap_servers, group_id, topic):
        """Connect to Kafka as a consumer"""
        self.consumer = Consumer({
            'bootstrap.servers': bootstrap_servers,
            'group.id': group_id,
            'auto.offset.reset': 'earliest'
        })
        self.consumer.subscribe([topic])

    def consume_message(self, timeout=10):
        """Consume a message from the topic"""
        start_time = time.time()
        while time.time() - start_time < timeout:
            msg = self.consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaException._PARTITION_EOF:
                    continue
                else:
                    raise KafkaException(msg.error())
            return msg.value()
        raise TimeoutError("No message received in the specified timeout")

    def close_consumer(self):
        """Close the Kafka consumer"""
        if self.consumer:
            self.consumer.close()
