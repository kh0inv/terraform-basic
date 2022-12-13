exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const requestHeaders = request.headers;
  const response = event.Records[0].cf.response;

  // Look for cookie
  if (requestHeaders.cookie) {
    for (let i = 0; i < requestHeaders.cookie.length; i++) {
      if (requestHeaders.cookie[i].value.indexOf("X-Redirect-Flag=a") >= 0) {
        response.headers["set-cookie"] = [{ key: "Set-Cookie", value: `X-Redirect-Flag=a; Path=/` }];
        callback(null, response);
        return;
      }

      if (requestHeaders.cookie[i].value.indexOf("X-Redirect-Flag=b") >= 0) {
        response.headers["set-cookie"] = [{ key: "Set-Cookie", value: `X-Redirect-Flag=b; Path=/` }];
        callback(null, response);
        return;
      }
    }
  }

  // If request contains no Source cookie, do nothing and forward the response as-is
  callback(null, response);
};
