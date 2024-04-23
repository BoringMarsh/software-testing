<template>
    <button @click="triangle()"> triangle </button>
    <button @click="calendar()"> calendar </button>
    <button @click="telephone()"> telephone </button>
    <button @click="computer()"> computer </button>

    <div v-for="item in response">
        <label > {{ item }} </label>
        <br>
    </div>
</template>

<script>
import { hwTriangle, hwCalendar, hwTelephone, hwComputer } from './axios/hw';

export default {
    name: 'App',
    data() {
        return {
            response: []
        }
    },
    methods: {
        triangle: function() {
            var that = this;

            hwTriangle({}).then(res => {
                console.log(res);
            }, err => {
                console.log(err);
            });
        },
        calendar: function() {
            var that = this;

            hwCalendar({}).then(res => {
                console.log(res);
            }, err => {
                console.log(err);
            });
        },
        telephone: function() {
            var that = this;

            hwTelephone({}).then(res => {
                console.log(res);
            }, err => {
                console.log(err);
            });
        },
        computer: function() {
            var that = this;

            hwComputer({}).then(res => {
                console.log(res);
            }, err => {
                console.log(err);
            });
        },
    }
}
</script>

<style>
#app {
    text-align: center;
}
</style>
