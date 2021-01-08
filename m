Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861EF2EEEAA
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 09:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbhAHIhG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 03:37:06 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:59233 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727182AbhAHIhG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 03:37:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UL2sdQ8_1610094983;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UL2sdQ8_1610094983)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Jan 2021 16:36:24 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: reduce one unnecessary io_sqring_entries() call
Date:   Fri,  8 Jan 2021 16:36:23 +0800
Message-Id: <20210108083623.26400-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In __io_sq_thread(), we have gotten the number of sqes to submit,
then in io_submit_sqes(), we can use this number directly, no need
to call io_sqring_entries() again in io_submit_sqes().

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..200a9eb72788 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6830,9 +6830,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 			return -EBUSY;
 	}
 
-	/* make sure SQ entry isn't read before tail */
-	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
-
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
@@ -9211,6 +9208,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
+		/* make sure SQ entry isn't read before tail */
+		to_submit = min3(to_submit, ctx->sq_entries, io_sqring_entries(ctx));
 		submitted = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
-- 
2.17.2

