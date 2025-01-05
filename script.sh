#!/bin/bash

# Function to check and install dependencies
check_dependencies() {
    local dependencies=("cowsay" "lolcat")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "'$dep' is not installed."
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "Installing '$dep' using apt..."
                sudo apt update && sudo apt install -y "$dep"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                echo "Installing '$dep' using Homebrew..."
                if ! command -v brew &> /dev/null; then
                    echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
                    exit 1
                fi
                brew install "$dep"
            else
                echo "Unsupported OS. Please install '$dep' manually."
                exit 1
            fi
        fi
    done
}

# Check for required tools
check_dependencies

# Temporary file to store pip output
TMP_FILE=$(mktemp)

# Display a funny animal animation during installation
(cowsay -f dragon-and-cow "Installing dependencies..." | lolcat -ads) &
ANIMATION_PID=$!

# Run the pip installation and redirect output to the temporary file
pip install -r requirements.txt &> "$TMP_FILE"
EXIT_CODE=$?

# Kill the animation process
kill $ANIMATION_PID 2> /dev/null

# Check if pip succeeded
if [ $EXIT_CODE -eq 0 ]; then
    cowsay -f dragon "✅ Preparation complete! Explore the project 💻" | lolcat -ds
else
    # Display a sad animal with the error message
    cowsay -f ghostbusters "Oh no! An error occurred!" | lolcat -a
    echo -e "\n$(cat "$TMP_FILE")" 
fi

# Cleanup
rm "$TMP_FILE"

