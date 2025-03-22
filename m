Return-Path: <io-uring+bounces-7199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E67A6CA28
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 13:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 451DB176E52
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 12:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89BF81F5831;
	Sat, 22 Mar 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NNFs3QyW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE93199FA8;
	Sat, 22 Mar 2025 12:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742646745; cv=none; b=K3kbFieTLVeHw6K93L4CG91CEuT2KUrCN5BpWttob0RMRia3s0r5c16AIGkPcJ2o9yZ9WNTG6lzx3akQNsYdi0JYcUr/anBZ6CewEtu3xp/ZlwlI+jyJQSUZel0MeTiDiluPG0S101+V2a/WdYBSH+UEoWbHvR1yBpP+w+K1yb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742646745; c=relaxed/simple;
	bh=pK7rxh+vGXwiECvtIO/iUyR/P1io+Iqb7WVxHoUthw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WFx1hE2hN8Sm212PxsLXJGhiupWepggzw6IPimM6ezuXAkZ7Ws++R93Z9TppBDn/Roi7rRFZgTyuaEDJ3e40kSBFavrrfAvgYwxcwLqgwfwH01++orj0pin/lPNBIjeASgW96oRsyFyTEnodrpaPOJKH/ykuMJGZe/QYDhj6TPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NNFs3QyW; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so4323018a12.3;
        Sat, 22 Mar 2025 05:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742646742; x=1743251542; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pW4CgvyO8E8d5aodvOYqRFyiScdqSUa2dn7Pkrdkp8Y=;
        b=NNFs3QyWAVzkcARkYgoV4W8yYOWuznNicxGyxm7RQTxd8z8qLvwxX+ez7J+/pfKlNi
         +PbR4/h1OW0uqkKN4+zibApTl9gIKkVpsqzGl6nkw/fW2k5W7xVcy2RJ6MzOVsyqAk8x
         fvGq/VUbG9FRcIfcw7zfjtIUDyhDYWl7jNsaW6MT1pAt8ppc9nqJeAdS5EuCscMDntxT
         vVKuX1l1cyJ+77YU17iF2OvlMGCvIH68QyAjot8iqqnfpKPxk9akfs5aYeWh3qhTYiR5
         pX1FcYcvak8V74Ll+PsbOhn2Tibsuj6okMuuiiQj5kC7HGRXGkbCz0JGr5XD8giPgoo8
         WceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742646742; x=1743251542;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pW4CgvyO8E8d5aodvOYqRFyiScdqSUa2dn7Pkrdkp8Y=;
        b=POgmU6B+BhQolDnsqV39Jpw8P85F6gnVrNQA3W5tfde4DSc2d7aNL9GHIJ5DF7zZio
         1HwhDrXP2Bo9ITrrMINFsyK8urbmGabd62xKvorgzs4+oTjHLgo6JR+ppinCsNwudYmE
         F3PK/m0SgL8CCj3/skHn5bjirNtow5xzPxkWtAT6IyyHVIuw/B4Ml41rhmK0yV5ydlK+
         cS0XugfyoqrLezMzmjitkjPqgUqEEiOxOVAYHtTuiQaQ4PHIHqBPAtieSuD/GxnWx5l9
         m8RYKIVhrGKBulahq54wAVv2CjvWBYwnzopWmEyFc7wdTrcyStORe2R3TRJBbV/0I7fK
         yYDw==
X-Forwarded-Encrypted: i=1; AJvYcCUBcH3zfjEOeh7iE8SIHzLS60S04hwz2sZ4yfd2+cnicTTf5WenPYtsxO/G56kSU405Xk+n4A3KlQ==@vger.kernel.org, AJvYcCX0PdahMUzB+u9MUcSmcFIDyDd9YWvBoS+xAhWZX86QLYuOUsNVyWm5Ae5/HMZr1xAcEhz+SEGeA8UbnbFZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzTFhCWMZQNfQQwibgdWAkRQSCXuGii/v3ruaTxYH7D9zvIMoFI
	Gf0yFjvfHaqY+eTvdlHQNsM0xnfnDhLe/Do37UwHPveU/zRvDDpL
X-Gm-Gg: ASbGncu+RhtmJULdUqnoMsyNDtXklE5gRbw4e8RocCNUOACyVl2rpTRcNO4k9+deqb7
	JVsIDBj9iHCwiFItMaPSjlArDIUt8go0m/W1LnZdiRC7WH5Qp5gX11olL+jJXBE7+jmTyGj9y8P
	gAAgLQYh4pciVLreDSYFBTyIBOgQ6CvHz8gPj3VZlUq/HfS/xdBrTcuG+7FmAyuDd/ap/A+10o9
	ZlkHlwR/ciiK6IjdCreWLmSRoBY+ebRGVmzjNDh+ck8LuLpyggDjuTA7FjP0mPZEzuU+T+nMaYN
	xA091+k8R4gJXOjmwWzRCS6U4tUpCWT8X9AJqOsNKwZDHLGKlo2+
