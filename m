Return-Path: <io-uring+bounces-2735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC84394FAF2
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 03:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 215DF1C21115
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 01:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956564C81;
	Tue, 13 Aug 2024 01:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OE1XzPZO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84157F8;
	Tue, 13 Aug 2024 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723511192; cv=none; b=nkElPE5vrfvvw4h8Rep/LYIUG9EFiVA75HEDWcgkOofVTzWgWKh9BReCtgHNmLkZYRdw24gXi7X6X0EAiviFOdEAAYbY7c10c/amxmbwUClOJF2M/28ERpYpieDLb/pLiVAXplRVDITvzihTEVpVPT2hsAw9Wb9TUn5RHBZz7Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723511192; c=relaxed/simple;
	bh=5iv5miWVkRDsd0wtEW6gKvDpoRlfIQjjKzJJy89R9wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fQ8vSqu5ZyXH+h98stOMpodfj+Z3DAD2dUm/anGIycPB7lutUjVf4QIEnl5EAfJ2Cya8YmQpFAzm+mIRGB6soJuIafkGwF3oDrRMHYbJVEbOSCUBmSZ+AvPua6xBESbtmT2NsD71cXn3/Kl1KYVwXuSj+Zq4h/uf1wYuqQL6Wfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OE1XzPZO; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4280ee5f1e3so37805135e9.0;
        Mon, 12 Aug 2024 18:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723511189; x=1724115989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SQwGFQgNCLwZuGHlPhnW3Zcwnbys1JKt+ZT379aTVuw=;
        b=OE1XzPZOpk9X8uIu8qnZz37u6jM4Fjbx03TgRMAy7ii83llyh8OWXPpT4DVtd92ZeM
         LBdgd9nHRsDmkhCR/nNBXNYCJBLTum253cJFI0wzwyL3krIMLOVFDkx7UWQGUxiM07o/
         VxFIyJQ1u56r/q/9ZjTcVHlON0TyOiyeyrXhz+YgrZb4tJdoifOcN2/qF9giuRNBejbh
         cFVp392uk9uT36i4/QvEqrRNb+sTyTeKUih8UBfa6/99lxazCJGdBmw1IZ2S56kg72ZL
         zMPkmQuRRPHKlZ9cmbtfY4M6de7sWxzX3/oPoZsTmlN1+D4rxbX4ABNR46d9OK3NVKf6
         XK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723511189; x=1724115989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQwGFQgNCLwZuGHlPhnW3Zcwnbys1JKt+ZT379aTVuw=;
        b=JIxdwY0DI07fq19IMa2oRllXAN3WEYZ+uq/PauPrSqQwOoEIRwBPO8r2yJ9BkjMBiB
         4eQYntJDwOcyxGSAoPpvExRIm7GoXF9LZszrD0b7ryxVXgrRbnmq9pfLNz0PPHnjt4vC
         Yw5uW6vf8eLo+507dgrbwSpbm8V9hHJw+Rr6+b+34eQPrtTt1VxdRN8F/gIdgwIlHLdP
         jN2mo9+6Ykk3xFyalJSDooX124RYwSVnt45zuTAfUswiQ4cbL+HCpcuFiV0FigQACTjP
         W0itnky+oSS1Xip1AaLsllbhorNdP4HwaYrDCfnkM0PJYNV4upvAkfYIQhjwfyQE95+f
         VzSg==
X-Forwarded-Encrypted: i=1; AJvYcCWCQ1PR9iZM2wuswmbiDdqWSsUAH5SBTcd6w1oyHbzWP3633r3j0Ch9RZ9maRlofA9YL4kovsYAYeIRFaqHWw8LdOvbYsgH5LZtDLXMTgoSHvWS+h+vJG0GQoob53ydGka6hY5Qnw==
X-Gm-Message-State: AOJu0YyFEb3nBCBQv3hO3zRZUw/pYj69vuL6GhyrBhyQn+0hzqPYGRkI
	eYndkWkhOqfyPCnsA4QQ7eHQAcw7vKHtbwDoN4ZSgrTZOIKdrvRkyhEPful4
