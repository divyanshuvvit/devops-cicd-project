
# Use official Nginx image
FROM nginx:alpine

# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy website files into Nginx web directory
COPY index.html /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/
COPY images/ /usr/share/nginx/html/images/

# Expose web server port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
