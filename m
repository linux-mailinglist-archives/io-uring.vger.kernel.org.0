Return-Path: <io-uring+bounces-4750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F2A9CFB66
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 01:00:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 989DF1F22F29
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 00:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A43318FC65;
	Sat, 16 Nov 2024 00:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHvcwERl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDCB19CD01;
	Fri, 15 Nov 2024 23:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731715200; cv=none; b=mWAU3H6Zm6wZ9rHzYRFhiIEffI0zREyg4iS2KSsWF+bxE0Q363Zv1Fp4Y5Zx/4bSEXUweDCIb6h1SIDA/Hc4/TnYSOVCBx3qFebGp0NOpBLmqD1C1/dxseaLDDkmn9PZcOBT6+Pl+O6ao0n2DUqTOdcEAWeVh18M96adAvuooL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731715200; c=relaxed/simple;
	bh=kMEf4uy9nCFZR+G56qL8HUWtzhq2D1KW+Xk6JWWbZws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YLMWQ5ZqXafQtNrREHCD2xrBPIKQqcGA6CpjfyF3GRcMF4XcCuRv+Z8pic8qXkonY/bN8fW/R8Y9+maUH7lZYhvnanfwcpRshvZkp17mbuMQtob50vj2l+OC4i/itDVa5aLTfEjo0Uc6Jlk8q7LjA+qZjLDuoaQiqQc+qlB6sTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iHvcwERl; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4315df7b43fso19797325e9.0;
        Fri, 15 Nov 2024 15:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731715197; x=1732319997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Ub+hhbIuAfONcEAapKR7TEJICFZwPInFyKrgiiMvBE=;
        b=iHvcwERlTcVPpaLjQzr5p1qIs3XC+jraKeW7EXu7E0dp9yLs4FEYi2Yd49foa38G1O
         1Nusq9mLVB9DOWAY021MYSYoXw4KVN5bGZW/F+9sDd5hwP1Ot73muJ6qIsd8p/LSkDfk
         0fB6AkxhOtUpTqMnCxJvH8SMOeFsmlBP2THSnx7JpT/ojadJc8BDA50xLnFWRutIEPvE
         SNVV8QQY9k0vk2txRVaZTvZJKBR9FJcwj+/1kFHozIl1jxHg7xXbaQZQ0nY1iTsnweIM
         +W76vKRlpuC7BxkUwujswcNMjFTsQgifT9ozbcUpZev2x2HG08KHoszjWZVjZTvshrfh
         /Mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731715197; x=1732319997;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ub+hhbIuAfONcEAapKR7TEJICFZwPInFyKrgiiMvBE=;
        b=pCZda1cTuoO7q+rxCCjjHISTL2vKUTIu8Jzv6IrXR1N1VRmhE/hPNsll3ogX8wazNd
         4vXDZzELgzmutEBJqL9gAUWZCwYHXOofrlQySjGDA4iSqXvuHzfpb7OOx5lTcj5GXtfB
         XCcLU+38eAbGqIaUfYUSDO5CUZqR9Q3N352uDjurTCsE920aMkEzYvXVY8Ij7tt/MxiX
         AgLzWI7/ObuVDHv6vDANTYAhQ37bg3hhnSMikp3U+RJadYG1sy7FV94w1RIHgneuOOPH
         2xC2r/nLfSQebau41Y9MhLhHDL+B4hYzyKHbxje6RA9tSrBqkBekad7OvkoLL2vrn0d2
         p/qA==
X-Forwarded-Encrypted: i=1; AJvYcCV2aMyxJsQ2+NlpcJs5VtgZGWpTQ+VapC3xv2jnIS5akYHCw+VJ+qGSlRuL+V12kpeOzU0z7Pesu1wl008o7A==@vger.kernel.org, AJvYcCVz03zRJdGJLPyrbomBq+s1G4ak4LRwNuPy2MpA8PRrMEFMCMchpCcnbU5z0xI80S29M6BgNvNGIGGDkQ==@vger.kernel.org, AJvYcCXp6wjttpMIx7XAfKiVMOXugVfIL+BBk1qeM/XHWwzOlsLKtPcMVHZIocI9VkRGTG52E2aSBEiaIB5FLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjizGiyOUF7a7TU/K2g4GB9LGEvfJvUT6CxA7ymHZkm2f21GwW
	iUrcAuDoqdsdneRyxkfx7AaFnfp9de++yDENJqn9IYBr1JuKpN9H
X-Google-Smtp-Source: AGHT+IGft1DvkMAO1kWM1kUCxMyoddKfZKvRD3xbOGm0Jf3Bj/9DDcNLrhNQNG6hJXFMXzx//UWwIg==
X-Received: by 2002:a05:600c:3b9d:b0:432:cbe5:4f09 with SMTP id 5b1f17b1804b1-432df7211a5mr37471815e9.4.1731715196605;
        Fri, 15 Nov 2024 15:59:56 -0800 (PST)
Received: from [192.168.42.251] ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dab721d7sm71012105e9.9.2024.11.15.15.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 15:59:56 -0800 (PST)
Message-ID: <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com>
Date: Sat, 16 Nov 2024 00:00:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
 kbusch@kernel.org, martin.petersen@oracle.com, anuj1072538@gmail.com,
 brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241114104517.51726-7-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 10:45, Anuj Gupta wrote:
