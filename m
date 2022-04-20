Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1ECC508624
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352354AbiDTKmx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352334AbiDTKmw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A05F101F0
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:06 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id j17so1547158pfi.9
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7GL+6+hzbLIzJD5Y/bDO8jQJJAXbwaK7ayM++xtPj9E=;
        b=CBG6fR718PSukXODnksYXrJI7tKTFOmo026RTVc8UExKACH2VzC+/f3CoF8vQDE383
         U2tmmbzsbVeSE1W0Rjp13XuvmVbLTT8bBjxlrak0huyQ7AG12h9/vv8BHvVs5KwxbHZW
         ftSxvZ8ZLm3oqGBX1UFIM7R/KxDAm7ApzLdXLWuVl1LF8KbK/pz6E90GrJsGt3zfcp7i
         7F91cDvfTtb/QWj7m9OSrPIN27ymaTiVTDQr3dmBIPQcbYPO22emkjJuufMSJ3iqARqJ
         WSOKTzJC/JpH+ecYqFAYEXXaqGj/bCYu6VieCsG/XPR6k02Wog1CsXCkR4aeb2S/Mf6Z
         Qpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7GL+6+hzbLIzJD5Y/bDO8jQJJAXbwaK7ayM++xtPj9E=;
        b=tPzmhLG042Jf4yCKgLrR2uFzGZBLg3qEyW+zu/bPdAzgsjosnvYdYZGjp24Fh2UiTH
         b07KdQ6vJu1O0p/7AN4FLyCTAFXuY+qw3dO6IAA9GQzc05f2TUXFfCj+W5Iv4M8HYiVQ
         hGZ5sV34G43xAyqR/T3ipW29PYIo82SNZTBIogWBk9oV1WpzfJLMgSvkqnXYua6CrZGf
         hVsyxuBk5gRYIRdyIDAtMSlTKPY4Zus00Hgsfw894kvKCoRsWLRuoP5rbg8Ngk1gQEbA
         SHfSP7itJI2t+bALNYc67w2TfAz0BwupjNDhvKnTX8GOQ0ZPYdYGUVP78L7XvyqDfhX6
         kd+Q==
X-Gm-Message-State: AOAM5304LRiGERPz+Nq1/zRrJiKgIg3sGaO2/tAf7rscpY6sXLdGrgby
        1Lx+cqJ3VfWjZ+EYTfQYoWKrAxHb5Kvlmg==
X-Google-Smtp-Source: ABdhPJw9N+taWTDFiRE+bS92EVlx4dsE1lpOwNJXIiqilI87lec9AJAV+Z0dRymXaGIKvaOHmhAF1g==
X-Received: by 2002:a05:6a00:84e:b0:50a:7a43:a2d1 with SMTP id q14-20020a056a00084e00b0050a7a43a2d1mr14228461pfk.51.1650451205861;
        Wed, 20 Apr 2022 03:40:05 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.40.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:40:05 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5/9] io-wq: fixed worker initialization
Date:   Wed, 20 Apr 2022 18:39:56 +0800
Message-Id: <20220420104000.23214-6-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420104000.23214-1-haoxu.linux@gmail.com>
References: <20220420104000.23214-1-haoxu.linux@gmail.com>
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
index f1c9e7936988..02f9b15a998f 100644
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

