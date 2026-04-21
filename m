Return-Path: <io-uring+bounces-13099-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCDpFrqw52lZ/QEAu9opvQ
	(envelope-from <io-uring+bounces-13099-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:15:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A85E43DCE4
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 02A1F303057E
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 17:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E34519004A;
	Tue, 21 Apr 2026 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MmRoCNwr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sxRDC5bW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MmRoCNwr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sxRDC5bW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E581B2FD1A5
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776791540; cv=none; b=uyovkhGlhXfmZANCAlX9Pd0Plpu+kD3DnTbVUAFO244wmpeKvWiex58WkyM4ceGIvFnaNycb+UZaJbSaRJmQon0KGKTSODkdPF83t61UPb0Xn5LZCoe7IKkLlgMwoLf+JWYVpBGiFjcFb9gcnjTLdJ1uLiNK+XbxSq/DgRGPXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776791540; c=relaxed/simple;
	bh=FW+NgB2xFrwL0HmO08ROWbJJhGcwq7aQdRCGNtkV4NE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EATedUC+01IAkKQ5L0AG8df7xXrmLQGq3LVD+M894t/iuADdwnbsHMLoyn3I211XYd9Q7TC2h8LznEoNjSZDGd2bNX2367IqKtMOB9pMLNt30b/n1VF9JzxOPVeMtdGs63KQsmddz7GnQJYvGRyWeVXkoUQ+afmw9/rKBLS2VbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MmRoCNwr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sxRDC5bW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MmRoCNwr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sxRDC5bW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E56A6A8E7;
	Tue, 21 Apr 2026 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776791537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T0mvTfPyfJPq0z79bimVL1A7nlXj25gXZux4eJdkW7I=;
	b=MmRoCNwrD6xchEG7USRrBQBAvByzVwyX/U6nGQ7jlm4YNKODGfGywl59hSAHk4TTPKmip8
	2U+GWRqdmZcUyYwz5OOXg8cNvhr/GO18An5170Y7Y2VOiBybeNBMjEj3exvHZNTX2+g2/P
	uvvILL6DUGlEtSOJ7sqVwDtxgefMMoo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776791537;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T0mvTfPyfJPq0z79bimVL1A7nlXj25gXZux4eJdkW7I=;
	b=sxRDC5bWqCTRX6hmdNKVDF+DGrmpruKjyf5pYR8rHzvovUiROYaYMtPQpryyb6AhyTeqUl
	MMxctWXCMvzaPNBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MmRoCNwr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sxRDC5bW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776791537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T0mvTfPyfJPq0z79bimVL1A7nlXj25gXZux4eJdkW7I=;
	b=MmRoCNwrD6xchEG7USRrBQBAvByzVwyX/U6nGQ7jlm4YNKODGfGywl59hSAHk4TTPKmip8
	2U+GWRqdmZcUyYwz5OOXg8cNvhr/GO18An5170Y7Y2VOiBybeNBMjEj3exvHZNTX2+g2/P
	uvvILL6DUGlEtSOJ7sqVwDtxgefMMoo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776791537;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T0mvTfPyfJPq0z79bimVL1A7nlXj25gXZux4eJdkW7I=;
	b=sxRDC5bWqCTRX6hmdNKVDF+DGrmpruKjyf5pYR8rHzvovUiROYaYMtPQpryyb6AhyTeqUl
	MMxctWXCMvzaPNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6CD4593AF;
	Tue, 21 Apr 2026 17:12:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yf1VKPCv52mlaQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 21 Apr 2026 17:12:16 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  stable@kernel.org
Subject: Re: [PATCH 6/6] io_uring/register: fix ring resizing with
 mixed/large SQEs/CQEs
In-Reply-To: <20260421135626.581917-7-axboe@kernel.dk> (Jens Axboe's message
	of "Tue, 21 Apr 2026 07:51:43 -0600")
References: <20260421135626.581917-1-axboe@kernel.dk>
	<20260421135626.581917-7-axboe@kernel.dk>
Date: Tue, 21 Apr 2026 13:12:10 -0400
Message-ID: <87tst4p79x.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13099-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mailhost.krisman.be:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 7A85E43DCE4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Jens Axboe <axboe@kernel.dk> writes:

> The ring resizing only properly handles "normal" sized SQEs or CQEs, if
> there are pending entries around a resize. This normally should not be
> the case, but the code is supposed to handle this regardless.
>
> For the mixed SQE/CQE cases, the current copying works fine as they
> are indexed in the same way. Each half is just copied separately. But
> for fixed large SQEs and CQEs, the iteration and copy need to take that
> into account.
>
> Cc: stable@kernel.org
> Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>



> ---
>  io_uring/register.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 24e593332d1a..dce5e2f9cf77 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -599,10 +599,20 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>  	if (tail - old_head > p->sq_entries)
>  		goto overflow;
>  	for (i = old_head; i < tail; i++) {
> -		unsigned src_head = i & (ctx->sq_entries - 1);
> -		unsigned dst_head = i & (p->sq_entries - 1);
> -
> -		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
> +		unsigned index, dst_mask, src_mask;
> +		size_t sq_size;
> +
> +		index = i;
> +		sq_size = sizeof(struct io_uring_sqe);
> +		src_mask = ctx->sq_entries - 1;
> +		dst_mask = p->sq_entries - 1;
> +		if (ctx->flags & IORING_SETUP_SQE128) {
> +			index <<= 1;
> +			sq_size <<= 1;
> +			src_mask = (ctx->sq_entries << 1) - 1;
> +			dst_mask = (p->sq_entries << 1) - 1;
> +		}
> +		memcpy(&n.sq_sqes[index & dst_mask], &o.sq_sqes[index & src_mask], sq_size);
>  	}
>  	WRITE_ONCE(n.rings->sq.head, old_head);
>  	WRITE_ONCE(n.rings->sq.tail, tail);
> @@ -619,10 +629,20 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>  		goto out;
>  	}
>  	for (i = old_head; i < tail; i++) {
> -		unsigned src_head = i & (ctx->cq_entries - 1);
> -		unsigned dst_head = i & (p->cq_entries - 1);
> -
> -		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
> +		unsigned index, dst_mask, src_mask;
> +		size_t cq_size;
> +
> +		index = i;
> +		cq_size = sizeof(struct io_uring_cqe);
> +		src_mask = ctx->cq_entries - 1;
> +		dst_mask = p->cq_entries - 1;
> +		if (ctx->flags & IORING_SETUP_CQE32) {
> +			index <<= 1;
> +			cq_size <<= 1;
> +			src_mask = (ctx->cq_entries << 1) - 1;
> +			dst_mask = (p->cq_entries << 1) - 1;
> +		}
> +		memcpy(&n.rings->cqes[index & dst_mask], &o.rings->cqes[index & src_mask], cq_size);
>  	}
>  	WRITE_ONCE(n.rings->cq.head, old_head);
>  	WRITE_ONCE(n.rings->cq.tail, tail);


Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi

