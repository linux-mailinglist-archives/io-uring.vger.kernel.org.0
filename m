Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF2B65B991
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbjACDFc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbjACDF3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E142733
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:28 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so19644539wmb.2
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kWWRsaw0qWaWK3TMMd0psKCqbvCHyf3bRkImyBw87Y=;
        b=PeqjXJRPOh/XzUOUqP2a/+mgxbfrGWBGGflwslugDL/NFr0Z+1acrP9RJBsjLW6qe3
         QEUBbqFRG2IhCfyQWucWYfFleaRsymKiujYHFKy39TTkLXTnppEdLUrOlZIvD94hQi8t
         867CoLg1OcQswtXihHuc8mwWdujXmYwI12IiRvcJWwNLhlGy5dgBzpuYw4NwmbKLdtR2
         Mb8r5TQUhzn+p4z0fBVDKfJt+wF6/jS0NoGZIi7aS9N/s2287kHMgrAYvyfB+rKx1G9b
         pqlFJbgU4pUcyrDg1WcVE6qZ90ZhhZXzZ796gNcX1qHLCfnbC74T0qyNkdF4+RRkwr23
         g0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kWWRsaw0qWaWK3TMMd0psKCqbvCHyf3bRkImyBw87Y=;
        b=w7wLTWjdqdzbFSvmz0nCy47OxJgJD1qzpEcQESdrn6JQ/YK1RiYc4J5gWI053ICMY2
         IbgSobiYuyRyYAb9SS6Wb+InOubFIWUVbe+ZvUdcHlpLtwGSxP7KiibhHEjTu/hJnYED
         GjcnW9d9Y631DcIxAzt4YT3LM8sdoaLq1BamDy3Lh+LqDtl4t8i6IAugRcZh4H62ItZ5
         CAgdp0a+JzDPPgNGNK3scmKIvY8eD44+7LL/lQK68dXmID7tGyykUJdlsRCtMoYXlxkk
         0pM5UXCWgcaxRetlKmH47QbErFt0mEbkH82OdhWPVIrKo0bnrAtXgK5jqFkf/FxUIAjk
         mNGw==
X-Gm-Message-State: AFqh2kpdXiv3VYkBINrPwuwI8GB8D8vtd3vtWWFBD8vrvuopt5DOEBJn
        cQbNLsS7pkxQa+FsMYZspZsaYJpece4=
X-Google-Smtp-Source: AMrXdXuN/cj/sPMgeuIHfHjZ/wUFqT3WyHMfVbCOdxY/MoPqCvNDqMCX0iOG7cYsAzvATwy8+z9l4w==
X-Received: by 2002:a05:600c:254:b0:3d2:2c86:d2b2 with SMTP id 20-20020a05600c025400b003d22c86d2b2mr37417590wmj.24.1672715126476;
        Mon, 02 Jan 2023 19:05:26 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 09/13] io_uring: separate wq for ring polling
Date:   Tue,  3 Jan 2023 03:04:00 +0000
Message-Id: <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
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

Don't use ->cq_wait for ring polling but add a separate wait queue for
it. We need it for following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/io_uring.c            | 3 ++-
 io_uring/io_uring.h            | 9 +++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dcd8a563ab52..cbcd3aaddd9d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -286,6 +286,7 @@ struct io_ring_ctx {
 		unsigned		cq_entries;
 		struct io_ev_fd	__rcu	*io_ev_fd;
 		struct wait_queue_head	cq_wait;
+		struct wait_queue_head	poll_wq;
 		unsigned		cq_extra;
 	} ____cacheline_aligned_in_smp;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 682f4b086f09..42f512c42099 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -316,6 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
+	init_waitqueue_head(&ctx->poll_wq);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
@@ -2768,7 +2769,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
-	poll_wait(file, &ctx->cq_wait, wait);
+	poll_wait(file, &ctx->poll_wq, wait);
 	/*
 	 * synchronizes with barrier from wq_has_sleeper call in
 	 * io_commit_cqring
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9b7baeff5a1c..645ace377d7e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -207,9 +207,18 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }
 
+static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
+{
+	if (waitqueue_active(&ctx->poll_wq))
+		__wake_up(&ctx->poll_wq, TASK_NORMAL, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
+}
+
 /* requires smb_mb() prior, see wq_has_sleeper() */
 static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
+	io_poll_wq_wake(ctx);
+
 	/*
 	 * Trigger waitqueue handler on all waiters on our waitqueue. This
 	 * won't necessarily wake up all the tasks, io_should_wake() will make
-- 
2.38.1

