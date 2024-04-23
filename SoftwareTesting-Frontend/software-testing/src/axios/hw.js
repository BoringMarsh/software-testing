import axios from "axios";

const hwInstance = axios.create({
    baseURL: "http://localhost:5000/api",
    timeout: 30000
});

hwInstance.interceptors.request.use(
    config => {
        return config;
    },
    error => {
        return Promise.reject(error);
    }
);

hwInstance.interceptors.response.use(
    response => {
        return response.data;
    },
    error => {
        return Promise.reject(error);
    }
);

export function hwTriangle(params) {
    return hwInstance.get("/hw/triangle", {
        params: params
    });
}

export function hwCalendar(params) {
    return hwInstance.get("/hw/calendar", {
        params: params
    });
}

export function hwTelephone(params) {
    return hwInstance.get("/hw/telephone", {
        params: params
    });
}

export function hwComputer(params) {
    return hwInstance.get("/hw/computer", {
        params: params
    });
}