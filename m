Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102AF775C70
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 13:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbjHIL1b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 07:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjHIL10 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 07:27:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E98B1BFE;
        Wed,  9 Aug 2023 04:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07857632A7;
        Wed,  9 Aug 2023 11:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DF6C433C9;
        Wed,  9 Aug 2023 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691580442;
        bh=O+Lu8OwQlnS8y+qRcbD1ZOLSNwXWg/qnqvOqhT3FWAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rn6acSlIQ5RnfD4x/dRSzWEN73Kn+cqQd7s+N0xYrudo1W0rUUWKeChS9yHMMvdh6
         QND7UBfyTA4h1jQq+8DbCrBSxhj2fOxO4pRZs3sbIjoAtJlSeXoOp255SVCSjjrVQa
         6tYGY9idlUpjiMtmekC8z7Q20UnP7eIcQaQ4fIxfj7NbafXNgbtqNfbISezScgkFVH
         4vL7xiKFjGtPDBauu0f+4D+k/h+Zb7IPzdsMAlFJjJj7ClX2M/ccCO4TCSxcJPTf79
         LnxO62zk64RBP15NgA1tKazbvTWm9nGd7uUUMGSdt1LT+KO9BTKDUy2tuTprWDs2/j
         S5OCwrGtW5llw==
Date:   Wed, 9 Aug 2023 13:27:18 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Message-ID: <20230809-ballkontakt-schule-bc15814d31e4@brauner>
References: <20230802231442.275558-1-axboe@kernel.dk>
 <20230802231442.275558-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230802231442.275558-6-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 02, 2023 at 05:14:42PM -0600, Jens Axboe wrote:
