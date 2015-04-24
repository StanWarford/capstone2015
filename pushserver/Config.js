/**
 * Created with JetBrains WebStorm.
 * User: smile
 * Date: 17/06/13
 * Time: 12:03
 * To change this template use File | Settings | File Templates.
 */
var _ = require('lodash');

var config;

var initialize = _.once(function (configFilePath, overrides) {
    config = _.merge({}, require(configFilePath), overrides);

    // Replace any "process.env.*" by its corresponding value
    _.forOwn(config, function(value, key){
        var env = /^process\.env\.(.+)$/.exec(value);
        if(env) {
          config[key] = process.env[env[1]];
        }
    });

    return config;
});

var get = function (key) {
    if (!config) initialize('../config.json');
    return config[key];
};

module.exports = {
    initialize: initialize,
    get: get
}