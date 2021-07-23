const Twit = require( 'twit' ),
      fs = require( 'fs' ),
      path = require( 'path' ),
      config = require( path.join( __dirname, 'config.js' ) );

const T = new Twit( config );

function tweetPainting(){

  const imagePath = path.join( __dirname, '/png/daily.png');
  const b64content = fs.readFileSync( imagePath, { encoding: 'base64' } );

  T.post( 'media/upload', { media_data: b64content }, function ( err, data, response ) {
    if ( err ){
      console.log( 'error:', err );
    } else {
      console.log( 'image uploaded, now tweeting it...' );
      
      T.post( 'statuses/update', {
        media_ids: new Array( data.media_id_string )
      },
      function( err, data, response) {
        if (err){
          console.log( 'error:', err );
        } else {
          console.log( 'posted an image!' );

          // fs.unlink( imagePath, function( err ) {
          //   if ( err ){
          //     console.log( 'error: unable to delete image ' + imagePath );
          //   } else {
          //     console.log( 'image ' + imagePath + ' was deleted' );
          //   }
          // });
        }
      });
    }
  })
};

setInterval( function(){
  tweetPainting();
}, 10000);//86400000);