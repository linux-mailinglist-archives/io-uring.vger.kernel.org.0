Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882E765E9BB
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjAELXs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbjAELXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:34 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1290B50066
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:33 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ja17so27768098wmb.3
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaLwErdLYUo15ANQXvzf5YPtPlY3IX20HXZIH7F0x/M=;
        b=GB6lb8hQX0w752savqu2+/DkSC4K0zRuTw4rkSMM1vld6gj6SJ6/AUz9DDBg8f3ERa
         LgjN31Tpu4T9GFQNKWdTVD5aINn2q+6z6BxAJzoy4DWKa647S/FcSCuJSmtM3YVy3LZA
         U3hEdaqHyh5Yl5cwgQHTbPJTLtixdpGr1n6XztOsZH8sdcK8mLrHKM0IM0W5y9fN4WhI
         qhqXObMfuzkbKvEfZmjjA7zPmB1kwfA9ASzvT5UrjmKZPrzSAW2GrTwJbGdidZra4mdO
         KOKmVpLPfEqd2QPJ1Pq6rKFpm69tUCZVbkj1viOid6lfZVNSQTNSk1v75702yawZOuzp
         RWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BaLwErdLYUo15ANQXvzf5YPtPlY3IX20HXZIH7F0x/M=;
        b=L5WQOthdbAT5zD9VI0DAXXRr1sIB/pRB/Q8nvufTV/HYXAu5DDS84V0/HrqrDJ8k3A
         z1z3cQ2uISoTaN9SScJuy2n2z9RARqH3lPn6kWrnT7wpWAJL3eI1G/SPOlFCFXKVCiR5
         GnT9Oq2REPUnFkmRQ8Tuthmd4vU6zDn9jqil/9d6mVXAyUplobUyphG6zilIsEfTLrsI
         PePOGuzawq687C8cedmwN2qOzAikP/LP38B/tNziFP7xMMUUAO+c8At0Ti8QI1E5wVff
         OQV89Ordv9YCmZ8Tl230Edq5jqUxF1zCP5ZMU7zydSNU8zydOvj96OKBL2FzyTfU8TJo
         IEUA==
X-Gm-Message-State: AFqh2kruCopS50+QOyI8/tGRiB2ZYulo/LwhYegqEU0gTDYHyl8wd931
        OYYe3u0SKt/kBCfhDNjrdgELnFLcakI=
X-Google-Smtp-Source: AMrXdXt1W0FCVYI6Ds8XPem5Y00OT1vi5ZKC2hWyTza8JK4aoF1wAL8MxCcL/23cdA4BUt9nkwcvZg==
X-Received: by 2002:a05:600c:2252:b0:3d3:5d8b:7af with SMTP id a18-20020a05600c225200b003d35d8b07afmr39112774wmm.41.1672917811517;
        Thu, 05 Jan 2023 03:23:31 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 05/10] io_uring: parse check_cq out of wq waiting
Date:   Thu,  5 Jan 2023 11:22:24 +0000
Message-Id: <9dfcec3121013f98208dbf79368d636d74e1231a.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
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

We already avoid flushing overflows in io_cqring_wait_schedule() but
only return an error for the outer loop to handle it. Minimise it even
further by moving all ->check_cq parsing there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bb3e9889717..067e3577ac9b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2468,21 +2468,13 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  ktime_t *timeout)
 {
 	int ret;
-	unsigned long check_cq;
 
+	if (unlikely(READ_ONCE(ctx->check_cq)))
+		return 1;
 	/* make sure we run task_work before checking for signals */
 	ret = io_run_task_work_sig(ctx);
 	if (ret || io_should_wake(iowq))
 		return ret;
-
-	check_cq = READ_ONCE(ctx->check_cq);
-	if (unlikely(check_cq)) {
-		/* let the caller flush overflows, retry */
-		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-			return 1;
-		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
-			return -EBADR;
-	}
 	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 
@@ -2548,13 +2540,25 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
-			finish_wait(&ctx->cq_wait, &iowq.wq);
-			io_cqring_do_overflow_flush(ctx);
-		}
+		unsigned long check_cq;
+
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+
+		check_cq = READ_ONCE(ctx->check_cq);
+		if (unlikely(check_cq)) {
+			/* let the caller flush overflows, retry */
+			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)) {
+				finish_wait(&ctx->cq_wait, &iowq.wq);
+				io_cqring_do_overflow_flush(ctx);
+			}
+			if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)) {
+				ret = -EBADR;
+				break;
+			}
+		}
+
 		if (__io_cqring_events_user(ctx) >= min_events)
 			break;
 		cond_resched();
-- 
2.38.1

