Return-Path: <io-uring+bounces-11601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD5DD15F14
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 01:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D883B3018F44
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 00:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE2113AD05;
	Tue, 13 Jan 2026 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v0GF7cyn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k4RqpLzU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v0GF7cyn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k4RqpLzU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC39C4315A
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 00:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263026; cv=none; b=PFmXpKKs6T+fBnuTNLJ/mY/gV9Pu47FRrD1sQHmA7rHuWCVsYnf3EZZLX987E1mavXwcRAgCrlKpPT/xheX6VRjVJgrPFw5ebWO5KbdhKKtD6LtUHVWEu+VWULiCl277RsgKGsG5VJ1j0OO/r0F3Z1EGgaG3QEANkeIqob2Q0gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263026; c=relaxed/simple;
	bh=F58DGnPahcrVjqz6xzE8g3b5qSJxzlT2GWL5JWZnsCQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HXA2AHmUp5hCNo8aOn32Bt7vuTSZUeY+2qDdF9s8TsGd7fgcUGh0MJjOFvqTF+DhPLCAbk2y/yKyV9EDYfsV7t5FJ/DkI8M4FaaOveQIIhZaZahl/qLFxEC5m2IXmVFBUO4ospiVQiv4ggHz/nTn4pV+D7v6OfiUB6R8si49LrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v0GF7cyn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k4RqpLzU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v0GF7cyn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k4RqpLzU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 157A75BCC1;
	Tue, 13 Jan 2026 00:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768263017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zsZoY0k6PKWboWxmr9Qp2oXe7qslGtjnhX/op7/DOA=;
	b=v0GF7cynYmEcQ4TCG6Lpi9nZFSuawOh2oromDeFmDlNt2Y2fUUJ5zp0gT6KUn6FkKw5EoX
	mTRwyOHwnWOhrDDyQZi24HccZHMPoNu++rQx6kH2YNINLaBZvuMoFA68zhlRh+Ibu6V38j
	y+7HSZPQcq3jXXlftojycju9qyjlX00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768263017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zsZoY0k6PKWboWxmr9Qp2oXe7qslGtjnhX/op7/DOA=;
	b=k4RqpLzUeOOEr/3r/u/8DzcvosgWz1s4XWMDmWrWJMel5A1h1uTtGDOaU+aJQNrIyeOCUg
	oA10UuHndBFGnhAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768263017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zsZoY0k6PKWboWxmr9Qp2oXe7qslGtjnhX/op7/DOA=;
	b=v0GF7cynYmEcQ4TCG6Lpi9nZFSuawOh2oromDeFmDlNt2Y2fUUJ5zp0gT6KUn6FkKw5EoX
	mTRwyOHwnWOhrDDyQZi24HccZHMPoNu++rQx6kH2YNINLaBZvuMoFA68zhlRh+Ibu6V38j
	y+7HSZPQcq3jXXlftojycju9qyjlX00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768263017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zsZoY0k6PKWboWxmr9Qp2oXe7qslGtjnhX/op7/DOA=;
	b=k4RqpLzUeOOEr/3r/u/8DzcvosgWz1s4XWMDmWrWJMel5A1h1uTtGDOaU+aJQNrIyeOCUg
	oA10UuHndBFGnhAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CCA003EA63;
	Tue, 13 Jan 2026 00:10:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ArgfK2iNZWn4FAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 13 Jan 2026 00:10:16 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] io_uring/register: allow original task restrictions
 owner to unregister
In-Reply-To: <20260109185155.88150-4-axboe@kernel.dk> (Jens Axboe's message of
	"Fri, 9 Jan 2026 11:48:27 -0700")
Organization: SUSE
References: <20260109185155.88150-1-axboe@kernel.dk>
	<20260109185155.88150-4-axboe@kernel.dk>
Date: Mon, 12 Jan 2026 19:10:15 -0500
Message-ID: <877btm4bko.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

--=-=-=
Content-Type: text/plain

Jens Axboe <axboe@kernel.dk> writes:

> Currently any attempt to register a set of task restrictions if an
> existing set exists will fail with -EPERM. But it is feasible to let the
> original creator/owner performance this operation. Either to remove
> restrictions entirely, or to replace them with a new set.
>
> If an existing set exists and NULL is passed for the new set, the
> current set is unregistered. If an existing set exists and a new set is
> supplied, the old set is dropped and replaced with the new one.

