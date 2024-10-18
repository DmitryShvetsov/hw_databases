# Предобработка файла.

with open("/home/pm/Downloads/misis books/ad2e0f01-e82d-4007-9af1-2cf6ad65a5b2.csv") as ouf:
    text = ouf.read()
text = text.replace("\\,", ",")

with open("/home/pm/Downloads/misis books/ad2e0f01-e82d-4007-9af1-2cf6ad65a5b2.csv", "w") as inf:
    inf.write(text)

# Также пришлось. в Libre Office (Excel) удалять запятые. Сам Libre Office хорошо разбил по столбцам.
