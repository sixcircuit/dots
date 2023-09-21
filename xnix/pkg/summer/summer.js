#!/usr/bin/env node

var _ = require('dry-underscore');

function extract_line(line){

    line = _.replace(line, ",", "");

    line = line.replace(/\(.*\)/g);

    // var regex = "(?=.)([+-]?([0-9]*)(\.([0-9]+))?)";
    // var regex = "-?(([0-9]+.[0-9]*)|([0-9]*.[0-9]+)|([0-9]+))"
    // var regex = "-?([0-9]+\.[0-9]*|[0-9]+|\.[0-9]+)"
    var regex = "-?([0-9]+(:?[.][0-9]*)?)"

    var matcher = _.regex(regex, "g");

    var numbers = line.match(matcher);

    // _.p("extract_line.matches: ", numbers);

    numbers = _.map(numbers, function(n){ return(_.n(n)); });

    // _.p("extract_line.numbers: ", numbers);

    return(numbers);
}

function extract(text){
    var lines = text.split('\n');

    return(_.flatten(_.map(lines, extract_line)));
}

function sum(text){ return _.sum(extract(text)); }

exports.extract = extract;
exports.sum = sum;
