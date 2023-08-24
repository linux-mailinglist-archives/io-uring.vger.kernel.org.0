Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003AF787BB5
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243951AbjHXWzn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244019AbjHXWzb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:31 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1BE1FDE
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:22 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-99c136ee106so32795366b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917720; x=1693522520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1G/AFWb5iyL48Qc9HzbF86s/wLNrCJOiAeFSM8nteRg=;
        b=DE0tfFnKkSWmAzFBZznvuhWTz2UgV06UcLKMpMRcLOIVopjcz3MXyL9DqlFByol85M
         RsDvdZZRge1qKqG20DehxcDZscooQzHQ6kiQ50gIjIng+Z+XEKh5GntkxRqr30/4dVFt
         FSbOtX6yHc9Bl3uOLuHDPFlqKDONV5aCaj69+3EvramxgKzbMJ+12/gA4Fo+YhqcNX9X
         UMFwU50XHBrd6wpV/7FoeWr6lV8+QHmry7mNeXT/w5q7rWgzCKhCvSsb2CFRawjECmiL
         iAdAf0f6z6nXJo4wptHXZz6MO0AQSJt8dsQXaWpKMmNtjaCLx355PozJlqngHp3MCsS2
         wF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917720; x=1693522520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1G/AFWb5iyL48Qc9HzbF86s/wLNrCJOiAeFSM8nteRg=;
        b=EHlNab1Zm8EBcBhMCuaolbDAbYopTxugESlIvDUdm07pAUo7Dl1Zcu2z1ieJVn6fbf
         +kCWv6Y0/jgetsP0EY0nU2iUkRak9UyEn1IfiM36Qp9WntFy1vIc4SVi8yfvOOfoBMWL
         Jtc9Yi0GY4KwtSf3tZ75QhKH6uwz7slTaIcFYqVgZSC8IZnrZDSd6IUi9WuZdONFw1nk
         tYuI/2LNgQmX3grtffvE6y5gSme+2e+SxjI8Owfxwy0jasB2LX3rMIOgWa1puB2QCj9x
         dUU3QfN+TOf/pXClACUKhU8NRuHCOwnSuTcryV9XUa4nLANpLBzrPTiSzLVFc1XlRtZ5
         Ax4w==
X-Gm-Message-State: AOJu0YwY8yJI/nv4Ci/pDkyTnS3Zryyuypq4sDmrHbSjlbi9L1CY7G8k
        l4AwWxvCLFJ+K0OZqa6aTM/Z6JMPkkg=
X-Google-Smtp-Source: AGHT+IF9jUv0l9seJq+bCEq8PmDkvGQsZ5stZ62x46MhR29Wh+cRoKsIcI68BlnOwu+oo+5fednBig==
X-Received: by 2002:a17:906:7699:b0:9a2:1e03:1573 with SMTP id o25-20020a170906769900b009a21e031573mr2187838ejm.65.1692917720332;
        Thu, 24 Aug 2023 15:55:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 03/15] io_uring: simplify big_cqe handling
Date:   Thu, 24 Aug 2023 23:53:25 +0100
Message-ID: <447aa1b2968978c99e655ba88db536e903df0fe9.1692916914.git.asml.silence@gmail.com>
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

Don't keep big_cqe bits of req in a union with hash_node, find a
separate space for it. It's bit safer, but also if we keep it always
initialised, we can get rid of ugly REQ_F_CQE32_INIT handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 16 ++++++----------
 io_uring/io_uring.c            |  8 +++-----
 io_uring/io_uring.h            | 15 +++------------
 io_uring/uring_cmd.c           |  5 ++---
 4 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f04ce513fadb..9795eda529f7 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -409,7 +409,6 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
-	REQ_F_CQE32_INIT_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
 	REQ_F_HASH_LOCKED_BIT,
@@ -479,8 +478,6 @@ enum {
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 	/* fast poll multishot mode */
 	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
-	/* ->extra1 and ->extra2 are initialised */
-	REQ_F_CQE32_INIT	= BIT(REQ_F_CQE32_INIT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
 	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
@@ -579,13 +576,7 @@ struct io_kiocb {
 	struct io_task_work		io_task_work;
 	unsigned			nr_tw;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-	union {
-		struct hlist_node	hash_node;
-		struct {
-			u64		extra1;
-			u64		extra2;
-		};
-	};
+	struct hlist_node		hash_node;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
@@ -595,6 +586,11 @@ struct io_kiocb {
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
 	struct io_wq_work		work;
+
+	struct {
+		u64			extra1;
+		u64			extra2;
+	} big_cqe;
 };
 
 struct io_overflow_cqe {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3e0fe1ebbc10..0aeb33256a6d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -807,13 +807,10 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 
 void io_req_cqe_overflow(struct io_kiocb *req)
 {
-	if (!(req->flags & REQ_F_CQE32_INIT)) {
-		req->extra1 = 0;
-		req->extra2 = 0;
-	}
 	io_cqring_event_overflow(req->ctx, req->cqe.user_data,
 				req->cqe.res, req->cqe.flags,
-				req->extra1, req->extra2);
+				req->big_cqe.extra1, req->big_cqe.extra2);
+	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 }
 
 /*
@@ -1057,6 +1054,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	req->async_data = NULL;
 	/* not necessary, but safer to zero */
 	memset(&req->cqe, 0, sizeof(req->cqe));
+	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 }
 
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 465598223386..9b5dfb6ef484 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -148,21 +148,12 @@ static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx, struct io_kiocb *req
 	if (trace_io_uring_complete_enabled())
 		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
 					req->cqe.res, req->cqe.flags,
-					(req->flags & REQ_F_CQE32_INIT) ? req->extra1 : 0,
-					(req->flags & REQ_F_CQE32_INIT) ? req->extra2 : 0);
+					req->big_cqe.extra1, req->big_cqe.extra2);
 
 	memcpy(cqe, &req->cqe, sizeof(*cqe));
-
 	if (ctx->flags & IORING_SETUP_CQE32) {
-		u64 extra1 = 0, extra2 = 0;
-
-		if (req->flags & REQ_F_CQE32_INIT) {
-			extra1 = req->extra1;
-			extra2 = req->extra2;
-		}
-
-		WRITE_ONCE(cqe->big_cqe[0], extra1);
-		WRITE_ONCE(cqe->big_cqe[1], extra2);
+		memcpy(cqe->big_cqe, &req->big_cqe, sizeof(*cqe));
+		memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 	}
 	return true;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8e7a03c1b20e..537795fddc87 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -43,9 +43,8 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);
 static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 					  u64 extra1, u64 extra2)
 {
-	req->extra1 = extra1;
-	req->extra2 = extra2;
-	req->flags |= REQ_F_CQE32_INIT;
+	req->big_cqe.extra1 = extra1;
+	req->big_cqe.extra2 = extra2;
 }
 
 /*
-- 
2.41.0

