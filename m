Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4263550A30
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 13:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiFSL0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 07:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiFSL0q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 07:26:46 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D9A5F67
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o8so11101113wro.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NBaWof8Lzg/HXk/U7LCqpKHXLfiNBK1+scHwWFvlKXo=;
        b=TbAUQPb/1ZcTZnXMpUK9z7mEqwN+n2mnlitB6KXUCR5LZCHq95q3/nU73MIhGrYx0A
         aiiQaI3PNd4Pyrwjwt37Q0n1Q6vbZDYXbgqEJLmKkGXs99QBzuLz1ZS6xImUIVULlQEO
         36HjR+R8dtBrQLyyPJi19x4o7Cu5+/sA0IhQv4Ky3r2cShs//xeIbRyvhGlNxmEe+7mu
         l/8uJCkLU+J9uCIX7DQDy6Ar0sQA4v0DtkLeQ9/h9Rvp/hqLU0G/i1dcQyfG0JNo9vzL
         gSHJFZdLeMyzYwWRBaJnn1M/JgkJuPPBBw4Gj4f0GUlAAeTLFf273+ovKHJUl+lZXHJh
         pqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBaWof8Lzg/HXk/U7LCqpKHXLfiNBK1+scHwWFvlKXo=;
        b=PRg/t1OL9vA/tnT7VYQRn9wQwStT/RvhlL1m2RNRP9gM3Gs8ljkQPw3VQU1mLc4RIw
         KEU+Gdq4an7AI+BADrRLpO56arvhx+S7E+6r2HeaPAEXII9ZvZbBp8ZMp3cVug23ItW5
         CoxH0dCYj6MElG1exZ04oZoHWLR9kpimpVVCrOsqg1iQWOsOmjrJmXbtytfUNTs2+21r
         8DZ/6OmJIaAh0hNktXUXymusJ3m8wtqV4vvhBcbcQJECoA1J0pYB6cufwKzSHhgCKNFF
         Zo2xpTayc+piteveT0h6qdvrWYq/VlpmGpXpo36cxuPXUNfdsLU34hI/hVwC+Sj9GHMV
         3Y9g==
X-Gm-Message-State: AJIora9qADA2EZFUCIcluPwwjrLdHhWQpv9hrOQNviOObF5GOeFcu+8U
        YIPsi+tBGbUCG3/uXiCvTZCr6p+OuaRkrw==
X-Google-Smtp-Source: AGRyM1tCNzTUA0UW84YV2HH9Yc34I4kDiEJiKBFiCk6DBVq+Q2djllyVDw4ghk5n+I1qAJonxUd3EQ==
X-Received: by 2002:adf:ed47:0:b0:21b:8724:6704 with SMTP id u7-20020adfed47000000b0021b87246704mr6433714wro.389.1655638003295;
        Sun, 19 Jun 2022 04:26:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y14-20020adfee0e000000b002119c1a03e4sm9921653wrn.31.2022.06.19.04.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 04:26:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/7] io_uring: reshuffle io_uring/io_uring.h
Date:   Sun, 19 Jun 2022 12:26:05 +0100
Message-Id: <1d7fa6672ed43f20ccc0c54ae201369ebc3ebfab.1655637157.git.asml.silence@gmail.com>
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

It's a good idea to first do forward declarations and then inline
helpers, otherwise there will be keep stumbling on dependencies
between them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 95 ++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 48 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 388391516a62..906749fa3415 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -18,6 +18,53 @@ enum {
 
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
 bool io_req_cqe_overflow(struct io_kiocb *req);
+int io_run_task_work_sig(void);
+void io_req_complete_failed(struct io_kiocb *req, s32 res);
+void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
+void io_req_complete_post(struct io_kiocb *req);
+void __io_req_complete_post(struct io_kiocb *req);
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
+void io_cqring_ev_posted(struct io_ring_ctx *ctx);
+void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
+
+struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
+
+struct file *io_file_get_normal(struct io_kiocb *req, int fd);
+struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
+			       unsigned issue_flags);
+
+bool io_is_uring_fops(struct file *file);
+bool io_alloc_async_data(struct io_kiocb *req);
+void io_req_task_work_add(struct io_kiocb *req);
+void io_req_task_prio_work_add(struct io_kiocb *req);
+void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
+void io_req_task_queue(struct io_kiocb *req);
+void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
+void io_req_task_complete(struct io_kiocb *req, bool *locked);
+void io_req_task_queue_fail(struct io_kiocb *req, int ret);
+void io_req_task_submit(struct io_kiocb *req, bool *locked);
+void tctx_task_work(struct callback_head *cb);
+__cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
+int io_uring_alloc_task_context(struct task_struct *task,
+				struct io_ring_ctx *ctx);
+
+int io_poll_issue(struct io_kiocb *req, bool *locked);
+int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
+int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
+void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
+int io_req_prep_async(struct io_kiocb *req);
+
+struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
+void io_wq_submit_work(struct io_wq_work *work);
+
+void io_free_req(struct io_kiocb *req);
+void io_queue_next(struct io_kiocb *req);
+
+bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
+			bool cancel_all);
+
+#define io_for_each_link(pos, head) \
+	for (pos = (head); pos; pos = pos->link)
 
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
@@ -190,52 +237,4 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
-int io_run_task_work_sig(void);
-void io_req_complete_failed(struct io_kiocb *req, s32 res);
-void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
-void io_req_complete_post(struct io_kiocb *req);
-void __io_req_complete_post(struct io_kiocb *req);
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
-void io_cqring_ev_posted(struct io_ring_ctx *ctx);
-void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
-
-struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
-
-struct file *io_file_get_normal(struct io_kiocb *req, int fd);
-struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
-			       unsigned issue_flags);
-
-bool io_is_uring_fops(struct file *file);
-bool io_alloc_async_data(struct io_kiocb *req);
-void io_req_task_work_add(struct io_kiocb *req);
-void io_req_task_prio_work_add(struct io_kiocb *req);
-void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
-void io_req_task_queue(struct io_kiocb *req);
-void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
-void io_req_task_complete(struct io_kiocb *req, bool *locked);
-void io_req_task_queue_fail(struct io_kiocb *req, int ret);
-void io_req_task_submit(struct io_kiocb *req, bool *locked);
-void tctx_task_work(struct callback_head *cb);
-__cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
-int io_uring_alloc_task_context(struct task_struct *task,
-				struct io_ring_ctx *ctx);
-
-int io_poll_issue(struct io_kiocb *req, bool *locked);
-int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
-int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
-void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
-int io_req_prep_async(struct io_kiocb *req);
-
-struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
-void io_wq_submit_work(struct io_wq_work *work);
-
-void io_free_req(struct io_kiocb *req);
-void io_queue_next(struct io_kiocb *req);
-
-bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
-			bool cancel_all);
-
-#define io_for_each_link(pos, head) \
-	for (pos = (head); pos; pos = pos->link)
-
 #endif
-- 
2.36.1

