<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
<head>
<title>users/hmh/autotools-dev - Debian autotools-dev package git tree</title>
<meta name='generator' content='cgit v0.10.2'/>
<meta name='robots' content='index, nofollow'/>
<link rel='stylesheet' type='text/css' href='/cgit-css/cgit.css'/>
<link rel='shortcut icon' href='/favicon.ico'/>
<link rel='alternate' title='Atom feed' href='http://anonscm.debian.org/cgit/users/hmh/autotools-dev.git/atom/config.guess?h=master' type='application/atom+xml'/>
</head>
<body>
<div id='cgit'><table id='header'>
<tr>
<td class='logo' rowspan='2'><a href='/cgit/'><img src='https://anonscm.debian.org/alioth.png' alt='cgit logo'/></a></td>
<td class='main'><a href='/cgit/'>index</a> : <a title='users/hmh/autotools-dev' href='/cgit/users/hmh/autotools-dev.git/'>users/hmh/autotools-dev</a></td><td class='form'><form method='get' action=''>
<select name='h' onchange='this.form.submit();'>
<option value='master' selected='selected'>master</option>
</select> <input type='submit' name='' value='switch'/></form></td></tr>
<tr><td class='sub'>Debian autotools-dev package git tree</td><td class='sub right'></td></tr></table>
<table class='tabs'><tr><td>
<a href='/cgit/users/hmh/autotools-dev.git/'>summary</a><a href='/cgit/users/hmh/autotools-dev.git/refs/'>refs</a><a href='/cgit/users/hmh/autotools-dev.git/log/config.guess'>log</a><a class='active' href='/cgit/users/hmh/autotools-dev.git/tree/config.guess'>tree</a><a href='/cgit/users/hmh/autotools-dev.git/commit/config.guess'>commit</a><a href='/cgit/users/hmh/autotools-dev.git/diff/config.guess'>diff</a></td><td class='form'><form class='right' method='get' action='/cgit/users/hmh/autotools-dev.git/log/config.guess'>
<select name='qt'>
<option value='grep'>log msg</option>
<option value='author'>author</option>
<option value='committer'>committer</option>
<option value='range'>range</option>
</select>
<input class='txt' type='text' size='10' name='q' value=''/>
<input type='submit' value='search'/>
</form>
</td></tr></table>
<div class='path'>path: <a href='/cgit/users/hmh/autotools-dev.git/tree/'>root</a>/<a href='/cgit/users/hmh/autotools-dev.git/tree/config.guess'>config.guess</a></div><div class='content'>blob: 1f5c50c0d1529d50b94dc3533ca72a47f0fa5849 (<a href='/cgit/users/hmh/autotools-dev.git/plain/config.guess'>plain</a>)
<table summary='blob content' class='blob'>
<tr><td class='linenumbers'><pre><a id='n1' href='#n1'>1</a>
<a id='n2' href='#n2'>2</a>
<a id='n3' href='#n3'>3</a>
<a id='n4' href='#n4'>4</a>
<a id='n5' href='#n5'>5</a>
<a id='n6' href='#n6'>6</a>
<a id='n7' href='#n7'>7</a>
<a id='n8' href='#n8'>8</a>
<a id='n9' href='#n9'>9</a>
<a id='n10' href='#n10'>10</a>
<a id='n11' href='#n11'>11</a>
<a id='n12' href='#n12'>12</a>
<a id='n13' href='#n13'>13</a>
<a id='n14' href='#n14'>14</a>
<a id='n15' href='#n15'>15</a>
<a id='n16' href='#n16'>16</a>
<a id='n17' href='#n17'>17</a>
<a id='n18' href='#n18'>18</a>
<a id='n19' href='#n19'>19</a>
<a id='n20' href='#n20'>20</a>
<a id='n21' href='#n21'>21</a>
<a id='n22' href='#n22'>22</a>
<a id='n23' href='#n23'>23</a>
<a id='n24' href='#n24'>24</a>
<a id='n25' href='#n25'>25</a>
<a id='n26' href='#n26'>26</a>
<a id='n27' href='#n27'>27</a>
<a id='n28' href='#n28'>28</a>
<a id='n29' href='#n29'>29</a>
<a id='n30' href='#n30'>30</a>
<a id='n31' href='#n31'>31</a>
<a id='n32' href='#n32'>32</a>
<a id='n33' href='#n33'>33</a>
<a id='n34' href='#n34'>34</a>
<a id='n35' href='#n35'>35</a>
<a id='n36' href='#n36'>36</a>
<a id='n37' href='#n37'>37</a>
<a id='n38' href='#n38'>38</a>
<a id='n39' href='#n39'>39</a>
<a id='n40' href='#n40'>40</a>
<a id='n41' href='#n41'>41</a>
<a id='n42' href='#n42'>42</a>
<a id='n43' href='#n43'>43</a>
<a id='n44' href='#n44'>44</a>
<a id='n45' href='#n45'>45</a>
<a id='n46' href='#n46'>46</a>
<a id='n47' href='#n47'>47</a>
<a id='n48' href='#n48'>48</a>
<a id='n49' href='#n49'>49</a>
<a id='n50' href='#n50'>50</a>
<a id='n51' href='#n51'>51</a>
<a id='n52' href='#n52'>52</a>
<a id='n53' href='#n53'>53</a>
<a id='n54' href='#n54'>54</a>
<a id='n55' href='#n55'>55</a>
<a id='n56' href='#n56'>56</a>
<a id='n57' href='#n57'>57</a>
<a id='n58' href='#n58'>58</a>
<a id='n59' href='#n59'>59</a>
<a id='n60' href='#n60'>60</a>
<a id='n61' href='#n61'>61</a>
<a id='n62' href='#n62'>62</a>
<a id='n63' href='#n63'>63</a>
<a id='n64' href='#n64'>64</a>
<a id='n65' href='#n65'>65</a>
<a id='n66' href='#n66'>66</a>
<a id='n67' href='#n67'>67</a>
<a id='n68' href='#n68'>68</a>
<a id='n69' href='#n69'>69</a>
<a id='n70' href='#n70'>70</a>
<a id='n71' href='#n71'>71</a>
<a id='n72' href='#n72'>72</a>
<a id='n73' href='#n73'>73</a>
<a id='n74' href='#n74'>74</a>
<a id='n75' href='#n75'>75</a>
<a id='n76' href='#n76'>76</a>
<a id='n77' href='#n77'>77</a>
<a id='n78' href='#n78'>78</a>
<a id='n79' href='#n79'>79</a>
<a id='n80' href='#n80'>80</a>
<a id='n81' href='#n81'>81</a>
<a id='n82' href='#n82'>82</a>
<a id='n83' href='#n83'>83</a>
<a id='n84' href='#n84'>84</a>
<a id='n85' href='#n85'>85</a>
<a id='n86' href='#n86'>86</a>
<a id='n87' href='#n87'>87</a>
<a id='n88' href='#n88'>88</a>
<a id='n89' href='#n89'>89</a>
<a id='n90' href='#n90'>90</a>
<a id='n91' href='#n91'>91</a>
<a id='n92' href='#n92'>92</a>
<a id='n93' href='#n93'>93</a>
<a id='n94' href='#n94'>94</a>
<a id='n95' href='#n95'>95</a>
<a id='n96' href='#n96'>96</a>
<a id='n97' href='#n97'>97</a>
<a id='n98' href='#n98'>98</a>
<a id='n99' href='#n99'>99</a>
<a id='n100' href='#n100'>100</a>
<a id='n101' href='#n101'>101</a>
<a id='n102' href='#n102'>102</a>
<a id='n103' href='#n103'>103</a>
<a id='n104' href='#n104'>104</a>
<a id='n105' href='#n105'>105</a>
<a id='n106' href='#n106'>106</a>
<a id='n107' href='#n107'>107</a>
<a id='n108' href='#n108'>108</a>
<a id='n109' href='#n109'>109</a>
<a id='n110' href='#n110'>110</a>
<a id='n111' href='#n111'>111</a>
<a id='n112' href='#n112'>112</a>
<a id='n113' href='#n113'>113</a>
<a id='n114' href='#n114'>114</a>
<a id='n115' href='#n115'>115</a>
<a id='n116' href='#n116'>116</a>
<a id='n117' href='#n117'>117</a>
<a id='n118' href='#n118'>118</a>
<a id='n119' href='#n119'>119</a>
<a id='n120' href='#n120'>120</a>
<a id='n121' href='#n121'>121</a>
<a id='n122' href='#n122'>122</a>
<a id='n123' href='#n123'>123</a>
<a id='n124' href='#n124'>124</a>
<a id='n125' href='#n125'>125</a>
<a id='n126' href='#n126'>126</a>
<a id='n127' href='#n127'>127</a>
<a id='n128' href='#n128'>128</a>
<a id='n129' href='#n129'>129</a>
<a id='n130' href='#n130'>130</a>
<a id='n131' href='#n131'>131</a>
<a id='n132' href='#n132'>132</a>
<a id='n133' href='#n133'>133</a>
<a id='n134' href='#n134'>134</a>
<a id='n135' href='#n135'>135</a>
<a id='n136' href='#n136'>136</a>
<a id='n137' href='#n137'>137</a>
<a id='n138' href='#n138'>138</a>
<a id='n139' href='#n139'>139</a>
<a id='n140' href='#n140'>140</a>
<a id='n141' href='#n141'>141</a>
<a id='n142' href='#n142'>142</a>
<a id='n143' href='#n143'>143</a>
<a id='n144' href='#n144'>144</a>
<a id='n145' href='#n145'>145</a>
<a id='n146' href='#n146'>146</a>
<a id='n147' href='#n147'>147</a>
<a id='n148' href='#n148'>148</a>
<a id='n149' href='#n149'>149</a>
<a id='n150' href='#n150'>150</a>
<a id='n151' href='#n151'>151</a>
<a id='n152' href='#n152'>152</a>
<a id='n153' href='#n153'>153</a>
<a id='n154' href='#n154'>154</a>
<a id='n155' href='#n155'>155</a>
<a id='n156' href='#n156'>156</a>
<a id='n157' href='#n157'>157</a>
<a id='n158' href='#n158'>158</a>
<a id='n159' href='#n159'>159</a>
<a id='n160' href='#n160'>160</a>
<a id='n161' href='#n161'>161</a>
<a id='n162' href='#n162'>162</a>
<a id='n163' href='#n163'>163</a>
<a id='n164' href='#n164'>164</a>
<a id='n165' href='#n165'>165</a>
<a id='n166' href='#n166'>166</a>
<a id='n167' href='#n167'>167</a>
<a id='n168' href='#n168'>168</a>
<a id='n169' href='#n169'>169</a>
<a id='n170' href='#n170'>170</a>
<a id='n171' href='#n171'>171</a>
<a id='n172' href='#n172'>172</a>
<a id='n173' href='#n173'>173</a>
<a id='n174' href='#n174'>174</a>
<a id='n175' href='#n175'>175</a>
<a id='n176' href='#n176'>176</a>
<a id='n177' href='#n177'>177</a>
<a id='n178' href='#n178'>178</a>
<a id='n179' href='#n179'>179</a>
<a id='n180' href='#n180'>180</a>
<a id='n181' href='#n181'>181</a>
<a id='n182' href='#n182'>182</a>
<a id='n183' href='#n183'>183</a>
<a id='n184' href='#n184'>184</a>
<a id='n185' href='#n185'>185</a>
<a id='n186' href='#n186'>186</a>
<a id='n187' href='#n187'>187</a>
<a id='n188' href='#n188'>188</a>
<a id='n189' href='#n189'>189</a>
<a id='n190' href='#n190'>190</a>
<a id='n191' href='#n191'>191</a>
<a id='n192' href='#n192'>192</a>
<a id='n193' href='#n193'>193</a>
<a id='n194' href='#n194'>194</a>
<a id='n195' href='#n195'>195</a>
<a id='n196' href='#n196'>196</a>
<a id='n197' href='#n197'>197</a>
<a id='n198' href='#n198'>198</a>
<a id='n199' href='#n199'>199</a>
<a id='n200' href='#n200'>200</a>
<a id='n201' href='#n201'>201</a>
<a id='n202' href='#n202'>202</a>
<a id='n203' href='#n203'>203</a>
<a id='n204' href='#n204'>204</a>
<a id='n205' href='#n205'>205</a>
<a id='n206' href='#n206'>206</a>
<a id='n207' href='#n207'>207</a>
<a id='n208' href='#n208'>208</a>
<a id='n209' href='#n209'>209</a>
<a id='n210' href='#n210'>210</a>
<a id='n211' href='#n211'>211</a>
<a id='n212' href='#n212'>212</a>
<a id='n213' href='#n213'>213</a>
<a id='n214' href='#n214'>214</a>
<a id='n215' href='#n215'>215</a>
<a id='n216' href='#n216'>216</a>
<a id='n217' href='#n217'>217</a>
<a id='n218' href='#n218'>218</a>
<a id='n219' href='#n219'>219</a>
<a id='n220' href='#n220'>220</a>
<a id='n221' href='#n221'>221</a>
<a id='n222' href='#n222'>222</a>
<a id='n223' href='#n223'>223</a>
<a id='n224' href='#n224'>224</a>
<a id='n225' href='#n225'>225</a>
<a id='n226' href='#n226'>226</a>
<a id='n227' href='#n227'>227</a>
<a id='n228' href='#n228'>228</a>
<a id='n229' href='#n229'>229</a>
<a id='n230' href='#n230'>230</a>
<a id='n231' href='#n231'>231</a>
<a id='n232' href='#n232'>232</a>
<a id='n233' href='#n233'>233</a>
<a id='n234' href='#n234'>234</a>
<a id='n235' href='#n235'>235</a>
<a id='n236' href='#n236'>236</a>
<a id='n237' href='#n237'>237</a>
<a id='n238' href='#n238'>238</a>
<a id='n239' href='#n239'>239</a>
<a id='n240' href='#n240'>240</a>
<a id='n241' href='#n241'>241</a>
<a id='n242' href='#n242'>242</a>
<a id='n243' href='#n243'>243</a>
<a id='n244' href='#n244'>244</a>
<a id='n245' href='#n245'>245</a>
<a id='n246' href='#n246'>246</a>
<a id='n247' href='#n247'>247</a>
<a id='n248' href='#n248'>248</a>
<a id='n249' href='#n249'>249</a>
<a id='n250' href='#n250'>250</a>
<a id='n251' href='#n251'>251</a>
<a id='n252' href='#n252'>252</a>
<a id='n253' href='#n253'>253</a>
<a id='n254' href='#n254'>254</a>
<a id='n255' href='#n255'>255</a>
<a id='n256' href='#n256'>256</a>
<a id='n257' href='#n257'>257</a>
<a id='n258' href='#n258'>258</a>
<a id='n259' href='#n259'>259</a>
<a id='n260' href='#n260'>260</a>
<a id='n261' href='#n261'>261</a>
<a id='n262' href='#n262'>262</a>
<a id='n263' href='#n263'>263</a>
<a id='n264' href='#n264'>264</a>
<a id='n265' href='#n265'>265</a>
<a id='n266' href='#n266'>266</a>
<a id='n267' href='#n267'>267</a>
<a id='n268' href='#n268'>268</a>
<a id='n269' href='#n269'>269</a>
<a id='n270' href='#n270'>270</a>
<a id='n271' href='#n271'>271</a>
<a id='n272' href='#n272'>272</a>
<a id='n273' href='#n273'>273</a>
<a id='n274' href='#n274'>274</a>
<a id='n275' href='#n275'>275</a>
<a id='n276' href='#n276'>276</a>
<a id='n277' href='#n277'>277</a>
<a id='n278' href='#n278'>278</a>
<a id='n279' href='#n279'>279</a>
<a id='n280' href='#n280'>280</a>
<a id='n281' href='#n281'>281</a>
<a id='n282' href='#n282'>282</a>
<a id='n283' href='#n283'>283</a>
<a id='n284' href='#n284'>284</a>
<a id='n285' href='#n285'>285</a>
<a id='n286' href='#n286'>286</a>
<a id='n287' href='#n287'>287</a>
<a id='n288' href='#n288'>288</a>
<a id='n289' href='#n289'>289</a>
<a id='n290' href='#n290'>290</a>
<a id='n291' href='#n291'>291</a>
<a id='n292' href='#n292'>292</a>
<a id='n293' href='#n293'>293</a>
<a id='n294' href='#n294'>294</a>
<a id='n295' href='#n295'>295</a>
<a id='n296' href='#n296'>296</a>
<a id='n297' href='#n297'>297</a>
<a id='n298' href='#n298'>298</a>
<a id='n299' href='#n299'>299</a>
<a id='n300' href='#n300'>300</a>
<a id='n301' href='#n301'>301</a>
<a id='n302' href='#n302'>302</a>
<a id='n303' href='#n303'>303</a>
<a id='n304' href='#n304'>304</a>
<a id='n305' href='#n305'>305</a>
<a id='n306' href='#n306'>306</a>
<a id='n307' href='#n307'>307</a>
<a id='n308' href='#n308'>308</a>
<a id='n309' href='#n309'>309</a>
<a id='n310' href='#n310'>310</a>
<a id='n311' href='#n311'>311</a>
<a id='n312' href='#n312'>312</a>
<a id='n313' href='#n313'>313</a>
<a id='n314' href='#n314'>314</a>
<a id='n315' href='#n315'>315</a>
<a id='n316' href='#n316'>316</a>
<a id='n317' href='#n317'>317</a>
<a id='n318' href='#n318'>318</a>
<a id='n319' href='#n319'>319</a>
<a id='n320' href='#n320'>320</a>
<a id='n321' href='#n321'>321</a>
<a id='n322' href='#n322'>322</a>
<a id='n323' href='#n323'>323</a>
<a id='n324' href='#n324'>324</a>
<a id='n325' href='#n325'>325</a>
<a id='n326' href='#n326'>326</a>
<a id='n327' href='#n327'>327</a>
<a id='n328' href='#n328'>328</a>
<a id='n329' href='#n329'>329</a>
<a id='n330' href='#n330'>330</a>
<a id='n331' href='#n331'>331</a>
<a id='n332' href='#n332'>332</a>
<a id='n333' href='#n333'>333</a>
<a id='n334' href='#n334'>334</a>
<a id='n335' href='#n335'>335</a>
<a id='n336' href='#n336'>336</a>
<a id='n337' href='#n337'>337</a>
<a id='n338' href='#n338'>338</a>
<a id='n339' href='#n339'>339</a>
<a id='n340' href='#n340'>340</a>
<a id='n341' href='#n341'>341</a>
<a id='n342' href='#n342'>342</a>
<a id='n343' href='#n343'>343</a>
<a id='n344' href='#n344'>344</a>
<a id='n345' href='#n345'>345</a>
<a id='n346' href='#n346'>346</a>
<a id='n347' href='#n347'>347</a>
<a id='n348' href='#n348'>348</a>
<a id='n349' href='#n349'>349</a>
<a id='n350' href='#n350'>350</a>
<a id='n351' href='#n351'>351</a>
<a id='n352' href='#n352'>352</a>
<a id='n353' href='#n353'>353</a>
<a id='n354' href='#n354'>354</a>
<a id='n355' href='#n355'>355</a>
<a id='n356' href='#n356'>356</a>
<a id='n357' href='#n357'>357</a>
<a id='n358' href='#n358'>358</a>
<a id='n359' href='#n359'>359</a>
<a id='n360' href='#n360'>360</a>
<a id='n361' href='#n361'>361</a>
<a id='n362' href='#n362'>362</a>
<a id='n363' href='#n363'>363</a>
<a id='n364' href='#n364'>364</a>
<a id='n365' href='#n365'>365</a>
<a id='n366' href='#n366'>366</a>
<a id='n367' href='#n367'>367</a>
<a id='n368' href='#n368'>368</a>
<a id='n369' href='#n369'>369</a>
<a id='n370' href='#n370'>370</a>
<a id='n371' href='#n371'>371</a>
<a id='n372' href='#n372'>372</a>
<a id='n373' href='#n373'>373</a>
<a id='n374' href='#n374'>374</a>
<a id='n375' href='#n375'>375</a>
<a id='n376' href='#n376'>376</a>
<a id='n377' href='#n377'>377</a>
<a id='n378' href='#n378'>378</a>
<a id='n379' href='#n379'>379</a>
<a id='n380' href='#n380'>380</a>
<a id='n381' href='#n381'>381</a>
<a id='n382' href='#n382'>382</a>
<a id='n383' href='#n383'>383</a>
<a id='n384' href='#n384'>384</a>
<a id='n385' href='#n385'>385</a>
<a id='n386' href='#n386'>386</a>
<a id='n387' href='#n387'>387</a>
<a id='n388' href='#n388'>388</a>
<a id='n389' href='#n389'>389</a>
<a id='n390' href='#n390'>390</a>
<a id='n391' href='#n391'>391</a>
<a id='n392' href='#n392'>392</a>
<a id='n393' href='#n393'>393</a>
<a id='n394' href='#n394'>394</a>
<a id='n395' href='#n395'>395</a>
<a id='n396' href='#n396'>396</a>
<a id='n397' href='#n397'>397</a>
<a id='n398' href='#n398'>398</a>
<a id='n399' href='#n399'>399</a>
<a id='n400' href='#n400'>400</a>
<a id='n401' href='#n401'>401</a>
<a id='n402' href='#n402'>402</a>
<a id='n403' href='#n403'>403</a>
<a id='n404' href='#n404'>404</a>
<a id='n405' href='#n405'>405</a>
<a id='n406' href='#n406'>406</a>
<a id='n407' href='#n407'>407</a>
<a id='n408' href='#n408'>408</a>
<a id='n409' href='#n409'>409</a>
<a id='n410' href='#n410'>410</a>
<a id='n411' href='#n411'>411</a>
<a id='n412' href='#n412'>412</a>
<a id='n413' href='#n413'>413</a>
<a id='n414' href='#n414'>414</a>
<a id='n415' href='#n415'>415</a>
<a id='n416' href='#n416'>416</a>
<a id='n417' href='#n417'>417</a>
<a id='n418' href='#n418'>418</a>
<a id='n419' href='#n419'>419</a>
<a id='n420' href='#n420'>420</a>
<a id='n421' href='#n421'>421</a>
<a id='n422' href='#n422'>422</a>
<a id='n423' href='#n423'>423</a>
<a id='n424' href='#n424'>424</a>
<a id='n425' href='#n425'>425</a>
<a id='n426' href='#n426'>426</a>
<a id='n427' href='#n427'>427</a>
<a id='n428' href='#n428'>428</a>
<a id='n429' href='#n429'>429</a>
<a id='n430' href='#n430'>430</a>
<a id='n431' href='#n431'>431</a>
<a id='n432' href='#n432'>432</a>
<a id='n433' href='#n433'>433</a>
<a id='n434' href='#n434'>434</a>
<a id='n435' href='#n435'>435</a>
<a id='n436' href='#n436'>436</a>
<a id='n437' href='#n437'>437</a>
<a id='n438' href='#n438'>438</a>
<a id='n439' href='#n439'>439</a>
<a id='n440' href='#n440'>440</a>
<a id='n441' href='#n441'>441</a>
<a id='n442' href='#n442'>442</a>
<a id='n443' href='#n443'>443</a>
<a id='n444' href='#n444'>444</a>
<a id='n445' href='#n445'>445</a>
<a id='n446' href='#n446'>446</a>
<a id='n447' href='#n447'>447</a>
<a id='n448' href='#n448'>448</a>
<a id='n449' href='#n449'>449</a>
<a id='n450' href='#n450'>450</a>
<a id='n451' href='#n451'>451</a>
<a id='n452' href='#n452'>452</a>
<a id='n453' href='#n453'>453</a>
<a id='n454' href='#n454'>454</a>
<a id='n455' href='#n455'>455</a>
<a id='n456' href='#n456'>456</a>
<a id='n457' href='#n457'>457</a>
<a id='n458' href='#n458'>458</a>
<a id='n459' href='#n459'>459</a>
<a id='n460' href='#n460'>460</a>
<a id='n461' href='#n461'>461</a>
<a id='n462' href='#n462'>462</a>
<a id='n463' href='#n463'>463</a>
<a id='n464' href='#n464'>464</a>
<a id='n465' href='#n465'>465</a>
<a id='n466' href='#n466'>466</a>
<a id='n467' href='#n467'>467</a>
<a id='n468' href='#n468'>468</a>
<a id='n469' href='#n469'>469</a>
<a id='n470' href='#n470'>470</a>
<a id='n471' href='#n471'>471</a>
<a id='n472' href='#n472'>472</a>
<a id='n473' href='#n473'>473</a>
<a id='n474' href='#n474'>474</a>
<a id='n475' href='#n475'>475</a>
<a id='n476' href='#n476'>476</a>
<a id='n477' href='#n477'>477</a>
<a id='n478' href='#n478'>478</a>
<a id='n479' href='#n479'>479</a>
<a id='n480' href='#n480'>480</a>
<a id='n481' href='#n481'>481</a>
<a id='n482' href='#n482'>482</a>
<a id='n483' href='#n483'>483</a>
<a id='n484' href='#n484'>484</a>
<a id='n485' href='#n485'>485</a>
<a id='n486' href='#n486'>486</a>
<a id='n487' href='#n487'>487</a>
<a id='n488' href='#n488'>488</a>
<a id='n489' href='#n489'>489</a>
<a id='n490' href='#n490'>490</a>
<a id='n491' href='#n491'>491</a>
<a id='n492' href='#n492'>492</a>
<a id='n493' href='#n493'>493</a>
<a id='n494' href='#n494'>494</a>
<a id='n495' href='#n495'>495</a>
<a id='n496' href='#n496'>496</a>
<a id='n497' href='#n497'>497</a>
<a id='n498' href='#n498'>498</a>
<a id='n499' href='#n499'>499</a>
<a id='n500' href='#n500'>500</a>
<a id='n501' href='#n501'>501</a>
<a id='n502' href='#n502'>502</a>
<a id='n503' href='#n503'>503</a>
<a id='n504' href='#n504'>504</a>
<a id='n505' href='#n505'>505</a>
<a id='n506' href='#n506'>506</a>
<a id='n507' href='#n507'>507</a>
<a id='n508' href='#n508'>508</a>
<a id='n509' href='#n509'>509</a>
<a id='n510' href='#n510'>510</a>
<a id='n511' href='#n511'>511</a>
<a id='n512' href='#n512'>512</a>
<a id='n513' href='#n513'>513</a>
<a id='n514' href='#n514'>514</a>
<a id='n515' href='#n515'>515</a>
<a id='n516' href='#n516'>516</a>
<a id='n517' href='#n517'>517</a>
<a id='n518' href='#n518'>518</a>
<a id='n519' href='#n519'>519</a>
<a id='n520' href='#n520'>520</a>
<a id='n521' href='#n521'>521</a>
<a id='n522' href='#n522'>522</a>
<a id='n523' href='#n523'>523</a>
<a id='n524' href='#n524'>524</a>
<a id='n525' href='#n525'>525</a>
<a id='n526' href='#n526'>526</a>
<a id='n527' href='#n527'>527</a>
<a id='n528' href='#n528'>528</a>
<a id='n529' href='#n529'>529</a>
<a id='n530' href='#n530'>530</a>
<a id='n531' href='#n531'>531</a>
<a id='n532' href='#n532'>532</a>
<a id='n533' href='#n533'>533</a>
<a id='n534' href='#n534'>534</a>
<a id='n535' href='#n535'>535</a>
<a id='n536' href='#n536'>536</a>
<a id='n537' href='#n537'>537</a>
<a id='n538' href='#n538'>538</a>
<a id='n539' href='#n539'>539</a>
<a id='n540' href='#n540'>540</a>
<a id='n541' href='#n541'>541</a>
<a id='n542' href='#n542'>542</a>
<a id='n543' href='#n543'>543</a>
<a id='n544' href='#n544'>544</a>
<a id='n545' href='#n545'>545</a>
<a id='n546' href='#n546'>546</a>
<a id='n547' href='#n547'>547</a>
<a id='n548' href='#n548'>548</a>
<a id='n549' href='#n549'>549</a>
<a id='n550' href='#n550'>550</a>
<a id='n551' href='#n551'>551</a>
<a id='n552' href='#n552'>552</a>
<a id='n553' href='#n553'>553</a>
<a id='n554' href='#n554'>554</a>
<a id='n555' href='#n555'>555</a>
<a id='n556' href='#n556'>556</a>
<a id='n557' href='#n557'>557</a>
<a id='n558' href='#n558'>558</a>
<a id='n559' href='#n559'>559</a>
<a id='n560' href='#n560'>560</a>
<a id='n561' href='#n561'>561</a>
<a id='n562' href='#n562'>562</a>
<a id='n563' href='#n563'>563</a>
<a id='n564' href='#n564'>564</a>
<a id='n565' href='#n565'>565</a>
<a id='n566' href='#n566'>566</a>
<a id='n567' href='#n567'>567</a>
<a id='n568' href='#n568'>568</a>
<a id='n569' href='#n569'>569</a>
<a id='n570' href='#n570'>570</a>
<a id='n571' href='#n571'>571</a>
<a id='n572' href='#n572'>572</a>
<a id='n573' href='#n573'>573</a>
<a id='n574' href='#n574'>574</a>
<a id='n575' href='#n575'>575</a>
<a id='n576' href='#n576'>576</a>
<a id='n577' href='#n577'>577</a>
<a id='n578' href='#n578'>578</a>
<a id='n579' href='#n579'>579</a>
<a id='n580' href='#n580'>580</a>
<a id='n581' href='#n581'>581</a>
<a id='n582' href='#n582'>582</a>
<a id='n583' href='#n583'>583</a>
<a id='n584' href='#n584'>584</a>
<a id='n585' href='#n585'>585</a>
<a id='n586' href='#n586'>586</a>
<a id='n587' href='#n587'>587</a>
<a id='n588' href='#n588'>588</a>
<a id='n589' href='#n589'>589</a>
<a id='n590' href='#n590'>590</a>
<a id='n591' href='#n591'>591</a>
<a id='n592' href='#n592'>592</a>
<a id='n593' href='#n593'>593</a>
<a id='n594' href='#n594'>594</a>
<a id='n595' href='#n595'>595</a>
<a id='n596' href='#n596'>596</a>
<a id='n597' href='#n597'>597</a>
<a id='n598' href='#n598'>598</a>
<a id='n599' href='#n599'>599</a>
<a id='n600' href='#n600'>600</a>
<a id='n601' href='#n601'>601</a>
<a id='n602' href='#n602'>602</a>
<a id='n603' href='#n603'>603</a>
<a id='n604' href='#n604'>604</a>
<a id='n605' href='#n605'>605</a>
<a id='n606' href='#n606'>606</a>
<a id='n607' href='#n607'>607</a>
<a id='n608' href='#n608'>608</a>
<a id='n609' href='#n609'>609</a>
<a id='n610' href='#n610'>610</a>
<a id='n611' href='#n611'>611</a>
<a id='n612' href='#n612'>612</a>
<a id='n613' href='#n613'>613</a>
<a id='n614' href='#n614'>614</a>
<a id='n615' href='#n615'>615</a>
<a id='n616' href='#n616'>616</a>
<a id='n617' href='#n617'>617</a>
<a id='n618' href='#n618'>618</a>
<a id='n619' href='#n619'>619</a>
<a id='n620' href='#n620'>620</a>
<a id='n621' href='#n621'>621</a>
<a id='n622' href='#n622'>622</a>
<a id='n623' href='#n623'>623</a>
<a id='n624' href='#n624'>624</a>
<a id='n625' href='#n625'>625</a>
<a id='n626' href='#n626'>626</a>
<a id='n627' href='#n627'>627</a>
<a id='n628' href='#n628'>628</a>
<a id='n629' href='#n629'>629</a>
<a id='n630' href='#n630'>630</a>
<a id='n631' href='#n631'>631</a>
<a id='n632' href='#n632'>632</a>
<a id='n633' href='#n633'>633</a>
<a id='n634' href='#n634'>634</a>
<a id='n635' href='#n635'>635</a>
<a id='n636' href='#n636'>636</a>
<a id='n637' href='#n637'>637</a>
<a id='n638' href='#n638'>638</a>
<a id='n639' href='#n639'>639</a>
<a id='n640' href='#n640'>640</a>
<a id='n641' href='#n641'>641</a>
<a id='n642' href='#n642'>642</a>
<a id='n643' href='#n643'>643</a>
<a id='n644' href='#n644'>644</a>
<a id='n645' href='#n645'>645</a>
<a id='n646' href='#n646'>646</a>
<a id='n647' href='#n647'>647</a>
<a id='n648' href='#n648'>648</a>
<a id='n649' href='#n649'>649</a>
<a id='n650' href='#n650'>650</a>
<a id='n651' href='#n651'>651</a>
<a id='n652' href='#n652'>652</a>
<a id='n653' href='#n653'>653</a>
<a id='n654' href='#n654'>654</a>
<a id='n655' href='#n655'>655</a>
<a id='n656' href='#n656'>656</a>
<a id='n657' href='#n657'>657</a>
<a id='n658' href='#n658'>658</a>
<a id='n659' href='#n659'>659</a>
<a id='n660' href='#n660'>660</a>
<a id='n661' href='#n661'>661</a>
<a id='n662' href='#n662'>662</a>
<a id='n663' href='#n663'>663</a>
<a id='n664' href='#n664'>664</a>
<a id='n665' href='#n665'>665</a>
<a id='n666' href='#n666'>666</a>
<a id='n667' href='#n667'>667</a>
<a id='n668' href='#n668'>668</a>
<a id='n669' href='#n669'>669</a>
<a id='n670' href='#n670'>670</a>
<a id='n671' href='#n671'>671</a>
<a id='n672' href='#n672'>672</a>
<a id='n673' href='#n673'>673</a>
<a id='n674' href='#n674'>674</a>
<a id='n675' href='#n675'>675</a>
<a id='n676' href='#n676'>676</a>
<a id='n677' href='#n677'>677</a>
<a id='n678' href='#n678'>678</a>
<a id='n679' href='#n679'>679</a>
<a id='n680' href='#n680'>680</a>
<a id='n681' href='#n681'>681</a>
<a id='n682' href='#n682'>682</a>
<a id='n683' href='#n683'>683</a>
<a id='n684' href='#n684'>684</a>
<a id='n685' href='#n685'>685</a>
<a id='n686' href='#n686'>686</a>
<a id='n687' href='#n687'>687</a>
<a id='n688' href='#n688'>688</a>
<a id='n689' href='#n689'>689</a>
<a id='n690' href='#n690'>690</a>
<a id='n691' href='#n691'>691</a>
<a id='n692' href='#n692'>692</a>
<a id='n693' href='#n693'>693</a>
<a id='n694' href='#n694'>694</a>
<a id='n695' href='#n695'>695</a>
<a id='n696' href='#n696'>696</a>
<a id='n697' href='#n697'>697</a>
<a id='n698' href='#n698'>698</a>
<a id='n699' href='#n699'>699</a>
<a id='n700' href='#n700'>700</a>
<a id='n701' href='#n701'>701</a>
<a id='n702' href='#n702'>702</a>
<a id='n703' href='#n703'>703</a>
<a id='n704' href='#n704'>704</a>
<a id='n705' href='#n705'>705</a>
<a id='n706' href='#n706'>706</a>
<a id='n707' href='#n707'>707</a>
<a id='n708' href='#n708'>708</a>
<a id='n709' href='#n709'>709</a>
<a id='n710' href='#n710'>710</a>
<a id='n711' href='#n711'>711</a>
<a id='n712' href='#n712'>712</a>
<a id='n713' href='#n713'>713</a>
<a id='n714' href='#n714'>714</a>
<a id='n715' href='#n715'>715</a>
<a id='n716' href='#n716'>716</a>
<a id='n717' href='#n717'>717</a>
<a id='n718' href='#n718'>718</a>
<a id='n719' href='#n719'>719</a>
<a id='n720' href='#n720'>720</a>
<a id='n721' href='#n721'>721</a>
<a id='n722' href='#n722'>722</a>
<a id='n723' href='#n723'>723</a>
<a id='n724' href='#n724'>724</a>
<a id='n725' href='#n725'>725</a>
<a id='n726' href='#n726'>726</a>
<a id='n727' href='#n727'>727</a>
<a id='n728' href='#n728'>728</a>
<a id='n729' href='#n729'>729</a>
<a id='n730' href='#n730'>730</a>
<a id='n731' href='#n731'>731</a>
<a id='n732' href='#n732'>732</a>
<a id='n733' href='#n733'>733</a>
<a id='n734' href='#n734'>734</a>
<a id='n735' href='#n735'>735</a>
<a id='n736' href='#n736'>736</a>
<a id='n737' href='#n737'>737</a>
<a id='n738' href='#n738'>738</a>
<a id='n739' href='#n739'>739</a>
<a id='n740' href='#n740'>740</a>
<a id='n741' href='#n741'>741</a>
<a id='n742' href='#n742'>742</a>
<a id='n743' href='#n743'>743</a>
<a id='n744' href='#n744'>744</a>
<a id='n745' href='#n745'>745</a>
<a id='n746' href='#n746'>746</a>
<a id='n747' href='#n747'>747</a>
<a id='n748' href='#n748'>748</a>
<a id='n749' href='#n749'>749</a>
<a id='n750' href='#n750'>750</a>
<a id='n751' href='#n751'>751</a>
<a id='n752' href='#n752'>752</a>
<a id='n753' href='#n753'>753</a>
<a id='n754' href='#n754'>754</a>
<a id='n755' href='#n755'>755</a>
<a id='n756' href='#n756'>756</a>
<a id='n757' href='#n757'>757</a>
<a id='n758' href='#n758'>758</a>
<a id='n759' href='#n759'>759</a>
<a id='n760' href='#n760'>760</a>
<a id='n761' href='#n761'>761</a>
<a id='n762' href='#n762'>762</a>
<a id='n763' href='#n763'>763</a>
<a id='n764' href='#n764'>764</a>
<a id='n765' href='#n765'>765</a>
<a id='n766' href='#n766'>766</a>
<a id='n767' href='#n767'>767</a>
<a id='n768' href='#n768'>768</a>
<a id='n769' href='#n769'>769</a>
<a id='n770' href='#n770'>770</a>
<a id='n771' href='#n771'>771</a>
<a id='n772' href='#n772'>772</a>
<a id='n773' href='#n773'>773</a>
<a id='n774' href='#n774'>774</a>
<a id='n775' href='#n775'>775</a>
<a id='n776' href='#n776'>776</a>
<a id='n777' href='#n777'>777</a>
<a id='n778' href='#n778'>778</a>
<a id='n779' href='#n779'>779</a>
<a id='n780' href='#n780'>780</a>
<a id='n781' href='#n781'>781</a>
<a id='n782' href='#n782'>782</a>
<a id='n783' href='#n783'>783</a>
<a id='n784' href='#n784'>784</a>
<a id='n785' href='#n785'>785</a>
<a id='n786' href='#n786'>786</a>
<a id='n787' href='#n787'>787</a>
<a id='n788' href='#n788'>788</a>
<a id='n789' href='#n789'>789</a>
<a id='n790' href='#n790'>790</a>
<a id='n791' href='#n791'>791</a>
<a id='n792' href='#n792'>792</a>
<a id='n793' href='#n793'>793</a>
<a id='n794' href='#n794'>794</a>
<a id='n795' href='#n795'>795</a>
<a id='n796' href='#n796'>796</a>
<a id='n797' href='#n797'>797</a>
<a id='n798' href='#n798'>798</a>
<a id='n799' href='#n799'>799</a>
<a id='n800' href='#n800'>800</a>
<a id='n801' href='#n801'>801</a>
<a id='n802' href='#n802'>802</a>
<a id='n803' href='#n803'>803</a>
<a id='n804' href='#n804'>804</a>
<a id='n805' href='#n805'>805</a>
<a id='n806' href='#n806'>806</a>
<a id='n807' href='#n807'>807</a>
<a id='n808' href='#n808'>808</a>
<a id='n809' href='#n809'>809</a>
<a id='n810' href='#n810'>810</a>
<a id='n811' href='#n811'>811</a>
<a id='n812' href='#n812'>812</a>
<a id='n813' href='#n813'>813</a>
<a id='n814' href='#n814'>814</a>
<a id='n815' href='#n815'>815</a>
<a id='n816' href='#n816'>816</a>
<a id='n817' href='#n817'>817</a>
<a id='n818' href='#n818'>818</a>
<a id='n819' href='#n819'>819</a>
<a id='n820' href='#n820'>820</a>
<a id='n821' href='#n821'>821</a>
<a id='n822' href='#n822'>822</a>
<a id='n823' href='#n823'>823</a>
<a id='n824' href='#n824'>824</a>
<a id='n825' href='#n825'>825</a>
<a id='n826' href='#n826'>826</a>
<a id='n827' href='#n827'>827</a>
<a id='n828' href='#n828'>828</a>
<a id='n829' href='#n829'>829</a>
<a id='n830' href='#n830'>830</a>
<a id='n831' href='#n831'>831</a>
<a id='n832' href='#n832'>832</a>
<a id='n833' href='#n833'>833</a>
<a id='n834' href='#n834'>834</a>
<a id='n835' href='#n835'>835</a>
<a id='n836' href='#n836'>836</a>
<a id='n837' href='#n837'>837</a>
<a id='n838' href='#n838'>838</a>
<a id='n839' href='#n839'>839</a>
<a id='n840' href='#n840'>840</a>
<a id='n841' href='#n841'>841</a>
<a id='n842' href='#n842'>842</a>
<a id='n843' href='#n843'>843</a>
<a id='n844' href='#n844'>844</a>
<a id='n845' href='#n845'>845</a>
<a id='n846' href='#n846'>846</a>
<a id='n847' href='#n847'>847</a>
<a id='n848' href='#n848'>848</a>
<a id='n849' href='#n849'>849</a>
<a id='n850' href='#n850'>850</a>
<a id='n851' href='#n851'>851</a>
<a id='n852' href='#n852'>852</a>
<a id='n853' href='#n853'>853</a>
<a id='n854' href='#n854'>854</a>
<a id='n855' href='#n855'>855</a>
<a id='n856' href='#n856'>856</a>
<a id='n857' href='#n857'>857</a>
<a id='n858' href='#n858'>858</a>
<a id='n859' href='#n859'>859</a>
<a id='n860' href='#n860'>860</a>
<a id='n861' href='#n861'>861</a>
<a id='n862' href='#n862'>862</a>
<a id='n863' href='#n863'>863</a>
<a id='n864' href='#n864'>864</a>
<a id='n865' href='#n865'>865</a>
<a id='n866' href='#n866'>866</a>
<a id='n867' href='#n867'>867</a>
<a id='n868' href='#n868'>868</a>
<a id='n869' href='#n869'>869</a>
<a id='n870' href='#n870'>870</a>
<a id='n871' href='#n871'>871</a>
<a id='n872' href='#n872'>872</a>
<a id='n873' href='#n873'>873</a>
<a id='n874' href='#n874'>874</a>
<a id='n875' href='#n875'>875</a>
<a id='n876' href='#n876'>876</a>
<a id='n877' href='#n877'>877</a>
<a id='n878' href='#n878'>878</a>
<a id='n879' href='#n879'>879</a>
<a id='n880' href='#n880'>880</a>
<a id='n881' href='#n881'>881</a>
<a id='n882' href='#n882'>882</a>
<a id='n883' href='#n883'>883</a>
<a id='n884' href='#n884'>884</a>
<a id='n885' href='#n885'>885</a>
<a id='n886' href='#n886'>886</a>
<a id='n887' href='#n887'>887</a>
<a id='n888' href='#n888'>888</a>
<a id='n889' href='#n889'>889</a>
<a id='n890' href='#n890'>890</a>
<a id='n891' href='#n891'>891</a>
<a id='n892' href='#n892'>892</a>
<a id='n893' href='#n893'>893</a>
<a id='n894' href='#n894'>894</a>
<a id='n895' href='#n895'>895</a>
<a id='n896' href='#n896'>896</a>
<a id='n897' href='#n897'>897</a>
<a id='n898' href='#n898'>898</a>
<a id='n899' href='#n899'>899</a>
<a id='n900' href='#n900'>900</a>
<a id='n901' href='#n901'>901</a>
<a id='n902' href='#n902'>902</a>
<a id='n903' href='#n903'>903</a>
<a id='n904' href='#n904'>904</a>
<a id='n905' href='#n905'>905</a>
<a id='n906' href='#n906'>906</a>
<a id='n907' href='#n907'>907</a>
<a id='n908' href='#n908'>908</a>
<a id='n909' href='#n909'>909</a>
<a id='n910' href='#n910'>910</a>
<a id='n911' href='#n911'>911</a>
<a id='n912' href='#n912'>912</a>
<a id='n913' href='#n913'>913</a>
<a id='n914' href='#n914'>914</a>
<a id='n915' href='#n915'>915</a>
<a id='n916' href='#n916'>916</a>
<a id='n917' href='#n917'>917</a>
<a id='n918' href='#n918'>918</a>
<a id='n919' href='#n919'>919</a>
<a id='n920' href='#n920'>920</a>
<a id='n921' href='#n921'>921</a>
<a id='n922' href='#n922'>922</a>
<a id='n923' href='#n923'>923</a>
<a id='n924' href='#n924'>924</a>
<a id='n925' href='#n925'>925</a>
<a id='n926' href='#n926'>926</a>
<a id='n927' href='#n927'>927</a>
<a id='n928' href='#n928'>928</a>
<a id='n929' href='#n929'>929</a>
<a id='n930' href='#n930'>930</a>
<a id='n931' href='#n931'>931</a>
<a id='n932' href='#n932'>932</a>
<a id='n933' href='#n933'>933</a>
<a id='n934' href='#n934'>934</a>
<a id='n935' href='#n935'>935</a>
<a id='n936' href='#n936'>936</a>
<a id='n937' href='#n937'>937</a>
<a id='n938' href='#n938'>938</a>
<a id='n939' href='#n939'>939</a>
<a id='n940' href='#n940'>940</a>
<a id='n941' href='#n941'>941</a>
<a id='n942' href='#n942'>942</a>
<a id='n943' href='#n943'>943</a>
<a id='n944' href='#n944'>944</a>
<a id='n945' href='#n945'>945</a>
<a id='n946' href='#n946'>946</a>
<a id='n947' href='#n947'>947</a>
<a id='n948' href='#n948'>948</a>
<a id='n949' href='#n949'>949</a>
<a id='n950' href='#n950'>950</a>
<a id='n951' href='#n951'>951</a>
<a id='n952' href='#n952'>952</a>
<a id='n953' href='#n953'>953</a>
<a id='n954' href='#n954'>954</a>
<a id='n955' href='#n955'>955</a>
<a id='n956' href='#n956'>956</a>
<a id='n957' href='#n957'>957</a>
<a id='n958' href='#n958'>958</a>
<a id='n959' href='#n959'>959</a>
<a id='n960' href='#n960'>960</a>
<a id='n961' href='#n961'>961</a>
<a id='n962' href='#n962'>962</a>
<a id='n963' href='#n963'>963</a>
<a id='n964' href='#n964'>964</a>
<a id='n965' href='#n965'>965</a>
<a id='n966' href='#n966'>966</a>
<a id='n967' href='#n967'>967</a>
<a id='n968' href='#n968'>968</a>
<a id='n969' href='#n969'>969</a>
<a id='n970' href='#n970'>970</a>
<a id='n971' href='#n971'>971</a>
<a id='n972' href='#n972'>972</a>
<a id='n973' href='#n973'>973</a>
<a id='n974' href='#n974'>974</a>
<a id='n975' href='#n975'>975</a>
<a id='n976' href='#n976'>976</a>
<a id='n977' href='#n977'>977</a>
<a id='n978' href='#n978'>978</a>
<a id='n979' href='#n979'>979</a>
<a id='n980' href='#n980'>980</a>
<a id='n981' href='#n981'>981</a>
<a id='n982' href='#n982'>982</a>
<a id='n983' href='#n983'>983</a>
<a id='n984' href='#n984'>984</a>
<a id='n985' href='#n985'>985</a>
<a id='n986' href='#n986'>986</a>
<a id='n987' href='#n987'>987</a>
<a id='n988' href='#n988'>988</a>
<a id='n989' href='#n989'>989</a>
<a id='n990' href='#n990'>990</a>
<a id='n991' href='#n991'>991</a>
<a id='n992' href='#n992'>992</a>
<a id='n993' href='#n993'>993</a>
<a id='n994' href='#n994'>994</a>
<a id='n995' href='#n995'>995</a>
<a id='n996' href='#n996'>996</a>
<a id='n997' href='#n997'>997</a>
<a id='n998' href='#n998'>998</a>
<a id='n999' href='#n999'>999</a>
<a id='n1000' href='#n1000'>1000</a>
<a id='n1001' href='#n1001'>1001</a>
<a id='n1002' href='#n1002'>1002</a>
<a id='n1003' href='#n1003'>1003</a>
<a id='n1004' href='#n1004'>1004</a>
<a id='n1005' href='#n1005'>1005</a>
<a id='n1006' href='#n1006'>1006</a>
<a id='n1007' href='#n1007'>1007</a>
<a id='n1008' href='#n1008'>1008</a>
<a id='n1009' href='#n1009'>1009</a>
<a id='n1010' href='#n1010'>1010</a>
<a id='n1011' href='#n1011'>1011</a>
<a id='n1012' href='#n1012'>1012</a>
<a id='n1013' href='#n1013'>1013</a>
<a id='n1014' href='#n1014'>1014</a>
<a id='n1015' href='#n1015'>1015</a>
<a id='n1016' href='#n1016'>1016</a>
<a id='n1017' href='#n1017'>1017</a>
<a id='n1018' href='#n1018'>1018</a>
<a id='n1019' href='#n1019'>1019</a>
<a id='n1020' href='#n1020'>1020</a>
<a id='n1021' href='#n1021'>1021</a>
<a id='n1022' href='#n1022'>1022</a>
<a id='n1023' href='#n1023'>1023</a>
<a id='n1024' href='#n1024'>1024</a>
<a id='n1025' href='#n1025'>1025</a>
<a id='n1026' href='#n1026'>1026</a>
<a id='n1027' href='#n1027'>1027</a>
<a id='n1028' href='#n1028'>1028</a>
<a id='n1029' href='#n1029'>1029</a>
<a id='n1030' href='#n1030'>1030</a>
<a id='n1031' href='#n1031'>1031</a>
<a id='n1032' href='#n1032'>1032</a>
<a id='n1033' href='#n1033'>1033</a>
<a id='n1034' href='#n1034'>1034</a>
<a id='n1035' href='#n1035'>1035</a>
<a id='n1036' href='#n1036'>1036</a>
<a id='n1037' href='#n1037'>1037</a>
<a id='n1038' href='#n1038'>1038</a>
<a id='n1039' href='#n1039'>1039</a>
<a id='n1040' href='#n1040'>1040</a>
<a id='n1041' href='#n1041'>1041</a>
<a id='n1042' href='#n1042'>1042</a>
<a id='n1043' href='#n1043'>1043</a>
<a id='n1044' href='#n1044'>1044</a>
<a id='n1045' href='#n1045'>1045</a>
<a id='n1046' href='#n1046'>1046</a>
<a id='n1047' href='#n1047'>1047</a>
<a id='n1048' href='#n1048'>1048</a>
<a id='n1049' href='#n1049'>1049</a>
<a id='n1050' href='#n1050'>1050</a>
<a id='n1051' href='#n1051'>1051</a>
<a id='n1052' href='#n1052'>1052</a>
<a id='n1053' href='#n1053'>1053</a>
<a id='n1054' href='#n1054'>1054</a>
<a id='n1055' href='#n1055'>1055</a>
<a id='n1056' href='#n1056'>1056</a>
<a id='n1057' href='#n1057'>1057</a>
<a id='n1058' href='#n1058'>1058</a>
<a id='n1059' href='#n1059'>1059</a>
<a id='n1060' href='#n1060'>1060</a>
<a id='n1061' href='#n1061'>1061</a>
<a id='n1062' href='#n1062'>1062</a>
<a id='n1063' href='#n1063'>1063</a>
<a id='n1064' href='#n1064'>1064</a>
<a id='n1065' href='#n1065'>1065</a>
<a id='n1066' href='#n1066'>1066</a>
<a id='n1067' href='#n1067'>1067</a>
<a id='n1068' href='#n1068'>1068</a>
<a id='n1069' href='#n1069'>1069</a>
<a id='n1070' href='#n1070'>1070</a>
<a id='n1071' href='#n1071'>1071</a>
<a id='n1072' href='#n1072'>1072</a>
<a id='n1073' href='#n1073'>1073</a>
<a id='n1074' href='#n1074'>1074</a>
<a id='n1075' href='#n1075'>1075</a>
<a id='n1076' href='#n1076'>1076</a>
<a id='n1077' href='#n1077'>1077</a>
<a id='n1078' href='#n1078'>1078</a>
<a id='n1079' href='#n1079'>1079</a>
<a id='n1080' href='#n1080'>1080</a>
<a id='n1081' href='#n1081'>1081</a>
<a id='n1082' href='#n1082'>1082</a>
<a id='n1083' href='#n1083'>1083</a>
<a id='n1084' href='#n1084'>1084</a>
<a id='n1085' href='#n1085'>1085</a>
<a id='n1086' href='#n1086'>1086</a>
<a id='n1087' href='#n1087'>1087</a>
<a id='n1088' href='#n1088'>1088</a>
<a id='n1089' href='#n1089'>1089</a>
<a id='n1090' href='#n1090'>1090</a>
<a id='n1091' href='#n1091'>1091</a>
<a id='n1092' href='#n1092'>1092</a>
<a id='n1093' href='#n1093'>1093</a>
<a id='n1094' href='#n1094'>1094</a>
<a id='n1095' href='#n1095'>1095</a>
<a id='n1096' href='#n1096'>1096</a>
<a id='n1097' href='#n1097'>1097</a>
<a id='n1098' href='#n1098'>1098</a>
<a id='n1099' href='#n1099'>1099</a>
<a id='n1100' href='#n1100'>1100</a>
<a id='n1101' href='#n1101'>1101</a>
<a id='n1102' href='#n1102'>1102</a>
<a id='n1103' href='#n1103'>1103</a>
<a id='n1104' href='#n1104'>1104</a>
<a id='n1105' href='#n1105'>1105</a>
<a id='n1106' href='#n1106'>1106</a>
<a id='n1107' href='#n1107'>1107</a>
<a id='n1108' href='#n1108'>1108</a>
<a id='n1109' href='#n1109'>1109</a>
<a id='n1110' href='#n1110'>1110</a>
<a id='n1111' href='#n1111'>1111</a>
<a id='n1112' href='#n1112'>1112</a>
<a id='n1113' href='#n1113'>1113</a>
<a id='n1114' href='#n1114'>1114</a>
<a id='n1115' href='#n1115'>1115</a>
<a id='n1116' href='#n1116'>1116</a>
<a id='n1117' href='#n1117'>1117</a>
<a id='n1118' href='#n1118'>1118</a>
<a id='n1119' href='#n1119'>1119</a>
<a id='n1120' href='#n1120'>1120</a>
<a id='n1121' href='#n1121'>1121</a>
<a id='n1122' href='#n1122'>1122</a>
<a id='n1123' href='#n1123'>1123</a>
<a id='n1124' href='#n1124'>1124</a>
<a id='n1125' href='#n1125'>1125</a>
<a id='n1126' href='#n1126'>1126</a>
<a id='n1127' href='#n1127'>1127</a>
<a id='n1128' href='#n1128'>1128</a>
<a id='n1129' href='#n1129'>1129</a>
<a id='n1130' href='#n1130'>1130</a>
<a id='n1131' href='#n1131'>1131</a>
<a id='n1132' href='#n1132'>1132</a>
<a id='n1133' href='#n1133'>1133</a>
<a id='n1134' href='#n1134'>1134</a>
<a id='n1135' href='#n1135'>1135</a>
<a id='n1136' href='#n1136'>1136</a>
<a id='n1137' href='#n1137'>1137</a>
<a id='n1138' href='#n1138'>1138</a>
<a id='n1139' href='#n1139'>1139</a>
<a id='n1140' href='#n1140'>1140</a>
<a id='n1141' href='#n1141'>1141</a>
<a id='n1142' href='#n1142'>1142</a>
<a id='n1143' href='#n1143'>1143</a>
<a id='n1144' href='#n1144'>1144</a>
<a id='n1145' href='#n1145'>1145</a>
<a id='n1146' href='#n1146'>1146</a>
<a id='n1147' href='#n1147'>1147</a>
<a id='n1148' href='#n1148'>1148</a>
<a id='n1149' href='#n1149'>1149</a>
<a id='n1150' href='#n1150'>1150</a>
<a id='n1151' href='#n1151'>1151</a>
<a id='n1152' href='#n1152'>1152</a>
<a id='n1153' href='#n1153'>1153</a>
<a id='n1154' href='#n1154'>1154</a>
<a id='n1155' href='#n1155'>1155</a>
<a id='n1156' href='#n1156'>1156</a>
<a id='n1157' href='#n1157'>1157</a>
<a id='n1158' href='#n1158'>1158</a>
<a id='n1159' href='#n1159'>1159</a>
<a id='n1160' href='#n1160'>1160</a>
<a id='n1161' href='#n1161'>1161</a>
<a id='n1162' href='#n1162'>1162</a>
<a id='n1163' href='#n1163'>1163</a>
<a id='n1164' href='#n1164'>1164</a>
<a id='n1165' href='#n1165'>1165</a>
<a id='n1166' href='#n1166'>1166</a>
<a id='n1167' href='#n1167'>1167</a>
<a id='n1168' href='#n1168'>1168</a>
<a id='n1169' href='#n1169'>1169</a>
<a id='n1170' href='#n1170'>1170</a>
<a id='n1171' href='#n1171'>1171</a>
<a id='n1172' href='#n1172'>1172</a>
<a id='n1173' href='#n1173'>1173</a>
<a id='n1174' href='#n1174'>1174</a>
<a id='n1175' href='#n1175'>1175</a>
<a id='n1176' href='#n1176'>1176</a>
<a id='n1177' href='#n1177'>1177</a>
<a id='n1178' href='#n1178'>1178</a>
<a id='n1179' href='#n1179'>1179</a>
<a id='n1180' href='#n1180'>1180</a>
<a id='n1181' href='#n1181'>1181</a>
<a id='n1182' href='#n1182'>1182</a>
<a id='n1183' href='#n1183'>1183</a>
<a id='n1184' href='#n1184'>1184</a>
<a id='n1185' href='#n1185'>1185</a>
<a id='n1186' href='#n1186'>1186</a>
<a id='n1187' href='#n1187'>1187</a>
<a id='n1188' href='#n1188'>1188</a>
<a id='n1189' href='#n1189'>1189</a>
<a id='n1190' href='#n1190'>1190</a>
<a id='n1191' href='#n1191'>1191</a>
<a id='n1192' href='#n1192'>1192</a>
<a id='n1193' href='#n1193'>1193</a>
<a id='n1194' href='#n1194'>1194</a>
<a id='n1195' href='#n1195'>1195</a>
<a id='n1196' href='#n1196'>1196</a>
<a id='n1197' href='#n1197'>1197</a>
<a id='n1198' href='#n1198'>1198</a>
<a id='n1199' href='#n1199'>1199</a>
<a id='n1200' href='#n1200'>1200</a>
<a id='n1201' href='#n1201'>1201</a>
<a id='n1202' href='#n1202'>1202</a>
<a id='n1203' href='#n1203'>1203</a>
<a id='n1204' href='#n1204'>1204</a>
<a id='n1205' href='#n1205'>1205</a>
<a id='n1206' href='#n1206'>1206</a>
<a id='n1207' href='#n1207'>1207</a>
<a id='n1208' href='#n1208'>1208</a>
<a id='n1209' href='#n1209'>1209</a>
<a id='n1210' href='#n1210'>1210</a>
<a id='n1211' href='#n1211'>1211</a>
<a id='n1212' href='#n1212'>1212</a>
<a id='n1213' href='#n1213'>1213</a>
<a id='n1214' href='#n1214'>1214</a>
<a id='n1215' href='#n1215'>1215</a>
<a id='n1216' href='#n1216'>1216</a>
<a id='n1217' href='#n1217'>1217</a>
<a id='n1218' href='#n1218'>1218</a>
<a id='n1219' href='#n1219'>1219</a>
<a id='n1220' href='#n1220'>1220</a>
<a id='n1221' href='#n1221'>1221</a>
<a id='n1222' href='#n1222'>1222</a>
<a id='n1223' href='#n1223'>1223</a>
<a id='n1224' href='#n1224'>1224</a>
<a id='n1225' href='#n1225'>1225</a>
<a id='n1226' href='#n1226'>1226</a>
<a id='n1227' href='#n1227'>1227</a>
<a id='n1228' href='#n1228'>1228</a>
<a id='n1229' href='#n1229'>1229</a>
<a id='n1230' href='#n1230'>1230</a>
<a id='n1231' href='#n1231'>1231</a>
<a id='n1232' href='#n1232'>1232</a>
<a id='n1233' href='#n1233'>1233</a>
<a id='n1234' href='#n1234'>1234</a>
<a id='n1235' href='#n1235'>1235</a>
<a id='n1236' href='#n1236'>1236</a>
<a id='n1237' href='#n1237'>1237</a>
<a id='n1238' href='#n1238'>1238</a>
<a id='n1239' href='#n1239'>1239</a>
<a id='n1240' href='#n1240'>1240</a>
<a id='n1241' href='#n1241'>1241</a>
<a id='n1242' href='#n1242'>1242</a>
<a id='n1243' href='#n1243'>1243</a>
<a id='n1244' href='#n1244'>1244</a>
<a id='n1245' href='#n1245'>1245</a>
<a id='n1246' href='#n1246'>1246</a>
<a id='n1247' href='#n1247'>1247</a>
<a id='n1248' href='#n1248'>1248</a>
<a id='n1249' href='#n1249'>1249</a>
<a id='n1250' href='#n1250'>1250</a>
<a id='n1251' href='#n1251'>1251</a>
<a id='n1252' href='#n1252'>1252</a>
<a id='n1253' href='#n1253'>1253</a>
<a id='n1254' href='#n1254'>1254</a>
<a id='n1255' href='#n1255'>1255</a>
<a id='n1256' href='#n1256'>1256</a>
<a id='n1257' href='#n1257'>1257</a>
<a id='n1258' href='#n1258'>1258</a>
<a id='n1259' href='#n1259'>1259</a>
<a id='n1260' href='#n1260'>1260</a>
<a id='n1261' href='#n1261'>1261</a>
<a id='n1262' href='#n1262'>1262</a>
<a id='n1263' href='#n1263'>1263</a>
<a id='n1264' href='#n1264'>1264</a>
<a id='n1265' href='#n1265'>1265</a>
<a id='n1266' href='#n1266'>1266</a>
<a id='n1267' href='#n1267'>1267</a>
<a id='n1268' href='#n1268'>1268</a>
<a id='n1269' href='#n1269'>1269</a>
<a id='n1270' href='#n1270'>1270</a>
<a id='n1271' href='#n1271'>1271</a>
<a id='n1272' href='#n1272'>1272</a>
<a id='n1273' href='#n1273'>1273</a>
<a id='n1274' href='#n1274'>1274</a>
<a id='n1275' href='#n1275'>1275</a>
<a id='n1276' href='#n1276'>1276</a>
<a id='n1277' href='#n1277'>1277</a>
<a id='n1278' href='#n1278'>1278</a>
<a id='n1279' href='#n1279'>1279</a>
<a id='n1280' href='#n1280'>1280</a>
<a id='n1281' href='#n1281'>1281</a>
<a id='n1282' href='#n1282'>1282</a>
<a id='n1283' href='#n1283'>1283</a>
<a id='n1284' href='#n1284'>1284</a>
<a id='n1285' href='#n1285'>1285</a>
<a id='n1286' href='#n1286'>1286</a>
<a id='n1287' href='#n1287'>1287</a>
<a id='n1288' href='#n1288'>1288</a>
<a id='n1289' href='#n1289'>1289</a>
<a id='n1290' href='#n1290'>1290</a>
<a id='n1291' href='#n1291'>1291</a>
<a id='n1292' href='#n1292'>1292</a>
<a id='n1293' href='#n1293'>1293</a>
<a id='n1294' href='#n1294'>1294</a>
<a id='n1295' href='#n1295'>1295</a>
<a id='n1296' href='#n1296'>1296</a>
<a id='n1297' href='#n1297'>1297</a>
<a id='n1298' href='#n1298'>1298</a>
<a id='n1299' href='#n1299'>1299</a>
<a id='n1300' href='#n1300'>1300</a>
<a id='n1301' href='#n1301'>1301</a>
<a id='n1302' href='#n1302'>1302</a>
<a id='n1303' href='#n1303'>1303</a>
<a id='n1304' href='#n1304'>1304</a>
<a id='n1305' href='#n1305'>1305</a>
<a id='n1306' href='#n1306'>1306</a>
<a id='n1307' href='#n1307'>1307</a>
<a id='n1308' href='#n1308'>1308</a>
<a id='n1309' href='#n1309'>1309</a>
<a id='n1310' href='#n1310'>1310</a>
<a id='n1311' href='#n1311'>1311</a>
<a id='n1312' href='#n1312'>1312</a>
<a id='n1313' href='#n1313'>1313</a>
<a id='n1314' href='#n1314'>1314</a>
<a id='n1315' href='#n1315'>1315</a>
<a id='n1316' href='#n1316'>1316</a>
<a id='n1317' href='#n1317'>1317</a>
<a id='n1318' href='#n1318'>1318</a>
<a id='n1319' href='#n1319'>1319</a>
<a id='n1320' href='#n1320'>1320</a>
<a id='n1321' href='#n1321'>1321</a>
<a id='n1322' href='#n1322'>1322</a>
<a id='n1323' href='#n1323'>1323</a>
<a id='n1324' href='#n1324'>1324</a>
<a id='n1325' href='#n1325'>1325</a>
<a id='n1326' href='#n1326'>1326</a>
<a id='n1327' href='#n1327'>1327</a>
<a id='n1328' href='#n1328'>1328</a>
<a id='n1329' href='#n1329'>1329</a>
<a id='n1330' href='#n1330'>1330</a>
<a id='n1331' href='#n1331'>1331</a>
<a id='n1332' href='#n1332'>1332</a>
<a id='n1333' href='#n1333'>1333</a>
<a id='n1334' href='#n1334'>1334</a>
<a id='n1335' href='#n1335'>1335</a>
<a id='n1336' href='#n1336'>1336</a>
<a id='n1337' href='#n1337'>1337</a>
<a id='n1338' href='#n1338'>1338</a>
<a id='n1339' href='#n1339'>1339</a>
<a id='n1340' href='#n1340'>1340</a>
<a id='n1341' href='#n1341'>1341</a>
<a id='n1342' href='#n1342'>1342</a>
<a id='n1343' href='#n1343'>1343</a>
<a id='n1344' href='#n1344'>1344</a>
<a id='n1345' href='#n1345'>1345</a>
<a id='n1346' href='#n1346'>1346</a>
<a id='n1347' href='#n1347'>1347</a>
<a id='n1348' href='#n1348'>1348</a>
<a id='n1349' href='#n1349'>1349</a>
<a id='n1350' href='#n1350'>1350</a>
<a id='n1351' href='#n1351'>1351</a>
<a id='n1352' href='#n1352'>1352</a>
<a id='n1353' href='#n1353'>1353</a>
<a id='n1354' href='#n1354'>1354</a>
<a id='n1355' href='#n1355'>1355</a>
<a id='n1356' href='#n1356'>1356</a>
<a id='n1357' href='#n1357'>1357</a>
<a id='n1358' href='#n1358'>1358</a>
<a id='n1359' href='#n1359'>1359</a>
<a id='n1360' href='#n1360'>1360</a>
<a id='n1361' href='#n1361'>1361</a>
<a id='n1362' href='#n1362'>1362</a>
<a id='n1363' href='#n1363'>1363</a>
<a id='n1364' href='#n1364'>1364</a>
<a id='n1365' href='#n1365'>1365</a>
<a id='n1366' href='#n1366'>1366</a>
<a id='n1367' href='#n1367'>1367</a>
<a id='n1368' href='#n1368'>1368</a>
<a id='n1369' href='#n1369'>1369</a>
<a id='n1370' href='#n1370'>1370</a>
<a id='n1371' href='#n1371'>1371</a>
<a id='n1372' href='#n1372'>1372</a>
<a id='n1373' href='#n1373'>1373</a>
<a id='n1374' href='#n1374'>1374</a>
<a id='n1375' href='#n1375'>1375</a>
<a id='n1376' href='#n1376'>1376</a>
<a id='n1377' href='#n1377'>1377</a>
<a id='n1378' href='#n1378'>1378</a>
<a id='n1379' href='#n1379'>1379</a>
<a id='n1380' href='#n1380'>1380</a>
<a id='n1381' href='#n1381'>1381</a>
<a id='n1382' href='#n1382'>1382</a>
<a id='n1383' href='#n1383'>1383</a>
<a id='n1384' href='#n1384'>1384</a>
<a id='n1385' href='#n1385'>1385</a>
<a id='n1386' href='#n1386'>1386</a>
<a id='n1387' href='#n1387'>1387</a>
<a id='n1388' href='#n1388'>1388</a>
<a id='n1389' href='#n1389'>1389</a>
<a id='n1390' href='#n1390'>1390</a>
<a id='n1391' href='#n1391'>1391</a>
<a id='n1392' href='#n1392'>1392</a>
<a id='n1393' href='#n1393'>1393</a>
<a id='n1394' href='#n1394'>1394</a>
<a id='n1395' href='#n1395'>1395</a>
<a id='n1396' href='#n1396'>1396</a>
<a id='n1397' href='#n1397'>1397</a>
<a id='n1398' href='#n1398'>1398</a>
<a id='n1399' href='#n1399'>1399</a>
<a id='n1400' href='#n1400'>1400</a>
<a id='n1401' href='#n1401'>1401</a>
<a id='n1402' href='#n1402'>1402</a>
<a id='n1403' href='#n1403'>1403</a>
<a id='n1404' href='#n1404'>1404</a>
<a id='n1405' href='#n1405'>1405</a>
<a id='n1406' href='#n1406'>1406</a>
<a id='n1407' href='#n1407'>1407</a>
<a id='n1408' href='#n1408'>1408</a>
<a id='n1409' href='#n1409'>1409</a>
<a id='n1410' href='#n1410'>1410</a>
<a id='n1411' href='#n1411'>1411</a>
<a id='n1412' href='#n1412'>1412</a>
<a id='n1413' href='#n1413'>1413</a>
<a id='n1414' href='#n1414'>1414</a>
<a id='n1415' href='#n1415'>1415</a>
<a id='n1416' href='#n1416'>1416</a>
<a id='n1417' href='#n1417'>1417</a>
<a id='n1418' href='#n1418'>1418</a>
<a id='n1419' href='#n1419'>1419</a>
<a id='n1420' href='#n1420'>1420</a>
</pre></td>
<td class='lines'><pre><code><style>.highlight .hll { background-color: #ffffcc }
.highlight  { background: #ffffff; }
.highlight .c { color: #888888 } /* Comment */
.highlight .err { color: #a61717; background-color: #e3d2d2 } /* Error */
.highlight .k { color: #008800; font-weight: bold } /* Keyword */
.highlight .cm { color: #888888 } /* Comment.Multiline */
.highlight .cp { color: #cc0000; font-weight: bold } /* Comment.Preproc */
.highlight .c1 { color: #888888 } /* Comment.Single */
.highlight .cs { color: #cc0000; font-weight: bold; background-color: #fff0f0 } /* Comment.Special */
.highlight .gd { color: #000000; background-color: #ffdddd } /* Generic.Deleted */
.highlight .ge { font-style: italic } /* Generic.Emph */
.highlight .gr { color: #aa0000 } /* Generic.Error */
.highlight .gh { color: #303030 } /* Generic.Heading */
.highlight .gi { color: #000000; background-color: #ddffdd } /* Generic.Inserted */
.highlight .go { color: #888888 } /* Generic.Output */
.highlight .gp { color: #555555 } /* Generic.Prompt */
.highlight .gs { font-weight: bold } /* Generic.Strong */
.highlight .gu { color: #606060 } /* Generic.Subheading */
.highlight .gt { color: #aa0000 } /* Generic.Traceback */
.highlight .kc { color: #008800; font-weight: bold } /* Keyword.Constant */
.highlight .kd { color: #008800; font-weight: bold } /* Keyword.Declaration */
.highlight .kn { color: #008800; font-weight: bold } /* Keyword.Namespace */
.highlight .kp { color: #008800 } /* Keyword.Pseudo */
.highlight .kr { color: #008800; font-weight: bold } /* Keyword.Reserved */
.highlight .kt { color: #888888; font-weight: bold } /* Keyword.Type */
.highlight .m { color: #0000DD; font-weight: bold } /* Literal.Number */
.highlight .s { color: #dd2200; background-color: #fff0f0 } /* Literal.String */
.highlight .na { color: #336699 } /* Name.Attribute */
.highlight .nb { color: #003388 } /* Name.Builtin */
.highlight .nc { color: #bb0066; font-weight: bold } /* Name.Class */
.highlight .no { color: #003366; font-weight: bold } /* Name.Constant */
.highlight .nd { color: #555555 } /* Name.Decorator */
.highlight .ne { color: #bb0066; font-weight: bold } /* Name.Exception */
.highlight .nf { color: #0066bb; font-weight: bold } /* Name.Function */
.highlight .nl { color: #336699; font-style: italic } /* Name.Label */
.highlight .nn { color: #bb0066; font-weight: bold } /* Name.Namespace */
.highlight .py { color: #336699; font-weight: bold } /* Name.Property */
.highlight .nt { color: #bb0066; font-weight: bold } /* Name.Tag */
.highlight .nv { color: #336699 } /* Name.Variable */
.highlight .ow { color: #008800 } /* Operator.Word */
.highlight .w { color: #bbbbbb } /* Text.Whitespace */
.highlight .mf { color: #0000DD; font-weight: bold } /* Literal.Number.Float */
.highlight .mh { color: #0000DD; font-weight: bold } /* Literal.Number.Hex */
.highlight .mi { color: #0000DD; font-weight: bold } /* Literal.Number.Integer */
.highlight .mo { color: #0000DD; font-weight: bold } /* Literal.Number.Oct */
.highlight .sb { color: #dd2200; background-color: #fff0f0 } /* Literal.String.Backtick */
.highlight .sc { color: #dd2200; background-color: #fff0f0 } /* Literal.String.Char */
.highlight .sd { color: #dd2200; background-color: #fff0f0 } /* Literal.String.Doc */
.highlight .s2 { color: #dd2200; background-color: #fff0f0 } /* Literal.String.Double */
.highlight .se { color: #0044dd; background-color: #fff0f0 } /* Literal.String.Escape */
.highlight .sh { color: #dd2200; background-color: #fff0f0 } /* Literal.String.Heredoc */
.highlight .si { color: #3333bb; background-color: #fff0f0 } /* Literal.String.Interpol */
.highlight .sx { color: #22bb22; background-color: #f0fff0 } /* Literal.String.Other */
.highlight .sr { color: #008800; background-color: #fff0ff } /* Literal.String.Regex */
.highlight .s1 { color: #dd2200; background-color: #fff0f0 } /* Literal.String.Single */
.highlight .ss { color: #aa6600; background-color: #fff0f0 } /* Literal.String.Symbol */
.highlight .bp { color: #003388 } /* Name.Builtin.Pseudo */
.highlight .vc { color: #336699 } /* Name.Variable.Class */
.highlight .vg { color: #dd7700 } /* Name.Variable.Global */
.highlight .vi { color: #3333bb } /* Name.Variable.Instance */
.highlight .il { color: #0000DD; font-weight: bold } /* Literal.Number.Integer.Long */</style><div class="highlight"><pre><span class="c">#! /bin/sh</span>
<span class="c"># Attempt to guess a canonical system name.</span>
<span class="c">#   Copyright 1992-2014 Free Software Foundation, Inc.</span>

<span class="nv">timestamp</span><span class="o">=</span><span class="s1">&#39;2014-03-23&#39;</span>

<span class="c"># This file is free software; you can redistribute it and/or modify it</span>
<span class="c"># under the terms of the GNU General Public License as published by</span>
<span class="c"># the Free Software Foundation; either version 3 of the License, or</span>
<span class="c"># (at your option) any later version.</span>
<span class="c">#</span>
<span class="c"># This program is distributed in the hope that it will be useful, but</span>
<span class="c"># WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="c"># MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU</span>
<span class="c"># General Public License for more details.</span>
<span class="c">#</span>
<span class="c"># You should have received a copy of the GNU General Public License</span>
<span class="c"># along with this program; if not, see &lt;http://www.gnu.org/licenses/&gt;.</span>
<span class="c">#</span>
<span class="c"># As a special exception to the GNU General Public License, if you</span>
<span class="c"># distribute this file as part of a program that contains a</span>
<span class="c"># configuration script generated by Autoconf, you may include it under</span>
<span class="c"># the same distribution terms that you use for the rest of that</span>
<span class="c"># program.  This Exception is an additional permission under section 7</span>
<span class="c"># of the GNU General Public License, version 3 (&quot;GPLv3&quot;).</span>
<span class="c">#</span>
<span class="c"># Originally written by Per Bothner.</span>
<span class="c">#</span>
<span class="c"># You can get the latest version of this script from:</span>
<span class="c"># http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD</span>
<span class="c">#</span>
<span class="c"># Please send patches with a ChangeLog entry to config-patches@gnu.org.</span>


<span class="nv">me</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="s2">&quot;$0&quot;</span> | sed -e <span class="s1">&#39;s,.*/,,&#39;</span><span class="sb">`</span>

<span class="nv">usage</span><span class="o">=</span><span class="s2">&quot;\</span>
<span class="s2">Usage: $0 [OPTION]</span>

<span class="s2">Output the configuration name of the system \`$me&#39; is run on.</span>

<span class="s2">Operation modes:</span>
<span class="s2">  -h, --help         print this help, then exit</span>
<span class="s2">  -t, --time-stamp   print date of last modification, then exit</span>
<span class="s2">  -v, --version      print version number, then exit</span>

<span class="s2">Report bugs and patches to &lt;config-patches@gnu.org&gt;.&quot;</span>

<span class="nv">version</span><span class="o">=</span><span class="s2">&quot;\</span>
<span class="s2">GNU config.guess ($timestamp)</span>

<span class="s2">Originally written by Per Bothner.</span>
<span class="s2">Copyright 1992-2014 Free Software Foundation, Inc.</span>

<span class="s2">This is free software; see the source for copying conditions.  There is NO</span>
<span class="s2">warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.&quot;</span>

<span class="nb">help</span><span class="o">=</span><span class="s2">&quot;</span>
<span class="s2">Try \`$me --help&#39; for more information.&quot;</span>

<span class="c"># Parse command line</span>
<span class="k">while </span><span class="nb">test</span> <span class="nv">$# </span>-gt 0 ; <span class="k">do</span>
<span class="k">  case</span> <span class="nv">$1</span> in
    --time-stamp | --time* | -t <span class="o">)</span>
       <span class="nb">echo</span> <span class="s2">&quot;$timestamp&quot;</span> ; <span class="nb">exit</span> ;;
    --version | -v <span class="o">)</span>
       <span class="nb">echo</span> <span class="s2">&quot;$version&quot;</span> ; <span class="nb">exit</span> ;;
    --help | --h* | -h <span class="o">)</span>
       <span class="nb">echo</span> <span class="s2">&quot;$usage&quot;</span>; <span class="nb">exit</span> ;;
    -- <span class="o">)</span>     <span class="c"># Stop option processing</span>
       <span class="nb">shift</span>; <span class="nb">break</span> ;;
    - <span class="o">)</span>	<span class="c"># Use stdin as input.</span>
       <span class="nb">break</span> ;;
    -* <span class="o">)</span>
       <span class="nb">echo</span> <span class="s2">&quot;$me: invalid option $1$help&quot;</span> &gt;&amp;2
       <span class="nb">exit </span>1 ;;
    * <span class="o">)</span>
       <span class="nb">break</span> ;;
  <span class="k">esac</span>
<span class="k">done</span>

<span class="k">if </span><span class="nb">test</span> <span class="nv">$# </span>!<span class="o">=</span> 0; <span class="k">then</span>
<span class="k">  </span><span class="nb">echo</span> <span class="s2">&quot;$me: too many arguments$help&quot;</span> &gt;&amp;2
  <span class="nb">exit </span>1
<span class="k">fi</span>

<span class="nb">trap</span> <span class="s1">&#39;exit 1&#39;</span> 1 2 15

<span class="c"># CC_FOR_BUILD -- compiler used by this script. Note that the use of a</span>
<span class="c"># compiler to aid in system detection is discouraged as it requires</span>
<span class="c"># temporary files to be created and, as you can see below, it is a</span>
<span class="c"># headache to deal with in a portable fashion.</span>

<span class="c"># Historically, `CC_FOR_BUILD&#39; used to be named `HOST_CC&#39;. We still</span>
<span class="c"># use `HOST_CC&#39; if defined, but it is deprecated.</span>

<span class="c"># Portable tmp directory creation inspired by the Autoconf team.</span>

<span class="nv">set_cc_for_build</span><span class="o">=</span><span class="s1">&#39;</span>
<span class="s1">trap &quot;exitcode=\$?; (rm -f \$tmpfiles 2&gt;/dev/null; rmdir \$tmp 2&gt;/dev/null) &amp;&amp; exit \$exitcode&quot; 0 ;</span>
<span class="s1">trap &quot;rm -f \$tmpfiles 2&gt;/dev/null; rmdir \$tmp 2&gt;/dev/null; exit 1&quot; 1 2 13 15 ;</span>
<span class="s1">: ${TMPDIR=/tmp} ;</span>
<span class="s1"> { tmp=`(umask 077 &amp;&amp; mktemp -d &quot;$TMPDIR/cgXXXXXX&quot;) 2&gt;/dev/null` &amp;&amp; test -n &quot;$tmp&quot; &amp;&amp; test -d &quot;$tmp&quot; ; } ||</span>
<span class="s1"> { test -n &quot;$RANDOM&quot; &amp;&amp; tmp=$TMPDIR/cg$$-$RANDOM &amp;&amp; (umask 077 &amp;&amp; mkdir $tmp) ; } ||</span>
<span class="s1"> { tmp=$TMPDIR/cg-$$ &amp;&amp; (umask 077 &amp;&amp; mkdir $tmp) &amp;&amp; echo &quot;Warning: creating insecure temp directory&quot; &gt;&amp;2 ; } ||</span>
<span class="s1"> { echo &quot;$me: cannot create a temporary directory in $TMPDIR&quot; &gt;&amp;2 ; exit 1 ; } ;</span>
<span class="s1">dummy=$tmp/dummy ;</span>
<span class="s1">tmpfiles=&quot;$dummy.c $dummy.o $dummy.rel $dummy&quot; ;</span>
<span class="s1">case $CC_FOR_BUILD,$HOST_CC,$CC in</span>
<span class="s1"> ,,)    echo &quot;int x;&quot; &gt; $dummy.c ;</span>
<span class="s1">	for c in cc gcc c89 c99 ; do</span>
<span class="s1">	  if ($c -c -o $dummy.o $dummy.c) &gt;/dev/null 2&gt;&amp;1 ; then</span>
<span class="s1">	     CC_FOR_BUILD=&quot;$c&quot;; break ;</span>
<span class="s1">	  fi ;</span>
<span class="s1">	done ;</span>
<span class="s1">	if test x&quot;$CC_FOR_BUILD&quot; = x ; then</span>
<span class="s1">	  CC_FOR_BUILD=no_compiler_found ;</span>
<span class="s1">	fi</span>
<span class="s1">	;;</span>
<span class="s1"> ,,*)   CC_FOR_BUILD=$CC ;;</span>
<span class="s1"> ,*,*)  CC_FOR_BUILD=$HOST_CC ;;</span>
<span class="s1">esac ; set_cc_for_build= ;&#39;</span>

<span class="c"># This is needed to find uname on a Pyramid OSx when run in the BSD universe.</span>
<span class="c"># (ghazi@noc.rutgers.edu 1994-08-24)</span>
<span class="k">if</span> <span class="o">(</span><span class="nb">test</span> -f /.attbin/uname<span class="o">)</span> &gt;/dev/null 2&gt;&amp;1 ; <span class="k">then</span>
<span class="k">	</span><span class="nv">PATH</span><span class="o">=</span><span class="nv">$PATH</span>:/.attbin ; <span class="nb">export </span>PATH
<span class="k">fi</span>

<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>uname -m<span class="o">)</span> 2&gt;/dev/null<span class="sb">`</span> <span class="o">||</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>unknown
<span class="nv">UNAME_RELEASE</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>uname -r<span class="o">)</span> 2&gt;/dev/null<span class="sb">`</span> <span class="o">||</span> <span class="nv">UNAME_RELEASE</span><span class="o">=</span>unknown
<span class="nv">UNAME_SYSTEM</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>uname -s<span class="o">)</span> 2&gt;/dev/null<span class="sb">`</span>  <span class="o">||</span> <span class="nv">UNAME_SYSTEM</span><span class="o">=</span>unknown
<span class="nv">UNAME_VERSION</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>uname -v<span class="o">)</span> 2&gt;/dev/null<span class="sb">`</span> <span class="o">||</span> <span class="nv">UNAME_VERSION</span><span class="o">=</span>unknown

<span class="k">case</span> <span class="s2">&quot;${UNAME_SYSTEM}&quot;</span> in
Linux|GNU|GNU/*<span class="o">)</span>
	<span class="c"># If the system lacks a compiler, then just pick glibc.</span>
	<span class="c"># We could probably try harder.</span>
	<span class="nv">LIBC</span><span class="o">=</span>gnu

	<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
	cat <span class="s">&lt;&lt;-EOF &gt; $dummy.c</span>
<span class="s">	#include &lt;features.h&gt;</span>
<span class="s">	#if defined(__UCLIBC__)</span>
<span class="s">	LIBC=uclibc</span>
<span class="s">	#elif defined(__dietlibc__)</span>
<span class="s">	LIBC=dietlibc</span>
<span class="s">	#else</span>
<span class="s">	LIBC=gnu</span>
<span class="s">	#endif</span>
<span class="s">	EOF</span>
	<span class="nb">eval</span> <span class="sb">`</span><span class="nv">$CC_FOR_BUILD</span> -E <span class="nv">$dummy</span>.c 2&gt;/dev/null | grep <span class="s1">&#39;^LIBC&#39;</span> | sed <span class="s1">&#39;s, ,,g&#39;</span><span class="sb">`</span>
	;;
<span class="k">esac</span>

<span class="c"># Note: order is significant - the case branches are not exclusive.</span>

<span class="k">case</span> <span class="s2">&quot;${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}:${UNAME_VERSION}&quot;</span> in
    *:NetBSD:*:*<span class="o">)</span>
	<span class="c"># NetBSD (nbsd) targets should (where applicable) match one or</span>
	<span class="c"># more of the tuples: *-*-netbsdelf*, *-*-netbsdaout*,</span>
	<span class="c"># *-*-netbsdecoff* and *-*-netbsd*.  For targets that recently</span>
	<span class="c"># switched to ELF, *-*-netbsd* would select the old</span>
	<span class="c"># object file format.  This provides both forward</span>
	<span class="c"># compatibility and a consistent mechanism for selecting the</span>
	<span class="c"># object file format.</span>
	<span class="c">#</span>
	<span class="c"># Note: NetBSD doesn&#39;t particularly care about the vendor</span>
	<span class="c"># portion of the name.  We always set it to &quot;unknown&quot;.</span>
	<span class="nv">sysctl</span><span class="o">=</span><span class="s2">&quot;sysctl -n hw.machine_arch&quot;</span>
	<span class="nv">UNAME_MACHINE_ARCH</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>/sbin/<span class="nv">$sysctl</span> 2&gt;/dev/null <span class="o">||</span> <span class="se">\</span>
	    /usr/sbin/<span class="nv">$sysctl</span> 2&gt;/dev/null <span class="o">||</span> <span class="nb">echo </span>unknown<span class="o">)</span><span class="sb">`</span>
	<span class="k">case</span> <span class="s2">&quot;${UNAME_MACHINE_ARCH}&quot;</span> in
	    armeb<span class="o">)</span> <span class="nv">machine</span><span class="o">=</span>armeb-unknown ;;
	    arm*<span class="o">)</span> <span class="nv">machine</span><span class="o">=</span>arm-unknown ;;
	    sh3el<span class="o">)</span> <span class="nv">machine</span><span class="o">=</span>shl-unknown ;;
	    sh3eb<span class="o">)</span> <span class="nv">machine</span><span class="o">=</span>sh-unknown ;;
	    sh5el<span class="o">)</span> <span class="nv">machine</span><span class="o">=</span>sh5le-unknown ;;
	    *<span class="o">)</span> <span class="nv">machine</span><span class="o">=</span><span class="k">${</span><span class="nv">UNAME_MACHINE_ARCH</span><span class="k">}</span>-unknown ;;
	<span class="k">esac</span>
	<span class="c"># The Operating System including object format, if it has switched</span>
	<span class="c"># to ELF recently, or will in the future.</span>
	<span class="k">case</span> <span class="s2">&quot;${UNAME_MACHINE_ARCH}&quot;</span> in
	    arm*|i386|m68k|ns32k|sh3*|sparc|vax<span class="o">)</span>
		<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
		<span class="k">if </span><span class="nb">echo </span>__ELF__ | <span class="nv">$CC_FOR_BUILD</span> -E - 2&gt;/dev/null <span class="se">\</span>
			| grep -q __ELF__
		<span class="k">then</span>
		    <span class="c"># Once all utilities can be ECOFF (netbsdecoff) or a.out (netbsdaout).</span>
		    <span class="c"># Return netbsd for either.  FIX?</span>
		    <span class="nv">os</span><span class="o">=</span>netbsd
		<span class="k">else</span>
<span class="k">		    </span><span class="nv">os</span><span class="o">=</span>netbsdelf
		<span class="k">fi</span>
		;;
	    *<span class="o">)</span>
		<span class="nv">os</span><span class="o">=</span>netbsd
		;;
	<span class="k">esac</span>
	<span class="c"># The OS release</span>
	<span class="c"># Debian GNU/NetBSD machines have a different userland, and</span>
	<span class="c"># thus, need a distinct triplet. However, they do not need</span>
	<span class="c"># kernel version information, so it can be replaced with a</span>
	<span class="c"># suitable tag, in the style of linux-gnu.</span>
	<span class="k">case</span> <span class="s2">&quot;${UNAME_VERSION}&quot;</span> in
	    Debian*<span class="o">)</span>
		<span class="nv">release</span><span class="o">=</span><span class="s1">&#39;-gnu&#39;</span>
		;;
	    *<span class="o">)</span>
		<span class="nv">release</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[-_].*/\./&#39;</span><span class="sb">`</span>
		;;
	<span class="k">esac</span>
	<span class="c"># Since CPU_TYPE-MANUFACTURER-KERNEL-OPERATING_SYSTEM:</span>
	<span class="c"># contains redundant information, the shorter form:</span>
	<span class="c"># CPU_TYPE-MANUFACTURER-OPERATING_SYSTEM is used.</span>
	<span class="nb">echo</span> <span class="s2">&quot;${machine}-${os}${release}&quot;</span>
	<span class="nb">exit</span> ;;
    *:Bitrig:*:*<span class="o">)</span>
	<span class="nv">UNAME_MACHINE_ARCH</span><span class="o">=</span><span class="sb">`</span>arch | sed <span class="s1">&#39;s/Bitrig.//&#39;</span><span class="sb">`</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE_ARCH</span><span class="k">}</span>-unknown-bitrig<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:OpenBSD:*:*<span class="o">)</span>
	<span class="nv">UNAME_MACHINE_ARCH</span><span class="o">=</span><span class="sb">`</span>arch | sed <span class="s1">&#39;s/OpenBSD.//&#39;</span><span class="sb">`</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE_ARCH</span><span class="k">}</span>-unknown-openbsd<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:ekkoBSD:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-ekkobsd<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:SolidBSD:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-solidbsd<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    macppc:MirBSD:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-unknown-mirbsd<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:MirBSD:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-mirbsd<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    alpha:OSF1:*:*<span class="o">)</span>
	<span class="k">case</span> <span class="nv">$UNAME_RELEASE</span> in
	*4.0<span class="o">)</span>
		<span class="nv">UNAME_RELEASE</span><span class="o">=</span><span class="sb">`</span>/usr/sbin/sizer -v | awk <span class="s1">&#39;{print $3}&#39;</span><span class="sb">`</span>
		;;
	*5.*<span class="o">)</span>
		<span class="nv">UNAME_RELEASE</span><span class="o">=</span><span class="sb">`</span>/usr/sbin/sizer -v | awk <span class="s1">&#39;{print $4}&#39;</span><span class="sb">`</span>
		;;
	<span class="k">esac</span>
	<span class="c"># According to Compaq, /usr/sbin/psrinfo has been available on</span>
	<span class="c"># OSF/1 and Tru64 systems produced since 1995.  I hope that</span>
	<span class="c"># covers most systems running today.  This code pipes the CPU</span>
	<span class="c"># types through head -n 1, so we only detect the type of CPU 0.</span>
	<span class="nv">ALPHA_CPU_TYPE</span><span class="o">=</span><span class="sb">`</span>/usr/sbin/psrinfo -v | sed -n -e <span class="s1">&#39;s/^  The alpha \(.*\) processor.*$/\1/p&#39;</span> | head -n 1<span class="sb">`</span>
	<span class="k">case</span> <span class="s2">&quot;$ALPHA_CPU_TYPE&quot;</span> in
	    <span class="s2">&quot;EV4 (21064)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alpha&quot;</span> ;;
	    <span class="s2">&quot;EV4.5 (21064)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alpha&quot;</span> ;;
	    <span class="s2">&quot;LCA4 (21066/21068)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alpha&quot;</span> ;;
	    <span class="s2">&quot;EV5 (21164)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev5&quot;</span> ;;
	    <span class="s2">&quot;EV5.6 (21164A)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev56&quot;</span> ;;
	    <span class="s2">&quot;EV5.6 (21164PC)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphapca56&quot;</span> ;;
	    <span class="s2">&quot;EV5.7 (21164PC)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphapca57&quot;</span> ;;
	    <span class="s2">&quot;EV6 (21264)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev6&quot;</span> ;;
	    <span class="s2">&quot;EV6.7 (21264A)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev67&quot;</span> ;;
	    <span class="s2">&quot;EV6.8CB (21264C)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev68&quot;</span> ;;
	    <span class="s2">&quot;EV6.8AL (21264B)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev68&quot;</span> ;;
	    <span class="s2">&quot;EV6.8CX (21264D)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev68&quot;</span> ;;
	    <span class="s2">&quot;EV6.9A (21264/EV69A)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev69&quot;</span> ;;
	    <span class="s2">&quot;EV7 (21364)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev7&quot;</span> ;;
	    <span class="s2">&quot;EV7.9 (21364A)&quot;</span><span class="o">)</span>
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;alphaev79&quot;</span> ;;
	<span class="k">esac</span>
	<span class="c"># A Pn.n version is a patched version.</span>
	<span class="c"># A Vn.n version is a released version.</span>
	<span class="c"># A Tn.n version is a released field test version.</span>
	<span class="c"># A Xn.n version is an unreleased experimental baselevel.</span>
	<span class="c"># 1.2 uses &quot;1.2&quot; for uname -r.</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-dec-osf<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed -e <span class="s1">&#39;s/^[PVTX]//&#39;</span> | tr <span class="s1">&#39;ABCDEFGHIJKLMNOPQRSTUVWXYZ&#39;</span> <span class="s1">&#39;abcdefghijklmnopqrstuvwxyz&#39;</span><span class="sb">`</span>
	<span class="c"># Reset EXIT trap before exiting to avoid spurious non-zero exit code.</span>
	<span class="nv">exitcode</span><span class="o">=</span><span class="nv">$?</span>
	<span class="nb">trap</span> <span class="s1">&#39;&#39;</span> 0
	<span class="nb">exit</span> <span class="nv">$exitcode</span> ;;
    Alpha<span class="se">\ </span>*:Windows_NT*:*<span class="o">)</span>
	<span class="c"># How do we know it&#39;s Interix rather than the generic POSIX subsystem?</span>
	<span class="c"># Should we change UNAME_MACHINE based on the output of uname instead</span>
	<span class="c"># of the specific Alpha model?</span>
	<span class="nb">echo </span>alpha-pc-interix
	<span class="nb">exit</span> ;;
    21064:Windows_NT:50:3<span class="o">)</span>
	<span class="nb">echo </span>alpha-dec-winnt3.5
	<span class="nb">exit</span> ;;
    Amiga*:UNIX_System_V:4.0:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-unknown-sysv4
	<span class="nb">exit</span> ;;
    *:<span class="o">[</span>Aa<span class="o">]</span>miga<span class="o">[</span>Oo<span class="o">][</span>Ss<span class="o">]</span>:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-amigaos
	<span class="nb">exit</span> ;;
    *:<span class="o">[</span>Mm<span class="o">]</span>orph<span class="o">[</span>Oo<span class="o">][</span>Ss<span class="o">]</span>:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-morphos
	<span class="nb">exit</span> ;;
    *:OS/390:*:*<span class="o">)</span>
	<span class="nb">echo </span>i370-ibm-openedition
	<span class="nb">exit</span> ;;
    *:z/VM:*:*<span class="o">)</span>
	<span class="nb">echo </span>s390-ibm-zvmoe
	<span class="nb">exit</span> ;;
    *:OS400:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-ibm-os400
	<span class="nb">exit</span> ;;
    arm:RISC*:1.<span class="o">[</span>012<span class="o">]</span>*:*|arm:riscix:1.<span class="o">[</span>012<span class="o">]</span>*:*<span class="o">)</span>
	<span class="nb">echo </span>arm-acorn-riscix<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    arm*:riscos:*:*|arm*:RISCOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>arm-unknown-riscos
	<span class="nb">exit</span> ;;
    SR2?01:HI-UX/MPP:*:* | SR8000:HI-UX/MPP:*:*<span class="o">)</span>
	<span class="nb">echo </span>hppa1.1-hitachi-hiuxmpp
	<span class="nb">exit</span> ;;
    Pyramid*:OSx*:*:* | MIS*:OSx*:*:* | MIS*:SMP_DC-OSx*:*:*<span class="o">)</span>
	<span class="c"># akee@wpdis03.wpafb.af.mil (Earle F. Ake) contributed MIS and NILE.</span>
	<span class="k">if </span><span class="nb">test</span> <span class="s2">&quot;`(/bin/universe) 2&gt;/dev/null`&quot;</span> <span class="o">=</span> att ; <span class="k">then</span>
<span class="k">		</span><span class="nb">echo </span>pyramid-pyramid-sysv3
	<span class="k">else</span>
<span class="k">		</span><span class="nb">echo </span>pyramid-pyramid-bsd
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    NILE*:*:*:dcosx<span class="o">)</span>
	<span class="nb">echo </span>pyramid-pyramid-svr4
	<span class="nb">exit</span> ;;
    DRS?6000:unix:4.0:6*<span class="o">)</span>
	<span class="nb">echo </span>sparc-icl-nx6
	<span class="nb">exit</span> ;;
    DRS?6000:UNIX_SV:4.2*:7* | DRS?6000:isis:4.2*:7*<span class="o">)</span>
	<span class="k">case</span> <span class="sb">`</span>/usr/bin/uname -p<span class="sb">`</span> in
	    sparc<span class="o">)</span> <span class="nb">echo </span>sparc-icl-nx7; <span class="nb">exit</span> ;;
	<span class="k">esac</span> ;;
    s390x:SunOS:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-ibm-solaris2<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*//&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    sun4H:SunOS:5.*:*<span class="o">)</span>
	<span class="nb">echo </span>sparc-hal-solaris2<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*//&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    sun4*:SunOS:5.*:* | tadpole*:SunOS:5.*:*<span class="o">)</span>
	<span class="nb">echo </span>sparc-sun-solaris2<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*//&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    i86pc:AuroraUX:5.*:* | i86xen:AuroraUX:5.*:*<span class="o">)</span>
	<span class="nb">echo </span>i386-pc-auroraux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    i86pc:SunOS:5.*:* | i86xen:SunOS:5.*:*<span class="o">)</span>
	<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
	<span class="nv">SUN_ARCH</span><span class="o">=</span><span class="s2">&quot;i386&quot;</span>
	<span class="c"># If there is a compiler, see if it is configured for 64-bit objects.</span>
	<span class="c"># Note that the Sun cc does not turn __LP64__ into 1 like gcc does.</span>
	<span class="c"># This test works for both compilers.</span>
	<span class="k">if</span> <span class="o">[</span> <span class="s2">&quot;$CC_FOR_BUILD&quot;</span> !<span class="o">=</span> <span class="s1">&#39;no_compiler_found&#39;</span> <span class="o">]</span>; <span class="k">then</span>
<span class="k">	    if</span> <span class="o">(</span><span class="nb">echo</span> <span class="s1">&#39;#ifdef __amd64&#39;</span>; <span class="nb">echo </span>IS_64BIT_ARCH; <span class="nb">echo</span> <span class="s1">&#39;#endif&#39;</span><span class="o">)</span> | <span class="se">\</span>
		<span class="o">(</span><span class="nv">CCOPTS</span><span class="o">=</span> <span class="nv">$CC_FOR_BUILD</span> -E - 2&gt;/dev/null<span class="o">)</span> | <span class="se">\</span>
		grep IS_64BIT_ARCH &gt;/dev/null
	    <span class="k">then</span>
<span class="k">		</span><span class="nv">SUN_ARCH</span><span class="o">=</span><span class="s2">&quot;x86_64&quot;</span>
	    <span class="k">fi</span>
<span class="k">	fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">SUN_ARCH</span><span class="k">}</span>-pc-solaris2<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*//&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    sun4*:SunOS:6*:*<span class="o">)</span>
	<span class="c"># According to config.sub, this is the proper way to canonicalize</span>
	<span class="c"># SunOS6.  Hard to guess exactly what SunOS6 will be like, but</span>
	<span class="c"># it&#39;s likely to be more like Solaris than SunOS4.</span>
	<span class="nb">echo </span>sparc-sun-solaris3<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*//&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    sun4*:SunOS:*:*<span class="o">)</span>
	<span class="k">case</span> <span class="s2">&quot;`/usr/bin/arch -k`&quot;</span> in
	    Series*|S4*<span class="o">)</span>
		<span class="nv">UNAME_RELEASE</span><span class="o">=</span><span class="sb">`</span>uname -v<span class="sb">`</span>
		;;
	<span class="k">esac</span>
	<span class="c"># Japanese Language versions have a version number like `4.1.3-JL&#39;.</span>
	<span class="nb">echo </span>sparc-sun-sunos<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/-/_/&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    sun3*:SunOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-sun-sunos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    sun*:*:4.2BSD:*<span class="o">)</span>
	<span class="nv">UNAME_RELEASE</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>sed 1q /etc/motd | awk <span class="s1">&#39;{print substr($5,1,3)}&#39;</span><span class="o">)</span> 2&gt;/dev/null<span class="sb">`</span>
	<span class="nb">test</span> <span class="s2">&quot;x${UNAME_RELEASE}&quot;</span> <span class="o">=</span> <span class="s2">&quot;x&quot;</span> <span class="o">&amp;&amp;</span> <span class="nv">UNAME_RELEASE</span><span class="o">=</span>3
	<span class="k">case</span> <span class="s2">&quot;`/bin/arch`&quot;</span> in
	    sun3<span class="o">)</span>
		<span class="nb">echo </span>m68k-sun-sunos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
		;;
	    sun4<span class="o">)</span>
		<span class="nb">echo </span>sparc-sun-sunos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
		;;
	<span class="k">esac</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    aushp:SunOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>sparc-auspex-sunos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    <span class="c"># The situation for MiNT is a little confusing.  The machine name</span>
    <span class="c"># can be virtually everything (everything which is not</span>
    <span class="c"># &quot;atarist&quot; or &quot;atariste&quot; at least should have a processor</span>
    <span class="c"># &gt; m68000).  The system name ranges from &quot;MiNT&quot; over &quot;FreeMiNT&quot;</span>
    <span class="c"># to the lowercase version &quot;mint&quot; (or &quot;freemint&quot;).  Finally</span>
    <span class="c"># the system name &quot;TOS&quot; denotes a system which is actually not</span>
    <span class="c"># MiNT.  But MiNT is downward compatible to TOS, so this should</span>
    <span class="c"># be no problem.</span>
    atarist<span class="o">[</span>e<span class="o">]</span>:*MiNT:*:* | atarist<span class="o">[</span>e<span class="o">]</span>:*mint:*:* | atarist<span class="o">[</span>e<span class="o">]</span>:*TOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-atari-mint<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    atari*:*MiNT:*:* | atari*:*mint:*:* | atarist<span class="o">[</span>e<span class="o">]</span>:*TOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-atari-mint<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *falcon*:*MiNT:*:* | *falcon*:*mint:*:* | *falcon*:*TOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-atari-mint<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    milan*:*MiNT:*:* | milan*:*mint:*:* | *milan*:*TOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-milan-mint<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    hades*:*MiNT:*:* | hades*:*mint:*:* | *hades*:*TOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-hades-mint<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:*MiNT:*:* | *:*mint:*:* | *:*TOS:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-unknown-mint<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    m68k:machten:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-apple-machten<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    powerpc:machten:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-apple-machten<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    RISC*:Mach:*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-dec-mach_bsd4.3
	<span class="nb">exit</span> ;;
    RISC*:ULTRIX:*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-dec-ultrix<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    VAX*:ULTRIX*:*:*<span class="o">)</span>
	<span class="nb">echo </span>vax-dec-ultrix<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    2020:CLIX:*:* | 2430:CLIX:*:*<span class="o">)</span>
	<span class="nb">echo </span>clipper-intergraph-clix<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    mips:*:*:UMIPS | mips:*:*:RISCos<span class="o">)</span>
	<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
	sed <span class="s1">&#39;s/^	//&#39;</span> <span class="s">&lt;&lt; EOF &gt;$dummy.c</span>
<span class="s">#ifdef __cplusplus</span>
<span class="s">#include &lt;stdio.h&gt;  /* for printf() prototype */</span>
<span class="s">	int main (int argc, char *argv[]) {</span>
<span class="s">#else</span>
<span class="s">	int main (argc, argv) int argc; char *argv[]; {</span>
<span class="s">#endif</span>
<span class="s">	#if defined (host_mips) &amp;&amp; defined (MIPSEB)</span>
<span class="s">	#if defined (SYSTYPE_SYSV)</span>
<span class="s">	  printf (&quot;mips-mips-riscos%ssysv\n&quot;, argv[1]); exit (0);</span>
<span class="s">	#endif</span>
<span class="s">	#if defined (SYSTYPE_SVR4)</span>
<span class="s">	  printf (&quot;mips-mips-riscos%ssvr4\n&quot;, argv[1]); exit (0);</span>
<span class="s">	#endif</span>
<span class="s">	#if defined (SYSTYPE_BSD43) || defined(SYSTYPE_BSD)</span>
<span class="s">	  printf (&quot;mips-mips-riscos%sbsd\n&quot;, argv[1]); exit (0);</span>
<span class="s">	#endif</span>
<span class="s">	#endif</span>
<span class="s">	  exit (-1);</span>
<span class="s">	}</span>
<span class="s">EOF</span>
	<span class="nv">$CC_FOR_BUILD</span> -o <span class="nv">$dummy</span> <span class="nv">$dummy</span>.c <span class="o">&amp;&amp;</span>
	  <span class="nv">dummyarg</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="s2">&quot;${UNAME_RELEASE}&quot;</span> | sed -n <span class="s1">&#39;s/\([0-9]*\).*/\1/p&#39;</span><span class="sb">`</span> <span class="o">&amp;&amp;</span>
	  <span class="nv">SYSTEM_NAME</span><span class="o">=</span><span class="sb">`</span><span class="nv">$dummy</span> <span class="nv">$dummyarg</span><span class="sb">`</span> <span class="o">&amp;&amp;</span>
	    <span class="o">{</span> <span class="nb">echo</span> <span class="s2">&quot;$SYSTEM_NAME&quot;</span>; <span class="nb">exit</span>; <span class="o">}</span>
	<span class="nb">echo </span>mips-mips-riscos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    Motorola:PowerMAX_OS:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-motorola-powermax
	<span class="nb">exit</span> ;;
    Motorola:*:4.3:PL8-*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-harris-powermax
	<span class="nb">exit</span> ;;
    Night_Hawk:*:*:PowerMAX_OS | Synergy:PowerMAX_OS:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-harris-powermax
	<span class="nb">exit</span> ;;
    Night_Hawk:Power_UNIX:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-harris-powerunix
	<span class="nb">exit</span> ;;
    m88k:CX/UX:7*:*<span class="o">)</span>
	<span class="nb">echo </span>m88k-harris-cxux7
	<span class="nb">exit</span> ;;
    m88k:*:4*:R4*<span class="o">)</span>
	<span class="nb">echo </span>m88k-motorola-sysv4
	<span class="nb">exit</span> ;;
    m88k:*:3*:R3*<span class="o">)</span>
	<span class="nb">echo </span>m88k-motorola-sysv3
	<span class="nb">exit</span> ;;
    AViiON:dgux:*:*<span class="o">)</span>
	<span class="c"># DG/UX returns AViiON for all architectures</span>
	<span class="nv">UNAME_PROCESSOR</span><span class="o">=</span><span class="sb">`</span>/usr/bin/uname -p<span class="sb">`</span>
	<span class="k">if</span> <span class="o">[</span> <span class="nv">$UNAME_PROCESSOR</span> <span class="o">=</span> mc88100 <span class="o">]</span> <span class="o">||</span> <span class="o">[</span> <span class="nv">$UNAME_PROCESSOR</span> <span class="o">=</span> mc88110 <span class="o">]</span>
	<span class="k">then</span>
<span class="k">	    if</span> <span class="o">[</span> <span class="k">${</span><span class="nv">TARGET_BINARY_INTERFACE</span><span class="k">}</span><span class="nv">x</span> <span class="o">=</span> m88kdguxelfx <span class="o">]</span> <span class="o">||</span> <span class="se">\</span>
	       <span class="o">[</span> <span class="k">${</span><span class="nv">TARGET_BINARY_INTERFACE</span><span class="k">}</span><span class="nv">x</span> <span class="o">=</span> x <span class="o">]</span>
	    <span class="k">then</span>
<span class="k">		</span><span class="nb">echo </span>m88k-dg-dgux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	    <span class="k">else</span>
<span class="k">		</span><span class="nb">echo </span>m88k-dg-dguxbcs<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	    <span class="k">fi</span>
<span class="k">	else</span>
<span class="k">	    </span><span class="nb">echo </span>i586-dg-dgux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    M88*:DolphinOS:*:*<span class="o">)</span>	<span class="c"># DolphinOS (SVR3)</span>
	<span class="nb">echo </span>m88k-dolphin-sysv3
	<span class="nb">exit</span> ;;
    M88*:*:R3*:*<span class="o">)</span>
	<span class="c"># Delta 88k system running SVR3</span>
	<span class="nb">echo </span>m88k-motorola-sysv3
	<span class="nb">exit</span> ;;
    XD88*:*:*:*<span class="o">)</span> <span class="c"># Tektronix XD88 system running UTekV (SVR3)</span>
	<span class="nb">echo </span>m88k-tektronix-sysv3
	<span class="nb">exit</span> ;;
    Tek43<span class="o">[</span>0-9<span class="o">][</span>0-9<span class="o">]</span>:UTek:*:*<span class="o">)</span> <span class="c"># Tektronix 4300 system running UTek (BSD)</span>
	<span class="nb">echo </span>m68k-tektronix-bsd
	<span class="nb">exit</span> ;;
    *:IRIX*:*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-sgi-irix<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/-/_/g&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    ????????:AIX?:<span class="o">[</span>12<span class="o">]</span>.1:2<span class="o">)</span>   <span class="c"># AIX 2.2.1 or AIX 2.1.1 is RT/PC AIX.</span>
	<span class="nb">echo </span>romp-ibm-aix     <span class="c"># uname -m gives an 8 hex-code CPU id</span>
	<span class="nb">exit</span> ;;               <span class="c"># Note that: echo &quot;&#39;`uname -s`&#39;&quot; gives &#39;AIX &#39;</span>
    i*86:AIX:*:*<span class="o">)</span>
	<span class="nb">echo </span>i386-ibm-aix
	<span class="nb">exit</span> ;;
    ia64:AIX:*:*<span class="o">)</span>
	<span class="k">if</span> <span class="o">[</span> -x /usr/bin/oslevel <span class="o">]</span> ; <span class="k">then</span>
<span class="k">		</span><span class="nv">IBM_REV</span><span class="o">=</span><span class="sb">`</span>/usr/bin/oslevel<span class="sb">`</span>
	<span class="k">else</span>
<span class="k">		</span><span class="nv">IBM_REV</span><span class="o">=</span><span class="k">${</span><span class="nv">UNAME_VERSION</span><span class="k">}</span>.<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-ibm-aix<span class="k">${</span><span class="nv">IBM_REV</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:AIX:2:3<span class="o">)</span>
	<span class="k">if </span>grep bos325 /usr/include/stdio.h &gt;/dev/null 2&gt;&amp;1; <span class="k">then</span>
<span class="k">		</span><span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
		sed <span class="s1">&#39;s/^		//&#39;</span> <span class="s">&lt;&lt; EOF &gt;$dummy.c</span>
<span class="s">		#include &lt;sys/systemcfg.h&gt;</span>

<span class="s">		main()</span>
<span class="s">			{</span>
<span class="s">			if (!__power_pc())</span>
<span class="s">				exit(1);</span>
<span class="s">			puts(&quot;powerpc-ibm-aix3.2.5&quot;);</span>
<span class="s">			exit(0);</span>
<span class="s">			}</span>
<span class="s">EOF</span>
		<span class="k">if</span> <span class="nv">$CC_FOR_BUILD</span> -o <span class="nv">$dummy</span> <span class="nv">$dummy</span>.c <span class="o">&amp;&amp;</span> <span class="nv">SYSTEM_NAME</span><span class="o">=</span><span class="sb">`</span><span class="nv">$dummy</span><span class="sb">`</span>
		<span class="k">then</span>
<span class="k">			</span><span class="nb">echo</span> <span class="s2">&quot;$SYSTEM_NAME&quot;</span>
		<span class="k">else</span>
<span class="k">			</span><span class="nb">echo </span>rs6000-ibm-aix3.2.5
		<span class="k">fi</span>
<span class="k">	elif </span>grep bos324 /usr/include/stdio.h &gt;/dev/null 2&gt;&amp;1; <span class="k">then</span>
<span class="k">		</span><span class="nb">echo </span>rs6000-ibm-aix3.2.4
	<span class="k">else</span>
<span class="k">		</span><span class="nb">echo </span>rs6000-ibm-aix3.2
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    *:AIX:*:<span class="o">[</span>4567<span class="o">])</span>
	<span class="nv">IBM_CPU_ID</span><span class="o">=</span><span class="sb">`</span>/usr/sbin/lsdev -C -c processor -S available | sed 1q | awk <span class="s1">&#39;{ print $1 }&#39;</span><span class="sb">`</span>
	<span class="k">if</span> /usr/sbin/lsattr -El <span class="k">${</span><span class="nv">IBM_CPU_ID</span><span class="k">}</span> | grep <span class="s1">&#39; POWER&#39;</span> &gt;/dev/null 2&gt;&amp;1; <span class="k">then</span>
<span class="k">		</span><span class="nv">IBM_ARCH</span><span class="o">=</span>rs6000
	<span class="k">else</span>
<span class="k">		</span><span class="nv">IBM_ARCH</span><span class="o">=</span>powerpc
	<span class="k">fi</span>
<span class="k">	if</span> <span class="o">[</span> -x /usr/bin/oslevel <span class="o">]</span> ; <span class="k">then</span>
<span class="k">		</span><span class="nv">IBM_REV</span><span class="o">=</span><span class="sb">`</span>/usr/bin/oslevel<span class="sb">`</span>
	<span class="k">else</span>
<span class="k">		</span><span class="nv">IBM_REV</span><span class="o">=</span><span class="k">${</span><span class="nv">UNAME_VERSION</span><span class="k">}</span>.<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">IBM_ARCH</span><span class="k">}</span>-ibm-aix<span class="k">${</span><span class="nv">IBM_REV</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:AIX:*:*<span class="o">)</span>
	<span class="nb">echo </span>rs6000-ibm-aix
	<span class="nb">exit</span> ;;
    ibmrt:4.4BSD:*|romp-ibm:BSD:*<span class="o">)</span>
	<span class="nb">echo </span>romp-ibm-bsd4.4
	<span class="nb">exit</span> ;;
    ibmrt:*BSD:*|romp-ibm:BSD:*<span class="o">)</span>            <span class="c"># covers RT/PC BSD and</span>
	<span class="nb">echo </span>romp-ibm-bsd<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>   <span class="c"># 4.3 with uname added to</span>
	<span class="nb">exit</span> ;;                             <span class="c"># report: romp-ibm BSD 4.3</span>
    *:BOSX:*:*<span class="o">)</span>
	<span class="nb">echo </span>rs6000-bull-bosx
	<span class="nb">exit</span> ;;
    DPX/2?00:B.O.S.:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-bull-sysv3
	<span class="nb">exit</span> ;;
    9000/<span class="o">[</span>34<span class="o">]</span>??:4.3bsd:1.*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-hp-bsd
	<span class="nb">exit</span> ;;
    hp300:4.4BSD:*:* | 9000/<span class="o">[</span>34<span class="o">]</span>??:4.3bsd:2.*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-hp-bsd4.4
	<span class="nb">exit</span> ;;
    9000/<span class="o">[</span>34678<span class="o">]</span>??:HP-UX:*:*<span class="o">)</span>
	<span class="nv">HPUX_REV</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*.[0B]*//&#39;</span><span class="sb">`</span>
	<span class="k">case</span> <span class="s2">&quot;${UNAME_MACHINE}&quot;</span> in
	    9000/31? <span class="o">)</span>            <span class="nv">HP_ARCH</span><span class="o">=</span>m68000 ;;
	    9000/<span class="o">[</span>34<span class="o">]</span>?? <span class="o">)</span>         <span class="nv">HP_ARCH</span><span class="o">=</span>m68k ;;
	    9000/<span class="o">[</span>678<span class="o">][</span>0-9<span class="o">][</span>0-9<span class="o">])</span>
		<span class="k">if</span> <span class="o">[</span> -x /usr/bin/getconf <span class="o">]</span>; <span class="k">then</span>
<span class="k">		    </span><span class="nv">sc_cpu_version</span><span class="o">=</span><span class="sb">`</span>/usr/bin/getconf SC_CPU_VERSION 2&gt;/dev/null<span class="sb">`</span>
		    <span class="nv">sc_kernel_bits</span><span class="o">=</span><span class="sb">`</span>/usr/bin/getconf SC_KERNEL_BITS 2&gt;/dev/null<span class="sb">`</span>
		    <span class="k">case</span> <span class="s2">&quot;${sc_cpu_version}&quot;</span> in
		      523<span class="o">)</span> <span class="nv">HP_ARCH</span><span class="o">=</span><span class="s2">&quot;hppa1.0&quot;</span> ;; <span class="c"># CPU_PA_RISC1_0</span>
		      528<span class="o">)</span> <span class="nv">HP_ARCH</span><span class="o">=</span><span class="s2">&quot;hppa1.1&quot;</span> ;; <span class="c"># CPU_PA_RISC1_1</span>
		      532<span class="o">)</span>                      <span class="c"># CPU_PA_RISC2_0</span>
			<span class="k">case</span> <span class="s2">&quot;${sc_kernel_bits}&quot;</span> in
			  32<span class="o">)</span> <span class="nv">HP_ARCH</span><span class="o">=</span><span class="s2">&quot;hppa2.0n&quot;</span> ;;
			  64<span class="o">)</span> <span class="nv">HP_ARCH</span><span class="o">=</span><span class="s2">&quot;hppa2.0w&quot;</span> ;;
			  <span class="s1">&#39;&#39;</span><span class="o">)</span> <span class="nv">HP_ARCH</span><span class="o">=</span><span class="s2">&quot;hppa2.0&quot;</span> ;;   <span class="c"># HP-UX 10.20</span>
			<span class="k">esac</span> ;;
		    <span class="k">esac</span>
<span class="k">		fi</span>
<span class="k">		if</span> <span class="o">[</span> <span class="s2">&quot;${HP_ARCH}&quot;</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span> <span class="o">]</span>; <span class="k">then</span>
<span class="k">		    </span><span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
		    sed <span class="s1">&#39;s/^		//&#39;</span> <span class="s">&lt;&lt; EOF &gt;$dummy.c</span>

<span class="s">		#define _HPUX_SOURCE</span>
<span class="s">		#include &lt;stdlib.h&gt;</span>
<span class="s">		#include &lt;unistd.h&gt;</span>

<span class="s">		int main ()</span>
<span class="s">		{</span>
<span class="s">		#if defined(_SC_KERNEL_BITS)</span>
<span class="s">		    long bits = sysconf(_SC_KERNEL_BITS);</span>
<span class="s">		#endif</span>
<span class="s">		    long cpu  = sysconf (_SC_CPU_VERSION);</span>

<span class="s">		    switch (cpu)</span>
<span class="s">			{</span>
<span class="s">			case CPU_PA_RISC1_0: puts (&quot;hppa1.0&quot;); break;</span>
<span class="s">			case CPU_PA_RISC1_1: puts (&quot;hppa1.1&quot;); break;</span>
<span class="s">			case CPU_PA_RISC2_0:</span>
<span class="s">		#if defined(_SC_KERNEL_BITS)</span>
<span class="s">			    switch (bits)</span>
<span class="s">				{</span>
<span class="s">				case 64: puts (&quot;hppa2.0w&quot;); break;</span>
<span class="s">				case 32: puts (&quot;hppa2.0n&quot;); break;</span>
<span class="s">				default: puts (&quot;hppa2.0&quot;); break;</span>
<span class="s">				} break;</span>
<span class="s">		#else  /* !defined(_SC_KERNEL_BITS) */</span>
<span class="s">			    puts (&quot;hppa2.0&quot;); break;</span>
<span class="s">		#endif</span>
<span class="s">			default: puts (&quot;hppa1.0&quot;); break;</span>
<span class="s">			}</span>
<span class="s">		    exit (0);</span>
<span class="s">		}</span>
<span class="s">EOF</span>
		    <span class="o">(</span><span class="nv">CCOPTS</span><span class="o">=</span> <span class="nv">$CC_FOR_BUILD</span> -o <span class="nv">$dummy</span> <span class="nv">$dummy</span>.c 2&gt;/dev/null<span class="o">)</span> <span class="o">&amp;&amp;</span> <span class="nv">HP_ARCH</span><span class="o">=</span><span class="sb">`</span><span class="nv">$dummy</span><span class="sb">`</span>
		    <span class="nb">test</span> -z <span class="s2">&quot;$HP_ARCH&quot;</span> <span class="o">&amp;&amp;</span> <span class="nv">HP_ARCH</span><span class="o">=</span>hppa
		<span class="k">fi</span> ;;
	<span class="k">esac</span>
<span class="k">	if</span> <span class="o">[</span> <span class="k">${</span><span class="nv">HP_ARCH</span><span class="k">}</span> <span class="o">=</span> <span class="s2">&quot;hppa2.0w&quot;</span> <span class="o">]</span>
	<span class="k">then</span>
<span class="k">	    </span><span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>

	    <span class="c"># hppa2.0w-hp-hpux* has a 64-bit kernel and a compiler generating</span>
	    <span class="c"># 32-bit code.  hppa64-hp-hpux* has the same kernel and a compiler</span>
	    <span class="c"># generating 64-bit code.  GNU and HP use different nomenclature:</span>
	    <span class="c">#</span>
	    <span class="c"># $ CC_FOR_BUILD=cc ./config.guess</span>
	    <span class="c"># =&gt; hppa2.0w-hp-hpux11.23</span>
	    <span class="c"># $ CC_FOR_BUILD=&quot;cc +DA2.0w&quot; ./config.guess</span>
	    <span class="c"># =&gt; hppa64-hp-hpux11.23</span>

	    <span class="k">if </span><span class="nb">echo </span>__LP64__ | <span class="o">(</span><span class="nv">CCOPTS</span><span class="o">=</span> <span class="nv">$CC_FOR_BUILD</span> -E - 2&gt;/dev/null<span class="o">)</span> |
		grep -q __LP64__
	    <span class="k">then</span>
<span class="k">		</span><span class="nv">HP_ARCH</span><span class="o">=</span><span class="s2">&quot;hppa2.0w&quot;</span>
	    <span class="k">else</span>
<span class="k">		</span><span class="nv">HP_ARCH</span><span class="o">=</span><span class="s2">&quot;hppa64&quot;</span>
	    <span class="k">fi</span>
<span class="k">	fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">HP_ARCH</span><span class="k">}</span>-hp-hpux<span class="k">${</span><span class="nv">HPUX_REV</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    ia64:HP-UX:*:*<span class="o">)</span>
	<span class="nv">HPUX_REV</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*.[0B]*//&#39;</span><span class="sb">`</span>
	<span class="nb">echo </span>ia64-hp-hpux<span class="k">${</span><span class="nv">HPUX_REV</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    3050*:HI-UX:*:*<span class="o">)</span>
	<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
	sed <span class="s1">&#39;s/^	//&#39;</span> <span class="s">&lt;&lt; EOF &gt;$dummy.c</span>
<span class="s">	#include &lt;unistd.h&gt;</span>
<span class="s">	int</span>
<span class="s">	main ()</span>
<span class="s">	{</span>
<span class="s">	  long cpu = sysconf (_SC_CPU_VERSION);</span>
<span class="s">	  /* The order matters, because CPU_IS_HP_MC68K erroneously returns</span>
<span class="s">	     true for CPU_PA_RISC1_0.  CPU_IS_PA_RISC returns correct</span>
<span class="s">	     results, however.  */</span>
<span class="s">	  if (CPU_IS_PA_RISC (cpu))</span>
<span class="s">	    {</span>
<span class="s">	      switch (cpu)</span>
<span class="s">		{</span>
<span class="s">		  case CPU_PA_RISC1_0: puts (&quot;hppa1.0-hitachi-hiuxwe2&quot;); break;</span>
<span class="s">		  case CPU_PA_RISC1_1: puts (&quot;hppa1.1-hitachi-hiuxwe2&quot;); break;</span>
<span class="s">		  case CPU_PA_RISC2_0: puts (&quot;hppa2.0-hitachi-hiuxwe2&quot;); break;</span>
<span class="s">		  default: puts (&quot;hppa-hitachi-hiuxwe2&quot;); break;</span>
<span class="s">		}</span>
<span class="s">	    }</span>
<span class="s">	  else if (CPU_IS_HP_MC68K (cpu))</span>
<span class="s">	    puts (&quot;m68k-hitachi-hiuxwe2&quot;);</span>
<span class="s">	  else puts (&quot;unknown-hitachi-hiuxwe2&quot;);</span>
<span class="s">	  exit (0);</span>
<span class="s">	}</span>
<span class="s">EOF</span>
	<span class="nv">$CC_FOR_BUILD</span> -o <span class="nv">$dummy</span> <span class="nv">$dummy</span>.c <span class="o">&amp;&amp;</span> <span class="nv">SYSTEM_NAME</span><span class="o">=</span><span class="sb">`</span><span class="nv">$dummy</span><span class="sb">`</span> <span class="o">&amp;&amp;</span>
		<span class="o">{</span> <span class="nb">echo</span> <span class="s2">&quot;$SYSTEM_NAME&quot;</span>; <span class="nb">exit</span>; <span class="o">}</span>
	<span class="nb">echo </span>unknown-hitachi-hiuxwe2
	<span class="nb">exit</span> ;;
    9000/7??:4.3bsd:*:* | 9000/8?<span class="o">[</span>79<span class="o">]</span>:4.3bsd:*:* <span class="o">)</span>
	<span class="nb">echo </span>hppa1.1-hp-bsd
	<span class="nb">exit</span> ;;
    9000/8??:4.3bsd:*:*<span class="o">)</span>
	<span class="nb">echo </span>hppa1.0-hp-bsd
	<span class="nb">exit</span> ;;
    *9??*:MPE/iX:*:* | *3000*:MPE/iX:*:*<span class="o">)</span>
	<span class="nb">echo </span>hppa1.0-hp-mpeix
	<span class="nb">exit</span> ;;
    hp7??:OSF1:*:* | hp8?<span class="o">[</span>79<span class="o">]</span>:OSF1:*:* <span class="o">)</span>
	<span class="nb">echo </span>hppa1.1-hp-osf
	<span class="nb">exit</span> ;;
    hp8??:OSF1:*:*<span class="o">)</span>
	<span class="nb">echo </span>hppa1.0-hp-osf
	<span class="nb">exit</span> ;;
    i*86:OSF1:*:*<span class="o">)</span>
	<span class="k">if</span> <span class="o">[</span> -x /usr/sbin/sysversion <span class="o">]</span> ; <span class="k">then</span>
