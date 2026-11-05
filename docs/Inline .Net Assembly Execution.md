## Overview 

Inline assembly execution (e.g. `inline-execute` command) is a Trinity C2 feature that enables .NET assemblies to be directly executed in memory within the Agent process, eliminating the need for traditional fork-and-run approaches that inject post-exploitation tooling into a newly spawned sacrificial process or dropping the binary to disk. 

Traditional fork-and-run approaches spawn a new sacrificial process, inject the post-exploitation .Net tooling into the new process, and when finished retrieves the output then terminates the process. The primary benefit to the fork-and-run is that execution occurs outside of the Agent process which improves the likelihood of survival in the eventuality of detection. However, it remains an expensive pattern in terms of operational security. 

Key differentiators are outlined below: 

| Feature           | fork-and-run                    | inline execution                |
| ----------------- | ------------------------------- | ------------------------------- |
| Process Creation  | Creates sacrificial process     | In-process execution            |
| Detection Surface | Process creation events         | CLR loading in existing process |
| Agent Survival    | Agent survives assembly crashes | Agent dies if assembly crashes  |
Inline assembly execution avoids some of those operational security pitfalls mentioned above when operating in mature security hardened environments, rendering it the exclusive means of executing .Net assemblies and extending Agent capabilities at runtime in Trinity C2. 
## Command usage 

 The`inline-execute` command requires two arguments, the path to the .NET Framework tool hosted in the Team Server's Armoury and optionally the command-line arguments for the binary. 
 
```
execute-assembly [/path/to/file.exe] [arguments]
```

The tool's path can be easily obtained from the Armoury tab using the clipboard button for that tool's respective record. 

*NOTE: .NET/.NET Core assemblies are not supported, only .NET Framework assemblies can be used.*
## Responses: Success and Error States 

The `inline-execute` command follows the same intuitive response pattern, whereby a `TaskResponse` structure is created to store the output of a command upon both success or failure states. 

However, `inline-execute` differs subtly in terms of failure and success states that may act to confuse the operator. An error state will only be returned in the response if the Agent has failed to load the CLR or invoke the entry point of the .Net assembly. Regardless of whether the tooling succeeds or fails it will return a success state, as determining failure based on the output of the anonymous pipe is not feasible or desirable considering the high-variance of available tooling in the .Net ecosystem. 

## Loading the Common Language Runtime (CLR)

The primary steps the Agent will take to load the CLR are as follows: 

1. Make a call to **CLRCreateInstance** which will be used to retrieve our **ICLRMetaHost** interface.
2. **CLRMetaHost ->GetRuntime** is then used to get the runtime information for the version of .NET requested.
3. Once we have our runtime info, we use **ICLRRuntimeInfo->IsLoadable** to check if our runtime can be loaded into the process.
4. If above steps are successful, we will then run **ICLRRuntimeInfo->GetInterface** to load the CLR into our process and retrieve an interface to **ICorRunTimeHost**.
5. Lastly, we will call **ICorRuntimeHost->Start**, which starts the CLR.

## Loading and invoking a .NET assembly 

The main steps the Agent will take to load and invoke our .NET assembly are as follows:

1. Use **ICorRuntimeHost->CreateDomain** to create our unique AppDomain
2. Use **IUnknown->QueryInterface** (pAppDomainThunk) to get a pointer to the AppDomain interface.
3. Create our SafeArray and copy our .NET assembly bytes to it.
4. Load our assembly via **AppDomain->Load_3**. 
5. Create an anonymous pipe to redirect the assembly's output.
6. Get our entry point in our assembly via **Assembly->EntryPoint**.
7. Invoke our assembly via **MethodInfo->Invoke_3**.
8. Lastly, write the output from the anonymous pipe to the provided memory buffer. 

## Writing A Custom .Net assembly Tool 

This section will demonstrate how custom .Net assembly tooling can be written to extend Agent capabilities at runtime. The project can be created using any Integrated Development Environment (IDE) and is not platform specific (e.g. Windows, Linux etc...) . However, for purposes of this demonstration Visual Studio will be used. 

*NOTE: Whilst development of the .Net tool is not restricted to a specific platform or IDE. The Agent is Windows specific and will not run on any other platform.*

Open Visual Studio select **Create a new project -> Console App (.Net Framework)** 

![[Pasted image 20261103152203.png]]

Next configure the project by providing a name and select an appropriate .Net Framework version (either 4.7.2 or 4.8) then click **Create**. 

![[Pasted image 20261103152729.png]]

The logic and implementation specific details are subject to the discretion of the operator and what they would like to achieve with the tooling. The only requirement is that the output be written to the standard output stream. This can be achieved by simply calling `Console.WriteLine` as seen in the example below: 

![[Pasted image 20261103153835.png]]
