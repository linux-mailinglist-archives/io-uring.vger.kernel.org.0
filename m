Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C2A4BB3DE
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 09:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiBRIHQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 03:07:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiBRIHO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 03:07:14 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B73A17A84
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 00:06:54 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V4oPLQF_1645171611;
Received: from 192.168.31.208(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4oPLQF_1645171611)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Feb 2022 16:06:52 +0800
Message-ID: <2ec04f63-7d82-74db-1b59-9629b4d6ca9b@linux.alibaba.com>
Date:   Fri, 18 Feb 2022 16:06:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
 <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
 <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
 <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
 <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
 <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
 <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
 <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
 <3dcb591407be5180d7b14c05eceff30a8f990b58.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <3dcb591407be5180d7b14c05eceff30a8f990b58.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 2/18/22 04:28, Olivier Langlois wrote:
> On Wed, 2022-02-16 at 20:14 +0800, Hao Xu wrote:
>> Hi Olivier,
>> I've write something to express my idea, it would be great if you can
>> try it.
>> It's totally untested and only does polling in sqthread, won't be
>> hard
>> to expand it to cqring_wait. My original idea is to poll all the napi
>> device but seems that may be not efficient. so for a request, just
>> do napi polling for one napi.
>> There is still one problem: when to delete the polled NAPIs.
>>
>> Regards,
>> Hao
>>
> Hi Hao,
>
> I am going to give your patch a try hopefully later today.
>
> On my side, I have made a small change to my code and it started to
> work.
>
> I did remove the call to io_run_task_work() from io_busy_loop_end().
> While inside napi_busy_loop(), preemption is disabled, local_bh too and
> the function acquires a napi_poll lock. I haven't been able to put my
> finger on exactly why but it appears that in that state, the net
> subsystem is not reentrant. Therefore, I did replace the call to
> io_run_task_work() with a call to signal_pending() just to know if
> there are pending task works so that they can be handled outside the
> napi_busy_loop.
>
> I am not sure how a socket is assigned to a napi device but I got a few
> with my 50 sockets program (8 to be exact):
>
> [2022-02-17 09:59:10] INFO WSBASE/client_established 706
> LWS_CALLBACK_CLIENT_ESTABLISHED client 50(17), napi_id: 10
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 3(63), napi_id: 12
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 49(16), napi_id: 15
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 15(51), napi_id: 12
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 31(35), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 14(52), napi_id: 14
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 11(55), napi_id: 12
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 16(50), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 40(26), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 39(27), napi_id: 14
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 8(58), napi_id: 10
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 20(46), napi_id: 13
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 7(59), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 6(60), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 22(44), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 13(53), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 38(28), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 21(45), napi_id: 12
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 4(62), napi_id: 15
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 35(31), napi_id: 13
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 25(41), napi_id: 12
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 18(48), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 12(54), napi_id: 13
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 5(61), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 23(43), napi_id: 13
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 46(20), napi_id: 11
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 43(23), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 9(57), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 29(37), napi_id: 14
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 28(38), napi_id: 15
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 33(33), napi_id: 13
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 27(39), napi_id: 10
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 32(34), napi_id: 12
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 1(65), napi_id: 10
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 26(40), napi_id: 13
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 37(29), napi_id: 12
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 30(36), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 47(19), napi_id: 14
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 10(56), napi_id: 11
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 44(22), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 17(49), napi_id: 11
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 41(25), napi_id: 13
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 48(18), napi_id: 10
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 2(64), napi_id: 15
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 45(21), napi_id: 14
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 24(42), napi_id: 9
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 34(32), napi_id: 11
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 42(24), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 36(30), napi_id: 16
> [2022-02-17 09:59:10] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 19(47), napi_id: 16
> [2022-02-17 09:59:11] INFO WSBASE/client_established 696
> LWS_CALLBACK_CLIENT_ESTABLISHED client 38(66), napi_id: 11
>
> First number is the thread id (706 and 696). I have 2 threads. 1
> io_uring context per thread.
>
> Next, you have the client id and the number in parenthesis is the
> socket fd.
>
> Based on the result, it appears that having a single napi_id per
> context won't do it... I wish I could pick the brains of the people
> having done things the way they have done it with the epoll
> implementation.
>
> I guess that I could create 8 distinct io_uring context with
> IORING_SETUP_ATTACH_WQ but it seems like a big burden placed on the
> shoulders of users when a simple linked list with ref-counted elements
> could do it...
>
> I think that if I merge your patch with what I have done so far, we
> could get something really cool!
>
> Concerning the remaining problem about when to remove the napi_id, I
> would say that a good place to do it would be when a request is
> completed and discarded if there was a refcount added to your
> napi_entry struct.
>
> The only thing that I hate about this idea is that in my scenario, the
> sockets are going to be pretty much the same for the whole io_uring
> context existance. Therefore, the whole ref counting overhead is
> useless and unneeded.

