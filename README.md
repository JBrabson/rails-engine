# Whether Sweater

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#setup">Setup</a>
    </li>
    <li><a href="#endpoints">Endpoints</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project
Sweater weather.... I mean, Whether Sweater is an API that allows you the user to plan a road trip. In doing so, as long as it is a viable destination, you will be able to see the origin city, the destination city, travel time, and estimated weather in the destination city upon arrival.
<p>Through this project the following learning goals were achieved:
  *Consumption of multiple API's
  * Following RESTful conventions when creating API endpoints
  * Exposing aggregated data through serializers

  #### Built With

* [Ruby | v](https://www.ruby-lang.org/en/)
* [Rails | v](https://rubyonrails.org/)
  
<!-- Setup -->
## Setup
Clone this repo<br>
Run `bundle install`<br>
Run `bundle exec figaro install`<br>
Run `rails db:create`<br><br>
<strong>You will need to get api_keys from the following websites:</strong><br>
* [OpenWeather](https://openweathermap.org/api/one-call-api)<br>
* [GeoCoding](https://developer.mapquest.com/documentation/geocoding-api/)<br>
* [Unsplash](https://unsplash.com/documentation)<br>
  
<strong>and store them in your application.yml file:</strong>
   ```sh
   #config/application.yml
   
   API_KEY = 'ENTER YOUR API'
   ``` 

<!-- Endpoints -->
## Endpoints
Below endpoints will append to base connector: [http://localhost:3000](http://localhost:3000)

| Method | URL | Detail |
| ------ | --- | ------ |
| GET | '/api/v1/forecast?location={location}' | Location must be sent as 'Denver,CO' or 'Phoenix,AZ'. Returns current forecast for given location, including next five days and next eight hours. |
| GET | '/api/v1/backgrounds?location={location}' | Location must be sent as 'Denver,CO' or 'Pheonix,AZ'. Returns url of a background image to display for given location. |
| POST | '/api/v1/users' | A post request can be sent to the above uri, sending over the email, password, and password confirmation in the body of the request as JSON. If successful, it will return the user's email and the api key they have been issued. |
| POST | '/api/v1/sessions' | A post request can be sent to the above uri, sending over email and password in the body of the request as JSON. If successful, it will return the given user's email and api_key. |
| POST | '/api/v1/road_trip' | A post request can be sent to the above uri, sending over an origin (ex. 'Denver,CO), a destination (ex. 'Phoenix,AZ), and a valid api key in the body of the request. If the locations are able to be traversed via car, and the api key is valid, the response will send the destination and origin city, total travel time, and estimated weather upon arrival at destination city. |
