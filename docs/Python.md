# Python

``` py title="Palíndromo" linenums="1"
def palindromo(cadena):
    #caso base:
    largo=len(cadena)
    if largo == 1 or largo == 0:
        print("Es un palíndromo")
    #compruebo, quito letras y rellamo a la función
    elif cadena[largo - 1] is cadena[0]:
        cadena = cadena [1:-1]
        palindromo(cadena)
    else:
        print("No es un palíndromo")
if __name__ == "__main__":
    import sys   
    palindromo(input("Introduce una palabra: "))
```
``` py title="Palíndromo Fácil" linenums="1"
import sys
def isPalindrome(s):
    if s == s[::-1]:
        print("Palindromo")
    else:
        print("No es palindromo")

isPalindrome(input("Introduce una palabra: "))
```

``` py title="DNIS" linenums="1"
import sys
#declaramos diccionario con las letras DNI, no tiene mucho sentido
letrasDNI = {0:"T",1:"R",2:"W",3:"A",4:"G",5:"M",6:"Y",7:"F",8:"P",9:"D",10:"X",11:"B",12:"N",13:"J",14:"Z",15:"S",16:"Q",17:"V",18:"H",19:"L",20:"C",21:"K",22:"E"}
dicionario={}
def comprobarDNI(dni):
    letra = (dni[8]).upper()
    nums = dni[:-1]
    resto = int(nums)%23
    busca = letrasDNI[resto]
    if letra == busca:
        print("Tu letra del DNI es correcta")
        return True
    else:
        print("Inténtalo de nuevo")
        return False
            
def gardarNota(dicionario, dni, nota):
    if dni not in dicionario:
        dicionario[dni]=nota
    else:
        dicionario[dni] = dicionario[dni] + nota

def consultarNota(dicionario, dni):
    print('A nota acumulada do DNI '+ dni + ' é: ' + str(dicionario[dni]))
    
    
if __name__ == "__main__":
    comprobarDNI("52931113v")
    gardarNota(dicionario, '11111111H',1.5)
    gardarNota(dicionario, '11111111H',2.5)
    gardarNota(dicionario,'22222222B', 2.1)
    consultarNota(dicionario,'11111111H')
```