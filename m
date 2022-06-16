Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F6B54DE18
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376608AbiFPJWy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376598AbiFPJWx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C67212AA8
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:51 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v14so1047874wra.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=whmbV8SR6MxGfqcouaajDpb1UgDnXjtmeXGDkViNhtk=;
        b=hEhHNNPyPcojnH8NSTzWJtjEbPkBmJeG8eLtS51yz2etRQKNmS0zfOUPn/NJdM/Mtt
         eyuC561y9aA642aCcOv+TFW9NFHzs+2tckN+2REjcHo8RWXKSU46WkN0KWZlzT2KpbLG
         gtWtw4Aff31PZDc3JJFk9oeZdAYUhpyHa3BwpvS9JvkSky7gzKaeq5cLhnnJ54zVahCN
         SF2J+cQIbsdQiMpybnZ8VfmlYPJoLTOPyhfIYLUu06RjHfONRsEuLUlD5z2uOVh036Bj
         cKaYPt8ULC1G5/+YYPzU2sxh7Vjc5tBGO/93GFAGBGYP0KskHiUMTK8amg7tLbV6IlkQ
         JxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whmbV8SR6MxGfqcouaajDpb1UgDnXjtmeXGDkViNhtk=;
        b=7jJGCiifLSYV9i+XiIoMmb+WDorlHLCjxrnDuJR6s8XdHOfQoVQLGjXi+SvM66vMP+
         IcNN0FDUCEeefCH3sGy2hEZvIBmhilKxt+DRViyFabUR4ypp0SuVWwiA9wtaBU069tVD
         11wFWS36dBj+p3FF5otydrNNzi0aIac9gEFgj+hySznENOABNsr7PP4nAI7q6IC6N7sV
         A6mqECpEirfnvrkGSC1/PATKcsX1bBFdWD1cab7ZCsnMCuBy1m25ZJ+ckB/tGwBx97zr
         trZziBIS2ne8CGWQh1UkrzT9K/pJFYDddAd4AT3JEsya6jruI23LVvRcsYWsedHnnZ+/
         sltg==
X-Gm-Message-State: AJIora8+Lul0vjb/7BdmtLXgn5YRL34CW0G/CloOT8npdGRSEmANicW8
        QWqsvch+Tnwoa/BZHkrBqKf7QfsKIRVUKQ==
X-Google-Smtp-Source: AGRyM1voXqs0XuKkli5bCNjrGzgT0qydjVlg9okjnvtnIb9QI5itkkKNlHlxsNzcwt3iYUyRGFCarg==
X-Received: by 2002:a5d:4a88:0:b0:214:1e17:9993 with SMTP id o8-20020a5d4a88000000b002141e179993mr3610401wrq.608.1655371370561;
        Thu, 16 Jun 2022 02:22:50 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 07/16] io_uring: pass poll_find lock back
Date:   Thu, 16 Jun 2022 10:22:03 +0100
Message-Id: <dae1dc5749aa34367812ecf62f82fd3f053aae44.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

