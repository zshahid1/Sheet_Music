*** Settings ***
Library  JMeterlib.py
Library  collections

*** Test Cases ***

#TC1 run jmeter
#    run jmeter
#
#tc2_analyseAndConvertExistingJtlLog
#    ${result}    analyse Jtl convert    D:/robotframework-jmeterlib/robotframework-jmeterlib/jmeterTest1Thread1Loop_csv.jtl
#    log    ${result}
#    : FOR    ${ELEMENT}    IN    @{result}
#    \    log dictionary    ${ELEMENT}
#
#tc3_runJMeterAndAnalyseAndConvertLog
#    ${result}    run jmeter analyse jtl convert    D:/programy/apache-jmeter-2.12/bin/jmeter.bat    D:/robotframework-jmeterlib/robotframework-jmeterlib/jmeterTest1Thread1Loop.jmx    D:/robotframework-jmeterlib/1.0/log/output_tc3.jtl
#    log    ${result}
#    :FOR    ${ELEMENT}    IN    @{result}
#    \    log dictionary    ${ELEMENT}
#