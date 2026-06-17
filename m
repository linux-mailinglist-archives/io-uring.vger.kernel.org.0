Return-Path: <io-uring+bounces-13764-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ry+/LTy2MmrN4AUAu9opvQ
	(envelope-from <io-uring+bounces-13764-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 16:59:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0522869ABD4
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 16:59:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=D9poun7u;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13764-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13764-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1AE9F31D4883
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 14:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46AB3B7B76;
	Wed, 17 Jun 2026 14:54:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4242C21F0
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 14:54:19 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781708062; cv=none; b=cqXDH9pkYUXa7La3frPSEezmEDkhdw0w57rfQMXmCcurJqYwswrefk0QJfFiKAnJDGFMXDI1vBBbSQ33d5hTX1cNdxGfGu5DK1lFWM+JonGTsNZfmnykYM7tXzxQktOq54cWC9uW+/mrR+l/ADNj593b/qXV+MmCQXz8DRm3rXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781708062; c=relaxed/simple;
	bh=JYvlfimKSqygNvWjrm0SJL/OntXTf5oSDKuVqv/4Qgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gNhHg3HDcAjXNDBvyRCX3ZNk8+FWEccGeWTp6coqqW0hehxKGCbNZnsXVLYdWC92F+cNLgbkMhWNtj901HeaAeIDdGSmQa1QoDgZxmBcTfQhteSv+gApB5eLx/7WMNu2NxjpF1hMoLp5/lA/hsKUsrVoynxSnsiHYVXsYFAyi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=D9poun7u; arc=none smtp.client-ip=209.85.160.45
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-43cce7db292so4451384fac.2
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 07:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781708058; x=1782312858; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K8Wv7VCkyaLN0s61xd4QXGQ88sPTQ0XGFCHSINh9F+E=;
        b=D9poun7u32mr2DCGJwc6cMYl7qlGIpMo1ilH8qatgFINlnGlNBsz9S0NxGOKmqnXKR
         TZ1NYE8YGdPgPZMDRLU0jGicSav6uH7X9ML7lqwkohB2vhHQMdsko66hgHZ12efGtifk
         8o5dx6sx5DU5Jf1wu4PqUHOL7km3rwARuWZXz847r6RNsOZxtSiEzUx6QCLyKX1JPcfN
         I5w2pk5ZcP9QQfIy+DS+OGz16gF6hEnAtdeCsUOyu+cMBliRJg8mcFyIMhVKZ0DeIRMA
         ZiuUf6/ljytzwY+4g1u+IeOax7aiA7yygB59215WNzVdhMNEEg2fdnx8Qjo5EgRRFRCp
         74HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781708058; x=1782312858;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K8Wv7VCkyaLN0s61xd4QXGQ88sPTQ0XGFCHSINh9F+E=;
        b=oP06jNUiJjyYUKQHC9MIrDUpraHnybitJ5t7KKiLgfguzo/iwrjsvUWpiYUI5Q1boM
         MWjAzlC1Ix+2ONP3QYnG2G6KmECOrr+FyqnRPzOBaipaAApchK6GcTMHE2ytyuMI2sOE
         l8u1mR+/IjgtpQbPJEjJv2t98aSdc+vnExaH8yRsejVuFouW+rd+xl4nMW7LpimIdtP7
         32d+3UYPHqtX0ouHeIZ8loBvQiIVohDZW7TLd0F4PYFiKrAQeJkp/rbmMI9nqB9Hbdpt
         ZdHKP6fkW4viM3NmhCnsKCduqNKFmaS2eSnNmktPSieCUHGfr+iLvsBlky7880H9Sg0w
         qQrA==
X-Forwarded-Encrypted: i=1; AFNElJ/gx2r9D/1fGJ+kVRmfIpCINyYP50E+Xxd0+B9TvnS8+INjSaBB//E+lfgLxjazzPE7oU5IRPHW/A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjvf+r6xAtkGRlQxO+lsiLWKO9Rc8A3riuZiSzl1rzz9ySyU+u
	eNCQEjc3IeykIg1DWb+U9Sept66Qem6YZ+Jjk6Qk9LLiL3NHp1gNqLV+bA2d+qG+z+4=
X-Gm-Gg: AfdE7cmC58wwZrTWm//xo4I3n33+JcnM6eWNtD4+v/20tmegvzc0w1gXWrqJhlOH8Sg
	kw11iozlASdUtEYlO6edQmV10Ppu5HeGpPunHUO+amjnShrjfA+Pv9Qptpu/KB8el+pUA88/Rs2
	RkxgR7yDUDRAie9bexxzjjlo8qh1Zgn9FPA41oIsKVj5bknAsjio0F12hcKy+XviaOtC3ld67So
	wiH2bBj7IDtV6wFywP5PeSoWP/lwjO5Z2229amLX5S1J1zgXaVXAKx3158FrAd6vV1LLSD0Fdxv
	x/hqpX3nENrbILOGNjtaM0ad1ca2uikpSQQoZRFZr8LLbW/ua/GAYotjKN/uJ36D5FHVLz3PUhJ
	q2A+rrGT2A3waexHo7jGx/RT0TRccIj37ObN97xnEpJo49tRT4xYfvRcA6nNuoGKGZZMStIZaRl
	eqEY/Xc/D1N7mqxTitwo4y1MJ9WJ9RKzgr8KoXOW4=
X-Received: by 2002:a05:6870:819d:b0:43c:3ae7:5e83 with SMTP id 586e51a60fabf-44690549596mr2920062fac.31.1781708058411;
        Wed, 17 Jun 2026 07:54:18 -0700 (PDT)
Received: from [172.19.0.220] ([99.196.128.98])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4430900e368sm4484893fac.16.2026.06.17.07.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 07:54:17 -0700 (PDT)
Message-ID: <2d35e4d2-72ec-4ae8-90ba-8c9b1e53c58f@kernel.dk>
Date: Wed, 17 Jun 2026 08:54:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] [PATCH v2] io_uring/register: add
 IORING_REGISTER_CLONE_FILES opcode
