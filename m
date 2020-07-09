Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B925F21955E
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 02:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgGIAw6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 20:52:58 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:41695 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbgGIAw6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 20:52:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U29Mfur_1594255974;
Received: from 192.168.124.22(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U29Mfur_1594255974)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 08:52:54 +0800
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <c4e40cba-4171-a253-8813-ca833c8ce575@linux.alibaba.com>
 <D59FC4AE-8D3B-44F4-A6AA-91722D97E202@kernel.dk>
 <83a3a0eb-8dea-20ad-ffc5-619226b47998@linux.alibaba.com>
 <f2cad5fb-7daf-611e-91dd-81d3eb268d26@kernel.dk>
 <54ce9903-4016-5b30-2fe9-397da9161bfe@linux.alibaba.com>
 <6c770628-34bd-f75a-3d4a-c1810f652054@kernel.dk>
 <c986d7f5-f085-c57c-450e-6f3bbee40640@linux.alibaba.com>
 <706ecf46-63e5-ac5f-a2e9-b15a75e0be11@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <39cd889e-e4de-95b6-36f0-53be95636193@linux.alibaba.com>
Date:   Thu, 9 Jul 2020 08:52:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <706ecf46-63e5-ac5f-a2e9-b15a75e0be11@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 7/8/20 10:51 AM, Xiaoguang Wang wrote:
>> hi,
>>
>>> On 7/8/20 9:39 AM, Xiaoguang Wang wrote:
>>>> hi,
>>>>
>>>>> On 7/7/20 11:29 PM, Xiaoguang Wang wrote:
>>>>>> I modify above test program a bit:
>>>>>> #include <errno.h>
>>>>>> #include <stdio.h>
>>>>>> #include <unistd.h>
>>>>>> #include <stdlib.h>
>>>>>> #include <string.h>
>>>>>> #include <fcntl.h>
>>>>>> #include <assert.h>
>>>>>>
>>>>>> #include "liburing.h"
>>>>>>
>>>>>> static void test_cq_overflow(struct io_uring *ring)
>>>>>> {
>>>>>>             struct io_uring_cqe *cqe;
>>>>>>             struct io_uring_sqe *sqe;
>>>>>>             int issued = 0;
>>>>>>             int ret = 0;
>>>>>>             int i;
>>>>>>
>>>>>>             for (i = 0; i < 33; i++) {
>>>>>>                     sqe = io_uring_get_sqe(ring);
>>>>>>                     if (!sqe) {
>>>>>>                             fprintf(stderr, "get sqe failed\n");
>>>>>>                             break;;
>>>>>>                     }
>>>>>>                     ret = io_uring_submit(ring);
>>>>>>                     if (ret <= 0) {
>>>>>>                             if (ret != -EBUSY)
>>>>>>                                     fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>>>>                             break;
>>>>>>                     }
>>>>>>                     issued++;
>>>>>>             }
>>>>>>
>>>>>>             printf("issued requests: %d\n", issued);
>>>>>>
>>>>>>             while (issued) {
>>>>>>                     ret = io_uring_peek_cqe(ring, &cqe);
>>>>>>                     if (ret) {
>>>>>>                             if (ret != -EAGAIN) {
>>>>>>                                     fprintf(stderr, "peek completion failed: %s\n",
>>>>>>                                             strerror(ret));
>>>>>>                                     break;
>>>>>>                             }
>>>>>>                             printf("left requets: %d %d\n", issued, IO_URING_READ_ONCE(*ring->sq.kflags));
>>>>>>                             continue;
>>>>>>                     }
>>>>>>                     io_uring_cqe_seen(ring, cqe);
>>>>>>                     issued--;
>>>>>>                     printf("left requets: %d\n", issued);
>>>>>>             }
>>>>>> }
>>>>>>
>>>>>> int main(int argc, char *argv[])
>>>>>> {
>>>>>>             int ret;
>>>>>>             struct io_uring ring;
>>>>>>
>>>>>>             ret = io_uring_queue_init(16, &ring, 0);
>>>>>>             if (ret) {
>>>>>>                     fprintf(stderr, "ring setup failed: %d\n", ret);
>>>>>>                     return 1;
>>>>>>             }
>>>>>>
>>>>>>             test_cq_overflow(&ring);
>>>>>>             return 0;
>>>>>> }
>>>>>>
>>>>>> Though with your patches applied, we still can not peek the last cqe.
>>>>>> This test program will only issue 33 sqes, so it won't get EBUSY error.
>>>>>
>>>>> How about we make this even simpler, then - make the
>>>>> IORING_SQ_CQ_OVERFLOW actually track the state, rather than when we fail
>>>>> on submission. The liburing change would be the same, the kernel side
>>>>> would then look like the below.
>>>>>
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 4c9a494c9f9f..01981926cdf4 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -1342,6 +1342,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>>>>     	if (cqe) {
>>>>>     		clear_bit(0, &ctx->sq_check_overflow);
>>>>>     		clear_bit(0, &ctx->cq_check_overflow);
>>>>> +		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
>>>>>     	}
>>>>>     	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>>>>>     	io_cqring_ev_posted(ctx);
>>>>> @@ -1379,6 +1380,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>>>>>     		if (list_empty(&ctx->cq_overflow_list)) {
>>>>>     			set_bit(0, &ctx->sq_check_overflow);
>>>>>     			set_bit(0, &ctx->cq_check_overflow);
>>>>> +			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
>> Some callers to __io_cqring_fill_event() don't hold completion_lock, for example:
>> ==> io_iopoll_complete
>> ====> __io_cqring_fill_event()
>> So this patch maybe still not safe when SQPOLL is enabled.
>> Do you perfer adding a new lock or just do completion_lock here only when cq ring is overflowed?
> 
> The polled side isn't IRQ driven, so should be serialized separately. This works
> because we don't allow non-polled IO on a polled context, and vice versa. If not,
> we'd have bigger issues than just the flags modification.
> 
> So it should be fine as-is.
Thanks for explanation, previously I worry about below race:
==> io_uring_enter
==== > io_iopoll_check
======> io_iopoll_getevents
========> io_do_iopoll
==========> io_iopoll_complete
============> __io_cqring_fill_event, which will modify sq_flags

and

==> io_sq_thread
====> will go to sleep, so also modify sq_flags.

But indeed above race won't happen, becuase if SQPOLL and IOPOLL are both
enabled, io_uring_enter will rely on io_sq_thread to do the iopoll job.
		if (ctx->flags & IORING_SETUP_IOPOLL &&
		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
			ret = io_iopoll_check(ctx, &nr_events, min_complete);
		} else {
			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
		}

Regards,
Xiaoguang Wang


> 
