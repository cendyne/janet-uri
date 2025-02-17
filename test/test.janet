(import ../uri :as uri)

(def parse-tests [

  ["foo://127.0.0.1"
  @{:scheme "foo" :host "127.0.0.1" :path "" :raw-path ""}]

  ["foo://example.com:8042/over%20there?name=fer%20ret#nose"
  @{:path "/over there" :raw-path "/over%20there"  :host "example.com"
    :fragment "nose" :raw-fragment "nose" :scheme "foo" :port "8042"
    :raw-query "name=fer%20ret" :query @{"name" "fer ret"}}]
  
  ["/over/there?name=ferret#nose"
  @{:path "/over/there" :raw-path "/over/there"
   :fragment "nose" :raw-fragment "nose"
   :raw-query "name=ferret" :query @{"name" "ferret"}}]

  ["/over/there?name=ferret&flag&flag2&another=4#nose"
  @{:path "/over/there" :raw-path "/over/there"
   :fragment "nose" :raw-fragment "nose"
   :raw-query "name=ferret&flag&flag2&another=4" :query @{
     "name" "ferret"
     "flag" true
     "flag2" true
     "another" "4"
     }}]

  ["//"
  @{:raw-path "" :path "" :host ""}]

  ["/"
  @{:raw-path "/" :path "/"}]
  
  [""
  @{}]
])

(each tc parse-tests
  (def r (uri/parse (tc 0)))
  (unless (deep= r (tc 1))
    (eprintf "%p\n!=\n%p" r (tc 1))
    (error "fail")))

(let [rng (math/rng (os/time))]
  (loop [i :range [0 100]]
    (def n (math/rng-int rng 2000))
    (def s (string (os/cryptorand n)))
    (unless (= s (uri/unescape (uri/escape s)))
      (error "fail."))))

(def parse-query-tests [
    ["" @{}]
    ["abc=5&%20=" @{"abc" "5" " " ""}]
    ["a=b" @{"a" "b"}]
])

(each tc parse-query-tests
  (def r (uri/parse-query (tc 0)))
  (unless (deep= r (tc 1))
    (eprintf "%p\n!=\n%p" r (tc 1))
    (error "fail")))
