Return-Path: <io-uring+bounces-5064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2222A9DA6CB
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 12:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6798281836
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 11:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAAA1F6674;
	Wed, 27 Nov 2024 11:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNBxFTZH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187A41F6664;
	Wed, 27 Nov 2024 11:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732706600; cv=none; b=qyIzL5yLZ8EuIA6dJNUfvv5JnnsXvWMfge08s8cUUHbpdParKmLkpRKLjnCQsKaWWKuEvk9GU0yICGyhstffYgdqr2YNE3O+E+hL/WAHojY0ikasUQh+eDa52xGLMtBzyj7UFn9ojq/wy2qPwyHBtsPVrwHV/u9Thx7PnU9pFSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732706600; c=relaxed/simple;
	bh=jPYE7nUJ0PQxj0TL68kBGwrZJwMQjdjzfszDvmh33UA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4b8aDiURTydIf/fCd1M8Gd82aPpg78091vZg1YT1S/sqiBAgWFxeuXPTgpJBHlElTPj01yPOsdbbQdNeCKyPmGm83pliNLkReE+wb0fAl0k9cZ1hwuSmUytg88NNwoFl8wxrw8EQ+VJizLoz2/uDSCxOOTlvRipB0FMwc7/FmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNBxFTZH; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso1068462566b.1;
        Wed, 27 Nov 2024 03:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732706597; x=1733311397; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CehglWY5cUyKQpTdTFxSNmTAz6hCZtKrvb/Ae4vWfPc=;
        b=BNBxFTZHRkZxBfRsrWIJ9cKC4dPepDwljBsZMoCnC/zw8HQt6vRWT2K4oCAl9yHxHF
         EBvWo4BPgZeAaLk1r5nSof/WniACOXhk6AkY3z7fVpbo7mEtfRaVghKoAY9MBfzfvyXL
         5RYio4fVQz8e1FCupMskX1ZP1h3X254VB/vsFVHQD9QKridV6kLRAHf+2y+VcObdVFA9
         w2xJ3HNEgY9gREEACXk+odOYQtXBUSq7zgOwub3aqNPAutrY91wsFraPRNT0dfb9OhB4
         yJktSKZ6k5pR6BAvMf28lpQozJEIl3T1dSDwu1HsEb1cjkt2ziGpqIxFuDj/KVqSjo+0
         uQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732706597; x=1733311397;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CehglWY5cUyKQpTdTFxSNmTAz6hCZtKrvb/Ae4vWfPc=;
        b=nwyUnEL0q8v7AVovDKn8fwyyG5PosKhRZCN63VjE6b+/3uxZBjdRM6hS9620VSJWVL
         j5TCrXBy28O6TxmqLjuclcYih8rOawUhabd7ZEN4LAYcc04DAELgPGTqgIKUn/6C5gPA
         EmqPMoW8d/96Cz4JRVViTOevH14h1/vvuPL50GHkkENxbwSAL5slUIu0AX+w4cBaQykI
         C/k/hSu4tRO00CxsYLBN5fIxJO1yg4sl5HXeXZMg3P2A7xHInQ1fnGOgL+J9s3M82ElS
         7g1ZwfKeyBMIwlwnhJF0IZa/m9EyDUX+GA5+V3F3okHEhaQxyTNthiFMHbUCOw3thyIq
         5m7A==
X-Forwarded-Encrypted: i=1; AJvYcCUbTqGpPgImuTR1QVS1xzPjQGZlt/6xbPSRkVyuuP8ygsaTHzHYnzZVCgJqmQ04lZVE4l9JlKkkY2FWQifzFA==@vger.kernel.org, AJvYcCUt3yYZfzQgNC6ft9dx7ZPedssoX/YSK3q7hiawkHozztDFUkiHAkllZtOWSvk4/xNkmC+YKKV+vPwMlg==@vger.kernel.org, AJvYcCW+ZlibOMZVMUKQRrwW3ciW7OfvC2d7UdKOl5w2wOhmcaXpeKrKIA1HY5spis6l0rP/5UnPkM3nudzjDpI=@vger.kernel.org, AJvYcCXvudKq0MDdYKXIWd8Sc/11s/OoCjSxfZM9uSJJa3Gkkcp7M4Jp5K5yVZjaXG5Ik3UgI0wV7TwOzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLv5BPQ2dp8BJ8jLZaVuVFMBuKoJ/IhNAN4M+QAWgxAiFZjR4E
	F254AVM7v0yxI8DYFIAyqm4pu76ioZbLOmIWY/KEdXEb+jYkNpjx
