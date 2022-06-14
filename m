Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6162354B3A9
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349561AbiFNOiN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbiFNOiH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B0AB7F2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:05 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o8so11589460wro.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5V/K45g9wpqoJNn9BXBkT927aYIh71OeYAeKJeObVFk=;
        b=Gy5vuXnuP7saIwdahAkXjinI/Yd+KNxa/Vwmt/ZfnMfWL0on4K+XRJ8gyOlrBmvML/
         H/0aCjCW53VtxPraDoIrnOyIeb+SNMtshDMJLqnr2BWNjNFqe1siqaWOaB3o6cBsLY2P
         7z8fZqP+/DjHuLMu+RuomszlxuyAcsrghvp+Tq/LYBkHVzqBQiYapepY+ob1SIPzpOzt
         p3QDj2ePy5EFmoNpbZWul46VZHTlnnFkDgbuFepFCWkH2TKcPa+d+YGuxT8/7rReGvph
         jHUHBOSUZ8+w5/H3tIeQYLjumHgmrCao4DvEkzHTmLH/DPXcrPCiBaqPZcpsCtNBhZvo
         MV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5V/K45g9wpqoJNn9BXBkT927aYIh71OeYAeKJeObVFk=;
        b=VOEu3j7EsSv+dWJCVCDzukby54YQerpDRbuM6ReC3r3g8gHXO7rlkYe6Wb6aNgixv3
         /9qC3oaFbuU2txUCRgV7Zno+0XSCGp4SISMWCmjmmKiV9nrziJRDGsTeZFyf5V6GBlbT
         /9TRN7nygrQSycNK5bZwXxTO04BLuSrtrcWGMcFVRZCz4U+v/JumLxC79ahhf1UF+3u8
         7E+mUpufSvvmqyXjs2f4qQ7sVerYI6Hkea+vVfGHoPJl3U3VwrXRf+LOfWODkJ4TFXgG
         uzXTq1mf2NFwpjURtr+p0B38SCEbag5oP82KrTuPoAFBmmWZTxf6Nf2kItmbGBG4xGyY
         BogQ==
X-Gm-Message-State: AJIora/v6Y/F6FKrKyc6fzE0P2QcaH1B06wpL9DxnhBUZuAJPxIxD3f3
        he8gYAX4dRMLNg/M71grw0alwZAwRaZqDw==
X-Google-Smtp-Source: AGRyM1vUEPnhNRN4BsQTN+dWMQg/ky6jIyssdgWeRupGHZjbzeMCNoVh6b//qJgqks4e8Nuc06PRTQ==
X-Received: by 2002:a5d:6da9:0:b0:218:5b98:41b with SMTP id u9-20020a5d6da9000000b002185b98041bmr5259986wrs.111.1655217485062;
        Tue, 14 Jun 2022 07:38:05 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:38:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 22/25] io_uring: pass hash table into poll_find
Date:   Tue, 14 Jun 2022 15:37:12 +0100
Message-Id: <f50857b475700c645340f3b7502711370a298bc7.1655213915.git.asml.silence@gmail.com>
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

