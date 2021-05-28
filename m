Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D29E3948B6
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 00:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhE1Whi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 May 2021 18:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhE1Whh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 May 2021 18:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622241361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RQJiDb6dEuwnNrjNyHzwbPkW/1I2xnqQUfXBqk8aXtI=;
        b=SJPVIjubWExuHH7SWp1oBHKapGbDbGHi4z6ALswvsOKJgG2Nt8bW77vn3bKSmHW880+IY2
        QruCwrOsAw2WvhTy9i67wIXnTvj4LLzFQ0MeHAc5pcSPfLs7NPIi7Hp7V5C0ktzPmVZq4+
        gKOPoRNEWBFgTGPbAQ4y1Yk1N4pawoQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-pNkq_L8KOi6TwEy5pAo6Fw-1; Fri, 28 May 2021 18:35:57 -0400
X-MC-Unique: pNkq_L8KOi6TwEy5pAo6Fw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 363F6801AF2;
        Fri, 28 May 2021 22:35:56 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 587EE614ED;
        Fri, 28 May 2021 22:35:47 +0000 (UTC)
Date:   Fri, 28 May 2021 18:35:44 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/9] audit: add filtering for io_uring records
Message-ID: <20210528223544.GL447005@madcap2.tricolour.ca>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163380685.8379.17381053199011043757.stgit@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162163380685.8379.17381053199011043757.stgit@sifl>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-21 17:50, Paul Moore wrote:
> WARNING - This is a work in progress and should not be merged
> anywhere important.  It is almost surely not complete, and while it
> probably compiles it likely hasn't been booted and will do terrible
> things.  You have been warned.
> 
> This patch adds basic audit io_uring filtering, using as much of the
> existing audit filtering infrastructure as possible.  In order to do
> this we reuse the audit filter rule's syscall mask for the io_uring
> operation and we create a new filter for io_uring operations as
> AUDIT_FILTER_URING_EXIT/audit_filter_list[7].
> 
> <TODO - provide some additional guidance for the userspace tools>
> 
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  include/uapi/linux/audit.h |    3 +-
>  kernel/auditfilter.c       |    4 ++-
>  kernel/auditsc.c           |   65 ++++++++++++++++++++++++++++++++++----------
>  3 files changed, 55 insertions(+), 17 deletions(-)
> 
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index b26e0c435e8b..621eb3c1076e 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -167,8 +167,9 @@
>  #define AUDIT_FILTER_EXCLUDE	0x05	/* Apply rule before record creation */
>  #define AUDIT_FILTER_TYPE	AUDIT_FILTER_EXCLUDE /* obsolete misleading naming */
>  #define AUDIT_FILTER_FS		0x06	/* Apply rule at __audit_inode_child */
> +#define AUDIT_FILTER_URING_EXIT	0x07	/* Apply rule at io_uring op exit */
>  
> -#define AUDIT_NR_FILTERS	7
> +#define AUDIT_NR_FILTERS	8
>  
>  #define AUDIT_FILTER_PREPEND	0x10	/* Prepend to front of list */
>  
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index db2c6b59dfc3..c21119c00504 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -44,7 +44,8 @@ struct list_head audit_filter_list[AUDIT_NR_FILTERS] = {
>  	LIST_HEAD_INIT(audit_filter_list[4]),
>  	LIST_HEAD_INIT(audit_filter_list[5]),
>  	LIST_HEAD_INIT(audit_filter_list[6]),
> -#if AUDIT_NR_FILTERS != 7
> +	LIST_HEAD_INIT(audit_filter_list[7]),
> +#if AUDIT_NR_FILTERS != 8
>  #error Fix audit_filter_list initialiser
>  #endif
>  };
> @@ -56,6 +57,7 @@ static struct list_head audit_rules_list[AUDIT_NR_FILTERS] = {
>  	LIST_HEAD_INIT(audit_rules_list[4]),
>  	LIST_HEAD_INIT(audit_rules_list[5]),
>  	LIST_HEAD_INIT(audit_rules_list[6]),
> +	LIST_HEAD_INIT(audit_rules_list[7]),
>  };
>  
>  DEFINE_MUTEX(audit_filter_mutex);
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index d8aa2c690bf9..4f6ab34020fb 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -799,6 +799,35 @@ static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
>  	return rule->mask[word] & bit;
>  }
>  
> +/**
> + * audit_filter_uring - apply filters to an io_uring operation
> + * @tsk: associated task
> + * @ctx: audit context
> + */
> +static void audit_filter_uring(struct task_struct *tsk,
> +			       struct audit_context *ctx)
> +{
> +	struct audit_entry *e;
> +	enum audit_state state;
> +
> +	if (auditd_test_task(tsk))
> +		return;

Is this necessary?  auditd and auditctl don't (intentionally) use any
io_uring functionality.  Is it possible it might inadvertantly use some
by virtue of libc or other library calls now or in the future?

> +	rcu_read_lock();
> +	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_URING_EXIT],
> +				list) {
> +		if (audit_in_mask(&e->rule, ctx->uring_op) &&

While this seems like the most obvious approach given the parallels
between syscalls and io_uring operations, as coded here it won't work
due to the different mappings of syscall numbers and io_uring
operations unless we re-use the auditctl -S field with raw io_uring
operation numbers in the place of syscall numbers.  This should have
been obvious to me when I first looked at this patch.  It became obvious
when I started looking at the userspace auditctl.c.

The easy first step would be to use something like this:
	auditctl -a uring,always -S 18,28 -F key=uring_open
to monitor file open commands only.  The same is not yet possible for
the perm field, but there are so few io_uring ops at this point compared
with syscalls that it might be manageable.  The arch is irrelevant since
io_uring operation numbers are identical across all hardware as far as I
can tell.  Most of the rest of the fields should make sense if they do
for a syscall rule.  Here's a sample of userspace code to support this
patch:
	https://github.com/rgbriggs/audit-userspace/commit/a77baa1651b7ad841a220eb962d4cc92bc07dc96
	https://github.com/linux-audit/audit-userspace/compare/master...rgbriggs:ghau-iouring-filtering.v1.0


If we abuse the syscall infrastructure at first, we'd need a transition
plan to coordinate user and kernel switchover to seperate mechanisms for
the two to work together if the need should arise to have both syscall
and uring filters in the same rule.


I'm still exploring ideas on the best place to put this translation
table, in userspace libaudit, kaudit, io_op_defs[],
include/uapi/linux/io_uring.h, ...

For speed, the best would be in userspace libaudit, but that will be the
least obvious place for any io_uring developer to look when making any
updates to the list of io_uring operations and will most likely result
in additions escaping security logging.

Next best for speed would be in kaudit when instantiating rules, to
translate the syscall numbers to operation numbers and store them
natively in a different mask (audit_in_mask).  This also runs the risk
of additions escaping security logging.

After that, they could reuse the existing audit syscall filter
infrastructure and mask and translate on the fly from the specific op in
use to its equivalent syscall number when checking the existing filter.
This is the least disruptive to the audit code and the most likely to be
updated when new io_uring operations are added, but will incur an extra
step to translate the io_uring operation number to a syscall number in
the hot path.

Given that multiple aspects of security appear to have been a complete
afterthought to this feature, necessitating it to be bolted on after the
fact, it appears that the last option might be the most attractive to
the security folks, making this as easy as possible for fs folks to
update the audit code would be necessary to maintain security.


If there isn't a direct mapping between io_uring operations and
syscalls (the reverse isn't needed), then we'll need to duplicate the
mechanism throughout the stack starting in userspace auditctl and
libaudit.  Currently the bitmap for syscalls is 2k.  The current
io_uring op list appears to be 37.


It might be wise to deliberately not support auditctl "-w" (and the
exported audit_add_watch() function) since that is currently hardcoded
to the AUDIT_FILTER_EXIT list and is the old watch form [replaced by
audit_rule_fieldpair_data()] anyways that is more likely to be
deprecated.  It also appears to make sense not to support autrace (at
least initially).


Does any of this roughly make sense?


> +		    audit_filter_rules(tsk, &e->rule, ctx, NULL, &state,
> +				       false)) {
> +			rcu_read_unlock();
> +			ctx->current_state = state;
> +			return;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return;
> +}
> +
>  /* At syscall exit time, this filter is called if the audit_state is
>   * not low enough that auditing cannot take place, but is also not
>   * high enough that we already know we have to write an audit record
> @@ -1754,7 +1783,7 @@ static void audit_log_exit(void)
>   * __audit_free - free a per-task audit context
>   * @tsk: task whose audit context block to free
>   *
> - * Called from copy_process and do_exit
> + * Called from copy_process, do_exit, and the io_uring code
>   */
>  void __audit_free(struct task_struct *tsk)
>  {
> @@ -1772,15 +1801,21 @@ void __audit_free(struct task_struct *tsk)
>  	 * random task_struct that doesn't doesn't have any meaningful data we
>  	 * need to log via audit_log_exit().
>  	 */
> -	if (tsk == current && !context->dummy &&
> -	    context->context == AUDIT_CTX_SYSCALL) {
> +	if (tsk == current && !context->dummy) {
>  		context->return_valid = AUDITSC_INVALID;
>  		context->return_code = 0;
> -
> -		audit_filter_syscall(tsk, context);
> -		audit_filter_inodes(tsk, context);
> -		if (context->current_state == AUDIT_RECORD_CONTEXT)
> -			audit_log_exit();
> +		if (context->context == AUDIT_CTX_SYSCALL) {
> +			audit_filter_syscall(tsk, context);
> +			audit_filter_inodes(tsk, context);
> +			if (context->current_state == AUDIT_RECORD_CONTEXT)
> +				audit_log_exit();
> +		} else if (context->context == AUDIT_CTX_URING) {
> +			/* TODO: verify this case is real and valid */
> +			audit_filter_uring(tsk, context);
> +			audit_filter_inodes(tsk, context);
> +			if (context->current_state == AUDIT_RECORD_CONTEXT)
> +				audit_log_uring(context);
> +		}
>  	}
>  
>  	audit_set_context(tsk, NULL);
> @@ -1861,12 +1896,6 @@ void __audit_uring_exit(int success, long code)
>  {
>  	struct audit_context *ctx = audit_context();
>  
> -	/*
> -	 * TODO: At some point we will likely want to filter on io_uring ops
> -	 *       and other things similar to what we do for syscalls, but that
> -	 *       is something for another day; just record what we can here.
> -	 */
> -
>  	if (!ctx || ctx->dummy)
>  		goto out;
>  	if (ctx->context == AUDIT_CTX_SYSCALL) {
> @@ -1891,6 +1920,8 @@ void __audit_uring_exit(int success, long code)
>  		 * the behavior here.
>  		 */
>  		audit_filter_syscall(current, ctx);
> +		if (ctx->current_state != AUDIT_RECORD_CONTEXT)
> +			audit_filter_uring(current, ctx);
>  		audit_filter_inodes(current, ctx);
>  		if (ctx->current_state != AUDIT_RECORD_CONTEXT)
>  			return;
> @@ -1899,7 +1930,9 @@ void __audit_uring_exit(int success, long code)
>  		return;
>  	}
>  #if 1
> -	/* XXX - temporary hack to force record generation */
> +	/* XXX - temporary hack to force record generation, we are leaving this
> +	 *       enabled, but if you want to actually test the filtering you
> +	 *       need to disable this #if/#endif block */
>  	ctx->current_state = AUDIT_RECORD_CONTEXT;
>  #endif
>  
> @@ -1907,6 +1940,8 @@ void __audit_uring_exit(int success, long code)
>  	if (!list_empty(&ctx->killed_trees))
>  		audit_kill_trees(ctx);
>  
> +	/* run through both filters to ensure we set the filterkey properly */
> +	audit_filter_uring(current, ctx);
>  	audit_filter_inodes(current, ctx);
>  	if (ctx->current_state != AUDIT_RECORD_CONTEXT)
>  		goto out;
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

