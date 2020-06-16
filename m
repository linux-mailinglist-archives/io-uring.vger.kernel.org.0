Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACED01FBE5D
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 20:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgFPSpY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 14:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgFPSpX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 14:45:23 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924CEC061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 11:45:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ne5so1817248pjb.5
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 11:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XK497qwL28BWVwTHTQHM5LJX8ETaoEyQCE9yq0G92Mw=;
        b=mEnrkrCvNdQqIxUeJWTwH8x4RcZPhsrdiDzYGYAto8aQYhQ8rS83yulYGPMtp3YUWM
         5+1wBblDLPDQOSHJOyw6nelYmFgCy5j5HcJR1npuOMxnwHe3u/IPW4XyY3UZwsURdNNm
         ZE5pvbQpxfljBUNGcA13dC4LMcN1at8pjXtQlHQ+oj46CSFHCAeGz84x/fdbt1AAyf9s
         GfQYC1ANw0Q1DDBpntxiIq+tObSazUxKBMAaP/ruBzbaSuCTUYvtGmvtetZx/goQN1fq
         x+kxmhtQsVX3Ud73LqHxqE/+OXI7Og8fhaRDjnw4LXyCaajtFT6mGyKU1hib2PUWFW2W
         6Sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XK497qwL28BWVwTHTQHM5LJX8ETaoEyQCE9yq0G92Mw=;
        b=XZXKpsr9BDMomFli3w8hLkPDZ2d9EF6XQFqawh8peHiXFsKA2FnFzt7pQpMjS7HzSt
         nSA8i6PQPRGzgxNwt4v253xz+b1yq7GTlUT4D0hrXGALWABOiRHrp7p9r0u8q2NgJkvE
         fb9yG5VoIZ4nZHTKKhgUyPGjZWZqIC5yqCES2bphZVgiHUNM3tdA2tjS2h6FJ8e0oJMY
         6dlQNxgfDNDBk/TflRYksrAZCx5FYXhzt0f6Z1nAzvmCwN6PDvH7pedBsCGctlliWgPH
         p67SQ+P2nmwVsaNJfFX5GZC7NNebzGs01XlvDajDSqlE7b9vtwXtDEGfwl05Dw/9XSsd
         frNw==
X-Gm-Message-State: AOAM531vxIvRxkqlUkEss62WcC82HK6peV6QCDrR1KA+fcoSmgnPHh3c
        dtczxL70gyr6zQh0PnKsRK8U9IrP5Pdvbg==
X-Google-Smtp-Source: ABdhPJwUgex3c+TuzvpFBm+cJKndkMN+7sHEXz4QnIPZZkE/Rr5wZltL1GfkFsJmM9QLIoWAukH15A==
X-Received: by 2002:a17:90a:e00a:: with SMTP id u10mr4108055pjy.17.1592333122852;
        Tue, 16 Jun 2020 11:45:22 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 9sm17751723pfu.181.2020.06.16.11.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 11:45:22 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
From:   Jens Axboe <axboe@kernel.dk>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
 <f6d3c7bb-1a10-10ed-9ab3-3d7b3b78b808@kernel.dk>
 <ec18b7b6-a931-409b-6113-334974442036@linux.alibaba.com>
 <b98ae1ed-c2b5-cfba-9a58-2fa64ffd067a@kernel.dk>
 <7a311161-839c-3927-951d-3ce2bc7aa5d4@linux.alibaba.com>
 <967819fd-84c5-9329-60b6-899a2708849e@kernel.dk>
