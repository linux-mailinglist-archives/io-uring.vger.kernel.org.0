Return-Path: <io-uring+bounces-4443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A95049BC007
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 22:27:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34DCA1F22547
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 21:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69AA51F7553;
	Mon,  4 Nov 2024 21:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBQzBmH2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E4C19BBA;
	Mon,  4 Nov 2024 21:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730755652; cv=none; b=rSRmHLhwyTnU4U/qdx9m67xlfeqZJQnba6nn0u1w/JZ6rZi5zz6nXQ+SC38ptcBehtacImpDNGboQ+3/LEbg5N6txyNXx0u4U22SXSA7dIJ1w8deK2101b4mY38we6gsiDXvh6CKGgkWbE6wGEaS/eSMi8dMZdHNwJ+sIgG0KCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730755652; c=relaxed/simple;
	bh=CssUUmt7kYvujk7m2ME9ffLzr6JOp2MGXnKwUAJ1Rqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mSvltS+oMdhRfmLle1+U5nmWoEvMlJFHJSAhgrU/hUWIziKXv2eI5JoQjZeZNy0kVmGpRCfWzGtRva1HDdc0r4JsRdEAzcmXh3mY/hME9gdq3OKHGBmZO2L01SBiYEqxz77zzOkN5Zx8KvBumuflYJ1SMoyl1pHjKFO+9/YpJ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBQzBmH2; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9a0f198d38so799974466b.1;
        Mon, 04 Nov 2024 13:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730755649; x=1731360449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNQYgmKSO8uZ7d58ovGGv37TlDMxUyuw3zjkggRIGJE=;
        b=fBQzBmH2omUrAxB3E2t7yqRVW2fXMfgMHn2phSRpKiJmS0O9Xw+YSFnKOqDxXh/TiQ
         E5xtLByKXeATsMV3kUyWs8HZWhr0u4wTweALnahmlQ5POVNfWwyYXloQUbTX3EvKA+i5
         N1/+8qEN0lDJYh7YNh1k0Y7PT37VDusWMxOgX0psyQfwQWo900nw9DBx+q1WGkLIJSOD
         /UgqaDCr9+618pQqczLXrCPTUhmusHNbMiBm1SMuTfYx8DgljhYfJSNiPEntwqN6tUZf
         QuKVnim3BSRbxzOt1uekH3wd03R0aOING7edyT02fRA/8f7q19ogzpIjNzdf5ItkFOsE
         zRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730755649; x=1731360449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNQYgmKSO8uZ7d58ovGGv37TlDMxUyuw3zjkggRIGJE=;
        b=ENSIiBZjVMH3arM+DoMaahmxC0g20H0a+PK0SuLQd/xXG1M/y6av9PoxCQvx4M/Gsd
         t/+OYOWkeNTSev/p1kxdIgFZqCxhQezIBe4ERpnQgTM8xhnC+dv6CRdBNSiJVl5iAUsg
         A7hxoKUTaiYRK6+A84sFTOqyd+etNfQp4/i5EFSrMzH7hCsHxDv1MtvEA454vFI1oPnv
         D7QsF0LvwYdmXCturv/XpTyHoa5Jq/WlZ9C8bbf6FdcQztyfV20IyDhAbIx2qQ1w5b6T
         8dwKb9ADWiPXYCNFPIfsqPerKAtgPTkqHLsDqXausjlSnJQSD7bYc6CZCvjmJygZyGOG
         yLnA==
X-Forwarded-Encrypted: i=1; AJvYcCU9hjQj+RTHSuC35fKUXFtw3MN7QeZ4D+azv5rYn4sHa3waTarYRGTLzoB4yosdsQ9DTTSoCYer@vger.kernel.org, AJvYcCVHGw5d0iTQvPi0rudSnh/9Khn+kpph6xw0CCzMUxbo5N7l4b/CJbk4uH7RYMurDYCsJqbxSwdKjg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm6VfZiVr33HfXI0OHbaAw9bDoil81MMwL9J0cgw7MpXFgzf7e
	+FdlvzuT82whQYZyjr1Tu04bJLDwqev4g/Kbmu9Rd2fjUBdUn1RyD8xq2Q==
