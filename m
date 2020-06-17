Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090581FC380
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 03:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgFQBj7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 21:39:59 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45838 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726601AbgFQBj4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 21:39:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.orvSE_1592357992;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.orvSE_1592357992)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Jun 2020 09:39:53 +0800
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
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
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <bc057eb0-2af5-3370-3734-fbe7d9284a5f@linux.alibaba.com>
Date:   Wed, 17 Jun 2020 09:39:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <d0d05303-e31c-7113-9805-df5602ecd86d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/6/17 上午5:46, Pavel Begunkov wrote:
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
>
Cool, That's clear. And we should do the reverse thing in liburing
for big endian.

I also want to add another feature bit in newer kernel, so that
the newer application should check the feature first before setting
the EPOLLEXCLUSIVE.

Thanks,
JIufei.

>> +		poll->events |= EPOLLEXCLUSIVE;
>> +
>>  	io_get_req_task(req);
>>  	return 0;
>>  }
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 92c22699a5a7..e6856d8e068f 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -31,7 +31,10 @@ struct io_uring_sqe {
>>  	union {
>>  		__kernel_rwf_t	rw_flags;
>>  		__u32		fsync_flags;
>> -		__u16		poll_events;
>> +		struct {
>> +			__u16	poll_events;
>> +			__u16	poll_events_hi;
>> +		};
>>  		__u32		sync_range_flags;
>>  		__u32		msg_flags;
>>  		__u32		timeout_flags;
>>
> 
