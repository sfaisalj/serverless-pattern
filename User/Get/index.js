exports.handler = async function(event, context) {
  console.log('Got an event for User Get', event);
  var res ={
    "statusCode": 200,
    "headers": {
        "Content-Type": "*/*"
    },
    "body": JSON.stringify(event)
  };
  return res;
}
