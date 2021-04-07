Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEB9356B0F
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 13:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhDGLX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 07:23:57 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:52295 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234598AbhDGLXm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 07:23:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUnhk8L_1617794605;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUnhk8L_1617794605)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 19:23:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/3] io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
Date:   Wed,  7 Apr 2021 19:23:23 +0800
Message-Id: <1617794605-35748-2-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we now have requests that may generate multiple cqes, we need a
new flag to mark them, so that we can maintain features like drain io
easily for them.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 5 ++++-
 include/uapi/linux/io_uring.h | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 81e5d156af1c..192463bb977a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -102,7 +102,7 @@
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
+				IOSQE_BUFFER_SELECT | IOSQE_MULTI_CQES)
 
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
@@ -700,6 +700,7 @@ enum {
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+	REQ_F_MULTI_CQES_BIT	= IOSQE_MULTI_CQES_BIT,
 
 	REQ_F_FAIL_LINK_BIT,
 	REQ_F_INFLIGHT_BIT,
@@ -766,6 +767,8 @@ enum {
 	REQ_F_ASYNC_WRITE	= BIT(REQ_F_ASYNC_WRITE_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
+	/* a request can generate multiple cqes */
+	REQ_F_MULTI_CQES	= BIT(REQ_F_MULTI_CQES_BIT),
 };
 
 struct async_poll {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5beaa6bbc6db..303ac8005572 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_MULTI_CQES_BIT,
 };
 
 /*
@@ -87,6 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* may generate multiple cqes */
+#define IOSQE_MULTI_CQES	(1U << IOSQE_MULTI_CQES_BIT)
 
 /*
  * io_uring_setup() flags
-- 
1.8.3.1

