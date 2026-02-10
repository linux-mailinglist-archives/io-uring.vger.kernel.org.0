Return-Path: <io-uring+bounces-12141-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILdVI3Bei2msUAAAu9opvQ
	(envelope-from <io-uring+bounces-12141-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 17:36:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D754011D495
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 17:35:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD5093016509
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 16:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFB730BF60;
	Tue, 10 Feb 2026 16:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzMOnB9/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBF230E856
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741293; cv=none; b=WVF8RdRMVosTHbL5caCCt/rAlNEj/peXnTMKvs/un/HWHC/i0IpiyeNIvymu4D6ZcxGUgCdCmJwvp33pdS/BDzDZXwYRw8cv4Gp60dZNkmgE/xGZ1CUR3aoCNQapIlUITDBg85tSwns9uVgQNvUnQ3h4MbIYxUZo2brMeQHn4NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741293; c=relaxed/simple;
	bh=86veMx+9eyZ8ry9KnNBmk+A8u4XCFjTLj02RM4J52O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nVCE/QwA4/SjcHxd/DqmY6GKvTLjYhsTwuVrmC/35N6ixTqFZKAXk3vztWUXcdBM/uCbiz+64dJ7IomWwlabHQx2dmwTGXaYH24x1pjgnrTCAajTVaKjzrMU+ddAyCFlhKk32DvMbm/OguPBu2d/Tt+ItWpRD357vm2zapRH5wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzMOnB9/; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so153610766b.2
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 08:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770741290; x=1771346090; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ABe5+RnZ8t9OkhePp+H59/cidwaikp31ekZ9ygT6MI0=;
        b=RzMOnB9/B6HWDaA8Pv4zigrVtiSPics2sxwSyOSbhmlJFLn0HYk2d1mVf/TzDUP0Ir
         Y9ZK2sSQxLPgQ4J7OsiLBzd3FXq3L33QWbf/dP2PtGjvbAwRu2Y4bkhADdUhNCsuxed9
         F/PtGgUktrGHp/y4WZtfcJwTsk665/xz5/C70kbvPb6zydhDn2LrNdyJv7tn7iO+PPAV
         jbzQuqiv6IDSM6wjHY1b4gYhxeJhzJKhiRF6R+48fYOFmBb/0oLkVhnOVuyW8Bw9+dqf
         uM7FoGn8FivSpVcEhzoOrdfflqvN+viXi5NL2ErHD2DW5KgIhtA17kb/VYQax4JvPvfJ
         DB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770741290; x=1771346090;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABe5+RnZ8t9OkhePp+H59/cidwaikp31ekZ9ygT6MI0=;
        b=GYU4vO1arxSdlyCOKHWvSEuHvvcRJstCtziMUbn1BGPlZj+2eKdMbGlpz2XvVRYeTN
         c3+wZOagbBrT6g/R3euh8x9rzZnG6wLilLgvy9AYCogNgxUg4Cpg2FPvGaNNPzC7mDS+
         pyj0r4Ty1gzAx+ej7/4GwCDUXaL/631yUyAyoy2lqGn9IVf6fvPINdOzX5BuFY0+CVvX
         I7NOdHqR50vZcpSbDCtyJCE9xMHog3alAFZ/Qs97SQ4p4/Iq2THdhql99ELVIbSyYyKx
         nuGKfuui7g8AXRwf1Ja5Llep91As9a9Cvdb4X491rk4pYTbbMQqZLQe7b6GxrxINBWOE
         QBng==
X-Forwarded-Encrypted: i=1; AJvYcCWIQFVtSzqQ+tLY/0/M5x/a6QnWQ3D7j7iU1lRg4HWctxgYkmt6QPI2rjJCHnMYW7M6AWSEmumjRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsNPPUzaCFKq5T1973Ctpgj4h7Tl2ffTrAjsmOXjtu7yyHKufD
	G+Sv1NN/ObT7CmmmPvCbwvYn7/9u0J+D6Rtcf9ZYiVc+BsD0K2wFJ31K
X-Gm-Gg: AZuq6aJPlJ+Oy8wpoA5qS0yQOV5amsSsPFRqc9gx3OT3F4OALfgwm+mWdjLca7JoDeh
	mmLUcrTTDrTYuDJ4WS/QoVT1q30pd2i/tFrv/A/W1RRszEfiun8ZLrplAMjz5YqMrjTramq+ytM
	zhG/9hmdLqsSoG1fwAjKmNHXmbzOH7A40E5U3DEde/4XbWu+Orper5Y8VXGPxKfB5chtimAAHyW
	5i9A7ZRX2qgifXAfQC47iiBZLeJ2305iAZp4jJ5f9pbVvrTkLsMsX9LL8vpB8L9ZJ8QTXCnwY+P
	4xnScAme9yK+TyqN+mA9RgQNYvACl+srT8ufm/gXfqak2DV+WHHHagIkpqgVadv67qaFvu+EE66
	BOE+9+lMl5tniHdKW5tVddg7Et4TjUJsmxh3WrTTFI2XLlildFOJ05Q+9JSxhE20mld8OoK7Hq7
	PX8IzXH1hnQWAuzqAgseynjf+W06YlesA1xwC87YoLBctOfLthd0ZQYvN2fiTyMEhyfZC08LcxT
	DQXYMoz+MJGqOJvumCfEDK29SbUR+v+acCdmwUiOktsA8/TeXjCHMUEKsY8XIFBHH3OpA==
X-Received: by 2002:a17:907:930c:b0:b88:4849:38bd with SMTP id a640c23a62f3a-b8edf225bb3mr871770466b.23.1770741290161;
        Tue, 10 Feb 2026 08:34:50 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:c74d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edacf1564sm540488766b.52.2026.02.10.08.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 08:34:49 -0800 (PST)
Message-ID: <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
Date: Tue, 10 Feb 2026 16:34:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org
Cc: csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com,
 hch@infradead.org, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260210002852.1394504-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12141-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D754011D495
X-Rspamd-Action: no action

On 2/10/26 00:28, Joanne Koong wrote:
> Add support for kernel-managed buffer rings (kmbuf rings), which allow
> the kernel to allocate and manage the backing buffers for a buffer
> ring, rather than requiring the application to provide and manage them.
> 
> This introduces two new registration opcodes:
> - IORING_REGISTER_KMBUF_RING: Register a kernel-managed buffer ring
> - IORING_UNREGISTER_KMBUF_RING: Unregister a kernel-managed buffer ring
> 
> The existing io_uring_buf_reg structure is extended with a union to
> support both application-provided buffer rings (pbuf) and kernel-managed
> buffer rings (kmbuf):
> - For pbuf rings: ring_addr specifies the user-provided ring address
> - For kmbuf rings: buf_size specifies the size of each buffer. buf_size
>    must be non-zero and page-aligned.
> 
> The implementation follows the same pattern as pbuf ring registration,
> reusing the validation and buffer list allocation helpers introduced in
> earlier refactoring. The IOBL_KERNEL_MANAGED flag marks buffer lists as
> kernel-managed for appropriate handling in the I/O path.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>   include/uapi/linux/io_uring.h |  15 ++++-
>   io_uring/kbuf.c               |  81 ++++++++++++++++++++++++-
>   io_uring/kbuf.h               |   7 ++-
>   io_uring/memmap.c             | 111 ++++++++++++++++++++++++++++++++++
>   io_uring/memmap.h             |   4 ++
>   io_uring/register.c           |   7 +++
>   6 files changed, 219 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index fc473af6feb4..a0889c1744bd 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -715,6 +715,10 @@ enum io_uring_register_op {
>   	/* register bpf filtering programs */
>   	IORING_REGISTER_BPF_FILTER		= 37,
>   
> +	/* register/unregister kernel-managed ring buffer group */
> +	IORING_REGISTER_KMBUF_RING		= 38,
> +	IORING_UNREGISTER_KMBUF_RING		= 39,
> +
>   	/* this goes last */
>   	IORING_REGISTER_LAST,
>   
> @@ -891,9 +895,16 @@ enum io_uring_register_pbuf_ring_flags {
>   	IOU_PBUF_RING_INC	= 2,
>   };
>   
> -/* argument for IORING_(UN)REGISTER_PBUF_RING */
> +/* argument for IORING_(UN)REGISTER_PBUF_RING and
> + * IORING_(UN)REGISTER_KMBUF_RING
> + */
>   struct io_uring_buf_reg {
> -	__u64	ring_addr;
> +	union {
> +		/* used for pbuf rings */
> +		__u64	ring_addr;
> +		/* used for kmbuf rings */
> +		__u32   buf_size;

If you're creating a region, there should be no reason why it
can't work with user passed memory. You're fencing yourself off
optimisations that are already there like huge pages.

> +	};
>   	__u32	ring_entries;
>   	__u16	bgid;
>   	__u16	flags;
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index aa9b70b72db4..9bc36451d083 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
...
> +static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
> +			       struct io_buffer_list *bl,
> +			       struct io_uring_buf_reg *reg)
> +{
> +	struct io_uring_buf_ring *ring;
> +	unsigned long ring_size;
> +	void *buf_region;
> +	unsigned int i;
> +	int ret;
> +
> +	/* allocate pages for the ring structure */
> +	ring_size = flex_array_size(ring, bufs, bl->nr_entries);
> +	ring = kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
> +	if (!ring)
> +		return -ENOMEM;
> +
> +	ret = io_create_region_multi_buf(ctx, &bl->region, bl->nr_entries,
> +					 reg->buf_size);

Please use io_create_region(), the new function does nothing new
and only violates abstractions.

Provided buffer rings with kernel addresses could be an interesting
abstraction, but why is it also responsible for allocating buffers?
What I'd do:

1. Strip buffer allocation from IORING_REGISTER_KMBUF_RING.
2. Replace *_REGISTER_KMBUF_RING with *_REGISTER_PBUF_RING + a new flag.
    Or maybe don't expose it to the user at all and create it from
    fuse via internal API.
3. Require the user to register a memory region of appropriate size,
    see IORING_REGISTER_MEM_REGION, ctx->param_region. Make fuse
    populating the buffer ring using the memory region.

I wanted to make regions shareable anyway (need it for other purposes),
I can toss patches for that tomorrow.

A separate question is whether extending buffer rings is the right
approach as it seems like you're only using it for fuse requests and
not for passing buffers to normal requests, but I don't see the
big picture here.

> +	if (ret) {
> +		kfree(ring);
> +		return ret;
> +	}
> +
> +	/* initialize ring buf entries to point to the buffers */
> +	buf_region = bl->region.ptr;

io_region_get_ptr()

> +	for (i = 0; i < bl->nr_entries; i++) {
> +		struct io_uring_buf *buf = &ring->bufs[i];
> +
> +		buf->addr = (u64)(uintptr_t)buf_region;
> +		buf->len = reg->buf_size;
> +		buf->bid = i;
> +
> +		buf_region += reg->buf_size;
> +	}
> +	ring->tail = bl->nr_entries;
> +
> +	bl->buf_ring = ring;
> +	bl->flags |= IOBL_KERNEL_MANAGED;
> +
> +	return 0;
> +}
> +
> +int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +	struct io_uring_buf_reg reg;
> +	struct io_buffer_list *bl;
> +	int ret;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	ret = io_copy_and_validate_buf_reg(arg, &reg, 0);
> +	if (ret)
> +		return ret;
> +
> +	if (!reg.buf_size || !PAGE_ALIGNED(reg.buf_size))

With io_create_region_multi_buf() gone, you shouldn't need
to align every buffer, that could be a lot of wasted memory
(thinking about 64KB pages).

> +		return -EINVAL;
> +
> +	bl = io_alloc_new_buffer_list(ctx, &reg);
> +	if (IS_ERR(bl))
> +		return PTR_ERR(bl);
> +
> +	ret = io_setup_kmbuf_ring(ctx, bl, &reg);
> +	if (ret) {
> +		kfree(bl);
> +		return ret;
> +	}
> +
> +	ret = io_buffer_add_list(ctx, bl, reg.bgid);
> +	if (ret)
> +		io_put_bl(ctx, bl);
> +
> +	return ret;

-- 
Pavel Begunkov


