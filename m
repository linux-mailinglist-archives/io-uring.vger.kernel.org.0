Return-Path: <io-uring+bounces-295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD00818BA9
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 16:57:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA80B285109
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 15:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA231D13C;
	Tue, 19 Dec 2023 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AGdvuf4/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7DD1D120
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d3b84173feso4979505ad.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 07:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703001423; x=1703606223; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odPrmVP0EWZPbh3u9s7tw86Pq29GzVY4bR4bF3nhbaQ=;
        b=AGdvuf4/5UATLmtSlK7Ane2EltrUvgk8ajJYeeThI+tI/h5uliv8+73cm65E9XeE5t
         laIjoUb0wP1XV2t5AvQW4e0Ec81r29texzIpdZ55XOfgEGfFNElZLVlYYnQz+1r9Xv6v
         huUz0cysNA3bmG2T6qiIGZrPM0aP5xNWml34GnpP8ujONVSdv4lvKEvRsq8viw2Dt8ib
         PNw/yW5p+uaC6uT4Fbgo95rU0z//GsbOanlsLB2qhEByRCbIcDkKMcnBhMBR/RzMDAO2
         C1RGHEwg3O0zvRaJNca5dI7jivPzXrTTZy6WHQ8XpvbRJP19d+e0BqpOD0KPoMhANy+O
         DWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703001423; x=1703606223;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=odPrmVP0EWZPbh3u9s7tw86Pq29GzVY4bR4bF3nhbaQ=;
        b=eO7aAm/GxKBd8IwkRQZAYHv0tCQMvQFqWXnM5RCLzq8gwck9XKS8sznQbn+BgRS4Zo
         45bx/PbA6e+MOib2r7LMbzK6JgNUtIF55FwSSUCkWHYiyCUo5q6eOlgrSyawoog6HXAj
         q9dpoIV4ny61Aabzt6skJ5patCHyRNaP9Lyk/rF4l4EoSLPRU6NrirxLLUnqQK58eEJi
         zM+vaTPMWXiTfpWoIQuUzc4ycJ/RgGSRyNZd2zyzqT4Vs49pesP64I3iRZOcSvg7rAHb
         2zsJtY7JTonr0SPaVKeLwqn7KGEiPfoApxBeOXcusqeeEU79mg5wE3FFflTqT7yt35VU
         U+kQ==
X-Gm-Message-State: AOJu0YzfqMY2o9tm5TtUcnfvp+naWiBgmwSEfTU76d4Dzt/8ezztYmFs
	T79khlI39NESmsyI+5PIFMXPDjsZFHXQiU8oniP2kg==
X-Google-Smtp-Source: AGHT+IHtb6UajTFNzZcEhLMqOBjSbUYPIsSo1ZqcAQhceFQ5xohgYa63z4S9uxQoqanBZqM6N72AGQ==
X-Received: by 2002:a17:902:b092:b0:1d3:cf95:fd4b with SMTP id p18-20020a170902b09200b001d3cf95fd4bmr4513227plr.6.1703001422988;
        Tue, 19 Dec 2023 07:57:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id s17-20020a170902ea1100b001d39ced922asm6397612plg.97.2023.12.19.07.57.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 07:57:02 -0800 (PST)
Message-ID: <52bf7df6-8ab2-4a9b-825c-8751b4719dc7@kernel.dk>
Date: Tue, 19 Dec 2023 08:57:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/register: move io_uring_register(2) related code to
 register.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Most of this code is basically self contained, move it out of the core
io_uring file to bring a bit more separation to the registration related
bits. This moves another ~10% of the code into register.c.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/Makefile b/io_uring/Makefile
index e5be47e4fc3b..2cdc51825405 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
 					cancel.o kbuf.o rsrc.o rw.o opdef.o \
-					notif.o waitid.o
+					notif.o waitid.o register.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5c946f3ed91c..2b24ce692b0b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -86,6 +86,7 @@
 #include "opdef.h"
 #include "refs.h"
 #include "tctx.h"
+#include "register.h"
 #include "sqpoll.h"
 #include "fdinfo.h"
 #include "kbuf.h"
@@ -104,9 +105,6 @@
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
-#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
-				 IORING_REGISTER_LAST + IORING_OP_LAST)
-
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
@@ -130,11 +128,6 @@ enum {
 	IO_CHECK_CQ_DROPPED_BIT,
 };
 
-enum {
-	IO_EVENTFD_OP_SIGNAL_BIT,
-	IO_EVENTFD_OP_FREE_BIT,
-};
-
 struct io_defer_entry {
 	struct list_head	list;
 	struct io_kiocb		*req;
@@ -555,8 +548,7 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 	}
 }
 
