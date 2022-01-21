( function _Cui_s_()
{

'use strict';

//

const _ = _global_.wTools;
const Parent = null;
const Self = wIdentityCui;
function wIdentityCui( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Cui';

// --
// inter
// --

function init( o )
{
  let cui = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( cui );
  Object.preventExtensions( cui );

  if( o )
  cui.copy( o );
}

//

function Exec()
{
  let cui = new this.Self();
  return cui.exec();
}

//

function exec()
{
  let cui = this;

  _.assert( arguments.length === 0 );

  let appArgs = _.process.input();
  let ca = cui._commandsMake();

  return _.Consequence.Try( () =>
  {
    return ca.programPerform({ program : appArgs.original });
  })
  .catch( ( err ) =>
  {
    _.process.exitCode( -1 );
    logger.error( _.errOnce( err ) );
    _.procedure.terminationBegin();
    _.process.exit();
    return err;
  });
}

// --
// meta commands
// --

function _commandsMake( context )
{
  const cui = this;

  _.assert( _.instanceIs( cui ) );

  if( arguments.length === 1 )
  _.assert( _.instanceIs( context ) );
  else
  _.assert( arguments.length === 0 );

  context = context || cui;

  let commands =
  {
    'help' :                    { ro : _.routineJoin( context, cui.commandHelp ) },
    'version' :                 { ro : _.routineJoin( context, cui.commandVersion ) },
    'imply' :                   { ro : _.routineJoin( context, cui.commandImply ) },

    'identity list' :           { ro : _.routineJoin( context, cui.commandIdentityList ) },
    'identity copy' :           { ro : _.routineJoin( context, cui.commandIdentityCopy ) },
    'identity set' :            { ro : _.routineJoin( context, cui.commandIdentitySet ) },
    'identity new' :            { ro : _.routineJoin( context, cui.commandIdentityNew ) },
    'super identity new' :      { ro : _.routineJoin( context, cui.commandSuperIdentityNew ) },
    'git identity new' :        { ro : _.routineJoin( context, cui.commandGitIdentityNew ) },
    'github identity new' :     { ro : _.routineJoin( context, cui.commandGithubIdentityNew ) },
    'bitbucket identity new' :  { ro : _.routineJoin( context, cui.commandBitbucketIdentityNew ) },
    'npm identity new' :        { ro : _.routineJoin( context, cui.commandNpmIdentityNew ) },
    'identity from git' :       { ro : _.routineJoin( context, cui.commandIdentityFromGit ) },
    'identity from ssh' :       { ro : _.routineJoin( context, cui.commandIdentityFromSsh ) },
    'identity remove' :         { ro : _.routineJoin( context, cui.commandIdentityRemove ) },
    'git identity script' :     { ro : _.routineJoin( context, cui.commandGitIdentityScript ) },
    'npm identity script' :     { ro : _.routineJoin( context, cui.commandNpmIdentityScript ) },
    'ssh identity script' :     { ro : _.routineJoin( context, cui.commandSshIdentityScript ) },
    'git identity script set' : { ro : _.routineJoin( context, cui.commandGitIdentityScriptSet ) },
    'npm identity script set' : { ro : _.routineJoin( context, cui.commandNpmIdentityScriptSet ) },
    'ssh identity script set' : { ro : _.routineJoin( context, cui.commandSshIdentityScriptSet ) },
    'super identity use' :      { ro : _.routineJoin( context, cui.commandSuperIdentityUse ) },
    'git identity use' :        { ro : _.routineJoin( context, cui.commandGitIdentityUse ) },
    'npm identity use' :        { ro : _.routineJoin( context, cui.commandNpmIdentityUse ) },
    'ssh identity use' :        { ro : _.routineJoin( context, cui.commandSshIdentityUse ) },
  };

  const ca = _.CommandsAggregator
  ({
    basePath : _.path.current(),
    commands,
    commandsImplicitDelimiting : 1,
  });
  ca.form();

  ca.logger.verbosity = 0;

  return ca;
}

//

function _command_head( o )
{
  let cui = this;

  if( arguments.length === 2 )
  o = { routine : arguments[ 0 ], args : arguments[ 1 ] }

  _.routine.options_( _command_head, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( o.args.length === 1 );

  let e = o.args[ 0 ];

  _.sure( _.map.is( e.propertiesMap ), () => 'Expects map, but got ' + _.entity.exportStringDiagnosticShallow( e.propertiesMap ) );
  if( o.routine.command.properties && !o.propertiesMapAsProperty )
  _.map.sureHasOnly( e.propertiesMap, o.routine.command.properties, `Command does not expect options:` );

  if( o.propertiesMapAsProperty )
  {
    let propertiesMap = Object.create( null );
    if( e.propertiesMap )
    propertiesMap[ o.propertiesMapAsProperty ] = e.propertiesMap;
    e.propertiesMap = propertiesMap;
  }

  if( cui.implied )
  {
    if( cui.implied.profile )
    cui.implied.profileDir = cui.implied.profile;

    if( o.routine.defaults )
    _.props.extend( e.propertiesMap, _.mapOnly_( null, cui.implied, o.routine.defaults ) );
    else
    _.props.extend( e.propertiesMap, cui.implied );
  }

  if( _.boolLikeFalse( o.routine.command.subjectHint ) )
  if( e.subject.trim() !== '' )
  throw _.errBrief
  (
    `Command .${e.phraseDescriptor.phrase} does not expect subject`
    + `, but got "${e.subject}"`
  );

  if( o.routine.defaults && !o.propertiesMapAsProperty )
  _.routine.options( o.routine, e.propertiesMap );

  if( o.routine.command.properties && o.routine.command.properties.profile )
  if( e.propertiesMap.profile !== undefined )
  {
    e.propertiesMap.profileDir = e.propertiesMap.profile;
    delete e.propertiesMap.profile;
  }

  if( o.routine.command.properties && o.routine.command.properties.v
      || o.routine.defaults && o.routine.defaults.verbosity )
  if( e.propertiesMap.v !== undefined && e.propertiesMap.v !== null )
  {
    e.propertiesMap.verbosity = e.propertiesMap.v;
    delete e.propertiesMap.v;
  }

  if( o.routine.command.properties && o.routine.command.properties.storage
      || o.routine.defaults && o.routine.defaults.storage )
  if( e.propertiesMap.storage !== undefined )
  {
    e.propertiesMap.storageTerminal = e.propertiesMap.storage;
    delete e.propertiesMap.storage;
  }
}

_command_head.defaults =
{
  routine : null,
  args : null,
  propertiesMapAsProperty : 0,
}

// --
// general commands
// --

function commandHelp( e )
{
  let cui = this;
  let ca = e.aggregator;

  ca._commandHelp( e );

  return cui;
}

var command = commandHelp.command = Object.create( null );
command.hint = 'Get help.';

//

function commandVersion( e )
{
  let cui = this;

  cui._command_head( commandVersion, arguments );

  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'widentity!alpha',
  });
}

var command = commandVersion.command = Object.create( null );
command.hint = 'Get information about version.';
command.subjectHint = false;

//

function commandImply( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui.implied = null;

  cui._command_head( commandImply, arguments );

  cui.implied = e.propertiesMap;

}

var command = commandImply.command = Object.create( null );
command.hint = 'Change state or imply value of a variable.';
command.subjectHint = false;

//

function commandIdentityList( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityList, args : arguments });

  e.propertiesMap.selector = '';
  const list =_.identity.identityGet( e.propertiesMap );
  logger.log( 'List of identities :' );
  logger.log( _.entity.exportStringNice( list ? list : '{-no identies found-}' ) );
}
commandIdentityList.defaults =
{
  profileDir : 'default',
};
var command = commandIdentityList.command = Object.create( null );
command.subjectHint = false;
command.hint = 'List all identies.';
command.longHint = 'List all identies. Prints identity names and identity data.';