To: harshal24-chavan <harshal24.chavan@gmail.com>, kees@kernel.org
Cc: gustavoars@kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20260617081622.32823-1-harshal24.chavan@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260617081622.32823-1-harshal24.chavan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:harshal24.chavan@gmail.com,m:kees@kernel.org,m:gustavoars@kernel.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-hardening@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13764-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0522869ABD4

On 6/17/26 2:16 AM, harshal24-chavan wrote:
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 650303626be6..1e4e114ca5a5 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1303,6 +1303,166 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
>  	return ret;
>  }
>  
> +
> +static int io_clone_files(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
> +			  struct io_uring_clone_files *arg)
> +{
> +	struct io_file_table new_file_table;
> +	int i, off, nr;
> +	unsigned int src_nr;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +	lockdep_assert_held(&src_ctx->uring_lock);
> +
> +	/* if offsets are given, must have nr specified too */
> +	if (!arg->nr && (arg->dst_off || arg->src_off))
> +		return -EINVAL;

Not sure the offsets and partial copies are going to be worth it, but
I'm willing to have my mind changed. But that's a minor thing really.

> +	/* not allowed unless REPLACE is set */
> +	if (ctx->file_table.data.nr &&
> +	    !(arg->flags & IORING_REGISTER_DST_REPLACE))
> +		return -EBUSY;
> +
> +	src_nr = src_ctx->file_table.data.nr;
> +	if (!src_nr)
> +		return -ENXIO;
> +	if (!arg->nr)
> +		arg->nr = src_nr;
> +	else if (arg->nr > src_nr)
> +		return -EINVAL;
> +	else if (arg->nr > IORING_MAX_FIXED_FILES)
> +		return -EINVAL;
> +	if (check_add_overflow(arg->nr, arg->src_off, &off) || off > src_nr)
> +		return -EOVERFLOW;
> +	if (check_add_overflow(arg->nr, arg->dst_off, &src_nr))
> +		return -EOVERFLOW;
> +	if (src_nr > IORING_MAX_FIXED_FILES)
> +		return -EINVAL;
> +	/* Allocate file tables memory {data + bitmap} into new_file_table */
> +	memset(&new_file_table, 0, sizeof(new_file_table));
> +	if (!io_alloc_file_tables(ctx, &new_file_table,
> +				  max(src_nr, ctx->file_table.data.nr)))
> +		return -ENOMEM;

Also a question whether the destination should've already allocated a
sparse table. This kind of bundles the two into one. In general, as
mention on the GH link, I do think this should work exactly like cloning
buffers. It'd be somewhat confusing if they don't match up, as it's
essentially the same operation, just on a different node type.


> +	/* Copy original dst nodes from before the cloned range */
> +	for (i = 0; i < min(arg->dst_off, ctx->file_table.data.nr); i++) {
> +		struct io_rsrc_node *node = ctx->file_table.data.nodes[i];
> +
> +		if (node) {
> +			new_file_table.data.nodes[i] = node;
> +			node->refs++;
> +			io_file_bitmap_set(&new_file_table, i);
> +		}
> +	}

This definitely won't work - I also mentioned in the GH link that nodes
cannot be shared, you have to allocate new nodes on the destination
side.

> +	while (nr--) {
> +		struct io_rsrc_node *dst_node, *src_node;
> +
> +		src_node = io_rsrc_node_lookup(&src_ctx->file_table.data, i);
> +		if (!src_node) {
> +			dst_node = NULL;
> +		} else {
> +			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
> +			if (!dst_node) {
> +				io_free_file_tables(ctx, &new_file_table);
> +				return -ENOMEM;
> +			}
> +
> +			struct file *file = io_slot_file(src_node);
> +
> +			get_file(file);
> +			io_fixed_file_set(dst_node, file);
> +		}
> +		new_file_table.data.nodes[off] = dst_node;
> +		if (dst_node)
> +			io_file_bitmap_set(&new_file_table, off);
> +
> +		i++;
> +		off++;
> +	}

Same here, it needs a new node that's private to the destination. Hence
you'd need to _always_ allocate one, assign the file, and get a
reference to it.

The file nodes rely on non-atomic refs when being used, which is
protected by the ctx->uring_lock as that's always held for the fast path
issue. If you just assign the node by reference, now you have two
different rings manipulating the same node in memory, but they don't
agree on synchronization.

-- 
Jens Axboe