X-Gm-Gg: ASbGncuDYF9896DyuCBg5rZfpi8/pJLDwDc1B1NL4EVWMQj9yuH6XR+pKA6PNo52+yu
	TU4I8JlSPRhN3i2mS041Xf3TPowEtBgyYfM8JWTXRus1aTmUSNedAKO94fS33/6YBkublrrfdAM
	7aLFOpMsICb5iqzKgzvl8FPpiByFf+VYK+/cFaYjz0sZUIIPR5/owcPlyFEwOOreE/Ae99s0ssM
	8ZxN0zbHDESiKBPw0eDjjWAAZqHEgjUW/9SnUB4RHWSHkFHoO7WstsToBPajQ==
X-Google-Smtp-Source: AGHT+IFsufWWnsFArYdPuvs9Ad81sVtZ17075H7eNLYpimFeYT75Kvd58Sonb/NBCuJN36c+6qQFJg==
X-Received: by 2002:a17:906:1da9:b0:aa5:274b:60e9 with SMTP id a640c23a62f3a-aa580f4df12mr158891366b.33.1732706597304;
        Wed, 27 Nov 2024 03:23:17 -0800 (PST)
Received: from [192.168.42.127] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5372002aasm536402466b.66.2024.11.27.03.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 03:23:16 -0800 (PST)
Message-ID: <6c870f8d-6293-4d4b-be2b-f0e221cd103f@gmail.com>
Date: Wed, 27 Nov 2024 11:24:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241125070633.8042-1-anuj20.g@samsung.com>
 <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com>
 <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
 <20241126135423.GB22537@green245>
 <a9d500a4-2609-4dd6-a687-713ae1472a88@gmail.com>
 <20241127094644.GC22537@green245>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127094644.GC22537@green245>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 09:46, Anuj Gupta wrote:
> On Tue, Nov 26, 2024 at 03:45:09PM +0000, Pavel Begunkov wrote:
>> On 11/26/24 13:54, Anuj Gupta wrote:
>>> On Tue, Nov 26, 2024 at 01:01:03PM +0000, Pavel Begunkov wrote:
>>>> On 11/25/24 07:06, Anuj Gupta wrote:
>>
>> Hmm, I have doubts it's going to work well because the union
>> members have different sizes. Adding a new type could grow
>> struct io_uring_attr, which is already bad for uapi. And it
>> can't be stacked:
>>
> 
> How about something like this [1]. I have removed the io_uring_attr
> structure, and with the mask scheme the user would pass attributes in
> order of their types. Do you still see some cracks?

Looks good to me

> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
...
> +static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
> +			 u64 attr_ptr, u64 attr_type_mask)
> +{
> +	struct io_uring_attr_pi pi_attr;
> +	struct io_async_rw *io;
> +	int ret;
> +
> +	if (copy_from_user(&pi_attr, u64_to_user_ptr(attr_ptr),
> +	    sizeof(pi_attr)))
> +		return -EFAULT;
> +
> +	if (pi_attr.rsvd)
> +		return -EINVAL;
> +
> +	io = req->async_data;
> +	io->meta.flags = pi_attr.flags;
> +	io->meta.app_tag = pi_attr.app_tag;
> +	io->meta.seed = READ_ONCE(pi_attr.seed);

Seems an unnecessary READ_ONCE slipped here

> +	ret = import_ubuf(ddir, u64_to_user_ptr(pi_attr.addr),
> +			  pi_attr.len, &io->meta.iter);
> +	if (unlikely(ret < 0))
> +		return ret;
> +	rw->kiocb.ki_flags |= IOCB_HAS_METADATA;
> +	io_meta_save_state(io);
> +	return ret;
> +}
...

-- 
Pavel Begunkov