//

function commandIdentityCopy( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityCopy, args : arguments });

  const identityNames = _.strSplit({ src : e.subject, preservingDelimeters : 0 });
  _.sure( identityNames.length === 2, 'Expects names of src and dst identities' );
  e.propertiesMap.identitySrcName = identityNames[ 0 ];
  e.propertiesMap.identityDstName = identityNames[ 1 ];
  e.propertiesMap = _.mapOnly_( null, e.propertiesMap, _.identity.identityCopy.defaults );
  return _.identity.identityCopy( e.propertiesMap );
}

commandIdentityCopy.defaults =
{
  profileDir : 'default',
};
var command = commandIdentityCopy.command = Object.create( null );
command.subjectHint = 'Names of source and destination identities.';
command.hint = 'Copy data of source identity to destination identity.';
command.longHint = 'Copy data of source identity to destination identity. Accepts identity names.\n\t"identity .identity.copy \'src.user\' \'dst.user\'" - copy data from identity `src.user` to `dst.user`.\n\t"identity .identity.copy \'src.user\' \'dst.user\' force:1" - will overwrite identity `dst.user` if it exists.';
command.properties =
{
  'force' : 'Copy identity force. Overwrites existed destination identity. Default is false.'
};

//

function commandIdentitySet( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentitySet, args : arguments, propertiesMapAsProperty : 'set' });

  _.sure
  (
    _.map.is( e.propertiesMap.set ) && _.entity.lengthOf( e.propertiesMap.set ),
    'Expects one or more pair "key:value" to append to the identity.'
  );
  _.map.sureHasOnly( e.propertiesMap.set, commandIdentitySet.command.properties );

  if( 'force' in e.propertiesMap.set )
  {
    e.propertiesMap.force = e.propertiesMap.set.force;
    delete e.propertiesMap.set.force;
  }

  e.propertiesMap.selector = e.subject;
  return _.identity.identitySet( e.propertiesMap );
}