X-Google-Smtp-Source: AGHT+IHtoreAFpwSLbMbyf/HL9HUhqaa7rHs4WW3N+AzsA18XIK03tUJixFmkmEfQu2U6K89YftbeQ==
X-Received: by 2002:a17:906:c115:b0:a99:7bc0:bca7 with SMTP id a640c23a62f3a-a9e654953bfmr1177756466b.10.1730755648515;
        Mon, 04 Nov 2024 13:27:28 -0800 (PST)
Received: from [192.168.42.103] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16aecbasm33139766b.32.2024.11.04.13.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 13:27:27 -0800 (PST)
Message-ID: <4d88742a-9e83-464f-9058-85f6777ae13b@gmail.com>
Date: Mon, 4 Nov 2024 21:27:32 +0000
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
 <2771e23a-2f4b-43c7-9d2a-3fa6aad26d53@gmail.com>
 <CAHS8izNvrUx1cEFFAEdY-AsrVh3ttX6WtAc9NHEXfyw3bKBnDg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izNvrUx1cEFFAEdY-AsrVh3ttX6WtAc9NHEXfyw3bKBnDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/4/24 20:42, Mina Almasry wrote:
> On Fri, Nov 1, 2024 at 2:38 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 11/1/24 19:24, Mina Almasry wrote:
>>> On Fri, Nov 1, 2024 at 11:34 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> ...
>>>>> Huh, interesting. For devmem TCP we bind a region of memory to the
>>>>> queue once, and after that we can create N connections all reusing the
>>>>> same memory region. Is that not the case for io_uring? There are no
>>>>
>>>> Hmm, I think we already discussed the same question before. Yes, it
>>>> does indeed support arbitrary number of connections. For what I was
>>>> saying above, the devmem TCP analogy would be attaching buffers to the
>>>> netlink socket instead of a tcp socket (that new xarray you added) when
>>>> you give it to user space. Then, you can close the connection after a
>>>> receive and the buffer you've got would still be alive.
>>>>
>>>
>>> Ah, I see. You're making a tradeoff here. You leave the buffers alive
>>> after each connection so the userspace can still use them if it wishes
>>> but they are of course unavailable for other connections.
>>>
>>> But in our case (and I'm guessing yours) the process that will set up
>>> the io_uring memory provider/RSS/flow steering will be a different
>>> process from the one that sends/receive data, no? Because the former
>>> requires CAP_NET_ADMIN privileges while the latter will not. If they
>>> are 2 different processes, what happens when the latter process doing
>>> the send/receive crashes? Does the memory stay unavailable until the
>>> CAP_NET_ADMIN process exits? Wouldn't it be better to tie the lifetime
>>> of the buffers of the connection? Sure, the buffers will become
>>
>> That's the tradeoff google is willing to do in the framework,
>> which is fine, but it's not without cost, e.g. you need to
>> store/erase into the xarray, and it's a design choice in other
>> aspects, like you can't release the page pool if the socket you
>> got a buffer from is still alive but the net_iov hasn't been
>> returned.
>>
>>> unavailable after the connection is closed, but at least you don't
>>> 'leak' memory on send/receive process crashes.
>>>
>>> Unless of course you're saying that only CAP_NET_ADMIN processes will
>>
>> The user can pass io_uring instance itself
>>
> 
> Thanks, but sorry, my point still stands. If the CAP_NET_ADMIN passes
> the io_uring instance to the process doing the send/receive, then the
> latter process crashes, do the io_uring netmems leak until the
> page_pool is destroyed? Or are they cleaned up because the io_uring
> instance is destroyed with the process crashing, and the io_uring will
> destroy the page_pool on exit?

It'll be killed when io_uring dies / closed.

-- 
Pavel Begunkov

