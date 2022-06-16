Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0086554DE1D
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376668AbiFPJXC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376655AbiFPJXA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:23:00 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ACC193E3
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:58 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso534752wml.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5V/K45g9wpqoJNn9BXBkT927aYIh71OeYAeKJeObVFk=;
        b=RlquVMAPlEOISo16lDxOP4xOacXdN+leilPiO/Lk4KZix4LB9WikcmcRs/X7DDvddg
         L3ja85OVVziR9M0OuHFe0CI+o0MCbZNCU/wF5EMFZe4sfTZkmRIA1ayF6bHrITCYwsHH
         fA75dfCvtJEnRNky32z4JjZErV3uXwJ2ciXhlNuwbK/tiaVBkrzIX62vvJ3FPRaTd8sv
         sgDWVs6din4XrMl80fFsuDrqjrddAVIujkaMs1+3wDeFl1dWcuj5MjTUjzWGkN1eN6Gn
         Ap8zrv0Ii8/0odF5+ozUVwDR/tz4Zjfam3gTjawIPuslflNMEtI9fhAPMQBLDlDEYOpq
         GY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5V/K45g9wpqoJNn9BXBkT927aYIh71OeYAeKJeObVFk=;
        b=iv0lSfPQerfB52nFOpGskq6+Tu48iTwDf6TRhKjbuKLzUxD/0a8WfhCNJHP3AXo01T
         34KfL1nUSs0J4totf80aEJZpn7T+rSGNDJBMABzFXcIYUhFPMi3q+C3RPgQW6Ju2pRy2
         L3EOc9IWwuM4cs1vRN4arYE8isN9YDVhAl4EMma0lAZvxfppmnXxPKdK2DvHZhE0+3uO
         kNvbBjE2zGwGKh0SN5W1UUDBlUNVHbt3+vmalfITp8QmFI5SfuUzjtk3NUFvuuPeu10r
         dEfNm7O/EWhHo7YCwkoSwHyzskgQZ7jQmwl2QMIjmV3Xxm/pYLl102hmiMtLV9fkz8TD
         LHLA==
X-Gm-Message-State: AJIora9VPtNNHto6HcjOQAe35tSVs5GDN9LgkfojVlCvbht5LoKXhWWH
        EHBaQRdU7Z6AgCcySDgqmbvPXvvL1MAe6A==
X-Google-Smtp-Source: AGRyM1ugt6JI3aGYVI9UPAlUPBjFc0pPKRZuyYv+a4tfnunKMCA+jNTakE9eRUOy/oOBOAf3UgOKbQ==
X-Received: by 2002:a05:600c:3c8f:b0:39b:808c:b5cb with SMTP id bg15-20020a05600c3c8f00b0039b808cb5cbmr3918015wmb.11.1655371377244;
        Thu, 16 Jun 2022 02:22:57 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 13/16] io_uring: pass hash table into poll_find
Date:   Thu, 16 Jun 2022 10:22:09 +0100
Message-Id: <a31c88502463dce09254240fa037352927d7ecc3.1655371007.git.asml.silence@gmail.com>
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

In preparation for having multiple cancellation hash tables, pass a
table pointer into io_poll_find() and other poll cancel functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index c4ce98504986..5cc03be365e3 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -556,11 +556,12 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				     struct io_cancel_data *cd,
+				     struct io_hash_bucket hash_table[],
 				     struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
 	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
-	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
+	struct io_hash_bucket *hb = &hash_table[index];
 
 	*out_bucket = NULL;
 
@@ -584,6 +585,7 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 					  struct io_cancel_data *cd,
+					  struct io_hash_bucket hash_table[],
 					  struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
@@ -592,7 +594,7 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 	*out_bucket = NULL;
 
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
+		struct io_hash_bucket *hb = &hash_table[i];
 
 		spin_lock(&hb->lock);
 		hlist_for_each_entry(req, &hb->list, hash_node) {
@@ -619,15 +621,16 @@ static bool io_poll_disarm(struct io_kiocb *req)
 	return true;
 }
 
-int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
+static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+			    struct io_hash_bucket hash_table[])
 {
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
 	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
-		req = io_poll_file_find(ctx, cd, &bucket);
+		req = io_poll_file_find(ctx, cd, ctx->cancel_hash, &bucket);
 	else
-		req = io_poll_find(ctx, false, cd, &bucket);
+		req = io_poll_find(ctx, false, cd, ctx->cancel_hash, &bucket);
 
 	if (req)
 		io_poll_cancel_req(req);
@@ -636,6 +639,11 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	return req ? 0 : -ENOENT;
 }
 
+int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
+{
+	return __io_poll_cancel(ctx, cd, ctx->cancel_hash);
+}
+
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
 				     unsigned int flags)
 {
@@ -731,7 +739,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret2, ret = 0;
 	bool locked;
 
-	preq = io_poll_find(ctx, true, &cd, &bucket);
+	preq = io_poll_find(ctx, true, &cd, ctx->cancel_hash, &bucket);
 	if (preq)
 		ret2 = io_poll_disarm(preq);
 	if (bucket)
-- 
2.36.1