I remember that now all the completion is in the original task(

should be confirmed again),

so it should be ok to just use simple 'unsigned int count' to show

the number of users of a napi entry. And doing deletion when count

is 0. For your scenario, which is only one napi in a iouring context,

This won't be big overhead as well.

The only thing is we may need to optimize the napi lookup process,

but I'm not sure if it is necessary.


Regards,

Hao

>
> Here is the latest version of my effort:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 77b9c7e4793b..ea2a3661c16f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -63,6 +63,7 @@
>   #include <net/sock.h>
>   #include <net/af_unix.h>
>   #include <net/scm.h>
> +#include <net/busy_poll.h>
>   #include <linux/anon_inodes.h>
>   #include <linux/sched/mm.h>
>   #include <linux/uaccess.h>
> @@ -395,6 +396,10 @@ struct io_ring_ctx {
>   	struct list_head	sqd_list;
>   
>   	unsigned long		check_cq_overflow;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	/* used to track busy poll napi_id */
> +	unsigned int napi_id;
> +#endif
>   
>   	struct {
>   		unsigned		cached_cq_tail;
> @@ -6976,7 +6981,40 @@ static inline struct file
> *io_file_get_fixed(struct io_ring_ctx *ctx,
>   	io_req_set_rsrc_node(req, ctx);
>   	return file;
>   }
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +/*
> + * Set epoll busy poll NAPI ID from sk.
> + */
> +static inline void io_set_busy_poll_napi_id(struct io_ring_ctx *ctx,
> struct file *file)
> +{
> +	unsigned int napi_id;
> +	struct socket *sock;
> +	struct sock *sk;
> +
> +	if (!net_busy_loop_on())
> +		return;
>   
> +	sock = sock_from_file(file);
> +	if (!sock)
> +		return;
> +
> +	sk = sock->sk;
> +	if (!sk)
> +		return;
> +
> +	napi_id = READ_ONCE(sk->sk_napi_id);
> +
> +	/* Non-NAPI IDs can be rejected
> +	 *	or
> +	 * Nothing to do if we already have this ID
> +	 */
> +	if (napi_id < MIN_NAPI_ID || napi_id == ctx->napi_id)
> +		return;
> +
> +	/* record NAPI ID for use in next busy poll */
> +	ctx->napi_id = napi_id;
> +}
> +#endif
>   static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
>   				       struct io_kiocb *req, int fd)
>   {
> @@ -6985,8 +7023,14 @@ static struct file *io_file_get_normal(struct
> io_ring_ctx *ctx,
>   	trace_io_uring_file_get(ctx, fd);
>   
>   	/* we don't allow fixed io_uring files */
> -	if (file && unlikely(file->f_op == &io_uring_fops))
> -		io_req_track_inflight(req);
> +	if (file) {
> +		if (unlikely(file->f_op == &io_uring_fops))
> +			io_req_track_inflight(req);
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +		else
> +			io_set_busy_poll_napi_id(ctx, file);
> +#endif
> +	}
>   	return file;
>   }
>   
> @@ -7489,7 +7533,22 @@ static inline void
> io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
>   		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
>   	spin_unlock(&ctx->completion_lock);
>   }
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +/*
> + * Busy poll if globally on and supporting sockets found
> + */
> +static inline bool io_napi_busy_loop(struct io_ring_ctx *ctx)
> +{
> +	unsigned int napi_id = ctx->napi_id;
>   
> +	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on()) {
> +		napi_busy_loop(napi_id, NULL, NULL, true,
> +			       BUSY_POLL_BUDGET);
> +		return true;
> +	}
> +	return false;
> +}
> +#endif
>   static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>   {
>   	unsigned int to_submit;
> @@ -7518,7 +7577,10 @@ static int __io_sq_thread(struct io_ring_ctx
> *ctx, bool cap_entries)
>   		    !(ctx->flags & IORING_SETUP_R_DISABLED))
>   			ret = io_submit_sqes(ctx, to_submit);
>   		mutex_unlock(&ctx->uring_lock);
> -
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +		if (io_napi_busy_loop(ctx))
> +			++ret;
> +#endif
>   		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
>   			wake_up(&ctx->sqo_sq_wait);
>   		if (creds)
> @@ -7649,6 +7711,9 @@ struct io_wait_queue {
>   	struct io_ring_ctx *ctx;
>   	unsigned cq_tail;
>   	unsigned nr_timeouts;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	unsigned busy_poll_to;
> +#endif
>   };
>   
>   static inline bool io_should_wake(struct io_wait_queue *iowq)
> @@ -7709,6 +7774,29 @@ static inline int io_cqring_wait_schedule(struct
> io_ring_ctx *ctx,
>   	return !*timeout ? -ETIME : 1;
>   }
>   
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +static inline bool io_busy_loop_timeout(unsigned long start_time,
> +					unsigned long bp_usec)
> +{
> +	if (bp_usec) {
> +		unsigned long end_time = start_time + bp_usec;
> +		unsigned long now = busy_loop_current_time();
> +
> +		return time_after(now, end_time);
> +	}
> +	return true;
> +}
> +
> +static bool io_busy_loop_end(void *p, unsigned long start_time)
> +{
> +	struct io_wait_queue *iowq = p;
> +
> +	return io_busy_loop_timeout(start_time, iowq->busy_poll_to) ||
> +	       signal_pending(current) ||
> +	       io_should_wake(iowq);
> +}
> +#endif
> +
>   /*
>    * Wait until events become available, if we don't already have some.
> The
>    * application must reap them itself, as they reside on the shared cq
> ring.
> @@ -7729,12 +7817,33 @@ static int io_cqring_wait(struct io_ring_ctx
> *ctx, int min_events,
>   		if (!io_run_task_work())
>   			break;
>   	} while (1);
> -
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	iowq.busy_poll_to = 0;
> +#endif
>   	if (uts) {
>   		struct timespec64 ts;
>   
>   		if (get_timespec64(&ts, uts))
>   			return -EFAULT;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +		if (!(ctx->flags & IORING_SETUP_SQPOLL) &&
> +		    (ctx->napi_id >= MIN_NAPI_ID) &&
> net_busy_loop_on()) {
> +			unsigned busy_poll_to =
> +				READ_ONCE(sysctl_net_busy_poll);
> +			struct timespec64 pollto =
> +				ns_to_timespec64(1000*busy_poll_to);
> +
> +			if (timespec64_compare(&ts, &pollto) > 0) {
> +				ts = timespec64_sub(ts, pollto);
> +				iowq.busy_poll_to = busy_poll_to;
> +			}
> +			else {
> +				iowq.busy_poll_to =
> timespec64_to_ns(&ts)/1000;
> +				ts.tv_sec = 0;
> +				ts.tv_nsec = 0;
> +			}
> +		}
> +#endif
>   		timeout = timespec64_to_jiffies(&ts);
>   	}
>   
> @@ -7759,6 +7868,11 @@ static int io_cqring_wait(struct io_ring_ctx
> *ctx, int min_events,
>   	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>   
>   	trace_io_uring_cqring_wait(ctx, min_events);
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	if (iowq.busy_poll_to)
> +		napi_busy_loop(ctx->napi_id, io_busy_loop_end, &iowq,
> true,
> +			       BUSY_POLL_BUDGET);
> +#endif
>   	do {
>   		/* if we can't even flush overflow, don't wait for
> more */
>   		if (!io_cqring_overflow_flush(ctx)) {
