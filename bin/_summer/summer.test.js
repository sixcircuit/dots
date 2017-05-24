
var _ = require('dry-underscore');

var eq = _.test.eq;

var summer = require('./summer.js');

suite("summer");

function number_array(a){ return(_.map(a, function(n){ return(_.n(n)); })); }

test('integer extract', function(){

    var expected = ["1", "-2", "3", "-4"];
    var text = expected.join("\n");

    expected = number_array(expected);

    var actual = summer.extract(text);

    eq(actual, expected);
});


test('float extract', function(){

    var text =     ["0.1", "-0.1", "0.1", "1.123", "-2.345", "3.456", "-4.567"].join("\n");
    var expected = [0.1, -0.1, 0.1, 1.123, -2.345, 3.456, -4.567];

    var actual = summer.extract(text);

    eq(actual, expected);
});

test('complex extract and sum', function(){

    var line_one = "blah 1.123 some text 1 0.1 0.1 -0.1";
    var line_one_expected = [1.123, 1, 0.1, 0.1, -0.1];

    var expected = _.concat(line_one_expected, [-2.345, -2.345, 3.456, 5, 6, 700, 8, -4.567]);
    var text = [line_one, "-2.345 some more text -2.345 (12345.4 ignored)", "3.456 more text 5 6 700 8", "more text -4.567"].join("\n");

    var actual = summer.extract(text);

    eq(actual, expected);

    var sum = summer.sum(text);
    eq(sum, _.sum(expected));

});
