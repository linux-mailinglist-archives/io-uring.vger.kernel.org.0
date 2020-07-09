Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7EB219A0D
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 09:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgGIHd6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 03:33:58 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:36118 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgGIHd5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 03:33:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U2B7J-q_1594280035;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U2B7J-q_1594280035)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 15:33:56 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring_peek_batch_cqe should also check cq ring overflow
Date:   Thu,  9 Jul 2020 15:33:49 +0800
Message-Id: <20200709073349.31860-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_uring_peek_batch_cqe(), if the first peek could not find any
cqes, we check cq ring overflow, and if cq ring has been overflowed,
enter kernel to flush cqes, and do the second peek.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 src/queue.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/src/queue.c b/src/queue.c
index 1f00251..be80d7a 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -125,7 +125,9 @@ unsigned io_uring_peek_batch_cqe(struct io_uring *ring,
 				 struct io_uring_cqe **cqes, unsigned count)
 {
 	unsigned ready;
+	bool overflow_checked = false;
 
+again:
 	ready = io_uring_cq_ready(ring);
 	if (ready) {
 		unsigned head = *ring->cq.khead;
@@ -141,6 +143,17 @@ unsigned io_uring_peek_batch_cqe(struct io_uring *ring,
 		return count;
 	}
 
+	if (overflow_checked)
+		goto done;
+
+	if (cq_ring_needs_flush(ring)) {
+		__sys_io_uring_enter(ring->ring_fd, 0, 0,
+				     IORING_ENTER_GETEVENTS, NULL);
+		overflow_checked = true;
+		goto again;
+	}
+
+done:
 	return 0;
 }
 
-- 
2.17.2