<span class="k">	    </span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-osf1mk
	<span class="k">else</span>
<span class="k">	    </span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-osf1
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    parisc*:Lites*:*:*<span class="o">)</span>
	<span class="nb">echo </span>hppa1.1-hp-lites
	<span class="nb">exit</span> ;;
    C1*:ConvexOS:*:* | convex:ConvexOS:C1*:*<span class="o">)</span>
	<span class="nb">echo </span>c1-convex-bsd
	<span class="nb">exit</span> ;;
    C2*:ConvexOS:*:* | convex:ConvexOS:C2*:*<span class="o">)</span>
	<span class="k">if </span>getsysinfo -f scalar_acc
	<span class="k">then </span><span class="nb">echo </span>c32-convex-bsd
	<span class="k">else </span><span class="nb">echo </span>c2-convex-bsd
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    C34*:ConvexOS:*:* | convex:ConvexOS:C34*:*<span class="o">)</span>
	<span class="nb">echo </span>c34-convex-bsd
	<span class="nb">exit</span> ;;
    C38*:ConvexOS:*:* | convex:ConvexOS:C38*:*<span class="o">)</span>
	<span class="nb">echo </span>c38-convex-bsd
	<span class="nb">exit</span> ;;
    C4*:ConvexOS:*:* | convex:ConvexOS:C4*:*<span class="o">)</span>
	<span class="nb">echo </span>c4-convex-bsd
	<span class="nb">exit</span> ;;
    CRAY*Y-MP:*:*:*<span class="o">)</span>
	<span class="nb">echo </span>ymp-cray-unicos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed -e <span class="s1">&#39;s/\.[^.]*$/.X/&#39;</span>
	<span class="nb">exit</span> ;;
    CRAY*<span class="o">[</span>A-Z<span class="o">]</span>90:*:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-cray-unicos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> <span class="se">\</span>
	| sed -e <span class="s1">&#39;s/CRAY.*\([A-Z]90\)/\1/&#39;</span> <span class="se">\</span>
	      -e y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/ <span class="se">\</span>
	      -e <span class="s1">&#39;s/\.[^.]*$/.X/&#39;</span>
	<span class="nb">exit</span> ;;
    CRAY*TS:*:*:*<span class="o">)</span>
	<span class="nb">echo </span>t90-cray-unicos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed -e <span class="s1">&#39;s/\.[^.]*$/.X/&#39;</span>
	<span class="nb">exit</span> ;;
    CRAY*T3E:*:*:*<span class="o">)</span>
	<span class="nb">echo </span>alphaev5-cray-unicosmk<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed -e <span class="s1">&#39;s/\.[^.]*$/.X/&#39;</span>
	<span class="nb">exit</span> ;;
    CRAY*SV1:*:*:*<span class="o">)</span>
	<span class="nb">echo </span>sv1-cray-unicos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed -e <span class="s1">&#39;s/\.[^.]*$/.X/&#39;</span>
	<span class="nb">exit</span> ;;
    *:UNICOS/mp:*:*<span class="o">)</span>
	<span class="nb">echo </span>craynv-cray-unicosmp<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed -e <span class="s1">&#39;s/\.[^.]*$/.X/&#39;</span>
	<span class="nb">exit</span> ;;
    F30<span class="o">[</span>01<span class="o">]</span>:UNIX_System_V:*:* | F700:UNIX_System_V:*:*<span class="o">)</span>
	<span class="nv">FUJITSU_PROC</span><span class="o">=</span><span class="sb">`</span>uname -m | tr <span class="s1">&#39;ABCDEFGHIJKLMNOPQRSTUVWXYZ&#39;</span> <span class="s1">&#39;abcdefghijklmnopqrstuvwxyz&#39;</span><span class="sb">`</span>
	<span class="nv">FUJITSU_SYS</span><span class="o">=</span><span class="sb">`</span>uname -p | tr <span class="s1">&#39;ABCDEFGHIJKLMNOPQRSTUVWXYZ&#39;</span> <span class="s1">&#39;abcdefghijklmnopqrstuvwxyz&#39;</span> | sed -e <span class="s1">&#39;s/\///&#39;</span><span class="sb">`</span>
	<span class="nv">FUJITSU_REL</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed -e <span class="s1">&#39;s/ /_/&#39;</span><span class="sb">`</span>
	<span class="nb">echo</span> <span class="s2">&quot;${FUJITSU_PROC}-fujitsu-${FUJITSU_SYS}${FUJITSU_REL}&quot;</span>
	<span class="nb">exit</span> ;;
    5000:UNIX_System_V:4.*:*<span class="o">)</span>
	<span class="nv">FUJITSU_SYS</span><span class="o">=</span><span class="sb">`</span>uname -p | tr <span class="s1">&#39;ABCDEFGHIJKLMNOPQRSTUVWXYZ&#39;</span> <span class="s1">&#39;abcdefghijklmnopqrstuvwxyz&#39;</span> | sed -e <span class="s1">&#39;s/\///&#39;</span><span class="sb">`</span>
	<span class="nv">FUJITSU_REL</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | tr <span class="s1">&#39;ABCDEFGHIJKLMNOPQRSTUVWXYZ&#39;</span> <span class="s1">&#39;abcdefghijklmnopqrstuvwxyz&#39;</span> | sed -e <span class="s1">&#39;s/ /_/&#39;</span><span class="sb">`</span>
	<span class="nb">echo</span> <span class="s2">&quot;sparc-fujitsu-${FUJITSU_SYS}${FUJITSU_REL}&quot;</span>
	<span class="nb">exit</span> ;;
    i*86:BSD/386:*:* | i*86:BSD/OS:*:* | *:Ascend<span class="se">\ </span>Embedded/OS:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-bsdi<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    sparc*:BSD/OS:*:*<span class="o">)</span>
	<span class="nb">echo </span>sparc-unknown-bsdi<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:BSD/OS:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-bsdi<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:FreeBSD:*:*<span class="o">)</span>
	<span class="nv">UNAME_PROCESSOR</span><span class="o">=</span><span class="sb">`</span>/usr/bin/uname -p<span class="sb">`</span>
	<span class="k">case</span> <span class="k">${</span><span class="nv">UNAME_PROCESSOR</span><span class="k">}</span> in
	    amd64<span class="o">)</span>
		<span class="nb">echo </span>x86_64-unknown-freebsd<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[-(].*//&#39;</span><span class="sb">`</span> ;;
	    *<span class="o">)</span>
		<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_PROCESSOR</span><span class="k">}</span>-unknown-freebsd<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[-(].*//&#39;</span><span class="sb">`</span> ;;
	<span class="k">esac</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    i*:CYGWIN*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-cygwin
	<span class="nb">exit</span> ;;
    *:MINGW64*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-mingw64
	<span class="nb">exit</span> ;;
    *:MINGW*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-mingw32
	<span class="nb">exit</span> ;;
    *:MSYS*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-msys
	<span class="nb">exit</span> ;;
    i*:windows32*:*<span class="o">)</span>
	<span class="c"># uname -m includes &quot;-pc&quot; on this system.</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-mingw32
	<span class="nb">exit</span> ;;
    i*:PW*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-pw32
	<span class="nb">exit</span> ;;
    *:Interix*:*<span class="o">)</span>
	<span class="k">case</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span> in
	    x86<span class="o">)</span>
		<span class="nb">echo </span>i586-pc-interix<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
		<span class="nb">exit</span> ;;
	    authenticamd | genuineintel | EM64T<span class="o">)</span>
		<span class="nb">echo </span>x86_64-unknown-interix<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
		<span class="nb">exit</span> ;;
	    IA64<span class="o">)</span>
		<span class="nb">echo </span>ia64-unknown-interix<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
		<span class="nb">exit</span> ;;
	<span class="k">esac</span> ;;
    <span class="o">[</span>345<span class="o">]</span>86:Windows_95:* | <span class="o">[</span>345<span class="o">]</span>86:Windows_98:* | <span class="o">[</span>345<span class="o">]</span>86:Windows_NT:*<span class="o">)</span>
	<span class="nb">echo </span>i<span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-mks
	<span class="nb">exit</span> ;;
    8664:Windows_NT:*<span class="o">)</span>
	<span class="nb">echo </span>x86_64-pc-mks
	<span class="nb">exit</span> ;;
    i*:Windows_NT*:* | Pentium*:Windows_NT*:*<span class="o">)</span>
	<span class="c"># How do we know it&#39;s Interix rather than the generic POSIX subsystem?</span>
	<span class="c"># It also conflicts with pre-2.0 versions of AT&amp;T UWIN. Should we</span>
	<span class="c"># UNAME_MACHINE based on the output of uname instead of i386?</span>
	<span class="nb">echo </span>i586-pc-interix
	<span class="nb">exit</span> ;;
    i*:UWIN*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-uwin
	<span class="nb">exit</span> ;;
    amd64:CYGWIN*:*:* | x86_64:CYGWIN*:*:*<span class="o">)</span>
	<span class="nb">echo </span>x86_64-unknown-cygwin
	<span class="nb">exit</span> ;;
    p*:CYGWIN*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpcle-unknown-cygwin
	<span class="nb">exit</span> ;;
    prep*:SunOS:5.*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpcle-unknown-solaris2<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[^.]*//&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    *:GNU:*:*<span class="o">)</span>
	<span class="c"># the GNU system</span>
	<span class="nb">echo</span> <span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s,[-/].*$,,&#39;</span><span class="sb">`</span>-unknown-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span><span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s,/.*$,,&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    *:GNU/*:*:*<span class="o">)</span>
	<span class="c"># other systems with GNU libc and userland</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_SYSTEM</span><span class="k">}</span> | sed <span class="s1">&#39;s,^[^/]*/,,&#39;</span> | tr <span class="s1">&#39;[A-Z]&#39;</span> <span class="s1">&#39;[a-z]&#39;</span><span class="sb">``</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[-(].*//&#39;</span><span class="sb">`</span>-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    i*86:Minix:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-minix
	<span class="nb">exit</span> ;;
    aarch64:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    aarch64_be:Linux:*:*<span class="o">)</span>
	<span class="nv">UNAME_MACHINE</span><span class="o">=</span>aarch64_be
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    alpha:Linux:*:*<span class="o">)</span>
	<span class="k">case</span> <span class="sb">`</span>sed -n <span class="s1">&#39;/^cpu model/s/^.*: \(.*\)/\1/p&#39;</span> &lt; /proc/cpuinfo<span class="sb">`</span> in
	  EV5<span class="o">)</span>   <span class="nv">UNAME_MACHINE</span><span class="o">=</span>alphaev5 ;;
	  EV56<span class="o">)</span>  <span class="nv">UNAME_MACHINE</span><span class="o">=</span>alphaev56 ;;
	  PCA56<span class="o">)</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>alphapca56 ;;
	  PCA57<span class="o">)</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>alphapca56 ;;
	  EV6<span class="o">)</span>   <span class="nv">UNAME_MACHINE</span><span class="o">=</span>alphaev6 ;;
	  EV67<span class="o">)</span>  <span class="nv">UNAME_MACHINE</span><span class="o">=</span>alphaev67 ;;
	  EV68*<span class="o">)</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>alphaev68 ;;
	<span class="k">esac</span>
