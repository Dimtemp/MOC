# once:
```console
npm install -g @mspnp/azure-building-blocks
git clone https://github.com/mspnp/template-building-blocks.git
cat ./template-building-blocks/scenarios/vnet/vnet-simple.json
```
# demo
```console
SUBID=$(az account list --query "[0].id" | tr -d '"')
RESOURCE_GROUP='azbb'
LOCATION='westeurope'
az group create --location $LOCATION --name $RESOURCE_GROUP
azbb -g $RESOURCE_GROUP -s $SUBID -l $LOCATION -p ./template-building-blocks/scenarios/vnet/vnet-simple.json
cp ./template-building-blocks/scenarios/vm/vm-win-cust-img-managed.json ./myvm.json
```
