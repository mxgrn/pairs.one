'use strict';

/* global Symbol */

// var hasSymbols = typeof Symbol === 'function' && typeof Symbol.iterator === 'symbol';

module.exports = function (promiseFinally, t) {
	if (typeof Promise !== 'function') {
		return t.skip('No global Promise detected');
	}

	t.test('onFinally arguments', function (st) {
		st.plan(2);

		promiseFinally(Promise.resolve(42), function () {
			st.equal(arguments.length, 0, 'resolved promise passes no arguments to onFinally');
		})['catch'](st.fail);

		promiseFinally(Promise.reject(NaN), function () {
			st.equal(arguments.length, 0, 'rejected promise passes no arguments to onFinally');
		}).then(st.fail);
	});

	t.test('onFinally fulfillment', function (st) {
		st.plan(6);

		promiseFinally(Promise.resolve(42), function () { return Promise.resolve(Infinity); }).then(function (x) {
			st.equal(x, 42, 'resolved promise onFinally resolution does not affect promise resolution value');
		})['catch'](st.fail);

		promiseFinally(Promise.resolve(42), function () { return Promise.reject(-Infinity); })['catch'](function (x) {
			st.equal(x, -Infinity, 'resolved promise onFinally returning a rejected Promise rejects with the new rejection value');
		})['catch'](st.fail);

		promiseFinally(Promise.resolve(42), function () { throw Function; })['catch'](function (e) {
			st.equal(e, Function, 'resolved promise onFinally throwing rejects with the thrown rejection value');
		})['catch'](st.fail);

		promiseFinally(Promise.reject(42), function () { return Promise.resolve(Infinity); })['catch'](function (e) {
			st.equal(e, 42, 'rejected promise onFinally resolution does not affect promise rejection value');
		})['catch'](st.fail);

		promiseFinally(Promise.reject(42), function () { return Promise.reject(-Infinity); })['catch'](function (x) {
			st.equal(x, -Infinity, 'rejected promise onFinally returning a rejected Promise rejects with the new rejection value');
		})['catch'](st.fail);

		promiseFinally(Promise.reject(42), function () { throw Function; })['catch'](function (e) {
			st.equal(e, Function, 'rejected promise onFinally throwing rejects with the thrown rejection value');
		})['catch'](st.fail);
	});

	var Subclass = (function () {
		try {
			// eslint-disable-next-line no-new-func
			return Function('return class Subclass extends Promise {};')();
		} catch (e) { /**/ }

		return false;
	}());
	t.test('inheritance', { skip: !Subclass }, function (st) {
		st.test('preserves correct subclass when chained', function (s2t) {
			var promise = promiseFinally(Subclass.resolve());
			s2t.ok(promise instanceof Subclass, 'promise is instanceof Subclass');
			s2t.equal(promise.constructor, Subclass, 'promise.constructor is Subclass');

			s2t.end();
		});

		st.test('preserves correct subclass when rejected', function (s2t) {
			var promise = promiseFinally(Subclass.resolve(), function () {
				throw new Error('OMG');
			});
			s2t.ok(promise instanceof Subclass, 'promise is instanceof Subclass');
			s2t.equal(promise.constructor, Subclass, 'promise.constructor is Subclass');

			s2t.end();
		});

		st.test('preserves correct subclass when someone returns a thenable', function (s2t) {
			var promise = promiseFinally(Subclass.resolve(), function () {
				return Promise.resolve(1);
			});
			s2t.ok(promise instanceof Subclass, 'promise is instanceof Subclass');
			s2t.equal(promise.constructor, Subclass, 'promise.constructor is Subclass');

			s2t.end();
		});
	});

	return t.comment('tests completed');
};
