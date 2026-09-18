;///////////////////////////////////////////////////////////////////////////////////////////
; MIT License
;
; Copyright (c) 2023 thqby
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;///////////////////////////////////////////////////////////////////////////////////////////

/************************************************************************
 * @description Implements a javascript-like Promise
 * @author thqby
 * @date 2025/01/09
 * @version 1.0.10
 ***********************************************************************/

/**
 * Represents the completion of an asynchronous operation
 * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise MDN doc}
 * @alias Promise<T=Any>
 */
class Promise {
	static Prototype.status := 'pending'
	/** @type {T} */
	static Prototype.result := ''
	static Prototype.thrown := false

	/**
	 * @param {(resolve [,reject]) => void} executor A callback used to initialize the promise. This callback is passed two arguments:
	 * a resolve callback used to resolve the promise with a value or the result of another promise,
	 * and a reject callback used to reject the promise with a provided reason or error.
	 * - resolve(data) => void
	 * - reject(err) => void
	 */
	__New(executor) {
		this.callbacks := []
		try
			(executor.MaxParams = 1) ? executor(resolve) : executor(resolve, reject)
		catch Any as e
			reject(e)
		resolve(value := '') {
			if value is Promise {
				if !ObjHasOwnProp(value, 'status') {
					if this !== value
						return value.onCompleted(resolve)
					this.status := 'rejected', this.result := ValueError('Chaining cycle detected for promise', -1)
				} else if this
					this.status := value.status, this.result := value.result
				else return
			} else if this
				this.status := 'fulfilled', this.result := value
			else return
			SetTimer(task.Bind(this), -1), this := 0
		}
		reject(reason?) {
			if !this
				return
			this.status := 'rejected', this.result := reason ?? Error(, -1)
			SetTimer(task.Bind(this), -1), this := 0
		}
		static task(this) {
			for cb in this.DeleteProp('callbacks')
				cb(this)
			else if !ObjHasOwnProp(this, 'thrown') && this.status == 'rejected' && this.thrown := true
				throw this.result
		}
	}
	; __Delete() => OutputDebug('del: ' ObjPtr(this) '`n')

