fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

#input = "^WNE$"
#input = "^ENWWW(NEEE|SSE(EE|N))$"
#input = "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"
#input = "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"
#input = "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"
input = "^SEESEENENWW(WNW(WWWNENESEEESEEENNWNWS(SEWN|)WWNW(S|NNNWNNEES(W|EENNEESWSESESESSW(NW(S|WN(E|WN(E|WWSSE(N|S|E))))|SSESSEENEESWSSWNWWWN(WSSSSEESESWWSSWSSEEEEENEENWWNEEENENWNNESESSSSENNNESSEESSESSEEEESSEENWNNNNNESSEESSW(NWSNES|)SESENENNNW(NWNW(S|NWWWWNNESENESEEEESEESSW(WN(WNWESE|)E|SEEESSESSEESWSWWWSESWSWWWNENE(NNEE(NNWNWW(NEEWWS|)SES(WSW(WSS(ENEWSW|)WSWWNENWWSWSWWNENWNNE(SE(EEE(ESNW|)N|S)|NWWSWNWNNWNNWSWSSSSWSSSWNNNWWSWSWSWNWNENNWWS(E|WSESSSE(EEENENE(SSSW(SEESEEESWWSESWWSWNWWSESWSESENESEESWWSSENESSENESEESSWSSWSESESESENNENNNWSSW(WNNE(NNNNESENEESWSS(WWNEWSEE|)SSSSSWSSWWWNWNWWSWSWWSSENESSSSWWWNEN(ESNW|)WWNNWWSWWWNWNNEENEESENNESEES(ENENNWNNWNWSSESW(SEEWWN|)WNNNWWNWSWSSWNWSSWNNWWWSSWSEESWSSSESWWSEESWSSEEN(EENWNW(S|NNNE(SSESESSEENWNEEE(SWSESSEN(NN|EEEES(WWW|EENWNNESESSENNNESSES(EEENNESENEENNNNWNWNNWSSSWNW(NENNEENESSSENNNESSEENWNEEEENNNNWWWNNWNENWWNNENNWNWWSES(SSWSSE(SWWNW(SSEEESEN(NN|ESSWSWNWWN(E|WSW(N|SSSENNEES(EEENESEENWN(E|W)|W))))|NWWS(WWNNE(S|NENNNWSWNNWNNEEESS(WNWESE|)ESSEE(SS(ENSW|)WS(ESNW|)W(NNEWSS|)W|NNW(NNNN(ESSSEES(W|ENNN(EEESESWWNWSSSESEEESEEEESSEESEENWNWWNEENNWWWNWNWSSES(EEE|WWNNW(SWWN(W|E)|NNE(NWWNEENEN(WWSNEE|)NEEEENESSSEEEEE(NWWWWNEEENWWWNEEENWNNESE(NNWNENNWSWNNNEE(SWEN|)NWNENWWNWWSESS(ENSW|)WSESWWSESE(SS(ENSW|)WSESWS(WWS(E|WNNNENWNNE(NWWWSESWWSEESWSWNW(SSEEE(SS(WNSE|)E|N)|NNW(SS|WWNEEEENNWNENENENWWWWSE(E|SWSSS(WNNNNWNWNNEES(W|S|ENESEEEENENNNESSEES(WWSWSES(SWNW(N|SWSWSEENE(E|S))|E)|ENNNNNNNWSSWNNWNWNWNNEES(SEENNNESSSES(SSSSE(SSW(SSSENN|N)|NNNNNNWNENWNWWNEEE(S|NNWWS(E|WWSWSES(WWWNENNWWWNWNNNENENEENESSSENEEENE(NWWWNENENWNWWNNEENENNE(SSSSS(SSSWENNN|)WN(WW|N)|NWWNEENWWWWWNENNESENENWNWSWNWSWWSWSESWSSENE(NNNESNWSSS|)SESEE(NWES|)SS(ENSW|)SWNNWWSWWWSWSSWNNNWNEE(NE(NNWWS(E|SWNNWWSWSSWSWWWSESESWWNWNNNENNESSENNNWNENEES(EENNW(S|NWSWWNENNENNESSEESS(WNWWEESE|)ESWSSEEENNNNW(SSSWENNN|)WNENNNNWNNNENESENNNWSWWNN(E(S|EEESSSEESSWSWSSWW(NENN(WWSE|ENE)|SEESSS(ENEEEEESE(SSSSW(N|WW)|NNWNNNNNNE(SSSSS|NNWWNN(ESENSWNW|)WSWNWSS(WNNSSE|)ESSSENE(SSSWNWSW(N|WSESS(WNSE|)EEENNWWSE(WNEESSNNWWSE|))|N(WNSE|)E)))|W(NWNEWSES|)S)))|WWSWWSWSEENESE(NN|SSSSSW(WWWSWNWNNWWSESWWNNNWWWSWNWSSESEEN(W|NESSSESEEE(NWWEES|)E(SWS(SSWS(E|WWWSSSSE(NNNEESWSS(NNENWWEESWSS|)|SSWWSWNWWWNENEES(E(E|NNWWNWNWSWSWWSESWWWNENNWNWSWWWWSWNNNWWNENNENESENNNWSWNNNWSWSSE(SWWWWWWWSESWWSESSWWSSESESWSSWSWSSWWNENNENWNEE(S|NWNWNNNNWWWSEESSSS(WNWNWSSWSEE(N|EESSWNWWWWNNNENWWWWNNWWNENWWNENWWNEENWNENEESESESWWW(N(N|E)|SES(W|EEEN(ESENESENNWNWWNW(SSEEWWNN|)WNNNWS(S|WNWNWNENEEENWWN(WWS(SWSWWNWNWN(WSWNWWWSWNWWSWSSWNNN(E|WWSSWNWWSESWWWWWWSESSEEEEESWSWNWSWSSEEN(ESESESEEESSENENNNWWWW(SEEESNWWWN|)NNNNW(NWWN(EEEE(N(WW|NN)|ESSSW(NNWESS|)SSEEENW(NNENWNENNE(N|ESENESESSEESWWSWWSWW(SESWSSSSENEENWWNEENENEENN(ESENEE(ENN(ESEWNW|)NWSSWWNENWNWS(WNW(S|N(WNWESE|)EE)|SS)|SWS(SWSWSWNW(NEENEWSWWS|)SSW(NN|SSWNWSSEESSSSSSWSESSWNWWNENWWWNNWWSSSE(NN|ESSWSWWNN(E(S|E)|NNNWNWNENENNWNNWWN(EEESSESESEEE(NNWSWN(N|W)|ESSSWW(SEEENNNN(SSSSWWEENNNN|)|NENWWSWW(WSNE|)N(N|E)))|WSWWSWNWSSSWSEESSWSESWWSSSSESSESEEEENNWSWNW(S|WNNNN(WSSNNE|)ENNNNNESSEE(SWWSEESEE(NWNSES|)SSSW(WNENWWSSWWNEN(NEWS|)W|SESSSW(SSWSEENNEEEEESEESSWNWSSEEESSSWNWWWWWNENWWN(WSWNWWNWSSEESSSWSESWWSWWWSSWWWNEENNWSWWSSWSEESESSSWWNN(ESNW|)WSSSWNNNWWSESSWSEESENEEN(ESESWWWSESSSENNESEEEESESSWNWWSESESWWWSEEESENNNESSSSWWSSWWWSSEESESEEENNWSWNN(NNESES(W|EESSW(N|SESSWNWSWWSWSEEEN(W|ESSENESENEESEEEEESEENNENWWS(WNWNNNWSSSWW(SEEEWWWN|)WWNENNNNNNWNENENNNWNNNESEENNW(S|NWWWNNWSWWNWNNNESSE(S|NESEEENNENNEESSSW(WSSWWSEEESENESSENNESSESWWWSW(NN|SSESSSESEENWNENWW(S|NENW(W|NEEESS(WNSE|)SSENEENNNNESESWSEESSSESSESWWWWNNE(SENSWN|)NWWN(ENESNWSW|)WSWSW(SWWSSEESWSESENNESSSWSW(NWNWSWWNNNNWSWWSSSWNNNNEENENN(ESES(SSESWS|W)|WNW(NEN(ESSNNW|)WNN(ESNW|)W|SS(SWNNSSEN|)E))|SESSSSWNNW(NEWS|)SWWWWWSSEEESSWNWWWNWSWSWSESSEESSSWWSWNNEN(ESNW|)WNWSWNNNNE(SSEWNN|)NENWNENWN(E(N|ESS(S|EENWNEEE(WWWSESNWNEEE|)))|WWSSE(N|SSWNWWNWNEN(ESSNNW|)WN(E|WWWNWWWSESWSSWNNNNWSSSSWSSWWNWWNEEE(NWNEE(NNWSWNNEEENEENNEE(NWWWWNNWSSWWWNWSWWSSEESWWSEESSSE(NNNNENWN(EESE(SWEN|)EN(ESNW|)W|WW)|SWWWSWSWWW(SESWSEESESSEESWSSEEESENNNNNNWSSSW(NNWWNNNEN(N(N|WSWS(WNSE|)S)|ESE(N|S(WSWNSENE|)ENEESWSSEEN(W|NENNW(S|NEESSSEEEEEESSWWSEEESWWWWWSSWWWSEESWSEENEEEEESWSWWW(NEEWWS|)WSWSWNN(WNNWWNENNNWSW(NNEEESSENE(NEENWWW(S|WNEEEEEE(WWWWWWSNEEEEEE|))|S)|S(SSSWNWWSWNN(E|WSWWWSESENESSEEESSWNWSSWSWWNWW(SSE(N|ESENESENNESSSES(WWNWWS(WNWW(NE|SE)|E)|EEEEEENNEENENNWWN(WWNWN(NW(NEWS|)WW(SESWSSW(SESS(WNSE|)EENESE(SWWWWEEEEN|)NNWN(EESSENE(WSWNNWESSENE|)|WW(S(S|E)|NE(E|NN)))|W)|W(WW|N))|E)|EEN(NESSESSENEEESSWSSWS(EENEES(W|EEEEENWNENNWSWSWS(WNNWSW(NNEEE(S|ENNWNENWWNWSWWWW(NEEENNWNW(SSEWNN|)WNWN(WSWS(EE|W(NNEWSS|)W)|EENNE(SSENESSW(SEEESWS(WNSE|)ESENESENNNWSWNNEENNNNNWNW(NEESE(SSSSENNNNESSENESSESSSESESSSENEEESSWNWSSWSWWSSSENNEEESSENNESSEEESESEEEES(WWWWWWN(WSWWWWNEEN(WWW(NENWESWS|)WSS(ENSW|)WWWWNWWNENWW(SSSEEWWNNN|)NNNESSENEENNE(NWWSW(SEWN|)WWWN(WSSSEN|EEENWNEENWWNW(SSS|NNESESEE(NNNWS(WNNEWSSE|)S|ESESWW(N|S(EESSENE(WSWNNWESSENE|)|W)))))|SSSSSW(SEENSWWN|)NW(NEWS|)S)|E(S|EE))|E)|EEE(NWWNWWWNW(S|WNWWWNENWNNW(NEEESS(WNSE|)ENEESESWW(S(WNWSNESE|)ES(W|ESENEE(S(ESWENW|)W|NNENWWW(NNENWNEE(SSESWW|NNWWNEENNENWWSWWS(EE|SSWWSWSS(SENESE(NNW(NEEEWWWS|)W|S)|WWWNNWS(S|WNNENWNNWSWNWWNENWWNENENENNESSESEEEEEEENENWWWNNWNWWNWNNEEENWNNNESEEEENWWWNWW(NNNNNNWNENESSESENENNESSENNESENNESSEESE(SSWSESSSSE(NNNNE(EEEESE(SWSNEN|)NEEN(NNE(SESWSS(ENSW|)WW|N)|WW)|S)|ESSWWSWWSESESESWSWNWN(E|WSWNWNNNESE(NNWWNENNEENWNWNENNN(WWSESWSWNNWWSSWSS(SEEENWWNE(EES(SSWSSWSWSSENE(N|SSSSE(ESWW(WNWW(SEWN|)NWNE(EESWENWW|)NNW(SWSWNW|NN(W|E(E|S)))|SSEEN(EEN(WNEWSE|)EESSSENEENNWN(WSSEWNNE|)EEEE(SSSSESSWWSS(WNWWSES(E|SWWN(NWSWW(NNNEN(ESE(SWWSNEEN|)NESENE(N(WW|E(SEWN|)NWNENW)|S)|NWSWN(NEENSWWS|)WSS(WNNWSSWWN(ENSW|)WWSSE(N|E(EE|SWWSWNWSSEE(EENWESWW|)SWSSWNNWNNNNNESENNWWWSWWS(EESSNNWW|)WNN(NESEWNWS|)W))|E))|S(EE|W(N|SS)))|E))|ENEESWSEEN(NNNWSNESSS|)EES(W|ES(W|SSE(SSEWNN|)NNNE(E|SS))))|NNWWNNEN(WWWSESW(WN(W|N)|SSE(N|EE))|ESE(S(ESWSEEENWN(SESWWWEEENWN|)|WW)|N)))|W))|N))|E)|NN)|WNNW(N(EE|N)|SS))|ES(SSSESSSS(EE|SWNWNE)|E))|S(W|E))))|NENN(E|WNN(N|WSSW(SEEWWN|)NWWWNE(NWWNWWWSESWWNWWNNNWWSESSSWNWN(E|WSWWNNNNNNWNENNESEENNW(S|NNNENEENNESENEEENNWNWSWS(WWNNWNNNWNNNEEEEEENNEN(EEENESESSEENNEENENENENNWNWSS(SWSWWS(E|W(NNW(S(S|W(W|N))|NNEENEE(NWNENEEN(ESSS(WNWSNESE|)SEEN(ESENEN(E(SSWSEESSWSSENEENWNNEEE(NNENEWSWSS|)SW(SSSSWSESENESSWSSENEEESSWW(NEWS|)WWWSEEESENESSESENESEESWSWSWSESEESSESSWWWWWSSSEENWNEEEEENEENEESEENNNWNNWNEEENN(NWNWSWWWWSEES(SWNWSWSW(NW(SWNSEN|)NENNE(NNENENNWWWNNESENNWNWNWWN(EEESEEEEEN(ESSENNENNEEEE(N(WWW|N)|SSWSWNN(WSSSSW(WWWWN(WSW(NWES|)SSESSENESSE(SWWW(NEWS|)WS(W|EE)|NNNN(EE(SWSNEN|)EENNEES(W|E(SSEEWWNN|)NN(ESNW|)W)|WW(SEWN|)W))|E)|NN)|E))|NNWWNN(WSSW(NWES|)SSENESEN(SWNWSWENESEN|)|NNE(SSSEWNNN|)N))|WSSSESWSSENE(NN(NWES|)E|SSWSWNWW(NNNNNWWSS(ENSW|)WNNNWNNN(WSSSNNNE|)NESE(N|SENESE(NE(NW|SE)|SWWW(WNSE|)SEEESSSSS(NNNNNWESSSSS|)))|SES(EESENE(N(EN(W|E)|W)|S)|W))))|SS)|SEENESSEN(N|ESS(ESNW|)WWWSWNN(W|E)))|EEENWW)|EE(E|SWSSWS(WNSE|)EE(SWWSEEESWSSSWWSEESWWS(SEEN(ENNNENN(WSNE|)(ESSESSENN(SSWNNWESSENN|)|N)|W)|WNWWNNN(EE(SSWNSENN|)EENNWS|W(N|WWSSESS(E(NNNWESSS|)EE|WNWNWSSESWSSSWNWNNWSSSS(WNNWWSS(ENSW|)WSSSWSESSS(WNNWNNNWW(SEWN|)NWNW(WNEEEEEE(SS(WWN(E|W)|S)|NNE(NEEE(SWWEEN|)NWN(WWS(WSWNNWNNNWWWSEESWSESESWWSEEESWWWWWNNNNN(ESS(SS|E)|NNNNWNNWWNEENNWSWWSSSESSWSESSEE(SWSW(NWNWWNW(NENNWNWS(SEWN|)WNNNNWWS(E|WWS(WNWSWNWSWSESWWSEESSS(ENNSSW|)WSWWWWWS(WNNNW(SWNWWSSSSS(EENWNN(ESENSWNW|)N|S)|NEEEENWWNENENWNW(NEENESEE(SWSSW(NNWESS|)S(SSES(ENSW|)WS(E|WNWWSE)|W)|N(ENWNENENWNENNNNESSSSEENWNNESENENN(WWW(SEEWWN|)WNNWWWSEESWSWNW(SSEESWS(E|SS(WNNNWSWNWWNEN(ESENSWNW|)WWWSESSSES(EN(NWES|)EE|S)|S))|N)|NEEEENWW(WW|NEEN(ESSEENEE(NNNN(E|WNWWWSESWS(EEE(SWWS|NWN)|W))|EEE(NEWS|)SSSWNNWWWSSSSSESWWSWNNWWSWNNEEEE(S|NWWN(NEESWENWWS|)WWS(WNWSSESSSWSSEEEEN(N(N|WSW(W|N))|ESSSWSSE(NEENWNENENN(WSWSNENE|)ENESEE(NWNWNW(S|N(EEEE(NWNSES|)SW(S|W)|W(NNESNWSS|)S))|ESSWWSWW(NNE(EE|S)|S(WNSE|)ESEEN(EN(W|ESEEEEE(EN(E|WWNWWN(E|WNWSSESEE(WWNWNNSSESEE|)))|SSWSSSWWSEE(SWWSSW(SE(EENNWS|S)|NNWWWNEENWWW(NEENN(EESS(WNSE|)(SS|ENNN(WWW|E(SSS|E)))|WWWS(EE|SS))|SS))|EEEE(NNWWNWSSEE(WWNNESNWSSEE|)|E))))|W)))|SSS(WNNWW(SEWN|)NENNN(E|WSWS(WNWSWNNWNWW(NEEEE(S(SEEWWN|)W|NWNENES(NWSWSEWNENES|))|SSE(N|SS(E(NN|E)|WNW(SWEN|)NN)))|E))|S(SSSEWNNN|)E)))|E)))|W)))|W))|WSESWSW(SEWN|)NN(WSNE|)N))|ESEES(WSWNSENE|)E(NNWWEESS|)EE)|S))|SS(W|EES(WWSNEE|)E))|SESSS(ENNNNSSSSW|)WN(WSSWWS(WNWN(WSNE|)E|SENEE(N|SSW(WWSSSWW(NENWESWS|)W|N)))|N))|NWNENWNN(SSESWSNENWNN|)))|E)|EEES(E(SS|NNWNEEE(WWWSESNWNEEE|))|W))|SS))|S)|EENWNNES(NWSSESNWNNES|))|E(ES(W|EEN(W|NE(NWNENSWSES|)ESWSES(W|E(S|NN))))|N))))))|NN)))|W)|E)|WW)|W)|WWWWS(SSW(NN(W(S|W)|NNEEEENNN(ESNW|)WSSWNW(NE|SW))|S)|E))|SSW(SWNWESEN|)N))|SS))|E)|WWWWSS(EENWESWW|)WNNNWSWWSWSWSEE(NEENWESWWS|)SWSSE(SWWSWSWWSSSSWSESWWSESENENENWNNNESSEES(WSSWSES(ENNNSSSW|)WW(SS(ENSW|)SSWWWWNEEENNWSWWNNN(ES(S|EE)|NWWWWNENEES(W|ENNNE(SS|NE(NWNENEENNWWWWWSSSW(SEE(NNEN(W|EE)|SWWSESWWWWWWN(WSSESEE(N(E|W)|SSSENEESE(N|SWW(S(EESSSEEESSS(WWNENWWSWWSEE(WWNEENSWWSEE|)|SSEEE(NWWNENWNEE(NWWEES|)SS|S(EEESE(SENEEE(NWES|)S(ENES(SSWNSENN|)ENEN(N|ESS(E|W))|WWSW(W|SSSESS))|N)|WWSEESSSWNN(SSENNNSSSWNN|))))|WWN(WWNWNN(NWSWSWSWNWSWNN(WSWNWSSESSWSWW(NNN(W|ES(S|E))|SSENESSEENNEESWSEE(SWSSS(WNNWSWWNN(E(S|EE)|W(S(S|WW)|N))|SESWSEESSENENWNWNN(EES(W|SEN(E(SSWSESWSW(SWSWW(NEN(WNNSSE|)E|SEEES(WW|SE(SE(SWW(SEESWSW(N|S(W|E))|N)|N)|NNN(W|EN(ENWESW|)W))))|N)|EE)|N))|WN(N|E)))|NNNESEENEEE(NWWNWSW(WWWN(WSS(W(WSSNNE|)NNN|E)|EEENEN)|S)|ESWSSWNNWSW(ENESSEWNNWSW|))))|NEENNNESES(ENNWNNWSWN(SENESSNNWSWN|)|SW(SWWEEN|)N))|EES(S|W))|E))|N)))|EE))|NNNW(SS|NWWNNWWWWS(WNNNEEENESEEEN(WNW(WNNSSE|)S|EENNNNNEESESEESSEENENWNNESESSE(EENWWNE(EESSSENEE(SWEN|)N(WNWSNESE|)E|NWNNWN(EESSNNWW|)WNWN(E|WSSESES(ESNW|)WWSS(SS|WWNENWNE(E|NNWWNWNWN(WSSSSESWSEEE(S|NN(E|W(NWNSES|)S))|NEES(W|SENE(S(SW|EN)|NWN(E|N|W))))))))|SWWSWSWNWWSESESWSS(ES(ENNWESSW|)S|WNWNENWNWNENWW(NE(EES|NWN)|SSSWW(NEWS|)SS(ENEE(SWS(EE|WW)|N)|WWNN(ESNW|)WWWWW)))))|EEE)))|S))))|N)|ENNNNWN(WS(SESWENWN|)WW|EE(SESWSESW(ENWNENSWSESW|)|N(WW|N))))|N))|EE)))|EE))))|WWSSE(SWWS(EE|SWWW(NEENWWNNEEN(ESSWWEENNW|)WWNNW(NEWS|)WS(SENSWN|)WW|SSW(NN|SES(ENEE(ESW(W|SSEES(W|EE(NWN(NWSWENES|)E|EE)))|NNWSWN)|WSS(ENSW|)SWNWSS(WNW(SSEESSESSES(W|SEN(N|EESSSWWNEN(SWSEENSWWNEN|)))|NENWWWW(EEEESWENWWWW|))|E)))))|N))))))|SS(ENSW|)W)))|N)|SWWS(W|EE)))|EEEENESENEEESWW(EENWWWEEESWW|)))|N)|S)|WW)|NNWSWNNNWWWNWWNW(SSEEWWNN|)NNEN(N|EESWS(SEE(N(W|NN)|ES(W|EESSEN))|W))))|SW(WNEWSE|)SEEEN(EEESS(WWNEWSEE|)E|W)))|W)|E))|WNWWS(E|WWWNEENEEN(WNNSSE|)EE(SW|NE)))|W))))|NNNN(NNNEEENNNWNWW(NNESEWNWSS|)SESS(WN|EN)|ESSENESS(ENSW|)(WW|S))))|E))|E)))))|S(W|E))|NNNESSENENNW(WNNNNNESE(SSS(WNNSSE|)EESSWN|NNNNESENEENWWNNNESEEENWWNWNWNWWWWW(SEEESE(N|E|SSWWWW(SSSSENNE(SSSWWSSSSSS(NNNNNNEWSSSSSS|)|EN(ESNW|)WW)|NEN(ESEWNW|)W))|NNESENNEENWWWW(SEWN|)NNESEENNW(S|WNNW(NNESEESS(WNSE|)ENE(N(WNENWWNWS(SEWN|)WNNENNNWW(SESWSSS(NNNENWESWSSS|)|NEENEEENWNENEENWWWWWWNENWNNW(SSSSSSSE(SWEN|)EENN(WSWNSENE|)E|NNEES(ENENWWWNENWW(SS|NENWNENNEESESSSW(SEES(SEESESENNWNENESESEN(NNW(S|NENNNENN(E|WWNWNWNNWSWSSWSWNNNWNNWSWNNNWSW(NNNESEENWNENWWW(SEWN|)NENWNNENNNW(SS|NEESSSEENWNNEES(W|EEESEESWSSSWWNNN(ESSNNW|)WSSWWWW(W|NEEENNEE(WWSSWWEENNEE|)|SES(W|ENESE(ESEEESSENEESWSESEES(ENN(WWNNNN(WSWNNWS(W(NNEE(ESNW|)NNNW(SSWENN|)NWN(EESESENN(W|ESSEENWNEEEE(WWWWSEWNEEEE|))|W(WWW|S))|WW)|S)|E)|EES(WSNE|)E)|WWSSSWW(SESNWN|)NNW(WNNESEE(SS|NWNWWNNWWWWN(WSSSEEN(W|EESWSSS(ENNSSW|)WW(NN(WWSE|ES)|SE(SS|E)))|E))|SS))|N)))))|SSE(SWSSSEENN(WSNE|)E(NWES|)SE(N|SWS(WWWSSNNEEE|)ESENESENNEE(NWNSES|)ESSE(NEWS|)SSWWSWS(EENSWW|)SWSWNNNNE(N(WWSSSNNNEE|)E(NNESSE|S)|SS))|N))))|ESSSWNWSW(NN|SWSWSESW(WWWWNEEENN(NWW(NEWS|)SESWWW(N(WS|EN)|SS)|E)|SSSWSW(N|SSWSSWSEEEE(SWS(EEE|WNWW(SEWN|)WNNNNES(NWSSSSNNNNES|))|NWWNEENN(WSNE|)EES(WSSNNE|)ENEEENWNWNWNEEES(SENNE(NWWNNN(EN(WNSE|)ESS(WSEWNE|)ENNEESWS(NENWWSNEESWS|)|WSWNWSWSS(EEN(ESNW|)W|SSW(SS(W|EE(NWES|)E)|N)))|SSE(ENWESW|)SSWSW(NNEWSS|)W)|W))))))|WW)|WNN(ESNW|)N))|W)))|E)|SSESWS(WNNSSE|)SSEESSS(ES(W|SENENWNEN(NNNWWS(SE(SWSNEN|)N|WN(WSNE|)N(N|EE))|EESSSSW(NNN|SESEN(NNNNE(SEWN|)NWNEEE|EESS(ENNSSW|)W(N|WSSW(SEWN|)NNWSWN(WSW(SESW|NWW)|N(E|NN)))))))|WNNWWS(WNSE|)E))|SS))))|S)))|ESS(ENEEWWSW|)SWNNWSSWW(EENNESNWSSWW|))|S)|S)))))|N))))|NN)))|S))))|W(WW|S))|W)|NEES(W|E(NNWWW|SSEEE)))|NN))|NNEN(NNWWSW(WWSEEE(ENSW|)SS|N)|E)))))))|E))|WSWWSWS(NENEENSWWSWS|))|N(W|NE(NEN(ESSWENNW|)WW(N|S)|S))))|W))|WWS(WNSE|)E)|SSWSES)|W))|EESE(NESNWS|)S)|E)|EEESSSENEESWSSSESW(WWNENWN(E|WNWWSE)|SEESESEEEE(NENNEENWNNWWWSES(ENSW|)WSESWSWNW(S|NNWNW(SSESNWNN|)WNEEESE(SS|NNEENNN(EESSENNEEESESWWSSWW(N(WWNN|ENNE)|SESSEE(SSSWNWN(WSW(S(W|EE)|N)|E)|ENNW(WSEWNE|)NEEN(WW|NENEN(WW(S|W)|ESEESENESEESSWNWSSESESEENWN(W|NNNENN(WWW(SEEWWN|)WWWW|ESSEESEEENNEN(EESSESSE(ESW(SEES(ENNN(WS|ESSS)|WW)|WWWNW(WWWWWNWWSES(W|SSSSWWWWWSSSENNESSSSWNWWNNWSSW(NNNNNWNW(S|NWN(WSNE|)ENENW(WSNE|)NEESEESSSSW(SE(SSWNSENN|)EE(NWNSES|)EEE|NNNWSS(WNSE|)S))|WSESE(EE(NWWEES|)EES(W|E(SWEN|)NNNNNESENEESWSWSS(W(NN|S)|ENESSESENNNEEENNWN(EESSNNWW|)WSWS(W(SS|W|NNNE(NWWSW(NN|WWW)|S|E))|EE)))|SWWNW(NWNEWSES|)S)))|NE(ESNW|)N(N|W)))|NNNN(WSNE|)E(EE|S))|WWSW(SE|NWSWN))))))))|WWWWSES(EENWESWW|)WW(SEEWWN|)NNWSWWNE(WSEENEWSWWNE|))))|SWS(E|SW(SS(E(E|N)|SS)|WW(WWWWSESS(EESNWW|)WWWNNE(SEWN|)NWWWSESS(NNWNEEWWSESS|)|NNESEN)))))))|WW))))|E))|N))|W)))|E)|E))|SSENE(N|S))|E)))|SW(N|SS)))|ES(ENEWSW|)W)|S))|SSSWNWWSES(EE|WWWN(E|WSS(E(S|EE)|WNNW(NEENW|WSES)))))|SS))))|WWW)|W)))|E))))|ES(SSSWENNN|)(W|E)))|E)|N)|SSSS)|SSWNWSSSSESWSESSSWSSENE(SSSSWNWSWSSSENEE(NWWEES|)SSSWN(WSSEESWWSESE(N|SSWWSWNWWSESESES(ENN(NESSSNNNWS|)W|WWWWNE(E|NWNWNWNWSWNWNNENNNW(NENWNNNNNESSEENWNEESENEN(WWWWWNE(NWWSSWSSWNNW(NNW(W|NEN(ESSSENNEEE(WWWSSWENNEEE|)|W))|SS)|EE)|EE(S(WS(SSWN(N|WSW(SWNWS(WNSE|)SESEEN(W|ESSESSSWWWS(WNW(SWEN|)NNN(ESSEEN(NWS|ES)|N)|EEES(EN(ESEWNW|)NNNNNWNNWW(EESSESNWNNWW|)|WW(S|W))))|N))|E)|EE)|NNNENWW(S|NENNW(S|WNENE(NNWWWSWWS(SEE(SWEN|)N(ENEWSW|)W|WWNNE(ENE(N(ES|WWS)|S)|S))|S)))))|WWWSEEESWSSSSWSSESWWWNWSS(WN(WWS(WW|E)|NNENNNENN(WWS(E|SSS|W)|EESSSW(SW(SESNWN|)N|NN)))|EEEEEENNW(S|N(W|N|EESE(ESSWNWS(NESENNSSWNWS|)|N))))))))|N)|NNNNNNNWNE(WSESSSNNNWNE|)))|S)))|WSWNNEN(SWSSENSWNNEN|)))|W(N|S(WNWSWNWNWNNWWNN(W(NENWNSESWS|)SSW(SSSS(WNNWSNESSE|)EESSSWSEEE(NWNENN(E|W(S|N(E|WNN(WSS|ES))))|SE(SWWNWSSSENEE(ENEWSW|)SSW(S(SWNNWW(SEWN|)NNNWW(SE|WW|NEE)|E)|N)|N))|N)|ESEESS)|SS)))|S)))|E))|N)|E)|SWSESES(WSSWNNW(S|N(E|WNN(ESNW|)WWNW(N|WSSSEN(EESWSNENWW|)N)))|EENN(ESSNNW|)(W(S|W)|N)))|W)))|N)|NW(WSNE|)NEEN(E(EN(EE(SWEN|)NWNEESS(NNWWSEWNEESS|)|W)|S)|WWNWNE)))|W)|WWS(ESSNNW|)WWW(N|W(SEWN|)W))|S)|S)|N)|N)|N)))|N)|E)|E)|S)))|SS)|N))))|S)|S)$"