<span class="k">	</span>objdump --private-headers /bin/sh | grep -q ld.so.1
	<span class="k">if </span><span class="nb">test</span> <span class="s2">&quot;$?&quot;</span> <span class="o">=</span> 0 ; <span class="k">then </span><span class="nv">LIBC</span><span class="o">=</span><span class="s2">&quot;gnulibc1&quot;</span> ; <span class="k">fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    arc:Linux:*:* | arceb:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    arm*:Linux:*:*<span class="o">)</span>
	<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
	<span class="k">if </span><span class="nb">echo </span>__ARM_EABI__ | <span class="nv">$CC_FOR_BUILD</span> -E - 2&gt;/dev/null <span class="se">\</span>
	    | grep -q __ARM_EABI__
	<span class="k">then</span>
<span class="k">	    </span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="k">else</span>
<span class="k">	    if </span><span class="nb">echo </span>__ARM_PCS_VFP | <span class="nv">$CC_FOR_BUILD</span> -E - 2&gt;/dev/null <span class="se">\</span>
		| grep -q __ARM_PCS_VFP
	    <span class="k">then</span>
<span class="k">		</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>eabi
	    <span class="k">else</span>
<span class="k">		</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>eabihf
	    <span class="k">fi</span>
<span class="k">	fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    avr32*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    cris:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-axis-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    crisv32:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-axis-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    frv:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    hexagon:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    i*86:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    ia64:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    m32r*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    m68*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    mips:Linux:*:* | mips64:Linux:*:*<span class="o">)</span>
	<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
	sed <span class="s1">&#39;s/^	//&#39;</span> <span class="s">&lt;&lt; EOF &gt;$dummy.c</span>
