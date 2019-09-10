# once:
# npm install -g @mspnp/azure-building-blocks
# git clone https://github.com/mspnp/template-building-blocks.git
cat ./template-building-blocks/scenarios/vnet/vnet-simple.json
SUBID=$(az account list --query "[0].id" | tr -d '"')
RESOURCE_GROUP='azbb'
LOCATION='westeurope'
of $(az group list --query "[?name == 'AADesignLab0201-RG'].location" --output tsv)
az group create --location $LOCATION --name $RESOURCE_GROUP
azbb -g $RESOURCE_GROUP -s $SUBID -l $LOCATION -p ./template-building-blocks/scenarios/vnet/vnet-simple.json
cp ./template-building-blocks/scenarios/vm/vm-win-cust-img-managed.json ./myvm.json
