Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42103EFE05
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 09:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbhHRHn6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 03:43:58 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:53435 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238369AbhHRHn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 03:43:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UjeejBw_1629272596;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UjeejBw_1629272596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Aug 2021 15:43:22 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/3] io_uring: move fail path of request submittion to the end
Date:   Wed, 18 Aug 2021 15:43:16 +0800
Message-Id: <20210818074316.22347-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210818074316.22347-1-haoxu@linux.alibaba.com>
References: <20210818074316.22347-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the fail path of request submittion to the end of the function to
make the logic more readable.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 383668e07417..5eb09ca4a0a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6639,25 +6639,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	head = link->head;
 
 	ret = io_init_req(ctx, req, sqe);
-	if (unlikely(ret)) {
-fail_req:
-		req->result = ret;
-		if (head) {
-			link->last = req;
-			if (is_link) {
-				req_set_fail(head);
-			} else {
-				int res = head->result ? head->result : -ECANCELED;
-
-				link->head = NULL;
-				/* fail even hard links since we don't submit */
-				io_req_complete_failed(head, res);
-			}
-		} else {
-			io_req_complete_failed(req, ret);
-		}
-		return ret;
-	}
+	if (unlikely(ret))
+		goto fail_req;
 
 	ret = io_req_prep(req, sqe);
 	if (unlikely(ret))
@@ -6698,6 +6681,25 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	return 0;
+
+fail_req:
+	if (head) {
+		req->result = ret;
+		link->last = req;
+		if (is_link) {
+			req_set_fail(head);
+		} else {
+			int res = head->result ? head->result : -ECANCELED;
+
+			link->head = NULL;
+			/* fail even hard links since we don't submit */
+			io_req_complete_failed(head, res);
+		}
+	} else {
+		io_req_complete_failed(req, ret);
+	}
+
+	return ret;
 }
 
 /*
-- 
2.24.4

