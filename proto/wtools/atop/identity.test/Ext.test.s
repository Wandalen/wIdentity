( function _Ext_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../identity/entry/Include.s' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = __.path.tempOpen( __.path.join( __dirname, '../..' ), 'identity' );
  context.appJsPath = __.path.join( __dirname, '../identity/entry/Exec' );
}

//

function onSuiteEnd()
{
  let context = this;
  __.assert( __.strHas( context.suiteTempPath, '/identity' ) )
  __.path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function identityList( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'list no identities';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.list` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, 'List of identities :\n{-no identies found-}\n' );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'list identities';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` )
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin type:git` )
  a.appStart( `.imply profile:${profile} .identity.list` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of identities :' ), 1 );
    test.identical( _.strCount( op.output, 'user :' ), 1 );
    test.identical( _.strCount( op.output, 'user2 :' ), 1 );
    test.identical( _.strCount( op.output, 'login : userLogin' ), 2 );
    test.identical( _.strCount( op.output, 'type : git' ), 2 );
    return null;
  });

  /* - */

  return a.ready;
}

//

function identityCopy( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'copy identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .identity.copy user user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function identitySet( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'rewrite all fields of identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.set user login:user type:npm` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : user, type : npm }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'rewrite one field of identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.set user login:user` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : user, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'extend identity by new fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.set user 'npm.login':user` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git, npm.login : user }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function identityNew( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login and type';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin type:git` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login, type and user fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user3 login:userLogin type:git email:user@domain.com token:123` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user3` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'login : userLogin,' ), 1 );
    test.identical( _.strCount( op.output, 'type : git,' ), 1 );
    test.identical( _.strCount( op.output, 'email : user@domain.com,' ), 1 );
    test.identical( _.strCount( op.output, 'token : 123' ), 1 );
    return null;
  });

  /* - */

  a.appStartNonThrowing( `.imply profile:${profile} .identity.new user login:userLogin` )
  .then( ( op ) =>
  {
    test.case = 'declared no type';
    test.notIdentical( op.exitCode, 0 );
    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function gitIdentityNew( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user login:userLogin` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ git.login : userLogin, type : git }' ), 1 );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login, user fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user2 login:userLogin email:user@domain.com token:123` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'git.login : userLogin,' ), 1 );
    test.identical( _.strCount( op.output, 'type : git' ), 1 );
    test.identical( _.strCount( op.output, 'git.email : user@domain.com,' ), 1 );
    test.identical( _.strCount( op.output, 'git.token : 123' ), 1 );
    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function npmIdentityNew( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login';
    return null;
  });

  a.appStart( `.imply profile:${profile} .npm.identity.new user login:userLogin` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ npm.login : userLogin, type : npm }' ), 1 );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login, user fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user2 login:userLogin email:user@domain.com token:123` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'git.login : userLogin,' ), 1 );
    test.identical( _.strCount( op.output, 'type : git' ), 1 );
    test.identical( _.strCount( op.output, 'git.email : user@domain.com,' ), 1 );
    test.identical( _.strCount( op.output, 'git.token : 123' ), 1 );
    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function identityFromGit( test )
{
  let a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true );

  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  a.fileProvider.dirMake( a.abs( '.' ) );

  const originalConfig = a.fileProvider.fileRead( a.fileProvider.configUserPath( '.gitconfig' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'create new identity from git';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` );
  a.appStart( `.imply profile:${profile} .config.get identity/git` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.from.git git` )
  a.appStart( `.imply profile:${profile} .config.get identity/git` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ type : git, git.login : userLogin, git.email : user@domain.com }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'extend existed identity, force - 1';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin email:'user@domain.com' type:git` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, email : user@domain.com, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.from.git user force:1` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'login : userLogin' ), 2 );
    test.identical( _.strCount( op.output, 'email : user@domain.com' ), 2 );
    test.identical( _.strCount( op.output, 'type : git' ), 1 );
    test.identical( _.strCount( op.output, 'git.login : userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'git.email : user@domain.com' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( () =>
  {
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), originalConfig );
    return null;
  })

  /* - */

  return a.ready;
}

//

