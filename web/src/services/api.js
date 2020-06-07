import axios from 'axios'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL
})

export function buscaEstados() {
  return axios.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados')
}

export function buscaCidades(estado) {
  return axios.get(`https://servicodados.ibge.gov.br/api/v1/localidades/estados/${estado}/distritos`)
}

export default api