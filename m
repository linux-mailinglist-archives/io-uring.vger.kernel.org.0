Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAFA1FBEE1
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 21:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbgFPTWQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 15:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730463AbgFPTWP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 15:22:15 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D99C061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:22:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l10so21929903wrr.10
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uBIiuRi+R/gki317HK3A4j11jyRBng0T910yoi7iT88=;
        b=JZ0JzZl7rqyqqWNdnPu3SonOjMuWqKI4IgjqE9PjFnb5D9Gg4RggXTXCqfZvtDWaCR
         7iyCRUhsHOo5+HaxmVVCwhPSgBcPiFKgXah1EP9vXYMRUTWSVe4LzUqfv5plCfqOY7VK
         3/12q5LhebHBp6asy9BPKsVxLHPjMmB0tawGzE/chYZqWhEtixj7eIK7JA8S107ev0gM
         1oDdOANBKZ/FqsEVkTsbCxAxrw6szJqyauDZ1WGLy/Y7lAsJJPW4c16uK/DsPVt1QzA3
         v/TVwUNSgnHqliZknTSfUIZ3iYDI8qnl+7ivl6g2PBLGsL0h/NoU4VmeSibFR48Sez7n
         eWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uBIiuRi+R/gki317HK3A4j11jyRBng0T910yoi7iT88=;
        b=QNgc1AoCSBdH3AUumBRi8y0m/MSoYXR4S6FfZWAIIQrfy0kVj7BS4I9YcgVXHpe5am
         zdahxKYdJuwy6AS+WF+tECqHZ1mCGLNln4f8Q2qUmgys0r7GDqKUBgBwd7tg9pkjzvZC
         my18FFMT5P7obZLnZ5FdZ5isIB8MXkxii3iRnKUiCn4ES7GhpK7YZMovebUYlUkzhmP2
         S9rLDwIwrv3eox3jr+HhhF20zljLuh+WUZzBAojvmso89BbgHa+b72cVCp5tFSSygryb
         K1fYk4eHNb0g4T0zKEA0Y6aOcF/Xw85MuayRryHXdFIiAJo9N20cTmI+mZIemFvD9E5J
         0uRA==
X-Gm-Message-State: AOAM531mzRNGum0U3e9VkmYICcUL9WfBIApJ4p8pG+LH3qDKN5bNof8N
        dFxVpPVvziqsU4lgj5rJJjvQolJ/
X-Google-Smtp-Source: ABdhPJzse8ncO91/kZiajvhfLqiGPksDRf5v0I+IzZcf4aTsHgNaBaFvjeSO3cjKHmpWmHAL35ACHw==
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr4496569wrs.127.1592335333824;
        Tue, 16 Jun 2020 12:22:13 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id c65sm5176366wme.8.2020.06.16.12.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 12:22:13 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
