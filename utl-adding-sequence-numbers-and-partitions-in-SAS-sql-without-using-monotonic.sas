%let pgm=utl-adding-sequence-numbers-and-partitions-in-SAS-sql-without-using-monotonic;

Adding sequence numbers and partitions in sas proc sql without using monotonic

This should provide ordering in sql and has implcations for ranking and transposing

The ability to sequence sql was first discoverd by Tim Abernathy

Monotomic is not supported, perhaps this is supported?

Related repos on end

github
http://tinyurl.com/3zpmd3zy
https://github.com/rogerjdeangelis/utl-adding-sequence-numbers-and-partitions-in-SAS-sql-without-using-monotonic

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                          |                                                         |                                   */
/*         INPUT            |              PROCESS                                    |            OUTPUT                 */
/*                          |                                                         |                                   */
/* NAME     WEEK      DOSE  |  select                                                 |  REC SUBSEQ NAME  WEEK     DOSE   */
/*                          |      resolve('%let seq=%eval(&seq + 1);')               |                                   */
/* ROGER    BASELINE  10mg  |     ,symget('seq') as rec                               |   1    1    ROGER BASELINE 10mg   */
/* ROGER    WEEK1     11mg  |                                                         |   2    2    ROGER WEEK1    11mg   */
/* ROGER    WEEK2     12mg  |     ,resolve('%let wek=%eval(&wek + 1);')               |   3    3    ROGER WEEK2    12mg   */
/* ROGER    EOT       13mg  |     ,case                                               |   4    4    ROGER EOT      13mg   */
/* JANET    BASELINE  20mg  |       when (WEEK='BASELINE') then resolve('%let wek=1;')|   5    1    JANET BASELINE 20mg   */
/* JANET    WEEK1     21mg  |       else resolve('%let wek=&wek;')                    |   6    2    JANET WEEK1    21mg   */
/* JANET    WEEK2     22mg  |      end                                                |   7    3    JANET WEEK2    22mg   */
/* JANET    EOT       23mg  |     ,symget('wek') as subSeq                            |   8    4    JANET EOT      23mg   */
/*                          |                                                         |                                   */
/*                          |     ,name                                               |                                   */
/*                          |     ,week                                               |                                   */
/*                          |     ,dose                                               |                                   */
/*                          |  from                                                   |                                   */
/*                          |     exposure                                            |                                   */
/*                          |                                                         |                                   */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data exposure;
  input NAME$ WEEK$  DOSE$;
cards4;
ROGER BASELINE 10mg
ROGER WEEK1    11mg
ROGER WEEK2    12mg
ROGER EOT      13mg
JANET BASELINE 20mg
JANET WEEK1    21mg
JANET WEEK2    22mg
JANET EOT      23mg
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  WORK.EXPOSURE total obs=8                                                                                             */
/*                                                                                                                        */
/*  Obs    NAME     WEEK        DOSE                                                                                      */
/*                                                                                                                        */
/*   1     ROGER    BASELINE    10mg                                                                                      */
/*   2     ROGER    WEEK1       11mg                                                                                      */
/*   3     ROGER    WEEK2       12mg                                                                                      */
/*   4     ROGER    EOT         13mg                                                                                      */
/*   5     JANET    BASELINE    20mg                                                                                      */
/*   6     JANET    WEEK1       21mg                                                                                      */
/*   7     JANET    WEEK2       22mg                                                                                      */
/*   8     JANET    EOT         23mg                                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%symdel evn/nowarn;
%let wek=0;
%let seq=0;
proc sql;
  create
      table want(drop=_t:) as
  select
      resolve('%let seq=%eval(&seq + 1);')
     ,symget('seq') as rec

     ,resolve('%let wek=%eval(&wek + 1);')
     ,case
       when (WEEK='BASELINE') then resolve('%let wek=1;')
       else resolve('%let wek=&wek;')
      end
     ,symget('wek') as subSeq

     ,name
     ,week
     ,dose
  from
     exposure
;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/*  WORK.WANT total obs=8                                                                                                 */
/*                                                                                                                        */
/*  Obs    REC    SUBSEQ    NAME     WEEK        DOSE                                                                     */
/*                                                                                                                        */
/*   1      1       1       ROGER    BASELINE    10mg                                                                     */
/*   2      2       2       ROGER    WEEK1       11mg                                                                     */
/*   3      3       3       ROGER    WEEK2       12mg                                                                     */
/*   4      4       4       ROGER    EOT         13mg                                                                     */
/*   5      5       1       JANET    BASELINE    20mg                                                                     */
/*   6      6       2       JANET    WEEK1       21mg                                                                     */
/*   7      7       3       JANET    WEEK2       22mg                                                                     */
/*   8      8       4       JANET    EOT         23mg                                                                     */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*        _       _           _
 _ __ ___| | __ _| |_ ___  __| |  _ __ ___ _ __   ___  ___
| `__/ _ \ |/ _` | __/ _ \/ _` | | `__/ _ \ `_ \ / _ \/ __|
| | |  __/ | (_| | ||  __/ (_| | | | |  __/ |_) | (_) \__ \
|_|  \___|_|\__,_|\__\___|\__,_| |_|  \___| .__/ \___/|___/
                                          |_|
*/

REPO
-----------------------------------------------------------------------------------------------------------------------------------
https://github.com/rogerjdeangelis/utl-create-equally-spaced-values-using-partitioning-in-sql-wps-r-python
https://github.com/rogerjdeangelis/utl-find-first-n-observations-per-category-using-proc-sql-partitioning
https://github.com/rogerjdeangelis/utl-macro-to-enable-sql-partitioning-by-groups-montonic-first-and-last-dot
https://github.com/rogerjdeangelis/utl-pivot-long-pivot-wide-transpose-partitioning-sql-arrays-wps-r-python
https://github.com/rogerjdeangelis/utl-pivot-transpose-by-id-using-wps-r-python-sql-using-partitioning
https://github.com/rogerjdeangelis/utl-top-four-seasonal-precipitation-totals--european-cities-sql-partitions-in-wps-r-python
https://github.com/rogerjdeangelis/utl-transpose-pivot-wide-using-sql-partitioning-in-wps-r-python
https://github.com/rogerjdeangelis/utl-transposing-rows-to-columns-using-proc-sql-partitioning
https://github.com/rogerjdeangelis/utl-transposing-words-into-sentences-using-sql-partitioning-in-r-and-python
https://github.com/rogerjdeangelis/utl-using-sql-in-wps-r-python-select-the-four-youngest-male-and-female-students-partitioning



/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
