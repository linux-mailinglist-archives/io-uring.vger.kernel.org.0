Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B2354F384
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381208AbiFQItn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381133AbiFQItm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:49:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD5F694B0
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:41 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id h23so7446056ejj.12
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c9REikkLKeJODwzy/5B/Fp1pXzka/2vpEOf5uX3trvc=;
        b=MfH7y3BF8SpdNY4QYgJt74/4Qy1Kwgsip/rumJ6Jm/sephcxvvauXGf+jNnRsLEJhq
         Ew6Mbl3eBiE1xqraNf9+Li3EZo5biOrdJRO4uKiRV8fNyDORPkA+Q9avEA09/MH1ivj/
         Kh5d6ktt2AXMXO1QFfEKs9WxmzrgiIsAXqwf28o0QYxty1Z92vR1XQ0IkKnT3Wxe5kat
         y19tkRc7YGz2yY7o/kDeOJo+KHsEGJeUBB7FS5c+JJnSmktapLs2m/3ZXAHtCixgGzsv
         A68JB2Ttq6W4blONqqm/kS6TZMdnbm7jigEXOuTtOhFbC27D1LvHce0HEecTxr49c4bL
         drdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c9REikkLKeJODwzy/5B/Fp1pXzka/2vpEOf5uX3trvc=;
        b=53zI2b1M/j6HaUNhX98DnW2q0DTlmei3saAIZNCXjicJNTUKv0i4FrVrMUHnKJwlDo
         IGAMbOfnsNfgimZlUCZKqmxpb+ij7QJb7e3UfXUSiTmfSUyDCW49MejbgzE+ETBnCQ22
         e9Kml4rIvfrTnFYPyArPQcLdOWTl1COW9AaMmEFo+NTDHY7rWi+XUn/R/BS5JHblDRPe
         DzuHzRCilBntPMwXr9glUVAGJrC/Zd5pc/vwW9spcjow+VhvLp8s0LHWtC4FINojNdnt
         GsKHrgNRXUY9aq1QxUoV/hHDja9ZdIOqogcp4tathQXF5loROWllsuYaDwgvnmwrcHyY
         Cpng==
X-Gm-Message-State: AJIora/d6TAxoWhrnaJfsc2d9WyUIAkpngpMCG4hAu6JPE2vOjMokkq3
        9PP37FdQ+5bmVxzSADUjA57YKwCQdWvZSw==
X-Google-Smtp-Source: AGRyM1vn+C6E6NN2a/8WGX5ANpEvDuo8dYUBg+INfmrhNRhT3zP6imLf9MHkPCGOv5hCEqPX9l1XHQ==
X-Received: by 2002:a17:907:6294:b0:6e1:ea4:74a3 with SMTP id nd20-20020a170907629400b006e10ea474a3mr8054947ejc.168.1655455779950;
        Fri, 17 Jun 2022 01:49:39 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709060b1100b006ff52dfccf3sm1851895ejg.211.2022.06.17.01.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:49:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/6] io_uring: don't expose io_fill_cqe_aux()
Date:   Fri, 17 Jun 2022 09:48:00 +0100
Message-Id: <b7c6557c8f9dc5c4cfb01292116c682a0ff61081.1655455613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455613.git.asml.silence@gmail.com>
References: <cover.1655455613.git.asml.silence@gmail.com>
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

Deduplicate some code and add a helper for filling an aux CQE, locking
and notification.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 18 ++++++++++++++++--
 io_uring/io_uring.h |  3 +--
 io_uring/msg_ring.c | 11 +----------
 io_uring/net.c      | 20 +++++---------------
 io_uring/poll.c     | 24 ++++++++----------------
 io_uring/rsrc.c     | 14 +++++---------
 6 files changed, 36 insertions(+), 54 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 80c433995347..7ffb8422e7d0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -673,8 +673,8 @@ bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return true;
 }
 
-bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
-		     u32 cflags)
+static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,
+			    u64 user_data, s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -701,6 +701,20 @@ bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 }
 
