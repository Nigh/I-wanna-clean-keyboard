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

; Construction and deconstruction VARIANT struct
class ComVar extends Buffer {
	/**
	 * Construction VARIANT struct, `ptr` property points to the address, `__Item` property returns var's Value
	 * @param vVal Values that need to be wrapped, supports String, Integer, Double, Array, ComValue, ComObjArray
	 * ### example
	 * `var1 := ComVar('string'), MsgBox(var1[])`
	 * 
	 * `var2 := ComVar([1,2,3,4], , true)`
	 * 
	 * `var3 := ComVar(ComValue(0xb, -1))`
	 * @param vType Variant's type, VT_VARIANT(default)
	 * @param convert Convert AHK's array to ComObjArray
	 */
	static Call(vVal := 0, vType := 0xC, convert := false) {
		static size := 8 + 2 * A_PtrSize
		if vVal is ComVar
			return vVal
		var := super(size, 0), IsObject(vVal) && vType := 0xC
		var.ref := ref := ComValue(0x4000 | vType, var.Ptr + (vType = 0xC ? 0 : 8))
		if convert && (vVal is Array) {
			switch Type(vVal[1]) {
				case "Integer": vType := 3
				case "String": vType := 8
				case "Float": vType := 5
				case "ComValue", "ComObject": vType := ComObjType(vVal[1])
				default: vType := 0xC
			}
			ComObjFlags(ref[] := obj := ComObjArray(vType, vVal.Length), i := -1)
			for v in vVal
				obj[++i] := v
		} else ref[] := vVal
		if vType & 0xC
			var.IsVariant := 1
		return var
	}
	__Delete() => DllCall("oleaut32\VariantClear", "ptr", this)
	__Item {
		get => this.ref[]
		set => this.ref[] := Value
	}
	Type {
		get => NumGet(this, "ushort")
		set {
			if (!this.IsVariant)
				throw PropertyError("VarType is not VT_VARIANT, Type is read-only.", -2)
			NumPut("ushort", Value, this)
		}
	}
	static Prototype.IsVariant := 0
	static Prototype.ref := 0
}