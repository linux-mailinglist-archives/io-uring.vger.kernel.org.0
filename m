Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C48514687
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357335AbiD2KWV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357320AbiD2KWR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:17 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85211C667E;
        Fri, 29 Apr 2022 03:19:00 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id t13so6566801pfg.2;
        Fri, 29 Apr 2022 03:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CWinwQT5xv5GldvtBlyvrjtEE1mVFuBOYzQEqC+w2dc=;
        b=VNBjm0bgpm0nu3eHAqayYOSLbubBgfH6aSM2JcruBSQU2rsHudy/rWzmUYaZdgfOVh
         yAO1uSeA2mISoN55zs8PNARkOAp4Gx/0F71DEVPdh8Au6Mh7VpMONQ64Tj1JXJx3smhU
         tqC1nw/o7SkTkFgTTtbNNgOvIoqWrbG9J9hM/Mk/t+BtQXYeceRiQ+GZnY5I6iQfQhIU
         gqCykzs2Ojdf3X/ACX7/cBhvIYqtMVQkQz547QYJEhC2uZBRaws08KENZoQy4f4jonTh
         914X2bFmPn8U+v+VvfmTtNwG5J6/+WpbB5Jobn2djTnngAiXhAjxx03ZbV7gw6gmEA1J
         X8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CWinwQT5xv5GldvtBlyvrjtEE1mVFuBOYzQEqC+w2dc=;
        b=fd8nC6St4IGqWD/zta+pdD+lcwF+wmqeIFuhLxCDyD8E08RdETiSKuhaUgOogPiiqP
         iD2nlMDgxubK78k8N97Yp6MHAUg4bFUSiVpxOjfIVEw1ijPbyHMyQNuOr6002eQn0Ivd
         uMtcmKhgMY0qY0o30mhwfCGGw1zgHfOar0iy+m7VGUW67qlevEIkiYNGWxSkRT2DWrlH
         0OKf2RHqnK9ZYYQfw+iSIMIt6gEw18GKxeXbbNIsmFTJzkFKwPivAtSLAcLrLTUAjoWA
         K0R7UAuhhCNv18Jc7SXbUgUIvJAcw3dVgPHNkSWybWNk+6aZj8MDT/vQ/QKntMallV04
         kTnQ==
X-Gm-Message-State: AOAM533wcqCRY7IRYAhR+0bE+09TCB4eKDVkSX4buUZMIRWUFSBi96Gw
        hBps9hRL2/nPaR3AbDw25pjMCfRU92A=
X-Google-Smtp-Source: ABdhPJyF2UjX3wlGLAmAG8m5a8qknH38NO7AhfZLGgbZgBxQ8HkIqn0CyZlGoNPZXJ5du7ahajKpnA==
X-Received: by 2002:a65:6d15:0:b0:382:4e6d:dd0d with SMTP id bf21-20020a656d15000000b003824e6ddd0dmr31353288pgb.333.1651227539926;
        Fri, 29 Apr 2022 03:18:59 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.18.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:18:59 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] io-wq: change argument of create_io_worker() for convienence
Date:   Fri, 29 Apr 2022 18:18:51 +0800
Message-Id: <20220429101858.90282-3-haoxu.linux@gmail.com>
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

Change index to acct itself for create_io_worker() for convienence in
the next patches.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0c26805ca6de..35ce622f77ba 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -139,7 +139,8 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct);
 static void io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
@@ -306,7 +307,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	raw_spin_unlock(&wqe->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wqe->wq->worker_refs);
-	return create_io_worker(wqe->wq, wqe, acct->index);
+	return create_io_worker(wqe->wq, wqe, acct);
 }
 
 static void io_wqe_inc_running(struct io_worker *worker)
@@ -335,7 +336,7 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, wqe, worker->create_index);
+		create_io_worker(wq, wqe, acct);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -812,9 +813,10 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = &wqe->acct[index];
+	int index = acct->index;
 	struct io_worker *worker;
 	struct task_struct *tsk;
 
-- 
2.36.0

