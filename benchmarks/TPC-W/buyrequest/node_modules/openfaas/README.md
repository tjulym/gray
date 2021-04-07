[![XO code
style](https://img.shields.io/badge/code_style-XO-5ed9c7.svg)](https://github.com/sindresorhus/xo)
![OpenFaaS](https://img.shields.io/badge/openfaas-serverless-blue.svg)

##### Usage

```js
const OpenFaaS = require('openfaas')

const openfaas = new OpenFaaS('http://localhost:8080')

openfaas
	.deploy(
		'yolo', // name your function
		'hello-serverless' // choose the Docker image
		'func_functions', // choose your network (optional)
	)
	.then(x => console.log(x))
	.catch(err => console.log(err))

openfaas
	.invoke(
		'yolo', // function name
		'hello world', // data to send to function
		true, // should response be JSON? Optional, default is false
		false // should the response by binary? Optional, default is false
	)
	.then(x => console.log(x)) // handle response
	.catch(err => console.log(err))

openfaas
	.remove('yolo')
	.then(x => console.log(x)) // handle response
	.catch(err => console.log(err))

openfaas
	.compose('initial data', [
		'func_nodeinfo',
		'func_echoit',
		'func_wordcount'
	])
	.then(x => console.log(x.body)) // handle final output
	.catch(err => console.log(err))
```