X-Google-Smtp-Source: AGHT+IEsbHzTRFUiQb7fTKYJd7LRcNdgUyb97jOThPxanIN2qNyUzvtkYwHkdFUfar5vTo2IQkA3CQ==
X-Received: by 2002:a05:600c:1e03:b0:426:60b8:d8ba with SMTP id 5b1f17b1804b1-429d4870874mr15687765e9.28.1723511188757;
        Mon, 12 Aug 2024 18:06:28 -0700 (PDT)
Received: from [192.168.42.116] ([85.255.232.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4290c72d4c9sm208885875e9.8.2024.08.12.18.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 18:06:28 -0700 (PDT)
Message-ID: <ad7c846c-f6fc-4fff-a406-7079dbb734dd@gmail.com>
Date: Tue, 13 Aug 2024 02:06:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
To: dsterba@suse.cz
Cc: Christoph Hellwig <hch@infradead.org>, Mark Harmstone
 <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240809173552.929988-1-maharmstone@fb.com>
 <Zrnxgu7vkVDgI6VU@infradead.org>
 <1f5f4194-8981-46d4-aa7d-819cbdf653b9@gmail.com>
 <20240812165816.GL25962@twin.jikos.cz>
 <8d8e24bf-95d2-418e-b305-42eec37341c7@gmail.com>
 <20240813004935.GM25962@twin.jikos.cz>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240813004935.GM25962@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 01:49, David Sterba wrote:
> On Mon, Aug 12, 2024 at 08:17:43PM +0100, Pavel Begunkov wrote:
>> On 8/12/24 17:58, David Sterba wrote:
>>> On Mon, Aug 12, 2024 at 05:10:15PM +0100, Pavel Begunkov wrote:
>>>> And the last point, I'm surprised there are two versions of
>>>> btrfs_ioctl_encoded_io_args. Maybe, it's a good moment to fix it if
>>>> we're creating a new interface.
>>>>
>>>> E.g. by adding a new structure defined right with u64 and such, use it
>>>> in io_uring, and cast to it in the ioctl code when it's x64 (with
>>>> a good set of BUILD_BUG_ON sprinkled) and convert structures otherwise?
>>>
>>> If you mean the 32bit version of the ioctl struct
>>> (btrfs_ioctl_encoded_io_args_32), I don't think we can fix it. It's been
>>
>> Right, I meant btrfs_ioctl_encoded_io_args_32. And to clarify, nothing
>> can be done for the ioctl(2) part, I only suggested to have a single
>> structure when it comes to io_uring.
>>
>>> there from the beginning and it's not a mistake. I don't remember the
>>> details why and only vaguely remember that I'd asked why we need it.
>>> Similar 64/32 struct is in the send ioctl but that was a mistake due to
>>> a pointer being passed in the structure and that needs to be handled due
>>> to different type width.
>>
>> Would be interesting to learn why, maybe Omar remembers? Only two
>> fields are not explicitly sized, both could've been just u64.
>> The structure iov points to (struct iovec) would've had a compat
>> flavour, but that doesn't require a separate
>> btrfs_ioctl_encoded_io_args.
> 
> Found it:
> 
> "why don't we avoid the send 32bit workaround"
> https://lore.kernel.org/linux-btrfs/20190828120650.GZ2752@twin.jikos.cz/
> 
> "because big-endian"
> https://lore.kernel.org/linux-btrfs/20190903171458.GA7452@vader/

union {
	void __user *buf;
	__u64 __buf_alignment;
};

Endianness is indeed a problem here, but I don't see the
purpose of aliasing it with a pointer instead of keeping
just u64, which is a common pattern.

struct btrfs_ioctl_encoded_io_args {
	__u64 buf;
	...
};

// user
void *buf = ...;
arg.buf = (__u64)(uintptr_t)buf;

// kernel
void __user *p = u64_to_user_ptr(arg.buf);

-- 
Pavel Begunkov

