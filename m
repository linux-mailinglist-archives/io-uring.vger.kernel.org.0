Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E8A1D41A2
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 01:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgENXYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 19:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgENXYB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 19:24:01 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF66C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 16:24:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b190so70284pfg.6
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 16:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zrKZ0uYWW79nV9aXL/FaADqICSkwPcyAcBDEdihVoAA=;
        b=nTy3fcnJPUzkQ1GjvBy2qG2CHWQtuFP2AIgD11l+Hsy0S0QLr008tdg4thJbu4RSGD
         a7DJLqj0LugoPkNE1yXu3aLfA1d35I6I96X7HcJsjGXwvAhRY2I0nK+7WEmKsplKCBL6
         UH/qQ88Erl5tVy8mbj8KXbC47SCE/xuuBpkixlLKPTbCpRRTzLPlXEyYCwjIatBM3Bd3
         QLBc7C5FeJ+I9ZPdXGAZtm238baZFfg1ljsaCe7s+OTChjA3eUtGvUJRJAAbAE5nut6d
         t1SpagwRhWyirf4YNsr5EWlbWwwQsprtteFXl1ooNig+CnC2LelXi+LKTii+1zvRme/6
         nhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zrKZ0uYWW79nV9aXL/FaADqICSkwPcyAcBDEdihVoAA=;
        b=eicks+mmzG33frobzcOZLvX+oCSeECtJkU5XnAF8H5k7dN2D3IqxPTtJthbvNKa6h7
         KAIUi+kAUk3Om2O0djK3Hw+ohxwCw9OE1lNWw3BgPsZ6eWCLKQpquTDArBdPBtJhHfws
         e4WU5Fi67LNwWJlW5o8XXlntj6Wd4cFSfk+VMuXdFSQ2mMVx2uZq/MOCbWV4rVrkISJp
         SPwQWpcHHAVLSZA8W8dLlGxDRBH2sXBaUKBUpKv+dCOJSKW6C/OprfGteqZPAgOE2VkH
         zxnTvu4tYQfhNKJZL1sHZ50JQKgyJ0cxmqL/9ndq5R11N5i4Zfh6P6inOpXfQdP9TJWJ
         +r9A==
X-Gm-Message-State: AOAM532GYtNuB+VGCHcqVCUeU7+Vqq6lPqonjh+TJdeAOg9ivwuV1PnJ
        ngOAIVEr12/Ho4g1HQtakE7rcg2VMFM=
X-Google-Smtp-Source: ABdhPJwcn8rOJjsZXncwffCoTNmwIrQV8sbpCeJyMfXCWfhQbFql2vCxK+quwdzsoyMosAbYjdBq3g==
X-Received: by 2002:a63:1a0b:: with SMTP id a11mr401923pga.299.1589498640412;
        Thu, 14 May 2020 16:24:00 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::15f4? ([2620:10d:c090:400::5:85d5])
        by smtp.gmail.com with ESMTPSA id q201sm261807pfq.40.2020.05.14.16.23.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 16:23:59 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: batch reap of dead file registrations
Message-ID: <d4a6a4de-9741-087b-6a3f-78525cc86122@kernel.dk>
Date:   Thu, 14 May 2020 17:23:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently embed and queue a work item per fixed_file_ref_node that
we update, but if the workload does a lot of these, then the associated
kworker-events overhead can become noticeable.

Since we rarely need to wait on these, batch them on 5 second intervals
instead. If we do need to wait for them, we can just flush the pending
delayed work.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 414e940323d4..3d57b1718e8c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -191,7 +191,7 @@ struct fixed_file_ref_node {
 	struct list_head		node;
 	struct list_head		file_list;
 	struct fixed_file_data		*file_data;
-	struct work_struct		work;
+	struct llist_node		llist;
 };
 
 struct fixed_file_data {
@@ -327,6 +327,9 @@ struct io_ring_ctx {
 		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
 
+	struct delayed_work		file_put_work;
+	struct llist_head		file_put_llist;
+
 	struct work_struct		exit_work;
 };
 
@@ -879,6 +882,8 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+static void io_file_put_work(struct work_struct *work);
+
 static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
@@ -934,6 +939,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->inflight_wait);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
+	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
+	init_llist_head(&ctx->file_put_llist);
 	return ctx;
 err:
 	if (ctx->fallback_req)
@@ -6190,6 +6197,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&data->refs);
 
 	/* wait for all refs nodes to complete */
+	flush_delayed_work(&ctx->file_put_work);
 	wait_for_completion(&data->done);
 
 	__io_sqe_files_unregister(ctx);
@@ -6420,18 +6428,13 @@ struct io_file_put {
 	struct file *file;
 };
 
-static void io_file_put_work(struct work_struct *work)
+static void __io_file_put_work(struct fixed_file_ref_node *ref_node)
 {
-	struct fixed_file_ref_node *ref_node;
-	struct fixed_file_data *file_data;
-	struct io_ring_ctx *ctx;
+	struct fixed_file_data *file_data = ref_node->file_data;
+	struct io_ring_ctx *ctx = file_data->ctx;
 	struct io_file_put *pfile, *tmp;
 	unsigned long flags;
 
-	ref_node = container_of(work, struct fixed_file_ref_node, work);
-	file_data = ref_node->file_data;
-	ctx = file_data->ctx;
-
 	list_for_each_entry_safe(pfile, tmp, &ref_node->file_list, list) {
 		list_del_init(&pfile->list);
 		io_ring_file_put(ctx, pfile->file);
@@ -6447,13 +6450,38 @@ static void io_file_put_work(struct work_struct *work)
 	percpu_ref_put(&file_data->refs);
 }
 
+static void io_file_put_work(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx;
+	struct llist_node *node;
+
+	ctx = container_of(work, struct io_ring_ctx, file_put_work.work);
+	node = llist_del_all(&ctx->file_put_llist);
+
+	while (node) {
+		struct fixed_file_ref_node *ref_node;
+		struct llist_node *next = node->next;
+
+		ref_node = llist_entry(node, struct fixed_file_ref_node, llist);
+		__io_file_put_work(ref_node);
+		node = next;
+	}
+}
+
 static void io_file_data_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_file_ref_node *ref_node;
+	struct io_ring_ctx *ctx;
+	int delay = 5 * HZ;
 
 	ref_node = container_of(ref, struct fixed_file_ref_node, refs);
+	ctx = ref_node->file_data->ctx;
 
-	queue_work(system_wq, &ref_node->work);
+	if (percpu_ref_is_dying(&ctx->file_data->refs))
+		delay = 0;
+
+	llist_add(&ref_node->llist, &ctx->file_put_llist);
+	queue_delayed_work(system_wq, &ctx->file_put_work, delay);
 }
 
 static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
@@ -6472,10 +6500,8 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 	}
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
-	INIT_WORK(&ref_node->work, io_file_put_work);
 	ref_node->file_data = ctx->file_data;
 	return ref_node;
-
 }
 
 static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node)
-- 
2.26.2

-- 
Jens Axboe