NSEW = [{name: 'N', x: 0, y: -1, opposite: 'S'}, {name: 'S', x: 0, y: 1, opposite: 'N'}, {name: 'E', x: 1, y: 0, opposite: 'W'}, {name: 'W', x: -1, y: 0, opposite: 'E'}]

parseRegex = (directions, index = 1) ->
  parenthesesArray = []
  steps = []
  while true
    switch directions.charAt(index)
      when '('
        [subSteps, index] = parseRegex(directions, index + 1)
        steps.push(subSteps)
      when '|'
        parenthesesArray.push steps
        steps = []
        index++
      when ')'
        parenthesesArray.push steps
        return [parenthesesArray, index + 1]
      when '$'
        return steps
      else
        steps.push directions.charAt(index)
        index++

directions = parseRegex(input)

id = 0
createNode = -> {id: ++id, N: undefined, W: undefined, E: undefined, S: undefined}

origin = createNode()

processDirections = (directions, fromRoom) ->
  currentRoom = fromRoom
  for direction in directions
    if Array.isArray(direction)
      for subDirections in direction
        processDirections(subDirections, currentRoom)
    else
      currentRoom[direction] ?= createNode()
      currentRoom[direction][_.find(NSEW, {name: direction}).opposite] = currentRoom
      currentRoom = currentRoom[direction]

