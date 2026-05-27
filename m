Return-Path: <io-uring+bounces-13514-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uAjrDSijFmqBnwcAu9opvQ
	(envelope-from <io-uring+bounces-13514-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 09:54:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D132F5E0AA2
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 09:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 179D7300BD93
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 07:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12943CD8BD;
	Wed, 27 May 2026 07:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/LoAvJP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EF13CCFD9;
	Wed, 27 May 2026 07:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779868386; cv=none; b=MZJ51ScsWTpi5VCT5CCiGJL1qroTWrPGv5Z/EiktUHE5c86/kD1Fpi4rFI6tkWZm8jX9SK19cSWxyvRsXtCrdBkIzXlpgo8fl+y5aW+2rMeUZsKZOjycaT8c6rhFVkwaTpTkmoPn+D8hh1YlMbAGr4MhVyL0Q6KmgjutVJ1qfjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779868386; c=relaxed/simple;
	bh=JQfPs4qyF8FMAJp0acXsGiDjC8SL5SQPb/DEVP9U/NY=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=WusN877t/4u+UwmbtMbb10q4NCqiMs7tKvxH1F1pbP4Ym+zj8IOK7p786Ig3fSGWemLzO1zEwxn3OwqYQxAA5DoIolphx7VYdTSRJIIqL+whNtljrcqjxnGZJfT3vJfiexov1Nw/BRkGvXjS+juie6I8qTUQ9/h/J1fB4Wg/Nq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/LoAvJP; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF041F000E9;
	Wed, 27 May 2026 07:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779868384;
	bh=Y+kGq0uunmREFgzVVLHHxPdC664CmUzrN4A02+MaM5c=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Y/LoAvJPd3wM9J66save3K6aXvb9rA0mMByndjKNrGjyUpfzpPle8B7OLNvHCqtKg
	 q7BGrOHY8N0MHjNtOcbmzF0zQhT4xSCFSscIbWL7kmkUaGCge8m7D3HTPOroftHtlV
	 1Q5YY+9ivs21hp4cFgJyRDziiCPltn4FSaPHz6AMCBGz7DE3IeLw1yK9B7vvkqsGa7
	 Mxw7Kr0JgyEv1n38pCyiiHR3id5tkI/HG589dmSHxuATcIQ9/yE06ZAXRNRYIsDY/S
	 m3h6OUojhIoGQAAez+DI/K0q08EYGW28qS67jpy1c6z33xfTR/Ii1mfqznW5u2+/ou
	 j2P1mnPXDtjbw==
Content-Type: multipart/mixed; boundary="===============2215855977696880001=="
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <582275f111aae9b0fb4520a98c60b5014751114022782c3aadeced2c21cbb3c7@mail.kernel.org>
In-Reply-To: <20260527070239.2252948-2-hch@lst.de>
References: <20260527070239.2252948-2-hch@lst.de>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
From: bot+bpf-ci@kernel.org
To: hch@lst.de,vbabka@kernel.org,harry@kernel.org,akpm@linux-foundation.org
Cc: hao.li@linux.dev,cl@gentwo.org,rientjes@google.com,roman.gushchin@linux.dev,hawk@kernel.org,linux-arm-msm@vger.kernel.org,dri-devel@lists.freedesktop.org,freedreno@lists.freedesktop.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,io-uring@vger.kernel.org,kasan-dev@googlegroups.com,bpf@vger.kernel.org,netdev@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 27 May 2026 07:53:04 +0000 (UTC)
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTYPE_MIXED_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.dev,gentwo.org,google.com,kernel.org,vger.kernel.org,lists.freedesktop.org,kvack.org,googlegroups.com,iogearbox.net,gmail.com,meta.com];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NEQ_ENVFROM(0.00)[bot@kernel.org,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13514-lists,io-uring=lfdr.de,bpf-ci];
	MIME_TRACE(0.00)[0:+,1:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[26];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NO_DN(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.kernel.org:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: D132F5E0AA2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

--===============2215855977696880001==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
> index 75d98dad7b1d..b80d7e1d5123 100644
> --- a/drivers/gpu/drm/panthor/panthor_mmu.c
> +++ b/drivers/gpu/drm/panthor/panthor_mmu.c
> @@ -1274,10 +1274,9 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
>  		goto err_cleanup;
>  	}
>
> -	ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
> -				    op_ctx->rsvd_page_tables.pages);
> -	op_ctx->rsvd_page_tables.count = ret;
> -	if (ret != pt_count) {
> +	if (!kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
> +			op_ctx->rsvd_page_tables.pages)) {
> +		op_ctx->rsvd_page_tables.count = 0;
>  		ret = -ENOMEM;
>  		goto err_cleanup;
>  	}

