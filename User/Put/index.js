exports.handler = async function(event, context) {
  console.log('Got an event for User Get', event);
  var res ={
    "statusCode": 200,
    "headers": {
        "Content-Type": "*/*"
    },
    "body": "Faisal just Putted"
  };
  return res;
}
