/**
 * Created with JetBrains WebStorm.
 * User: smile
 * Date: 13/06/13
 * Time: 16:42
 * To change this template use File | Settings | File Templates.
 */

var config = require('./Config')
var _ = require('lodash');
var gcm = require('node-gcm');
var pushAssociations = require('./PushAssociations');


var push = function (tokens, message) {
    gcmSender().send(message, tokens, 4, function (err, res) {
        if(err) console.log(err);

        if (res) {
            var mappedResults = _.map(_.zip(tokens, res.results), function (arr) {
                return _.merge({token: arr[0]}, arr[1]);
            });

            handleResults(mappedResults);
        }
    })
};

var handleResults = function (results) {
    var idsToUpdate = [],
        idsToDelete = [];

    results.forEach(function (result) {
        if (!!result.registration_id) {
            idsToUpdate.push({from: result.token, to: result.registration_id});

        } else if (result.error === 'InvalidRegistration' || result.error === 'NotRegistered') {
            idsToDelete.push(result.token);
        }
    });

    if (idsToUpdate.length > 0) pushAssociations.updateTokens(idsToUpdate);
    if (idsToDelete.length > 0) pushAssociations.removeDevices(idsToDelete);
};

var buildPayload = function (options) {
    return new gcm.Message(options);
};

var gcmSender = _.once(function() {
    return new gcm.Sender(config.get('gcm').apiKey);
});

module.exports = {
    push: push,
    buildPayload:buildPayload
}
