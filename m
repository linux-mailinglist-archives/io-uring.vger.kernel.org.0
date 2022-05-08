Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06051EEAD
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbiEHPlu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiEHPlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:41:49 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2096.outbound.protection.outlook.com [40.92.53.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A6921B6
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:37:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIyps+L214Nrx0uGTq117vgzS/u8SqHyyMJoZ7MNG+HJIvH9O12qggCQFVYIn9+pqGpWlhupppSeNejSFGTSfuTWGjpIIcbF45u2Sk4eww+MUTbFsqNOp/I/GaaKJjg53GkjmwXJsmkplsckZMmZxyylEM4f6YMfLrG8withpg0TOVJXQw0wzkrrmto834ienuk+b5a2398cUInHoDASVt5MKKyvcfuj3MMrhwmQC2EpZNS+S+cFTiMx0dMrPxJZLbaxavKYJg/OGKkwG1ElsmH2JDHHkWRS1ARvR69UfoCey1tpVHfBhWqIAZyUG0pJQrz/K0vrwjYFefRYUDAeGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KG7AOEkD7Dd7kAM4qXi3ol9p7mnkcQifJs0wOx2TzU=;
 b=LPGaHQZu4hzTOKMZ4S/uTChl3+NAMTUTGcWoDre2zOyxUws5zRjgrmvKbEgNCbszFdVNkLlkaJnGz8qjoGk3qMA8ejWcfsInseIvL1VAeCW+rCGJdT99MuBRxr2x54Qlr3e/O0Jbkx3GhX2JVJG2JgaV7Fg1h+7r0doRnxGsqThKIUPiJeWnJ9+MxJGd/d3QvDn0ct4x+jhREbzNihMPEkmsAClxbVoGd1go2PgameYviM2C3U7kJLdse2fBumVBhF0SlkN73iocdy/JRIW+rYwyLG2jMV5OmRLO4O2VNXuB5CpxAl4kGUOdUo1MkQ8RZlRTQ63lLASF1L0imQciaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KG7AOEkD7Dd7kAM4qXi3ol9p7mnkcQifJs0wOx2TzU=;
 b=nhp29hVNfA8tWywpzeCpLMbEPNpoJt5fOKc99aIWdf91p3/DJ3r60E8Ywh7Cy8Y7dF0tKummaR6w/nbKPD8nih373npusRL6cVu8OLgbnAg1L9wbYjtGFs7v1HD3PnXSl6TG9NHW1opLttnvYxNWZHjFDJKTONZ+hBN+A9Pbz9EwxdbmRt5dBmWIlUV+LbR1uiuTCrHXkdZFvShMoG/5a96m3QfxR93y35XMK3HXgggAsYXTY5RfWSAmhpGcrLZY2wbok4MZUOWjsr07Rl4txoRC41U5oedWlPPRmeoaDYxS/hkd25Ri/3Z1f1EuELI9UHb/LjrUlBWaZX5G8U7/Qw==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by PSAPR01MB3910.apcprd01.prod.exchangelabs.com
 (2603:1096:301:17::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:37:56 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:37:56 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v5 0/4] fast poll multishot mode
Date:   Sun,  8 May 2022 23:37:43 +0800
Message-ID: <SG2PR01MB241138EDCD004D6C19374E80FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [SITJU3/+bqyZH5yMmP3e1Bm0JBN5N7/d]
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153747.6184-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e585af8-dceb-4fa8-2d8f-08da3108b906
X-MS-TrafficTypeDiagnostic: PSAPR01MB3910:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A0Q+LZaFfeRryqg7Vkrm2jKcHmsAAqZWAjtXJjTU6HGXhop7PsUswxCXfeCnPqNo/MIsZFxyki7Efgus32M3qj3M9hyJ7J2I8XBQ3B15IwwvudvzUV6GmChhX1XFMWJwjrSGpzjtSG3J3N8mwkIfkOZoV88v2jmGaHvkeTw7RSvIVSBFtMjhzqFXPEei9biEpAWciB9ICKSAq/bT76U6NmWPclZyHUgmI73Ua05LnvCeXKuWAh3rHDL9BQ4x+m4H3TCzkQ/HL3KqtZkfIgkerfl+IzRor/fd3lMoXae/DKK7fw/yPoGqQ1e/0RxgGRfHAaqYm1tKfcW0fMOB/h9CSWBwdetvBomd9XBSIG66mGOG0p2p+1+A10KLr7VGfRNZ9ZT5YKZ/y1D+vU6eRWAMKgvPNYxgOB3Z1aJyl/ByRrvmQASRr80ys65DwolrIqBbIpTg5Hsohz6iaLPxAVvkLcLTdKmZDOP6qg4SljSljHgv3u2/sjqs4cklThwD+eEQfoXFH5gsmlq+2KvvC56F+lgCFDJjHBAF7jytSsEHEfA6AHMCO8RWjcH1s4Fr2bWQ4EyicUeALwxouUtdwr1LgJ41ZiGTgk/61CjegK8rppbxi7U7+FEW4bOz/zUfQaIG
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SBYMBSL3v8gN4qnphIbu/BsP7DgnC0hK8mJ2zoDGjlZ0Qg9Em31kETAiWd/B?=
 =?us-ascii?Q?0RDUxIatmvrbzB4kkUHJb0pf0DVgs7mtrBbJH9KQAlziGK//Q3tDtZBhJmHZ?=
 =?us-ascii?Q?a/nA+KDrB9rgO52/+HORFGhQnboyVh3ybUNxRY7c9UcdjVCsOLxvuVjUZJl0?=
 =?us-ascii?Q?VA+mgLfC4gDK5cxM39wZu+K3zmJlCD4434Pn64nFwS1a7mNasUQUCvZuMxhg?=
 =?us-ascii?Q?QrhIjGa/qScNDp4d8mmLp9Py8ICvKvP/LuvJS3LjHGAOWgGxP3yd2wIlHmEi?=
 =?us-ascii?Q?Wo4aDhcN36kwmoH6MDVwcDE88T0rvSIEiKuvs+ifCPRwtl3u1P32V9fdsNPw?=
 =?us-ascii?Q?XGQSUwtNM97SieL++sqky4IfB7xarX4mOQIqCY6y/7dZiOurM7zjK38gt9VZ?=
 =?us-ascii?Q?koPbBkw7oe2C04K4kJGBj9OINePlCu8erQtdww/E8tJ+WurT/S9Jf89EhOVF?=
 =?us-ascii?Q?XavLf/Cig0eOyWq3bWJDwhlw0cvfi5D/AMnN/G8JSQXte7tXvf0t3eH+vGOQ?=
 =?us-ascii?Q?gEvi88RZctgsyTVApsETc3UX/AkiKSq0hO+q9KSYRzeb4v9hTqCw97lqHmlx?=
 =?us-ascii?Q?Hvtwj4RW5Ox9Q5UXQ8Gk+JemUd4PftJZmc23XQ3/3PH2mwuYG2UWUC4ZlGte?=
 =?us-ascii?Q?GGqOIcdMTNbvfPt5zl126RDklaRP4txdG6BCLjTsLfG9se5SW7edH4r7YRbe?=
 =?us-ascii?Q?1zZFIdQq+3FA9tZ8skYb6iAIp4kGCagjf40GSxb/7ihk97Dw3Z88Um0ixoU0?=
 =?us-ascii?Q?Girr+38PSfCJCsddkSXpLlg84WeSQfsyeZakCAclJ+/s1/EOAL9sQkMDjw58?=
 =?us-ascii?Q?M/DyZLp8k8wXgmbxHdCDA42PA6ofPEkoJdMvR3lKGj+KDR3G+UgxOt9t0iU2?=
 =?us-ascii?Q?Gim+lkmid612k33MtJUZ9G4RQsWrrK81A6sTICJhXU58dULb/VCPtSdKEkCZ?=
 =?us-ascii?Q?+0v+QZKhVqyoU8SfJP25wQIhqxGc0irxvK2Qke1V+bz8laQ7CcOMFMKI4JwG?=
 =?us-ascii?Q?jMooDM7dhrKwHoml4l631xdkuOOX64UH35RWdRgcEHdNWx0spnIayL4NfPWq?=
 =?us-ascii?Q?DO0Ewl+ceFdbPUnQWE+SUypY5hJ1ggILR5JObQ6OcMSQI/yVGwlbsyEB0K+K?=
 =?us-ascii?Q?SVicFbhU9mbMnp4WsX2mQr4gTtvPbVScSQbs31Dg6N6vmdVtzUX8tvqpU5k0?=
 =?us-ascii?Q?SoHNABOWelZ/tUFMztlkdsGTtS56j+fc9iFKs/zJzZo/YIMxnF6B123wVeDI?=
 =?us-ascii?Q?0oXXh+30cvVBuWcw52qJrLYaa055dI1yq5OTBYAud+ulq27QnLPLBb/typsg?=
 =?us-ascii?Q?MkBVpsyvq1zTCFrGd9xJ81UA9EBlURh6t+6+kKD2MNwB/Q3d9K5mh+rxU+t1?=
 =?us-ascii?Q?FuZiitQaHPEJTF8deRcvxR7xJYHzpR1SqoCKXj+WgqU0lQlw4uyYPybOhMB/?=
 =?us-ascii?Q?qwewN496XUfsm1TBj3Lx9+q0LKwjlX4TKv6q24WJh37tAwWvLJ/3pA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e585af8-dceb-4fa8-2d8f-08da3108b906
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:37:56.1598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR01MB3910
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,FORGED_GMAIL_RCVD,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Let multishot support multishot mode, currently only add accept as its
first consumer.
theoretical analysis:
  1) when connections come in fast
    - singleshot:
              add accept sqe(userspace) --> accept inline
                              ^                 |
                              |-----------------|
    - multishot:
             add accept sqe(userspace) --> accept inline
                                              ^     |
                                              |--*--|

    we do accept repeatedly in * place until get EAGAIN

  2) when connections come in at a low pressure
    similar thing like 1), we reduce a lot of userspace-kernel context
    switch and useless vfs_poll()


