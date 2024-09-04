*** Settings ***
Documentation       This taskset runs a user provided azure cli command and pushes the metric. The supplied command must result in distinct single metric. Command line tools like jq are available. 
Metadata            Author    stewartshea
Metadata            Supports    Azure

Library             BuiltIn
Library             RW.Core
Library             RW.platform
Library             OperatingSystem
Library             RW.CLI

Suite Setup         Suite Initialization


*** Tasks ***
${TASK_TITLE}
    [Documentation]    Runs a user provided az cli command and pushes the metric as an SLI
    [Tags]    azure    cli    metric    sli    generic    az
    ${rsp}=    RW.CLI.Run Cli
    ...    cmd=${AZURE_COMMAND}
    RW.Core.Push Metric    ${rsp.stdout}

*** Keywords ***
Suite Initialization
    ${azure_auth}=    RW.Core.Import Secret
    ...    azure_auth
    ...    type=string
    ...    description=The azure authentication type to use.
    ...    pattern=\w*
    ...    example=azure:sp@cli
    ${AZURE_COMMAND}=    RW.Core.Import User Variable    AZURE_COMMAND
    ...    type=string
    ...    description=The az cli command to run. Must produce a single value that can be pushed as a metric. Can use tools like jq. 
    ...    pattern=\w*
    ...    example="az aks list --output json | jq 'length'"
    ${TASK_TITLE}=    RW.Core.Import User Variable    TASK_TITLE
    ...    type=string
    ...    description=The name of the task to run. This is useful for helping find this generic task with RunWhen Digital Assistants. 
    ...    pattern=\w*
    ...    example="Count the number of pods in the namespace"
