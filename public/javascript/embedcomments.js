//    discqus variables
var disqus_shortname = 'medu';
var disqus_developer = 1;

// test settings - comment out before releasing
var disqus_title  = "test page";
var disqus_category_id  = "test category 2" ;
var disqus_identifier = "5555";

//var test = true;

(function() {
  var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
  dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();