+bool io_post_aux_cqe(struct io_ring_ctx *ctx,
+		     u64 user_data, s32 res, u32 cflags)
+{
+	bool filled;
+
+	spin_lock(&ctx->completion_lock);
+	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	if (filled)
+		io_cqring_ev_posted(ctx);
+	return filled;
+}
+
 static void __io_req_complete_put(struct io_kiocb *req)
 {
 	/*
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 16e46b09253a..ce6538c9aed3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -241,8 +241,7 @@ void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 void __io_req_complete_post(struct io_kiocb *req);
-bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
-		     u32 cflags);
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_cqring_ev_posted(struct io_ring_ctx *ctx);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 1f2de3534932..b02be2349652 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -33,7 +33,6 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req);
 	struct io_ring_ctx *target_ctx;
-	bool filled;
 	int ret;
 
 	ret = -EBADFD;
@@ -42,16 +41,8 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = -EOVERFLOW;
 	target_ctx = req->file->private_data;
-
-	spin_lock(&target_ctx->completion_lock);
-	filled = io_fill_cqe_aux(target_ctx, msg->user_data, msg->len, 0);
-	io_commit_cqring(target_ctx);
-	spin_unlock(&target_ctx->completion_lock);
-
-	if (filled) {
-		io_cqring_ev_posted(target_ctx);
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
 		ret = 0;
-	}
 
 done:
 	if (ret < 0)
diff --git a/io_uring/net.c b/io_uring/net.c
index cd931dae1313..4481deda8607 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -647,22 +647,12 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		io_req_set_res(req, ret, 0);
 		return IOU_OK;
 	}
-	if (ret >= 0) {
-		bool filled;
-
-		spin_lock(&ctx->completion_lock);
-		filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
-					 IORING_CQE_F_MORE);
-		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
-		if (filled) {
-			io_cqring_ev_posted(ctx);
-			goto retry;
-		}
-		ret = -ECANCELED;
-	}
 
-	return ret;
+	if (ret < 0)
+		return ret;
+	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE))
+		goto retry;
+	return -ECANCELED;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7f245f5617f6..d4bfc6d945cf 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -213,23 +213,15 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 			__poll_t mask = mangle_poll(req->cqe.res &
 						    req->apoll_events);
-			bool filled;
-
-			spin_lock(&ctx->completion_lock);
-			filled = io_fill_cqe_aux(ctx, req->cqe.user_data,
-						 mask, IORING_CQE_F_MORE);
-			io_commit_cqring(ctx);
-			spin_unlock(&ctx->completion_lock);
-			if (filled) {
-				io_cqring_ev_posted(ctx);
-				continue;
-			}
-			return -ECANCELED;
-		}
 
-		ret = io_poll_issue(req, locked);
-		if (ret)
-			return ret;
+			if (!io_post_aux_cqe(ctx, req->cqe.user_data,
+					     mask, IORING_CQE_F_MORE))
+				return -ECANCELED;
+		} else {
+			ret = io_poll_issue(req, locked);
+			if (ret)
+				return ret;
+		}
 
 		/*
 		 * Release all references, retry if someone tried to restart
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2f893e3f5c15..c10c512aa71b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -173,17 +173,13 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 		list_del(&prsrc->list);
 
 		if (prsrc->tag) {
-			if (ctx->flags & IORING_SETUP_IOPOLL)
+			if (ctx->flags & IORING_SETUP_IOPOLL) {
 				mutex_lock(&ctx->uring_lock);
-
-			spin_lock(&ctx->completion_lock);
-			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
-			io_commit_cqring(ctx);
-			spin_unlock(&ctx->completion_lock);
-			io_cqring_ev_posted(ctx);
-
-			if (ctx->flags & IORING_SETUP_IOPOLL)
+				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
 				mutex_unlock(&ctx->uring_lock);
+			} else {
+				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
+			}
 		}
 
 		rsrc_data->do_put(ctx, prsrc);
-- 
2.36.1

