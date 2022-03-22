Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2094E403A
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 15:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiCVOKo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 10:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiCVOKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 10:10:42 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7115E756
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h16so10603698wmd.0
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7adyoKToocj+FWztsOZRd9/JKiXd4wNghznE53QTCpo=;
        b=f4JD6vPxvTuZn+td1D/AbHFVvIGrq0ekUVxaBa/9LaB01RUt0oAsJ/G0RFW36k1zVX
         89SzD22LjY7btXqelatwj79gw/yWz3Ojl2dTsxRzouz4M5HFyfZwSEuOiL/mdoNd0dSJ
         MI1mDvacvph/NEOsv5dNqIghtNtt/kY6Qec5n6a+Kp97YvEvhNBQxeuxwCGcGGDTkX6u
         1EhanZXMDvSLhIMOLC8Tnih4D+fmT+JbPCuKh3WnRZcK2ciXtDvSzwOQR+PS2wjzom+g
         PkEn/PUY9XaabOi8BqxYs3xbA5n1p85QxnmfbIlU2TClshv5sdi+a2yvYFqNUgkdZv7I
         cfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7adyoKToocj+FWztsOZRd9/JKiXd4wNghznE53QTCpo=;
        b=MBnnBTtx8btNEq3w8bbsRuW05o32lRRLd+9QrfOyuspobdXU/STrYNqN7uDRFR0Pac
         fMwEGbYMIXYpahXv9D39rjEeMpQWfz1OluqgksIddoSKvVQjp3RF1Fbw3+fbq8uunnM1
         0Zng+dlg5Is8UPe0zVeVftDgBke84ysoSwBDHQsEPv6gVs4AVt37UKR7HWf8/1rnaocg
         oikhGsBkHRYksRp291kS/I2tXukjnmAxk9XBB4aT0aT75RG2WgBjJJN5oxBTj/MdbCTv
         aIEScgr6dq9NyC8A9bgK9I20r99hWmW2LilTdRiRffMTAkByc1UQK971bwCaOBo92COz
         73Ug==
X-Gm-Message-State: AOAM533u+d+LsXBTxbF17d1qBrPvQ9LNvTr4nzndo48i34nxbbTCTa2Q
        x5tVtEmaw/ZwbKXpHKzLyjLuDQInKnfRWQ==
X-Google-Smtp-Source: ABdhPJzeveUHS5h8F2y1VrZFp8nqfoiipaogF0vur+Ic/abtVqP50PmcyGqdLc6A2UubgaNtqClQgA==
X-Received: by 2002:a1c:f70a:0:b0:37c:533d:d296 with SMTP id v10-20020a1cf70a000000b0037c533dd296mr3920594wmh.147.1647958153027;
        Tue, 22 Mar 2022 07:09:13 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-32.dab.02.net. [82.132.222.32])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00203ed35b0aesm21987733wrp.108.2022.03.22.07.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:09:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring: optimise mutex locking for submit+iopoll
Date:   Tue, 22 Mar 2022 14:07:58 +0000
Message-Id: <034b6c41658648ad3ad3c9485ac8eb546f010bc4.1647957378.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647957378.git.asml.silence@gmail.com>
References: <cover.1647957378.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both submittion and iopolling requires holding uring_lock. IOPOLL can
users do them together in a single syscall, however it would still do 2
pairs of lock/unlock. Optimise this case combining locking into one
lock/unlock pair, which especially nice for low QD.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d7ca4f28cfa4..c87a4b18e370 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2867,12 +2867,6 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	unsigned int nr_events = 0;
 	int ret = 0;
 
-	/*
-	 * We disallow the app entering submit/complete with polling, but we
-	 * still need to lock the ring to prevent racing with polled issue
-	 * that got punted to a workqueue.
-	 */
-	mutex_lock(&ctx->uring_lock);
 	/*
 	 * Don't enter poll loop if we already have events pending.
 	 * If we do, we can potentially be spinning for commands that
@@ -2881,7 +2875,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	if (test_bit(0, &ctx->check_cq_overflow))
 		__io_cqring_overflow_flush(ctx, false);
 	if (io_cqring_events(ctx))
-		goto out;
+		return 0;
 	do {
 		/*
 		 * If a submit got punted to a workqueue, we can have the
@@ -2911,8 +2905,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		nr_events += ret;
 		ret = 0;
 	} while (nr_events < min && !need_resched());
-out:
-	mutex_unlock(&ctx->uring_lock);
+
 	return ret;
 }
 
@@ -10927,21 +10920,33 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
+
 		mutex_lock(&ctx->uring_lock);
 		submitted = io_submit_sqes(ctx, to_submit);
-		mutex_unlock(&ctx->uring_lock);
-
-		if (submitted != to_submit)
+		if (submitted != to_submit) {
+			mutex_unlock(&ctx->uring_lock);
 			goto out;
+		}
+		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
+			goto iopoll_locked;
+		mutex_unlock(&ctx->uring_lock);
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
-		min_complete = min(min_complete, ctx->cq_entries);
-
 		if (ctx->syscall_iopoll) {
+			/*
+			 * We disallow the app entering submit/complete with
+			 * polling, but we still need to lock the ring to
+			 * prevent racing with polled issue that got punted to
+			 * a workqueue.
+			 */
+			mutex_lock(&ctx->uring_lock);
+iopoll_locked:
 			ret = io_validate_ext_arg(flags, argp, argsz);
-			if (unlikely(ret))
-				goto out;
-			ret = io_iopoll_check(ctx, min_complete);
+			if (likely(!ret)) {
+				min_complete = min(min_complete, ctx->cq_entries);
+				ret = io_iopoll_check(ctx, min_complete);
+			}
+			mutex_unlock(&ctx->uring_lock);
 		} else {
 			const sigset_t __user *sig;
 			struct __kernel_timespec __user *ts;
@@ -10949,6 +10954,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			ret = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
 			if (unlikely(ret))
 				goto out;
+			min_complete = min(min_complete, ctx->cq_entries);
 			ret = io_cqring_wait(ctx, min_complete, sig, argsz, ts);
 		}
 	}
-- 
2.35.1

