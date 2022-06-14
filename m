Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA71554B0FC
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241187AbiFNMd7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiFNMdk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:40 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4729C4B1EB
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:44 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k19so11059150wrd.8
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tcnT183OYNPa4vdT2GoOS6WMF6bmKM6MUsSlmmhun7A=;
        b=hlX0CdHLf6LcGW5CKOCY2RKXzHPOOz8THFZNt0wiqq/l5jhfNAKXCCtzaCfVoQP+lb
         kr9kG4rzaLnT9q/85r2NPTsmuj3YfGnlZ62Yhe42lxZ8tzU+0RN8ow2hc430V/MB5GAS
         vxPiDtNOn8y6Iu6FQKYvnL91b6VUjBPRucSh8I0O4LXA9JHlzTlkKIKw+B65KGyHM9ea
         yJflp1jWpG+81q0NCLpxio7ibtlWBP+V88UW6CZUQIeEQ0zavu03X0iQy2EAmevk/oIO
         wrs5d00PSZ1PVRjXQLZZFCghKUGKKbNtEFRv4rTCTdWfut1rYInHUf0T8VJC27r6ccpg
         88QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tcnT183OYNPa4vdT2GoOS6WMF6bmKM6MUsSlmmhun7A=;
        b=0QjM6NpZMQQ7czAuizQ2Pskado1uiM4/quM2OJeqs+wwk5uIAf6QjY0Ptjew9hg6ff
         1nM5ijVvaZhxod2FXmiIi7dUJB5spq2sksjpPFWVe0aIVLzzfV3b2enS7Q+7gxc8O3CF
         ld0I4L2HFpoOjANqTXtS5B2YKuGWHhdX2ulTEAxcUuYoIgZ5I2Yu0s2HNKOoM8p9MJLJ
         nd945iMwbzFAR/K013zYR8LJz3/Qe8AyHRSHk8gn7T8gRZgoutRVKMSfHFF3Oxa/FVyI
         dtBM6gD3DHAZm9Kv0j3SRqs3OzmtD/VhScsPRycAa7OF+GB1m7WW1pWWVZ9vbjsPa8Ij
         /IKQ==
X-Gm-Message-State: AJIora/55sQrVcbPp7pF9Q9CNNyGJpl/MXOPnbhx/0jC2pTIGaRpEoeK
        G7R/NDqSnG9tXkLOl+C2vhpRAGOXddkzKQ==
X-Google-Smtp-Source: AGRyM1veVvLJqJenIPmY7d6F8waNbakyiOsDBFctjMPiBmPuSRQnFYlN7yfl/U/uhV435yGyiDT8Nw==
X-Received: by 2002:a05:6000:156d:b0:210:3125:6012 with SMTP id 13-20020a056000156d00b0021031256012mr4525595wrz.357.1655209842417;
        Tue, 14 Jun 2022 05:30:42 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 06/25] io_uring: move small helpers to headers
Date:   Tue, 14 Jun 2022 13:29:44 +0100
Message-Id: <263af7a3f2f40130c26969877381567ce66870d9.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

There is a bunch of inline helpers that will be useful not only to the
core of io_uring, move them to headers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 22 ----------------------
 io_uring/io_uring.h | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index af9188c8e2eb..2f5fd1749c4a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -616,14 +616,6 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
-static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
-{
-	if (!*locked) {
-		mutex_lock(&ctx->uring_lock);
-		*locked = true;
-	}
-}
-
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
@@ -879,15 +871,6 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-static inline void io_req_add_compl_list(struct io_kiocb *req)
-{
-	struct io_submit_state *state = &req->ctx->submit_state;
-
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		state->flush_cqes = true;
-	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
-}
-
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
@@ -1293,11 +1276,6 @@ static void io_req_complete_post32(struct io_kiocb *req, u64 extra1, u64 extra2)
 	io_cqring_ev_posted(ctx);
 }
 
-static inline void io_req_complete_state(struct io_kiocb *req)
-{
-	req->flags |= REQ_F_COMPLETE_INLINE;
-}
-
 inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 {
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3660df80e589..26b669746d61 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -193,6 +193,28 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
+static inline void io_req_complete_state(struct io_kiocb *req)
+{
+	req->flags |= REQ_F_COMPLETE_INLINE;
+}
+
+static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
+{
+	if (!*locked) {
+		mutex_lock(&ctx->uring_lock);
+		*locked = true;
+	}
+}
+
+static inline void io_req_add_compl_list(struct io_kiocb *req)
+{
+	struct io_submit_state *state = &req->ctx->submit_state;
+
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		state->flush_cqes = true;
+	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+}
+
 int io_run_task_work_sig(void);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete32(struct io_kiocb *req, unsigned int issue_flags,
-- 
2.36.1