<span class="s">	#undef CPU</span>
<span class="s">	#undef ${UNAME_MACHINE}</span>
<span class="s">	#undef ${UNAME_MACHINE}el</span>
<span class="s">	#if defined(__MIPSEL__) || defined(__MIPSEL) || defined(_MIPSEL) || defined(MIPSEL)</span>
<span class="s">	CPU=${UNAME_MACHINE}el</span>
<span class="s">	#else</span>
<span class="s">	#if defined(__MIPSEB__) || defined(__MIPSEB) || defined(_MIPSEB) || defined(MIPSEB)</span>
<span class="s">	CPU=${UNAME_MACHINE}</span>
<span class="s">	#else</span>
<span class="s">	CPU=</span>
<span class="s">	#endif</span>
<span class="s">	#endif</span>
<span class="s">EOF</span>
	<span class="nb">eval</span> <span class="sb">`</span><span class="nv">$CC_FOR_BUILD</span> -E <span class="nv">$dummy</span>.c 2&gt;/dev/null | grep <span class="s1">&#39;^CPU&#39;</span><span class="sb">`</span>
	<span class="nb">test </span>x<span class="s2">&quot;${CPU}&quot;</span> !<span class="o">=</span> x <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo</span> <span class="s2">&quot;${CPU}-unknown-linux-${LIBC}&quot;</span>; <span class="nb">exit</span>; <span class="o">}</span>
	;;
    openrisc*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo </span>or1k-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    or32:Linux:*:* | or1k*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    padre:Linux:*:*<span class="o">)</span>
	<span class="nb">echo </span>sparc-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    parisc64:Linux:*:* | hppa64:Linux:*:*<span class="o">)</span>
	<span class="nb">echo </span>hppa64-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    parisc:Linux:*:* | hppa:Linux:*:*<span class="o">)</span>
	<span class="c"># Look for CPU level</span>
	<span class="k">case</span> <span class="sb">`</span>grep <span class="s1">&#39;^cpu[^a-z]*:&#39;</span> /proc/cpuinfo 2&gt;/dev/null | cut -d<span class="s1">&#39; &#39;</span> -f2<span class="sb">`</span> in
	  PA7*<span class="o">)</span> <span class="nb">echo </span>hppa1.1-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span> ;;
	  PA8*<span class="o">)</span> <span class="nb">echo </span>hppa2.0-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span> ;;
	  *<span class="o">)</span>    <span class="nb">echo </span>hppa-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span> ;;
	<span class="k">esac</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    ppc64:Linux:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc64-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    ppc:Linux:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    ppc64le:Linux:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc64le-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    ppcle:Linux:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpcle-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    s390:Linux:*:* | s390x:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-ibm-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    sh64*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    sh*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    sparc:Linux:*:* | sparc64:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    tile*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    vax:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-dec-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    x86_64:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    xtensa*:Linux:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-linux-<span class="k">${</span><span class="nv">LIBC</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    i*86:DYNIX/ptx:4*:*<span class="o">)</span>
	<span class="c"># ptx 4.0 does uname -s correctly, with DYNIX/ptx in there.</span>
	<span class="c"># earlier versions are messed up and put the nodename in both</span>
	<span class="c"># sysname and nodename.</span>
	<span class="nb">echo </span>i386-sequent-sysv4
	<span class="nb">exit</span> ;;
    i*86:UNIX_SV:4.2MP:2.*<span class="o">)</span>
	<span class="c"># Unixware is an offshoot of SVR4, but it has its own version</span>
	<span class="c"># number series starting with 2...</span>
	<span class="c"># I am not positive that other SVR4 systems won&#39;t match this,</span>
	<span class="c"># I just have to hope.  -- rms.</span>
	<span class="c"># Use sysv4.2uw... so that sysv4* matches it.</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-sysv4.2uw<span class="k">${</span><span class="nv">UNAME_VERSION</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    i*86:OS/2:*:*<span class="o">)</span>
	<span class="c"># If we were able to find `uname&#39;, then EMX Unix compatibility</span>
	<span class="c"># is probably installed.</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-os2-emx
	<span class="nb">exit</span> ;;
    i*86:XTS-300:*:STOP<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-stop
	<span class="nb">exit</span> ;;
    i*86:atheos:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-atheos
	<span class="nb">exit</span> ;;
    i*86:syllable:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-syllable
	<span class="nb">exit</span> ;;
    i*86:LynxOS:2.*:* | i*86:LynxOS:3.<span class="o">[</span>01<span class="o">]</span>*:* | i*86:LynxOS:4.<span class="o">[</span>02<span class="o">]</span>*:*<span class="o">)</span>
	<span class="nb">echo </span>i386-unknown-lynxos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    i*86:*DOS:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-msdosdjgpp
	<span class="nb">exit</span> ;;
    i*86:*:4.*:* | i*86:SYSTEM_V:4.*:*<span class="o">)</span>
	<span class="nv">UNAME_REL</span><span class="o">=</span><span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> | sed <span class="s1">&#39;s/\/MP$//&#39;</span><span class="sb">`</span>
	<span class="k">if </span>grep Novell /usr/include/link.h &gt;/dev/null 2&gt;/dev/null; <span class="k">then</span>