tests:
Did some tests, which goes in this way:

  server    client(multiple)
  accept    connect
  read      write
  write     read
  close     close

Basically, raise up a number of clients(on same machine with server) to
connect to the server, and then write some data to it, the server will
write those data back to the client after it receives them, and then
close the connection after write return. Then the client will read the
data and then close the connection. Here I test 10000 clients connect
one server, data size 128 bytes. And each client has a go routine for
it, so they come to the server in short time.
test 20 times before/after this patchset, time spent:(unit cycle, which
is the return value of clock())
before:
  1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
  +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
  +1934226+1914385)/20.0 = 1927633.75
after:
  1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
  +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
  +1871324+1940803)/20.0 = 1894750.45

(1927633.75 - 1894750.45) / 1927633.75 = 1.65%

v1->v2:
 - re-implement it against the reworked poll code

v2->v3:
 - fold in code tweak and clean from Jens
 - use io_issue_sqe rather than io_queue_sqe, since the former one
   return the internal error back which makes more sense
 - remove io_poll_clean() and its friends since they are not needed

v3->v4:
 - move the accept multishot flag to the proper patch
 - typo correction
 - remove improperly added signed-off-by

v4->v5:
 - address some email account issue..


Hao Xu (4):
  io_uring: add IORING_ACCEPT_MULTISHOT for accept
  io_uring: add REQ_F_APOLL_MULTISHOT for requests
  io_uring: let fast poll support multishot
  io_uring: implement multishot mode for accept

 fs/io_uring.c                 | 94 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  5 ++
 2 files changed, 79 insertions(+), 20 deletions(-)


base-commit: 0a194603ba7ee67b4e39ec0ee5cda70a356ea618
-- 
2.25.1

