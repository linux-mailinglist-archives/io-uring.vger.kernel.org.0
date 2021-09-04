Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A253400CAC
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 20:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbhIDSln (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Sep 2021 14:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhIDSlm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Sep 2021 14:41:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047A3C061575
        for <io-uring@vger.kernel.org>; Sat,  4 Sep 2021 11:40:41 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c17so2444751pgc.0
        for <io-uring@vger.kernel.org>; Sat, 04 Sep 2021 11:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hcTyJz5L3DveSxT8oQ6xS8+yiZaLRx2qQ56lGu9tjnE=;
        b=D7Dft69+wtxS5zuoPdWWWfHoJohUlCHqYC+dA1yhNiBEvYg49PN/cOWyePyoO1c+Sd
         yibSw29f+lTxEkPHeYOxcZB/wVS3yccu3z/TUVQC71jw0WFJeUYOPtc3ne3ZnMaT20l6
         +lf28rskZIdtWu+E2E7bpSiYCWcGUcAWBjAUGDgocYLl6Phhd0K+uMxOqPduXEpzXx/V
         roeXQwDUW8Aeb3mnV/3j+vANDQ1FG/mETFrOzOXYbuDesQsMJfsbe6+xJbZK5gi2ShmC
         puDkVvba4SmKGaCL2OPKj/bwgkFolpRettEqVHGVxmlxQnkqwjQsfqLtC6KxlAhpWMZp
         5NqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hcTyJz5L3DveSxT8oQ6xS8+yiZaLRx2qQ56lGu9tjnE=;
        b=NBfnv5iBpfOjhnTrNFQj9Fo1LwxO36dr+9gAWaKUZGtV5yaIbjJZoxYflcgKKtlhKo
         wRjY4AkHUTaHo0slxDN0trDKJNrhg8J+OvTz5HK54G190AxK0/KW6O9h5NcZZc9Z285d
         QkwhFgSH95W77tY+AQGgOkMb7jyX5fW2h+HCXrp5SNccf4Qj3TKV9UUxDioV33vktqii
         Gr8HLbNiWdGYK3KxU1fuPqBMdhUjvcqei4w6O800DT5eYLcarmYkehhZSWVdUNYSO/hk
         Wv2S5vfJ5IJkOzuyh5k6fKqpeSo+5dcW1mcxjqgfQLgyC5KQ4ZyMpC/Ofk+/bfJSIk/C
         yFww==
X-Gm-Message-State: AOAM530EgeKAYwObT8wOBV43FIHex/ke+ItmyCXF8dgS+Qdpp9/egGBU
        zxay9nfvEq5tIhGmB/ULoHo/1x+8WEZHyw==
X-Google-Smtp-Source: ABdhPJzBoCcFMUDgRjF6Q07iJ9EtOWwy7gdkWsSG7P5Nc25j9Mnf4MtXLRnpyfmR93FeZc8M4oyuwA==
X-Received: by 2002:a63:1262:: with SMTP id 34mr4592288pgs.356.1630780840250;
        Sat, 04 Sep 2021 11:40:40 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y5sm3471271pgs.27.2021.09.04.11.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 11:40:39 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
Date:   Sat, 4 Sep 2021 12:40:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/21 9:34 AM, Hao Xu wrote:
> 在 2021/9/4 上午12:29, Jens Axboe 写道:
>> On 9/3/21 5:00 AM, Hao Xu wrote:
>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index eb81d37dce78..34612646ae3c 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>   static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>   {
>>>   	struct io_accept *accept = &req->accept;
>>> +	bool is_multishot;
>>>   
>>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>   		return -EINVAL;
>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>   	accept->flags = READ_ONCE(sqe->accept_flags);
>>>   	accept->nofile = rlimit(RLIMIT_NOFILE);
>>>   
>>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>> +		return -EINVAL;
>>
>> I like the idea itself as I think it makes a lot of sense to just have
>> an accept sitting there and generating multiple CQEs, but I'm a bit
>> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
>> which can currently be:
>>
>> SOCK_NONBLOCK
>> SOCK_CLOEXEC
>>
>> While there's not any overlap here, that is mostly by chance I think. A
>> cleaner separation is needed here, what happens if some other accept4(2)
>> flag is enabled and it just happens to be the same as
>> IORING_ACCEPT_MULTISHOT?
> Make sense, how about a new IOSQE flag, I saw not many
> entries left there.

Not quite sure what the best approach would be... The mshot flag only
makes sense for a few request types, so a bit of a shame to have to
waste an IOSQE flag on it. Especially when the flags otherwise passed in
are so sparse, there's plenty of bits there.

Hence while it may not be the prettiest, perhaps using accept->flags is
ok and we just need some careful code to ensure that we never have any
overlap.

Probably best to solve that issue in include/linux/net.h, ala:

/* Flags for socket, socketpair, accept4 */
#define SOCK_CLOEXEC	O_CLOEXEC
#ifndef SOCK_NONBLOCK
#define SOCK_NONBLOCK	O_NONBLOCK
#endif

/*
 * Only used for io_uring accept4, and deliberately chosen to overlap
 * with the O_* file bits for read/write mode so we won't risk overlap
 * other flags added for socket/socketpair/accept4 use in the future.
 */
#define SOCK_URING_MULTISHOT	00000001

which should be OK, as these overlap with the O_* filespace and the
read/write bits are at the start of that space.

Should be done as a prep patch and sent out to netdev as well, so we can
get their sign-off on this "hack". If we can get that done, then we have
our flag and we can just stuff it in accept->flags as long as we clear
it before calling into accept from io_uring.

-- 
Jens Axboe

