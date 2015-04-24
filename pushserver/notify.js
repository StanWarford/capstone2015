var pushAssociations = require("./PushAssociations");
var _ = require("lodash");
var push = require('./PushController');

exports.sendNotifications = function(notifs) {
    notifs.forEach(function (notif) {

        var users = notif.users,
            androidPayload = notif.android,
            iosPayload = notif.ios,
            target;

        if (androidPayload && iosPayload) {
            target = 'all'
        } else if (iosPayload) {
            target = 'ios'
        } else if (androidPayload) {
            target = 'android';
        }

        var fetchUsers = users ? pushAssociations.getForUsers : pushAssociations.getAll,
            callback = function (err, pushAssociations) {

                
                if (err) {
                    console.log("In the calback! with ERROR: " + err);
                    return;
                }

                if (target !== 'all') {
                    // TODO: do it in mongo instead of here ...
                    pushAssociations = _.where(pushAssociations, {'type': target});
                }
                push.send(pushAssociations, androidPayload, iosPayload);
            },
            args = users ? [users, callback] : [callback];

        // TODO: optim. -> mutualise user fetching ?
        fetchUsers.apply(null, args);
    });

    return true;
}