commandIdentitySet.defaults =
{
  profileDir : 'default',
};

var command = commandIdentitySet.command = Object.create( null );
command.subjectHint = 'A name of identity.';
command.hint = 'Modify an existed identity.';
command.longHint = 'Modify an existed identity. By default, can\'t create new identity.\n\t"identity .identity.set user \'git.login:user\'" - extend identity `user` by field \'git.login\'.\n\t"identity .identity.set user \'git.login:user\' force:1" - extend identity `user` by field \'git.login\', if identity `user` does not exists, command will create new identity.';
command.properties =
{
  'identities' : 'A map of identities for superidentity.',
  'login' : 'An identity login ( user name ) that is used for all identity scripts if no specifique login defined.',
  'email' : 'An email that is used for all identity scripts if no specifique email defined.',
  'token' : 'A token that is used for all identity scripts if no specifique token defined.',
  'type' : 'A type of identity. Define a way to setup identity data. Can be `git`, `npm`, `rust`, `general`. Default is `general`.',
  'git.login' : 'An identity login ( user name ) that is used for git script. It has priority over property `login`.',
  'git.email' : 'An email that is used for git script. It has priority over property `email`.',
  'git.token' : 'A token that is used for git script. It has priority over property `token`.',
  'npm.login' : 'An identity login ( user name ) that is used for npm script. It has priority over property `login`.',
  'npm.email' : 'An email that is used for npm script. It has priority over property `email`.',
  'npm.token' : 'A token that is used for npm script. It has priority over property `token`.',
  'rust.login' : 'An identity login ( user name ) that is used for rust script. It has priority over property `login`.',
  'rust.email' : 'An email that is used for rust script. It has priority over property `email`.',
  'rust.token' : 'A token that is used for rust script. It has priority over property `token`.',
  'default' : 'Use as default identity for all actions. Default is false.',
  'services' : 'An array with services for identity.',
  'force' : 'Allow to create new identity if identity does not exists. Default is false.',
};

//