> This adds support for an async version of waitid(2), in a fully async
> version. If an event isn't immediately available, wait for a callback
> to trigger a retry.
> 
> The format of the sqe is as follows:
> 
> sqe->len		The 'which', the idtype being queried/waited for.
> sqe->fd			The 'pid' (or id) being waited for.
> sqe->file_index		The 'options' being set.
> sqe->addr2		A pointer to siginfo_t, if any, being filled in.
> 
> buf_index, add3, and waitid_flags are reserved/unused for now.
> waitid_flags will be used for options for this request type. One
> interesting use case may be to add multi-shot support, so that the
> request stays armed and posts a notification every time a monitored
> process state change occurs.
> 
> Note that this does not support rusage, on Arnd's recommendation.
> 
> See the waitid(2) man page for details on the arguments.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |   2 +
>  include/uapi/linux/io_uring.h  |   2 +
>  io_uring/Makefile              |   2 +-
>  io_uring/cancel.c              |   5 +
>  io_uring/io_uring.c            |   3 +
>  io_uring/opdef.c               |   9 +
>  io_uring/waitid.c              | 313 +++++++++++++++++++++++++++++++++
>  io_uring/waitid.h              |  15 ++
>  8 files changed, 350 insertions(+), 1 deletion(-)
>  create mode 100644 io_uring/waitid.c
>  create mode 100644 io_uring/waitid.h
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index a7f03d8d879f..598553877fc2 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -276,6 +276,8 @@ struct io_ring_ctx {
>  	struct hlist_head	futex_list;
>  	struct io_alloc_cache	futex_cache;
>  
> +	struct hlist_head	waitid_list;
> +
>  	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
>  	struct io_sq_data	*sq_data;	/* if using sq thread polling */
>  
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 420f38675769..8fca2cffc343 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -66,6 +66,7 @@ struct io_uring_sqe {
>  		__u32		msg_ring_flags;
>  		__u32		uring_cmd_flags;
>  		__u32		futex_flags;
> +		__u32		waitid_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */
> @@ -239,6 +240,7 @@ enum io_uring_op {
>  	IORING_OP_FUTEX_WAIT,
>  	IORING_OP_FUTEX_WAKE,
>  	IORING_OP_FUTEX_WAITV,
> +	IORING_OP_WAITID,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> diff --git a/io_uring/Makefile b/io_uring/Makefile
> index 2e4779bc550c..e5be47e4fc3b 100644
> --- a/io_uring/Makefile
> +++ b/io_uring/Makefile
> @@ -8,6 +8,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
>  					statx.o net.o msg_ring.o timeout.o \
>  					sqpoll.o fdinfo.o tctx.o poll.o \
>  					cancel.o kbuf.o rsrc.o rw.o opdef.o \
> -					notif.o
> +					notif.o waitid.o
>  obj-$(CONFIG_IO_WQ)		+= io-wq.o
>  obj-$(CONFIG_FUTEX)		+= futex.o
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index 3dba8ccb1cd8..a01f3f41012b 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -16,6 +16,7 @@
>  #include "poll.h"
>  #include "timeout.h"
>  #include "futex.h"
> +#include "waitid.h"
>  #include "cancel.h"
>  
>  struct io_cancel {
> @@ -124,6 +125,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
>  	if (ret != -ENOENT)
>  		return ret;
>  
> +	ret = io_waitid_cancel(ctx, cd, issue_flags);
> +	if (ret != -ENOENT)
> +		return ret;
> +
>  	spin_lock(&ctx->completion_lock);
>  	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
>  		ret = io_timeout_cancel(ctx, cd);
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e52cbdcb29b8..94147e0835bf 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -93,6 +93,7 @@
>  #include "net.h"
>  #include "notif.h"
>  #include "futex.h"
> +#include "waitid.h"
>  
>  #include "timeout.h"
>  #include "poll.h"
> @@ -352,6 +353,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>  	ctx->submit_state.free_list.next = NULL;
>  	INIT_WQ_LIST(&ctx->locked_free_list);
>  	INIT_HLIST_HEAD(&ctx->futex_list);
> +	INIT_HLIST_HEAD(&ctx->waitid_list);
>  	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>  	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
>  	return ctx;
> @@ -3286,6 +3288,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>  	mutex_lock(&ctx->uring_lock);
>  	ret |= io_poll_remove_all(ctx, task, cancel_all);
>  	ret |= io_futex_remove_all(ctx, task, cancel_all);
> +	ret |= io_waitid_remove_all(ctx, task, cancel_all);
>  	mutex_unlock(&ctx->uring_lock);
>  	ret |= io_kill_timeouts(ctx, task, cancel_all);
>  	if (task)
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index b9e1e12cac9c..1c5cfa9d7b31 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -34,6 +34,7 @@
>  #include "cancel.h"
>  #include "rw.h"
>  #include "futex.h"
> +#include "waitid.h"
>  
>  static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
>  {
> @@ -453,6 +454,10 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_eopnotsupp_prep,
>  #endif
>  	},
> +	[IORING_OP_WAITID] = {
> +		.prep			= io_waitid_prep,
> +		.issue			= io_waitid,
> +	},
>  };
>  
>  const struct io_cold_def io_cold_defs[] = {
> @@ -681,6 +686,10 @@ const struct io_cold_def io_cold_defs[] = {
>  	[IORING_OP_FUTEX_WAITV] = {
>  		.name			= "FUTEX_WAITV",
>  	},
> +	[IORING_OP_WAITID] = {
> +		.name			= "WAITID",
> +		.async_size		= sizeof(struct io_waitid_async),
> +	},
>  };
>  
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
> new file mode 100644
> index 000000000000..14ffa07e161a
> --- /dev/null
> +++ b/io_uring/waitid.c
> @@ -0,0 +1,313 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Support for async notification of waitid
> + */
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/compat.h>
> +#include <linux/io_uring.h>
> +
> +#include <uapi/linux/io_uring.h>
> +
> +#include "io_uring.h"
> +#include "cancel.h"
> +#include "waitid.h"
> +#include "../kernel/exit.h"
> +
> +struct io_waitid {
> +	struct file *file;
> +	int which;
> +	pid_t upid;
> +	int options;
> +	struct wait_queue_head *head;
> +	struct siginfo __user *infop;
> +	struct waitid_info info;
> +};
> +
> +static void io_waitid_free(struct io_kiocb *req)
> +{
> +	struct io_waitid_async *iwa = req->async_data;
> +
> +	put_pid(iwa->wo.wo_pid);
> +	kfree(req->async_data);
> +	req->async_data = NULL;
> +	req->flags &= ~REQ_F_ASYNC_DATA;
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)
> +{
> +	struct compat_siginfo __user *infop;
> +	bool ret;
> +
> +	infop = (struct compat_siginfo __user *) iw->infop;
> +
> +	if (!user_write_access_begin(infop, sizeof(*infop)))
> +		return false;
> +
> +	unsafe_put_user(signo, &infop->si_signo, Efault);
> +	unsafe_put_user(0, &infop->si_errno, Efault);
> +	unsafe_put_user(iw->info.cause, &infop->si_code, Efault);
> +	unsafe_put_user(iw->info.pid, &infop->si_pid, Efault);
> +	unsafe_put_user(iw->info.uid, &infop->si_uid, Efault);
> +	unsafe_put_user(iw->info.status, &infop->si_status, Efault);
> +	ret = true;
> +done:
> +	user_write_access_end();
> +	return ret;
> +Efault:
> +	ret = false;
> +	goto done;
> +}
> +#endif
> +
> +static bool io_waitid_copy_si(struct io_kiocb *req, int signo)
> +{
> +	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
> +	bool ret;
> +
> +	if (!iw->infop)
> +		return true;
> +
> +#ifdef CONFIG_COMPAT
> +	if (req->ctx->compat)
> +		return io_waitid_compat_copy_si(iw, signo);
> +#endif
> +
> +	if (!user_write_access_begin(iw->infop, sizeof(*iw->infop)))
> +		return false;
> +
> +	unsafe_put_user(signo, &iw->infop->si_signo, Efault);
> +	unsafe_put_user(0, &iw->infop->si_errno, Efault);
> +	unsafe_put_user(iw->info.cause, &iw->infop->si_code, Efault);
> +	unsafe_put_user(iw->info.pid, &iw->infop->si_pid, Efault);
> +	unsafe_put_user(iw->info.uid, &iw->infop->si_uid, Efault);
> +	unsafe_put_user(iw->info.status, &iw->infop->si_status, Efault);
> +	ret = true;
> +done:
> +	user_write_access_end();
> +	return ret;
> +Efault:
> +	ret = false;
> +	goto done;
> +}
> +
> +static int io_waitid_finish(struct io_kiocb *req, int ret)
> +{
> +	int signo = 0;
> +
> +	if (ret > 0) {
> +		signo = SIGCHLD;
> +		ret = 0;
> +	}
> +
> +	if (!io_waitid_copy_si(req, signo))
> +		ret = -EFAULT;
> +	io_waitid_free(req);
> +	return ret;
> +}
> +
> +static void io_waitid_complete(struct io_kiocb *req, int ret)
> +{
> +	struct io_tw_state ts = { .locked = true };
> +
> +	lockdep_assert_held(&req->ctx->uring_lock);
> +
> +	/*
> +	 * Did cancel find it meanwhile?
> +	 */
> +	if (hlist_unhashed(&req->hash_node))
> +		return;
> +
> +	hlist_del_init(&req->hash_node);
> +
> +	ret = io_waitid_finish(req, ret);
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, 0);
> +	io_req_task_complete(req, &ts);
> +}
> +
> +static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
> +	struct wait_queue_head *head;
> +
> +	head = READ_ONCE(iw->head);
> +	if (head) {
> +		struct io_waitid_async *iwa = req->async_data;
> +
> +		spin_lock_irq(&head->lock);
> +		list_del_init(&iwa->wo.child_wait.entry);
> +		iw->head = NULL;
> +		spin_unlock_irq(&head->lock);
> +		io_waitid_complete(req, -ECANCELED);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
> +		     unsigned int issue_flags)
> +{
> +	struct hlist_node *tmp;
> +	struct io_kiocb *req;
> +	int nr = 0;
> +
> +	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_FD_FIXED))
> +		return -ENOENT;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
> +		if (req->cqe.user_data != cd->data &&
> +		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
> +			continue;
> +		if (__io_waitid_cancel(ctx, req))
> +			nr++;
> +		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
> +			break;
> +	}
> +	io_ring_submit_unlock(ctx, issue_flags);
> +
> +	if (nr)
> +		return nr;
> +
> +	return -ENOENT;
> +}
> +
> +bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
> +			  bool cancel_all)
> +{
> +	struct hlist_node *tmp;
> +	struct io_kiocb *req;
> +	bool found = false;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
> +		if (!io_match_task_safe(req, task, cancel_all))
> +			continue;
> +		__io_waitid_cancel(ctx, req);
> +		found = true;
> +	}
> +
> +	return found;
> +}
> +
> +static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
> +{
> +	struct io_waitid_async *iwa = req->async_data;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	int ret;
> +
> +	/*
> +	 * If we get -ERESTARTSYS here, we need to re-arm and check again
> +	 * to ensure we get another callback. If the retry works, then we can
> +	 * just remove ourselves from the waitqueue again and finish the
> +	 * request.
> +	 */
> +	ret = __do_wait(&iwa->wo);
> +	if (unlikely(ret == -ERESTARTSYS)) {
> +		struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
> +
> +		io_tw_lock(ctx, ts);
> +		iw->head = &current->signal->wait_chldexit;
> +		add_wait_queue(iw->head, &iwa->wo.child_wait);
> +		ret = __do_wait(&iwa->wo);
> +		if (ret == -ERESTARTSYS)
> +			return;
> +
> +		remove_wait_queue(iw->head, &iwa->wo.child_wait);
> +		iw->head = NULL;
> +	}
> +
> +	io_tw_lock(ctx, ts);
> +	io_waitid_complete(req, ret);
> +}
> +
> +static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
> +			  int sync, void *key)
> +{
> +	struct wait_opts *wo = container_of(wait, struct wait_opts, child_wait);
> +	struct io_waitid_async *iwa = container_of(wo, struct io_waitid_async, wo);
> +	struct io_kiocb *req = iwa->req;
> +	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
> +	struct task_struct *p = key;
> +
> +	if (!pid_child_should_wake(wo, p))
> +		return 0;
> +
> +	req->io_task_work.func = io_waitid_cb;
> +	io_req_task_work_add(req);
> +	iw->head = NULL;
> +	list_del_init(&wait->entry);
> +	return 1;
> +}
> +
> +int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
> +
> +	if (sqe->addr || sqe->buf_index || sqe->addr3 || sqe->waitid_flags)
> +		return -EINVAL;
> +
> +	iw->which = READ_ONCE(sqe->len);
> +	iw->options = READ_ONCE(sqe->file_index);
> +	iw->upid = READ_ONCE(sqe->fd);
> +	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +	iw->head = NULL;
> +	return 0;
> +}
> +
> +int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_waitid_async *iwa;
> +	unsigned int f_flags = 0;
> +	int ret;
> +
> +	if (io_alloc_async_data(req))
> +		return -ENOMEM;
> +
> +	iwa = req->async_data;
> +	iwa->req = req;
> +
> +	ret = kernel_waitid_prepare(&iwa->wo, iw->which, iw->upid, &iw->info,
> +					iw->options, NULL, &f_flags);

