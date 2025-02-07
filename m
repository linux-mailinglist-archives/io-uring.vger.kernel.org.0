Return-Path: <io-uring+bounces-6297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA7BA2C4C9
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 15:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88319188FD3D
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 14:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0123B2248BF;
	Fri,  7 Feb 2025 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SR1RWO1T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D978D2236EB;
	Fri,  7 Feb 2025 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738937301; cv=none; b=nHwkHrjNmImzB1nW3bFZZxCGQ+Gumc0xIntDgpRKv8TkD3JnpYRHsnQ97sOJn4BHZrTNRUhOTn1UKR2zAWaFR8KMQ561VIhxm05bWE9rwi1f5HtMRDK3aCrLD9rNEgKxAnI3G9bvFYKHiY3tLCza7yJ0rTyAgrYW0WYbJWDeQOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738937301; c=relaxed/simple;
	bh=93gd5DgkvCAq8hGY8QDexQ7DMFZpRoGX1eRfGc0mZyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RENLkxrmGzvoicI/B2jdcIMdG4NS2ApmciGEsAMRtarO7RL7KdgmC1tAbPsympNBn0udlgbaUAtuGwg74QBf7aF1CC9jtM26yWp4YyMCSpxVUaq/hU3YcFdIkcsQ0Eo8tOBNj8Am0j7x+V/1P+zrlp9VKDFrjYzJ18V32fkhJkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SR1RWO1T; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab78d9c5542so114982866b.1;
        Fri, 07 Feb 2025 06:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738937298; x=1739542098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZsyGFluwDj0m/QCC2/e4g1KcV2Bpno5K2Hr3t9It75g=;
        b=SR1RWO1TrxOHdKRUiizKz3xnMcHyMSBpgVgYLwaVXcwIkj0O7FjsAf0zQu903UD7rE
         sk2NcqpI5WSj7Ld+nO2Rr6TYgTNNS1fjDWOEwLIrHORMxRzdMnjRc0JC8qj9DwBDC3ds
         V3P0jeeOZZLN35DTuxseXSAxA1iWjUawKvNntQWtQnfEkJEjTyCdDCZSpyLYnSG/6xbV
         Fk7+LZh/dZ5T5ZecSv5YNXeyvQiAcepdpyPbAJ4NsNbDfXp1aERFId1JS2AJA3xo6PJ5
         MGdAOkA3CMb1fwzkS2avRsNaFUq8pD7NPpiHXpIEOrqGtlgwFWs1tia2H/e4QutPM208
         B8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738937298; x=1739542098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsyGFluwDj0m/QCC2/e4g1KcV2Bpno5K2Hr3t9It75g=;
        b=lGjeJo9MItbx6kWHPrpXycCzMN4B1XJWu1O0x4iQi7CuweBA0GRQkUAF6MZAOxOHop
         wFE+Aw3MVvQ2lMNygakmDO1AMPO+8tlr3uu+4K7GWnLccO7aMrckGN4F77tMA69uGvKc
         uV/dzLqhXVZR6vYxmbgg1wEqVf06SoRkrxYjh7eyhNV8VER8T0DW+wT6umFJ5VThBKt0
         vPsileKWHOWClOzEk2WQKW1oq+g+d6Zp2aOyHG/sjiND56squ2/Ya3zXacg5Cf8wcayt
         cm7U9kReFmJUVjdg8DiwfuF1EJl6r2EiQZp/g0gPUdnuN9qeaOnbesP1btjRs5doPJz+
         mPYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBlHWgUfJL7GtAaTF5YY8dSrYZS/p5rbP+lComI5MWK+SM1Gl9mRLsrowForEsAKqa9NJcKSXWdXLMYXI=@vger.kernel.org, AJvYcCXQqogcl4ZQYor8opNJgoKpG+NX+kM7JQSQtuM5wltj12Tbl0nxd0oFZIyb/+ExT7U0ZzOTbdeeIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyG50rleBxrdo/r0PkczQjl6K9F+apspYf7zu2Q/WBdaQRQnT0
	Ric3qeLryRTop2L2EI1dN0wAfDZwwqKfNpNH4pLe3jrpLebPul8x
X-Gm-Gg: ASbGnctcCsa4exuCj6eOyVQm8WAazOYTRdDhWDfJXevBbcYwWOxtU0ioZCe1v29AENs
	fIe8qlsLek8gHDjAvrrrCxPMqwNJi8hqKlgEBSIwdRZqBqjA3PrNxa6IXHNeYDjnGkjNvXuXmIH
	o4TxyVEh0/Kx0eIO81Yh1h8Ag5toMJccXFh5XJS1Jyfxq2Ho3O+/EMFbjs3M6Zw5uhjbilIGVaZ
	cWgA1j/Hr2OecGfJ/MztZyUc9qCy0IoatGsYaAJGHvpdeTU1yXQgzbna6FaqFYBZmg33DPdU/IL
	y9PT6l5ABH7PTzw1tsw+x2G8MgtljIorq8DKzoqtVWhO1xiH
X-Google-Smtp-Source: AGHT+IHuuVoj/faw33QdzBEzwiRwIAuZKSQ8mYeS4TUFCiJMVDrIw+PNg0A3aqHEc9kZkr+es9hwlA==
X-Received: by 2002:a17:907:7ba9:b0:ab2:f8e9:5f57 with SMTP id a640c23a62f3a-ab789ab496bmr254454266b.21.1738937297835;
        Fri, 07 Feb 2025 06:08:17 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8e12])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab78ee9e208sm87832666b.50.2025.02.07.06.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 06:08:17 -0800 (PST)
