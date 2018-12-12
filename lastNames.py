def getLastNames(file):
    names = open(file)
    final = []
    for i in names.readlines():
        final.append(i.rstrip())
    for i in range(0, len(final)):
        final[i] = str(final[i].replace("-", " ").rsplit(' ', 1)[0])
    return final

print(getLastNames('namesOnly.csv'))
