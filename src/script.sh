export LOCATION=southeastasia
export RESOURCEGROUP=AutomationTeam
export APPNAME=dphlap # Cannot be more than 6 characters
export APP_INSIGHTS_LOCATION=southeastasia
export COSMOSDB_DATABASE_NAME=${APPNAME}-db
export COSMOSDB_DATABASE_COL=${APPNAME}-col


export AFD_NAME=dphlafd
export STORAGE_ACCOUNT_NAME=dphlstorageac

export COSMOSDB_DATABASE_ACCOUNT=$(az group deployment show \
                                    -g ${RESOURCEGROUP} \
                                    -n azuredeploy-backend-functionapps \
                                    --query properties.outputs.cosmosDatabaseAccount.value \
                                    -o tsv)
				
export DRONE_STATUS_FUNCTION_APP_NAME=$(az group deployment show \
                                    -g ${RESOURCEGROUP} \
                                    -n azuredeploy-backend-functionapps \
                                    --query properties.outputs.droneStatusFunctionAppName.value \
				    -o tsv)
export DRONE_TELEMETRY_FUNCTION_APP_NAME=$(az group deployment show \
                                    -g ${RESOURCEGROUP} \
                                    -n azuredeploy-backend-functionapps \
                                    --query properties.outputs.droneTelemetryFunctionAppName.value \
                                    -o tsv)
export FUNCTIONAPP_KEY=_master
export FUNCTIONAPP_URL="https://$(az functionapp show -g ${RESOURCEGROUP} -n ${DRONE_STATUS_FUNCTION_APP_NAME} --query defaultHostName -o tsv)/api"
export EH_NAMESPACE=$(az eventhubs namespace list \
     -g $RESOURCEGROUP \
     --query '[].name' --output tsv)
export EVENT_HUB_CONNECTION_STRING=$(az eventhubs eventhub authorization-rule keys list \
     -g $RESOURCEGROUP \
     --eventhub-name $APPNAME-eh  \
     --namespace-name $EH_NAMESPACE \
     -n send \
     --query primaryConnectionString --output tsv)

export SIMULATOR_PROJECT_PATH=DroneSimulator/Serverless.Simulator/Serverless.Simulator.csproj
dotnet build $SIMULATOR_PROJECT_PATH
dotnet run --project $SIMULATOR_PROJECT_PATH
