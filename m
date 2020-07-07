Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A854621741C
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 18:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgGGQgu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 12:36:50 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:41491 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726911AbgGGQgu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 12:36:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U22cV9h_1594139797;
Received: from 192.168.124.22(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U22cV9h_1594139797)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Jul 2020 00:36:38 +0800
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
 <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
 <bb9e165a-3193-5da2-d342-e5d9ed200070@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <cd98c11f-a453-b0c9-ceb0-569e0a161e17@linux.alibaba.com>
Date:   Wed, 8 Jul 2020 00:36:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bb9e165a-3193-5da2-d342-e5d9ed200070@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 7/7/20 8:28 AM, Jens Axboe wrote:
>> On 7/7/20 7:24 AM, Xiaoguang Wang wrote:
>>> For those applications which are not willing to use io_uring_enter()
>>> to reap and handle cqes, they may completely rely on liburing's
>>> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
>>> io_uring_peek_cqe() is not aware of this overflow, it won't enter
>>> kernel to flush cqes, below test program can reveal this bug:
>>>
>>> static void test_cq_overflow(struct io_uring *ring)
>>> {
>>>          struct io_uring_cqe *cqe;
>>>          struct io_uring_sqe *sqe;
>>>          int issued = 0;
>>>          int ret = 0;
>>>
>>>          do {
>>>                  sqe = io_uring_get_sqe(ring);
>>>                  if (!sqe) {
>>>                          fprintf(stderr, "get sqe failed\n");
>>>                          break;;
>>>                  }
>>>                  ret = io_uring_submit(ring);
>>>                  if (ret <= 0) {
>>>                          if (ret != -EBUSY)
>>>                                  fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>                          break;
>>>                  }
>>>                  issued++;
>>>          } while (ret > 0);
>>>          assert(ret == -EBUSY);
>>>
>>>          printf("issued requests: %d\n", issued);
>>>
>>>          while (issued) {
>>>                  ret = io_uring_peek_cqe(ring, &cqe);
>>>                  if (ret) {
>>>                          if (ret != -EAGAIN) {
>>>                                  fprintf(stderr, "peek completion failed: %s\n",
>>>                                          strerror(ret));
>>>                                  break;
>>>                          }
>>>                          printf("left requets: %d\n", issued);
>>>                          continue;
>>>                  }
>>>                  io_uring_cqe_seen(ring, cqe);
>>>                  issued--;
>>>                  printf("left requets: %d\n", issued);
>>>          }
>>> }
>>>
>>> int main(int argc, char *argv[])
>>> {
>>>          int ret;
>>>          struct io_uring ring;
>>>
>>>          ret = io_uring_queue_init(16, &ring, 0);
>>>          if (ret) {
>>>                  fprintf(stderr, "ring setup failed: %d\n", ret);
>>>                  return 1;
>>>          }
>>>
>>>          test_cq_overflow(&ring);
>>>          return 0;
>>> }
>>>
>>> To fix this issue, export cq overflow status to userspace, then
>>> helper functions() in liburing, such as io_uring_peek_cqe, can be
>>> aware of this cq overflow and do flush accordingly.
>>
>> Is there any way we can accomplish the same without exporting
>> another set of flags? Would it be enough for the SQPOLl thread to set
>> IORING_SQ_NEED_WAKEUP if we're in overflow condition? That should
>> result in the app entering the kernel when it's flushed the user CQ
>> side, and then the sqthread could attempt to flush the pending
>> events as well.
>>
>> Something like this, totally untested...
> 
> OK, took a closer look at this, it's a generic thing, not just
> SQPOLL related. My bad!
> 
> Anyway, my suggestion would be to add IORING_SQ_CQ_OVERFLOW to the
> existing flags, and then make a liburing change almost identical to
> what you had.
Thanks.
It's somewhat late today, I'll test and send these two patches tomorrow.

Regards,
Xiaoguang Wang

