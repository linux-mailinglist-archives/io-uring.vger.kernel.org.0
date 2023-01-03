Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8AB65B994
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbjACDFf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjACDFa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:30 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F56BF5F
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:29 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so22169831wms.2
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MoTHAaXqKBt52ZvHVgZSMQyuUe+Z8C2Fhn5NtXMvC9E=;
        b=mm5r2qFhbJcOlDXjGU+IglpBpoWiPA1/gsJKN4EB9iVSwi5y89uhdlDvWVNZZVGMkx
         WJpRjLphpUvmF6IuHeOpLDEDRalW+9NA7331XlkhrWPGMj75OanjHjSznNpdVPUf6d1G
         +z9YZRBnydcpJ8q3gsiDMopB5GphQ89zuswTW9dFX2tkQrJTpAKsIXOnxmOOjUXRmA88
         FqlQdeaVav9xJyX4M7zEr1sk56GRFNtTefMBbaS26Md0EG9WulAETfpvAd6OS+15lIB7
         wusQiIudNcpdPL6Jzqt1hGYd/u2YE80yIE6bblcn1cV+ksKJaC40ST0K8XcWRfV0tsEW
         aarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MoTHAaXqKBt52ZvHVgZSMQyuUe+Z8C2Fhn5NtXMvC9E=;
        b=sDOV0VOB1nVfyYcph1YPvMzQdhQZM3gs7Q6U20mXOIlN0sWe9g61MvFw5LoankIewK
         j7QfFqN/9kICV96HnafJMvn/eCXTa+RFvrgelBtk7rk5RCZxbnsd71eQB/4HUvxfdfsW
         KJ2uuyXtI52XBB0nRTmcpPeWe0OqL5JWJDIgzW8m+oifzn9DwOEp/aJ/7HbIeee1z2sr
         hp16c7xYZWNBBoZLMHEa7FE24zG67Sr303NQP/U59kBFuTm1lVIj0Vq8tV+2QUzcLYag
         YhaqnKr9SalymJ2sxhpJVRqPbMRW1hOTHg2/ZHmYRMb7C0X6Hy+J5byaJrtbhLHHDX6W
         qFcA==
X-Gm-Message-State: AFqh2ko8dNxOZ06D7nvBevpb3k+g2WVFWLuewa+prbziVNRmtuRXWjmA
        GTj662YFf/iSoIET3GNv9woz4QPpzjc=
X-Google-Smtp-Source: AMrXdXv8/sKjyIRjsipPHhnNj8YicQz5CvOVA1qBeYsUPAKl+saptt3rhESiHbYNmgc1F4e6NKvRoA==
X-Received: by 2002:a05:600c:3b82:b0:3d3:4877:e560 with SMTP id n2-20020a05600c3b8200b003d34877e560mr29520586wms.27.1672715127914;
        Mon, 02 Jan 2023 19:05:27 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 11/13] io_uring: wake up optimisations
Date:   Tue,  3 Jan 2023 03:04:02 +0000
Message-Id: <1b09f9674e9140ef9623c5a26ab7b826d4d4fe69.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Flush completions is done either from the submit syscall or by the
task_work, both are in the context of the submitter task, and when it
goes for a single threaded rings like implied by ->task_complete, there
won't be any waiters on ->cq_wait but the master task. That means that
there can be no tasks sleeping on cq_wait while we run
__io_submit_flush_completions() and so waking up can be skipped.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d2a3d9928ba3..98d0d9e49be0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -621,6 +621,25 @@ static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_cqring_wake(ctx);
 }
 
+static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
+	__releases(ctx->completion_lock)
+{
+	io_commit_cqring(ctx);
+	__io_cq_unlock(ctx);
+	io_commit_cqring_flush(ctx);
+
+	/*
+	 * As ->task_complete implies that the ring is single tasked, cq_wait
+	 * may only be waited on by the current in io_cqring_wait(), but since
+	 * it will re-check the wakeup conditions once we return we can safely
+	 * skip waking it up.
+	 */
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
+		smp_mb();
+		__io_cqring_wake(ctx);
+	}
+}
+
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
@@ -1461,7 +1480,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			}
 		}
 	}
-	__io_cq_unlock_post(ctx);
+	__io_cq_unlock_post_flush(ctx);
 
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
-- 
2.38.1