function commandIdentityNew( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityNew, args : arguments, propertiesMapAsProperty : 'identity' });

  _.sure
  (
    _.map.is( e.propertiesMap.identity ) && _.entity.lengthOf( e.propertiesMap.identity ),
    'Expects one or more pair "key:value" to append to the identity.'
  );
  _.map.sureHasOnly( e.propertiesMap.identity, commandIdentityNew.command.properties );

  if( 'force' in e.propertiesMap.identity )
  {
    e.propertiesMap.force = e.propertiesMap.identity.force;
    delete e.propertiesMap.identity.force;
  }

  e.propertiesMap.identity.name = e.subject;
  return _.identity.identityNew( e.propertiesMap );
}

commandIdentityNew.defaults =
{
  profileDir : 'default',
};

var command = commandIdentityNew.command = Object.create( null );
command.subjectHint = 'A name of identity.';
command.hint = 'Create new identity.';
command.longHint = 'Create new identity. By default, can\'t rewrite existed identities.\n\t"identity .identity.new user login:user email:user@domain.com type:git" - create new git identity with name `user`.\n\t"identity .identity.new user \'git.login\':user \'git.email\':user@domain.com type:git force:1" - will extend identity `user` if it exists, otherwise, will create new identity.';
command.properties =
{
  ... commandIdentitySet.command.properties,
  'force' : 'Allow to extend identity if identity exists. Default is false.'
};

//

function commandSuperIdentityNew( e )
{
  const cui = this;

  cui._command_head({ routine : commandSuperIdentityNew, args : arguments, propertiesMapAsProperty : 'identities' });

  _.sure
  (
    _.mapIs( e.propertiesMap.identities ) && _.entity.lengthOf( e.propertiesMap.identities ),
    'Expects one or more pair "key:value" to append to the config'
  );

  if( 'force' in e.propertiesMap.identities )
  {
    e.propertiesMap.force = e.propertiesMap.identities.force;
    delete e.propertiesMap.identities.force;
  }

  const identity = Object.create( null );
  identity.name = e.subject;
  identity.type = 'super';
  identity.identities = e.propertiesMap.identities;
  delete e.propertiesMap.identities;
  e.propertiesMap.identity = identity;
  return _.identity.identityNew( e.propertiesMap );
}

commandSuperIdentityNew.defaults =
{
  profileDir : 'default',
};

var command = commandSuperIdentityNew.command = Object.create( null );
command.subjectHint = 'A name of identity.';
command.hint = 'Create new superidentity.';
command.longHint = 'Create new super identity. By default, can\'t rewrite existed identities.\n\t"identity .super.identity.new user user2:true" - create new superidentity with name `user`.\n\t"identity .super.identity.new user user2:false force:1" - will extend identity `user` if it exists, otherwise, will create new super identity.';
command.properties =
{
};

//

function _commandIdentityNew_functor( type )
{
  const routine = identityNew;
  routine.defaults =
  {
    profileDir : 'default',
  };

  var command = routine.command = Object.create( null );
  command.subjectHint = 'A name of identity.';
  command.hint = `Create new ${ type } identity.`;
  command.longHint = `Create new ${ type } identity. By default, can\'t rewrite existed identities.`
  + `\n\t"identity .${ type }.identity.new user login:user email:user@domain.com" - create new npm identity with name 'user'.`
  + `\n\t"identity .${ type }.identity.new user login:user email:user@domain.com force:1" - will extend identity 'user' if it `
  + `exists, otherwise, will create new ${ type } identity.`;
  command.properties =
  {
    'login' : `An identity ${ type } login ( user name ) that is used for git script.`,
    'email' : `An email that is used for ${ type } script.`,
    'token' : 'A token that is used for git script.',
    'force' : 'Create new identity force. Overwrites existed identity. Default is false.'
  };

  return routine;

  /* */

  function identityNew( e )
  {
    let cui = this;
    let ca = e.aggregator;

    cui._command_head({ routine, args : arguments, propertiesMapAsProperty : 'identity' });

    _.sure
    (
      _.mapIs( e.propertiesMap.identity ) && _.entity.lengthOf( e.propertiesMap.identity ),
      'Expects one or more pair "key:value" to append to the config'
    );
    _.map.sureHasOnly( e.propertiesMap.identity, routine.command.properties );

    if( 'force' in e.propertiesMap.identity )
    {
      e.propertiesMap.force = e.propertiesMap.identity.force;
      delete e.propertiesMap.identity.force;
    }

    for( let key in e.propertiesMap.identity )
    {
      e.propertiesMap.identity[ `${ type }.${ key }` ] = e.propertiesMap.identity[ key ];
      delete e.propertiesMap.identity[ key ];
    }
    e.propertiesMap.identity.name = e.subject;
    e.propertiesMap.identity.type = type;
    return _.identity.identityNew( e.propertiesMap );
  }
}

