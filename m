Return-Path: <io-uring+bounces-4340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 786339B9A49
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 22:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03DE41F22956
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59851E2843;
	Fri,  1 Nov 2024 21:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHXQyzTK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E689116F8EB;
	Fri,  1 Nov 2024 21:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730497099; cv=none; b=X9KaErUE3/MIr6OoWxfrT/5qoj8GvsVmpUI0Lpr+yLiarpKv5NGdATGvyKYK/RYXWaVDOQdHEXw+bAHGZliMw9wXivLIqXdwvVmcrBOT2bMSnODqvcs50IAwuKluew8E9qBiH6T9gKJizBgdCdlAcaHyJ5H8kigOUNVvo7I2/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730497099; c=relaxed/simple;
	bh=JlbNVIRKSzsLtBv7TV1TERH54pB6qu+x70KMBvJXHVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I+9mLHJTgI3iPa0m5MvEfsqRQiXHw0FeA4ezdL4Q8hxTriPSmlw4+DGD3FE4rixGTSJun/2dGJ//vh7hwUEjxkiBzEv0d9c2hgog4gSpqw6Q9yhil4XU6d87fZWWRkq+RmN5cmUBXCDr8ygmOy8ZSj86d1VlWUgZtJEBIkaR9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHXQyzTK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4316e9f4a40so18962825e9.2;
        Fri, 01 Nov 2024 14:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730497096; x=1731101896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2cD22XsOi7oq6v7jrSkqH7sh0ErRUZpI8mY2PFklx4U=;
        b=HHXQyzTKL8O4mC06nXm+fTfRJi3c4fuE91YLlmzxKNfe/Jy6LJLqRz6bvw3DSyaFQc
         yWEtBiOg2NwGeQeBlehLc2zJyJ+WIE5cZfLf9Rrk+vzge8p6kfr4U6xc5QOyg57DHe0W
         HmKNpCFX/2HzwA5ehtmzXaHol5mgBexHwNK7RLNgm2MYcr7Uj+93OwHz7pGvEF8RXdkk
         f8Kbqvluh34ADZ3qAdpGYsxeJsPR01AxHcJI6otMhDs01kuXDJxkuR2jLr8+2TFDPP78
         io6P3hOjCB5mvYczdo2WxWStbs+0/P4RoEqre4EyHiJVZUPwG3Jg5byycs+1DsiEm1il
         oQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730497096; x=1731101896;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cD22XsOi7oq6v7jrSkqH7sh0ErRUZpI8mY2PFklx4U=;
        b=a2l+HnTFGuTfQHuBUVPoW83k/yPuliJOjs8s3GmH6iKUCMpNkoQvdGI0VEK92uW/rC
         yoieetq23rFlhZYdU42yRS7oADkwKhy9TlA50M+yTVubjWVthNvCoMLsoS3yTKxppWjJ
         EGnsz+EUHtt4+B9RT4pT1y2UGWCPHx+wJqwZ460Zqq0gC++6W7LBVOWgwKOf5WmyIPlz
         NnENYS77M85XeBHXi8/w4NVFbuz3yf00ISaQbyDpe3vgTpF7Ffm282Od+EmIo9jtsCtT
         PCpRV5JPKfSPBGsiuZOIPkda80a5uYtqKvhACy5MY5Wo3QCJ3AYPmpUDorJgD4BarA9C
         fqMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK+wRl9MsfvZNpgONSRUeVU4EjOsk+ULyP8n4xEwVzvXrxGLBdC6xVa2YYIeEchEyF/VK81rh2HQ==@vger.kernel.org, AJvYcCVwJoobkojnEzj0QfN1S17452SzEj+aVf50w5v22gX0McXh2Toi/oXEijh+TnLsAOaQgbUE6mZp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8zF15K1MJep4h+MrYJZ4v3D+TnuHVC/ibscMqPF1a123mwrtz
	zqiI4bWYF6UvGsUJbNjYjJeILGYY+looqnlRVMTyIl+woPgmDmV9
X-Google-Smtp-Source: AGHT+IGgoaDGQlpiFvCMQVvPCCO1fqvf8TrEy5AJDg/+SRD8mvwSzwtlLCiI0JehdylsKZLSEeULoQ==
X-Received: by 2002:adf:f18c:0:b0:374:c621:3d67 with SMTP id ffacd0b85a97d-38061137930mr18291532f8f.24.1730497096040;
        Fri, 01 Nov 2024 14:38:16 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d6848b5sm73732215e9.32.2024.11.01.14.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:38:15 -0700 (PDT)
Message-ID: <2771e23a-2f4b-43c7-9d2a-3fa6aad26d53@gmail.com>
Date: Fri, 1 Nov 2024 21:38:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider
 callback
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
 <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
 <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
 <CAHS8izNt8pfBwGnRNWphN4vJJ=1yJX=++-RmGVHrVOvy59=13Q@mail.gmail.com>
 <6acf95a6-2ddc-4eee-a6e1-257ac8d41285@gmail.com>
 <CAHS8izNXOSGCAT6zvwTOpW7uomuA5L7EwuVD75gyeh2pmqyE2w@mail.gmail.com>
 <58046d4d-4dff-42c2-ae89-a69c2b43e295@gmail.com>
 <CAHS8izO6aBdHkN5QF8Z57qGwop3+XObd5T6P8VnMdyT=FUDO1A@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izO6aBdHkN5QF8Z57qGwop3+XObd5T6P8VnMdyT=FUDO1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/24 19:24, Mina Almasry wrote:
> On Fri, Nov 1, 2024 at 11:34 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>>> Huh, interesting. For devmem TCP we bind a region of memory to the
>>> queue once, and after that we can create N connections all reusing the
>>> same memory region. Is that not the case for io_uring? There are no
>>
>> Hmm, I think we already discussed the same question before. Yes, it
>> does indeed support arbitrary number of connections. For what I was
>> saying above, the devmem TCP analogy would be attaching buffers to the
>> netlink socket instead of a tcp socket (that new xarray you added) when
>> you give it to user space. Then, you can close the connection after a
>> receive and the buffer you've got would still be alive.
>>
> 
> Ah, I see. You're making a tradeoff here. You leave the buffers alive
> after each connection so the userspace can still use them if it wishes
> but they are of course unavailable for other connections.
> 
> But in our case (and I'm guessing yours) the process that will set up
> the io_uring memory provider/RSS/flow steering will be a different
> process from the one that sends/receive data, no? Because the former
> requires CAP_NET_ADMIN privileges while the latter will not. If they
> are 2 different processes, what happens when the latter process doing
> the send/receive crashes? Does the memory stay unavailable until the
> CAP_NET_ADMIN process exits? Wouldn't it be better to tie the lifetime
> of the buffers of the connection? Sure, the buffers will become

That's the tradeoff google is willing to do in the framework,
which is fine, but it's not without cost, e.g. you need to
store/erase into the xarray, and it's a design choice in other
aspects, like you can't release the page pool if the socket you
got a buffer from is still alive but the net_iov hasn't been
returned.

> unavailable after the connection is closed, but at least you don't
> 'leak' memory on send/receive process crashes.
> 
> Unless of course you're saying that only CAP_NET_ADMIN processes will

The user can pass io_uring instance itself

> run io_rcrx connections. Then they can do their own mp setup/RSS/flow
> steering and there is no concern when the process crashes because
> everything will be cleaned up. But that's a big limitation to put on
> the usage of the feature no?

-- 
Pavel Begunkov

