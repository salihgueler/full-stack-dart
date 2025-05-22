#!/bin/bash

# Build the frontend (if needed)
# cd ../frontend
# flutter build web
# mkdir -p public
# cp -r ../frontend/build/web/* public/

# Initialize Elastic Beanstalk if not already done
if [ ! -d ".elasticbeanstalk" ]; then
  eb init emoji-reaction-app --platform docker --region us-east-1
fi

# Create the environment if it doesn't exist
eb list | grep -q emoji-reaction-env
if [ $? -ne 0 ]; then
  eb create emoji-reaction-env --instance-type t3.micro --single
else
  # Deploy to existing environment
  eb deploy emoji-reaction-env
fi

# Get the environment URL
ENV_URL=$(eb status emoji-reaction-env | grep CNAME | awk '{print $2}')
echo "Application deployed successfully!"
echo "HTTP endpoint: http://$ENV_URL"
echo "WebSocket endpoint: ws://$ENV_URL/ws"
