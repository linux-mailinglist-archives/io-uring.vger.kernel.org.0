Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC982218FF2
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 20:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGHStY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 14:49:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37344 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgGHStX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 14:49:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068IaqlI102786;
        Wed, 8 Jul 2020 18:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=f16GOGKsc9NRiItIq+nSVW6pbFW72HperJdkFPlL8B0=;
 b=XK9VsAzwSD913ZwtbsqMykwkXGvGB4z7psu8Zqc3yyUZfSIuhIeaJDm6DPleE9kmyjO6
 J7Qye+rn0acoJTFdqFnAv14qnGNYt2faRQCgM+U2jL/XyLBabfdbI+RwI9F5+qy/7iWm
 nFwTbTrJsh4BRkw86NdOCzmpV5MEdEul9Qt7eV07ByOuqkrrzPz3ELFQJCda/k3czgch
 OAcDQY1Iqkn1YqPTwpX3HxW2/+WysxhgDwawEVZhF5he4dg2pRbToUnFvEAcJyBpR/j5
 q5/HOrqMdt0G4xNVOKwau4zC7ZdE4UEDygah1VYYNDpS/c6DrbbHkq4dJhvp4FDSoaqe 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 325k3687qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 18:49:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068IdD4Y125333;
        Wed, 8 Jul 2020 18:47:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 325k3fsp27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 18:47:19 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 068IlIjk025607;
        Wed, 8 Jul 2020 18:47:18 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jul 2020 11:47:18 -0700
Date:   Wed, 8 Jul 2020 21:47:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring: fix a use after free in io_async_task_func()
Message-ID: <20200708184711.GA31157@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007080114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007080114
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The "apoll" variable is freed and then used on the next line.  We need
to move the free down a few lines.

Fixes: 0be0b0e33b0b ("io_uring: simplify io_async_task_func()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70828e2470e2..f2993070a9e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4652,12 +4652,13 @@ static void io_async_task_func(struct callback_head *cb)
 	/* restore ->work in case we need to retry again */
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
-	kfree(apoll);
 
 	if (!READ_ONCE(apoll->poll.canceled))
 		__io_req_task_submit(req);
 	else
 		__io_req_task_cancel(req, -ECANCELED);
+
+	kfree(apoll);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-- 
2.27.0