Does this omit setting op_ctx->rsvd_page_tables.count to pt_count on success?

Since op_ctx is initialized via memset previously, the count will remain 0 when
the allocation succeeds. This could lead to memory leaks when these page tables
are consumed or cleaned up later, since the cleanup code won't know about the
allocated page tables.

The original code set the count to ret on both success and failure. The
updated code only sets count = 0 in the failure path, but doesn't set
count = pt_count in the success path.

[ ... ]

> diff --git a/lib/test_meminit.c b/lib/test_meminit.c
> index 6298f66c964b..3727dee7c262 100644
> --- a/lib/test_meminit.c
> +++ b/lib/test_meminit.c
> @@ -229,14 +229,12 @@ static int __init do_kmem_cache_size(size_t size, bool want_ctor,
>  	for (iter = 0; iter < 10; iter++) {
>  		/* Do a test of bulk allocations */
>  		if (!want_rcu && !want_ctor) {
> -			int ret;
> -
> -			ret = kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE, bulk_array);
> -			if (!ret) {
> +			if (!kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE,
> +					bulk_array)) {
>  				fail = true;
>  			} else {
>  				int i;
> -				for (i = 0; i < ret; i++)
> +				for (i = 0; i < BULK_SIZE; i++)
>  					fail |= check_buf(bulk_array[i], size, want_ctor, want_rcu, want_zero);
>  				kmem_cache_free_bulk(c, ret, bulk_array);
>  			}

Will this cause a compilation error?

The local variable ret is removed from this scope, but it's still used in the
kmem_cache_free_bulk() call. This should fail to compile because ret is
undeclared.

The fix should probably replace ret with BULK_SIZE in the free call:

	kmem_cache_free_bulk(c, BULK_SIZE, bulk_array);


> @@ -354,17 +352,18 @@ static int __init do_kmem_cache_size_bulk(int size, int *total_failures)
>
>  	c = kmem_cache_create("test_cache", size, size, 0, NULL);
>  	for (iter = 0; (iter < maxiter) && !fail; iter++) {
> -		num = kmem_cache_alloc_bulk(c, GFP_KERNEL, ARRAY_SIZE(objects),
> -					    objects);
> -		for (i = 0; i < num; i++) {
> +		if (!kmem_cache_alloc_bulk(c, GFP_KERNEL, ARRAY_SIZE(objects),
> +				objects))
> +			continue;
> +
> +		for (i = 0; i < ARRAY_SIZE(objects); i++) {
>  			bytes = count_nonzero_bytes(objects[i], size);
>  			if (bytes)
>  				fail = true;
>  			fill_with_garbage(objects[i], size);
>  		}
>
> -		if (num)
> -			kmem_cache_free_bulk(c, num, objects);
> +		kmem_cache_free_bulk(c, num, objects);
>  	}
>  	kmem_cache_destroy(c);
>  	*total_failures += fail;

Is num uninitialized here?

It's no longer assigned the result of the allocation call. Passing it to
kmem_cache_free_bulk() will use indeterminate stack data, which could lead to
memory corruption. The fix should probably be:

	kmem_cache_free_bulk(c, ARRAY_SIZE(objects), objects);

[ ... ]

> diff --git a/mm/slub.c b/mm/slub.c
> index a2bf3756ca7d..d9790e7c17f6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -7352,18 +7362,18 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>  	 */
>  	unsigned int i = 0;
>  	void *kfence_obj;
>
>  	if (!size)
> -		return 0;
> +		return false;

Does this incorrectly report an allocation failure when size is 0?

Previously, callers interpreting the return value against size (ret != size)
would treat 0 objects allocated for a request of 0 as a success. Returning
false here contradicts the typical kernel behavior where allocating 0 items is
a successful no-op.

This might cause callers to incorrectly abort with an error when they request
0 objects, which should be a valid no-op case.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26496962101
--===============2215855977696880001==--

