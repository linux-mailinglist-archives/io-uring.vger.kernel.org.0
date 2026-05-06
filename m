Return-Path: <io-uring+bounces-13243-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Jv9LKkD+2mbVQMAu9opvQ
	(envelope-from <io-uring+bounces-13243-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 11:02:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F92B4D843D
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 11:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 61190301AA53
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 09:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89A83E122C;
	Wed,  6 May 2026 09:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGAPdKzL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FE73DD534
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778058151; cv=none; b=UBJ5oqBeJGupkU+U3gwbDXXK5rlMIoYOVseuJBvXcRE//G0HODcZeQwAaAGMqC50Nzpp8dkV9m8lw26SQtGuU33KGIigU63sEx4mLKToJULYgx378J3Roy3Pu45MnakW0VeNIlfAodCqgDPyj8phM104IDewC2+8Oj2vClC+Ayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778058151; c=relaxed/simple;
	bh=nLSZKCR0woXtN6W5cyzs5oEHO2Ts0XPwdeXwd60CnUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZV2aHYLiCjFT31FYB57wfuoyx/le5os2r0I/zRnGJtqAU2h+PqNaATH67KdZd0XQp7QdK4+aNAwK6RYPKThTmO77URSeLwuWH9WD6mhatfVw1DGLI8BkQr6WEv1zxzepVuBsLQ9dCUKhcZ77DWz7AwmMq5hBpqeihOcsU3ZWzek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KGAPdKzL; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso47202465e9.0
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 02:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778058143; x=1778662943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mmaZWXsqMxYY1SXzoardDG6u5dyIRaJ/iULJJHwbN+E=;
        b=KGAPdKzLk3vJJ86/+9JWb0pewVd+eSoidY3lk7EZPts94uHo4N/VRkoM9t57Na8hZU
         ohCDqtJlErkxUgfhc1xF31gaTTxEEV9aQTpYdnIYJw5UqkLIvfOYXMVeC0yFRnX/MHe4
         HmgeTl6uAbvaO7lSltkxovg9zHAEVQVtWdlJLq+MyigLOHJOPN3xooUX/QlPsg9aezCX
         fcFIH2ULFXdTlkzGp+Ry1SgKQ1i2euO26Gf6Maw6yBVWA69E1LILuSHMu5h7drw4GBsF
         YHnLv0r1kzhMzpzHNEVk53axTY4nfGL7MMB052P2FX+fuI9Xsu9HaT6ntUkADcXIzcaX
         fiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778058143; x=1778662943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mmaZWXsqMxYY1SXzoardDG6u5dyIRaJ/iULJJHwbN+E=;
        b=jivvQp6FJSxr8XynpA5gtT+xY8lsiNAyfCbiech7N8+NS2KEP79NUQGDwMmw5JhT5s
         FmuMPt8EAh8RYh9Jj1BazIsl8r+aJT8Zo1z0SRj1kOF/c/kUCFyy5TOR+elvehRXsvWZ
         aiO60bRzR7CYcxus6fHPLxD3hlv9HRbaHsgau69CPHXZla6IQUc8lxzDfT8tPAr49pG+
         bibGsMx+25jzZi3wjBTuug0V8ZyNsIt5FrwTqLE1UrbMuu3TQ256VdHY9cJOuUQLWB9S
         NV3mweIwEwIAU23Erqo883t0Y2zepTFup/gnzkdJRVso61+iCHCPH6Old86a791e/XUV
         AQJw==
X-Forwarded-Encrypted: i=1; AFNElJ9qpTMS7+3/Q/zOkHGO1qBP4b7v7UCObcAId5+D/ZtNZK3j6Ml5Q6oY1AcJwohD0V5x+8q5GKysPw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo4d9BKA1FL07rWe9uPYD3/Oe6Mo/W4lLVmlLx262zxzM3AP1u
	/uNnWAoEVtm8ZkO/0pHPe9F1gmn5dpETD2KwRvvd/uZ2wZ7vaylFk1JH
X-Gm-Gg: AeBDievxQvfTodNDiboQnvsgzFZraqtupKY41ZAhtQB4E2PBrRXg8OveGVz1j1o+EN9
	i18GahUPxuhCZoz1JCxk0GrGj5NLereZ7yDjS1czKX9K/2PGtJmSquiq7FGFf5Qk+o4R8Oot2to
	syA2J9XsAoKYsbOhWSQ+Pttl1ORcY9Zrtd3PPwFgV2/+CZXWtpK1dgIBJWfpmRKMKou8rTb99zf
	mm45M1at7PD+jK9kThugPY4xVBSWK3RCnitYs4ZEZFwZ1v5ZztU/mKoWPoSLYqk1+MbNXTK3NbI
	oG44VZYjZVK+LLnPlmabQZ9xy5msQZPUVfKAB4aWBAMjF2vrJxKc+mWWlMmtayHz35Gh/E6s4wh
	w4GX5htmHmhy7K1Cj/0snCHaDHR6VLUVaaVm9rve0qaK5izqQNI9MmYRIxgRGhKYnuc++Avzq2C
	uksnnFfq9ZG8oAIjxQ2PrPkUvGaSkQylvgsHE0eRfs8k8DxS73WpGS96e8sRaL2PFzmog2la4yk
	BhkbmofSuSyy5qREIY1qByzM33LOgzmYebWVrGGPg==
X-Received: by 2002:a05:600c:2e0c:b0:489:1c2d:211e with SMTP id 5b1f17b1804b1-48e51e0c833mr25734095e9.5.1778058142476;
        Wed, 06 May 2026 02:02:22 -0700 (PDT)
Received: from [10.109.92.22] ([86.33.71.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e52f5c1cfsm21365215e9.0.2026.05.06.02.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 02:02:21 -0700 (PDT)
Message-ID: <6873d617-c904-45f3-bad9-e1ae39cfecd2@gmail.com>
Date: Wed, 6 May 2026 10:02:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] Add dmabuf read/write via io_uring
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <afi7c-VUJWOLlC1m@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <afi7c-VUJWOLlC1m@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3F92B4D843D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13243-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

Hey Ming,

On 5/4/26 16:29, Ming Lei wrote:
> On Wed, Apr 29, 2026 at 04:25:46PM +0100, Pavel Begunkov wrote:
>> The patch set allows to register a dmabuf to an io_uring instance for
>> a specified file and use it with io_uring read / write requests. The
>> infrastructure is not tied to io_uring and there could be more users
>> in the future. A similar idea was attempted some years ago by Keith [1],
>> from where I borrowed a good number of changes, and later was brough up
>> by Tushar and Vishal from Intel.
>>
>> It's an opt-in feature for files, and they need to implement a new
>> file operation to use it. Only NVMe block devices are supported in this
>> series. The user API is built on top of io_uring's "registered buffers",
>> where a dmabuf is registered in a special way, but after it can be used
>> as any other "registered buffer" with IORING_OP_{READ,WRITE}_FIXED
>> requests. It's created via a new file operation and the resulted map is
>> then passed through the I/O stack in a new iterator type. There is some
>> additional infrastructure to bind it all, which also counts requests
>> using a dmabuf map and managing lifetimes, which is used to implement
>> map invalidation.
>>
>> It was tested for GPU <-> NVMe transfers. Also, as it maintains a
>> long-term dma mapping, it helps with the IOMMU cost. The numbers
>> below are for udmabuf reads previously run by Anuj for different
>> IOMMU modes:
> 
> Plain registered buffer is long-live too, which raises question: does this
> framework need to take it into account from beginning?

Not sure I follow, mind expanding on what should be accounted?
Are you suggesting that we might want to use normal registered
buffers in a similar way? I.e. giving the driver an ability to
pre-register them?

> BTW, inspired by this approach, I adds similar feature to ublk via UBLK_IO_F_SHMEM_ZC
> which can maintain long-term vfio dma mapping over registered user-place aligned buffer.

Interesting, just too a glance, and it looks like what David Wei
was thinking to add to fuse, but IIUC he gave up exactly because the
client will need to cooperate and that could be troublesome.

Should we try to push everything under the same interface instead of
keeping a ublk specific one? Again to the point that it requires
a cooperative client, but if it's something more generic, the user
might just try to use it as a general optimisation. In the same way
it'll be helpful to fuse, and as a bonus you wouldn't need tree look
ups (but mandates clients using registered buffers as a downside).

It'd need to shaped to somehow work better with host memory as I
assume you want to be able to map it into server in common case.
Switch case'ing if it's a udmabuf is not the greatest approach,
but maybe we can figure out something else.
  
-- 
Pavel Begunkov


