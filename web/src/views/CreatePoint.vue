<template>
  <div id="page-create-point">
    <Header>
      <router-link to="/">
        <ArrowLeftIcon />
        Voltar para home
      </router-link>
    </Header>
    
    <ValidationObserver v-slot="{ handleSubmit }">
      <form @submit.prevent="handleSubmit(submitForm)" role="form" >
        <h1>Cadastro do <br/>ponto de coleta</h1>

        <Dropzone @fileAdded="selectFile"/>
        
        <fieldset>
          <legend>
            <h2>Dados</h2>
          </legend>

          <div class="field">
            <ValidationProvider name="name" rules="required" v-slot="{ errors }">
              <label for="name" :class="errors[0] ? 'has-danger':''">Nome da entidade</label>
              <base-input alternative
                          type="text"
                          class="modal-input"
                          v-model="name"
                          :error="errors[0]">
              </base-input>
            </ValidationProvider>
          </div>

          <div class="field-group">
            <div class="field">              
              <ValidationProvider name="email" rules="required|email" v-slot="{ errors }">
                <label for="email" :class="errors[0] ? 'has-danger':''">E-mail</label>     
                <base-input alternative
                            type="email"
                            name="email"
                            class="modal-input"
                            v-model="email"
                            :error="errors[0]">
                </base-input>
              </ValidationProvider>
            </div>
            <div class="field">
              <ValidationProvider name="whatsapp" rules="required" v-slot="{ errors }">
                <label for="whatsapp" :class="errors[0] ? 'has-danger':''">Whatsapp</label>
                <base-input alternative
                  type="text"
                  class="modal-input"
                  v-model="whatsapp"
                  :error="errors[0]">
                </base-input>
              </ValidationProvider>
            </div>
          </div>
        </fieldset>

        <fieldset>
          <legend>
            <h2>Endereço</h2>
            <span>Selecione o endereço no mapa</span>
          </legend>

          <Map @change="selectPosition"/>
          
          <div class="field-group">
            <div class="field">

              <ValidationProvider name="uf" rules="required" v-slot="{ errors }">
                <label for="uf" :class="{'has-danger': errors[0]}">Estado (UF)</label>

                <select name="uf" id="uf" v-model="selectedUF" @change="selectUF($event.target.value)" :class="{'has-danger': errors[0]}">
                  <option value="">Selecione um estado</option>
                  <option v-for="uf in ufs" :key="uf" :value="uf">{{ uf }}</option>
                </select>
                <div class="text-danger invalid-feedback" style="display: block;" v-if="errors[0]">
                    {{ errors[0] }}
                </div>
              </ValidationProvider>
            </div>
            <div class="field">
              <ValidationProvider name="city" rules="required" v-slot="{ errors }">
                <label for="city" :class="{'has-danger': errors[0]}">Cidade</label>
                <select name="city" id="city" v-model="selectedCity" :class="{'has-danger': errors[0]}">
                  <option value="">Selecione uma cidade</option>
                  <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
                </select>
                <div class="text-danger invalid-feedback" style="display: block;" v-if="errors[0]">
                  {{ errors[0] }}
                </div>
              </ValidationProvider>
            </div>
          </div>
        </fieldset>

          <fieldset>
            <legend>
              <h2>Itens de coleta</h2>
              <span>Selecione um ou mais itens abaixo</span>
            </legend>

            <ul class="items-grid">
              <li v-for="item in items" 
                :key="item.id" 
                :class="selectedItems.includes(item.id) ? 'selected' : ''"
                @click="selectItem(item.id)"
              >
                <img :src="item.image_url" :alt="item.title" />
              </li>
            </ul>
          </fieldset>

        <button type="submit">
          Cadastrar ponto de coleta
        </button>
      </form>
    </ValidationObserver>
  </div>
</template>
<script>
import { ArrowLeftIcon } from 'vue-feather-icons'

import { extend, ValidationObserver, ValidationProvider } from 'vee-validate';
import { required, email } from 'vee-validate/dist/rules';

extend('email', email);
extend('required', required);

import api, { buscaEstados, buscaCidades } from '../services/api'
import Header from "../components/Header"
import BaseInput from "../components/BaseInput"
import Dropzone from "../components/Dropzone"
import Map from "../components/Map"

