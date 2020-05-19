Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5031DA419
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgESVwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:52:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgESVwa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:52:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLpsV8142733;
        Tue, 19 May 2020 21:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=eHXiWMR2T2oaEWcez2mGYdQ8Y0tGtfeDqdd4E/QDW8s=;
 b=irHvFpMLe1yAeIYSs5jSXOf+iFS2dCXC//g75hyYnp8IChxNPzVLxZsoQWNlreFH15FU
 UAqjuI3SkzF03YL0MBZAeCfsA7Tiw6vV/MPnW8BqIH8ASf0c7QxM9Y2fCDnZT/u+aGJH
 rqHE8gtK+FBMc1blF+sL3gzbNaCaPW2gLakIzjm3RpwwBe/EgEFnXkApv9WYkECycKAH
 MVQWRwazXBraEw7YN+ClieOTwpV0u9yTdT9KgOcUksj26eoGsLKNV1SK2ed0q8AC8q3q
 9QjHFYkztTyH3g/rLMwuemaZFdSmFmmuSMbFoh8WSsQxYWgxP8V4XFUaCReXMwU9s1/u JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3128tnfwmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:52:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLh9Mh159915;
        Tue, 19 May 2020 21:52:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 312sxtm1tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:52:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JLqREC030593;
        Tue, 19 May 2020 21:52:27 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:52:27 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 0/3] __io_uring_get_cqe() fix/optimization
Date:   Tue, 19 May 2020 14:52:18 -0700
Message-Id: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=946 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=960 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190184
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch set and a corresponding kernel patch set are fixes and
optimizations resulting from running unit test 500f9fbadef8-test.

- Patch 1 is a fix to the test hanging when it runs on a non-mq queue.

The patch preserves the value of wait_nr if SETUP_IOPOLL is set
since otherwise __sys_io_uring_enter() could never be called
__io_uring_peek_cqe() could never find new completions.

With this patch applied, two problems were hit in the kernel as described
in the kernel patch set, which caused 500f9fbadef8-test to fail and
to hang.  With all three patches, 500f9fbadef8-test either passes
successfully or skips the test gracefully with the following message:

Polling not supported in current dir, test skipped

- Patch 2 is an optimization for io_uring_enter() system calls.

If we want to wait for completions (wait_nr > 0), account for the
completion we might fetch with __io_uring_peek_cqe().  For example,
with wait_nr=1 and submit=0, there is no need to call io_uring_enter()
if the peek call finds a completion.

Below are the perf results for 500f9fbadef8-test without/with the fix:

perf stat -e syscalls:sys_enter_io_uring_enter 500f9fbadef8-test

12,289     syscalls:sys_enter_io_uring_enter
8,193      syscalls:sys_enter_io_uring_enter

- Patch 3 is a cleanup with no functional changes.

Since we always have

io_uring_wait_cqe_nr()
-> __io_uring_get_cqe()
   -> __io_uring_peek_cqe()

remove the direct call from io_uring_wait_cqe_nr() to __io_uring_peek_cqe().

After the removal, __io_uring_peek_cqe() is called only from
__io_uring_get_cqe() so move the two routines together(). Without the
move, compilation fails with a 'defined but not used' error.

Bijan Mottahedeh (3):
  preseve wait_nr if SETUP_IOPOLL is set
  update wait_nr to account for completed event
  remove duplicate call to __io_uring_peek_cqe()

 src/include/liburing.h | 32 --------------------------------
 src/queue.c            | 38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 33 deletions(-)

-- 
1.8.3.1