<span class="k">		</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-univel-sysv<span class="k">${</span><span class="nv">UNAME_REL</span><span class="k">}</span>
	<span class="k">else</span>
<span class="k">		</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-sysv<span class="k">${</span><span class="nv">UNAME_REL</span><span class="k">}</span>
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    i*86:*:5:<span class="o">[</span>678<span class="o">]</span>*<span class="o">)</span>
	<span class="c"># UnixWare 7.x, OpenUNIX and OpenServer 6.</span>
	<span class="k">case</span> <span class="sb">`</span>/bin/uname -X | grep <span class="s2">&quot;^Machine&quot;</span><span class="sb">`</span> in
	    *486*<span class="o">)</span>	     <span class="nv">UNAME_MACHINE</span><span class="o">=</span>i486 ;;
	    *Pentium<span class="o">)</span>	     <span class="nv">UNAME_MACHINE</span><span class="o">=</span>i586 ;;
	    *Pent*|*Celeron<span class="o">)</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>i686 ;;
	<span class="k">esac</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-sysv<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}${</span><span class="nv">UNAME_SYSTEM</span><span class="k">}${</span><span class="nv">UNAME_VERSION</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    i*86:*:3.2:*<span class="o">)</span>
	<span class="k">if </span><span class="nb">test</span> -f /usr/options/cb.name; <span class="k">then</span>
