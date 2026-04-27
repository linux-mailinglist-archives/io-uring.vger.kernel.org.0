Return-Path: <io-uring+bounces-13150-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNj/CWnZ72maGwEAu9opvQ
	(envelope-from <io-uring+bounces-13150-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 23:47:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C05FF47AE05
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 23:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D6101300D367
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 21:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894213537FF;
	Mon, 27 Apr 2026 21:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xKTVgdi7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sRMrKS2y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fF1e51W+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XIrPHR2b"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA3D37F009
	for <io-uring@vger.kernel.org>; Mon, 27 Apr 2026 21:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777326437; cv=none; b=fSqw/lCRP/QYqQBTKqwI3NlB3liBPX0frTyNgKuC4r5haAL2om5EHLUVBkqRF5VTRjW/9aI15R459SXK0/tDXZSxy/RZkbwq1ASQeZ63CFuiepXgHIBzVqA/v8TfMeSf40p3Ki9pZ4vx4iJAQ+UnSQIxYXg2+XxB2Gjcrbm7xdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777326437; c=relaxed/simple;
	bh=BMi5v12Fat8Cmj7ZfbqJfTUijQJmxQ/c6FalSVHExQg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Oj8Ak056XLY3bshIP/ZhwWinWZaEittLrqt735d1+qvW6JyOKV75V9lBtWLrqWcdpPAyJjD0kmL3BO5KMTlm6MFTZ97TSm3adi8Hd4gk+ruVveha7Oq82sx+fJJ1s83SEtQFQwpaDkqGtuEod10Rqa2ftuiasmlVraUGucK+B5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xKTVgdi7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sRMrKS2y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fF1e51W+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XIrPHR2b; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1D926A826;
	Mon, 27 Apr 2026 21:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777326433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PD5CBPI36xg8XgD5In1OelpqiBEYUy2drfzjh+OvPXU=;
	b=xKTVgdi7ACrz3Kao4hwjYyqdog3bKa8XcGO31HRIy2gRSFfquqR9LOyn6LDMjyU6DOykFF
	6ej/VazHt1ihIAHo7jJlLotnYWHDAgcTXJw/VKgJXCf1sKKjvTI6QzwNTTXEwEF/JQmc97
	gRu9P1/RBHctN1ppEWTVZmjni6ZlGt8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777326433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PD5CBPI36xg8XgD5In1OelpqiBEYUy2drfzjh+OvPXU=;
	b=sRMrKS2yvC1/4QvF2T9gh8nV6/sz10ToQqCCn04rSA0byKtTSdDl6EnI/1zJ0QonT6GFWy
	a01rc5QaY5TV+wAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777326432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PD5CBPI36xg8XgD5In1OelpqiBEYUy2drfzjh+OvPXU=;
	b=fF1e51W+dWcE5Wp4W14cjSsrwwxMhgdGeJ+94bVvQdXQ7DTewmrUxBZtfR9akf1/AVZ0mG
	HeLiG+QldAhnxvSt8GNy4eYrSh3RY5OpMUeFXMmHJVZsvTgRaHVXXDEVrDCNLntaE4X50i
	dT9WExUJSuz0FIw9NS+mi2LTKtOcXvo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777326432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PD5CBPI36xg8XgD5In1OelpqiBEYUy2drfzjh+OvPXU=;
	b=XIrPHR2bdA4Dn25ztlSlCcVqCdyO+wcD4TCr99x6VPy8Js4V3p73HNKnvKI1634eVw2td9
	4vUqVlfTXLCrDHAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CE3F593B0;
	Mon, 27 Apr 2026 21:47:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oGNoCmDZ72m5RgAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 27 Apr 2026 21:47:12 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Ali Raza <elirazamumtaz@gmail.com>
Cc: io-uring@vger.kernel.org,  Jens Axboe <axboe@kernel.dk>,  Pavel Begunkov
 <asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring: add submitter_task consistency check to
 io_install_bpf()
In-Reply-To: <20260427192400.416133-1-elirazamumtaz@gmail.com> (Ali Raza's
	message of "Tue, 28 Apr 2026 00:24:00 +0500")
References: <12c2bec8-ffb9-4b01-8bea-819c6ec77c5e@gmail.com>
	<20260427192400.416133-1-elirazamumtaz@gmail.com>
Date: Mon, 27 Apr 2026 17:47:10 -0400
Message-ID: <87mryom5y9.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: C05FF47AE05
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13150-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.de:dkim]

Ali Raza <elirazamumtaz@gmail.com> writes:

> io_uring_register() already guards against a different task touching
> a SINGLE_ISSUER ring (register.c:733):
>
>     if (ctx->submitter_task && ctx->submitter_task != current)
>         return -EEXIST;
>
> bpf_io_reg() calls io_install_bpf() without an equivalent guard.  Add
> the same check for consistency.  The check is gated on
> IORING_SETUP_SINGLE_ISSUER since submitter_task is only assigned for
> that flag combination (io_uring.c:3053 and register.c:282).
>
> Note: io_install_bpf() is called directly from the BPF syscall path,
> so `current` is the task invoking BPF_LINK_CREATE.  If BPF link
> registration were ever deferred to a worker thread, this check would
> need revisiting.
>
> Signed-off-by: Ali Raza <elirazamumtaz@gmail.com>
> ---
> v2: Added IORING_SETUP_SINGLE_ISSUER gate; changed -EPERM to -EEXIST to
>     match register.c:733; removed security/exploit framing from commit
>     message; acknowledged that `current` may not be valid if BPF link
>     creation is ever deferred to a worker thread.
>
>  io_uring/bpf-ops.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
> index 937e48bef40b..84578614cc0b 100644
> --- a/io_uring/bpf-ops.c
> +++ b/io_uring/bpf-ops.c
> @@ -162,6 +162,9 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
>  		return -EOPNOTSUPP;
>  	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>  		return -EOPNOTSUPP;
> +	if ((ctx->flags & IORING_SETUP_SINGLE_ISSUER) &&
> +	    ctx->submitter_task && ctx->submitter_task != current)

The ctx->flags & IORING_SETUP_SINGLE_ISSUER check is redundant. IIUC,
->submitter_task can only be set if the ring is set with
IORING_SETUP_SINGLE_ISSUER.

> +		return -EEXIST;
>
>  	if (ctx->bpf_ops)
>  		return -EBUSY;
> --
> 2.43.0

-- 
Gabriel Krisman Bertazi

