def arithmetic_arranger(array):
  def proceed():  
    int_arr0=[]
    int_arr2=[]
    result=[]

    for x in array:
      array2=(x.split(" "))
      try:
        int_arr0.append(int(array2[0]))
        int_arr2.append(int(array2[2]))
      except ValueError:
        print('Error: Numbers must only contain digits.')
        exit()
      lenarr0=len(array2[0])
      lenarr2=len(array2[2])

      if lenarr0 <= 4 and lenarr2 <= 4 :
        print('{:>10}'.format(array2[0]),end='    ')
      else:
        print('Numbers cannot be more than four digits')
        exit()

    def addition():
      result.insert(i,int_arr0[i] + int_arr2[i])
    
    def subtraction():
      result.insert(i,int_arr0[i] - int_arr2[i])

    i=0
    while i < len(int_arr0):  # Ensure the loop doesn't go out of bounds
        if "+" in array[i]:
          addition()
        elif "-" in array[i]:
          subtraction()
        else:
          print('Error: Operator must be '+' or '-'.')
          exit()
        i += 1
    
    print("")

    for x in array:
      array2=(x.split(" "))
      print('{:>4}'.format(array2[1]),'{:>5}'.format(array2[2]),end='    ')
    print("")
    for x in array:
      print('{:>2}'.format(""),'{:->7}'.format('-'),end='    ')
    print("")
    for x in result:
      print('{:>2}'.format(""),'{:>7}'.format(x),end='    ')
      
  if len(array) <= 4:
    proceed()
  else:
    print('Error: Too many problems.')

arithmetic_arranger(["500 + 3200", "380 - 4000", "5005 + 5454", "123 - 49"])