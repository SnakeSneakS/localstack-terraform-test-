const apiTestHandler = (payload, context, callback) => {
    callback(null, {
        statusCode: 200,
        body: JSON.stringify({
            message: `hello ${process.env.target!=""?process.env.target:"hello-world"}! from lambda function.`
        }),
    });
    
}

module.exports = {
    apiTestHandler,
}