It seems you're not really using @f_flags at all so I'd just not bother
exposing it in kernel_waitid_prepare(). I think the following (untested)
will let you avoid all this:

diff --git a/kernel/exit.c b/kernel/exit.c
index 1c9d1cbadcd0..33eba306aa51 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1646,10 +1646,11 @@ static long do_wait(struct wait_opts *wo)

 int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
                          struct waitid_info *infop, int options,
-                         struct rusage *ru, unsigned int *f_flags)
+                         struct rusage *ru)
 {
        struct pid *pid = NULL;
        enum pid_type type;
+       unsigned int f_flags = 0;

        if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED|
                        __WNOTHREAD|__WCLONE|__WALL))
@@ -1708,16 +1709,16 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 {
        struct wait_opts wo;
        long ret;
-       unsigned int f_flags = 0;

-       ret = kernel_waitid_prepare(&wo, which, upid, infop, options, ru,
-                                       &f_flags);
+       ret = kernel_waitid_prepare(&wo, which, upid, infop, options, ru);
        if (ret)
                return ret;

        ret = do_wait(&wo);
-       if (!ret && !(options & WNOHANG) && (f_flags & O_NONBLOCK))
+       if (!ret && !(options & WNOHANG) && (wo.wo_flags & WNOHANG)) {
+               WARN_ON_ONCE(which != P_PIDFD);
                ret = -EAGAIN;
+       }

        put_pid(wo.wo_pid);
        return ret;
diff --git a/kernel/exit.h b/kernel/exit.h
index f10207ba1341..278faa26a653 100644
--- a/kernel/exit.h
+++ b/kernel/exit.h
@@ -26,5 +26,5 @@ bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p);
 long __do_wait(struct wait_opts *wo);
 int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
                          struct waitid_info *infop, int options,
-                         struct rusage *ru, unsigned int *f_flags);
+                         struct rusage *ru);
 #endif