function identityFromSsh( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  let a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profile }` );
  let originalExists = false;
  const originalPath = a.fileProvider.configUserPath( '.ssh' );
  const backupPath = a.fileProvider.configUserPath( '.ssh.bak' );
  if( _.fileProvider.fileExists( originalPath ) )
  originalExists = true;

  /* - */

  begin().then( ( op ) =>
  {
    test.case = 'create new identity from ssh';
    return null;
  });
  writeKey( 'id_rsa' );
  a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './ssh', './ssh/user', './ssh/user/id_rsa' ] );
    test.identical( _.strCount( op.output, `{ type : ssh, ssh.login : user, ssh.path : .censor/${profile}/ssh/user }` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  writeKey( 'id_rsa' );
  a.appStart( `.imply profile:${profile} .identity.from.ssh user` );
  a.appStart( `.imply profile:${profile} .identity.from.ssh user force:1` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './ssh', './ssh/user', './ssh/user/id_rsa' ] );
    test.identical( _.strCount( op.output, `{ type : ssh, ssh.login : user, ssh.path : .censor/${profile}/ssh/user }` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.filesDelete( originalPath );
    if( originalExists )
    {
      a.fileProvider.filesReflect
      ({
        reflectMap : { [ backupPath ] : originalPath }
      });
      a.fileProvider.filesDelete( backupPath );
    }
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      if( originalExists )
      {
        a.fileProvider.filesReflect
        ({
          reflectMap : { [ originalPath ] : backupPath }
        });
        a.fileProvider.filesDelete( originalPath );
      }
      return null;
    });
  }

  /* */

  function writeKey( name )
  {
    return a.ready.then( () =>
    {
      a.fileProvider.filesDelete( originalPath );
      a.fileProvider.fileWrite( a.abs( originalPath, name ), name );
      return null;
    });
  }
}

//

function identityRemove( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'remove single identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin2 type:git` );
  a.appStart( `.imply profile:${profile} .identity.remove user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user2' ), 1 );
    test.identical( _.strCount( op.output, 'user' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'try to remove with glob';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin2 type:git` );
  a.appStart( `.imply profile:${profile} .identity.remove user*` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user2' ), 1 );
    test.identical( _.strCount( op.output, 'user' ), 2 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function gitIdentityScript( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'get default script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:git login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /function .*\( identity, options \)/ ), 1 );
    test.identical( _.strCount( op.output, 'module.exports = onIdentity;' ), 0 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'get user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:git login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .git.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, script ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function npmIdentityScript( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'get default script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:npm login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /function .*\( identity, options \)/ ), 1 );
    test.identical( _.strCount( op.output, 'module.exports = onIdentity;' ), 0 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'get user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:super identities:'{user2:true}'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .npm.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, script ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function sshIdentityScript( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'get default script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .ssh.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /function .*\( identity, options \)/ ), 1 );
    test.identical( _.strCount( op.output, 'module.exports = onIdentity;' ), 0 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'get user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .ssh.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, script ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function gitIdentityScriptSet( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'set git script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:git login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ type: \'git\', login: \'userLogin\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function npmIdentityScriptSet( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'set git script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:npm login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .npm.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ type: \'npm\', login: \'userLogin\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function sshIdentityScriptSet( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  let a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profile }` );
  let originalExists = false;
  const originalPath = a.fileProvider.configUserPath( '.ssh' );
  const backupPath = a.fileProvider.configUserPath( '.ssh.bak' );
  if( _.fileProvider.fileExists( originalPath ) )
  originalExists = true;
  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  begin()

  /* - */

  writeKey( 'id_rsa' ).then( ( op ) =>
  {
    test.case = 'set ssh script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .ssh.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'type: \'ssh\',' ), 1 );
    test.identical( _.strCount( op.output, '\'ssh.login\': \'user\',' ), 1 );
    test.identical( _.strCount( op.output, `'ssh.path': '.censor/${profile}/ssh/user'` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.filesDelete( originalPath );
    if( originalExists )
    {
      a.fileProvider.filesReflect
      ({
        reflectMap : { [ backupPath ] : originalPath }
      });
      a.fileProvider.filesDelete( backupPath );
    }
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      if( originalExists )
      {
        a.fileProvider.filesReflect
        ({
          reflectMap : { [ originalPath ] : backupPath }
        });
        a.fileProvider.filesDelete( originalPath );
      }
      return null;
    });
  }

  /* */

  function writeKey( name )
  {
    return a.ready.then( () =>
    {
      a.fileProvider.filesDelete( originalPath );
      a.fileProvider.fileWrite( a.abs( originalPath, name ), name );
      return null;
    });
  }
}

//

