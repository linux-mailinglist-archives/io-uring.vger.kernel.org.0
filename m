Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B81B3991AA
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 19:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFBRbZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 13:31:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229876AbhFBRbZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 13:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622654981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jeG4WMRk0ILXYi5qfnkEfZj2m5iBA39KB7rY7qu7LWY=;
        b=R1zY392MtMhss3OdJAxh+4j1Pc+pSVc/zPd6INVJllG71GyIIQO9cyLEXzAvegTpKZ7BG9
        iqy0XdSBeAXWNL4rqp+R9ocTXyBzEYydVPDt+Q80T9KBQkpvJait1DPJRUFC7gHTr0+wBt
        uNKlm8hoRAg60mgn9UJMElCEATCxSF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-JkUbnDbKOimV2LEpEuklEw-1; Wed, 02 Jun 2021 13:29:40 -0400
X-MC-Unique: JkUbnDbKOimV2LEpEuklEw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CF39101371D;
        Wed,  2 Jun 2021 17:29:38 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B070360BD9;
        Wed,  2 Jun 2021 17:29:27 +0000 (UTC)
Date:   Wed, 2 Jun 2021 13:29:24 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/9] audit, io_uring, io-wq: add some basic audit
 support to io_uring
Message-ID: <20210602172924.GM447005@madcap2.tricolour.ca>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162163379461.8379.9691291608621179559.stgit@sifl>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-21 17:49, Paul Moore wrote:
> WARNING - This is a work in progress and should not be merged
> anywhere important.  It is almost surely not complete, and while it
> probably compiles it likely hasn't been booted and will do terrible
> things.  You have been warned.
> 
> This patch adds basic auditing to io_uring operations, regardless of
> their context.  This is accomplished by allocating audit_context
> structures for the io-wq worker and io_uring SQPOLL kernel threads
> as well as explicitly auditing the io_uring operations in
> io_issue_sqe().  The io_uring operations are audited using a new
> AUDIT_URINGOP record, an example is shown below:
> 
>   % <TODO - insert AUDIT_URINGOP record example>
> 
> Thanks to Richard Guy Briggs for review and feedback.
> 
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  fs/io-wq.c                 |    4 +
>  fs/io_uring.c              |   11 +++
>  include/linux/audit.h      |   17 ++++
>  include/uapi/linux/audit.h |    1 
>  kernel/audit.h             |    2 +
>  kernel/auditsc.c           |  173 ++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 208 insertions(+)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 5361a9b4b47b..8af09a3336e0 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -16,6 +16,7 @@
>  #include <linux/rculist_nulls.h>
>  #include <linux/cpu.h>
>  #include <linux/tracehook.h>
> +#include <linux/audit.h>
>  
>  #include "io-wq.h"
>  
> @@ -535,6 +536,8 @@ static int io_wqe_worker(void *data)
>  	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
>  	set_task_comm(current, buf);
>  
> +	audit_alloc_kernel(current);
> +
>  	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
>  		long ret;
>  
> @@ -573,6 +576,7 @@ static int io_wqe_worker(void *data)
>  			raw_spin_unlock_irq(&wqe->lock);
>  	}
>  
> +	audit_free(current);
>  	io_worker_exit(worker);
>  	return 0;
>  }
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e481ac8a757a..e9941d1ad8fd 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -78,6 +78,7 @@
>  #include <linux/task_work.h>
>  #include <linux/pagemap.h>
>  #include <linux/io_uring.h>
> +#include <linux/audit.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -6105,6 +6106,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	if (req->work.creds && req->work.creds != current_cred())
>  		creds = override_creds(req->work.creds);
>  
> +	if (req->opcode < IORING_OP_LAST)
> +		audit_uring_entry(req->opcode);
> +
>  	switch (req->opcode) {
>  	case IORING_OP_NOP:
>  		ret = io_nop(req, issue_flags);
> @@ -6211,6 +6215,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  		break;
>  	}
>  
> +	if (req->opcode < IORING_OP_LAST)
> +		audit_uring_exit(!ret, ret);
> +
>  	if (creds)
>  		revert_creds(creds);
>  
> @@ -6827,6 +6834,8 @@ static int io_sq_thread(void *data)
>  		set_cpus_allowed_ptr(current, cpu_online_mask);
>  	current->flags |= PF_NO_SETAFFINITY;
>  
> +	audit_alloc_kernel(current);
> +
>  	mutex_lock(&sqd->lock);
>  	/* a user may had exited before the thread started */
>  	io_run_task_work_head(&sqd->park_task_work);
> @@ -6916,6 +6925,8 @@ static int io_sq_thread(void *data)
>  	io_run_task_work_head(&sqd->park_task_work);
>  	mutex_unlock(&sqd->lock);
>  
> +	audit_free(current);
> +
>  	complete(&sqd->exited);
>  	do_exit(0);
>  }
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 82b7c1116a85..6a0c013bc7de 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -286,7 +286,10 @@ static inline int audit_signal_info(int sig, struct task_struct *t)
>  /* These are defined in auditsc.c */
>  				/* Public API */
>  extern int  audit_alloc(struct task_struct *task);
> +extern int  audit_alloc_kernel(struct task_struct *task);
>  extern void __audit_free(struct task_struct *task);
> +extern void __audit_uring_entry(u8 op);
> +extern void __audit_uring_exit(int success, long code);
>  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
>  				  unsigned long a2, unsigned long a3);
>  extern void __audit_syscall_exit(int ret_success, long ret_value);
> @@ -323,6 +326,16 @@ static inline void audit_free(struct task_struct *task)
>  	if (unlikely(task->audit_context))
>  		__audit_free(task);
>  }
> +static inline void audit_uring_entry(u8 op)
> +{
> +	if (unlikely(audit_context()))
> +		__audit_uring_entry(op);
> +}
> +static inline void audit_uring_exit(int success, long code)
> +{
> +	if (unlikely(audit_context()))
> +		__audit_uring_exit(success, code);
> +}
>  static inline void audit_syscall_entry(int major, unsigned long a0,
>  				       unsigned long a1, unsigned long a2,
>  				       unsigned long a3)
> @@ -554,6 +567,10 @@ static inline int audit_alloc(struct task_struct *task)
>  {
>  	return 0;
>  }
> +static inline int audit_alloc_kernel(struct task_struct *task)
> +{
> +	return 0;
> +}
>  static inline void audit_free(struct task_struct *task)
>  { }
>  static inline void audit_syscall_entry(int major, unsigned long a0,
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index cd2d8279a5e4..b26e0c435e8b 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -118,6 +118,7 @@
>  #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
>  #define AUDIT_BPF		1334	/* BPF subsystem */
>  #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
> +#define AUDIT_URINGOP		1336	/* io_uring operation */
>  
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> diff --git a/kernel/audit.h b/kernel/audit.h
> index fba180de5912..50de827497ca 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -100,10 +100,12 @@ struct audit_context {
>  	enum {
>  		AUDIT_CTX_UNUSED,	/* audit_context is currently unused */
>  		AUDIT_CTX_SYSCALL,	/* in use by syscall */
> +		AUDIT_CTX_URING,	/* in use by io_uring */
>  	} context;
>  	enum audit_state    state, current_state;
>  	unsigned int	    serial;     /* serial number for record */
>  	int		    major;      /* syscall number */
> +	int		    uring_op;   /* uring operation */
>  	struct timespec64   ctime;      /* time of syscall entry */
>  	unsigned long	    argv[4];    /* syscall arguments */
>  	long		    return_code;/* syscall return code */
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index cc89e9f9a753..729849d41631 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -953,6 +953,7 @@ static void audit_reset_context(struct audit_context *ctx)
>  	ctx->current_state = ctx->state;
>  	ctx->serial = 0;
>  	ctx->major = 0;
> +	ctx->uring_op = 0;
>  	ctx->ctime = (struct timespec64){ .tv_sec = 0, .tv_nsec = 0 };
>  	memset(ctx->argv, 0, sizeof(ctx->argv));
>  	ctx->return_code = 0;
> @@ -1038,6 +1039,31 @@ int audit_alloc(struct task_struct *tsk)
>  	return 0;
>  }
>  
> +/**
> + * audit_alloc_kernel - allocate an audit_context for a kernel task
> + * @tsk: the kernel task
> + *
> + * Similar to the audit_alloc() function, but intended for kernel private
> + * threads.  Returns zero on success, negative values on failure.
> + */
> +int audit_alloc_kernel(struct task_struct *tsk)
> +{
> +	/*
> +	 * At the moment we are just going to call into audit_alloc() to
> +	 * simplify the code, but there two things to keep in mind with this
> +	 * approach:
> +	 *
> +	 * 1. Filtering internal kernel tasks is a bit laughable in almost all
> +	 * cases, but there is at least one case where there is a benefit:
> +	 * the '-a task,never' case allows the admin to effectively disable
> +	 * task auditing at runtime.
> +	 *
> +	 * 2. The {set,clear}_task_syscall_work() ops likely have zero effect
> +	 * on these internal kernel tasks, but they probably don't hurt either.
> +	 */
> +	return audit_alloc(tsk);
> +}
> +
>  static inline void audit_free_context(struct audit_context *context)
>  {
>  	/* resetting is extra work, but it is likely just noise */
> @@ -1536,6 +1562,52 @@ static void audit_log_proctitle(void)
>  	audit_log_end(ab);
>  }
>  
> +/**
> + * audit_log_uring - generate a AUDIT_URINGOP record
> + * @ctx: the audit context
> + */
> +static void audit_log_uring(struct audit_context *ctx)
> +{
> +	struct audit_buffer *ab;
> +	const struct cred *cred;
> +
> +	/*
> +	 * TODO: What do we log here?  I'm tossing in a few things to start the
> +	 *       conversation, but additional thought needs to go into this.
> +	 */
> +
> +	ab = audit_log_start(ctx, GFP_KERNEL, AUDIT_URINGOP);
> +	if (!ab)
> +		return;
> +	cred = current_cred();

This may need to be req->work.creds.  I haven't been following if the
io_uring thread inherited the user task's creds (and below, comm and
exe).

> +	audit_log_format(ab, "uring_op=%d", ctx->uring_op);

arch is stored below in __audit_uring_entry() and never used in the
AUDIT_CTX_URING case.  That assignment can either be dropped or printed
before uring_op similar to the SYSCALL record.  There aren't really any
arg[0-3] to print.

io_uring_register and io_uring_setup() args are better covered by other
records.  io_uring_enter() has 6 args and the last two aren't covered by
SYSCALL anyways.

> +	if (ctx->return_valid != AUDITSC_INVALID)
> +		audit_log_format(ab, " success=%s exit=%ld",
> +				 (ctx->return_valid == AUDITSC_SUCCESS ?
> +				  "yes" : "no"),
> +				 ctx->return_code);
> +	audit_log_format(ab,
> +			 " items=%d"
> +			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
> +			 " euid=%u suid=%u fsuid=%u"
> +			 " egid=%u sgid=%u fsgid=%u",
> +			 ctx->name_count,
> +			 task_ppid_nr(current),
> +			 task_tgid_nr(current),
> +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			 from_kuid(&init_user_ns, cred->uid),
> +			 from_kgid(&init_user_ns, cred->gid),
> +			 from_kuid(&init_user_ns, cred->euid),
> +			 from_kuid(&init_user_ns, cred->suid),
> +			 from_kuid(&init_user_ns, cred->fsuid),
> +			 from_kgid(&init_user_ns, cred->egid),
> +			 from_kgid(&init_user_ns, cred->sgid),
> +			 from_kgid(&init_user_ns, cred->fsgid));

The audit session ID is still important, relevant and qualifies auid.
In keeping with the SYSCALL record format, I think we want to keep
ses=audit_get_sessionid(current) in here.

I'm pretty sure we also want to keep comm= and exe= too, but may have to
reach into req->task to get it.  There are two values for comm possible,
one from the original task and second "iou-sqp-<pid>" set at the top of
io_sq_thread().

I'm reluctant to leave them out now and then have to re-add them in yet
another field order later.

> +	audit_log_task_context(ab);
> +	audit_log_key(ab, ctx->filterkey);
> +	audit_log_end(ab);
> +}
> +
>  static void audit_log_exit(void)
>  {
>  	int i, call_panic = 0;
> @@ -1571,6 +1643,9 @@ static void audit_log_exit(void)
>  		audit_log_key(ab, context->filterkey);
>  		audit_log_end(ab);
>  		break;
> +	case AUDIT_CTX_URING:
> +		audit_log_uring(context);
> +		break;
>  	default:
>  		BUG();
>  		break;
> @@ -1740,6 +1815,104 @@ static void audit_return_fixup(struct audit_context *ctx,
>  	ctx->return_valid = (success ? AUDITSC_SUCCESS : AUDITSC_FAILURE);
>  }
>  
> +/**
> + * __audit_uring_entry - prepare the kernel task's audit context for io_uring
> + * @op: the io_uring opcode
> + *
> + * This is similar to audit_syscall_entry() but is intended for use by io_uring
> + * operations.
> + */
> +void __audit_uring_entry(u8 op)
> +{
> +	struct audit_context *ctx = audit_context();
> +
> +	if (!audit_enabled || !ctx || ctx->state == AUDIT_DISABLED)
> +		return;
> +
> +	/*
> +	 * NOTE: It's possible that we can be called from the process' context
> +	 *       before it returns to userspace, and before audit_syscall_exit()
> +	 *       is called.  In this case there is not much to do, just record
> +	 *       the io_uring details and return.
> +	 */
> +	ctx->uring_op = op;
> +	if (ctx->context == AUDIT_CTX_SYSCALL)
> +		return;
> +
> +	ctx->dummy = !audit_n_rules;
> +	if (!ctx->dummy && ctx->state == AUDIT_BUILD_CONTEXT)
> +		ctx->prio = 0;
> +
> +	ctx->arch = syscall_get_arch(current);
> +	ctx->context = AUDIT_CTX_URING;
> +	ctx->current_state = ctx->state;
> +	ktime_get_coarse_real_ts64(&ctx->ctime);
> +}
> +
> +/**
> + * __audit_uring_exit - wrap up the kernel task's audit context after io_uring
> + * @success: true/false value to indicate if the operation succeeded or not
> + * @code: operation return code
> + *
> + * This is similar to audit_syscall_exit() but is intended for use by io_uring
> + * operations.
> + */
> +void __audit_uring_exit(int success, long code)
> +{
> +	struct audit_context *ctx = audit_context();
> +
> +	/*
> +	 * TODO: At some point we will likely want to filter on io_uring ops
> +	 *       and other things similar to what we do for syscalls, but that
> +	 *       is something for another day; just record what we can here.
> +	 */
> +
> +	if (!ctx || ctx->dummy)
> +		goto out;
> +	if (ctx->context == AUDIT_CTX_SYSCALL) {
> +		/*
> +		 * NOTE: See the note in __audit_uring_entry() about the case
> +		 *       where we may be called from process context before we
> +		 *       return to userspace via audit_syscall_exit().  In this
> +		 *       case we simply emit a URINGOP record and bail, the
> +		 *       normal syscall exit handling will take care of
> +		 *       everything else.
> +		 *       It is also worth mentioning that when we are called,
> +		 *       the current process creds may differ from the creds
> +		 *       used during the normal syscall processing; keep that
> +		 *       in mind if/when we move the record generation code.
> +		 */
> +
> +		/*
> +		 * We need to filter on the syscall info here to decide if we
> +		 * should emit a URINGOP record.  I know it seems odd but this
> +		 * solves the problem where users have a filter to block *all*
> +		 * syscall records in the "exit" filter; we want to preserve
> +		 * the behavior here.
> +		 */
> +		audit_filter_syscall(current, ctx);
> +		audit_filter_inodes(current, ctx);
> +		if (ctx->current_state != AUDIT_RECORD_CONTEXT)
> +			return;
> +
> +		audit_log_uring(ctx);
> +		return;
> +	}
> +
> +	/* this may generate CONFIG_CHANGE records */
> +	if (!list_empty(&ctx->killed_trees))
> +		audit_kill_trees(ctx);
> +
> +	audit_filter_inodes(current, ctx);
> +	if (ctx->current_state != AUDIT_RECORD_CONTEXT)
> +		goto out;
> +	audit_return_fixup(ctx, success, code);
> +	audit_log_exit();
> +
> +out:
> +	audit_reset_context(ctx);
> +}
> +
>  /**
>   * __audit_syscall_entry - fill in an audit record at syscall entry
>   * @major: major syscall type (function)
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://listman.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