//

const commandGitIdentityNew = _commandIdentityNew_functor( 'git' );

//

const commandGithubIdentityNew = _commandIdentityNew_functor( 'github' );

//

const commandBitbucketIdentityNew = _commandIdentityNew_functor( 'bitbucket' );

//

const commandNpmIdentityNew = _commandIdentityNew_functor( 'npm' );

//

function commandIdentityFromGit( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityFromGit, args : arguments });

  e.propertiesMap.selector = e.subject || null;
  e.propertiesMap.type = 'git';
  return _.identity.identityFrom( e.propertiesMap );
}

commandIdentityFromGit.defaults =
{
  profileDir : 'default',
  force : true,
};

var command = commandIdentityFromGit.command = Object.create( null );
command.subjectHint = 'A name of destination identity.';
command.hint = 'Create new git identity.';
command.longHint = 'Create new git identity. By default, can\'t rewrite existed identities.\n\t"identity .identity.from.git user" - will create new git identity from global git config.\n\t"identity .identity.from.git user force:1" - will extend identity `user` if it exists, otherwise, will create new git identity.';
command.properties =
{
  'force' : 'Allow to extend identity if the identity exists. Default is false.'
};

//

function commandIdentityFromSsh( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityFromSsh, args : arguments });

  e.propertiesMap.selector = e.subject || null;
  e.propertiesMap.type = 'ssh';
  return _.identity.identityFrom( e.propertiesMap );
}

commandIdentityFromSsh.defaults =
{
  profileDir : 'default',
  force : false,
};

var command = commandIdentityFromSsh.command = Object.create( null );
command.subjectHint = 'A name of destination identity.';
command.hint = 'Create new ssh identity.';
command.longHint = 'Create new ssh identity. By default, can\'t rewrite existed identities.\n\t"identity .identity.from.ssh user" - will create new ssh identity from current ssh keys storage.\n\t"identity .identity.from.ssh user force:1" - will extend identity `user` if it exists, otherwise, will create new ssh identity.';
command.properties =
{
  'force' : 'Allow to extend identity if the identity exists. Default is false.'
};

//

function commandIdentityRemove( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityRemove, args : arguments });

  e.propertiesMap.selector = e.subject;
  e.propertiesMap = _.mapOnly_( null, e.propertiesMap, _.identity.identityDel.defaults );
  return _.identity.identityDel( e.propertiesMap );
}
commandIdentityRemove.defaults =
{
  profileDir : 'default',
};
var command = commandIdentityRemove.command = Object.create( null );
command.subjectHint = 'A name of identity to remove. Could be selectors.';
command.hint = 'Remove identity.';
command.longHint = 'Remove identity by name.\n\t"identity .identity.remove user" - will remove identity `user`.\n\t"identity .identity.remove user*" - will remove all identities which starts with `user`.';

//

function commandGitIdentityScript( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandGitIdentityScript, args : arguments });

  e.propertiesMap.type = 'git';
  const script = _.censor.profileHookGet( e.propertiesMap );
  logger.log( script );
}
commandGitIdentityScript.defaults =
{
  profileDir : 'default',
};
var command = commandGitIdentityScript.command = Object.create( null );
command.subjectHint = false;
command.hint = 'Get profile git script.';
command.longHint = 'Get profile git script.\n\t"identity .git.identity.script" - will print git script of default profile.';