> Add the ability to pass additional attributes along with read/write.
> Application can populate an array of 'struct io_uring_attr_vec' and pass
> its address using the SQE field:
> 	__u64	attr_vec_addr;
> 
> Along with number of attributes using:
> 	__u8	nr_attr_indirect;
> 
> Overall 16 attributes are allowed and currently one attribute
> 'ATTR_TYPE_PI' is supported.

Why only 16? It's possible that might need more, 256 would
be a safer choice and fits into u8. I don't think you even
need to commit to a number, it should be ok to add more as
long as it fits into the given types (u8 above). It can also
be u16 as well.

> With PI attribute, userspace can pass following information:
> - flags: integrity check flags IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
> - len: length of PI/metadata buffer
> - addr: address of metadata buffer
> - seed: seed value for reftag remapping
> - app_tag: application defined 16b value

In terms of flexibility I like it apart from small nits,
but the double indirection could be a bit inefficient,
this thing:

struct pi_attr pi = {};
attr_array = { &pi, ... };
sqe->attr_addr = attr_array;

So maybe we should just flatten it? An attempt to pseudo
code it to understand what it entails is below. Certainly
buggy and some handling is omitted, but should show the
idea.

// uapi/.../io_uring.h

struct sqe {
	...
	u64 attr_addr;
	/* the total size of the array pointed by attr_addr */
	u16 attr_size; /* max 64KB, more than enough */
}

struct io_attr_header {
	/* bit mask of attributes passed, can be helpful in the future
	 * for optimising processing.
	 */
	u64 attr_type_map;
};

/* each attribute should start with a preamble */
struct io_uring_attr_preamble {
	u16 attr_type;
};

// user space

struct PI_param {
	struct io_attr_header header;
	struct io_uring_attr_preamble preamble;
	struct io_uring_attr_pi pi;
};

struct PI_param p = {};
p.header.map = 1 << ATTR_TYPE_PI;
p.preamble.type = ATTR_TYPE_PI;
p.pi = {...};

sqe->attr_addr = &p;
sqe->attr_size = sizeof(p);


The holes b/w structures should be packed better. For the same
reason I don't like a separate preamble structure much, maybe it
should be embedded into the attribute structures, e.g.

struct io_uring_attr_pi {
	u16 attr_type;
	...
}

The user side looks ok to me, should be pretty straightforward
if the user can define a structure like PI_param, i.e. knows
at compilation time which attributes it wants to use.

// kernel space (current patch set, PI only)

addr = READ_ONCE(sqe->attr_addr);
if (addr) {
	size = READ_ONCE(sqe->attr_size);
	process_pi(addr, size);
}

process_pi(addr, size) {
	struct PI_param p;

	if (size != sizeof(PI_attr + struct attr_preamble + struct attr_header))
		return -EINVAL;
	copy_from_user(p, addr, sizeof(p));
	if (p.preamble != ATTR_TYPE_PI)
		return -EINVAL;
	do_pi_setup(&p->pi);
}

This one is pretty simple as well. A bit more troublesome if
extended with many attributes, but it'd need additional handling
regardless:

process_pi(addr, size) {
	if (size < sizeof(header + preamble))
		return -EINVAL;

	attr_array = malloc(size); // +caching by io_uring
	copy_from_user(attr_array);
	handle_attributes(attr_array, size);
}

handle_attributes(attr_array, size) {
	struct io_attr_header *hdr = attr_array;
	offset = sizeof(*hdr);

	while (1) {
		if (offset + sizeof(struct preamble) > size)
			break;

		struct preamble *pr = attr_array + offset;
		if (pr->type > MAX_TYPES)
			return -EINVAL;
		attr_size = attr_sizes[pr->type];
		if (offset + sizeof(preamble) + attr_size > size)
			return -EINVAL;
		offset += sizeof(preamble) + attr_size;

		process_attr(pr->type, (void *)(pr + 1));
	}
}

Some checks can probably be optimised by playing with the uapi
a bit.

attr_type_map is unused here, but I like the idea. I'd love
to see all actual attribute handling to move deeper into the
stack to those who actually need it, but that's for far
away undecided future. E.g.

io_uring_rw {
	p = malloc();
	copy_from_user(p, sqe->attr_addr);
	kiocb->attributes = p;
}

block_do_read {
	hdr = kiocb->attributes;
	type_mask = /* all types block layer recognises */
	if (hdr->attr_type_map & type_mask)
		use_attributes();
}

copy_from_user can be optimised, I mentioned before, we can
have a pre-mapped area into which the indirection can point.
The infra is already in there and even used for passing
waiting arguments.

process_pi(addr, size) {
	struct PI_param *p, __p;

	if (some_flags & USE_REGISTERED_REGION) {
		// Glorified p = ctx->ptr; with some checks
		p = io_uring_get_mem(addr, size);
	} else {
		copy_from_user(__p, addr, sizeof(__p));
		p = &__p;
	}
	...
}

In this case all reads would need to be READ_ONCE, but that
shouldn't be a problem. It might also optimise out the kmalloc
in the extended version.

-- 
Pavel Begunkov

