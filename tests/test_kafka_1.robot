*** Settings ***
Library    ../KafkaLibrary.py    WITH NAME    Kafka

*** Variables ***
${BOOTSTRAP_SERVERS}    localhost:9092
${TOPIC_AAA}            aaa
${TOPIC_BBB}            bbb
${GROUP_ID}             test-group
${MESSAGE_KEY}          test-key
${INPUT_MESSAGE}        {"key1":"value1"}
${EXPECTED_OUTPUT}      {"processed1":true}

*** Test Cases ***
End-to-End Kafka Test
    [Documentation]    Test Kafka message production and consumption
    # Connect to Kafka as producer
    Kafka.Connect Producer    ${BOOTSTRAP_SERVERS}

    # Produce a message to topic aaa
    Kafka.Produce Message    ${TOPIC_AAA}    ${MESSAGE_KEY}    ${INPUT_MESSAGE}

    # Connect to Kafka as consumer
    Kafka.Connect Consumer    ${BOOTSTRAP_SERVERS}    ${GROUP_ID}    ${TOPIC_BBB}

    # Consume the message from topic bbb
    ${output}=    Kafka.Consume Message    timeout=30

    # Verify the output
	Should Be Equal As Strings    ${output}    ${EXPECTED_OUTPUT}

    # Close the consumer
    Kafka.Close Consumer