processDirections(directions, origin)

#console.log JSON.stringify(origin, null, '  ')

createMap = (origin) ->
  getBoundingBox = (origin) ->
    minX = Number.MAX_VALUE
    minY = Number.MAX_VALUE
    maxX = Number.MIN_SAFE_INTEGER
    maxY = Number.MIN_SAFE_INTEGER

    traverse = (location, x, y, from) ->
      location.x = x
      location.y = y
      minX = Math.min(minX, x)
      minY = Math.min(minY, y)
      maxX = Math.max(maxX, x)
      maxY = Math.max(maxY, y)

      for d in NSEW
        traverse(location[d.name], x + d.x, y + d.y, location) if location[d.name]? and location[d.name] != from

    traverse(origin, 0, 0)

    return [minX, minY, maxX, maxY]

  [minX, minY, maxX, maxY] = getBoundingBox(origin)
  width = Math.abs(minX) + maxX + 1
  height = Math.abs(minY) + maxY + 1

  map = []
  for y in [0...(height * 2) + 1]
    row = []
    map.push row
    for x in [0...(width * 2) + 1]
      row.push if x % 2 == 0 or y % 2 == 0 or x == 0 or x == width * 2 or y == 0 or y == height * 2 then '#' else '.'

  _x = (x)-> ((x + Math.abs(minX)) * 2) + 1
  _y = (y)-> ((y + Math.abs(minY)) * 2) + 1

  traverse = (location, from) ->
    map[_y(location.y)][_x(location.x)] = "#{location.distance}" if location.distance?
    if from?
      map[_y(from.y)][_x(from.x) + (location.x - from.x)] = '|' if location.x - from.x != 0
      map[_y(from.y) + (location.y - from.y)][_x(from.x)] = '-' if location.y - from.y != 0

    for d in NSEW
      traverse(location[d.name], location) if location[d.name]? and location[d.name] != from

  traverse(origin)
  map[_y(origin.y)][_x(origin.x)] = 'X'

  return map

aoc.print2DArray(createMap(origin), '')

computeDistance = (location, distance) ->
  return if location.distance <= distance
  location.distance = distance
  for d in NSEW
    computeDistance(location[d.name], distance + 1) if location[d.name]?

computeDistance(origin, 0)

#aoc.print2DArray(createMap(origin), '')

findMaxDistance = (location) ->
  max = 0
  traverse = (location, from) ->
    max = Math.max(max, location.distance)
    for d in NSEW
      traverse(location[d.name], location) if location[d.name]? and location[d.name] != from

  traverse(location)
  return max

countDistanceAbove = (location, distance) ->
  count = 0
  traverse = (location, from) ->
    count++ if location.distance >= distance
    for d in NSEW
      traverse(location[d.name], location) if location[d.name]? and location[d.name] != from

  traverse(location)
  return count

console.log "A: " + findMaxDistance( origin )
console.log "B: " + countDistanceAbove( origin, 1000 )