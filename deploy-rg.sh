#!/bin/bash

# Prompt the user for input
read -p "Please enter the resouce group name " rg_name_input

# Define the file to search and replace in
file="terraform/variables.tf"

# Check if the file exists
if [ ! -f "$file" ]; then
  echo "The file $file does not exist."
  exit 1
fi

# Search for 'rg-test-01' and replace it with the user's input
sed -i "s/rg-test-01/$rg_name_input/g" "$file"

# Print a success message
echo "Set '$rg_name_input' in $file"

  # Change to the terraform directory
  echo "Changing to terraform directory..."
  cd terraform || { echo "Error: terraform directory not found"; exit 1; }

  # Call terraform init
  echo "Initializing Terraform..."
  terraform init
  echo "Terraform initialization complete."

  # Call terraform plan
  echo "Planning Terraform..."
  terraform plan
  echo "Terraform plan complete."

# Ask the user if they want to proceed
read -p "Are you sure you want to deploy rsouce group '$rg_name_input'? (y/n): " proceed

# Check the user's response
if [ "$proceed" = "y" ] || [ "$proceed" = "Y" ]; then
  # Call terraform plan
  echo "Applying Terraform..."
  terraform apply -auto-approve
  echo "Terraform apply complete."
else
  # Change to the terraform directory
  echo "Changing to back to DSO-TAP directory..."
  cd .. || { echo "Error: terraform directory not found"; exit 1; }
  # revert file back to default
  sed -i "s/$rg_name_input/rg-test-01/g" "$file"
  # Print a cancellation message
  echo "Operation cancelled."
  exit 1
fi

# Ask the user if they want to proceed
read -p "Did '$rg_name_input' deploy as expspected? (y/n): " proceed

# Check the user's response
if [ "$proceed" = "y" ] || [ "$proceed" = "Y" ]; then
  #staging for next deployment
  rm terraform.tfstate*
  # Change to the terraform directory
  echo "Changing to back to DSO-TAP directory..."
  # cleaning up for next deployment
  sed -i "s/$rg_name_input/rg-test-01/g" "$file"
else
  # Call terraform destroy
  echo "Destroying Terraform..."
  terraform destroy -auto-approve
  echo "Terraform destroy complete."
  #staging for next deployment
  rm terraform.tfstate*
  # Change to the terraform directory
  echo "Changing to back to DSO-TAP directory..."
  cd .. || { echo "Error: terraform directory not found"; exit 1; }
  # revert file back to default
  sed -i "s/$rg_name_input/rg-test-01/g" "$file"
  # Print a cancellation message
  echo "Operation cancelled."
fi
