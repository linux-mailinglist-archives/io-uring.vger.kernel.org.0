Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87B6514677
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiD2KWc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357326AbiD2KW0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067EDC6677;
        Fri, 29 Apr 2022 03:19:07 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b12so6756567plg.4;
        Fri, 29 Apr 2022 03:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3+L3pwb3ppcFRe2sFtkQeWcRPTykgnJuLr+xwFDuh68=;
        b=pAxnEK/nCE1MWwrb/q08LBo76wO+Ers7osMQZPIxciEVObYjvemvjQKUNGPG0grxNT
         G7Mq+rTnM3X+0EFaoyu5hmlAVR63KUoLnVIN2HrLKbjSouYSmkpEbYjLSPmFNn0+xlR+
         ufL7LVhz2/p7H/e12QUsSXcI11vpviOvmTGWKqV1u4FdNlfrQCHPcGcBvDwy28Yoya1g
         ZBZYY6EFm/M9hTvmJPd6Il9OGIpzhkExkeCm1F8hYunuAArptBhPKfXk15dKjL5KUhFU
         9z7QgkQX3QmKpJ+PudjZ+fwSJRywli9tNIBfRUiD+2k1o+7OF7Tyfjgt5m1rpgzQIxWk
         sJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3+L3pwb3ppcFRe2sFtkQeWcRPTykgnJuLr+xwFDuh68=;
        b=33Xqa7f3eDhr07ZImG3uXZtm9r9L5HB83+Z5Ta7nMJmuSjOz0/GZe0OV+2hsIqkjFU
         puHmYe/FXx4MjvS6KF3pIBMj+3ZqYwOudWnvFFTFBEZfYyfGogtv6jWyLmQ1WwywSw/M
         aneDbJPrlks94H2VhnalA73ieRzLXrK9PWLMxsusQEDzsSNRLP8H6ckYVNbgrQ2W9UZ1
         2LtEaMbbtJwpnThFLmuDah29uOIx1YMX4SZs01yrhq4DNtTWCte8O7pXzfqk1lI3/Yya
         sTPYdXFJshGR2++VEXS5rY7OYfJlSejVF0StoPTPIDVHCFGFslWTenyXZ9dUvuPezs8T
         5z0Q==
X-Gm-Message-State: AOAM532dswL3+teooJxdG+t5G7rUpuYYC3fKXvfMuLaPNTkMYHrT1cO0
        c2lavKc/hTdgtjWImmP+vnC4nnH56WQ=
X-Google-Smtp-Source: ABdhPJwRjb1IFkHsIEMUvBnH3SfNPim3GwaRTAHEH0043smuw3lN2xawRH3ergLJGXGx94KwIHmE2Q==
X-Received: by 2002:a17:902:70cb:b0:158:424e:a657 with SMTP id l11-20020a17090270cb00b00158424ea657mr37330398plt.6.1651227546441;
        Fri, 29 Apr 2022 03:19:06 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.19.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:19:06 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] io-wq: fixed worker initialization
Date:   Fri, 29 Apr 2022 18:18:54 +0800
Message-Id: <20220429101858.90282-6-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Implementation of the fixed worker initialization.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c67bd5e5d117..a1a10fb204a7 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -774,6 +774,26 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	io_wqe_dec_running(worker);
 }
 
+static void io_init_new_fixed_worker(struct io_wqe *wqe,
+				     struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe_acct *iw_acct = &worker->acct;
+	unsigned index = acct->index;
+	unsigned *nr_fixed;
+
+	raw_spin_lock(&acct->lock);
+	nr_fixed = &acct->nr_fixed;
+	acct->fixed_workers[*nr_fixed] = worker;
+	worker->index = (*nr_fixed)++;
+	iw_acct->nr_works = 0;
+	iw_acct->max_works = acct->max_works;
+	iw_acct->index = index;
+	INIT_WQ_LIST(&iw_acct->work_list);
+	raw_spin_lock_init(&iw_acct->lock);
+	raw_spin_unlock(&acct->lock);
+}
+
 static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 			       struct task_struct *tsk)
 {
@@ -787,6 +807,8 @@ static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
 	raw_spin_unlock(&wqe->lock);
+	if (worker->flags & IO_WORKER_F_FIXED)
+		io_init_new_fixed_worker(wqe, worker);
 	wake_up_new_task(tsk);
 }
 
@@ -893,6 +915,8 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
 
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
+	if (&wqe->fixed_acct[index] == acct)
+		worker->flags |= IO_WORKER_F_FIXED;
 
 	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
 	if (!IS_ERR(tsk)) {
-- 
2.36.0

