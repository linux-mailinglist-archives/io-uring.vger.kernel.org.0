Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2927A3FE4
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbjIREMZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239414AbjIREMT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:12:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BB29F
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JQ0OGbw8P5+mlbOCGhQ5rG8/PVFXLlF0EMXrQsKOArk=;
        b=SeRhByqKFQfQfwCAgIn9ASMTw6xlT6JmR30isoMj7F+S1sSy6QVAET4JKPiFkyDE6F3XYj
        vV21WnltXWGyGPgKFx39hlAHHKX4sNuvSjWNKOYipj88cplRCMNQPlu435FL0kWqjYklXM
        2eZIUNSCm6yvgrLaRCfy8rwwQoKTkmM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-695--ILItjkONd2otM7iyI_-Sw-1; Mon, 18 Sep 2023 00:11:23 -0400
X-MC-Unique: -ILItjkONd2otM7iyI_-Sw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C76DC85A5A8;
        Mon, 18 Sep 2023 04:11:22 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E09D21005B90;
        Mon, 18 Sep 2023 04:11:21 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 01/10] io_uring: allocate ctx id and build map between id and ctx
Date:   Mon, 18 Sep 2023 12:10:57 +0800
Message-Id: <20230918041106.2134250-2-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Prepare for supporting to notify uring_cmd driver when ctx/io_uring_task
is going away.

Notifier callback will be registered by driver to get notified, so that driver
can cancel in-flight command which may depend on the io task.

For driver to check if the ctx is matched with uring_cmd, allocate/provide ctx
id to the callback, so we can avoid to expose the whole ctx instance.

The global xarray of ctx_ids is added for holding the mapping and allocating
unique id for each ctx.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring.h       | 2 ++
 include/linux/io_uring_types.h | 3 +++
 io_uring/io_uring.c            | 9 +++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..ec9714e36477 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -41,6 +41,8 @@ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 	return sqe->cmd;
 }
 
+#define IO_URING_INVALID_CTX_ID  UINT_MAX
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 13d19b9be9f4..d310bb073101 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -215,6 +215,9 @@ struct io_ring_ctx {
 		struct percpu_ref	refs;
 
 		enum task_work_notify_mode	notify_method;
+
+		/* for uring cmd driver to retrieve context  */
+		unsigned int		id;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 783ed0fff71b..c015c070ff85 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -175,6 +175,9 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 };
 #endif
 
+/* mapping between io_ring_ctx instance and its ctx_id */
+static DEFINE_XARRAY_FLAGS(ctx_ids, XA_FLAGS_ALLOC);
+
 struct sock *io_uring_get_socket(struct file *file)
 {
 #if defined(CONFIG_UNIX)
@@ -303,6 +306,10 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 
 	xa_init(&ctx->io_bl_xa);
 
+	ctx->id = IO_URING_INVALID_CTX_ID;
+	if (xa_alloc(&ctx_ids, &ctx->id, ctx, xa_limit_31b, GFP_KERNEL))
+		goto err;
+
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
 	 * 32 entries per hash list if totally full and uniformly spread, but
@@ -356,6 +363,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_erase(&ctx_ids, ctx->id);
 	kfree(ctx);
 	return NULL;
 }
@@ -2929,6 +2937,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_erase(&ctx_ids, ctx->id);
 	kfree(ctx);
 }
 
-- 
2.40.1

