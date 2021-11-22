
const _ = require( 'widentity' );

/* */

const utility = _.identity.Cui.Self();
const commandsAggregator = utility._commandsMake();
commandsAggregator.programPerform({ program : '.help' });

