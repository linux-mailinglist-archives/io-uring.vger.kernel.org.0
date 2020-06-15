Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9298A1F9B99
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 17:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgFOPJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 11:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFOPJy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 11:09:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C23AC061A0E
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:09:54 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so7731113pgn.5
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M1kUTWQbHBmCkqQl0hhSuFs7eW34YyGydgC8727bD9w=;
        b=W6MKkAblttPUpkt0hClVwDeYOKLCwSQoPqMpG7UithlMY3iEW+iMHFFYTb3sAODBFz
         G07RYv2NTFuErjzoKjseusBXgWmAAdRc+o7QcJWhQO0e2W2OlkS2in3biQdfLMK11Ksj
         tcQsgW4YaxS2UWvN4Yj0PB+W7kTjCPwmsbg+rq0RalIUFw8C05undA+NTj0OFH3GA5Kj
         6ZNeQoDeFKSmrsWosp55NgrPUTu+KWVksK2nISRGHvY8jRCCLdbbshDWCJmJTOn0vOq0
         OFpalpzW2oxfroxI+weybr5fpNW68gTiHveFzayfBa1rNWwpGBaL9T5PY9sUlWE9ZofX
         EwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M1kUTWQbHBmCkqQl0hhSuFs7eW34YyGydgC8727bD9w=;
        b=c44lEkujJ15VCxV5AMH09DGTqgYObtM7tESwWRAMIckpwKjzJsaG0Gxl0lohR4m8ZP
         4pTXQv4nnu6SIV1m0nsUVHeg9MyTxXKgTop2YcoPXgFVk77nBJRy9nlLbKy0xxzMlAiF
         7TRaNyWcTkkFWhY6zz1XK9T9FipYQvVLXIfJVbOd1Wz7X97JrFG7QdlZ4UVboYSTdXmE
         WCzB8rGcM08i07FNA3fcWpMY89ThRJyQiEs4e5tDLSGBvCUDI9TuGQ/xaLT27tWMxVQs
         X01F/Bw/UbInyNZ/XJaAV7m3Q109xPz+WnRxXiEdVn0JO4jQHOdEzzbtRo/i+UocEc+J
         lkgQ==
X-Gm-Message-State: AOAM532mU1tQmsWsxEhneKmEim3wj8oyku/4Zf4dTzNR3kkfeYewH4QX
        7CevSO4BS3ChxvcgRxTu+YXjFf9mZZkIAw==
X-Google-Smtp-Source: ABdhPJzP1XXs+9NS4pcOhx8jBpAfd5UStruOIJDcSDaERnFgHWCmB+sR1u8VZq6XI/cuiI7DZ3ofoA==
X-Received: by 2002:a62:6d85:: with SMTP id i127mr23380966pfc.270.1592233793593;
        Mon, 15 Jun 2020 08:09:53 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o18sm15763867pfu.138.2020.06.15.08.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 08:09:53 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
 <f6d3c7bb-1a10-10ed-9ab3-3d7b3b78b808@kernel.dk>
 <ec18b7b6-a931-409b-6113-334974442036@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b98ae1ed-c2b5-cfba-9a58-2fa64ffd067a@kernel.dk>
Date:   Mon, 15 Jun 2020 09:09:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ec18b7b6-a931-409b-6113-334974442036@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/20 8:49 PM, Jiufei Xue wrote:
> Hi Jens,
> 
> On 2020/6/13 上午12:48, Jens Axboe wrote:
>> On 6/12/20 8:58 AM, Jens Axboe wrote:
>>> On 6/11/20 8:30 PM, Jiufei Xue wrote:
>>>> poll events should be 32-bits to cover EPOLLEXCLUSIVE.
>>>>
>>>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>>>> ---
>>>>  fs/io_uring.c                 | 4 ++--
>>>>  include/uapi/linux/io_uring.h | 2 +-
>>>>  tools/io_uring/liburing.h     | 2 +-
>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 47790a2..6250227 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -4602,7 +4602,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>>>>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>  {
>>>>  	struct io_poll_iocb *poll = &req->poll;
>>>> -	u16 events;
>>>> +	u32 events;
>>>>  
>>>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>  		return -EINVAL;
>>>> @@ -8196,7 +8196,7 @@ static int __init io_uring_init(void)
>>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
>>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
>>>> -	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
>>>> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll_events);
>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 92c2269..afc7edd 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -31,7 +31,7 @@ struct io_uring_sqe {
>>>>  	union {
>>>>  		__kernel_rwf_t	rw_flags;
>>>>  		__u32		fsync_flags;
>>>> -		__u16		poll_events;
>>>> +		__u32		poll_events;
>>>>  		__u32		sync_range_flags;
>>>>  		__u32		msg_flags;
>>>>  		__u32		timeout_flags;
>>>
>>> We obviously have the space in there as most other flag members are 32-bits, but
>>> I'd want to double check if we're not changing the ABI here. Is this always
>>> going to be safe, on any platform, regardless of endianess etc?
>>
>> Double checked, and as I feared, we can't safely do this. We'll have to
>> do something like the below, grabbing an unused bit of the poll mask
>> space and if that's set, then store the fact that EPOLLEXCLUSIVE is set.
>> So probably best to turn this just into one patch, since it doesn't make
>> a lot of sense to do it as a prep patch at that point.
>>
> Yes, Agree about that. But I also fear that if the unused bit is used
> in the feature, it will bring unexpected behavior.

Yeah, it's certainly not the prettiest and could potentially be fragile.
I'm open to suggestions, we need some way of signaling that the 32-bit
variant of the poll_events should be used. We could potentially make
this work by doing explicit layout for big endian vs little endian, that
might be prettier and wouldn't suffer from the "grab some random bit"
issue.

>> This does have the benefit of not growing io_poll_iocb. With your patch,
>> it'd go beyond a cacheline, and hence bump the size of the entire
>> io_iocb as well, which would be very unfortunate.
>>
> events in io_poll_iocb is 32-bits already, so why it will bump the
> size of the io_iocb structure with my patch? 

It's not 32-bits already, it's a __poll_t type which is 16-bits only.

-- 
Jens Axboe

