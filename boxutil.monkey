Strict

Public

#Rem
	DESCRIPTION:
		* This module was written as a simple utility module for the standard "box" classes provided with Monkey.
#End

' Preprocessor related:
#BOXUTIL_IMPLEMENTED = True
#BOXUTIL_STANDARD_UNBOXING = False

' Surprisingly, this works.
#BOXUTIL_SHARED_CONVERSION = (Not REFLECTION_FILTER) ' (REFLECTION_FILTER.Find("${MODPATH}") = -1)

'#MONKEYLANG_EXPLICIT_BOXES = True

' Imports:

' This module is imported explicitly for the sake of maximum compatibility.
Import monkey.boxes

' Functions:

' The following commands are wrappers for the 'SharedBoxRoutines' class's 'Clone' implementation:
Function CloneBox:IntObject(IO:IntObject)
	Return SharedBoxRoutines<IntObject>.Clone(IO)
End

Function CloneBox:FloatObject(FO:FloatObject)
	Return SharedBoxRoutines<FloatObject>.Clone(FO)
End

Function CloneBox:BoolObject(BO:BoolObject)
	Return SharedBoxRoutines<BoolObject>.Clone(BO)
End

Function CloneBox:StringObject(SO:StringObject)
	Return SharedBoxRoutines<StringObject>.Clone(SO)
End

#Rem
	DESCRIPTION:
		* The 'InnerValue' command allows you to always get the true value of a type.
		This is very useful for those who are lazy with generic/template classes.
#End

' Standard versions of 'InnerValue' (Here as an optimization):
Function InnerValue:Int(I:Int)
	Return I
End

Function InnerValue:Float(F:Float)
	Return F
End

Function InnerValue:Bool(B:Bool)
	Return B
End

Function InnerValue:String(S:String)
	Return S
End

' Box versions of 'InnerValue' (Wrappers of the 'SharedBoxRoutines' class's implementation):
Function InnerValue:Int(IO:IntObject)
	#If Not BOXUTIL_STANDARD_UNBOXING
		#If Not BOXUTIL_SHARED_CONVERSION
			Return IO.ToInt() ' IO.value
		#Else
			Return SharedBoxRoutines<IntObject>.AsInt(IO)
		#End
	#Else
		Return UnboxInt(IO)
	#End
End

Function InnerValue:Float(FO:FloatObject)
	#If Not BOXUTIL_STANDARD_UNBOXING
		#If Not BOXUTIL_SHARED_CONVERSION
			Return FO.ToFloat() ' FO.value
		#Else
			Return SharedBoxRoutines<FloatObject>.AsFloat(FO)
		#End
	#Else
		Return UnboxFloat(FO)
	#End
End

Function InnerValue:Bool(BO:BoolObject)
	#If Not BOXUTIL_STANDARD_UNBOXING
		#If Not BOXUTIL_SHARED_CONVERSION
			Return BO.ToBool() ' BO.value
		#Else
			Return SharedBoxRoutines<BoolObject>.AsBool(BO)
		#End
	#Else
		Return UnboxBool(BO)
	#End
End

Function InnerValue:String(SO:StringObject)
	#If Not BOXUTIL_STANDARD_UNBOXING
		#If Not BOXUTIL_SHARED_CONVERSION
			Return SO.ToString() ' SO.value
		#Else
			Return SharedBoxRoutines<StringObject>.AsString(SO)
		#End
	#Else
		Return UnboxString(SO)
	#End
End

' Classes:
Class SharedBoxRoutines<Type>
	' Functions:
	
	' Cloning/Reconstruction commands:
	
	' This is rather basic, but it works.
	Function Clone:Type(O:Type)
		Return New Type(InnerValue(O))
	End
	
	' Due to the already generic/template nature of 'ArrayObject', we need separate commands for this:
	Function CloneArrayBox:ArrayObject<Type>(AO:ArrayObject<Type>)
		Return New ArrayObject<Type>(InnerValueOfArrayBox(AO))
	End
	
	Function InnerValueOfArrayBox:Type[](AO:ArrayObject<Type>)
		#If Not BOXUTIL_STANDARD_UNBOXING
			Return AO.ToArray()
		#Else
			Return ArrayBoxer<Type>.Unbox(AO)
		#End
	End
	
	' Conversion commands:
	#If BOXUTIL_SHARED_CONVERSION
		Function AsInt:Int(O:Type)
			Return O.ToInt()
		End
		
		Function AsFloat:Float(O:Type)
			Return O.ToFloat()
		End
		
		Function AsBool:Bool(O:Type)
			Return O.ToBool()
		End
		
		Function AsString:String(O:Type)
			Return O.ToString()
		End
	#End
End