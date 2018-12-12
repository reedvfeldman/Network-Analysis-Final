import re
import nltk
from nltk.corpus import stopwords
import os
stop = stopwords.words('english')

#function to get all last names from workAttributes.csv
#Takes in a string of all names, splits them, returns array of last names only
def getLastNames(file):
    names = open(file)
    final = []
    for i in names.readlines():
        final.append(i.rstrip())
    for i in range(0, len(final)):
        final[i] = str(final[i].replace("-", " ").rsplit(' ', 1)[0])
    return final

#function returns sentences in .txt file that are tokenized for language tag
#output of function is each work in the sentence mapped to their respective language token
#Examples of language token include 'PERSON', 'PLACE', 'DATE' etc
def ie_preprocess(document):
    document = ' '.join([i for i in document.split() if i not in stop])
    sentences = nltk.sent_tokenize(document)
    sentences = [nltk.word_tokenize(sent) for sent in sentences]
    sentences = [nltk.pos_tag(sent) for sent in sentences]
    return sentences

#Iterate over tokenized sentences and extract chunks that are only 'PERSON'
#Return list of Names
def extract_names(document):
    names = []
    sentences = ie_preprocess(document)
    for tagged_sentence in sentences:
        for chunk in nltk.ne_chunk(tagged_sentence):
            if type(chunk) == nltk.tree.Tree:
                if chunk.label() == 'PERSON':
                    names.append(' '.join([c[0] for c in chunk]).rsplit(' ', 1)[-1])
    return names

#Call NLP functions above for a respective interview.
#This function will be used in a for loop for each interview to create the Network
def createNetwork(filename):
    with open(filename) as string:
        names = extract_names(string.read())
        lastOnly = getLastNames('namesOnly.csv')
        both = list(set(names).intersection(lastOnly))
        network = str(filename)[11:-4] + ' : ' +str(both) + ', '
        return network

#Make files readable --> returns a list of files ready for NLP name extraction
def getFiles(directory):
    file_list = [f for f in os.listdir(directory)]
    return file_list

#Main function
#Iterates over each file and extracts the names
#Writes output to final.csv
#Sample output --> Jambard_Norm_MWOH_022_cleaned : ['Lebel', 'Roy', 'Jambard', 'Harvey']
if __name__ == '__main__':
    with open('final.csv', "a", newline='') as fp:
        for i in getFiles('./csvfiles'):
            print(i)
            fp.write((createNetwork('./csvfiles/'+str(i))))
