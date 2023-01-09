Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F04662903
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbjAIOvb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbjAIOvL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:11 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680541EAC1
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:34 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ss4so13419058ejb.11
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=044SK/jIYqht5aLvZ5M6vMX/a8GVtEexKNEoV10/0T8=;
        b=qHb284//Era/CPs1rkp6Dmy6XDEqx15zi0Kbil8IyOx6UCh3DGEZTCvvuFsBAJsOXz
         QrSqMCM5uzpezfQjpdagZQnj+o9yRzTaxjLnpHWY6Tu8tQ94ogChWhgo88pkie6jyCyy
         iyUBU+rTsUpvZIwI202wINtvRz0wSdrSiRn5z4P+QD9vMMNEbkIwLJIgsBcMFQ+SreVW
         duxgZ0yz9G9Ae3b/q108ffsaHepQf4WmO41V77qmiIjlaERCpvdmP5XOCyd/tl7FRAzR
         PGH7YwTzFzjIESLpSC4RRqzOmhCMbdzHFAFA5SGmmnV9fcCIx4/Qm59DkLO3OkHQZjvN
         n3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=044SK/jIYqht5aLvZ5M6vMX/a8GVtEexKNEoV10/0T8=;
        b=vxZvu6duk+6gNxsTGfgpoWqHMnf7Fz/non0TgcbPHf8snotgddEjn5BVZ/7/+KVRxu
         f17TMTizHSzre58dia83ylhubZyOutoo0Htxt6kKW822firUhTsF/8PyaFAwUpiS9Jxh
         OOccyrpCR+w8e6gJDZJ8MBiMxoYx840bgKC+I2D0s4QnQn7z7Xu0SsU0WcTJpHPYkyx7
         moCqqEUK5ZnGUwrnQaTY7wqvvaXF5BEOcTN98DbhH6S/4eDSE75v1EJiW7UuocffRD4B
         VowGYXhZSJ+x2GRX+qEkVrthp5GIMBhhXpOpoHKJ/bVBdifSglag2MnWokQzFzhc5kF7
         16Dw==
X-Gm-Message-State: AFqh2krQVN14VeijhO3NZVh5QzFpuV1pplqMashhvKfUyqmKaxX2fgnG
        ugLru0bNg2YJG+ynZ0HbOACR4DsIyqM=
X-Google-Smtp-Source: AMrXdXtaE59CQwoXHXgd8lIUWw7RnFIsMQYwU7PQXqVJEn9BpfGODmoN1lfljKYZv24ds070k5i3hQ==
X-Received: by 2002:a17:907:d50e:b0:81f:fc05:2ba0 with SMTP id wb14-20020a170907d50e00b0081ffc052ba0mr56263572ejc.2.1673275652857;
        Mon, 09 Jan 2023 06:47:32 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 05/11] io_uring: move io_run_local_work_locked
Date:   Mon,  9 Jan 2023 14:46:07 +0000
Message-Id: <91757bcb33e5774e49fed6f2b6e058630608119b.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
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

io_run_local_work_locked() is only used in io_uring.c, move it there.
With that we can also make __io_run_local_work() static.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 18 +++++++++++++++++-
 io_uring/io_uring.h | 17 -----------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5b62386413d9..c251acf0964e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1296,7 +1296,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 	}
 }
 
-int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
+static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 {
 	struct llist_node *node;
 	struct llist_node fake;
@@ -1337,6 +1337,22 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 
 }
 
+static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
+{
+	bool locked;
+	int ret;
+
+	if (llist_empty(&ctx->work_llist))
+		return 0;
+
+	locked = true;
+	ret = __io_run_local_work(ctx, &locked);
+	/* shouldn't happen! */
+	if (WARN_ON_ONCE(!locked))
+		mutex_lock(&ctx->uring_lock);
+	return ret;
+}
+
 static int io_run_local_work(struct io_ring_ctx *ctx)
 {
 	bool locked = mutex_trylock(&ctx->uring_lock);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 78896d1f7916..b5975e353aa1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -28,7 +28,6 @@ enum {
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
 bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
-int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
@@ -283,22 +282,6 @@ static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
 }
 
-static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
-{
-	bool locked;
-	int ret;
-
-	if (llist_empty(&ctx->work_llist))
-		return 0;
-
-	locked = true;
-	ret = __io_run_local_work(ctx, &locked);
-	/* shouldn't happen! */
-	if (WARN_ON_ONCE(!locked))
-		mutex_lock(&ctx->uring_lock);
-	return ret;
-}
-
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
-- 
2.38.1