Message-ID: <659bda5d-2da0-b092-9a66-1c4c4d89501a@kernel.dk>
Date:   Tue, 16 Jun 2020 12:45:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <967819fd-84c5-9329-60b6-899a2708849e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/20 7:58 AM, Jens Axboe wrote:
> On 6/15/20 9:04 PM, Jiufei Xue wrote:
>>
>>
>> On 2020/6/15 下午11:09, Jens Axboe wrote:
>>> On 6/14/20 8:49 PM, Jiufei Xue wrote:
>>>> Hi Jens,
>>>>
>>>> On 2020/6/13 上午12:48, Jens Axboe wrote:
>>>>> On 6/12/20 8:58 AM, Jens Axboe wrote:
>>>>>> On 6/11/20 8:30 PM, Jiufei Xue wrote:
>>>>>>> poll events should be 32-bits to cover EPOLLEXCLUSIVE.
>>>>>>>
>>>>>>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>>>>>>> ---
>>>>>>>  fs/io_uring.c                 | 4 ++--
>>>>>>>  include/uapi/linux/io_uring.h | 2 +-
>>>>>>>  tools/io_uring/liburing.h     | 2 +-
>>>>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>> index 47790a2..6250227 100644
>>>>>>> --- a/fs/io_uring.c
>>>>>>> +++ b/fs/io_uring.c
>>>>>>> @@ -4602,7 +4602,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>>>>>>>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>  {
>>>>>>>  	struct io_poll_iocb *poll = &req->poll;
>>>>>>> -	u16 events;
>>>>>>> +	u32 events;
>>>>>>>  
>>>>>>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>>>  		return -EINVAL;
>>>>>>> @@ -8196,7 +8196,7 @@ static int __init io_uring_init(void)
>>>>>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
>>>>>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
>>>>>>> -	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
>>>>>>> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll_events);
>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>>>>>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>>>> index 92c2269..afc7edd 100644
>>>>>>> --- a/include/uapi/linux/io_uring.h
>>>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>>>> @@ -31,7 +31,7 @@ struct io_uring_sqe {
>>>>>>>  	union {
>>>>>>>  		__kernel_rwf_t	rw_flags;
>>>>>>>  		__u32		fsync_flags;
>>>>>>> -		__u16		poll_events;
>>>>>>> +		__u32		poll_events;
>>>>>>>  		__u32		sync_range_flags;
>>>>>>>  		__u32		msg_flags;
>>>>>>>  		__u32		timeout_flags;
>>>>>>
>>>>>> We obviously have the space in there as most other flag members are 32-bits, but
>>>>>> I'd want to double check if we're not changing the ABI here. Is this always
>>>>>> going to be safe, on any platform, regardless of endianess etc?
>>>>>
>>>>> Double checked, and as I feared, we can't safely do this. We'll have to
>>>>> do something like the below, grabbing an unused bit of the poll mask
>>>>> space and if that's set, then store the fact that EPOLLEXCLUSIVE is set.
>>>>> So probably best to turn this just into one patch, since it doesn't make
>>>>> a lot of sense to do it as a prep patch at that point.
>>>>>
>>>> Yes, Agree about that. But I also fear that if the unused bit is used
>>>> in the feature, it will bring unexpected behavior.
>>>
>>> Yeah, it's certainly not the prettiest and could potentially be fragile.
>>> I'm open to suggestions, we need some way of signaling that the 32-bit
>>> variant of the poll_events should be used. We could potentially make
>>> this work by doing explicit layout for big endian vs little endian, that
>>> might be prettier and wouldn't suffer from the "grab some random bit"
>>> issue.
>>>
>> Thank you for your suggestion, I will think about it.
>>
>>>>> This does have the benefit of not growing io_poll_iocb. With your patch,
>>>>> it'd go beyond a cacheline, and hence bump the size of the entire
>>>>> io_iocb as well, which would be very unfortunate.
>>>>>
>>>> events in io_poll_iocb is 32-bits already, so why it will bump the
>>>> size of the io_iocb structure with my patch? 
>>>
>>> It's not 32-bits already, it's a __poll_t type which is 16-bits only.
>>>
>> Yes, it is a __poll_t type, but I found that __poll_t type is 32-bits
>> with the definition below:
>>
>> typedef unsigned __bitwise __poll_t;
>>
>> And I also investigate it with crash:
>> crash> io_poll_iocb -ox
>> struct io_poll_iocb {
>>    [0x0] struct file *file;
>>          union {
>>    [0x8]     struct wait_queue_head *head;
>>    [0x8]     u64 addr;
>>          };
>>   [0x10] __poll_t events;
>>   [0x14] bool done;
>>   [0x15] bool canceled;
>>   [0x18] struct wait_queue_entry wait;
>> }
> 
> Yeah you're right, not sure why I figured it was 16-bits. But just
> checking on my default build:
> 
> axboe@x1 ~/gi/linux-block (block-5.8)> pahole -C io_poll_iocb fs/io_uring.o
> struct io_poll_iocb {
> 	struct file *              file;                 /*     0     8 */
> 	union {
> 		struct wait_queue_head * head;           /*     8     8 */
> 		u64                addr;                 /*     8     8 */
> 	};                                               /*     8     8 */
> 	__poll_t                   events;               /*    16     4 */
> 	bool                       done;                 /*    20     1 */
> 	bool                       canceled;             /*    21     1 */
> 
> 	/* XXX 2 bytes hole, try to pack */
> 
> 	struct wait_queue_entry wait;                    /*    24    40 */
> 
> 	/* size: 64, cachelines: 1, members: 6 */
> 	/* sum members: 62, holes: 1, sum holes: 2 */
> };
> 
> and it's definitely 64-bytes in total size (as it should be), and the
> 'events' is indeed 32-bits as well.
> 
> So at least that's good, we don't need anything extra in there. If we
> can solve the endian issue, then it should be trivial to use the full
> 32-bits for the flags in the sqe.

To get back to something that can move us forward, something like the
below I _think_ will work. Then applications just use poll32_events and
we don't have to handle this in any special way. Care to base on that
and re-send the change?


diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c22699a5a7..5b3f6bd59437 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -31,7 +31,16 @@ struct io_uring_sqe {
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
-		__u16		poll_events;
+		struct {
+#ifdef __BIG_ENDIAN_BITFIELD
+			__u16	__unused_poll;
+			__u16	poll_events;
+#else
+			__u16	poll_events;
+			__u16	__unused_poll;
+#endif
+		};
+		__u32		poll32_events;
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;

-- 
Jens Axboe