Message-ID: <b36f0c87-71ad-444f-b234-f71953ca58ba@gmail.com>
Date: Fri, 7 Feb 2025 14:08:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
Cc: Keith Busch <kbusch@kernel.org>
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-4-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250203154517.937623-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/25 15:45, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide an interface for the kernel to leverage the existing
> pre-registered buffers that io_uring provides. User space can reference
> these later to achieve zero-copy IO.
> 
> User space must register an empty fixed buffer table with io_uring in
> order for the kernel to make use of it.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/linux/io_uring.h       |   1 +
>   include/linux/io_uring_types.h |   3 +
>   io_uring/rsrc.c                | 114 +++++++++++++++++++++++++++++++--
>   io_uring/rsrc.h                |   1 +
>   4 files changed, 114 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 85fe4e6b275c7..b5637a2aae340 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -5,6 +5,7 @@
>   #include <linux/sched.h>
>   #include <linux/xarray.h>
>   #include <uapi/linux/io_uring.h>
> +#include <linux/blk-mq.h>
>   
>   #if defined(CONFIG_IO_URING)
>   void __io_uring_cancel(bool cancel_all);
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 623d8e798a11a..7e5a5a70c35f2 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -695,4 +695,7 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *ctx)
>   	return ctx->flags & IORING_SETUP_CQE32;
>   }
>   
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, const struct request *rq, unsigned int tag);
> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int tag);
> +
>   #endif
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 4d0e1c06c8bc6..8c4c374abcc10 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -111,7 +111,10 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>   		if (!refcount_dec_and_test(&imu->refs))
>   			return;
>   		for (i = 0; i < imu->nr_bvecs; i++)
> -			unpin_user_page(imu->bvec[i].bv_page);
> +			if (node->type == IORING_RSRC_KBUF)
> +				put_page(imu->bvec[i].bv_page);

Just a note, that's fine but I hope we'll be able to optimise
that later.

> +			else
> +				unpin_user_page(imu->bvec[i].bv_page);
>   		if (imu->acct_pages)
>   			io_unaccount_mem(ctx, imu->acct_pages);
>   		kvfree(imu);
> @@ -240,6 +243,13 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>   		struct io_rsrc_node *node;
>   		u64 tag = 0;
>   
> +		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
> +		node = io_rsrc_node_lookup(&ctx->buf_table, i);
> +		if (node && node->type != IORING_RSRC_BUFFER) {

We might need to rethink how it's unregistered. The next patch
does it as a ublk commands, but what happens if it gets ejected
by someone else? get_page might protect from kernel corruption
and here you try to forbid ejections, but there is io_rsrc_data_free()
and the io_uring ctx can die as well and it will have to drop it.
And then you don't really have clear ownership rules. Does ublk
releases the block request and "returns ownership" over pages to
its user while io_uring is still dying and potenially have some
IO inflight against it?

That's why I liked more the option to allow removing buffers from
the table as per usual io_uring api / rules instead of a separate
unregister ublk cmd. And inside, when all node refs are dropped,
it'd call back to ublk. This way you have a single mechanism of
how buffers are dropped from io_uring perspective. Thoughts?

> +			err = -EBUSY;
> +			break;
> +		}
> +
>   		uvec = u64_to_user_ptr(user_data);
>   		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
>   		if (IS_ERR(iov)) {
> @@ -258,6 +268,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>   			err = PTR_ERR(node);
>   			break;
>   		}
...
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, const struct request *rq,
> +			    unsigned int index)
> +{
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	u16 nr_bvecs = blk_rq_nr_phys_segments(rq);
> +	struct req_iterator rq_iter;
> +	struct io_rsrc_node *node;
> +	struct bio_vec bv;
> +	int i = 0;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	if (WARN_ON_ONCE(!data->nr))
> +		return -EINVAL;

IIUC you can trigger all these from the user space, so they
can't be warnings. Likely same goes for unregister*()

> +	if (WARN_ON_ONCE(index >= data->nr))
> +		return -EINVAL;
> +
> +	node = data->nodes[index];
> +	if (WARN_ON_ONCE(node))
> +		return -EBUSY;
> +
> +	node = io_buffer_alloc_node(ctx, nr_bvecs, blk_rq_bytes(rq));
> +	if (!node)
> +		return -ENOMEM;
> +
> +	rq_for_each_bvec(bv, rq, rq_iter) {
> +		get_page(bv.bv_page);
> +		node->buf->bvec[i].bv_page = bv.bv_page;
> +		node->buf->bvec[i].bv_len = bv.bv_len;
> +		node->buf->bvec[i].bv_offset = bv.bv_offset;

bvec_set_page() should be more convenient

> +		i++;
> +	}
> +	data->nodes[index] = node;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> +

...
>   			unsigned long seg_skip;
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index abd0d5d42c3e1..d1d90d9cd2b43 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -13,6 +13,7 @@
>   enum {
>   	IORING_RSRC_FILE		= 0,
>   	IORING_RSRC_BUFFER		= 1,
> +	IORING_RSRC_KBUF		= 2,

The name "kbuf" is already used, to avoid confusion let's rename it.
Ming called it leased buffers before, I think it's a good name.


-- 
Pavel Begunkov


