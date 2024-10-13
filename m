Return-Path: <io-uring+bounces-3627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F353F99BA88
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 19:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DFCEB21481
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 17:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F381474A2;
	Sun, 13 Oct 2024 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="AaGI1Pv+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAB73D6A
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728840325; cv=none; b=tBqq+2KiEJlOYqgezcgLnA4Xcky4k8FykqEZ3SYboFLxcdfaWxuriSiiO3aeKSy4GgSXO0p/mMvquJReIfqMCtZ1rRHaoj3kyExGmBO1Beqi+RdpTRjXqQhjzzF7B/Fxn9N84dt/wsFc1SukeJLbeq3T6pNaXlCMcKNW7c4pduU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728840325; c=relaxed/simple;
	bh=0r6ubmKK3fTmaW9p5/f0rrKPVpMMmuQVR6OAALoZIEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qs49bxt8M4g9/qIWXeYRI6LSGavLTlVHeeBX7PpZowTnpCLh2y588mlvPy9jTTng6KDI3wK6JSYkrQ8b3Wz2sCBumZ3TZikeGsxIt5wexUunqvjqYeo4CeO0+WYgZVG7Qu7FSN/BggmO4Kell6Nm8LDtgxlSnNH/e+znUf6wCtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=AaGI1Pv+; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7ea12e0dc7aso2190388a12.3
        for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 10:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728840323; x=1729445123; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PiTx0ha6pjBtkUTB0+EsHxh7W7/HixrnetXsL0FLYCI=;
        b=AaGI1Pv+TJSF9B8Y6Z2nvwY0BKgeOpNB3WNxy0pW/0uuHJAAuMzPO3xyAlY/oK8+dN
         J1jdttpdf/OgFlIGT33KDxoQ41Xyowj5glcjoaS+x7tXiiOPkdYqZVSB3065fCpP1iD4
         i7l8uUqlGSgUpvzSDPTdrmmC5Rxq5S5ZPuNY/HfG1CFaZjzrCDWN6ESfV9HicbSwbKyj
         fI6cIWtrkHtPgK8bd19nGQ5Z7HO3CsdnrIx1Q7q2DmOpg6z489nrIoSP05vf/TXemD9s
         jpOoJt6T8VAP1o6eEJzHY1Zswp9D+U1OYdJXg7TrJvRTOEvnBNYK1QKrNa/Jv93rP6pk
         MfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728840323; x=1729445123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PiTx0ha6pjBtkUTB0+EsHxh7W7/HixrnetXsL0FLYCI=;
        b=iVbxZm1+IiU3oSz+fZCSEIMTFnpPU3PYSZhWr2NNIku5DOLzDf4+z2Goy3qZw5a8Tz
         niv0mI90HQtYkEB/wSYE6Vy3RcEo7vg2Lk0Ls8uJDTq560WRZ1o2UZZl/OSkN4cWU4FL
         8uauLhPAesL1LwghFmSHre1FehfOny6T18sxRfa0nfy+p6vrGjiuW9idpdvniw4XG7U7
         o921SLvRIVz5v5wRUOpVkg9pAtxyotly1OCFe9mPlY4VVFdQZkQvcZ85V0uMGx7x9CIv
         lw/Gow4eAC85a/izg9JejiJQlrhr60CtfDi4GbZH5U/JRyaaYf6qqC5HSjRPrMRqqFgj
         grmA==
X-Gm-Message-State: AOJu0YwihHel2VwrvD4TGnvVSE15sUV8EMO1zo2VU+uo58xM24qN2aih
	7LQtgM8mhiBYsvR3JJ+ZQbspQ7BJMvYSMVSJBVKAmtpeawUleUCKxFIIsS6Gcg0=
X-Google-Smtp-Source: AGHT+IEGlI8g2iMGz4qmfmF8QvVGmGKgZur5IagnbQDPTXE0fj9TljUIlg4BCVsEX9orjPo8VEvZrw==
X-Received: by 2002:a17:90b:3850:b0:2cf:c9ab:e747 with SMTP id 98e67ed59e1d1-2e3151b415fmr7876066a91.1.1728840323422;
        Sun, 13 Oct 2024 10:25:23 -0700 (PDT)
Received: from [192.168.1.24] (174-21-189-109.tukw.qwest.net. [174.21.189.109])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e3132badd2sm3603920a91.40.2024.10.13.10.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2024 10:25:22 -0700 (PDT)
Message-ID: <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
Date: Sun, 13 Oct 2024 10:25:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider
 callback
Content-Language: en-GB
To: Mina Almasry <almasrymina@google.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 David Wei <dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
 <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-10-10 10:54, Mina Almasry wrote:
> On Wed, Oct 9, 2024 at 2:58 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 10/9/24 22:00, Mina Almasry wrote:
>>> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>>>
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> page pool is now waiting for all ppiovs to return before destroying
>>>> itself, and for that to happen the memory provider might need to push
>>>> some buffers, flush caches and so on.
>>>>
>>>> todo: we'll try to get by without it before the final release
>>>>
>>>
>>> Is the intention to drop this todo and stick with this patch, or to
>>> move ahead with this patch?
>>
>> Heh, I overlooked this todo. The plan is to actually leave it
>> as is, it's by far the simplest way and doesn't really gets
>> into anyone's way as it's a slow path.
>>
>>> To be honest, I think I read in a follow up patch that you want to
>>> unref all the memory on page_pool_destory, which is not how the
>>> page_pool is used today. Tdoay page_pool_destroy does not reclaim
>>> memory. Changing that may be OK.
>>
>> It doesn't because it can't (not breaking anything), which is a
>> problem as the page pool might never get destroyed. io_uring
>> doesn't change that, a buffer can't be reclaimed while anything
>> in the kernel stack holds it. It's only when it's given to the
>> user we can force it back out of there.

The page pool will definitely be destroyed, the call to
netdev_rx_queue_restart() with mp_ops/mp_priv set to null and netdev
core will ensure that.

>>
>> And it has to happen one way or another, we can't trust the
>> user to put buffers back, it's just devmem does that by temporarily
>> attaching the lifetime of such buffers to a socket.
>>
> 
> (noob question) does io_uring not have a socket equivalent that you
> can tie the lifetime of the buffers to? I'm thinking there must be
> one, because in your patches IIRC you have the fill queues and the
> memory you bind from the userspace, there should be something that
> tells you that the userspace has exited/crashed and it's time to now
> destroy the fill queue and unbind the memory, right?
> 
> I'm thinking you may want to bind the lifetime of the buffers to that,
> instead of the lifetime of the pool. The pool will not be destroyed
> until the next driver/reset reconfiguration happens, right? That could
> be long long after the userspace has stopped using the memory.
> 

Yes, there are io_uring objects e.g. interface queue that hold
everything together. IIRC page pool destroy doesn't unref but it waits
for all pages that are handed out to skbs to be returned. So for us,
below might work:

1. Call netdev_rx_queue_restart() which allocates a new pp for the rx
   queue and tries to free the old pp
2. At this point we're guaranteed that any packets hitting this rx queue
   will not go to user pages from our memory provider
3. Assume userspace is gone (either crash or gracefully terminating),
   unref the uref for all pages, same as what scrub() is doing today
4. Any pages that are still in skb frags will get freed when the sockets
   etc are closed
5. Rely on the pp delay release to eventually terminate and clean up

Let me know what you think Pavel.

