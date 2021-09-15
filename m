Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED41C40CF04
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 23:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhIOVuA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 17:50:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232542AbhIOVt5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 17:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631742518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4JQbxGAJkeSEPdQ0jyX0sTG6pB3VM96R1fLSbgXGIXg=;
        b=RGWeILj/9AzfSr3lyOfw2XJHpn5wqgUYlvL7M4zAuJseIpMG7bh9gVjU9rWKrx7Zni+/Sm
        QIFYrdZKXCgnJmmEFvFmeJivEKFdS0WRjH6k8PxsB8D2PdRhn2jB9UdQaWE5nkywAG2PVb
        3WiuhXi3hMObEc9W/4KRk/2qjg6Kpn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-3U94tmNfNP2ezU7a4PMyWA-1; Wed, 15 Sep 2021 17:48:35 -0400
X-MC-Unique: 3U94tmNfNP2ezU7a4PMyWA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 858451006AA1;
        Wed, 15 Sep 2021 21:48:33 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85A481B46B;
        Wed, 15 Sep 2021 21:48:23 +0000 (UTC)
Date:   Wed, 15 Sep 2021 17:48:20 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v4 3/8] audit: add filtering for io_uring records
Message-ID: <20210915214820.GO490529@madcap2.tricolour.ca>
References: <163172413301.88001.16054830862146685573.stgit@olly>
 <163172457764.88001.5016839648172573823.stgit@olly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163172457764.88001.5016839648172573823.stgit@olly>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-09-15 12:49, Paul Moore wrote:
> This patch adds basic audit io_uring filtering, using as much of the
> existing audit filtering infrastructure as possible.  In order to do
> this we reuse the audit filter rule's syscall mask for the io_uring
> operation and we create a new filter for io_uring operations as
> AUDIT_FILTER_URING_EXIT/audit_filter_list[7].
> 
> Thanks to Richard Guy Briggs for his review, feedback, and work on
> the corresponding audit userspace changes.
> 
> Signed-off-by: Paul Moore <paul@paul-moore.com>

Looks good.

Acked-by: Richard Guy Briggs <rgb@redhat.com>