	/**
	 * Attaches a callback that is invoked when the Promise is completed (fulfilled or rejected).
	 * @param {(value: Promise) => void} callback The callback to execute when the Promise is completed.
	 * @returns {void}
	 */
	onCompleted(callback) {
		ObjHasOwnProp(this, 'callbacks') ? this.callbacks.Push(callback) : nextTick(this, callback)
		static nextTick(this, callback) => SetTimer(() => callback(this), -1)
	}
	/**
	 * Attaches callbacks for the resolution and/or rejection of the Promise.
	 * @param {(value) => void} onfulfilled The callback to execute when the Promise is resolved.
	 * @param {(reason) => void} onrejected The callback to execute when the Promise is rejected.
	 * @returns {void}
	 */
	onSettled(onfulfilled, onrejected := Promise.throw) {
		this.onCompleted(val => (val.status == 'fulfilled' ? onfulfilled : onrejected)(val.result))
	}
	/**
	 * Attaches callbacks for the resolution and/or rejection of the Promise.
	 * @param {(value) => Any} onfulfilled The callback to execute when the Promise is resolved.
	 * @param {(reason) => Any} onrejected The callback to execute when the Promise is rejected.
	 * @returns {Promise} A Promise for the completion of which ever callback is executed.
	 */
	then(onfulfilled, onrejected := Promise.throw) {
		return Promise(executor)
		executor(resolve, reject) {
			this.onCompleted(task)
			task(p1) {
				try
					resolve((p1.status == 'fulfilled' ? onfulfilled : onrejected)(p1.result))
				catch Any as e
					reject(e)
			}
		}
	}
	/**
	 * Attaches a callback for only the rejection of the Promise.
	 * @param {(reason) => Any} onrejected The callback to execute when the Promise is rejected.
	 * @returns {Promise} A Promise for the completion of the callback.
	 */
	catch(onrejected) => this.then(val => val, onrejected)
	/**
	 * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected).
	 * The resolved value cannot be modified from the callback.
	 * @param {() => void} onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
	 * @returns {Promise} A Promise for the completion of the callback.
	 */
	finally(onfinally) => this.then(
		val => (onfinally(), val),
		err => (onfinally(), (Promise.throw)(err))
	)
	/**
	 * Waits for a promise to be completed.
	 * @returns {T}
	 */
	await2(timeout := -1) {
		end := A_TickCount + timeout, old := Critical(0)
		while (pending := !ObjHasOwnProp(this, 'status')) && (timeout < 0 || A_TickCount < end)
			Sleep(1)
		Critical(old)
		if !pending && this.status == 'fulfilled'
			return this.result
		throw pending ? TimeoutError() : (this.thrown := true) && this.result
	}
	/**
	 * Waits for a promise to be completed.
	 * Wake up only when a system event or timeout occurs, which takes up less cpu time.
	 * @returns {T}
	 */
	await(timeout := -1) {
		static hEvent := DllCall('CreateEvent', 'ptr', 0, 'int', 1, 'int', 0, 'ptr', 0, 'ptr')
		static __del := { Ptr: hEvent, __Delete: this => DllCall('CloseHandle', 'ptr', this) }
		static msg := Buffer(4 * A_PtrSize + 16)
		t := A_TickCount, r := 258, old := Critical(0)
		while (pending := !ObjHasOwnProp(this, 'status')) && timeout &&
			(DllCall('PeekMessage', 'ptr', msg, 'ptr', 0, 'uint', 0, 'uint', 0, 'uint', 0) ||
				1 == r := DllCall('MsgWaitForMultipleObjects', 'uint', 1, 'ptr*', hEvent,
					'int', 0, 'uint', timeout, 'uint', 7423, 'uint'))
			Sleep(-1), (timeout < 0) || timeout := Max(timeout - A_TickCount + t, 0)
		Critical(old)
		if !pending && this.status == 'fulfilled'
			return this.result
		throw pending ? r == 0xffffffff ? OSError() : TimeoutError() : (this.thrown := true) && this.result
	}
	static throw() {
		throw this
	}
	/**
	 * Creates a new resolved promise for the provided value.
	 * @param value The value the promise was resolved.
	 * @returns {Promise} A new resolved Promise.
	 */
	static resolve(value) => { base: this.Prototype, result: value, status: 'fulfilled' }
	/**
	 * Creates a new rejected promise for the provided reason.
	 * @param reason The reason the promise was rejected.
	 * @returns {Promise} A new rejected Promise.
	 */
	static reject(reason) => Promise((_, reject) => reject(reason))
	/**
	 * Creates a Promise that is resolved with an array of results when all of the provided Promises
	 * resolve, or rejected when any Promise is rejected.
	 * @param {Array} promises An array of Promises.
	 * @returns {Promise<Array>} A new Promise.
	 */
	static all(promises) {
		return Promise(executor)
		executor(resolve, reject) {
			res := [], count := res.Length := promises.Length
			resolve2 := (index, val) => (res[index] := val, !--count && resolve(res))
			for val in promises {
				if val is Promise
					val.onSettled(resolve2.Bind(A_Index), reject)
				else resolve2(A_Index, val)
			} else resolve(res)
		}
	}
	/**
	 * Creates a Promise that is resolved with an array of results when all
	 * of the provided Promises resolve or reject.
	 * @param {Array} promises An array of Promises.
	 * @returns {Promise<Array<{status: String, result: Any}>>} A new Promise.
	 */
	static allSettled(promises) {
		return Promise(executor)
		executor(resolve, reject) {
			res := [], count := res.Length := promises.Length
			callback := (index, val) => (res[index] := { result: val.result, status: val.status }, !--count && resolve(res))
			for val in promises {
				if val is Promise
					val.onCompleted(callback.Bind(A_Index))
				else res[A_Index] := { result: val, status: 'fulfilled' }, !--count && resolve(res)
			} else resolve(res)
		}
	}
	/**
     * The any function returns a promise that is fulfilled by the first given promise to be fulfilled, or rejected with an AggregateError containing an array of rejection reasons if all of the given promises are rejected. It resolves all elements of the passed iterable to promises as it runs this algorithm.
     * @param {Array<Promise>} promises An array of Promises.
     * @returns {Promise} A new Promise.
     */
	static any(promises) {
		return Promise(executor)
		executor(resolve, reject) {
			errs := [], count := errs.Length := promises.Length
			reject2 := (index, err) => (errs[index] := err, !--count && (
				err := Error('All promises were rejected'), err.errors := errs, reject(err)))
			for val in promises
				val.onSettled(resolve, reject2.Bind(A_Index))
		}
	}
	/**
	 * Creates a Promise that is resolved or rejected when any of the provided Promises are resolved or rejected.
	 * @param {Array} promises An array of Promises.
	 * @returns {Promise} A new Promise.
	 */
	static race(promises) {
		return Promise(executor)
		executor(resolve, reject) {
			for val in promises
				if val is Promise
					val.onSettled(resolve, reject)
				else return resolve(val)
		}
	}
	static try(fn) {
		try {
			val := fn()
			return Promise.resolve(val)
		} catch Any as e
			return Promise.reject(e)
	}
	/**
	 * Creates a new Promise and returns it in an object, along with its resolve and reject functions. 
	 * @returns {{ promise: Promise, resolve: (data) => void, reject: (err) => void }}
	 */
	static withResolvers() {
		local resolvers := 0
		resolvers.promise := Promise((resolve, reject) => resolvers := { resolve: resolve, reject: reject })
		return resolvers
	}
}