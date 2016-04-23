all: clean rtree

rtree: community_districts.geojson
	./build_rtree.py $^

community_districts.geojson:
	@echo Downloading geojson...
	wget -q -O $@ http://data.beta.nyc//dataset/472dda10-79b3-4bfb-9c75-e7bd5332ec0b/resource/d826bbc6-a376-4642-8d8b-3a700d701557/download/88472a1f6fd94fef97b8c06335db60f7nyccommunitydistricts.geojson

.PHONY: clean
clean:
	@echo Cleaning files...
	rm -f rtree* community_districts.geojson
