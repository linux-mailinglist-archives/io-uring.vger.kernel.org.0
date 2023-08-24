Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B82F787BB9
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbjHXWzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244046AbjHXWzh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:37 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7491FDB
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:31 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2bc63e0d8cdso4250631fa.2
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917729; x=1693522529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5sBb2bmHDwDccJqKXBWjX6d3EaphhndG8TcXEkQq5wI=;
        b=Nl8FgFfn08R0vxUmcrgzBoQN84qwqOLyN9IkZrxdxca5CDd+Mmq6KxdVDJtv12V01+
         OQby5Qqysuqrae3tVJtK2F0bkK3Y8i+5UOFAOpzIe+2EPRtSTPvkm4WoyAYvGVvROdA3
         Gsopqn3nIyT06HBjjw3LbXiQvDwg+NNqVVBoOM8XRcSzyqXZ4hv3rHd7HmKLn+Cgx3Qg
         cR95f6MDMuCQcdbE5oY69Uogj3wDkB5/BRVMDOmnsfbzavwdifrgRyBlshacjHNVEMWq
         0+wWiBfueeiJZ8s6eqWPoF8DxRQD7oI/SqYftCCwXLFG7cTutezev9/tenvcyu2/Lpny
         VlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917729; x=1693522529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5sBb2bmHDwDccJqKXBWjX6d3EaphhndG8TcXEkQq5wI=;
        b=Y0o/uLNNSZB4zUmV374uv1lvuWRRkageoOL+/nd9l3qI8bFjwsEXgIzrgV+UEFOKY+
         ahFsYDjUWTHgW8K26lmI1ptdNRGhI/Li/Xmqpd1OGz7ChLa5vPOCGp5tMWtQGNLhK6+w
         +WDLUUpSkRagHc/Q1I3wwpyDma29jSewl5y+5eXIjGDwEO/djAyqFHtp/LFFpI7WfDRU
         TT9vchoMOfh5vrqAXsHd1pvipuemRnSePiaEIYZRcmFqNhdOSQGIgiMf0OwcpEvot/jJ
         lQkZQKuTjwt4h1buUzwd3/t6W3++/2bOtV+3zaSH2+twRKf/zDoyayWUP4UdQ2vvjJ16
         x58Q==
X-Gm-Message-State: AOJu0YwdZtYqp+SqgZ7q5AR/qCBPKAon9y0LiMSJqM2u8gtEYRDSp/O8
        2wc9S12PlrevXz8WAN3FdjPuyCxAfvw=
X-Google-Smtp-Source: AGHT+IHHvUvnoXru6w+Yr/noXB95LQT/495H9OaDVSUNJwZJZZEO/L0qyQsecstFzFhnR14aediXtA==
X-Received: by 2002:a05:651c:96:b0:2bc:c557:848a with SMTP id 22-20020a05651c009600b002bcc557848amr7779627ljq.50.1692917729332;
        Thu, 24 Aug 2023 15:55:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 14/15] io_uring: move multishot cqe cache in ctx
Date:   Thu, 24 Aug 2023 23:53:36 +0100
Message-ID: <dbe1f39c043ee23da918836be44fcec252ce6711.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
index a6eea3938802..88599852af82 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -880,7 +880,7 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
 
 	lockdep_assert_held(&ctx->uring_lock);
 	for (i = 0; i < state->cqes_count; i++) {
-		struct io_uring_cqe *cqe = &state->cqes[i];
+		struct io_uring_cqe *cqe = &ctx->completion_cqes[i];
 
 		if (!io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags)) {
 			if (ctx->task_complete) {
@@ -931,7 +931,7 @@ bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->submit_state.cqes)) {
+	if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->completion_cqes)) {
 		__io_cq_lock(ctx);
 		__io_flush_post_cqes(ctx);
 		/* no need to flush - flush is deferred */
@@ -945,7 +945,7 @@ bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
 	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
 		return false;
 
-	cqe = &ctx->submit_state.cqes[ctx->submit_state.cqes_count++];
+	cqe = &ctx->completion_cqes[ctx->submit_state.cqes_count++];
 	cqe->user_data = user_data;
 	cqe->res = res;
 	cqe->flags = cflags;
-- 
2.41.0

