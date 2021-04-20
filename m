Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5198236570E
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 13:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhDTLER (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 07:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhDTLER (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 07:04:17 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D7FC06174A
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:46 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id y204so18494021wmg.2
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=i71o7Uyxl5AGk806tivCM/9ldvxzlL1xzAw8UXnz/W0=;
        b=R5yxTDJQUqYE8/IKYoGTRuuXmOPj0eyGyjWj/qHrs+ynv7QYbhuwA6Ynx3LXwU8Tep
         tyAT1Ldo8Flz2yZzaoDFj9vZkjNTgU4+PZiygU8GhGo7FGhGV11CNSXMfeZzxVEXHh+K
         dBVdHO9PEcQeIUvRcpvwryRlg6FlAMicdysyV0QfuhZJcOcYUMNNwgwofjEPMVL6+65K
         kZDXt91P1MCX1lxNfjV8NN+/ceORlmpH/cn++ecAA+fP4oNRKdhMhD1XZ1SMRrUU7+i4
         dRXOIUZMrLFGNhJVGrpbuR0iVzn9Z15caF1y5wgA/QeB3Gq+Iq4kXueY89MzlvioH9bq
         /7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i71o7Uyxl5AGk806tivCM/9ldvxzlL1xzAw8UXnz/W0=;
        b=DH472mYie0jNAs9ftOXavzWLBVe/fTEpo9q2Gt16KXj36hHdhVoQjwvJpeiz97jwzP
         wjlWgMxhUj00WQr4H5xa0qty1EiYGrvQ84MwwNSchNFkEHPLeGMbdkz1DB0bxHEgU8OQ
         SCJZtX4SaczOp9uXr+X3Z0Z+DOgv/NcfmZ560CVPz/E7LTxgORoraooPfy0XfRWB9XLH
         hVwPJo3m5rQFnY4iScvsDqGTNql8kLpxKuCeQnFN8pir9rA2eeRKTPGHVXxVx1Z6imsM
         yIZjN8Q4c2yzAOSui7ew9Edu/DBDdwmwWZVwwwmlWkCohKbFhmGds0sYN27I31AkSIFf
         ZkoQ==
X-Gm-Message-State: AOAM531l61q5P6ByowSmnQqGeMHzWWv9Zy5r3vY8/c6Xjq/wHfLgYust
        BfUtK6UsJk6FMIC1iq+ammCb/6jUB9n59g==
X-Google-Smtp-Source: ABdhPJzbfFooMvrzJOUqm9Mlgz5m0Y2AisEaUhOvRY75gHLx2+R58mBITagVdDLAuPelXkEuJC9zNQ==
X-Received: by 2002:a1c:6585:: with SMTP id z127mr3935797wmb.46.1618916625140;
        Tue, 20 Apr 2021 04:03:45 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.116])
        by smtp.gmail.com with ESMTPSA id y8sm12899486wru.27.2021.04.20.04.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 04:03:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Date:   Tue, 20 Apr 2021 12:03:33 +0100
Message-Id: <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618916549.git.asml.silence@gmail.com>
References: <cover.1618916549.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just a bit of code tossing in io_sq_offload_create(), so it looks a bit
better. No functional changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 482c77d57219..b2aa9b99b820 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7876,11 +7876,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		f = fdget(p->wq_fd);
 		if (!f.file)
 			return -ENXIO;
-		if (f.file->f_op != &io_uring_fops) {
-			fdput(f);
-			return -EINVAL;
-		}
 		fdput(f);
+		if (f.file->f_op != &io_uring_fops)
+			return -EINVAL;
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct task_struct *tsk;
@@ -7899,13 +7897,11 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
 
-		ret = 0;
 		io_sq_thread_park(sqd);
 		list_add(&ctx->sqd_list, &sqd->ctx_list);
 		io_sqd_update_thread_idle(sqd);
 		/* don't attach to a dying SQPOLL thread, would be racy */
-		if (attached && !sqd->thread)
-			ret = -ENXIO;
+		ret = (attached && !sqd->thread) ? -ENXIO : 0;
 		io_sq_thread_unpark(sqd);
 
 		if (ret < 0)
@@ -7917,11 +7913,8 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
-			if (cpu >= nr_cpu_ids)
-				goto err_sqpoll;
-			if (!cpu_online(cpu))
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 				goto err_sqpoll;
-
 			sqd->sq_cpu = cpu;
 		} else {
 			sqd->sq_cpu = -1;
@@ -7947,12 +7940,11 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 	}
 
 	return 0;
+err_sqpoll:
+	complete(&ctx->sq_data->exited);
 err:
 	io_sq_thread_finish(ctx);
 	return ret;
-err_sqpoll:
-	complete(&ctx->sq_data->exited);
-	goto err;
 }
 
 static inline void __io_unaccount_mem(struct user_struct *user,
-- 
2.31.1

