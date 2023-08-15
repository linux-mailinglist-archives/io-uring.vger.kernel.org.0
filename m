Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D6477D12C
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbjHORdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbjHORd1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:27 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CB011A
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:25 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4fe94dde7d7so7527386e87.3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120804; x=1692725604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpaAHUyNNg2kIgP5vy8SQO2UtTfI3jq3CqcwchLqWvo=;
        b=oza1p8J5Ie7cS6Sgm0RcjoCY1JzI4hlyapHxx8OrAqZ2ZzeBZ58HOQi8w3rhr8G9jb
         /TArgKTr/RxsMLy9o+vg+SdySGXMG41MhC1HfVeGriDqSDYc1zdFY4gVWncp+eQWqZQS
         uHmgQXw73uU5eds67Zrd8EDq3tHZ4OtbeOY7Kd8CGIJNmHB3vK0NdcOqCYdUnS9X30el
         +nbQGtDvoNnLYb9r0WOSyTMUxwfF/8y5gQ5cVJuWOz6fVXHcB9KFvJEUWX4u9gFA0CjC
         AwpqUpKX1778hNsAfvDNCV+Tc468j3N2eJZQLzBEPD82jY/bLfnpwNmxrtGII5METsmW
         s1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120804; x=1692725604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpaAHUyNNg2kIgP5vy8SQO2UtTfI3jq3CqcwchLqWvo=;
        b=KsoiXJQFncRtFjsvEJG0Jw+5kwC54YufL341ym3mFbyXY6Htss/o51ZdqHEhIMDPLK
         0CFRXnvE1vF2WUTGFErJ0r7vZ7dgRfFIEQWSq8QqUZt4uSu5K8zpLNYN2k9Ob8KOR+NB
         zgqzpVg431RTgdukJv2PvX16oQDC70QX/9TjyXTo90hz7hI60+Q2f0MYGfH28l8T47id
         Xn9OSK9q9LNgKkw84PTNEhRpsSsR30X6x9EBCgYWN8Nu74UYNxDFV4cm7GdefoTwc1XV
         Lh03HS/LSw16dlZPjtC9Tl6KRrSuQntes0vyZCRumXKraWcd5Tm9SBt8JbHCt935P+Ov
         v8EQ==
X-Gm-Message-State: AOJu0YwcgXJnQd21ataElgpxHjXLQ1tZU8xP3aHb62SOWkuM1tqFZv+K
        CZ+Baos9D40X6qu4Lr1yuL2VI08iOVI=
X-Google-Smtp-Source: AGHT+IEgOAQs9n/lJ4HU+8t12Hr535cBotn9CduqJtXnULqSX6/zA+eyI0mxOpsxJjyS0BhXzwY+Zg==
X-Received: by 2002:a05:6512:12c3:b0:4fb:8bcd:acd4 with SMTP id p3-20020a05651212c300b004fb8bcdacd4mr11077297lfg.37.1692120803716;
        Tue, 15 Aug 2023 10:33:23 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 14/16] io_uring: move multishot cqe cache in ctx
Date:   Tue, 15 Aug 2023 18:31:43 +0100
Message-ID: <4dae5652bc608b131ef5d79a3cb1f671e16193e1.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
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

We cache multishot CQEs before flushing them to the CQ in
submit_state.cqe. It's a 16 entry cache totalling 256 bytes in the
middle of the io_submit_state structure. Move it out of there, it
should help with CPU caches for the submission state, and shouldn't
affect cached CQEs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 3 ++-
 io_uring/io_uring.c            | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 5de5dffe29df..01bdbc223edd 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -176,7 +176,6 @@ struct io_submit_state {
 	unsigned short		submit_nr;
 	unsigned int		cqes_count;
 	struct blk_plug		plug;
-	struct io_uring_cqe	cqes[16];
 };
 
 struct io_ev_fd {
@@ -307,6 +306,8 @@ struct io_ring_ctx {
 		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
+	struct io_uring_cqe	completion_cqes[16];
+
 	/* IRQ completion list, under ->completion_lock */
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c39606740c73..5b13d22d1b76 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -883,7 +883,7 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
 
 	lockdep_assert_held(&ctx->uring_lock);
 	for (i = 0; i < state->cqes_count; i++) {
-		struct io_uring_cqe *cqe = &state->cqes[i];
+		struct io_uring_cqe *cqe = &ctx->completion_cqes[i];
 
 		if (!io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags)) {
 			if (ctx->task_complete) {
@@ -934,7 +934,7 @@ bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->submit_state.cqes)) {
+	if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->completion_cqes)) {
 		__io_cq_lock(ctx);
 		__io_flush_post_cqes(ctx);
 		/* no need to flush - flush is deferred */
@@ -948,7 +948,7 @@ bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
 	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
 		return false;
 
-	cqe = &ctx->submit_state.cqes[ctx->submit_state.cqes_count++];
+	cqe = &ctx->completion_cqes[ctx->submit_state.cqes_count++];
 	cqe->user_data = user_data;
 	cqe->res = res;
 	cqe->flags = cflags;
-- 
2.41.0