export default {
  components: {
    Header, BaseInput, ArrowLeftIcon, ValidationObserver, ValidationProvider, Dropzone, Map
  },
  data() {
    return {   
      name: '',
      email: '',
      whatsapp: '',
      latitude: 0.0,
      longitude: 0.0,
      selectedFile: File,
      selectedUF: '',
      selectedCity: '',
      selectedItems: [],

      ufs: [],
      cities: [],
      items: [],
    }
  },
  methods: {
    selectFile(file) {
      this.selectedFile = file
      console.log(this.selectedFile)
    },
    selectPosition(latlng) {
      this.latitude = latlng.lat
      this.longitude = latlng.lng
    },
    selectUF(estado) {
      buscaCidades(estado).then(res => this.cities = Array.from(new Set(res.data.map((city) => city.nome))).sort())
    },
    selectItem(itemId) {
      const selected = this.selectedItems.findIndex(item => item === itemId)
      if (selected >= 0) {
        const filteredItems = this.selectedItems.filter(item => item !== itemId)
        this.selectedItems = filteredItems
      }
      else 
        this.selectedItems = [...this.selectedItems, itemId]
    },
    submitForm() {
      const data = new FormData()
      data.append('name', this.name)
      data.append('email', this.email)
      data.append('whatsapp', this.whatsapp)
      data.append('uf', this.selectedUF)
      data.append('city', this.selectedCity)
      data.append('latitude', String(this.latitude))
      data.append('longitude', String(this.longitude))
      data.append('items', this.selectedItems.join(','))
      if (this.selectedFile)
        data.append('image', this.selectedFile)

      api.post('points', data, {
        header : {
          'Content-Type' : 'multipart/form-data'
        }
      }).then(() => {
        this.$router.push('/')
      }).catch(error => {
        alert(error.response)
      });
    }
  },
  mounted () {
    api.get('/items').then((response) => {
      this.items = response.data
    })
    buscaEstados().then(res => this.ufs = res.data.map(uf => uf.sigla).sort())
  },
}
</script>
<style>
  @import url("https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css");


#page-create-point {
  width: 100%;
  max-width: 1100px;

  margin: 0 auto;
}

#page-create-point header {
  margin-top: 48px;

  display: flex;
  justify-content: space-between;
  align-items: center;
}

#page-create-point header a {
  color: var(--title-color);
  font-weight: bold;
  text-decoration: none;

  display: flex;
  align-items: center;
}

#page-create-point header a svg {
  margin-right: 16px;
  color: var(--primary-color);
}

#page-create-point form {
  margin: 80px auto;
  padding: 64px;
  max-width: 730px;
  background: #FFF;
  border-radius: 8px;

  display: flex;
  flex-direction: column;
}

#page-create-point form h1 {
  font-size: 36px;
}

#page-create-point form fieldset {
  margin-top: 64px;
  min-inline-size: auto;
  border: 0;
}

#page-create-point form legend {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 40px;
}

#page-create-point form legend h2 {
  font-size: 24px;
}

#page-create-point form legend span {
  font-size: 14px;
  font-weight: normal;
  color: var(--text-color);
}

#page-create-point form .field-group {
  flex: 1;
  display: flex;
}

#page-create-point form .field {
  flex: 1;

  display: flex;
  flex-direction: column;
  margin-bottom: 24px;
}

#page-create-point form .field span input[type=text],
#page-create-point form .field span input[type=email],
#page-create-point form .field span input[type=number] {
  flex: 1;
  background: #e9e9f5;
  border-radius: 8px;
  border: 0;
  padding: 16px 24px;
  font-size: 16px;
  color: #6C6C80;
  width: 100%;
}

#page-create-point form .field span select {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  flex: 1;
  background: #e9e9f5;
  border-radius: 8px;
  border: 0;
  padding: 16px 24px;
  font-size: 16px;
  color: #6C6C80;
  width: 100%;
}

#page-create-point form .field span input::placeholder {
  color: #A0A0B2;
}

#page-create-point form .field span label {
  font-size: 14px;
  margin-bottom: 8px;
}

.text-danger {
  font-size: 12px
}

#page-create-point form .field span :disabled {
  cursor: not-allowed;
}

#page-create-point form .field-group .field + .field {
  margin-left: 24px;
}

#page-create-point form .field-group input + input {
  margin-left: 24px;
}

#page-create-point form .field-check {
  flex-direction: row;
  align-items: center;
}

#page-create-point form .field-check input[type=checkbox] {
  background: #e9e9f5;
}

#page-create-point form .field-check label {
  margin: 0 0 0 8px;
}

#page-create-point form .leaflet-container {
  width: 100%;
  height: 350px;
  border-radius: 8px;
  margin-bottom: 24px;
}

#page-create-point form button {
  width: 260px;
  height: 56px;
  background: var(--primary-color);
  border-radius: 8px;
  color: #FFF;
  font-weight: bold;
  font-size: 16px;
  border: 0;
  align-self: flex-end;
  margin-top: 40px;
  transition: background-color 0.2s;
  cursor: pointer;
}

#page-create-point form button:hover {
  background: #2FB86E;
}

.items-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  list-style: none;
}

.items-grid li {
  background: #e9e9f5;
  border: 2px solid #e9e9f5;
  height: 180px;
  border-radius: 8px;
  padding: 32px 24px 16px;

  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;

  text-align: center;

  cursor: pointer;
}

.items-grid li span {
  flex: 1;
  margin-top: 12px;

  display: flex;
  align-items: center;
  color: var(--title-color)
}

.items-grid li.selected {
  background: #E1FAEC;
  border: 2px solid #34CB79;
}

.has-danger {
  border-color: #d9534f;
  color: #d9534f;
}
.text-danger {
  color: #d9534f;
}

select.has-danger,
.has-danger > input[type=email],
.has-danger > input[type=email]:active,
.has-danger > input[type=email]:focus,
.has-danger > input[type=text],
.has-danger > input[type=text]:active,
.has-danger > input[type=text]:focus {
  border: 2px solid #d9534f !important;
}

.input-group-alternative {
  margin-top: 8px
}
select {
  margin-top: 8px
}

</style>