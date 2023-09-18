Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325DD7A3FEB
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbjIREN3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239414AbjIREM7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC18122
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=52B/d8oY7jJWZfrym56R0BHRAS7KgEfK4SZXaam5tP4=;
        b=BTWZH6imWJU6fJ5zsx66Vwd5JkgqNwE+7ZQhqn4uatXIYjv6tpK8iaCP3+LkA1R5N/czsD
        bCluaAYxKfKNV6ZZAH2ZbfiEYd8rZ7Elvgzc736BtP8VTG1T2DUzjld9cM3D3sYLHP15h1
        s5/l+UT5pe01GO5NpWZHA6YPiRf4NR0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-hi4SGSw2M5e8G1WXfau-Rg-1; Mon, 18 Sep 2023 00:11:32 -0400
X-MC-Unique: hi4SGSw2M5e8G1WXfau-Rg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4181811E7B;
        Mon, 18 Sep 2023 04:11:31 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6EB6176C3;
        Mon, 18 Sep 2023 04:11:30 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 03/10] io_uring: support io_uring notifier for uring_cmd
Date:   Mon, 18 Sep 2023 12:10:59 +0800
Message-Id: <20230918041106.2134250-4-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Notifier callback is registered by driver to get notified, so far only for
uring_cmd based driver.

With this notifier, driver can cancel in-flight command when ctx is being
released or io task is exiting.

The main use case is ublk(or probably fuse with uring cmd support) in which
uring command may never complete, so driver has to cancel this command
when io task is exiting or ctx is releasing, otherwise __io_uring_cancel() may
wait forever because of inflight commands.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring.h | 19 ++++++++++++++++
 io_uring/io_uring.c      | 48 ++++++++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h      |  4 ++++
 io_uring/uring_cmd.c     | 12 ++++++++++
 4 files changed, 83 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index c395807bd7cf..037bff9960a1 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -47,7 +47,19 @@ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 
 #define IO_URING_INVALID_CTX_ID  UINT_MAX
 
+enum io_uring_notifier {
+	IO_URING_NOTIFIER_CTX_EXIT,
+	IO_URING_NOTIFIER_IO_TASK_EXIT,
+};
+
+struct io_uring_notifier_data {
+	unsigned int ctx_id;
+	const struct task_struct *task;
+};
+
 #if defined(CONFIG_IO_URING)
+int io_uring_cmd_register_notifier(struct notifier_block *nb);
+void io_uring_cmd_unregister_notifier(struct notifier_block *nb);
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
@@ -89,6 +101,13 @@ static inline void io_uring_free(struct task_struct *tsk)
 }
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 #else
+static inline int io_uring_cmd_register_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline void io_uring_cmd_unregister_notifier(struct notifier_block *nb)
+{
+}
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c015c070ff85..de9b217bf5d8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -73,6 +73,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <asm/shmparam.h>
+#include <linux/notifier.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -178,6 +179,22 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 /* mapping between io_ring_ctx instance and its ctx_id */
 static DEFINE_XARRAY_FLAGS(ctx_ids, XA_FLAGS_ALLOC);
 
+/*
+ * Uring_cmd driver can register to be notified when ctx/io_uring_task
+ * is going away for canceling inflight commands.
+ */
+static struct srcu_notifier_head notifier_chain;
+
+int io_uring_register_notifier(struct notifier_block *nb)
+{
+	return srcu_notifier_chain_register(&notifier_chain, nb);
+}
+
+void io_uring_unregister_notifier(struct notifier_block *nb)
+{
+	srcu_notifier_chain_unregister(&notifier_chain, nb);
+}
+
 struct sock *io_uring_get_socket(struct file *file)
 {
 #if defined(CONFIG_UNIX)
@@ -191,6 +208,11 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+struct io_ring_ctx *io_uring_id_to_ctx(unsigned int id)
+{
+	return (struct io_ring_ctx *)xa_load(&ctx_ids, id);
+}
+
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
@@ -3060,6 +3082,23 @@ static __cold bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
 	return req->ctx == data;
 }
 
+static __cold void io_uring_cancel_notify(struct io_ring_ctx *ctx,
+					  struct task_struct *task)
+{
+	struct io_uring_notifier_data notifier_data = {
+		.ctx_id = ctx->id,
+		.task	= task,
+	};
+	enum io_uring_notifier notifier;
+
+	if (!task)
+		notifier = IO_URING_NOTIFIER_CTX_EXIT;
+	else
+		notifier = IO_URING_NOTIFIER_IO_TASK_EXIT;
+
+	srcu_notifier_call_chain(&notifier_chain, notifier, &notifier_data);
+}
+
 static __cold void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
@@ -3069,6 +3108,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
+	io_uring_cancel_notify(ctx, NULL);
+
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while
@@ -3346,6 +3387,11 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
+	if (!cancel_all) {
+		xa_for_each(&tctx->xa, index, node)
+			io_uring_cancel_notify(node->ctx, current);
+	}
+
 	atomic_inc(&tctx->in_cancel);
 	do {
 		bool loop = false;
@@ -4695,6 +4741,8 @@ static int __init io_uring_init(void)
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
 #endif
 
+	srcu_init_notifier_head(&notifier_chain);
+
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 547c30582fb8..1d5588d8a88a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -38,6 +38,10 @@ enum {
 	IOU_STOP_MULTISHOT	= -ECANCELED,
 };
 
+struct io_ring_ctx *io_uring_id_to_ctx(unsigned int id);
+int io_uring_register_notifier(struct notifier_block *nb);
+void io_uring_unregister_notifier(struct notifier_block *nb);
+
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 void io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index c54c627fb6b9..03e3a8c1b712 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -192,3 +192,15 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
+
+int io_uring_cmd_register_notifier(struct notifier_block *nb)
+{
+	return io_uring_register_notifier(nb);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_register_notifier);
+
+void io_uring_cmd_unregister_notifier(struct notifier_block *nb)
+{
+	io_uring_unregister_notifier(nb);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_unregister_notifier);
-- 
2.40.1

