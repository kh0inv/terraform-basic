exports.handler = async (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  if (headers.cookie) {
    for (let i = 0; i < headers.cookie.length; i++) {
      if (headers.cookie[i].value.indexOf("X-Redirect-Flag=a") >= 0) {
        request.origin = {
          s3: {
            authMethod: "origin-access-identity",
            domainName: "mamnon-prod-a-bucket.s3.amazonaws.com",
            region: "us-east-1",
            path: "",
          },
        };

        headers["host"] = [
          {
            key: "host",
            value: "mamnon-prod-a-bucket.s3.amazonaws.com",
          },
        ];
        break;
      }

      if (headers.cookie[i].value.indexOf("X-Redirect-Flag=b") >= 0) {
        request.origin = {
          s3: {
            authMethod: "origin-access-identity",
            domainName: "mamnon-prod-b-bucket.s3.amazonaws.com",
            region: "us-east-1",
            path: "",
          },
        };

        headers["host"] = [
          {
            key: "host",
            value: "mamnon-prod-b-bucket.s3.amazonaws.com",
          },
        ];
        break;
      }
    }
  }

  callback(null, request);
};
