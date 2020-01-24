import face_recognition
import cv2
import pickle
import numpy as np

def imgFace(path):
    face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
    img = path
    faces = face_cascade.detectMultiScale(img, 1.1, 5, minSize=(30, 30))
    numF = len(faces)
    faceL = face_recognition.face_locations(img)
    print(faceL)
    print(numF)
    if numF >= 1:
        for (x, y, w, h) in faceL:
            copy = img[x-20:w+20, h-20:y+20]
        #cv2.imshow('img', copy)
        #cv2.waitKey()
        return copy

def tadasCombinacoes(img):
    resutadosPositivo = []
    # Carrega a base
    with open('data_set.dat', 'rb') as f:
        encodings = pickle.load(f)
    # Carrega a lista de nome vinculada a cada encoding
    nomes = list(encodings.keys())
    face_encodings = np.array(list(encodings.values()))
    padrao = cv2.resize(imgFace(img), (400, 350))
    unknown_face = face_recognition.face_encodings(padrao)[0]
    result = face_recognition.compare_faces(face_encodings, unknown_face)
    # Gera lista com os resultados Nome e True/False
    names_with_result = list(zip(nomes, result))
    x = 0
    while x < len(names_with_result):
        _, valorLogico = names_with_result[x]
        if valorLogico:
            resutadosPositivo.append(nomes[x])
            _, ids = nomes[x]
            print(ids)
        x = x + 1
    print(resutadosPositivo)

def validaFace(img):
    resutadosPositivo = []
    with open('data_set.dat', 'rb') as f:
        encodings = pickle.load(f)
    # Carrega a lista de nome vinculada a cada encoding 
    nomes = list(encodings.keys())
    face_encodings = np.array(list(encodings.values()))
    padrao = cv2.resize(imgFace(img), (400, 350))
    unknown_face = face_recognition.face_encodings(padrao)[0]
    result = face_recognition.compare_faces(face_encodings, unknown_face)
    # Gera lista com os resultados Nome e True/False
    nomeResult = list(zip(nomes, result))
    x = 0
    while x < len(nomeResult):
        _, valorLogico = nomeResult[x]
        if valorLogico:
            resutadosPositivo.append(nomes[x])
            _, ids = nomes[x]
        x = x + 1
    if len(resutadosPositivo) >= 1:
        return True
    else:
        return False

def primeiraCombinacao(img):
    primeiroResultado = []
    # Carrega a base
    with open('data_set.dat', 'rb') as f:
        encodings = pickle.load(f)
    nomes = list(encodings.keys())
    face_encodings = np.array(list(encodings.values()))
    padrao = cv2.resize(imgFace(img), (400, 350))
    unknown_face = face_recognition.face_encodings(padrao)[0]
    result = face_recognition.compare_faces(face_encodings, unknown_face)
    # Gera lista com os resultados Nome e True/False
    nomeResult = list(zip(nomes, result))
    x = 0
    #Gera a lista com o primeiro resultado Positivo
    while x < len(nomeResult):
        _, valorLogico = nomeResult[x]
        if valorLogico:
            primeiroResultado.append(nomes[x])
        if len(primeiroResultado) == 1:
            x = len(nomeResult)
        x = x + 1
    print(primeiroResultado)


#tadasCombinacoes('Guss1.jpeg')
#primeiraCombinacao('Guss1.jpeg')
