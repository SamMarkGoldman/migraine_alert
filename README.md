# Migraine Alert
Alert me when barometric pressure changes could cause migraines.

This project is an experiment, and completely tailored to my personal migraine triggers and needs, but anyone is welcome to use this code in anyway.  Maybe it can help someone else.

## How was this built?
My wife has been logging down every time I get a migraine.  In the meantime, I eventually realized I always get migraines when the weather seems to be changing, more in spring and fall, more on very gusty days.  I decided to pull the historic weather data from the logs provided via [wunderground's API](https://www.wunderground.com/weather/api/) and look for any correlations between changes is weather conditions and my migraine events.  It turns out my migraines often followed sharp drops in barometric pressure.  So, I wrote a little app which keeps track of the pressure in real-time and emails me with a warning if a pressure drop has similar characteristics to the pressure drops experienced prior to past migraines.

## Historic Data

Since I had a data set from the previous two years, used to find correlations between headaches and weather changes, it was easy to repurpose this data set to act as testing data during development.

By replacing the call to `Weather::Reading#fetch_data` to `Weather::Reading#fetch_mock`, in a matter of seconds I could perform "real-time" analysis over a whole years worth of data and log where the alerts would be triggered.  This was critical in ironing out little bugs before setting it to run on current weather data.