/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

var app = {
    pushNotification: {},
    // Application Constructor
    initialize: function(callback) {
        //alert("initializing");

        app.pushNotification = window.plugins.pushNotification;

        this.bindEvents(callback);
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function(callback) {
        document.addEventListener('deviceready', function() {
           app.onDeviceReady(); 
           if(callback) {
            callback();
           }
        }, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        // var parentElement = document.getElementById(id);
        // var listeningElement = parentElement.querySelector('.listening');
        // var receivedElement = parentElement.querySelector('.received');

        // listeningElement.setAttribute('style', 'display:none;');
        // receivedElement.setAttribute('style', 'display:block;');

        if(id == "deviceready") {
            app.handleDeviceReady(id);
        }
    },
    // Event handler for deviceready event
    handleDeviceReady: function(id) {
        //alert("handling deviceready");
        // if (device.platform == 'android' || device.platform == 'Android') {
        //     //alert("Register called");
        //     pushNotification.register(this.successHandler, this.errorHandler,{"senderID":"1047272876473","ecb":"app.onNotificationGCM"});
        // }
        // else {
        //     //alert("Register called");
        //     pushNotification.register(this.successHandler,this.errorHandler,{"badge":"true","sound":"true","alert":"true","ecb":"app.onNotificationAPN"});
        // }
    },
    registerUser: function() {
        //alert("Registering User from index.js");
        if (device.platform == 'android' || device.platform == 'Android') {
            //alert("Register called");
            app.pushNotification.register(app.successHandler, app.errorHandler,{"senderID":"1047272876473","ecb":"app.onNotificationGCM"});
        }
        else {
            //alert("Register called");
            app.pushNotification.register(app.successHandler, app.errorHandler,{"badge":"true","sound":"true","alert":"true","ecb":"app.onNotificationAPN"});
        }
    },
    // result contains any message sent from the plugin call
    successHandler: function(result) {
        //alert('Callback Success! Result = '+result)
    },
    errorHandler:function(error) {
        //alert(error);
    },
    onNotificationGCM: function(e) {
        //alert("handling GCM");
        switch( e.event )
        {
            case 'registered':
                if ( e.regid.length > 0 ) {
                    if (localStorage.getItem("hasRegistered")) {
                        // if hasRegistered has been set:
                        // do nothing! we're ready to do other PN stuff, though
                    } else {
                        // save regid to local storage for future use
                        localStorage.setItem("regID", e.regid);

                        //console.log("Regid " + e.regid);
                        //alert('Registration id = '+e.regid);
                        // now send HTTP POST to server with regid and user info
                        $.post("http://137.159.150.222:8000/subscribe",
                        {
                            user: localStorage.getItem("userName"),
                            type: "Android",
                            token: e.regid
                        },
                        function(data,status){
                            if (status == "success") {
                                localStorage.setItem("hasRegistered", true);
                            }
                            //alert("Data: " + data + "\nStatus: " + status);
                        });
                    }
                }
            break;
 
            case 'message':
              // this is the actual push notification. its format depends on the data model from the push server
              alert('PN: '+e.message);
            break;
 
            case 'error':
              alert('GCM error = '+e.msg);
            break;
 
            default:
              alert('An unknown GCM event has occurred');
              break;
        }
    },
    onNotificationAPN: function(event) {
        alert("Running in JS - onNotificationAPN - Received a notification! " + event.alert);
        
        if (event.alert) {
            navigator.notification.alert(event.alert);
        }
        if (event.badge) {
            app.pushNotification.setApplicationIconBadgeNumber(this.successHandler, this.errorHandler, event.badge);
        }
        if (event.sound) {
            var snd = new Media(event.sound);
            snd.play();
        }
    }
};
