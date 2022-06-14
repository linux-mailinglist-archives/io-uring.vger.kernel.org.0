Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2538B54B376
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244922AbiFNOiE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242898AbiFNOiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA951AF2C
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i81-20020a1c3b54000000b0039c76434147so117423wma.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=whmbV8SR6MxGfqcouaajDpb1UgDnXjtmeXGDkViNhtk=;
        b=ml6hj18Gg9XE9WmmpzC68rm4LQW3/uRnHRKUuce34X2rWc38sXbSGln2ZyQ9Qwx8qQ
         cxwTk+YQ3af9I4tt7b2fzh0SBZgIFe1aBkZA1Cfpbbpu2KaM6E9mfBt+xCLtr8keddf5
         ptc0YXDbHzgMUJNOSThlFLFI7PXfFZOwoWORdDcfQtExkk2m/+9A7S+W7fjNpzhFt9Mu
         H/+f8tV+QkpcXKB2rKZAvTio5qp4EerBXMNQm9eOADUUEF5JPphi5SJtyuU+8IZ0YlY0
         vGTC6ljQC0nEgPa2ErcFAZbzo41UmGXkKaooGLc/heF9dvHFNzD/csf7+BaqoaXHCqH2
         UAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whmbV8SR6MxGfqcouaajDpb1UgDnXjtmeXGDkViNhtk=;
        b=myynef0bYNzQf/HMERD6SoIJ2l6fAhVCO0UFlwedNJ2QB+TzUAQzynjv6BuufDviYq
         2FQywSj1pNGSM/XH2L4ekf5Tv/FLRS0DX88aikkj+5wP6ol7Ql30amFrJAFMiFYCNUsW
         +sDWFF/BASW09QuXpGAvy9AnN13CsXPj4Wp+sssSEYnEAJE2T68huNg0y8mdBfChm4wG
         p9+CsrNhxCxR+YV7kgmUus4u4ih3Cj5/QeT983fwoOzMGb7KJf4ATppa7n3eKsfs636j
         wmwMkpYz9tfEJqIyUGmadaE3ZRX/mhah+WmTMls+uLrkIiFKu8bUDetV1FWw6zklD265
         DVlQ==
X-Gm-Message-State: AOAM530UxNaUKVaW4J+0jSDKkV0TBCeF074JHMJXiWTiZaEECpbGM2WX
        zZJ/7xz8xrnqh/BO2Zi1Sq3j/pKC9C1ZfQ==
X-Google-Smtp-Source: ABdhPJycIoHugb4DJDZedtEG1zqbS5qWjPFoeAaCWknZbbQR3ZjB71e2ycxbA0DRKsqZdO3Y6PhsNQ==
X-Received: by 2002:a05:600c:2312:b0:397:7647:2ac4 with SMTP id 18-20020a05600c231200b0039776472ac4mr4383493wmo.125.1655217477679;
        Tue, 14 Jun 2022 07:37:57 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 16/25] io_uring: pass poll_find lock back
Date:   Tue, 14 Jun 2022 15:37:06 +0100
Message-Id: <c189e37df752d1acf74c50eaeb5aa563099c4ba3.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

Instead of using implicit knowledge of what is locked or not after
io_poll_find() and co returns, pass back a pointer to the locked
bucket if any. If set the user must to unlock the spinlock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7f6b16f687b0..7fc4aafcca95 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -559,12 +559,15 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
-				     struct io_cancel_data *cd)
+				     struct io_cancel_data *cd,
+				     struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
 	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
 	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
 
+	*out_bucket = NULL;
+
 	spin_lock(&hb->lock);
 	hlist_for_each_entry(req, &hb->list, hash_node) {
 		if (cd->data != req->cqe.user_data)
@@ -576,6 +579,7 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				continue;
 			req->work.cancel_seq = cd->seq;
 		}
+		*out_bucket = hb;
 		return req;
 	}
 	spin_unlock(&hb->lock);
@@ -583,11 +587,14 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 }
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
-					  struct io_cancel_data *cd)
+					  struct io_cancel_data *cd,
+					  struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
 	int i;
 
+	*out_bucket = NULL;
+
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
 
@@ -599,6 +606,7 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 			if (cd->seq == req->work.cancel_seq)
 				continue;
 			req->work.cancel_seq = cd->seq;
+			*out_bucket = hb;
 			return req;
 		}
 		spin_unlock(&hb->lock);
@@ -617,23 +625,19 @@ static bool io_poll_disarm(struct io_kiocb *req)
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
+	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
-	u32 index;
-	spinlock_t *lock;
 
 	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
-		req = io_poll_file_find(ctx, cd);
+		req = io_poll_file_find(ctx, cd, &bucket);
 	else
-		req = io_poll_find(ctx, false, cd);
-	if (!req) {
-		return -ENOENT;
-	} else {
-		index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
-		lock = &ctx->cancel_hash[index].lock;
-	}
-	io_poll_cancel_req(req);
-	spin_unlock(lock);
-	return 0;
+		req = io_poll_find(ctx, false, cd, &bucket);
+
+	if (req)
+		io_poll_cancel_req(req);
+	if (bucket)
+		spin_unlock(&bucket->lock);
+	return req ? 0 : -ENOENT;
 }
 
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
@@ -726,19 +730,21 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_poll_update *poll_update = io_kiocb_to_cmd(req);
 	struct io_cancel_data cd = { .data = poll_update->old_user_data, };
 	struct io_ring_ctx *ctx = req->ctx;
-	u32 index = hash_long(cd.data, ctx->cancel_hash_bits);
-	spinlock_t *lock = &ctx->cancel_hash[index].lock;
+	struct io_hash_bucket *bucket;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
 	bool locked;
 
-	preq = io_poll_find(ctx, true, &cd);
+	preq = io_poll_find(ctx, true, &cd, &bucket);
+	if (preq)
+		ret2 = io_poll_disarm(preq);
+	if (bucket)
+		spin_unlock(&bucket->lock);
+
 	if (!preq) {
 		ret = -ENOENT;
 		goto out;
 	}
-	ret2 = io_poll_disarm(preq);
-	spin_unlock(lock);
 	if (!ret2) {
 		ret = -EALREADY;
 		goto out;
-- 
2.36.1