function gitIdentityUse( test )
{
  const a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true );

  a.fileProvider.dirMake( a.abs( '.' ) );
  const originalConfig = a.fileProvider.fileRead( a.fileProvider.configUserPath( '.gitconfig' ) );
  const profile = `censor-test-${ __.intRandom( 1000000 ) }`;

  const script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'use default identity scripts';
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'change identities';
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin2 type:git email:'user2@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  a.appStart( `.imply profile:${profile} .git.identity.use user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin2' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user2@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'custom user script';
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login: \'userLogin\', type: \'git\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( op.output, '' );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  // a.ready.then( ( op ) => /* qqq : for Dmytro : repair */
  // {
  //   test.case = 'custom user script, type - super';
  //   a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
  //   return null;
  // });
  //
  // a.appStart( `.imply profile:${profile} .identity.new user login:userLogin email:'user@domain.com' type:git` );
  // a.appStart( `.imply profile:${profile} .identity.new user2 type:super identities:{user:true}` );
  // a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  // a.appStart( `.imply profile:${profile} .git.identity.use user2` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //   test.identical( _.strCount( op.output, '{ login: \'userLogin\', email: \'user@domain.com\', type: \'git\' }' ), 1 );
  //   return null;
  // });
  // a.shell( 'git config --global --list' )
  // .then( ( op ) =>
  // {
  //   test.identical( op.output, '' );
  //   return null;
  // });
  // a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), originalConfig );
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;
}

//

function npmIdentityUse( test )
{
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  const profile = `censor-test-${ __.intRandom( 1000000 ) }`;

  const script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'custom user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:npm email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .npm.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login: \'userLogin\', type: \'npm\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  // a.ready.then( ( op ) => /* qqq2 : for Dmytro : repair */
  // {
  //   test.case = 'custom user script, type - general';
  //   return null;
  // });
  //
  // a.appStart( `.imply profile:${profile} .identity.new user login:userLogin email:'user@domain.com'` );
  // a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  // a.appStart( `.imply profile:${profile} .npm.identity.use user` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //   test.identical( _.strCount( op.output, '{ login: \'userLogin\', email: \'user@domain.com\', type: \'general\' }' ), 1 );
  //   return null;
  // });
  // a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function sshIdentityUse( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  let a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profile }` );
  let originalExists = false;
  const originalPath = a.fileProvider.configUserPath( '.ssh' );
  const backupPath = a.fileProvider.configUserPath( '.ssh.bak' );
  if( _.fileProvider.fileExists( originalPath ) )
  originalExists = true;
  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  begin()
  writeKey( 'id_rsa' );

  /* - */


  a.ready.then( ( op ) =>
  {
    test.case = 'custom user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .ssh.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'type: \'ssh\',' ), 1 );
    test.identical( _.strCount( op.output, '\'ssh.login\': \'user\',' ), 1 );
    test.identical( _.strCount( op.output, `'ssh.path': '.censor/${profile}/ssh/user'` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  // a.ready.then( ( op ) => /* qqq2 : for Dmytro : repair */
  // {
  //   test.case = 'custom user script, type - general';
  //   return null;
  // });
  //
  // a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  // a.appStart( `.imply profile:${profile} .identity.set user login:userLogin type:general email:'user@domain.com'` );
  // a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  // a.appStart( `.imply profile:${profile} .ssh.identity.use user` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //   test.identical( _.strCount( op.output, 'login: \'userLogin\',' ), 1 );
  //   test.identical( _.strCount( op.output, 'email: \'user@domain.com\'' ), 1 );
  //   test.identical( _.strCount( op.output, 'type: \'general\',' ), 1 );
  //   test.identical( _.strCount( op.output, '\'ssh.login\': \'user\',' ), 1 );
  //   test.identical( _.strCount( op.output, `'ssh.path': '.censor/${profile}/ssh/user'` ), 1 );
  //   return null;
  // });
  // a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.filesDelete( originalPath );
    if( originalExists )
    {
      a.fileProvider.filesReflect
      ({
        reflectMap : { [ backupPath ] : originalPath }
      });
      a.fileProvider.filesDelete( backupPath );
    }
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      if( originalExists )
      {
        a.fileProvider.filesReflect
        ({
          reflectMap : { [ originalPath ] : backupPath }
        });
        a.fileProvider.filesDelete( originalPath );
      }
      return null;
    });
  }

  /* */

  function writeKey( name )
  {
    return a.ready.then( () =>
    {
      a.fileProvider.filesDelete( originalPath );
      a.fileProvider.fileWrite( a.abs( originalPath, name ), name );
      return null;
    });
  }
}

// --
// declare
// --

const Proto =
{
  name : 'Tools.Identity.Ext',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 60000,

  context :
  {
    suiteTempPath : null,
    appJsPath : null,
  },

  tests :
  {
    identityList,
    identityCopy,
    identitySet,
    identityNew,
    gitIdentityNew,
    npmIdentityNew,
    identityFromGit,
    identityFromSsh,
    identityRemove,
    gitIdentityScript,
    npmIdentityScript,
    sshIdentityScript,
    gitIdentityScriptSet,
    npmIdentityScriptSet,
    sshIdentityScriptSet,
    gitIdentityUse,
    npmIdentityUse,
    sshIdentityUse,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
