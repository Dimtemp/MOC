This Azure template creates a storage account, two logic apps and a service bus.

The first logic app monitors the storage account, and writes a message to the service bus when a new file is created.

The second logic app monitors the service bus, and creates a new file in the storage account when it reads the message from the service bus.

DISCLAIMER: use on your own risk!