> ---
> v4:
> - no change
> v3:
> - removed work-in-progress warning from the description
> v2:
> - incorporate feedback from Richard
> v1:
> - initial draft
> ---
>  include/uapi/linux/audit.h |    3 +-
>  kernel/audit_tree.c        |    3 +-
>  kernel/audit_watch.c       |    3 +-
>  kernel/auditfilter.c       |   15 +++++++++--
>  kernel/auditsc.c           |   61 ++++++++++++++++++++++++++++++++++----------
>  5 files changed, 65 insertions(+), 20 deletions(-)
> 
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index a1997697c8b1..ecf1edd2affa 100644
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
> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 2cd7b5694422..338c53a961c5 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -726,7 +726,8 @@ int audit_make_tree(struct audit_krule *rule, char *pathname, u32 op)
>  {
>  
>  	if (pathname[0] != '/' ||
> -	    rule->listnr != AUDIT_FILTER_EXIT ||
> +	    (rule->listnr != AUDIT_FILTER_EXIT &&
> +	     rule->listnr != AUDIT_FILTER_URING_EXIT) ||
>  	    op != Audit_equal ||
>  	    rule->inode_f || rule->watch || rule->tree)
>  		return -EINVAL;
> diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
> index 2acf7ca49154..698b62b4a2ec 100644
> --- a/kernel/audit_watch.c
> +++ b/kernel/audit_watch.c
> @@ -183,7 +183,8 @@ int audit_to_watch(struct audit_krule *krule, char *path, int len, u32 op)
>  		return -EOPNOTSUPP;
>  
>  	if (path[0] != '/' || path[len-1] == '/' ||
> -	    krule->listnr != AUDIT_FILTER_EXIT ||
> +	    (krule->listnr != AUDIT_FILTER_EXIT &&
> +	     krule->listnr != AUDIT_FILTER_URING_EXIT) ||
>  	    op != Audit_equal ||
>  	    krule->inode_f || krule->watch || krule->tree)
>  		return -EINVAL;
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index db2c6b59dfc3..d75acb014ccd 100644
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
> @@ -151,7 +153,8 @@ char *audit_unpack_string(void **bufp, size_t *remain, size_t len)
>  static inline int audit_to_inode(struct audit_krule *krule,
>  				 struct audit_field *f)
>  {
> -	if (krule->listnr != AUDIT_FILTER_EXIT ||
> +	if ((krule->listnr != AUDIT_FILTER_EXIT &&
> +	     krule->listnr != AUDIT_FILTER_URING_EXIT) ||
>  	    krule->inode_f || krule->watch || krule->tree ||
>  	    (f->op != Audit_equal && f->op != Audit_not_equal))
>  		return -EINVAL;
> @@ -248,6 +251,7 @@ static inline struct audit_entry *audit_to_entry_common(struct audit_rule_data *
>  		pr_err("AUDIT_FILTER_ENTRY is deprecated\n");
>  		goto exit_err;
>  	case AUDIT_FILTER_EXIT:
> +	case AUDIT_FILTER_URING_EXIT:
>  	case AUDIT_FILTER_TASK:
>  #endif
>  	case AUDIT_FILTER_USER:
> @@ -332,6 +336,10 @@ static int audit_field_valid(struct audit_entry *entry, struct audit_field *f)
>  		if (entry->rule.listnr != AUDIT_FILTER_FS)
>  			return -EINVAL;
>  		break;
> +	case AUDIT_PERM:
> +		if (entry->rule.listnr == AUDIT_FILTER_URING_EXIT)
> +			return -EINVAL;
> +		break;
>  	}
>  
>  	switch (entry->rule.listnr) {
> @@ -980,7 +988,8 @@ static inline int audit_add_rule(struct audit_entry *entry)
>  	}
>  
>  	entry->rule.prio = ~0ULL;
> -	if (entry->rule.listnr == AUDIT_FILTER_EXIT) {
> +	if (entry->rule.listnr == AUDIT_FILTER_EXIT ||
> +	    entry->rule.listnr == AUDIT_FILTER_URING_EXIT) {
>  		if (entry->rule.flags & AUDIT_FILTER_PREPEND)
>  			entry->rule.prio = ++prio_high;
>  		else
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 6dda448fb826..7c66a9fea5e6 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -805,6 +805,35 @@ static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
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
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_URING_EXIT],
> +				list) {
> +		if (audit_in_mask(&e->rule, ctx->uring_op) &&
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
> @@ -1757,7 +1786,7 @@ static void audit_log_exit(void)
>   * __audit_free - free a per-task audit context
>   * @tsk: task whose audit context block to free
>   *
> - * Called from copy_process and do_exit
> + * Called from copy_process, do_exit, and the io_uring code
>   */
>  void __audit_free(struct task_struct *tsk)
>  {
> @@ -1775,15 +1804,21 @@ void __audit_free(struct task_struct *tsk)
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
> -		if (context->current_state == AUDIT_STATE_RECORD)
> -			audit_log_exit();
> +		if (context->context == AUDIT_CTX_SYSCALL) {
> +			audit_filter_syscall(tsk, context);
> +			audit_filter_inodes(tsk, context);
> +			if (context->current_state == AUDIT_STATE_RECORD)
> +				audit_log_exit();
> +		} else if (context->context == AUDIT_CTX_URING) {
> +			/* TODO: verify this case is real and valid */
> +			audit_filter_uring(tsk, context);
> +			audit_filter_inodes(tsk, context);
> +			if (context->current_state == AUDIT_STATE_RECORD)
> +				audit_log_uring(context);
> +		}
>  	}
>  
>  	audit_set_context(tsk, NULL);
> @@ -1867,12 +1902,6 @@ void __audit_uring_exit(int success, long code)
>  {
>  	struct audit_context *ctx = audit_context();
>  
> -	/*
> -	 * TODO: At some point we will likely want to filter on io_uring ops
> -	 *       and other things similar to what we do for syscalls, but that
> -	 *       is something for another day; just record what we can here.
> -	 */
> -
>  	if (ctx->context == AUDIT_CTX_SYSCALL) {
>  		/*
>  		 * NOTE: See the note in __audit_uring_entry() about the case
> @@ -1895,6 +1924,8 @@ void __audit_uring_exit(int success, long code)
>  		 * the behavior here.
>  		 */
>  		audit_filter_syscall(current, ctx);
> +		if (ctx->current_state != AUDIT_STATE_RECORD)
> +			audit_filter_uring(current, ctx);
>  		audit_filter_inodes(current, ctx);
>  		if (ctx->current_state != AUDIT_STATE_RECORD)
>  			return;
> @@ -1907,6 +1938,8 @@ void __audit_uring_exit(int success, long code)
>  	if (!list_empty(&ctx->killed_trees))
>  		audit_kill_trees(ctx);
>  
> +	/* run through both filters to ensure we set the filterkey properly */
> +	audit_filter_uring(current, ctx);
>  	audit_filter_inodes(current, ctx);
>  	if (ctx->current_state != AUDIT_STATE_RECORD)
>  		goto out;
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

