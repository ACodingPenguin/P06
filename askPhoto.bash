#!/bin/bash

# GenAIoT 202324 Project Work by Gabriel 06 
# 2024 12 21

################################################################################
# Define input parameters                                                      #
################################################################################
# First parameter, PHOTO is the path to the image file which you want to examine
echo "Please input filename with path which you want to examine"
echo "e.g. /data/images/bus3.jpg"
read PHOTO
echo "Your file is " $PHOTO

# Second parameter, PROMPT is the prompt to ask the AI about the details of the image
echo "Please input prompt which is used to examine the image"
echo "e.g.  Please describe the image"
read PROMPT
echo "Your prompt is " $PROMPT

################################################################################
# Initialization of the operational environment                                #
################################################################################
# Stop all currently running dockers to clean the running environment state
sudo service docker stop
# Start relevant dockers needed for the operation
sudo service docker start

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Ask details about input photo"
   echo
   echo "Syntax: askPhoto.bash [-h|photo_filename e.g. /data/images/bus3.jpg ]"
   echo "PHOTO is the path to the image file which you want to examine"
   echo "PHOTO is the path to the image file which you want to examine"
   echo "PROMPT is the prompt to ask the AI about the details of the image"
}

################################################################################
# Main program                                                                 #
################################################################################
Help

################################################################################
# Initialize the Llava model                                                   #
################################################################################
jetson-containers run $(autotag llava) \
  python3 -m llava.serve.cli \
    --model-path liuhaotian/llava-v1.5-13b

################################################################################
# Start the askPhoto with the user-given parameters                            #
################################################################################
jetson-containers run --workdir=/opt/llama.cpp/bin $(autotag llama_cpp:gguf) \
  /bin/bash -c './llava-cli \
    --model $(huggingface-downloader mys/ggml_llava-v1.5-13b/ggml-model-q4_k.gguf) \
    --mmproj $(huggingface-downloader mys/ggml_llava-v1.5-13b/mmproj-model-f16.gguf) \
    --n-gpu-layers 999 \
    --image '${PHOTO}' \
    --prompt '${PROMPT}' '

################################################################################
# Clean the environment                                                        #
################################################################################
# Stop all currently running dockers to clear the running environment state
sudo service docker stop

exit 0
