Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC87662909
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbjAIOvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbjAIOvQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:16 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237EE3E87D
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:45 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id cf18so14363075ejb.5
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht36KmsVzo7KCc1QVvOj8IAAQ1yudsZVITKpWhMsVEg=;
        b=I4jZ/1WlbMajhdpno6XRqIe2dtgzKvnP0Ij7gjPyGDZT8NCA1ehrGKw9vF4xcO2JDz
         0uVZ0vpVsW3tDrbMQQDeCJ3c0TE++RQnwIEPsC6tsztBePoKIJ8KnhNyBMRRXZfvy4f9
         1f2t9fJmp6v1YzxOaM1VUY7wbgdXdltKC+GgZTxjRrHJdTYZTHaqswpnNMvtaI17mE92
         KOBj/S4po13IQwhH5eUlfLg7nKTIQOPSLvnp+qHNe6MxAR7faM+eIyJqG8KZnh7LJsVr
         5dTVWGLDYmltZq9W0WgfWuoJD6rxcYMXQyF+3jHJsLXNZGba/K0mJGd8XMt5BEs72V0D
         hU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ht36KmsVzo7KCc1QVvOj8IAAQ1yudsZVITKpWhMsVEg=;
        b=hsnFCGpnQXTSqxDG9RXgi0EVLj/XoIBrSR9/Tvd+rd7mkfjGdC4aEw41yF/i3Eqmen
         txmXBWjeVhXoxVrvvjSXr1XGjdO79nD/p1Hb91QpqpBLcZ+0OowXFKj5HdN0b24BwGlJ
         jwmnzTMTGwvIpHIeQ8/eloZDbhUiytbgiutbR/NRjkStqmrRJjHklF5ic7qphyjgPTbi
         sMWkjtyLu2KLTunsuUwkw0OACRje7Wq5FGI8aDbm2D9qBsIFZvtuiz52Ns+dXdVpFgD9
         +4DEvOhJPyWmCvVkc0MVrhOOtWZG54pIfy/E1fqJLIiheO9ciF9/ZrZ9FlFefOmGi39i
         Mq5Q==
X-Gm-Message-State: AFqh2kohYvziOL4oJqI3L8oVH3/9IM4KoLH2WPdLMJoyxLvEY8955LDw
        1EjeYOLFZU9ZcqKYqtVHKDG5kzcs7+s=
X-Google-Smtp-Source: AMrXdXsWgPP1z1sU2mAFUHeLdG4D4iL5OwRMNOAGDwfwoTFizT4z8S+JuxpfCMp0pppmgzgI/vyNGQ==
X-Received: by 2002:a17:907:b686:b0:7c1:7c3a:ffba with SMTP id vm6-20020a170907b68600b007c17c3affbamr61202938ejc.35.1673275663588;
        Mon, 09 Jan 2023 06:47:43 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 11/11] io_uring: optimise deferred tw execution
Date:   Mon,  9 Jan 2023 14:46:13 +0000
Message-Id: <8839534891f0a2f1076e78554a31ea7e099f7de5.1673274244.git.asml.silence@gmail.com>
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

We needed fake nodes in __io_run_local_work() and to avoid unecessary wake
ups while the task already running task_works, but we don't need them
anymore since wake ups are protected by cq_waiting, which is always
cleared by the time we're executing deferred task_work items.

Note that because of loose sync around cq_waiting clearing
io_req_local_work_add() may wake the task more than once, but that's
fine and should be rare to not hurt perf.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9c95ceb1a9f2..1dd0fc0412c8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1322,17 +1322,16 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 {
 	struct llist_node *node;
-	struct llist_node fake;
-	struct llist_node *current_final = NULL;
+	unsigned int loops = 0;
 	int ret = 0;
-	unsigned int loops = 1;
 
 	if (WARN_ON_ONCE(ctx->submitter_task != current))
 		return -EEXIST;
-
-	node = io_llist_xchg(&ctx->work_llist, &fake);
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 again:
-	while (node != current_final) {
+	node = io_llist_xchg(&ctx->work_llist, NULL);
+	while (node) {
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
@@ -1341,23 +1340,14 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 		ret++;
 		node = next;
 	}
+	loops++;
 
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-
-	node = io_llist_cmpxchg(&ctx->work_llist, &fake, NULL);
-	if (node != &fake) {
-		loops++;
-		current_final = &fake;
-		node = io_llist_xchg(&ctx->work_llist, &fake);
+	if (!llist_empty(&ctx->work_llist))
 		goto again;
-	}
-
 	if (*locked)
 		io_submit_flush_completions(ctx);
 	trace_io_uring_local_work_run(ctx, ret, loops);
 	return ret;
-
 }
 
 static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
-- 
2.38.1