//

function commandNpmIdentityScript( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandNpmIdentityScript, args : arguments });

  e.propertiesMap.type = 'npm';
  const script = _.censor.profileHookGet( e.propertiesMap );
  logger.log( script );
}
commandNpmIdentityScript.defaults =
{
  profileDir : 'default',
};
var command = commandNpmIdentityScript.command = Object.create( null );
command.subjectHint = false;
command.hint = 'Get profile npm script.';
command.longHint = 'Get profile npm script.\n\t"identity .npm.identity.script" - will print npm script of default profile.';

//

function commandSshIdentityScript( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandSshIdentityScript, args : arguments });

  e.propertiesMap.type = 'ssh';
  const script = _.censor.profileHookGet( e.propertiesMap );
  logger.log( script );
}
commandSshIdentityScript.defaults =
{
  profileDir : 'default',
};
var command = commandSshIdentityScript.command = Object.create( null );
command.subjectHint = false;
command.hint = 'Get profile ssh script.';
command.longHint = 'Get profile ssh script.\n\t"identity .ssh.identity.script" - will print ssh script of default profile.';

//

function commandGitIdentityScriptSet( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandGitIdentityScriptSet, args : arguments });

  e.propertiesMap.hook = e.subject;
  e.propertiesMap.type = 'git';
  return _.censor.profileHookSet( e.propertiesMap );
}
commandGitIdentityScriptSet.defaults =
{
  profileDir : 'default',
};
var command = commandGitIdentityScriptSet.command = Object.create( null );
command.subjectHint = 'A script to set.';
command.hint = 'Imply profile script to set git config.';
command.longHint = 'Imply profile script to set git config. Accepts js script data.\n\t"identity .git.identity.script.set $(cat script.js)" - will set `script.js` as default git script for default profile (example is valid for Unix-like OSs).';

//

function commandNpmIdentityScriptSet( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandNpmIdentityScriptSet, args : arguments });

  e.propertiesMap.hook = e.subject;
  e.propertiesMap.type = 'npm';
  return _.censor.profileHookSet( e.propertiesMap );
}

commandNpmIdentityScriptSet.defaults =
{
  profileDir : 'default',
};
var command = commandNpmIdentityScriptSet.command = Object.create( null );
command.subjectHint = 'A script to set.';
command.hint = 'Imply profile script to set npm config.';
command.longHint = 'Imply profile script to set npm config. Accepts js script data.\n\t"identity .npm.identity.script.set $(cat script.js)" - will set `script.js` as default npm script for default profile (example is valid for Unix-like OSs).';

//

function commandSshIdentityScriptSet( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandSshIdentityScriptSet, args : arguments });

  e.propertiesMap.hook = e.subject;
  e.propertiesMap.type = 'ssh';
  return _.censor.profileHookSet( e.propertiesMap );
}

commandSshIdentityScriptSet.defaults =
{
  profileDir : 'default',
};
var command = commandSshIdentityScriptSet.command = Object.create( null );
command.subjectHint = 'A script to set.';
command.hint = 'Imply profile script to set ssh keys.';
command.longHint = 'Imply profile script to set ssh keys. Accepts js script data.\n\t"identity .ssh.identity.script.set $(cat script.js)" - will set `script.js` as default ssh script for default profile (example is valid for Unix-like OSs).';

//

function commandSuperIdentityUse( e )
{
  const cui = this;

  cui._command_head({ routine : commandSuperIdentityUse, args : arguments });

  e.propertiesMap.logger = e.propertiesMap.verbosity;
  delete e.propertiesMap.verbosity;
  e.propertiesMap.selector = e.subject;
  e.propertiesMap.type = 'super';
  return _.identity.identityUse( e.propertiesMap );
}
commandSuperIdentityUse.defaults =
{
  profileDir : 'default',
  verbosity : 4,
};
var command = commandSuperIdentityUse.command = Object.create( null );
command.subjectHint = 'A name of identity to use.';
command.hint = 'Set configs for each subidentity using subidentity data.';
command.longHint = 'Set configs using subidentity data.\n\t"identity .super.identity.use user" - will configure configs using subidentities of identity `user`.';

