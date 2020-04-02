Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E2A19C936
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2020 20:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389297AbgDBSyx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Apr 2020 14:54:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732214AbgDBSyx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Apr 2020 14:54:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Idh4K065189;
        Thu, 2 Apr 2020 18:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=zOGbkcRjc/DwwpbjejtYyTNRyp8AaUliAVhJOdpNmZQ=;
 b=nmtRhXCj07eRmzNuw8TkoIa393KPpkK8KUx/ETC+ZZnIqdjq9zO2QVduGDqh265fxRW5
 JULEMdvqtZviY3tg1jcJV3WCQA3gZecTS6woqXbzhMSL0UhbWJy37SkWfGZv560rgSKl
 uui8nl0w7BhzeIyqPrR0BPx+2AT1IN0feRTFkISMPmReqzQJ/cE6RA2ZE2lCTbd9WENJ
 sjbtui270iCFzAVW3Gw2n9qquR4SYqoeBWE52ynD15+vDQvQWJAJhzlEZotemlgVVuqj
 I1HK8vt0mSiNmW5ToqFT/yzHUPJ9u2UCTLpxbmdw+NJz/FIVUWtxtPkbZcWYPdKoGaAr kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevd9n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:54:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032IcGea069799;
        Thu, 2 Apr 2020 18:54:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga2xgj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:54:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032IslRS011983;
        Thu, 2 Apr 2020 18:54:47 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 11:54:46 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 1/1] io_uring: process requests completed with -EAGAIN on poll list
Date:   Thu,  2 Apr 2020 11:54:25 -0700
Message-Id: <1585853665-8705-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585853665-8705-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1585853665-8705-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=3 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020141
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
index 62bd410..a3e3a4e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1738,11 +1738,24 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	io_free_req_many(ctx, &rb);
 }
 
+static void io_iopoll_queue(struct list_head *again)
+{
+	struct io_kiocb *req;
+
+	while (!list_empty(again)) {
+		req = list_first_entry(again, struct io_kiocb, list);
+		list_del(&req->list);
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	}
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

