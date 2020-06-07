<template>
  <vue-dropzone ref="myVueDropzone" id="dropzone" :options="dropzoneOptions" :useCustomSlot="true" @vdropzone-success="fileAdded">
    <div class="dropzone-custom-content">
      <p><UploadIcon /> Arraste e solte a imagem aqui, ou clique para selecionar uma imagem</p>
    </div>
  </vue-dropzone>
</template>

<script>
import { UploadIcon } from 'vue-feather-icons'
import vue2Dropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
export default {
  components: {
    vueDropzone: vue2Dropzone , UploadIcon
  },
  methods: {
    fileAdded(file) {
      this.$emit('fileAdded', file)
    },
  },
  data() {
    return {
      dropzoneOptions: {
        url: 'https://httpbin.org/post',
        maxFilesize: 5,
        maxFiles: 1,
        headers: { "My-Awesome-Header": "header value" },
        acceptedFiles: 'image/*',
        addRemoveLinks: true,
      },
    }
  },
}
</script>

<style>

.dropzone {
  height: 300px;
  background: #E1FAEC;
  border-radius: 10px;

  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 48px;
  outline: 0;
  padding: 0;
}

.dropzone-custom-content,
.dz-message,
.dz-preview {
  width: 100%;
  height: 100%;
}
.dz-complete {
  margin: 0 !important;
}

.dz-image img {
  width: 100%;
  height: 100%; 
  object-fit: cover;
}

.dz-message p {
  margin: 30px;
  width: calc(100% - 60px);
  height: calc(100% - 60px);
  border-radius: 10px;
  border: 1px dashed #4ECB79;

  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: #333;
}

.dropzone-custom-content p svg {
  color: #4ECB79;
  width: 24px;
  height: 24px;
  margin-bottom: 8px;
}

</style>