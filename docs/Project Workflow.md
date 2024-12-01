## **General Guidelines**

1. **Consistency**: Use the same naming convention throughout your program.
2. **Descriptive Names**: Choose meaningful names that clearly indicate the purpose of the variable, macro, or procedure.
3. **Case Sensitivity**: Assembly language is generally not case-sensitive, but be consistent (e.g., use all uppercase for constants and macros).

## **Naming Conventions**

## **Variable Naming**

1. **General Format**:  
   `<type>_<purpose>`

   - **Prefix** to indicate the variable type or scope.
   - **Purpose** to describe the use of the variable.

2. **Examples**:

   - `int_Counter`: Integer variable for counting.
   - `str_Message`: String variable for storing messages.
   - `buf_InputBuffer`: Buffer for user input.
   - `flag_IsReady`: Boolean flag for readiness.

3. **Global Variables**:  
   Use a `g_` prefix to indicate global scope.

   - Example: `g_TotalSum`

4. **Local Variables**:  
   Use a `l_` prefix for local scope.

   - Example: `l_LoopIndex`

5. **Constants**:  
   Use uppercase letters with underscores to separate words.

   - Example: `MAX_BUFFER_SIZE`

## **Macro Naming**

1. **General Format**:  
   Use uppercase letters with underscores.
2. **Examples**:

   - `PRINT_CHAR`: Macro to print a single character.
   - `CLEAR_SCREEN`: Macro to clear the console.
   - `READ_STRING`: Macro to read a string.

3. **Local Labels in Macros**:  
   Use `LOCAL` for labels inside macros to avoid conflicts. Prefix local labels with a descriptive name related to the macro.

   - Example:
     `LOCAL loop_start loop_start:`

---

## **Procedure Naming**

1. **General Format**:  
   `<action>_<object>`

   - Use descriptive verbs for actions and nouns for objects.

2. **Examples**:

   - `Print_String`: Procedure to print a string.
   - `Read_Input`: Procedure to read user input.
   - `Sort_Array`: Procedure to sort an array.

3. **Label Naming in Procedures**:  
   Use descriptive and unique labels to improve readability. Prefix the labels with the procedure name or purpose.

   - Example:

     `Sort_Array_start:`

---

## **Label Naming**

1. **General Format**:  
   `<procedure>_<purpose>`
   - Include the procedure name as a prefix to ensure uniqueness.
2. **Examples**:

   - `Loop_Start`: Starting point of a loop.
   - `Error_Message`: Label for displaying error messages.

3. **Avoid Generic Names**:  
   Do not use generic names like `read`, `loop`, or `start`. These can conflict with existing symbols.
