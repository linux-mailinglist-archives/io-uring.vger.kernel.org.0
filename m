Return-Path: <io-uring+bounces-3736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A98979A10D9
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 19:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DB251F23768
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 17:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C08321264C;
	Wed, 16 Oct 2024 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XK0gq7SX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB00210C25;
	Wed, 16 Oct 2024 17:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729100531; cv=none; b=YxE41pYqARct42wbYJAQ+CwUeoW1jQmamw9C5zZnZ6rmFpMugxSivGBpzB3URij4QyxnsQBWkhfzHg9Np4wN13hGKhJe2M4cr7NB36iZx7MwkSzch3k7UpkSKk3U1vw6uTQRV8RES7tIeTUo9oTg/rYSRyCaOhEmryIsVLjuPQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729100531; c=relaxed/simple;
	bh=phM+pVu9SLwFbp1Wp9C9TeErlYuU8kxWqlkQofn+yN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qj/I7VrK8r54IHJb1S/EBt7MHu+mU8TeFo0HH0pHKTF41bz8Vwy6rl8TMlOvwkYIxt3cQGxtTq5oHfNhlYZQVYzi5XE+gcm+ZrOtHp4fhaGoGbTdc6UoA57kEBv2VerDzzy4bm0Izm79c9JfIZJC9gE19xgSXfJJFQrqYlP6/fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XK0gq7SX; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-431481433bdso773895e9.3;
        Wed, 16 Oct 2024 10:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729100528; x=1729705328; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BVaNb08D6w8n/sMSLsw+CF00yri1+/JCunW6ITSwOQk=;
        b=XK0gq7SXMJ+l9ZiLkOT/lJHNP/U7jeOpm5w3/hAjVujqKdrBIg5cjAlVFuFFid/xIq
         aHEVoEBqoGojLacgnmo7SYOBEnO+0Guhnx43c4CNL3v68h2p6QhrgKbSwsj7THmWL+z4
         CLWrQovCG/d6HV3rXi2C3AFlvdysFBrSTH9F3crriMSPVRc57UXIBlP9PJwGE7Iws/GR
         tNkMx6FKclCarmHCe3zDNsBsep6Tx/4lbAePqhS47mb60s5TaCN6XLCghI4r5ZJljAOE
         PWBcP+c0tDTTlItaGerTe3hrhLaq8QNsWTgs3jipGEybd/odJZt9FnXey3Pf/hNnOY1D
         1c2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729100528; x=1729705328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BVaNb08D6w8n/sMSLsw+CF00yri1+/JCunW6ITSwOQk=;
        b=fe0yj3vAE5KovCKvzdGghkZ/YIPCXB2BE9uKc2SHuRFv+dLP36tPaoV6bQbERuXdYy
         FIkcqCkk72pPs+aR9RxoOjID24860M8dJ4QaRK3ptosvXPg85kska2z/bv4TKMGwTZqb
         U/0CKV04d5yoeAW7R5sMqEvzHc7TAttt7C4eJD3TyvwC2sbsjj9+GduO8XgUrsLppwBz
         oLgSakeYPLXWBprd7jJvBvZ4/PsOqt8He3h3r+byW065UYHDO1OwucXX7LFy6am3fLvI
         a/uTI22pxwxHJR11ZfA6TBi8rqLt/0P1fZnaijFdhhhwE6clehSY6G3ytmi3csuyc37W
         STjg==
X-Forwarded-Encrypted: i=1; AJvYcCVPLI3GQiLJRar6a6+xj2X5mvysysoXGihbXFbzgExBdEuKIMP1uZsDdlAvJemy2JAsklg7Jcg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj5L6/l0Wwcrs0+csxLpff50HcQ6Gwm5Mttt0jicwV0rnN/ACM
	TtbrQaIqokTBbMMBvNJwqmfBygWkOsqMZAUXXzkFSH/mOUs9OLnDAPMF0w==
X-Google-Smtp-Source: AGHT+IHRgVy3T2e09nhdfxS4rgs0rd+2vv48EvMwJqdMOfgY1mni2ORZMwsCtz+W1ziPntTGsKxZlA==
X-Received: by 2002:a05:600c:1f8c:b0:42c:b220:4778 with SMTP id 5b1f17b1804b1-4311df5c639mr173161175e9.33.1729100527775;
        Wed, 16 Oct 2024 10:42:07 -0700 (PDT)
