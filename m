Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370451F8C55
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 04:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgFOCuN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Jun 2020 22:50:13 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:34500 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727971AbgFOCuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Jun 2020 22:50:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.YpBmI_1592189395;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.YpBmI_1592189395)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Jun 2020 10:50:10 +0800
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
 <f6d3c7bb-1a10-10ed-9ab3-3d7b3b78b808@kernel.dk>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <ec18b7b6-a931-409b-6113-334974442036@linux.alibaba.com>
Date:   Mon, 15 Jun 2020 10:49:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <f6d3c7bb-1a10-10ed-9ab3-3d7b3b78b808@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 2020/6/13 上午12:48, Jens Axboe wrote:
> On 6/12/20 8:58 AM, Jens Axboe wrote:
>> On 6/11/20 8:30 PM, Jiufei Xue wrote:
>>> poll events should be 32-bits to cover EPOLLEXCLUSIVE.
>>>
>>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>>> ---
>>>  fs/io_uring.c                 | 4 ++--
>>>  include/uapi/linux/io_uring.h | 2 +-
>>>  tools/io_uring/liburing.h     | 2 +-
>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 47790a2..6250227 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4602,7 +4602,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>>>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  {
>>>  	struct io_poll_iocb *poll = &req->poll;
>>> -	u16 events;
>>> +	u32 events;
>>>  
>>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>  		return -EINVAL;
>>> @@ -8196,7 +8196,7 @@ static int __init io_uring_init(void)
>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
>>>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
>>> -	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
>>> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll_events);
>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>>>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 92c2269..afc7edd 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -31,7 +31,7 @@ struct io_uring_sqe {
>>>  	union {
>>>  		__kernel_rwf_t	rw_flags;
>>>  		__u32		fsync_flags;
>>> -		__u16		poll_events;
>>> +		__u32		poll_events;
>>>  		__u32		sync_range_flags;
>>>  		__u32		msg_flags;
>>>  		__u32		timeout_flags;
>>
>> We obviously have the space in there as most other flag members are 32-bits, but
>> I'd want to double check if we're not changing the ABI here. Is this always
>> going to be safe, on any platform, regardless of endianess etc?
> 
> Double checked, and as I feared, we can't safely do this. We'll have to
> do something like the below, grabbing an unused bit of the poll mask
> space and if that's set, then store the fact that EPOLLEXCLUSIVE is set.
> So probably best to turn this just into one patch, since it doesn't make
> a lot of sense to do it as a prep patch at that point.
>
Yes, Agree about that. But I also fear that if the unused bit is used in the
feature, it will bring unexpected behavior.

> This does have the benefit of not growing io_poll_iocb. With your patch,
> it'd go beyond a cacheline, and hence bump the size of the entire
> io_iocb as well, which would be very unfortunate.
>
events in io_poll_iocb is 32-bits already, so why it will bump the size of the io_iocb
structure with my patch? 

Thanks,
Jiufei

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d830ddb..64a98bf11943 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -350,6 +350,7 @@ struct io_poll_iocb {
>  		u64			addr;
>  	};
>  	__poll_t			events;
> +	bool				exclusive;
>  	bool				done;
>  	bool				canceled;
>  	struct wait_queue_entry		wait;
> @@ -4543,7 +4544,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_poll_iocb *poll = &req->poll;
> -	u16 events;
> +	u32 events;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> @@ -4553,6 +4554,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  		return -EBADF;
>  
>  	events = READ_ONCE(sqe->poll_events);
> +	if ((events & IORING_POLL_32BIT) &&
> +	    (sqe->poll32_events & EPOLLEXCLUSIVE))
> +		poll->exclusive = true;
>  	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
>  
>  	get_task_struct(current);
> @@ -8155,6 +8159,7 @@ static int __init io_uring_init(void)
>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92c22699a5a7..16d473d909eb 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -32,6 +32,7 @@ struct io_uring_sqe {
>  		__kernel_rwf_t	rw_flags;
>  		__u32		fsync_flags;
>  		__u16		poll_events;
> +		__u32		poll32_events;
>  		__u32		sync_range_flags;
>  		__u32		msg_flags;
>  		__u32		timeout_flags;
> @@ -60,6 +61,8 @@ struct io_uring_sqe {
>  	};
>  };
>  
> +#define IORING_POLL_32BIT	(1U << 15)
> +
>  enum {
>  	IOSQE_FIXED_FILE_BIT,
>  	IOSQE_IO_DRAIN_BIT,
> 
