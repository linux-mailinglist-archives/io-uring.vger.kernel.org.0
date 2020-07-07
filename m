Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1D62173F4
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 18:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGGQ3p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 12:29:45 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:33903 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726911AbgGGQ3p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 12:29:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U22i8eb_1594139379;
Received: from 192.168.124.22(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U22i8eb_1594139379)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Jul 2020 00:29:40 +0800
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
 <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <9b62548d-1a40-0706-21bd-7be699cc2c83@linux.alibaba.com>
Date:   Wed, 8 Jul 2020 00:29:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 7/7/20 7:24 AM, Xiaoguang Wang wrote:
>> For those applications which are not willing to use io_uring_enter()
>> to reap and handle cqes, they may completely rely on liburing's
>> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
>> io_uring_peek_cqe() is not aware of this overflow, it won't enter
>> kernel to flush cqes, below test program can reveal this bug:
>>
>> static void test_cq_overflow(struct io_uring *ring)
>> {
>>          struct io_uring_cqe *cqe;
>>          struct io_uring_sqe *sqe;
>>          int issued = 0;
>>          int ret = 0;
>>
>>          do {
>>                  sqe = io_uring_get_sqe(ring);
>>                  if (!sqe) {
>>                          fprintf(stderr, "get sqe failed\n");
>>                          break;;
>>                  }
>>                  ret = io_uring_submit(ring);
>>                  if (ret <= 0) {
>>                          if (ret != -EBUSY)
>>                                  fprintf(stderr, "sqe submit failed: %d\n", ret);
>>                          break;
>>                  }
>>                  issued++;
>>          } while (ret > 0);
>>          assert(ret == -EBUSY);
>>
>>          printf("issued requests: %d\n", issued);
>>
>>          while (issued) {
>>                  ret = io_uring_peek_cqe(ring, &cqe);
>>                  if (ret) {
>>                          if (ret != -EAGAIN) {
>>                                  fprintf(stderr, "peek completion failed: %s\n",
>>                                          strerror(ret));
>>                                  break;
>>                          }
>>                          printf("left requets: %d\n", issued);
>>                          continue;
>>                  }
>>                  io_uring_cqe_seen(ring, cqe);
>>                  issued--;
>>                  printf("left requets: %d\n", issued);
>>          }
>> }
>>
>> int main(int argc, char *argv[])
>> {
>>          int ret;
>>          struct io_uring ring;
>>
>>          ret = io_uring_queue_init(16, &ring, 0);
>>          if (ret) {
>>                  fprintf(stderr, "ring setup failed: %d\n", ret);
>>                  return 1;
>>          }
>>
>>          test_cq_overflow(&ring);
>>          return 0;
>> }
>>
>> To fix this issue, export cq overflow status to userspace, then
>> helper functions() in liburing, such as io_uring_peek_cqe, can be
>> aware of this cq overflow and do flush accordingly.
> 
> Is there any way we can accomplish the same without exporting
> another set of flags? 
I understand your concerns and will try to find some better methods later,
but not sure there're some better :)

> Would it be enough for the SQPOLl thread to set
> IORING_SQ_NEED_WAKEUP if we're in overflow condition? That should
> result in the app entering the kernel when it's flushed the user CQ
> side, and then the sqthread could attempt to flush the pending
> events as well.
> 
> Something like this, totally untested...
I haven't test your patch, but I think it doesn't work for non-sqpoll case, see
my above test program, it doesn't have SQPOLL enabled.

Regards,
Xiaoguang Wang
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d37d7ea5ebe5..d409bd68553f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6110,8 +6110,18 @@ static int io_sq_thread(void *data)
>   		}
>   
>   		mutex_lock(&ctx->uring_lock);
> -		if (likely(!percpu_ref_is_dying(&ctx->refs)))
> +		if (likely(!percpu_ref_is_dying(&ctx->refs))) {
> +retry:
>   			ret = io_submit_sqes(ctx, to_submit, NULL, -1);
> +			if (unlikely(ret == -EBUSY)) {
> +				ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
> +				smp_mb();
> +				if (io_cqring_overflow_flush(ctx, false)) {
> +					ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
> +					goto retry;
> +				}
> +			}
> +		}
>   		mutex_unlock(&ctx->uring_lock);
>   		timeout = jiffies + ctx->sq_thread_idle;
>   	}
> 
