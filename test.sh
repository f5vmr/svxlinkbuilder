#!/bin/bash

# Define a list of colors using ANSI escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# The text to be echoed
text="Hello, world!"

# Echo the text in different colors
echo -e "${RED}${text}${NC}"
echo -e "${GREEN}${text}${NC}"
echo -e "${YELLOW}${text}${NC}"
echo -e "${BLUE}${text}${NC}"
echo -e "${MAGENTA}${text}${NC}"
echo -e "${CYAN}${text}${NC}"
echo -e "${WHITE}${text}${NC}"
