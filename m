Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF453FFE91
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 13:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhICLCe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 07:02:34 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:41322 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348412AbhICLCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 07:02:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Un61DbM_1630666849;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un61DbM_1630666849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 19:00:59 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 6/6] io_uring: enable multishot mode for accept
Date:   Fri,  3 Sep 2021 19:00:49 +0800
Message-Id: <20210903110049.132958-7-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210903110049.132958-1-haoxu@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Update io_accept_prep() to enable multishot mode for accept operation.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eb81d37dce78..34612646ae3c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
+	bool is_multishot;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
 
+	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
+	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
+		return -EINVAL;
+
 	accept->file_slot = READ_ONCE(sqe->file_index);
 	if (accept->file_slot && ((req->open.how.flags & O_CLOEXEC) ||
-				  (accept->flags & SOCK_CLOEXEC)))
+				  (accept->flags & SOCK_CLOEXEC) || is_multishot))
 		return -EINVAL;
-	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK | IORING_ACCEPT_MULTISHOT))
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
 		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+	if (is_multishot) {
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+		accept->flags &= ~IORING_ACCEPT_MULTISHOT;
+	}
+
 	return 0;
 }
 
-- 
2.24.4

