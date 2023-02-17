Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B59169AFF1
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBQP4m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Feb 2023 10:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBQP4k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Feb 2023 10:56:40 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334271480
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:10 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id f11so371828ioz.3
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676649369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxEL1/q2EaMAGy2jb8nUV7Ltni048cKqSOvvDVCI/cI=;
        b=U5Jm9FZepPr4NbBiRTI0eNo/vqmMqo3ewNSAS++5cct9FrcwNcONsk92EpvHcXC3MK
         /g4+nvBbKC79U/1nL1nuAbp9g3hwH0lXEP5wg7gM81lG9jUg/UJMpoEA4yGApXb4WWNy
         9GpC34WlnIbgCvcF/kUnSCcr+LKkyqJ04vuxCVBfgT6VMT6K6aOu7P1C0nhehsWhxzPn
         7NBPAZywLm8HQpOnbMU6GSBj/B4LONjfroxoGR8u0xPgjwCY666lchzIwUjpMdK7DyKR
         KOJo42GXTZ8q0xVIT8JWtMqxD5ojojp8pohiSWdwgZPsQj67dupyv4HS6jmBI3HUv93+
         b5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676649369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxEL1/q2EaMAGy2jb8nUV7Ltni048cKqSOvvDVCI/cI=;
        b=mwTtXF1/o0bq5HU5OLRuInfyCcn/cwryk0ynVpaYo7JmmlUWT5Eh0wgAN/l+AyOM7L
         m95n92woqm2gzxPsDGn9zLv08vw/nSCX6cOKdn01m5tmAa4Hk/38qzbo+/RZFsnItoTA
         1HAV2GjIJirKwi2olHQUzEIWYtIp6q35c8sxzfCMjXDVX1i4IhRgHg8qsw1d7lU5GBXB
         lWvrMP629czLBKlHraU+W2PsvBIWmdxtdWHppGAS6KbzSS6lWHHD/MU1WSpuoL8m4dsP
         ZiNNq9gP4VsUfliX473j7jTvdzGT+RmI3U/m2++rRqQX6vEeJEdFUrfckx92AWq1t6yq
         l7LA==
X-Gm-Message-State: AO0yUKWGzAXl74HiOgX4RqkqQ6hjYLbr1W35dhM5Q5OFoca+OFx+eEye
        ps+9EBmQjXCgOVtTsj6nKeRN9QQNeGEW0Yj9
X-Google-Smtp-Source: AK7set8PzalkbK9Dm7G9uluqqaDdCgzv3GE3Ru/F3WZcXM+9S3ZMhuVJQ1aqIjqTW7pEz6n8/s4EtA==
X-Received: by 2002:a05:6602:2e13:b0:73a:397b:e311 with SMTP id o19-20020a0566022e1300b0073a397be311mr1633033iow.0.1676649368730;
        Fri, 17 Feb 2023 07:56:08 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d22-20020a0566022d5600b007046e9e138esm1551156iow.22.2023.02.17.07.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 07:56:08 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: cache task cancelation state in the ctx
Date:   Fri, 17 Feb 2023 08:55:59 -0700
Message-Id: <20230217155600.157041-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217155600.157041-1-axboe@kernel.dk>
References: <20230217155600.157041-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It can be quite expensive for the fast paths to deference
req->task->io_uring->in_cancel for the (very) unlikely scenario that
we're currently undergoing cancelations.

Add a ctx bit to indicate if we're currently canceling or not, so that
the hot path may check this rather than dip into the remote task
state.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 44 ++++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 00689c12f6ab..42d704adb9c6 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -211,6 +211,8 @@ struct io_ring_ctx {
 		enum task_work_notify_mode	notify_method;
 		struct io_rings			*rings;
 		struct task_struct		*submitter_task;
+		/* local ctx cache of task cancel state */
+		unsigned long			in_cancel;
 		struct percpu_ref		refs;
 	} ____cacheline_aligned_in_smp;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 64e07df034d1..0fcb532db1fc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3192,6 +3192,46 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
+static __cold void io_uring_dec_cancel(struct io_uring_task *tctx,
+				       struct io_sq_data *sqd)
+{
+	if (!atomic_dec_return(&tctx->in_cancel))
+		return;
+
+	if (!sqd) {
+		struct io_tctx_node *node;
+		unsigned long index;
+
+		xa_for_each(&tctx->xa, index, node)
+			clear_bit(0, &node->ctx->in_cancel);
+	} else {
+		struct io_ring_ctx *ctx;
+
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+			clear_bit(0, &ctx->in_cancel);
+	}
+}
+
+static __cold void io_uring_inc_cancel(struct io_uring_task *tctx,
+				       struct io_sq_data *sqd)
+{
+	if (atomic_inc_return(&tctx->in_cancel) != 1)
+		return;
+
+	if (!sqd) {
+		struct io_tctx_node *node;
+		unsigned long index;
+
+		xa_for_each(&tctx->xa, index, node)
+			set_bit(0, &node->ctx->in_cancel);
+	} else {
+		struct io_ring_ctx *ctx;
+
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+			set_bit(0, &ctx->in_cancel);
+	}
+}
+
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
  * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
@@ -3210,7 +3250,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
-	atomic_inc(&tctx->in_cancel);
+	io_uring_inc_cancel(tctx, sqd);
 	do {
 		bool loop = false;
 
@@ -3263,7 +3303,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		 * We shouldn't run task_works after cancel, so just leave
 		 * ->in_cancel set for normal exit.
 		 */
-		atomic_dec(&tctx->in_cancel);
+		io_uring_dec_cancel(tctx, sqd);
 		/* for exec all current's requests should be gone, kill tctx */
 		__io_uring_free(current);
 	}
-- 
2.39.1

