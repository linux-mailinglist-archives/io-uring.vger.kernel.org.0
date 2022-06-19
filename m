Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B07550A32
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 13:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbiFSL0t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 07:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbiFSL0s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 07:26:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3F16153
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:47 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v14so11090061wra.5
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MhKVC6/7Nw0gdOt5wcUBQM6VXSKzq7yiIe7eF3ZRLEI=;
        b=qtLGUQn0kk8f+ySS5tWIHjM8H95BnpYqlp5iquMqHULj67nf+r6t5Yz2Dq+ovcNgIQ
         W1fAtGcWAkGvYJhorSkmiSIyCiwNPU5vb8HROrDb34tI0t+3F+oZBid62O8UvQf97HCu
         0nU5u3ReJpsQoWef5RzzXX7Z0wPS+yW3+lKQ0uuChkrulDCdLH+gnLq4AQEQrhufkT8H
         UqW83mmNM8oM/eze6WRyeQOY44oWTXjMs4oqbltVdA+kuLyIgZgmSWQrOillFNvyQ+f7
         +1MOn23y0DWjNU8iXka6j7kZ+h5rbM82lQZxAM9nyb0S7EgKWF6ghtAzU8rtN0i120Xc
         Jk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MhKVC6/7Nw0gdOt5wcUBQM6VXSKzq7yiIe7eF3ZRLEI=;
        b=l0I65g54faWGAZsfVXyDZ4/1mmoQBl+UpFHT5TGYsj/sWIvtEcZTHMlLnhZa0qo5cu
         4yppmUKGLz5/GIEzF7xFIGjGwtZ4knpSAOL8YAQ4gETYQV2vqPBlAGj7GNZgpL/IVeIy
         +G0w6EYVS1XJdghaGzqHNRMDToSmQJyAK+vHBN2Z/4ovKe55FhB1EkOgmJq1lKiu3MOC
         SKbRDgKJq4vQqTO9adKxUVA1KyyBIEiDhY/a7jGleDNY6galBcvWdVx1b4mi6YJhEJnv
         gd7IdIwN4ZTULApvndoIJQPzQIpDnC+OlCUWyK5w8kXD3PIbpP5jhZCL9z2L989LuHSO
         cMFA==
X-Gm-Message-State: AJIora8n2nInDY7rqbG1Y9RF+HCtiYr6i8ApyDjWXbg1Am2bDxm+y284
        06RxpEyH9BBV26Alwyr8t2sdWh2g3q3F+A==
X-Google-Smtp-Source: AGRyM1uqceXNczSUWgS0uFA7nDhZbZLl+UWUwBDNtdB4n5mSeeibInLO6ALWflVn+vHxHzILv7JjgQ==
X-Received: by 2002:a5d:64c7:0:b0:218:4a82:ffa4 with SMTP id f7-20020a5d64c7000000b002184a82ffa4mr18396897wri.592.1655638006357;
        Sun, 19 Jun 2022 04:26:46 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y14-20020adfee0e000000b002119c1a03e4sm9921653wrn.31.2022.06.19.04.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 04:26:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/7] io_uring: remove ->flush_cqes optimisation
Date:   Sun, 19 Jun 2022 12:26:08 +0100
Message-Id: <692e81eeddccc096f449a7960365fa7b4a18f8e6.1655637157.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655637157.git.asml.silence@gmail.com>
References: <cover.1655637157.git.asml.silence@gmail.com>
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

It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
->flush_cqes flag prevents from completion being flushed. Sometimes it's
high level of concurrency that enables it at least for one CQE, but
sometimes it doesn't save much because nobody waiting on the CQ.

Remove ->flush_cqes flag and the optimisation, it should benefit the
normal use case. Note, that there is no spurious eventfd problem with
that as checks for spuriousness were incorporated into
io_eventfd_signal().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 23 ++++++++++-------------
 io_uring/io_uring.h |  2 --
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0875cc649e23..57aef092ef38 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1253,22 +1253,19 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
 
-	if (state->flush_cqes) {
-		spin_lock(&ctx->completion_lock);
-		wq_list_for_each(node, prev, &state->compl_reqs) {
-			struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    comp_list);
-
-			if (!(req->flags & REQ_F_CQE_SKIP))
-				__io_fill_cqe_req(ctx, req);
-		}
+	spin_lock(&ctx->completion_lock);
+	wq_list_for_each(node, prev, &state->compl_reqs) {
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+					    comp_list);
 
-		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
-		io_cqring_ev_posted(ctx);
-		state->flush_cqes = false;
+		if (!(req->flags & REQ_F_CQE_SKIP))
+			__io_fill_cqe_req(ctx, req);
 	}
 
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+
 	io_free_batch_list(ctx, state->compl_reqs.first);
 	INIT_WQ_LIST(&state->compl_reqs);
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 906749fa3415..7feef8c36db7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -232,8 +232,6 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		state->flush_cqes = true;
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
-- 
2.36.1