//

function commandGitIdentityUse( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandGitIdentityUse, args : arguments });

  e.propertiesMap.logger = e.propertiesMap.verbosity;
  delete e.propertiesMap.verbosity;
  e.propertiesMap.selector = e.subject;
  e.propertiesMap.type = 'git';
  return _.identity.identityUse( e.propertiesMap );
}
commandGitIdentityUse.defaults =
{
  profileDir : 'default',
  verbosity : 4,
};
var command = commandGitIdentityUse.command = Object.create( null );
command.subjectHint = 'A name of identity to use.';
command.hint = 'Set git configs using identity data.';
command.longHint = 'Set git configs using identity data.\n\t"identity .git.identity.use user" - will configure git using identity `user` script and data.';

//

function commandNpmIdentityUse( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandNpmIdentityUse, args : arguments });

  e.propertiesMap.logger = e.propertiesMap.verbosity;
  delete e.propertiesMap.verbosity;
  e.propertiesMap.selector = e.subject;
  e.propertiesMap.type = 'npm';
  return _.identity.identityUse( e.propertiesMap );
}
commandNpmIdentityUse.defaults =
{
  profileDir : 'default',
  verbosity : 4,
};
var command = commandNpmIdentityUse.command = Object.create( null );
command.subjectHint = 'A name of identity to use.';
command.hint = 'Set npm configs using identity data.';
command.longHint = 'Set npm configs using identity data.\n\t"identity .npm.identity.use user" - will configure npm using identity `user` script and data.';

//

function commandSshIdentityUse( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandSshIdentityUse, args : arguments });

  e.propertiesMap.logger = e.propertiesMap.verbosity;
  delete e.propertiesMap.verbosity;
  e.propertiesMap.selector = e.subject;
  e.propertiesMap.type = 'ssh';
  return _.identity.identityUse( e.propertiesMap );
}
commandSshIdentityUse.defaults =
{
  profileDir : 'default',
  verbosity : 4,
};
var command = commandSshIdentityUse.command = Object.create( null );
command.subjectHint = 'A name of identity to use.';
command.hint = 'Set ssh keys using identity data.';
command.longHint = 'Set ssh keys using identity data.\n\t"identity .ssh.identity.use user" - will configure ssh using identity `user` script and data.';

// --
// relations
// --

let Composes =
{
};

let Aggregates =
{
};

let Associates =
{
};

let Restricts =
{
  implied : _.define.own( {} ),
};

let Statics =
{
  Exec,
};

let Forbids =
{
};

// --
// declare
// --

let Extension =
{
  // inter

  init,
  Exec,
  exec,

  // meta commands

  _commandsMake,
  _command_head,

  // general commands

  commandHelp,
  commandVersion,
  commandImply,

  //

  commandIdentityList,
  commandIdentityCopy,
  commandIdentitySet,

  commandIdentityNew,
  commandSuperIdentityNew,
  commandGitIdentityNew,
  commandGithubIdentityNew,
  commandBitbucketIdentityNew,
  commandNpmIdentityNew,

  commandIdentityFromGit,
  commandIdentityFromSsh,
  commandIdentityRemove,
  commandGitIdentityScript,
  commandNpmIdentityScript,
  commandSshIdentityScript,
  commandGitIdentityScriptSet,
  commandNpmIdentityScriptSet,
  commandSshIdentityScriptSet,
  commandSuperIdentityUse,
  commandGitIdentityUse,
  commandNpmIdentityUse,
  commandSshIdentityUse,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.identity[ Self.shortName ] = Self;
if( !module.parent )
Self.Exec();

})();
