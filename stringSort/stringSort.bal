import ballerina/io;

string[] result;
string[] alphabet = ["a","b","c","d","e","f","g","h","i","j","k"
,"l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
string[] effectiveAlphabet = ["a","b","c","d","e","f","g","h","i","j","k"
,"l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];

type Bucket object {
    public {
        string[] items;
        int index;
    }

    function sortBucket();

    public function addItem(string item) {
        self.items[lengthof self.items] = item;
    }
};

function Bucket::sortBucket() {
    io:println("sortBucket function");
    map buckets = bucketize(self.items, self.index);
    addToResultArray(buckets);
}

documentation {
    Returns sorted string array after performing bucket sort repeatedly. 
    Bydefault, sorting is done on the english alphabet order.
    You can define a new set of characters to sort, by passing the desired alphabet string array,
    using the initAlphabet(string[]) method. 
    Use the resetAlphabet() method to reset the alphabet to english alphabet.
    If any character outside the alphabet isfound, it will get the least priority in sorting.

    P{{unsortedArray}} The unsorted string array
    R{{}} The sorted string array
}
public function sort(string[] unsortedArray) returns string[] {
    result = [];
    Bucket initBucket = new Bucket();
    initBucket.items = unsortedArray;
    initBucket.index = 0;
    initBucket.sortBucket();
    return result;
}

documentation {
    Define a new set of characters to sort, by passing the desired alphabet string array. 

    P{{newAlphabet}} The new alphabet to follow in sorting
}
public function initAlphabet(string[] newAlphabet) {
    effectiveAlphabet = newAlphabet;
}

documentation {
    Reset the alphabet to english alphabet.
}
public function resetAlphabet() {
    effectiveAlphabet = alphabet;
}

function bucketize(string[] strArray, int index) returns map {
    io:println("bucketize function:" + strArray[0] + index);
    map bucketsMap;
    foreach item in strArray {
     addTobucket(item,index, bucketsMap);   
    }

    return bucketsMap;
}

function addTobucket(string item, int index, map bucketsMap){
    io:println("addTobucket function");
    int nextIndex = index + 1;
    if (lengthof item < nextIndex) {
        //nothing to sort further, add to result
        result[lengthof result] = item;
    }

    boolean matchFound = false;
    foreach char in effectiveAlphabet {  
        if (item.substring(index, nextIndex).equalsIgnoreCase(char)) {
            populateMap(bucketsMap, char, item, index);
            matchFound = true;
            break;
        }
    }
    
    //skip current character and consider next.
    if(!matchFound) {
        populateMap(bucketsMap, "nonAlp", item, index);
    }   
}

function populateMap(map bucketmap, string key, string item, int index){
    io:println("populateMap function");
    if(bucketmap.hasKey(key)) {
        Bucket buck = check <Bucket>bucketmap[key];
        buck.addItem(item);
        buck.index = index+1;
    } else {
        Bucket newBucket = new Bucket();
        newBucket.addItem(item);
        newBucket.index = index+1;
        bucketmap[key] = newBucket;
    }
}

function addToResultArray(map buckets) {
    io:println("addToResultArray");
    int i = 0;
    
    while (i < lengthof effectiveAlphabet) {
        string alpChar = effectiveAlphabet[i];
        if (buckets.hasKey(alpChar)) {
            addToResultByKey(check <Bucket>buckets[alpChar]);
        }
        i++;
    }
    
    if (buckets.hasKey("nonAlp")) {
        addToResultByKey(check <Bucket>buckets["nonAlp"]);
    }
}

function addToResultByKey(Bucket thisBucket) {
    io:println("addToResultByKey function");
    if (lengthof thisBucket.items > 1) {
            io:println("in addToResultByKey:",thisBucket.items);
            thisBucket.sortBucket(); //create buckets again
        } else {
            //only one item in the bucket
            result[lengthof result] = thisBucket.items[0];
        }
}