-
-static void io_eventfd_ops(struct rcu_head *rcu)
+void io_eventfd_ops(struct rcu_head *rcu)
 {
 	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
 	int ops = atomic_xchg(&ev_fd->ops, 0);
@@ -2835,61 +2827,6 @@ static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries
 	return off;
 }
 
-static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
-			       unsigned int eventfd_async)
-{
-	struct io_ev_fd *ev_fd;
-	__s32 __user *fds = arg;
-	int fd;
-
-	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
-					lockdep_is_held(&ctx->uring_lock));
-	if (ev_fd)
-		return -EBUSY;
-
-	if (copy_from_user(&fd, fds, sizeof(*fds)))
-		return -EFAULT;
-
-	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
-	if (!ev_fd)
-		return -ENOMEM;
-
-	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
-	if (IS_ERR(ev_fd->cq_ev_fd)) {
-		int ret = PTR_ERR(ev_fd->cq_ev_fd);
-		kfree(ev_fd);
-		return ret;
-	}
-
-	spin_lock(&ctx->completion_lock);
-	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
-	spin_unlock(&ctx->completion_lock);
-
-	ev_fd->eventfd_async = eventfd_async;
-	ctx->has_evfd = true;
-	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
-	atomic_set(&ev_fd->refs, 1);
-	atomic_set(&ev_fd->ops, 0);
-	return 0;
-}
-
-static int io_eventfd_unregister(struct io_ring_ctx *ctx)
-{
-	struct io_ev_fd *ev_fd;
-
-	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
-					lockdep_is_held(&ctx->uring_lock));
-	if (ev_fd) {
-		ctx->has_evfd = false;
-		rcu_assign_pointer(ctx->io_ev_fd, NULL);
-		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_FREE_BIT), &ev_fd->ops))
-			call_rcu(&ev_fd->rcu, io_eventfd_ops);
-		return 0;
-	}
-
-	return -ENXIO;
-}
-
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
 	struct io_kiocb *req;
@@ -2988,7 +2925,7 @@ static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 	percpu_ref_put(&ctx->refs);
 }
 