Feature-wise, I think this covers what I mentioned in the previous
iteration.  Even though this is an RFC, I think I found two bugs that
allow the child to escape the restrictions:

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  1 +
>  io_uring/register.c            | 45 ++++++++++++++++++++++++++++------
>  2 files changed, 38 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 196f41ec6d60..1ff7817b3535 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -222,6 +222,7 @@ struct io_rings {
>  struct io_restriction {
>  	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
> +	pid_t pid;
>  	refcount_t refs;
>  	u8 sqe_flags_allowed;
>  	u8 sqe_flags_required;
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 552b22f6b2dc..c8b8a9edbc65 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -189,12 +189,19 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
>  {
>  	struct io_uring_task_restriction __user *ures = arg;
>  	struct io_uring_task_restriction tres;
> -	struct io_restriction *res;
> +	struct io_restriction *old_res, *res;
>  	int ret;
>  
>  	if (nr_args != 1)
>  		return -EINVAL;
>  
> +	res = current->io_uring_restrict;
> +	if (!ures) {
> +		if (!res)
> +			return -EFAULT;
> +		goto drop_set;
> +	}
> +
>  	if (copy_from_user(&tres, arg, sizeof(tres)))
>  		return -EFAULT;
>  
> @@ -207,13 +214,27 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
>  	 * Disallow if task already has registered restrictions, and we're
>  	 * not passing in further restrictions to add to an existing set.
>  	 */
> -	if (current->io_uring_restrict &&
> -	    !(tres.flags & IORING_REG_RESTRICTIONS_MASK))
> -		return -EPERM;
> +	old_res = NULL;
> +	if (res && !(tres.flags & IORING_REG_RESTRICTIONS_MASK)) {
> +		/* Not owner, may only append further restrictions */
> +drop_set:
> +		if (res->pid != current->pid)
> +			return -EPERM;

This might be hard to exploit, but if the parent terminates, the pid can
get reused.  Then, if the child forks until it gets the same pid, it can
unregister the filter.  I suppose the fix would require holding a
reference to the task, similar to what pidfd does. but perhaps just
abandon the unregistering semantics?  I'm not sure it is that useful...

> @@ -226,14 +247,22 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
>  				    tres.flags & IORING_REG_RESTRICTIONS_MASK);
>  	if (ret) {
>  		kfree(res);
> -		return ret;
> +		goto out;
>  	}
>  	if (current->io_uring_restrict &&
>  	    refcount_dec_and_test(&current->io_uring_restrict->refs))
>  		kfree(current->io_uring_restrict);
> +	res->pid = current->pid;

res->pid must always point to the first task that added a
restriction. So:

if (!current->io_uring_restrict)
       res->pid = current->pid;

Otherwise, the child will become the owner after adding another
restriction, and can then break out with a further unregister.  Based on
your testcase, this escapes the filter:


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=poc.patch

diff --git a/test/task-restrictions.c b/test/task-restrictions.c
index 5a9170b4..4d4b457c 100644
--- a/test/task-restrictions.c
+++ b/test/task-restrictions.c
@@ -92,6 +92,12 @@ static int test_restrictions(int should_work)
 static void *thread_fn(void *unused)
 {
 	int ret;
+	struct io_uring_task_restriction  *res =
+		calloc(1, sizeof(*res) + 1 * sizeof(struct io_uring_restriction));
+	res->restrictions[1].opcode = IORING_RESTRICTION_SQE_OP;
+	res->restrictions[1].sqe_op = IORING_OP_FUTEX_WAIT;
+	res->nr_res = 1;
+	res->flags = IORING_REG_RESTRICTIONS_MASK;
 
 	ret = test_restrictions(0);
 	if (ret) {
@@ -99,6 +105,7 @@ static void *thread_fn(void *unused)
 		return (void *) (uintptr_t) ret;
 	}
 
+	ret = io_uring_register_task_restrictions(res);
 	ret = io_uring_register_task_restrictions(NULL);
 	if (!ret) {
 		fprintf(stderr, "thread restrictions unregister worked?!\n");

--=-=-=
Content-Type: text/plain


-- 
Gabriel Krisman Bertazi

--=-=-=--

