Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B999D19DFD4
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 22:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbgDCUvn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 16:51:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53352 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgDCUvn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 16:51:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033KgmQJ091258;
        Fri, 3 Apr 2020 20:51:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fyNzfljLdF6oLLkElmvtkQErWZdj5e4T4RYQSl51T5g=;
 b=0Yfa7t47EBIGFIemHWJjhPQbCvUbJSGZtjWYSnSCz3mV/qpXpcyG8vTdSt/9/lJyglBN
 HFL5flK3BPyq10tNYkDfLBM3r+nvGmnQj9SD0uulne51oHSioZxq0I/W8Rk9swzBpVZU
 GBd/3wwAPEwc5TPg0tdMgsfzO/SxC5+XI567y4ijKcvCxGEQam46+zp7/2ouREfPpjoA
 1Ev2gt5T4gqOSo+lBDg7MPUktU2t0Ru10KJ8w0UZJVkNUfhLWZjwq/pS/60LwP0hGbiq
 pmn/itC3oW3vVnLxh35N2BB03Bt8o3hKYdRcd4r/6U8m5FsUttvoVut+Xmw9V35M7kGu RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqj3nd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 20:51:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033KhFYr100119;
        Fri, 3 Apr 2020 20:51:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 304sjtx7na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 20:51:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033KpcCN024123;
        Fri, 3 Apr 2020 20:51:38 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 13:51:38 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: process requests completed with -EAGAIN on poll list
Date:   Fri,  3 Apr 2020 13:51:33 -0700
Message-Id: <1585947093-41691-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585947093-41691-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1585947093-41691-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=3 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030165
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A request that completes with an -EAGAIN result after it has been added
to the poll list, will not be removed from that list in io_do_iopoll()
because the f_op->iopoll() will not succeed for that request.

Maintain a retryable local list similar to the done list, and explicity
reissue requests with an -EAGAIN result.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62bd410..149e843 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1738,11 +1738,24 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	io_free_req_many(ctx, &rb);
 }
 
+static void io_iopoll_queue(struct list_head *again)
+{
+	struct io_kiocb *req;
+
+	do {
+		req = list_first_entry(again, struct io_kiocb, list);
+		list_del(&req->list);
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	} while (!list_empty(again));
+}
+
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			long min)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
+	LIST_HEAD(again);
 	bool spin;
 	int ret;
 
@@ -1757,9 +1770,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		struct kiocb *kiocb = &req->rw.kiocb;
 
 		/*
-		 * Move completed entries to our local list. If we find a
-		 * request that requires polling, break out and complete
-		 * the done list first, if we have entries there.
+		 * Move completed and retryable entries to our local lists.
+		 * If we find a request that requires polling, break out
+		 * and complete those lists first, if we have entries there.
 		 */
 		if (req->flags & REQ_F_IOPOLL_COMPLETED) {
 			list_move_tail(&req->list, &done);
@@ -1768,6 +1781,13 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (!list_empty(&done))
 			break;
 
+		if (req->result == -EAGAIN) {
+			list_move_tail(&req->list, &again);
+			continue;
+		}
+		if (!list_empty(&again))
+			break;
+
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
 		if (ret < 0)
 			break;
@@ -1780,6 +1800,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	if (!list_empty(&done))
 		io_iopoll_complete(ctx, nr_events, &done);
 
+	if (!list_empty(&again))
+		io_iopoll_queue(&again);
+
 	return ret;
 }
 
-- 
1.8.3.1