<span class="k">		</span><span class="nv">UNAME_REL</span><span class="o">=</span><span class="sb">`</span>sed -n <span class="s1">&#39;s/.*Version //p&#39;</span> &lt;/usr/options/cb.name<span class="sb">`</span>
		<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-isc<span class="nv">$UNAME_REL</span>
	<span class="k">elif</span> /bin/uname -X 2&gt;/dev/null &gt;/dev/null ; <span class="k">then</span>
<span class="k">		</span><span class="nv">UNAME_REL</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>/bin/uname -X|grep Release|sed -e <span class="s1">&#39;s/.*= //&#39;</span><span class="o">)</span><span class="sb">`</span>
		<span class="o">(</span>/bin/uname -X|grep i80486 &gt;/dev/null<span class="o">)</span> <span class="o">&amp;&amp;</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>i486
		<span class="o">(</span>/bin/uname -X|grep <span class="s1">&#39;^Machine.*Pentium&#39;</span> &gt;/dev/null<span class="o">)</span> <span class="se">\</span>
			<span class="o">&amp;&amp;</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>i586
		<span class="o">(</span>/bin/uname -X|grep <span class="s1">&#39;^Machine.*Pent *II&#39;</span> &gt;/dev/null<span class="o">)</span> <span class="se">\</span>
			<span class="o">&amp;&amp;</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>i686
		<span class="o">(</span>/bin/uname -X|grep <span class="s1">&#39;^Machine.*Pentium Pro&#39;</span> &gt;/dev/null<span class="o">)</span> <span class="se">\</span>
			<span class="o">&amp;&amp;</span> <span class="nv">UNAME_MACHINE</span><span class="o">=</span>i686
		<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-sco<span class="nv">$UNAME_REL</span>
	<span class="k">else</span>
<span class="k">		</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-sysv32
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    pc:*:*:*<span class="o">)</span>
	<span class="c"># Left here for compatibility:</span>
	<span class="c"># uname -m prints for DJGPP always &#39;pc&#39;, but it prints nothing about</span>
	<span class="c"># the processor, so we play safe by assuming i586.</span>
	<span class="c"># Note: whatever this is, it MUST be the same as what config.sub</span>
	<span class="c"># prints for the &quot;djgpp&quot; host, or else GDB configury will decide that</span>
	<span class="c"># this is a cross-build.</span>
	<span class="nb">echo </span>i586-pc-msdosdjgpp
	<span class="nb">exit</span> ;;
    Intel:Mach:3*:*<span class="o">)</span>
	<span class="nb">echo </span>i386-pc-mach3
	<span class="nb">exit</span> ;;
    paragon:*:*:*<span class="o">)</span>
	<span class="nb">echo </span>i860-intel-osf1
	<span class="nb">exit</span> ;;
    i860:*:4.*:*<span class="o">)</span> <span class="c"># i860-SVR4</span>
	<span class="k">if </span>grep Stardent /usr/include/sys/uadmin.h &gt;/dev/null 2&gt;&amp;1 ; <span class="k">then</span>
