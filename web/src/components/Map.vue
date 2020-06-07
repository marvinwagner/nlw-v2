<template>
  <div style="height: 400px; width: 100%">
    <l-map
      :zoom="zoom"
      :center="center"
      style="height: 80%"
      @click="selectPosition"
    >
      <l-tile-layer :url="url" :attribution="attribution"/>
      <l-marker :lat-lng="selectedPosition"/>
    </l-map>
  </div>
</template>

<script>
import { LMap, LTileLayer, LMarker } from 'vue2-leaflet';
import { latLng, Icon } from "leaflet";

delete Icon.Default.prototype._getIconUrl;
Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

export default {
  components: {
    LMap, LTileLayer, LMarker,
  },
  data() {
    return {
      zoom: 15,
      center: latLng(47.41322, -1.219482),
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      selectedPosition: latLng(0,0)
    }
  },
  methods: {
    selectPosition(e) {
      this.selectedPosition = latLng(e.latlng.lat, e.latlng.lng)
      this.$emit('change', { lat: e.latlng.lat, lng: e.latlng.lng })
    }
  },
  mounted () {
    navigator.geolocation.getCurrentPosition(position => {
      const { latitude, longitude } = position.coords
      this.center = latLng(latitude, longitude)
    })
  },
}
</script>

<style>

</style>