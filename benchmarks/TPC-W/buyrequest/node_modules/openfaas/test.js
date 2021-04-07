const test = require('tape')
const nock = require('nock')
const OpenFaaS = require('./openfaas')

test('Test typeofs', t => {
	t.plan(8)

	t.equals(typeof OpenFaaS, 'function')

	const openfaas = new OpenFaaS('http://localhost:8080')

	t.equals(typeof openfaas, 'object')
	t.equals(typeof openfaas.deploy, 'function')
	t.equals(typeof openfaas.invoke, 'function')
	t.equals(typeof openfaas.compose, 'function')
	t.equals(typeof openfaas.remove, 'function')
	t.equals(typeof openfaas.inspect, 'function')
	t.equals(typeof openfaas.list, 'function')
})

test('Test full API', t => {
	nock('http://localhost:8080')
		.post('/system/functions', {
			service: 'test-func',
			network: 'func_functions',
			image: 'hello-serverless'
		}).reply(200)
		.post('/function/func_echoit', 'test').reply(200, 'test')
		.get('/system/functions').reply(200, [{
			name: 'func_echoit',
			image: 'functions/alpine:health@sha256:52e6e83add2caafc014d9f14984781c91d0d36c7d13829a7ccec480f2e395d19',
			invocationCount: 12,
			replicas: 1,
			envProcess: 'cat'
		}])
		.post('/function/func_nodeinfo').reply(200, 'hello cruel world')
		.post('/function/func_echoit', 'hello cruel world').reply(200, 'hello cruel world')
		.post('/function/func_wordcount', 'hello cruel world').reply(200, 3)
		.get('/system/functions').reply(200, [{
			name: 'func_echoit',
			image: 'functions/alpine:health@sha256:52e6e83add2caafc014d9f14984781c91d0d36c7d13829a7ccec480f2e395d19',
			invocationCount: 12,
			replicas: 1,
			envProcess: 'cat'
		}])
		.delete('/system/functions', { functionName: 'test-func' }).reply(200)

	t.plan(10)
	const openfaas = new OpenFaaS('http://localhost:8080')

	openfaas.deploy(
		'test-func',
		'hello-serverless'
	)
		.then(x => t.equals(x.statusCode, 200))
		.then(() => openfaas.invoke('func_echoit', 'test', true))
		.then(x => {
			t.equals(x.statusCode, 200)
			t.equals(x.body, 'test')
		})
		.then(() => openfaas.list())
		.then(x => {
			t.equals(x.statusCode, 200)
			t.equals(x.body[0].name, 'func_echoit')
		})
		.then(() => openfaas.compose('', [
			'func_nodeinfo',
			'func_echoit',
			'func_wordcount'
		]))
		.then(x => {
			t.equals(x.statusCode, 200)
			t.equals(x.body, '3')
		})
		.then(() => openfaas.inspect('func_echoit'))
		.then(x => {
			t.equals(x.statusCode, 200)
			t.equals(x.body.name, 'func_echoit')
		})
		.then(() => openfaas.remove('test-func'))
		.then(x => t.equals(x.statusCode, 200))
		.catch(console.log)
})