> 
> Hence kernel side:
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d37d7ea5ebe5..af9fd5cefc51 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1234,11 +1234,12 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>   	struct io_uring_cqe *cqe;
>   	struct io_kiocb *req;
>   	unsigned long flags;
> +	bool ret = true;
>   	LIST_HEAD(list);
>   
>   	if (!force) {
>   		if (list_empty_careful(&ctx->cq_overflow_list))
> -			return true;
> +			goto done;
>   		if ((ctx->cached_cq_tail - READ_ONCE(rings->cq.head) ==
>   		    rings->cq_ring_entries))
>   			return false;
> @@ -1284,7 +1285,11 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>   		io_put_req(req);
>   	}
>   
> -	return cqe != NULL;
> +	ret = cqe != NULL;
> +done:
> +	if (ret)
> +		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
> +	return ret;
>   }
>   
>   static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
> @@ -5933,10 +5938,13 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>   	int i, submitted = 0;
>   
>   	/* if we have a backlog and couldn't flush it all, return BUSY */
> -	if (test_bit(0, &ctx->sq_check_overflow)) {
> +	if (unlikely(test_bit(0, &ctx->sq_check_overflow))) {
>   		if (!list_empty(&ctx->cq_overflow_list) &&
> -		    !io_cqring_overflow_flush(ctx, false))
> +		    !io_cqring_overflow_flush(ctx, false)) {
> +			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
> +			smp_mb();
>   			return -EBUSY;
> +		}
>   	}
>   
>   	/* make sure SQ entry isn't read before tail */
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92c22699a5a7..9c7e028beda5 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -197,6 +197,7 @@ struct io_sqring_offsets {
>    * sq_ring->flags
>    */
>   #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
> +#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* app needs to enter kernel */
>   
>   struct io_cqring_offsets {
>   	__u32 head;
> 
> and then this for the liburing side:
> 
> 
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
> index 6a73522..e4314ed 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -202,6 +202,7 @@ struct io_sqring_offsets {
>    * sq_ring->flags
>    */
>   #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
> +#define IORING_SQ_CQ_OVERFLOW	(1U << 1)
>   
>   struct io_cqring_offsets {
>   	__u32 head;
> diff --git a/src/queue.c b/src/queue.c
> index 88e0294..1f00251 100644
> --- a/src/queue.c
> +++ b/src/queue.c
> @@ -32,6 +32,11 @@ static inline bool sq_ring_needs_enter(struct io_uring *ring,
>   	return false;
>   }
>   
> +static inline bool cq_ring_needs_flush(struct io_uring *ring)
> +{
> +	return IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW;
> +}
> +
>   static int __io_uring_peek_cqe(struct io_uring *ring,
>   			       struct io_uring_cqe **cqe_ptr)
>   {
> @@ -67,22 +72,26 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
>   	int ret = 0, err;
>   
>   	do {
> +		bool cq_overflow_flush = false;
>   		unsigned flags = 0;
>   
>   		err = __io_uring_peek_cqe(ring, &cqe);
>   		if (err)
>   			break;
>   		if (!cqe && !to_wait && !submit) {
> -			err = -EAGAIN;
> -			break;
> +			if (!cq_ring_needs_flush(ring)) {
> +				err = -EAGAIN;
> +				break;
> +			}
> +			cq_overflow_flush = true;
>   		}
>   		if (wait_nr && cqe)
>   			wait_nr--;
> -		if (wait_nr)
> +		if (wait_nr || cq_overflow_flush)
>   			flags = IORING_ENTER_GETEVENTS;
>   		if (submit)
>   			sq_ring_needs_enter(ring, submit, &flags);
> -		if (wait_nr || submit)
> +		if (wait_nr || submit || cq_overflow_flush)
>   			ret = __sys_io_uring_enter(ring->ring_fd, submit,
>   						   wait_nr, flags, sigmask);
>   		if (ret < 0) {
> 
> If you agree with this approach, could you test this and resubmit the
> two patches?
> 