Message-ID: <cdf0cbfe-2c3b-1240-a9b0-4b6d9bb0933f@gmail.com>
Date:   Tue, 16 Jun 2020 22:20:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <659bda5d-2da0-b092-9a66-1c4c4d89501a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/06/2020 21:45, Jens Axboe wrote:
> On 6/16/20 7:58 AM, Jens Axboe wrote:
>> On 6/15/20 9:04 PM, Jiufei Xue wrote:
>>>
>>>
>>> On 2020/6/15 下午11:09, Jens Axboe wrote:
>>>> On 6/14/20 8:49 PM, Jiufei Xue wrote:
>>>>> Hi Jens,
>>>>>
>>>>> On 2020/6/13 上午12:48, Jens Axboe wrote:
>>>>>> On 6/12/20 8:58 AM, Jens Axboe wrote:
>>>>>>> On 6/11/20 8:30 PM, Jiufei Xue wrote:
>>>>>>>> poll events should be 32-bits to cover EPOLLEXCLUSIVE.
>>>>>>>>
>>>>>>>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>>  fs/io_uring.c                 | 4 ++--
>>>>>>>>  include/uapi/linux/io_uring.h | 2 +-
>>>>>>>>  tools/io_uring/liburing.h     | 2 +-
>>>>>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>>> index 47790a2..6250227 100644
>>>>>>>> --- a/fs/io_uring.c
>>>>>>>> +++ b/fs/io_uring.c
>>>>>>>> @@ -4602,7 +4602,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>>>>>>>>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>>  {
>>>>>>>>  	struct io_poll_iocb *poll = &req->poll;
>>>>>>>> -	u16 events;
>>>>>>>> +	u32 events;
>>>>>>>>  
>>>>>>>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>>>>  		return -EINVAL;
>>>>>>>> @@ -8196,7 +8196,7 @@ static int __init io_uring_init(void)
>>>>>>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
>>>>>>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
>>>>>>>> -	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
>>>>>>>> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll_events);
>>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
>>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>>>>> index 92c2269..afc7edd 100644
>>>>>>>> --- a/include/uapi/linux/io_uring.h
>>>>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>>>>> @@ -31,7 +31,7 @@ struct io_uring_sqe {
>>>>>>>>  	union {
>>>>>>>>  		__kernel_rwf_t	rw_flags;
>>>>>>>>  		__u32		fsync_flags;
>>>>>>>> -		__u16		poll_events;
>>>>>>>> +		__u32		poll_events;
>>>>>>>>  		__u32		sync_range_flags;
>>>>>>>>  		__u32		msg_flags;
>>>>>>>>  		__u32		timeout_flags;
>>>>>>>
>>>>>>> We obviously have the space in there as most other flag members are 32-bits, but
>>>>>>> I'd want to double check if we're not changing the ABI here. Is this always
>>>>>>> going to be safe, on any platform, regardless of endianess etc?
>>>>>>
>>>>>> Double checked, and as I feared, we can't safely do this. We'll have to
>>>>>> do something like the below, grabbing an unused bit of the poll mask
>>>>>> space and if that's set, then store the fact that EPOLLEXCLUSIVE is set.
>>>>>> So probably best to turn this just into one patch, since it doesn't make
>>>>>> a lot of sense to do it as a prep patch at that point.
>>>>>>
>>>>> Yes, Agree about that. But I also fear that if the unused bit is used
>>>>> in the feature, it will bring unexpected behavior.
>>>>
>>>> Yeah, it's certainly not the prettiest and could potentially be fragile.
>>>> I'm open to suggestions, we need some way of signaling that the 32-bit
>>>> variant of the poll_events should be used. We could potentially make
>>>> this work by doing explicit layout for big endian vs little endian, that
>>>> might be prettier and wouldn't suffer from the "grab some random bit"
>>>> issue.
>>>>
>>> Thank you for your suggestion, I will think about it.
>>>
>>>>>> This does have the benefit of not growing io_poll_iocb. With your patch,
>>>>>> it'd go beyond a cacheline, and hence bump the size of the entire
>>>>>> io_iocb as well, which would be very unfortunate.
>>>>>>
>>>>> events in io_poll_iocb is 32-bits already, so why it will bump the
>>>>> size of the io_iocb structure with my patch? 
>>>>
>>>> It's not 32-bits already, it's a __poll_t type which is 16-bits only.
>>>>
>>> Yes, it is a __poll_t type, but I found that __poll_t type is 32-bits
>>> with the definition below:
>>>
>>> typedef unsigned __bitwise __poll_t;
>>>
>>> And I also investigate it with crash:
>>> crash> io_poll_iocb -ox
>>> struct io_poll_iocb {
>>>    [0x0] struct file *file;
>>>          union {
>>>    [0x8]     struct wait_queue_head *head;
>>>    [0x8]     u64 addr;
>>>          };
>>>   [0x10] __poll_t events;
>>>   [0x14] bool done;
>>>   [0x15] bool canceled;
>>>   [0x18] struct wait_queue_entry wait;
>>> }
>>
>> Yeah you're right, not sure why I figured it was 16-bits. But just
>> checking on my default build:
>>
>> axboe@x1 ~/gi/linux-block (block-5.8)> pahole -C io_poll_iocb fs/io_uring.o
>> struct io_poll_iocb {
>> 	struct file *              file;                 /*     0     8 */
>> 	union {
>> 		struct wait_queue_head * head;           /*     8     8 */
>> 		u64                addr;                 /*     8     8 */
>> 	};                                               /*     8     8 */
>> 	__poll_t                   events;               /*    16     4 */
>> 	bool                       done;                 /*    20     1 */
>> 	bool                       canceled;             /*    21     1 */
>>
>> 	/* XXX 2 bytes hole, try to pack */
>>
>> 	struct wait_queue_entry wait;                    /*    24    40 */
>>
>> 	/* size: 64, cachelines: 1, members: 6 */
>> 	/* sum members: 62, holes: 1, sum holes: 2 */
>> };
>>
>> and it's definitely 64-bytes in total size (as it should be), and the
>> 'events' is indeed 32-bits as well.
>>
>> So at least that's good, we don't need anything extra in there. If we
>> can solve the endian issue, then it should be trivial to use the full
>> 32-bits for the flags in the sqe.
> 
> To get back to something that can move us forward, something like the
> below I _think_ will work. Then applications just use poll32_events and
> we don't have to handle this in any special way. Care to base on that
> and re-send the change?
> 
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92c22699a5a7..5b3f6bd59437 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -31,7 +31,16 @@ struct io_uring_sqe {
>  	union {
>  		__kernel_rwf_t	rw_flags;
>  		__u32		fsync_flags;
> -		__u16		poll_events;
> +		struct {
> +#ifdef __BIG_ENDIAN_BITFIELD
> +			__u16	__unused_poll;
> +			__u16	poll_events;
> +#else
> +			__u16	poll_events;
> +			__u16	__unused_poll;
> +#endif
> +		};
> +		__u32		poll32_events;
>  		__u32		sync_range_flags;
>  		__u32		msg_flags;
>  		__u32		timeout_flags;
> 

That changes layout for big endian, isn't it? It's not ABI compatible.

-- 
Pavel Begunkov
