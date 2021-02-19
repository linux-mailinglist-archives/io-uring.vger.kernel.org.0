Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB8A31FE73
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBSR7X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:59:23 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:43882 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhBSR7U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:59:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UOzNGoU_1613757506;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UOzNGoU_1613757506)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 01:58:36 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: don't submit sqes when ctx->refs is dying
Date:   Sat, 20 Feb 2021 01:58:26 +0800
Message-Id: <1613757506-199460-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When doing __io_uring_register() and waiting for references to exit,
there could be other threads calling io_uring_enter() and submitting
sqes which may cause the drain wait endless. So avoid this case by
checking if ctx->refs is dying.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 931671082e61..9aab4d25c2df 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9356,6 +9356,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 		}
 		submitted = to_submit;
 	} else if (to_submit) {
+		if (unlikely(percpu_ref_is_dying(&ctx->refs)))
+			goto out;
 		ret = io_uring_add_task_file(ctx, f.file);
 		if (unlikely(ret))
 			goto out;
-- 
1.8.3.1

