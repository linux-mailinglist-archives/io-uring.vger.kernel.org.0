Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621004599D2
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 02:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhKWBsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 20:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhKWBsw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 20:48:52 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300F6C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 17:45:45 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t30so35963540wra.10
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 17:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EDKVDrf4s2Q6KEUJVP41sdLDTbYTwcXz4LomrLElSM=;
        b=hbrzv0yUXu+cpZmcXeVb0Xhk6p5VAXfWZK2QCB15Ru7flWJUqX3XW4GOYxbUpGL6C+
         HKJnLV5aJMDtKb+PKwuXCa7fwa3QN6xgbudfk2w5n7I5ByVL9dBPtKKuihkYldvO/C75
         7ObbeuHI2vTvX/Wfgww5xELnhwMZbySMGCkPZORrFHwkupH6UQ7AmF/97bK6d/z1yxle
         stBmlY7OBUVNu2VyL1FbUXalU4r5dVmn79rn8usPtrk7aZSrcCzMdEjwcPJOyGSR9IDv
         ZsVr0ZcnOp37/hHMSjjyHS/bMzknNvm98iJ1bjkPrQdtsxcV9JBIvEqnMbdx7sJ7P4EB
         K4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EDKVDrf4s2Q6KEUJVP41sdLDTbYTwcXz4LomrLElSM=;
        b=39cctMoajUVFDfSTEI2LQgc84yUpj2JiNVdwhEcJVH1XvxtIuq0Svqook8rTP/Kca3
         0Ug/Yvb96ldZTWt7bNNcba8aeAksDrS6gSFfq/KYNle6R+4hy9uMHc2BVPh1OQdKIRzK
         akqHiikauofRPE1Yz4gGsWrEbOA5Z/1aQJckS5xG2ClkXVs7rtcCf8f9Y9tQQwWE8KQW
         Zlrrr2hTDB4UGaCvlnyanYgTzqJtmzl1Oeftm6/XJc552L0Raf2eddrzaaXHZrVu0Qqa
         KBwXSdY5zvWcnv+174zysv+68OnmbRfHyLxHy3IEgRX++z/8yCEshsIRJivcoDpBCNC3
         WihQ==
X-Gm-Message-State: AOAM533cfssK+k+p/6lGsDrinT2I6jFIWH+KBNCIF2HVREkdrqNMqIpD
        Y98yS2qrB+sKmqUZgdf7OwDlNO3cs8g=
X-Google-Smtp-Source: ABdhPJwfpb6ihcCePuN7t3ptDnyoKq78X0fdbQ40ZOS43PtIunsLHPJOOpqWuM7L1iTjjvHX5rS++A==
X-Received: by 2002:a05:6000:1a88:: with SMTP id f8mr2556057wry.54.1637631943631;
        Mon, 22 Nov 2021 17:45:43 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.196])
        by smtp.gmail.com with ESMTPSA id e8sm10452156wrr.26.2021.11.22.17.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 17:45:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: correct link-list traversal locking
Date:   Tue, 23 Nov 2021 01:45:35 +0000
Message-Id: <b54541cedf7de59cb5ae36109e58529ca16e66aa.1637631883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As io_remove_next_linked() is now under ->timeout_lock (see
io_link_timeout_fn), we should update locking around io_for_each_link()
and io_match_task() to use the new lock.

Cc: stable@kernel.org # 5.15+
Fixes: 89850fce16a1a ("io_uring: run timeouts from task_work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e98e7ce3dc39..a4c508a1e0cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1502,10 +1502,10 @@ static void io_prep_async_link(struct io_kiocb *req)
 	if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		spin_lock(&ctx->completion_lock);
+		spin_lock_irq(&ctx->timeout_lock);
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
-		spin_unlock(&ctx->completion_lock);
+		spin_unlock_irq(&ctx->timeout_lock);
 	} else {
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
@@ -5699,6 +5699,7 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
 	int posted = 0, i;
 
 	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list;
 
@@ -5708,6 +5709,7 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
 				posted += io_poll_remove_one(req);
 		}
 	}
+	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 
 	if (posted)
@@ -9568,9 +9570,9 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 		struct io_ring_ctx *ctx = req->ctx;
 
 		/* protect against races with linked timeouts */
-		spin_lock(&ctx->completion_lock);
+		spin_lock_irq(&ctx->timeout_lock);
 		ret = io_match_task(req, cancel->task, cancel->all);
-		spin_unlock(&ctx->completion_lock);
+		spin_unlock_irq(&ctx->timeout_lock);
 	} else {
 		ret = io_match_task(req, cancel->task, cancel->all);
 	}
@@ -9585,12 +9587,14 @@ static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	LIST_HEAD(list);
 
 	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
 		if (io_match_task(de->req, task, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
 	}
+	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 	if (list_empty(&list))
 		return false;
-- 
2.33.1

