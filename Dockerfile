#
# Build stage
#
FROM arm32v7/gcc:9 AS build

COPY . /usr/src/dsmr2mqtt
WORKDIR /usr/src/dsmr2mqtt
RUN apt-get update && apt-get install -y \
	git \
	libmosquitto-dev \
	ragel \
	&& make

#
# Package stage
#
FROM arm32v7/debian:buster-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
	libmosquitto-dev \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/src/dsmr2mqtt/dsmr2mqtt /usr/local/bin/dsmr2mqtt

CMD ["/usr/local/bin/dsmr2mqtt"]