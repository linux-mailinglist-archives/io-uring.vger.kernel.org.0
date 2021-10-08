Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97256426AF2
	for <lists+io-uring@lfdr.de>; Fri,  8 Oct 2021 14:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhJHMiq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Oct 2021 08:38:46 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53823 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241532AbhJHMip (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Oct 2021 08:38:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ur.V7Wc_1633696602;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ur.V7Wc_1633696602)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Oct 2021 20:36:49 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/2] io_uring: add IOSQE_ASYNC_HYBRID flag for pollable requests
Date:   Fri,  8 Oct 2021 20:36:41 +0800
Message-Id: <20211008123642.229338-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211008123642.229338-1-haoxu@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current logic of requests with IOSQE_FORCE_ASYNC is first queueing
it to io-worker, then execute it in a synchronous way. For unbound works
like pollable requests(e.g. read/write a socketfd), the io-worker may
stuck there waiting for events for a long time. And thus other works
wait in the list for a long time too.
Let's introduce a new sqe flag IOSQE_ASYNC_HIBRID for unbound works
(currently pollable requests), with this a request will first be queued
to io-worker, then executed in a nonblock try rather than a synchronous
way. Failure of that leads it to arm poll stuff and then the worker can
begin to handle other works.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 6 +++++-
 include/uapi/linux/io_uring.h | 4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73135c5c6168..a99f7f46e6d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -104,7 +104,8 @@
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
-			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
+			  IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+			  IOSQE_ASYNC_HYBRID)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS|IOSQE_BUFFER_SELECT|IOSQE_IO_DRAIN)
 
@@ -709,6 +710,7 @@ enum {
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+	REQ_F_ASYNC_HYBRID_BIT	= IOSQE_ASYNC_HYBRID_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 8,
@@ -747,6 +749,8 @@ enum {
 	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
+	/* IOSQE_ASYNC_HYBRID */
+	REQ_F_ASYNC_HYBRID	= BIT(REQ_F_ASYNC_HYBRID_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c45b5e9a9387..3e49a7dbe636 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_ASYNC_HYBRID_BIT,
 };
 
 /*
@@ -87,7 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
-
+/* first force async then arm poll */
+#define IOSQE_ASYNC_HYBRID	(1U << IOSQE_ASYNC_HYBRID_BIT)
 /*
  * io_uring_setup() flags
  */
-- 
2.24.4