<span class="k">	  </span><span class="nb">echo </span>i860-stardent-sysv<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span> <span class="c"># Stardent Vistra i860-SVR4</span>
	<span class="k">else</span> <span class="c"># Add other i860-SVR4 vendors below as they are discovered.</span>
	  <span class="nb">echo </span>i860-unknown-sysv<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>  <span class="c"># Unknown i860-SVR4</span>
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    mini*:CTIX:SYS*5:*<span class="o">)</span>
	<span class="c"># &quot;miniframe&quot;</span>
	<span class="nb">echo </span>m68010-convergent-sysv
	<span class="nb">exit</span> ;;
    mc68k:UNIX:SYSTEM5:3.51m<span class="o">)</span>
	<span class="nb">echo </span>m68k-convergent-sysv
	<span class="nb">exit</span> ;;
    M680?0:D-NIX:5.3:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-diab-dnix
	<span class="nb">exit</span> ;;
    M68*:*:R3V<span class="o">[</span>5678<span class="o">]</span>*:*<span class="o">)</span>
	<span class="nb">test</span> -r /sysV68 <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo</span> <span class="s1">&#39;m68k-motorola-sysv&#39;</span>; <span class="nb">exit</span>; <span class="o">}</span> ;;
    3<span class="o">[</span>345<span class="o">]</span>??:*:4.0:3.0 | 3<span class="o">[</span>34<span class="o">]</span>??A:*:4.0:3.0 | 3<span class="o">[</span>34<span class="o">]</span>??,*:*:4.0:3.0 | 3<span class="o">[</span>34<span class="o">]</span>??/*:*:4.0:3.0 | 4400:*:4.0:3.0 | 4850:*:4.0:3.0 | SKA40:*:4.0:3.0 | SDS2:*:4.0:3.0 | SHG2:*:4.0:3.0 | S7501*:*:4.0:3.0<span class="o">)</span>
	<span class="nv">OS_REL</span><span class="o">=</span><span class="s1">&#39;&#39;</span>
	<span class="nb">test</span> -r /etc/.relid <span class="se">\</span>
	<span class="o">&amp;&amp;</span> <span class="nv">OS_REL</span><span class="o">=</span>.<span class="sb">`</span>sed -n <span class="s1">&#39;s/[^ ]* [^ ]* \([0-9][0-9]\).*/\1/p&#39;</span> &lt; /etc/.relid<span class="sb">`</span>
	/bin/uname -p 2&gt;/dev/null | grep 86 &gt;/dev/null <span class="se">\</span>
	  <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo </span>i486-ncr-sysv4.3<span class="k">${</span><span class="nv">OS_REL</span><span class="k">}</span>; <span class="nb">exit</span>; <span class="o">}</span>
	/bin/uname -p 2&gt;/dev/null | /bin/grep entium &gt;/dev/null <span class="se">\</span>
	  <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo </span>i586-ncr-sysv4.3<span class="k">${</span><span class="nv">OS_REL</span><span class="k">}</span>; <span class="nb">exit</span>; <span class="o">}</span> ;;
    3<span class="o">[</span>34<span class="o">]</span>??:*:4.0:* | 3<span class="o">[</span>34<span class="o">]</span>??,*:*:4.0:*<span class="o">)</span>
	/bin/uname -p 2&gt;/dev/null | grep 86 &gt;/dev/null <span class="se">\</span>
	  <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo </span>i486-ncr-sysv4; <span class="nb">exit</span>; <span class="o">}</span> ;;
    NCR*:*:4.2:* | MPRAS*:*:4.2:*<span class="o">)</span>
	<span class="nv">OS_REL</span><span class="o">=</span><span class="s1">&#39;.3&#39;</span>
	<span class="nb">test</span> -r /etc/.relid <span class="se">\</span>
	    <span class="o">&amp;&amp;</span> <span class="nv">OS_REL</span><span class="o">=</span>.<span class="sb">`</span>sed -n <span class="s1">&#39;s/[^ ]* [^ ]* \([0-9][0-9]\).*/\1/p&#39;</span> &lt; /etc/.relid<span class="sb">`</span>
	/bin/uname -p 2&gt;/dev/null | grep 86 &gt;/dev/null <span class="se">\</span>
	    <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo </span>i486-ncr-sysv4.3<span class="k">${</span><span class="nv">OS_REL</span><span class="k">}</span>; <span class="nb">exit</span>; <span class="o">}</span>
	/bin/uname -p 2&gt;/dev/null | /bin/grep entium &gt;/dev/null <span class="se">\</span>
	    <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo </span>i586-ncr-sysv4.3<span class="k">${</span><span class="nv">OS_REL</span><span class="k">}</span>; <span class="nb">exit</span>; <span class="o">}</span>
	/bin/uname -p 2&gt;/dev/null | /bin/grep pteron &gt;/dev/null <span class="se">\</span>
	    <span class="o">&amp;&amp;</span> <span class="o">{</span> <span class="nb">echo </span>i586-ncr-sysv4.3<span class="k">${</span><span class="nv">OS_REL</span><span class="k">}</span>; <span class="nb">exit</span>; <span class="o">}</span> ;;
    m68*:LynxOS:2.*:* | m68*:LynxOS:3.0*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-unknown-lynxos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    mc68030:UNIX_System_V:4.*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-atari-sysv4
	<span class="nb">exit</span> ;;
    TSUNAMI:LynxOS:2.*:*<span class="o">)</span>
	<span class="nb">echo </span>sparc-unknown-lynxos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    rs6000:LynxOS:2.*:*<span class="o">)</span>
	<span class="nb">echo </span>rs6000-unknown-lynxos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    PowerPC:LynxOS:2.*:* | PowerPC:LynxOS:3.<span class="o">[</span>01<span class="o">]</span>*:* | PowerPC:LynxOS:4.<span class="o">[</span>02<span class="o">]</span>*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-unknown-lynxos<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    SM<span class="o">[</span>BE<span class="o">]</span>S:UNIX_SV:*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-dde-sysv<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    RM*:ReliantUNIX-*:*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-sni-sysv4
	<span class="nb">exit</span> ;;
    RM*:SINIX-*:*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-sni-sysv4
	<span class="nb">exit</span> ;;
    *:SINIX-*:*:*<span class="o">)</span>
	<span class="k">if </span>uname -p 2&gt;/dev/null &gt;/dev/null ; <span class="k">then</span>