-static __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
+__cold void io_activate_pollwq(struct io_ring_ctx *ctx)
 {
 	spin_lock(&ctx->completion_lock);
 	/* already activated or in progress */
@@ -3047,19 +2984,6 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
-{
-	const struct cred *creds;
-
-	creds = xa_erase(&ctx->personalities, id);
-	if (creds) {
-		put_cred(creds);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
@@ -4162,506 +4086,6 @@ SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 	return io_uring_setup(entries, params);
 }
 
-static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
-			   unsigned nr_args)
-{
-	struct io_uring_probe *p;
-	size_t size;
-	int i, ret;
-
-	size = struct_size(p, ops, nr_args);
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
-	p = kzalloc(size, GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	ret = -EFAULT;
-	if (copy_from_user(p, arg, size))
-		goto out;
-	ret = -EINVAL;
-	if (memchr_inv(p, 0, size))
-		goto out;
-
-	p->last_op = IORING_OP_LAST - 1;
-	if (nr_args > IORING_OP_LAST)
-		nr_args = IORING_OP_LAST;
-
-	for (i = 0; i < nr_args; i++) {
-		p->ops[i].op = i;
-		if (!io_issue_defs[i].not_supported)
-			p->ops[i].flags = IO_URING_OP_SUPPORTED;
-	}
-	p->ops_len = i;
-
-	ret = 0;
-	if (copy_to_user(arg, p, size))
-		ret = -EFAULT;
-out:
-	kfree(p);
-	return ret;
-}
-
-static int io_register_personality(struct io_ring_ctx *ctx)
-{
-	const struct cred *creds;
-	u32 id;
-	int ret;
-
-	creds = get_current_cred();
-
-	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
-			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (ret < 0) {
-		put_cred(creds);
-		return ret;
-	}
-	return id;
-}
-
-static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
-					   void __user *arg, unsigned int nr_args)
-{
-	struct io_uring_restriction *res;
-	size_t size;
-	int i, ret;
-
-	/* Restrictions allowed only if rings started disabled */
-	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
-		return -EBADFD;
-
-	/* We allow only a single restrictions registration */
-	if (ctx->restrictions.registered)
-		return -EBUSY;
-
-	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
-		return -EINVAL;
-
-	size = array_size(nr_args, sizeof(*res));
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
-
-	res = memdup_user(arg, size);
-	if (IS_ERR(res))
-		return PTR_ERR(res);
-
-	ret = 0;
-
-	for (i = 0; i < nr_args; i++) {
-		switch (res[i].opcode) {
-		case IORING_RESTRICTION_REGISTER_OP:
-			if (res[i].register_op >= IORING_REGISTER_LAST) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			__set_bit(res[i].register_op,
-				  ctx->restrictions.register_op);
-			break;
-		case IORING_RESTRICTION_SQE_OP:
-			if (res[i].sqe_op >= IORING_OP_LAST) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
-			break;
-		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
-			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
-			break;
-		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
-			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
-			break;
-		default:
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-out:
-	/* Reset all restrictions if an error happened */
-	if (ret != 0)
-		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
-	else
-		ctx->restrictions.registered = true;
-
-	kfree(res);
-	return ret;
-}
-
-static int io_register_enable_rings(struct io_ring_ctx *ctx)
-{
-	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
-		return -EBADFD;
-
-	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
-		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
-		/*
-		 * Lazy activation attempts would fail if it was polled before
-		 * submitter_task is set.
-		 */
-		if (wq_has_sleeper(&ctx->poll_wq))
-			io_activate_pollwq(ctx);
-	}
-
-	if (ctx->restrictions.registered)
-		ctx->restricted = 1;
-
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
-	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
-		wake_up(&ctx->sq_data->wait);
-	return 0;
-}
-
-static __cold int __io_register_iowq_aff(struct io_ring_ctx *ctx,
-					 cpumask_var_t new_mask)
-{
-	int ret;
-
-	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
-		ret = io_wq_cpu_affinity(current->io_uring, new_mask);
-	} else {
-		mutex_unlock(&ctx->uring_lock);
-		ret = io_sqpoll_wq_cpu_affinity(ctx, new_mask);
-		mutex_lock(&ctx->uring_lock);
-	}
-
-	return ret;
-}
-
-static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
-				       void __user *arg, unsigned len)
-{
-	cpumask_var_t new_mask;
-	int ret;
-
-	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_clear(new_mask);
-	if (len > cpumask_size())
-		len = cpumask_size();
-
-	if (in_compat_syscall()) {
-		ret = compat_get_bitmap(cpumask_bits(new_mask),
-					(const compat_ulong_t __user *)arg,
-					len * 8 /* CHAR_BIT */);
-	} else {
-		ret = copy_from_user(new_mask, arg, len);
-	}
-
-	if (ret) {
-		free_cpumask_var(new_mask);
-		return -EFAULT;
-	}
-
-	ret = __io_register_iowq_aff(ctx, new_mask);
-	free_cpumask_var(new_mask);
-	return ret;
-}
-
-static __cold int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
-{
-	return __io_register_iowq_aff(ctx, NULL);
-}
-
-static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
-					       void __user *arg)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_tctx_node *node;
-	struct io_uring_task *tctx = NULL;
-	struct io_sq_data *sqd = NULL;
-	__u32 new_count[2];
-	int i, ret;
-
-	if (copy_from_user(new_count, arg, sizeof(new_count)))
-		return -EFAULT;
-	for (i = 0; i < ARRAY_SIZE(new_count); i++)
-		if (new_count[i] > INT_MAX)
-			return -EINVAL;
-
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		sqd = ctx->sq_data;
-		if (sqd) {
-			/*
-			 * Observe the correct sqd->lock -> ctx->uring_lock
-			 * ordering. Fine to drop uring_lock here, we hold
-			 * a ref to the ctx.
-			 */
-			refcount_inc(&sqd->refs);
-			mutex_unlock(&ctx->uring_lock);
-			mutex_lock(&sqd->lock);
-			mutex_lock(&ctx->uring_lock);
-			if (sqd->thread)
-				tctx = sqd->thread->io_uring;
-		}
-	} else {
-		tctx = current->io_uring;
-	}
-
-	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
-
-	for (i = 0; i < ARRAY_SIZE(new_count); i++)
-		if (new_count[i])
-			ctx->iowq_limits[i] = new_count[i];
-	ctx->iowq_limits_set = true;
-
-	if (tctx && tctx->io_wq) {
-		ret = io_wq_max_workers(tctx->io_wq, new_count);
-		if (ret)
-			goto err;
-	} else {
-		memset(new_count, 0, sizeof(new_count));
-	}
-
-	if (sqd) {
-		mutex_unlock(&sqd->lock);
-		io_put_sq_data(sqd);
-	}
-
-	if (copy_to_user(arg, new_count, sizeof(new_count)))
-		return -EFAULT;
-
-	/* that's it for SQPOLL, only the SQPOLL task creates requests */
-	if (sqd)
-		return 0;
-
-	/* now propagate the restriction to all registered users */
-	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
-		struct io_uring_task *tctx = node->task->io_uring;
-
-		if (WARN_ON_ONCE(!tctx->io_wq))
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(new_count); i++)
-			new_count[i] = ctx->iowq_limits[i];
-		/* ignore errors, it always returns zero anyway */
-		(void)io_wq_max_workers(tctx->io_wq, new_count);
-	}
-	return 0;
-err:
-	if (sqd) {
-		mutex_unlock(&sqd->lock);
-		io_put_sq_data(sqd);
-	}
-	return ret;
-}
-
-static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
-			       void __user *arg, unsigned nr_args)
-	__releases(ctx->uring_lock)
-	__acquires(ctx->uring_lock)
-{
-	int ret;
-
-	/*
-	 * We don't quiesce the refs for register anymore and so it can't be
-	 * dying as we're holding a file ref here.
-	 */
-	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
-		return -ENXIO;
-
-	if (ctx->submitter_task && ctx->submitter_task != current)
-		return -EEXIST;
-
-	if (ctx->restricted) {
-		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
-		if (!test_bit(opcode, ctx->restrictions.register_op))
-			return -EACCES;
-	}
-
-	switch (opcode) {
-	case IORING_REGISTER_BUFFERS:
-		ret = -EFAULT;
-		if (!arg)
-			break;
-		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
-		break;
-	case IORING_UNREGISTER_BUFFERS:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_sqe_buffers_unregister(ctx);
-		break;
-	case IORING_REGISTER_FILES:
-		ret = -EFAULT;
-		if (!arg)
-			break;
-		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
-		break;
-	case IORING_UNREGISTER_FILES:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_sqe_files_unregister(ctx);
-		break;
-	case IORING_REGISTER_FILES_UPDATE:
-		ret = io_register_files_update(ctx, arg, nr_args);
-		break;
-	case IORING_REGISTER_EVENTFD:
-		ret = -EINVAL;
-		if (nr_args != 1)
-			break;
-		ret = io_eventfd_register(ctx, arg, 0);
-		break;
-	case IORING_REGISTER_EVENTFD_ASYNC:
-		ret = -EINVAL;
-		if (nr_args != 1)
-			break;
-		ret = io_eventfd_register(ctx, arg, 1);
-		break;
-	case IORING_UNREGISTER_EVENTFD:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_eventfd_unregister(ctx);
-		break;
-	case IORING_REGISTER_PROBE:
-		ret = -EINVAL;
-		if (!arg || nr_args > 256)
-			break;
-		ret = io_probe(ctx, arg, nr_args);
-		break;
-	case IORING_REGISTER_PERSONALITY:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_register_personality(ctx);
-		break;
-	case IORING_UNREGISTER_PERSONALITY:
-		ret = -EINVAL;
-		if (arg)
-			break;
-		ret = io_unregister_personality(ctx, nr_args);
-		break;
-	case IORING_REGISTER_ENABLE_RINGS:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_register_enable_rings(ctx);
-		break;
-	case IORING_REGISTER_RESTRICTIONS:
-		ret = io_register_restrictions(ctx, arg, nr_args);
-		break;
-	case IORING_REGISTER_FILES2:
-		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_FILE);
-		break;
-	case IORING_REGISTER_FILES_UPDATE2:
-		ret = io_register_rsrc_update(ctx, arg, nr_args,
-					      IORING_RSRC_FILE);
-		break;
-	case IORING_REGISTER_BUFFERS2:
-		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_BUFFER);
-		break;
-	case IORING_REGISTER_BUFFERS_UPDATE:
-		ret = io_register_rsrc_update(ctx, arg, nr_args,
-					      IORING_RSRC_BUFFER);
-		break;
-	case IORING_REGISTER_IOWQ_AFF:
-		ret = -EINVAL;
-		if (!arg || !nr_args)
-			break;
-		ret = io_register_iowq_aff(ctx, arg, nr_args);
-		break;
-	case IORING_UNREGISTER_IOWQ_AFF:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_unregister_iowq_aff(ctx);
-		break;
-	case IORING_REGISTER_IOWQ_MAX_WORKERS:
-		ret = -EINVAL;
-		if (!arg || nr_args != 2)
-			break;
-		ret = io_register_iowq_max_workers(ctx, arg);
-		break;
-	case IORING_REGISTER_RING_FDS:
-		ret = io_ringfd_register(ctx, arg, nr_args);
-		break;
-	case IORING_UNREGISTER_RING_FDS:
-		ret = io_ringfd_unregister(ctx, arg, nr_args);
-		break;
-	case IORING_REGISTER_PBUF_RING:
-		ret = -EINVAL;
-		if (!arg || nr_args != 1)
-			break;
-		ret = io_register_pbuf_ring(ctx, arg);
-		break;
-	case IORING_UNREGISTER_PBUF_RING:
-		ret = -EINVAL;
-		if (!arg || nr_args != 1)
-			break;
-		ret = io_unregister_pbuf_ring(ctx, arg);
-		break;
-	case IORING_REGISTER_SYNC_CANCEL:
-		ret = -EINVAL;
-		if (!arg || nr_args != 1)
-			break;
-		ret = io_sync_cancel(ctx, arg);
-		break;
-	case IORING_REGISTER_FILE_ALLOC_RANGE:
-		ret = -EINVAL;
-		if (!arg || nr_args)
-			break;
-		ret = io_register_file_alloc_range(ctx, arg);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
-		void __user *, arg, unsigned int, nr_args)
-{
-	struct io_ring_ctx *ctx;
-	long ret = -EBADF;
-	struct file *file;
-	bool use_registered_ring;
-
-	use_registered_ring = !!(opcode & IORING_REGISTER_USE_REGISTERED_RING);
-	opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
-
-	if (opcode >= IORING_REGISTER_LAST)
-		return -EINVAL;
-
-	if (use_registered_ring) {
-		/*
-		 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
-		 * need only dereference our task private array to find it.
-		 */
-		struct io_uring_task *tctx = current->io_uring;
-
-		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
-			return -EINVAL;
-		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
-		file = tctx->registered_rings[fd];
-		if (unlikely(!file))
-			return -EBADF;
-	} else {
-		file = fget(fd);
-		if (unlikely(!file))
-			return -EBADF;
-		ret = -EOPNOTSUPP;
-		if (!io_is_uring_fops(file))
-			goto out_fput;
-	}
-
-	ctx = file->private_data;
-
-	mutex_lock(&ctx->uring_lock);
-	ret = __io_uring_register(ctx, opcode, arg, nr_args);
-	mutex_unlock(&ctx->uring_lock);
-	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);
-out_fput:
-	if (!use_registered_ring)
-		fput(file);
-	return ret;
-}
-
 static int __init io_uring_init(void)
 {
 #define __BUILD_BUG_VERIFY_OFFSET_SIZE(stype, eoffset, esize, ename) do { \
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ef783a2444ac..1112c198e516 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -79,6 +79,14 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 void *io_mem_alloc(size_t size);
 void io_mem_free(void *ptr);
 
+enum {
+	IO_EVENTFD_OP_SIGNAL_BIT,
+	IO_EVENTFD_OP_FREE_BIT,
+};
+
+void io_eventfd_ops(struct rcu_head *rcu);
+void io_activate_pollwq(struct io_ring_ctx *ctx);
+
 #if defined(CONFIG_PROVE_LOCKING)
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/register.c b/io_uring/register.c
new file mode 100644
index 000000000000..a4286029e920
--- /dev/null
+++ b/io_uring/register.c
@@ -0,0 +1,599 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Code related to the io_uring_register() syscall
+ *
+ * Copyright (C) 2023 Jens Axboe
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/syscalls.h>
+#include <linux/refcount.h>
+#include <linux/bits.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/nospec.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring_types.h>
+
+#include "io_uring.h"
+#include "opdef.h"
+#include "tctx.h"
+#include "rsrc.h"
+#include "sqpoll.h"
+#include "register.h"
+#include "cancel.h"
+#include "kbuf.h"
+
+#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
+				 IORING_REGISTER_LAST + IORING_OP_LAST)
+
+static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			       unsigned int eventfd_async)
+{
+	struct io_ev_fd *ev_fd;
+	__s32 __user *fds = arg;
+	int fd;
+
+	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
+					lockdep_is_held(&ctx->uring_lock));
+	if (ev_fd)
+		return -EBUSY;
+
+	if (copy_from_user(&fd, fds, sizeof(*fds)))
+		return -EFAULT;
+
+	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
+	if (!ev_fd)
+		return -ENOMEM;
+
+	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(ev_fd->cq_ev_fd)) {
+		int ret = PTR_ERR(ev_fd->cq_ev_fd);
+		kfree(ev_fd);
+		return ret;
+	}
+
+	spin_lock(&ctx->completion_lock);
+	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
+	spin_unlock(&ctx->completion_lock);
+
+	ev_fd->eventfd_async = eventfd_async;
+	ctx->has_evfd = true;
+	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
+	atomic_set(&ev_fd->refs, 1);
+	atomic_set(&ev_fd->ops, 0);
+	return 0;
+}
+
+int io_eventfd_unregister(struct io_ring_ctx *ctx)
+{
+	struct io_ev_fd *ev_fd;
+
+	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
+					lockdep_is_held(&ctx->uring_lock));
+	if (ev_fd) {
+		ctx->has_evfd = false;
+		rcu_assign_pointer(ctx->io_ev_fd, NULL);
+		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_FREE_BIT), &ev_fd->ops))
+			call_rcu(&ev_fd->rcu, io_eventfd_ops);
+		return 0;
+	}
+
+	return -ENXIO;
+}
+
+static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
+			   unsigned nr_args)
+{
+	struct io_uring_probe *p;
+	size_t size;
+	int i, ret;
+
+	size = struct_size(p, ops, nr_args);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+	p = kzalloc(size, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(p, arg, size))
+		goto out;
+	ret = -EINVAL;
+	if (memchr_inv(p, 0, size))
+		goto out;
+
+	p->last_op = IORING_OP_LAST - 1;
+	if (nr_args > IORING_OP_LAST)
+		nr_args = IORING_OP_LAST;
+
+	for (i = 0; i < nr_args; i++) {
+		p->ops[i].op = i;
+		if (!io_issue_defs[i].not_supported)
+			p->ops[i].flags = IO_URING_OP_SUPPORTED;
+	}
+	p->ops_len = i;
+
+	ret = 0;
+	if (copy_to_user(arg, p, size))
+		ret = -EFAULT;
+out:
+	kfree(p);
+	return ret;
+}
+
+int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
+{
+	const struct cred *creds;
+
+	creds = xa_erase(&ctx->personalities, id);
+	if (creds) {
+		put_cred(creds);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+
+static int io_register_personality(struct io_ring_ctx *ctx)
+{
+	const struct cred *creds;
+	u32 id;
+	int ret;
+
+	creds = get_current_cred();
+
+	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
+			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
+	if (ret < 0) {
+		put_cred(creds);
+		return ret;
+	}
+	return id;
+}
+
+static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
+					   void __user *arg, unsigned int nr_args)
+{
+	struct io_uring_restriction *res;
+	size_t size;
+	int i, ret;
+
+	/* Restrictions allowed only if rings started disabled */
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EBADFD;
+
+	/* We allow only a single restrictions registration */
+	if (ctx->restrictions.registered)
+		return -EBUSY;
+
+	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
+		return -EINVAL;
+
+	size = array_size(nr_args, sizeof(*res));
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	res = memdup_user(arg, size);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	ret = 0;
+
+	for (i = 0; i < nr_args; i++) {
+		switch (res[i].opcode) {
+		case IORING_RESTRICTION_REGISTER_OP:
+			if (res[i].register_op >= IORING_REGISTER_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].register_op,
+				  ctx->restrictions.register_op);
+			break;
+		case IORING_RESTRICTION_SQE_OP:
+			if (res[i].sqe_op >= IORING_OP_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
+			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
+			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	/* Reset all restrictions if an error happened */
+	if (ret != 0)
+		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+	else
+		ctx->restrictions.registered = true;
+
+	kfree(res);
+	return ret;
+}
+
+static int io_register_enable_rings(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EBADFD;
+
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
+		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
+		/*
+		 * Lazy activation attempts would fail if it was polled before
+		 * submitter_task is set.
+		 */
+		if (wq_has_sleeper(&ctx->poll_wq))
+			io_activate_pollwq(ctx);
+	}
+
+	if (ctx->restrictions.registered)
+		ctx->restricted = 1;
+
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
+		wake_up(&ctx->sq_data->wait);
+	return 0;
+}
+
+static __cold int __io_register_iowq_aff(struct io_ring_ctx *ctx,
+					 cpumask_var_t new_mask)
+{
+	int ret;
+
+	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		ret = io_wq_cpu_affinity(current->io_uring, new_mask);
+	} else {
+		mutex_unlock(&ctx->uring_lock);
+		ret = io_sqpoll_wq_cpu_affinity(ctx, new_mask);
+		mutex_lock(&ctx->uring_lock);
+	}
+
+	return ret;
+}
+
+static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
+				       void __user *arg, unsigned len)
+{
+	cpumask_var_t new_mask;
+	int ret;
+
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_clear(new_mask);
+	if (len > cpumask_size())
+		len = cpumask_size();
+
+	if (in_compat_syscall()) {
+		ret = compat_get_bitmap(cpumask_bits(new_mask),
+					(const compat_ulong_t __user *)arg,
+					len * 8 /* CHAR_BIT */);
+	} else {
+		ret = copy_from_user(new_mask, arg, len);
+	}
+
+	if (ret) {
+		free_cpumask_var(new_mask);
+		return -EFAULT;
+	}
+
+	ret = __io_register_iowq_aff(ctx, new_mask);
+	free_cpumask_var(new_mask);
+	return ret;
+}
+
+static __cold int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
+{
+	return __io_register_iowq_aff(ctx, NULL);
+}
+
+static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
+					       void __user *arg)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_tctx_node *node;
+	struct io_uring_task *tctx = NULL;
+	struct io_sq_data *sqd = NULL;
+	__u32 new_count[2];
+	int i, ret;
+
+	if (copy_from_user(new_count, arg, sizeof(new_count)))
+		return -EFAULT;
+	for (i = 0; i < ARRAY_SIZE(new_count); i++)
+		if (new_count[i] > INT_MAX)
+			return -EINVAL;
+
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		sqd = ctx->sq_data;
+		if (sqd) {
+			/*
+			 * Observe the correct sqd->lock -> ctx->uring_lock
+			 * ordering. Fine to drop uring_lock here, we hold
+			 * a ref to the ctx.
+			 */
+			refcount_inc(&sqd->refs);
+			mutex_unlock(&ctx->uring_lock);
+			mutex_lock(&sqd->lock);
+			mutex_lock(&ctx->uring_lock);
+			if (sqd->thread)
+				tctx = sqd->thread->io_uring;
+		}
+	} else {
+		tctx = current->io_uring;
+	}
+
+	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
+
+	for (i = 0; i < ARRAY_SIZE(new_count); i++)
+		if (new_count[i])
+			ctx->iowq_limits[i] = new_count[i];
+	ctx->iowq_limits_set = true;
+
+	if (tctx && tctx->io_wq) {
+		ret = io_wq_max_workers(tctx->io_wq, new_count);
+		if (ret)
+			goto err;
+	} else {
+		memset(new_count, 0, sizeof(new_count));
+	}
+
+	if (sqd) {
+		mutex_unlock(&sqd->lock);
+		io_put_sq_data(sqd);
+	}
+
+	if (copy_to_user(arg, new_count, sizeof(new_count)))
+		return -EFAULT;
+
+	/* that's it for SQPOLL, only the SQPOLL task creates requests */
+	if (sqd)
+		return 0;
+
+	/* now propagate the restriction to all registered users */
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		if (WARN_ON_ONCE(!tctx->io_wq))
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(new_count); i++)
+			new_count[i] = ctx->iowq_limits[i];
+		/* ignore errors, it always returns zero anyway */
+		(void)io_wq_max_workers(tctx->io_wq, new_count);
+	}
+	return 0;
+err:
+	if (sqd) {
+		mutex_unlock(&sqd->lock);
+		io_put_sq_data(sqd);
+	}
+	return ret;
+}
+
+static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
+			       void __user *arg, unsigned nr_args)
+	__releases(ctx->uring_lock)
+	__acquires(ctx->uring_lock)
+{
+	int ret;
+
+	/*
+	 * We don't quiesce the refs for register anymore and so it can't be
+	 * dying as we're holding a file ref here.
+	 */
+	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
+		return -ENXIO;
+
+	if (ctx->submitter_task && ctx->submitter_task != current)
+		return -EEXIST;
+
+	if (ctx->restricted) {
+		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
+		if (!test_bit(opcode, ctx->restrictions.register_op))
+			return -EACCES;
+	}
+
+	switch (opcode) {
+	case IORING_REGISTER_BUFFERS:
+		ret = -EFAULT;
+		if (!arg)
+			break;
+		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
+		break;
+	case IORING_UNREGISTER_BUFFERS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_sqe_buffers_unregister(ctx);
+		break;
+	case IORING_REGISTER_FILES:
+		ret = -EFAULT;
+		if (!arg)
+			break;
+		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
+		break;
+	case IORING_UNREGISTER_FILES:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_sqe_files_unregister(ctx);
+		break;
+	case IORING_REGISTER_FILES_UPDATE:
+		ret = io_register_files_update(ctx, arg, nr_args);
+		break;
+	case IORING_REGISTER_EVENTFD:
+		ret = -EINVAL;
+		if (nr_args != 1)
+			break;
+		ret = io_eventfd_register(ctx, arg, 0);
+		break;
+	case IORING_REGISTER_EVENTFD_ASYNC:
+		ret = -EINVAL;
+		if (nr_args != 1)
+			break;
+		ret = io_eventfd_register(ctx, arg, 1);
+		break;
+	case IORING_UNREGISTER_EVENTFD:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_eventfd_unregister(ctx);
+		break;
+	case IORING_REGISTER_PROBE:
+		ret = -EINVAL;
+		if (!arg || nr_args > 256)
+			break;
+		ret = io_probe(ctx, arg, nr_args);
+		break;
+	case IORING_REGISTER_PERSONALITY:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_register_personality(ctx);
+		break;
+	case IORING_UNREGISTER_PERSONALITY:
+		ret = -EINVAL;
+		if (arg)
+			break;
+		ret = io_unregister_personality(ctx, nr_args);
+		break;
+	case IORING_REGISTER_ENABLE_RINGS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_register_enable_rings(ctx);
+		break;
+	case IORING_REGISTER_RESTRICTIONS:
+		ret = io_register_restrictions(ctx, arg, nr_args);
+		break;
+	case IORING_REGISTER_FILES2:
+		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_FILE);
+		break;
+	case IORING_REGISTER_FILES_UPDATE2:
+		ret = io_register_rsrc_update(ctx, arg, nr_args,
+					      IORING_RSRC_FILE);
+		break;
+	case IORING_REGISTER_BUFFERS2:
+		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_BUFFER);
+		break;
+	case IORING_REGISTER_BUFFERS_UPDATE:
+		ret = io_register_rsrc_update(ctx, arg, nr_args,
+					      IORING_RSRC_BUFFER);
+		break;
+	case IORING_REGISTER_IOWQ_AFF:
+		ret = -EINVAL;
+		if (!arg || !nr_args)
+			break;
+		ret = io_register_iowq_aff(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_IOWQ_AFF:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_unregister_iowq_aff(ctx);
+		break;
+	case IORING_REGISTER_IOWQ_MAX_WORKERS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 2)
+			break;
+		ret = io_register_iowq_max_workers(ctx, arg);
+		break;
+	case IORING_REGISTER_RING_FDS:
+		ret = io_ringfd_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_RING_FDS:
+		ret = io_ringfd_unregister(ctx, arg, nr_args);
+		break;
+	case IORING_REGISTER_PBUF_RING:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_pbuf_ring(ctx, arg);
+		break;
+	case IORING_UNREGISTER_PBUF_RING:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_unregister_pbuf_ring(ctx, arg);
+		break;
+	case IORING_REGISTER_SYNC_CANCEL:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_sync_cancel(ctx, arg);
+		break;
+	case IORING_REGISTER_FILE_ALLOC_RANGE:
+		ret = -EINVAL;
+		if (!arg || nr_args)
+			break;
+		ret = io_register_file_alloc_range(ctx, arg);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
+		void __user *, arg, unsigned int, nr_args)
+{
+	struct io_ring_ctx *ctx;
+	long ret = -EBADF;
+	struct file *file;
+	bool use_registered_ring;
+
+	use_registered_ring = !!(opcode & IORING_REGISTER_USE_REGISTERED_RING);
+	opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
+
+	if (opcode >= IORING_REGISTER_LAST)
+		return -EINVAL;
+
+	if (use_registered_ring) {
+		/*
+		 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
+		 * need only dereference our task private array to find it.
+		 */
+		struct io_uring_task *tctx = current->io_uring;
+
+		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
+			return -EINVAL;
+		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
+		file = tctx->registered_rings[fd];
+		if (unlikely(!file))
+			return -EBADF;
+	} else {
+		file = fget(fd);
+		if (unlikely(!file))
+			return -EBADF;
+		ret = -EOPNOTSUPP;
+		if (!io_is_uring_fops(file))
+			goto out_fput;
+	}
+
+	ctx = file->private_data;
+
+	mutex_lock(&ctx->uring_lock);
+	ret = __io_uring_register(ctx, opcode, arg, nr_args);
+	mutex_unlock(&ctx->uring_lock);
+	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);
+out_fput:
+	if (!use_registered_ring)
+		fput(file);
+	return ret;
+}
diff --git a/io_uring/register.h b/io_uring/register.h
new file mode 100644
index 000000000000..c9da997d503c
--- /dev/null
+++ b/io_uring/register.h
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IORING_REGISTER_H
+#define IORING_REGISTER_H
+
+int io_eventfd_unregister(struct io_ring_ctx *ctx);
+int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id);
+
+#endif

-- 
Jens Axboe


