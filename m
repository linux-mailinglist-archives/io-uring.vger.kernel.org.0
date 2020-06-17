Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7C1FC296
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 02:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFQAGj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 20:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQAGi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 20:06:38 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44490C061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 17:06:37 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d66so235818pfd.6
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 17:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o5cL/wljkdzLZJg8BTtawQouizAIFcb4eBsKvx7sCz8=;
        b=dAqEJc2QMjY22Bg4C2udH+VO2RTEPWFBvTvD4LOa8EQ1JV6mD9D85dgW77aysOvLg1
         RPjvn+UTZj9OTWQ3IgE1u92khq5nMgI6PLb11l4CFDX6CIE8oVuwEOaZQQ7vlqabxCP3
         +qNUjWu3sYqIkyPDLTBAh/zhrI1zqrT4u8L4i8Bz1UtyzOz57I9xEI1MrsymJteWDIh5
         5M4pFxgsRRHo5Dq3/JY0OVFoOo+4RhRlb4xBzdOm67U3GlgPrqDQkjy+4sYdhkhP6RnJ
         /vzHZpkjYXzXiCgMXuW81XSoWVhLDCGzIvJ3WoVnltzJgOg2kDj8cZEIcJTyz9BhXeYJ
         jCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5cL/wljkdzLZJg8BTtawQouizAIFcb4eBsKvx7sCz8=;
        b=CXDNfOVNC7DIoJhshxVnTtRriniZg6RHEHwX5pvDmYUvk0EqtjjdTCtppSjkZOuLEz
         pULCOCuofL1Vqr199yZIzSiWeSM4IIEbuI3TjN+uTLO3WoiONakqEBThaoox8qgsDjHA
         Rz+bHRsOZTUt3UA9zprGKEpWCPV/UV44T+3PWhkhzsc4Cco+2VXQJc2Fe4qoVoAdUagt
         HxDmf66DQB73pGvyGBf3WauAz4VkgGa21pHqPnA5hBuBJiDS8xWfXp1xlXL9bu860bmL
         oMl++mPUiWkjCtm8ILMRqwaiIpeqbTkdv1ihUowJgCrKnvaj3hKnD4xp0cwwMBE4GV3B
         EbSA==
X-Gm-Message-State: AOAM53217vvd71IZzvs4kNXtkGDkUbyM6sNkXAssA5+zNUcOSEjjHBaj
        wdaMHNuQiHVrrHNEnB4JoOmbKA==
X-Google-Smtp-Source: ABdhPJxqFWAfCcXCzuLnyIlVrt/YcdnYdoEriD9x4CBtWzxrG7XVOqQC7HyQCp6ygoYQ3M1Vvf7sCQ==
X-Received: by 2002:aa7:96e9:: with SMTP id i9mr4422229pfq.232.1592352396673;
        Tue, 16 Jun 2020 17:06:36 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q16sm18290563pfg.49.2020.06.16.17.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 17:06:36 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
 <f6d3c7bb-1a10-10ed-9ab3-3d7b3b78b808@kernel.dk>
 <ec18b7b6-a931-409b-6113-334974442036@linux.alibaba.com>
 <b98ae1ed-c2b5-cfba-9a58-2fa64ffd067a@kernel.dk>
 <7a311161-839c-3927-951d-3ce2bc7aa5d4@linux.alibaba.com>
 <967819fd-84c5-9329-60b6-899a2708849e@kernel.dk>
 <659bda5d-2da0-b092-9a66-1c4c4d89501a@kernel.dk>
 <5fc59f0b-7437-ac2c-a142-8cd7a532960c@kernel.dk>
 <d0d05303-e31c-7113-9805-df5602ecd86d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <131ee21f-1a15-2f5b-42f8-2e8791491818@kernel.dk>
Date:   Tue, 16 Jun 2020 18:06:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d0d05303-e31c-7113-9805-df5602ecd86d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/20 3:46 PM, Pavel Begunkov wrote:
> On 16/06/2020 22:21, Jens Axboe wrote:
>>
>> Nah this won't work, as the BE layout will be different. So how about
>> this, just add a 16-bit poll_events_hi instead. App/liburing will set
>> upper bits there. Something like the below, then just needs the
>> exclusive wait change on top.
>>
>> Only downside I can see is that newer applications on older kernels will
>> set EPOLLEXCLUSIVE but the kernel will ignore it. That's not a huge
>> concern for this particular bit, but could be a concern if there are
>> others that prove useful.
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index de1175206807..a9d74330ad6b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4809,6 +4809,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>>  	events = READ_ONCE(sqe->poll_events);
>>  	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
>>  
>> +	if (READ_ONCE(sqe->poll_events_hi) & EPOLLEXCLUSIVE)
> 
> poll_events_hi is 16 bit, EPOLLEXCLUSIVE is (1 << 28). It's always false.
> Do you look for something like below?
> 
> 
> union {
> 	...
> 	__u32		fsync_flags;
> 	__u16		poll_events;  /* compatibility */
> 	__u32		poll32_events; /* word-reversed for BE */
> };
> 
> u32 evs = READ_ONCE(poll32_events);
> if (BIG_ENDIAN)
> 	evs = swahw32(evs); // swap 16-bit halves
> 
> // use as always, e.g. if (evs & EPOLLEXCLUSIVE) { ... }

Duh yes, that's much better. Thanks for the clue bat.

-- 
Jens Axboe

