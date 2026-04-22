Return-Path: <io-uring+bounces-13128-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEHbJPo76WmgWQIAu9opvQ
	(envelope-from <io-uring+bounces-13128-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 23:22:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6AA44ADE6
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 23:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3DAD30DFFF0
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 21:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577CA370D4D;
	Wed, 22 Apr 2026 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A18F5LgI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aC4Fieuj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A18F5LgI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aC4Fieuj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BF8271471
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 21:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776892848; cv=none; b=UTmr30EjNqX31LPU4CycnIxpTC77w9GBHjjsFBaaBJNWcizYjS7iJb+L0bw4OwcFdt+g1vx3MCKenxuA5AGcXX4cLMZ4Q5ne8YrvFaWUkPQIFFK76FeO5m8PmsRZFqvPG61TRiTN0qp49D3+Yt8/bx9hLJXxay3ExHaySV7Zx+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776892848; c=relaxed/simple;
	bh=Xp+unCXJF+qg5R5kKdjuVWl4Qwgj6mFbAQZnJe93BQU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jLGthes6hyKvrvs/UND5F8c+nD7+ZCSXQAkZxBz9LHh2dPzuyDROBZJUzFWex3od7BVLO17BT1gtJ/BxRTzpUd2n5tz9s1Hzhsyooq0DFVNxdnwrq8HiRfr49cm5o/rohb1lXSDjj/bkzx2eI7hAr7u0UVHivjVPK3w2XlxyEE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A18F5LgI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aC4Fieuj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A18F5LgI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aC4Fieuj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 342426A82F;
	Wed, 22 Apr 2026 21:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776892845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZO6ZnC4bI2xQTtqyBvQ90Buju/Kx0J4Jj+4V23LnNI=;
	b=A18F5LgIc9D8wlsTVA2sbqyB7CuSr51zDS/M+c4zj9Z9fHrE8NIKN8aqkBBx2ts6Ycqge+
	YAhcUuDyw7R7VUL4NEwwVd0Tui9EDUJT6tW/z7DnHy65BLoLiQx5suvH/+phvKo7U1///P
	qys2ykaviZJvH5D0ubRBS/0m8UeFAso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776892845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZO6ZnC4bI2xQTtqyBvQ90Buju/Kx0J4Jj+4V23LnNI=;
	b=aC4FieujGugYGxSgCDyGt8h+sHTZQqmNU00jQ1VfULZS9LhbL+f1x6bvfEL738uU+RdfBa
	WmbrdCvB9N8XDbDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776892845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZO6ZnC4bI2xQTtqyBvQ90Buju/Kx0J4Jj+4V23LnNI=;
	b=A18F5LgIc9D8wlsTVA2sbqyB7CuSr51zDS/M+c4zj9Z9fHrE8NIKN8aqkBBx2ts6Ycqge+
	YAhcUuDyw7R7VUL4NEwwVd0Tui9EDUJT6tW/z7DnHy65BLoLiQx5suvH/+phvKo7U1///P
	qys2ykaviZJvH5D0ubRBS/0m8UeFAso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776892845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZO6ZnC4bI2xQTtqyBvQ90Buju/Kx0J4Jj+4V23LnNI=;
	b=aC4FieujGugYGxSgCDyGt8h+sHTZQqmNU00jQ1VfULZS9LhbL+f1x6bvfEL738uU+RdfBa
	WmbrdCvB9N8XDbDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E631D593AF;
	Wed, 22 Apr 2026 21:20:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IdetMaw76WkbdAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 22 Apr 2026 21:20:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Ali Raza <elirazamumtaz@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,  io-uring@vger.kernel.org,
  linux-kernel@vger.kernel.org,  bpf@vger.kernel.org,  Pavel Begunkov
 <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: fix missing submitter_task ownership check in
 bpf_io_reg()
In-Reply-To: <20260422-master-v1-1-e82f47558345@gmail.com> (Ali Raza's message
	of "Wed, 22 Apr 2026 20:53:05 +0500")
References: <20260422-master-v1-1-e82f47558345@gmail.com>
Date: Wed, 22 Apr 2026 17:20:39 -0400
Message-ID: <87eck6ofo8.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13128-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: DE6AA44ADE6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Ali Raza <elirazamumtaz@gmail.com> writes:

> bpf_io_reg() installs a BPF struct_ops loop_step on any io_uring ring
> the caller holds a file descriptor for.  io_uring_ctx_get_file() only
> validates that the fd resolves to an io_uring file; it does not verify
> the caller has authority over the ring's submitter_task.
>
> A parallel path in io_uring_register() already enforces this:
>
>     if (ctx->submitter_task && ctx->submitter_task != current)
>         return -EEXIST;  /* register.c:733 */

How is this a protection?  I thought ctx->submitter_task is about
IORING_SETUP_SINGLE_ISSUER. there is no permission or capability over
it against other processes.

> Without the equivalent check in bpf_io_reg(), a local user with
> CAP_PERFMON can exploit IORING_SETUP_R_DISABLED -- which defers

I'd argue this is a non-issue.  If you have CAP_PERFMON, you are able to
mess with the process in many ways beyond this.  Otherwise, how a
process would be able to get the fd in the first place?

> submitter_task assignment until IORING_REGISTER_ENABLE_RINGS -- to
> install a loop_step on a ring before a more-privileged process becomes
> its submitter_task.  The loop_step then executes in the privileged
> process's task context and can issue arbitrary io_uring operations
> (IORING_OP_WRITE, IORING_OP_READ, IORING_OP_SPLICE) against that
> process's open file table.  This provides a cross-privilege io_uring
> execution primitive that can serve as a component in a privilege
> escalation chain when combined with a vector that induces a privileged
> process to adopt an attacker-controlled ring.
>
> Affected: v7.1-rc1+ with CONFIG_IO_URING_BPF_OPS=y.
> Requires: IORING_SETUP_DEFER_TASKRUN | IORING_SETUP_SINGLE_ISSUER.
>
> Add the ownership check in io_install_bpf(), which is called under
> uring_lock, matching the locking context of the register.c check.
>
> Signed-off-by: Ali Raza <elirazamumtaz@gmail.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/bpf-ops.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
> index 937e48bef40b..cac11c929297 100644
> --- a/io_uring/bpf-ops.c
> +++ b/io_uring/bpf-ops.c
> @@ -162,6 +162,8 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
>  		return -EOPNOTSUPP;
>  	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>  		return -EOPNOTSUPP;
> +	if (ctx->submitter_task && ctx->submitter_task != current)
> +		return -EPERM;
>  
>  	if (ctx->bpf_ops)
>  		return -EBUSY;
>
> ---
> base-commit: bea8d77e45a8b77f2beca1affc9aa7ed28f39b17
> change-id: 20260422-master-d96fe0e8bb3c
>
> Best regards,
> --  
>
> Ali Raza <elirazamumtaz@gmail.com>
>

-- 
Gabriel Krisman Bertazi