<span class="k">		</span><span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>uname -p<span class="o">)</span> 2&gt;/dev/null<span class="sb">`</span>
		<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-sni-sysv4
	<span class="k">else</span>
<span class="k">		</span><span class="nb">echo </span>ns32k-sni-sysv
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    PENTIUM:*:4.0*:*<span class="o">)</span>	<span class="c"># Unisys `ClearPath HMP IX 4000&#39; SVR4/MP effort</span>
			<span class="c"># says &lt;Richard.M.Bartel@ccMail.Census.GOV&gt;</span>
	<span class="nb">echo </span>i586-unisys-sysv4
	<span class="nb">exit</span> ;;
    *:UNIX_System_V:4*:FTX*<span class="o">)</span>
	<span class="c"># From Gerald Hewes &lt;hewes@openmarket.com&gt;.</span>
	<span class="c"># How about differentiating between stratus architectures? -djm</span>
	<span class="nb">echo </span>hppa1.1-stratus-sysv4
	<span class="nb">exit</span> ;;
    *:*:*:FTX*<span class="o">)</span>
	<span class="c"># From seanf@swdc.stratus.com.</span>
	<span class="nb">echo </span>i860-stratus-sysv4
	<span class="nb">exit</span> ;;
    i*86:VOS:*:*<span class="o">)</span>
	<span class="c"># From Paul.Green@stratus.com.</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-stratus-vos
	<span class="nb">exit</span> ;;
    *:VOS:*:*<span class="o">)</span>
	<span class="c"># From Paul.Green@stratus.com.</span>
	<span class="nb">echo </span>hppa1.1-stratus-vos
	<span class="nb">exit</span> ;;
    mc68*:A/UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>m68k-apple-aux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    news*:NEWS-OS:6*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-sony-newsos6
	<span class="nb">exit</span> ;;
    R<span class="o">[</span>34<span class="o">]</span>000:*System_V*:*:* | R4000:UNIX_SYSV:*:* | R*000:UNIX_SV:*:*<span class="o">)</span>
	<span class="k">if</span> <span class="o">[</span> -d /usr/nec <span class="o">]</span>; <span class="k">then</span>
<span class="k">		</span><span class="nb">echo </span>mips-nec-sysv<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="k">else</span>
<span class="k">		</span><span class="nb">echo </span>mips-unknown-sysv<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">exit</span> ;;
    BeBox:BeOS:*:*<span class="o">)</span>	<span class="c"># BeOS running on hardware made by Be, PPC only.</span>
	<span class="nb">echo </span>powerpc-be-beos
	<span class="nb">exit</span> ;;
    BeMac:BeOS:*:*<span class="o">)</span>	<span class="c"># BeOS running on Mac or Mac clone, PPC only.</span>
	<span class="nb">echo </span>powerpc-apple-beos
	<span class="nb">exit</span> ;;
    BePC:BeOS:*:*<span class="o">)</span>	<span class="c"># BeOS running on Intel PC compatible.</span>
	<span class="nb">echo </span>i586-pc-beos
	<span class="nb">exit</span> ;;
    BePC:Haiku:*:*<span class="o">)</span>	<span class="c"># Haiku running on Intel PC compatible.</span>
	<span class="nb">echo </span>i586-pc-haiku
	<span class="nb">exit</span> ;;
    x86_64:Haiku:*:*<span class="o">)</span>
	<span class="nb">echo </span>x86_64-unknown-haiku
	<span class="nb">exit</span> ;;
    SX-4:SUPER-UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>sx4-nec-superux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    SX-5:SUPER-UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>sx5-nec-superux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    SX-6:SUPER-UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>sx6-nec-superux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    SX-7:SUPER-UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>sx7-nec-superux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    SX-8:SUPER-UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>sx8-nec-superux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    SX-8R:SUPER-UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>sx8r-nec-superux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    Power*:Rhapsody:*:*<span class="o">)</span>
	<span class="nb">echo </span>powerpc-apple-rhapsody<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:Rhapsody:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-apple-rhapsody<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:Darwin:*:*<span class="o">)</span>
	<span class="nv">UNAME_PROCESSOR</span><span class="o">=</span><span class="sb">`</span>uname -p<span class="sb">`</span> <span class="o">||</span> <span class="nv">UNAME_PROCESSOR</span><span class="o">=</span>unknown
	<span class="nb">eval</span> <span class="nv">$set_cc_for_build</span>
	<span class="k">if </span><span class="nb">test</span> <span class="s2">&quot;$UNAME_PROCESSOR&quot;</span> <span class="o">=</span> unknown ; <span class="k">then</span>
<span class="k">	    </span><span class="nv">UNAME_PROCESSOR</span><span class="o">=</span>powerpc
	<span class="k">fi</span>
<span class="k">	if </span><span class="nb">test</span> <span class="sb">`</span><span class="nb">echo</span> <span class="s2">&quot;$UNAME_RELEASE&quot;</span> | sed -e <span class="s1">&#39;s/\..*//&#39;</span><span class="sb">`</span> -le 10 ; <span class="k">then</span>
<span class="k">	    if</span> <span class="o">[</span> <span class="s2">&quot;$CC_FOR_BUILD&quot;</span> !<span class="o">=</span> <span class="s1">&#39;no_compiler_found&#39;</span> <span class="o">]</span>; <span class="k">then</span>
<span class="k">		if</span> <span class="o">(</span><span class="nb">echo</span> <span class="s1">&#39;#ifdef __LP64__&#39;</span>; <span class="nb">echo </span>IS_64BIT_ARCH; <span class="nb">echo</span> <span class="s1">&#39;#endif&#39;</span><span class="o">)</span> | <span class="se">\</span>
		    <span class="o">(</span><span class="nv">CCOPTS</span><span class="o">=</span> <span class="nv">$CC_FOR_BUILD</span> -E - 2&gt;/dev/null<span class="o">)</span> | <span class="se">\</span>
		    grep IS_64BIT_ARCH &gt;/dev/null
		<span class="k">then</span>
<span class="k">		    case</span> <span class="nv">$UNAME_PROCESSOR</span> in
			i386<span class="o">)</span> <span class="nv">UNAME_PROCESSOR</span><span class="o">=</span>x86_64 ;;
			powerpc<span class="o">)</span> <span class="nv">UNAME_PROCESSOR</span><span class="o">=</span>powerpc64 ;;
		    <span class="k">esac</span>
<span class="k">		fi</span>
<span class="k">	    fi</span>
<span class="k">	elif </span><span class="nb">test</span> <span class="s2">&quot;$UNAME_PROCESSOR&quot;</span> <span class="o">=</span> i386 ; <span class="k">then</span>
	    <span class="c"># Avoid executing cc on OS X 10.9, as it ships with a stub</span>
	    <span class="c"># that puts up a graphical alert prompting to install</span>
	    <span class="c"># developer tools.  Any system running Mac OS X 10.7 or</span>
	    <span class="c"># later (Darwin 11 and later) is required to have a 64-bit</span>
	    <span class="c"># processor. This is not true of the ARM version of Darwin</span>
	    <span class="c"># that Apple uses in portable devices.</span>
	    <span class="nv">UNAME_PROCESSOR</span><span class="o">=</span>x86_64
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_PROCESSOR</span><span class="k">}</span>-apple-darwin<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:procnto*:*:* | *:QNX:<span class="o">[</span>0123456789<span class="o">]</span>*:*<span class="o">)</span>
	<span class="nv">UNAME_PROCESSOR</span><span class="o">=</span><span class="sb">`</span>uname -p<span class="sb">`</span>
	<span class="k">if </span><span class="nb">test</span> <span class="s2">&quot;$UNAME_PROCESSOR&quot;</span> <span class="o">=</span> <span class="s2">&quot;x86&quot;</span>; <span class="k">then</span>
<span class="k">		</span><span class="nv">UNAME_PROCESSOR</span><span class="o">=</span>i386
		<span class="nv">UNAME_MACHINE</span><span class="o">=</span>pc
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_PROCESSOR</span><span class="k">}</span>-<span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-nto-qnx<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:QNX:*:4*<span class="o">)</span>
	<span class="nb">echo </span>i386-pc-qnx
	<span class="nb">exit</span> ;;
    NEO-?:NONSTOP_KERNEL:*:*<span class="o">)</span>
	<span class="nb">echo </span>neo-tandem-nsk<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    NSE-*:NONSTOP_KERNEL:*:*<span class="o">)</span>
	<span class="nb">echo </span>nse-tandem-nsk<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    NSR-?:NONSTOP_KERNEL:*:*<span class="o">)</span>
	<span class="nb">echo </span>nsr-tandem-nsk<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:NonStop-UX:*:*<span class="o">)</span>
	<span class="nb">echo </span>mips-compaq-nonstopux
	<span class="nb">exit</span> ;;
    BS2000:POSIX*:*:*<span class="o">)</span>
	<span class="nb">echo </span>bs2000-siemens-sysv
	<span class="nb">exit</span> ;;
    DS/*:UNIX_System_V:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-<span class="k">${</span><span class="nv">UNAME_SYSTEM</span><span class="k">}</span>-<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:Plan9:*:*<span class="o">)</span>
	<span class="c"># &quot;uname -m&quot; is not consistent, so use $cputype instead. 386</span>
	<span class="c"># is converted to i386 for consistency with other x86</span>
	<span class="c"># operating systems.</span>
	<span class="k">if </span><span class="nb">test</span> <span class="s2">&quot;$cputype&quot;</span> <span class="o">=</span> <span class="s2">&quot;386&quot;</span>; <span class="k">then</span>
<span class="k">	    </span><span class="nv">UNAME_MACHINE</span><span class="o">=</span>i386
	<span class="k">else</span>
<span class="k">	    </span><span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="s2">&quot;$cputype&quot;</span>
	<span class="k">fi</span>
<span class="k">	</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-plan9
	<span class="nb">exit</span> ;;
    *:TOPS-10:*:*<span class="o">)</span>
	<span class="nb">echo </span>pdp10-unknown-tops10
	<span class="nb">exit</span> ;;
    *:TENEX:*:*<span class="o">)</span>
	<span class="nb">echo </span>pdp10-unknown-tenex
	<span class="nb">exit</span> ;;
    KS10:TOPS-20:*:* | KL10:TOPS-20:*:* | TYPE4:TOPS-20:*:*<span class="o">)</span>
	<span class="nb">echo </span>pdp10-dec-tops20
	<span class="nb">exit</span> ;;
    XKL-1:TOPS-20:*:* | TYPE5:TOPS-20:*:*<span class="o">)</span>
	<span class="nb">echo </span>pdp10-xkl-tops20
	<span class="nb">exit</span> ;;
    *:TOPS-20:*:*<span class="o">)</span>
	<span class="nb">echo </span>pdp10-unknown-tops20
	<span class="nb">exit</span> ;;
    *:ITS:*:*<span class="o">)</span>
	<span class="nb">echo </span>pdp10-unknown-its
	<span class="nb">exit</span> ;;
    SEI:*:*:SEIUX<span class="o">)</span>
	<span class="nb">echo </span>mips-sei-seiux<span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>
	<span class="nb">exit</span> ;;
    *:DragonFly:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-dragonfly<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span>|sed -e <span class="s1">&#39;s/[-(].*//&#39;</span><span class="sb">`</span>
	<span class="nb">exit</span> ;;
    *:*VMS:*:*<span class="o">)</span>
	<span class="nv">UNAME_MACHINE</span><span class="o">=</span><span class="sb">`</span><span class="o">(</span>uname -p<span class="o">)</span> 2&gt;/dev/null<span class="sb">`</span>
	<span class="k">case</span> <span class="s2">&quot;${UNAME_MACHINE}&quot;</span> in
	    A*<span class="o">)</span> <span class="nb">echo </span>alpha-dec-vms ; <span class="nb">exit</span> ;;
	    I*<span class="o">)</span> <span class="nb">echo </span>ia64-dec-vms ; <span class="nb">exit</span> ;;
	    V*<span class="o">)</span> <span class="nb">echo </span>vax-dec-vms ; <span class="nb">exit</span> ;;
	<span class="k">esac</span> ;;
    *:XENIX:*:SysV<span class="o">)</span>
	<span class="nb">echo </span>i386-pc-xenix
	<span class="nb">exit</span> ;;
    i*86:skyos:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-skyos<span class="sb">`</span><span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_RELEASE</span><span class="k">}</span><span class="sb">`</span> | sed -e <span class="s1">&#39;s/ .*$//&#39;</span>
	<span class="nb">exit</span> ;;
    i*86:rdos:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-rdos
	<span class="nb">exit</span> ;;
    i*86:AROS:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-pc-aros
	<span class="nb">exit</span> ;;
    x86_64:VMkernel:*:*<span class="o">)</span>
	<span class="nb">echo</span> <span class="k">${</span><span class="nv">UNAME_MACHINE</span><span class="k">}</span>-unknown-esx
	<span class="nb">exit</span> ;;
<span class="k">esac</span>

cat &gt;&amp;2 <span class="s">&lt;&lt;EOF</span>
<span class="s">$0: unable to guess system type</span>

<span class="s">This script, last modified $timestamp, has failed to recognize</span>
<span class="s">the operating system you are using. It is advised that you</span>
<span class="s">download the most up to date version of the config scripts from</span>

<span class="s">  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD</span>
<span class="s">and</span>
<span class="s">  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD</span>

<span class="s">If the version you run ($0) is already up to date, please</span>
<span class="s">send the following data and any information you think might be</span>
<span class="s">pertinent to &lt;config-patches@gnu.org&gt; in order to provide the needed</span>
<span class="s">information to handle your system.</span>

<span class="s">config.guess timestamp = $timestamp</span>

<span class="s">uname -m = `(uname -m) 2&gt;/dev/null || echo unknown`</span>
<span class="s">uname -r = `(uname -r) 2&gt;/dev/null || echo unknown`</span>
<span class="s">uname -s = `(uname -s) 2&gt;/dev/null || echo unknown`</span>
<span class="s">uname -v = `(uname -v) 2&gt;/dev/null || echo unknown`</span>

<span class="s">/usr/bin/uname -p = `(/usr/bin/uname -p) 2&gt;/dev/null`</span>
<span class="s">/bin/uname -X     = `(/bin/uname -X) 2&gt;/dev/null`</span>

<span class="s">hostinfo               = `(hostinfo) 2&gt;/dev/null`</span>
<span class="s">/bin/universe          = `(/bin/universe) 2&gt;/dev/null`</span>
<span class="s">/usr/bin/arch -k       = `(/usr/bin/arch -k) 2&gt;/dev/null`</span>
<span class="s">/bin/arch              = `(/bin/arch) 2&gt;/dev/null`</span>
<span class="s">/usr/bin/oslevel       = `(/usr/bin/oslevel) 2&gt;/dev/null`</span>
<span class="s">/usr/convex/getsysinfo = `(/usr/convex/getsysinfo) 2&gt;/dev/null`</span>

<span class="s">UNAME_MACHINE = ${UNAME_MACHINE}</span>
<span class="s">UNAME_RELEASE = ${UNAME_RELEASE}</span>
<span class="s">UNAME_SYSTEM  = ${UNAME_SYSTEM}</span>
<span class="s">UNAME_VERSION = ${UNAME_VERSION}</span>
<span class="s">EOF</span>

<span class="nb">exit </span>1

<span class="c"># Local variables:</span>
<span class="c"># eval: (add-hook &#39;write-file-hooks &#39;time-stamp)</span>
<span class="c"># time-stamp-start: &quot;timestamp=&#39;&quot;</span>
<span class="c"># time-stamp-format: &quot;%:y-%02m-%02d&quot;</span>
<span class="c"># time-stamp-end: &quot;&#39;&quot;</span>
<span class="c"># End:</span>
</pre></div>
</code></pre></td></tr></table>
</div> <!-- class=content -->
<div class='footer'>generated  by cgit v0.10.2 at 2015-02-12 08:28:06 (GMT)</div>
</div> <!-- id=cgit -->
</body>
</html>