Received: from [192.168.42.41] ([85.255.234.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43158c61ae2sm534605e9.46.2024.10.16.10.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 10:42:07 -0700 (PDT)
Message-ID: <6acf95a6-2ddc-4eee-a6e1-257ac8d41285@gmail.com>
Date: Wed, 16 Oct 2024 18:42:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider
 callback
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
 <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
 <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
 <CAHS8izNt8pfBwGnRNWphN4vJJ=1yJX=++-RmGVHrVOvy59=13Q@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izNt8pfBwGnRNWphN4vJJ=1yJX=++-RmGVHrVOvy59=13Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/14/24 23:58, Mina Almasry wrote:
> On Sun, Oct 13, 2024 at 8:25 PM David Wei <dw@davidwei.uk> wrote:
>>
>> On 2024-10-10 10:54, Mina Almasry wrote:
>>> On Wed, Oct 9, 2024 at 2:58 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 10/9/24 22:00, Mina Almasry wrote:
>>>>> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>>>>>
>>>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>
>>>>>> page pool is now waiting for all ppiovs to return before destroying
>>>>>> itself, and for that to happen the memory provider might need to push
>>>>>> some buffers, flush caches and so on.
>>>>>>
>>>>>> todo: we'll try to get by without it before the final release
>>>>>>
>>>>>
>>>>> Is the intention to drop this todo and stick with this patch, or to
>>>>> move ahead with this patch?
>>>>
>>>> Heh, I overlooked this todo. The plan is to actually leave it
>>>> as is, it's by far the simplest way and doesn't really gets
>>>> into anyone's way as it's a slow path.
>>>>
>>>>> To be honest, I think I read in a follow up patch that you want to
>>>>> unref all the memory on page_pool_destory, which is not how the
>>>>> page_pool is used today. Tdoay page_pool_destroy does not reclaim
>>>>> memory. Changing that may be OK.
>>>>
>>>> It doesn't because it can't (not breaking anything), which is a
>>>> problem as the page pool might never get destroyed. io_uring
>>>> doesn't change that, a buffer can't be reclaimed while anything
>>>> in the kernel stack holds it. It's only when it's given to the
>>>> user we can force it back out of there.
>>
>> The page pool will definitely be destroyed, the call to
>> netdev_rx_queue_restart() with mp_ops/mp_priv set to null and netdev
>> core will ensure that.
>>
>>>>
>>>> And it has to happen one way or another, we can't trust the
>>>> user to put buffers back, it's just devmem does that by temporarily
>>>> attaching the lifetime of such buffers to a socket.
>>>>
>>>
>>> (noob question) does io_uring not have a socket equivalent that you
>>> can tie the lifetime of the buffers to? I'm thinking there must be

You can say it is bound to io_uring / io_uring's object
representing the queue.

>>> one, because in your patches IIRC you have the fill queues and the
>>> memory you bind from the userspace, there should be something that
>>> tells you that the userspace has exited/crashed and it's time to now
>>> destroy the fill queue and unbind the memory, right?
>>>
>>> I'm thinking you may want to bind the lifetime of the buffers to that,
>>> instead of the lifetime of the pool. The pool will not be destroyed
>>> until the next driver/reset reconfiguration happens, right? That could
>>> be long long after the userspace has stopped using the memory.

io_uring will reset the queue if it dies / requested to release
the queue.

>> Yes, there are io_uring objects e.g. interface queue that hold
>> everything together. IIRC page pool destroy doesn't unref but it waits
>> for all pages that are handed out to skbs to be returned. So for us,
>> below might work:
>>
>> 1. Call netdev_rx_queue_restart() which allocates a new pp for the rx
>>     queue and tries to free the old pp
>> 2. At this point we're guaranteed that any packets hitting this rx queue
>>     will not go to user pages from our memory provider

It's reasonable to assume that the driver will start destroying
the page pool, but I wouldn't rely on it when it comes to the
kernel state correctness, i.e. not crashing the kernel. It's a bit
fragile, drivers always tend to do all kinds of interesting stuff,
I'd rather deal with a loud io_uring / page pool leak in case of
some weirdness. And that means we can't really guarantee the above
and need to care about not racing with allocations.

>> 3. Assume userspace is gone (either crash or gracefully terminating),
>>     unref the uref for all pages, same as what scrub() is doing today
>> 4. Any pages that are still in skb frags will get freed when the sockets
>>     etc are closed

And we need to prevent from requests receiving netmem that are
already pushed to sockets.

>> 5. Rely on the pp delay release to eventually terminate and clean up
>>
>> Let me know what you think Pavel.

I think it's reasonable to leave it as is for now, I don't believe
anyone cares much about a simple slow path memory provider-only
callback. And we can always kill it later on if we find a good way
to synchronise pieces, which will be more apparent when we add some
more registration dynamism on top, when/if this patchset is merged.

In short, let's resend the series with the callback, see if
maintainers have a strong opinion, and otherwise I'd say it
should be fine as is.

> Something roughly along those lines sounds more reasonable to me.
> 
> The critical point is as I said above, if you free the memory only
> when the pp is destroyed, then the memory lives from 1 io_uring ZC
> instance to the next. The next instance will see a reduced address
> space because the previously destroyed io_uring ZC connection did not
> free the memory. You could have users in production opening thousands
> of io_uring ZC connections between rxq resets, and not cleaning up
> those connections. In that case I think eventually they'll run out of
> memory as the memory leaks until it's cleaned up with a pp destroy
> (driver reset?).

Not sure what giving memory from one io_uring zc instance to
another means. And it's perfectly valid to receive a buffer, close
the socket and only after use the data, it logically belongs to
the user, not the socket. It's only bound to io_uring zcrx/queue
object for clean up purposes if io_uring goes down, it's different
from devmem TCP.

-- 
Pavel Begunkov

