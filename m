Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C66F4BD55E
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 06:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbiBUFY0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 00:24:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344488AbiBUFYW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 00:24:22 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375E349F91;
        Sun, 20 Feb 2022 21:23:58 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V5.86GE_1645421035;
Received: from 30.225.24.181(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5.86GE_1645421035)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Feb 2022 13:23:55 +0800
Message-ID: <aee0e905-7af4-332c-57bc-ece0bca63ce2@linux.alibaba.com>
Date:   Mon, 21 Feb 2022 13:23:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/2/19 下午4:03, Olivier Langlois 写道:
> The sqpoll thread can be used for performing the napi busy poll in a
> similar way that it does io polling for file systems supporting direct
> access bypassing the page cache.
> 
> The other way that io_uring can be used for napi busy poll is by
> calling io_uring_enter() to get events.
> 
> If the user specify a timeout value, it is distributed between polling
> and sleeping by using the systemwide setting
> /proc/sys/net/core/busy_poll.
> 
> Co-developed-by: Hao Xu <haoxu@linux.alibaba.com>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   fs/io_uring.c | 194 +++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 192 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 77b9c7e4793b..0ed06f024e79 100644
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
> +	struct list_head	napi_list;
> +#endif
>   
>   	struct {
>   		unsigned		cached_cq_tail;
> @@ -1464,6 +1469,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	INIT_WQ_LIST(&ctx->locked_free_list);
>   	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>   	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
> +	INIT_LIST_HEAD(&ctx->napi_list);
>   	return ctx;
>   err:
>   	kfree(ctx->dummy_ubuf);
> @@ -5398,6 +5404,111 @@ IO_NETOP_FN(send);
>   IO_NETOP_FN(recv);
>   #endif /* CONFIG_NET */
>   
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +
> +#define NAPI_TIMEOUT			(60 * SEC_CONVERSION)
> +
> +struct napi_entry {
> +	struct list_head	list;
> +	unsigned int		napi_id;
> +	unsigned long		timeout;
> +};
> +
> +/*
> + * Add busy poll NAPI ID from sk.
> + */
> +static void io_add_napi(struct file *file, struct io_ring_ctx *ctx)
> +{
> +	unsigned int napi_id;
> +	struct socket *sock;
> +	struct sock *sk;
> +	struct napi_entry *ne;
> +
> +	if (!net_busy_loop_on())
> +		return;
> +
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
> +	/* Non-NAPI IDs can be rejected */
> +	if (napi_id < MIN_NAPI_ID)
> +		return;
> +
> +	list_for_each_entry(ne, &ctx->napi_list, list) {
> +		if (ne->napi_id == napi_id) {
> +			ne->timeout = jiffies + NAPI_TIMEOUT;
> +			return;
> +		}
> +	}
> +
> +	ne = kmalloc(sizeof(*ne), GFP_KERNEL);
> +	if (!ne)
> +		return;
> +
> +	ne->napi_id = napi_id;
> +	ne->timeout = jiffies + NAPI_TIMEOUT;
> +	list_add_tail(&ne->list, &ctx->napi_list);
> +}
> +
> +static inline void io_check_napi_entry_timeout(struct napi_entry *ne)
> +{
> +	if (time_after(jiffies, ne->timeout)) {
> +		list_del(&ne->list);
> +		kfree(ne);
> +	}
> +}
> +
> +/*
> + * Busy poll if globally on and supporting sockets found
> + */
> +static bool io_napi_busy_loop(struct io_ring_ctx *ctx)
> +{
> +	struct napi_entry *ne, *n;
> +
> +	if (list_empty(&ctx->napi_list))
> +		return false;
> +
> +	list_for_each_entry_safe(ne, n, &ctx->napi_list, list) {
> +		napi_busy_loop(ne->napi_id, NULL, NULL, true,
> +			       BUSY_POLL_BUDGET);
> +		io_check_napi_entry_timeout(ne);
> +	}
> +	return !list_empty(&ctx->napi_list);
> +}
> +
> +static void io_free_napi_list(struct io_ring_ctx *ctx)
> +{
> +	while (!list_empty(&ctx->napi_list)) {
> +		struct napi_entry *ne =
> +			list_first_entry(&ctx->napi_list, struct napi_entry,
> +					 list);
> +
> +		list_del(&ne->list);
> +		kfree(ne);
> +	}
> +}
> +#else
> +static inline void io_add_napi(struct file *file, struct io_ring_ctx *ctx)
> +{
> +}
> +
> +static inline bool io_napi_busy_loop(struct io_ring_ctx *ctx)
> +{
> +	return false;
> +}
> +
> +static inline void io_free_napi_list(struct io_ring_ctx *ctx)
> +{
> +}
> +#endif /* CONFIG_NET_RX_BUSY_POLL */
> +
>   struct io_poll_table {
>   	struct poll_table_struct pt;
>   	struct io_kiocb *req;
> @@ -5776,6 +5887,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   		__io_poll_execute(req, mask);
>   		return 0;
>   	}
> +	io_add_napi(req->file, req->ctx);

I think this may not be the right place to do it. the process will be:
arm_poll sockfdA--> get invalid napi_id from sk->napi_id --> event
triggered --> arm_poll for sockfdA again --> get valid napi_id
then why not do io_add_napi() in event
handler(apoll_task_func/poll_task_func).
>   
>   	/*
>   	 * Release ownership. If someone tried to queue a tw while it was
> @@ -7518,7 +7630,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>   		    !(ctx->flags & IORING_SETUP_R_DISABLED))
>   			ret = io_submit_sqes(ctx, to_submit);
>   		mutex_unlock(&ctx->uring_lock);
> -
> +		if (io_napi_busy_loop(ctx))
> +			++ret;
>   		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
>   			wake_up(&ctx->sqo_sq_wait);
>   		if (creds)
> @@ -7649,6 +7762,9 @@ struct io_wait_queue {
>   	struct io_ring_ctx *ctx;
>   	unsigned cq_tail;
>   	unsigned nr_timeouts;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	unsigned busy_poll_to;
> +#endif
>   };
>   
>   static inline bool io_should_wake(struct io_wait_queue *iowq)
> @@ -7709,6 +7825,67 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	return !*timeout ? -ETIME : 1;
>   }
>   
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +static void io_adjust_busy_loop_timeout(struct timespec64 *ts,
> +					struct io_wait_queue *iowq)
> +{
> +	unsigned busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
> +	struct timespec64 pollto = ns_to_timespec64(1000 * (s64)busy_poll_to);
> +
> +	if (timespec64_compare(ts, &pollto) > 0) {
> +		*ts = timespec64_sub(*ts, pollto);
> +		iowq->busy_poll_to = busy_poll_to;
> +	} else {
> +		iowq->busy_poll_to = timespec64_to_ns(ts) / 1000;

How about timespec64_tons(ts) >> 10, since we don't need accurate
number.
> +		ts->tv_sec = 0;
> +		ts->tv_nsec = 0;
> +	}
> +}
> +
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
> +	return signal_pending(current) ||
> +	       io_should_wake(iowq) ||
> +	       io_busy_loop_timeout(start_time, iowq->busy_poll_to);
> +}
> +
> +static void io_blocking_napi_busy_loop(struct io_ring_ctx *ctx,
> +				       struct io_wait_queue *iowq)
> +{
> +	unsigned long start_time =
> +		list_is_singular(&ctx->napi_list) ? 0 :
> +		busy_loop_current_time();
> +
> +	do {
> +		if (list_is_singular(&ctx->napi_list)) {
> +			struct napi_entry *ne =
> +				list_first_entry(&ctx->napi_list,
> +						 struct napi_entry, list);
> +
> +			napi_busy_loop(ne->napi_id, io_busy_loop_end, iowq,
> +				       true, BUSY_POLL_BUDGET);
> +			io_check_napi_entry_timeout(ne);
> +			break;
> +		}
> +	} while (io_napi_busy_loop(ctx) &&

Why don't we setup busy_loop_end callback for normal(non-singular) case,
we can record the number of napi_entry, and divide the time frame to
each entry.
> +		 !io_busy_loop_end(iowq, start_time));
> +}
> +#endif /* CONFIG_NET_RX_BUSY_POLL */
> +
>   /*
>    * Wait until events become available, if we don't already have some. The
>    * application must reap them itself, as they reside on the shared cq ring.
> @@ -7729,12 +7906,20 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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
> +		    !list_empty(&ctx->napi_list)) {
> +			io_adjust_busy_loop_timeout(&ts, &iowq);
> +		}
> +#endif
>   		timeout = timespec64_to_jiffies(&ts);
>   	}
>   
> @@ -7759,6 +7944,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>   	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>   
>   	trace_io_uring_cqring_wait(ctx, min_events);
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	if (iowq.busy_poll_to)
> +		io_blocking_napi_busy_loop(ctx, &iowq);

We may not need locks for the napi_list, the reason is we don't need to
poll an accurate list, the busy polling/NAPI itself is kind of
speculation. So the deletion is not an emergency.
To say the least, we can probably delay the deletion to some safe place
like the original task's task work though this may cause other problems...

Regards,
Hao
> +#endif
>   	do {
>   		/* if we can't even flush overflow, don't wait for more */
>   		if (!io_cqring_overflow_flush(ctx)) {
> @@ -9440,6 +9629,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>   		__io_sqe_files_unregister(ctx);
>   	if (ctx->rings)
>   		__io_cqring_overflow_flush(ctx, true);
> +	io_free_napi_list(ctx);
>   	mutex_unlock(&ctx->uring_lock);
>   	io_eventfd_unregister(ctx);
>   	io_destroy_buffers(ctx);

