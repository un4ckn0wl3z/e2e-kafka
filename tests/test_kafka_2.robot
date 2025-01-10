*** Settings ***
Library    ../KafkaLibrary.py    WITH NAME    Kafka

*** Variables ***
${BOOTSTRAP_SERVERS}    localhost:9092
${TOPIC_CCC}            ccc
${TOPIC_DDD}            ddd
${GROUP_ID}             test-group
${MESSAGE_KEY}          test-key
${INPUT_MESSAGE}        {"key2":"value2"}
${EXPECTED_OUTPUT}      {"processed2":true}

*** Test Cases ***
End-to-End Kafka Test
    [Documentation]    Test Kafka message production and consumption
    # Connect to Kafka as producer
    Kafka.Connect Producer    ${BOOTSTRAP_SERVERS}

    # Produce a message to topic aaa
    Kafka.Produce Message    ${TOPIC_CCC}    ${MESSAGE_KEY}    ${INPUT_MESSAGE}

    # Connect to Kafka as consumer
    Kafka.Connect Consumer    ${BOOTSTRAP_SERVERS}    ${GROUP_ID}    ${TOPIC_DDD}

    # Consume the message from topic bbb
    ${output}=    Kafka.Consume Message    timeout=30

    # Verify the output
	Should Be Equal As Strings    ${output}    ${EXPECTED_OUTPUT}

    # Close the consumer
    Kafka.Close Consumer