X-Google-Smtp-Source: AGHT+IHJAD6ahRLJfliFILL9MhKgl55JdXEMg4d/m5h9z2bwL6EhEJ1WElQ80YTk2VaHYjmxB8orNg==
X-Received: by 2002:a05:6402:270d:b0:5e6:17fb:d3c6 with SMTP id 4fb4d7f45d1cf-5ebcd4f3827mr5389659a12.25.1742646741523;
        Sat, 22 Mar 2025 05:32:21 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ebcd0dfdcesm2999752a12.65.2025.03.22.05.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 05:32:19 -0700 (PDT)
Message-ID: <814281f1-3b8c-4cb8-943b-0edb818168dd@gmail.com>
Date: Sat, 22 Mar 2025 12:33:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Consistently look up fixed buffers before going async
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Xinyu Zhang <xizhang@purestorage.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org
References: <20250321184819.3847386-1-csander@purestorage.com>
 <5588f0fe-c7dc-457f-853a-8687bddd2d36@gmail.com>
 <CADUfDZo5qKymN515sFKma1Eua0bUxThM5yr_LeQHR=ahQuS_wg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZo5qKymN515sFKma1Eua0bUxThM5yr_LeQHR=ahQuS_wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/21/25 21:24, Caleb Sander Mateos wrote:
> On Fri, Mar 21, 2025 at 1:23 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 3/21/25 18:48, Caleb Sander Mateos wrote:
>>> To use ublk zero copy, an application submits a sequence of io_uring
>>> operations:
>>> (1) Register a ublk request's buffer into the fixed buffer table
>>> (2) Use the fixed buffer in some I/O operation
>>> (3) Unregister the buffer from the fixed buffer table
>>>
>>> The ordering of these operations is critical; if the fixed buffer lookup
>>> occurs before the register or after the unregister operation, the I/O
>>> will fail with EFAULT or even corrupt a different ublk request's buffer.
>>> It is possible to guarantee the correct order by linking the operations,
>>> but that adds overhead and doesn't allow multiple I/O operations to
>>> execute in parallel using the same ublk request's buffer. Ideally, the
>>> application could just submit the register, I/O, and unregister SQEs in
>>> the desired order without links and io_uring would ensure the ordering.
>>> This mostly works, leveraging the fact that each io_uring SQE is prepped
>>> and issued non-blocking in order (barring link, drain, and force-async
>>> flags). But it requires the fixed buffer lookup to occur during the
>>> initial non-blocking issue.
>>
>> In other words, leveraging internal details that is not a part
>> of the uapi, should never be relied upon by the user and is fragile.
>> Any drain request or IOSQE_ASYNC and it'll break, or for any reason
>> why it might be desirable to change the behaviour in the future.
>>
>> Sorry, but no, we absolutely can't have that, it'll be an absolute
>> nightmare to maintain as basically every request scheduling decision
>> now becomes a part of the uapi.
> 
> I thought we discussed this on the ublk zero copy patchset, but I
> can't seem to find the email. My recollection is that Jens thought it
> was reasonable for userspace to rely on the sequential prep + issue of
> each SQE as long as it's not setting any of these flags that affect
> their order. (Please correct me if that's not what you remember.)

Well, my opinions are my own. I think it's reasonable to assume that
for optimisation purposes IFF the user space can sanely handle
errors when the assumption fails.

In your case, the user space should expect that an unregistration
op can happen before a read/write had resolved the buffer (node), in
which case the rw request will find that the buffer slot is empty
and fail. And that should be handled in the user space, e.g.
by reissuing the rw request of failing.

> I don't have a strong opinion about whether or not io_uring should
> provide this guarantee, but I was under the impression this had
> already been decided. I was just trying to fix the few gaps in this

I don't think so, it's a major uapi change, and a huge burden
for many future core io_uring changes.

> guarantee, but I'm fine dropping the patches if Jens also feels
> userspace shouldn't rely on this io_uring behavior.
> 
>>
>> There is an api to order requests, if you want to order them you
>> either have to use that or do it in user space. In your particular
>> case you can try to opportunistically issue them without ordering
>> by making sure the reg buffer slot is not reused in the meantime
>> and handling request failures.
> 
> Yes, I am aware of the other options. Unfortunately, io_uring's linked
> operation interface isn't rich enough to express an arbitrary
> dependency graph. We have multiple I/O operations operating on the
> same ublk request's buffer, so we would either need to link the I/O
> operations (which would prevent them from executing in parallel), or
> use a separate register/unregister operation for every I/O operation
> (which has considerable overhead). We can also wait for the completion
> of the I/O operations before submitting the unregister operation, but
> that adds latency to the ublk request and requires another
> io_uring_enter syscall.
> 
> We are using separate registered buffer indices for each ublk request
> so at least this scenario doesn't lead to data corruption. And we can
> certainly handle the EFAULT when the operation goes asynchronous, but
> it would be preferable not to need to do that.

-- 
Pavel Begunkov


