Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DF94C934B
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 19:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiCAScG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Mar 2022 13:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiCAScF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Mar 2022 13:32:05 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317B82AC56;
        Tue,  1 Mar 2022 10:31:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V6-oGAG_1646159479;
Received: from 192.168.31.208(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V6-oGAG_1646159479)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 02:31:20 +0800
Message-ID: <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
Date:   Wed, 2 Mar 2022 02:31:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1646142288.git.olivier@trillion01.com>
 <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
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

Hi Olivier,

On 3/1/22 21:47, Olivier Langlois wrote:
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
> The changes have been tested with this program:
> https://github.com/lano1106/io_uring_udp_ping
>
> and the result is:
> Without sqpoll:
> NAPI busy loop disabled:
> rtt min/avg/max/mdev = 40.631/42.050/58.667/1.547 us
> NAPI busy loop enabled:
> rtt min/avg/max/mdev = 30.619/31.753/61.433/1.456 us
>
> With sqpoll:
> NAPI busy loop disabled:
> rtt min/avg/max/mdev = 42.087/44.438/59.508/1.533 us
> NAPI busy loop enabled:
> rtt min/avg/max/mdev = 35.779/37.347/52.201/0.924 us
>
> Co-developed-by: Hao Xu <haoxu@linux.alibaba.com>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   fs/io_uring.c | 230 +++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 229 insertions(+), 1 deletion(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f7b8df79a02b..37c065786e4b 100644
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
> @@ -395,6 +396,11 @@ struct io_ring_ctx {
>   	struct list_head	sqd_list;
>   
>   	unsigned long		check_cq_overflow;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	/* used to track busy poll napi_id */
> +	struct list_head	napi_list;
> +	spinlock_t		napi_lock;	/* napi_list lock */
> +#endif
>   
>   	struct {
>   		unsigned		cached_cq_tail;
> @@ -1464,6 +1470,10 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	INIT_WQ_LIST(&ctx->locked_free_list);
>   	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>   	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	INIT_LIST_HEAD(&ctx->napi_list);
> +	spin_lock_init(&ctx->napi_lock);
> +#endif
>   	return ctx;
>   err:
>   	kfree(ctx->dummy_ubuf);
> @@ -5399,6 +5409,108 @@ IO_NETOP_FN(send);
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
> +	spin_lock(&ctx->napi_lock);
> +	list_for_each_entry(ne, &ctx->napi_list, list) {
> +		if (ne->napi_id == napi_id) {
> +			ne->timeout = jiffies + NAPI_TIMEOUT;
> +			goto out;
> +		}
> +	}
> +
> +	ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
> +	if (!ne)
> +		goto out;

IMHO, we need to handle -ENOMEM here, I cut off the error handling when

I did the quick coding. Sorry for misleading.

> +
> +	ne->napi_id = napi_id;
> +	ne->timeout = jiffies + NAPI_TIMEOUT;
> +	list_add_tail(&ne->list, &ctx->napi_list);
> +out:
> +	spin_unlock(&ctx->napi_lock);
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
> +static bool io_napi_busy_loop(struct list_head *napi_list)
> +{
> +	struct napi_entry *ne, *n;
> +
> +	list_for_each_entry_safe(ne, n, napi_list, list) {
> +		napi_busy_loop(ne->napi_id, NULL, NULL, true,
> +			       BUSY_POLL_BUDGET);
> +		io_check_napi_entry_timeout(ne);
> +	}
> +	return !list_empty(napi_list);
> +}
> +
> +static void io_free_napi_list(struct io_ring_ctx *ctx)
> +{
> +	spin_lock(&ctx->napi_lock);
> +	while (!list_empty(&ctx->napi_list)) {
> +		struct napi_entry *ne =
> +			list_first_entry(&ctx->napi_list, struct napi_entry,
> +					 list);
> +
> +		list_del(&ne->list);
> +		kfree(ne);
> +	}
> +	spin_unlock(&ctx->napi_lock);
> +}
> +#else
> +static inline void io_add_napi(struct file *file, struct io_ring_ctx *ctx)
> +{
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
> @@ -5545,6 +5657,7 @@ static int io_poll_check_events(struct io_kiocb *req)
>   			if (unlikely(!filled))
>   				return -ECANCELED;
>   			io_cqring_ev_posted(ctx);
> +			io_add_napi(req->file, ctx);
>   		} else if (req->result) {
>   			return 0;
>   		}
> @@ -5777,6 +5890,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   		__io_poll_execute(req, mask);
>   		return 0;
>   	}
> +	io_add_napi(req->file, req->ctx);
>   
>   	/*
>   	 * Release ownership. If someone tried to queue a tw while it was
> @@ -7519,7 +7633,11 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>   		    !(ctx->flags & IORING_SETUP_R_DISABLED))
>   			ret = io_submit_sqes(ctx, to_submit);
>   		mutex_unlock(&ctx->uring_lock);
> -
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +		if (!list_empty(&ctx->napi_list) &&
> +		    io_napi_busy_loop(&ctx->napi_list))

I'm afraid we may need lock for sqpoll too, since io_add_napi() could be 
in iowq context.

I'll take a look at the lock stuff of this patch tomorrow, too late now 
in my timezone.

> +			++ret;
> +#endif
>   		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
>   			wake_up(&ctx->sqo_sq_wait);
>   		if (creds)
> @@ -7650,6 +7768,9 @@ struct io_wait_queue {
>   	struct io_ring_ctx *ctx;
>   	unsigned cq_tail;
>   	unsigned nr_timeouts;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	unsigned busy_poll_to;
> +#endif
>   };
>   
>   static inline bool io_should_wake(struct io_wait_queue *iowq)
> @@ -7711,6 +7832,87 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	return 1;
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
> +		u64 to = timespec64_to_ns(ts);
> +
> +		do_div(to, 1000);
> +		iowq->busy_poll_to = to;
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
> +static void io_blocking_napi_busy_loop(struct list_head *napi_list,
> +				       struct io_wait_queue *iowq)
> +{
> +	unsigned long start_time =
> +		list_is_singular(napi_list) ? 0 :
> +		busy_loop_current_time();
> +
> +	do {
> +		if (list_is_singular(napi_list)) {
> +			struct napi_entry *ne =
> +				list_first_entry(napi_list,
> +						 struct napi_entry, list);
> +
> +			napi_busy_loop(ne->napi_id, io_busy_loop_end, iowq,
> +				       true, BUSY_POLL_BUDGET);
> +			io_check_napi_entry_timeout(ne);
> +			break;
> +		}
> +	} while (io_napi_busy_loop(napi_list) &&
> +		 !io_busy_loop_end(iowq, start_time));
> +}
> +

How about:

if (list is singular) {

     do something;

     return;

}

while (!io_busy_loop_end() && io_napi_busy_loop())

     ;


Btw, start_time seems not used in singular branch.


Regards,

Hao

> +static void io_putback_napi_list(struct io_ring_ctx *ctx,
> +				 struct list_head *napi_list)
> +{
> +	struct napi_entry *cne, *lne;
> +
> +	spin_lock(&ctx->napi_lock);
> +	list_for_each_entry(cne, &ctx->napi_list, list)
> +		list_for_each_entry(lne, napi_list, list)
> +			if (cne->napi_id == lne->napi_id) {
> +				list_del(&lne->list);
> +				kfree(lne);
> +				break;
> +			}
> +	list_splice(napi_list, &ctx->napi_list);
> +	spin_unlock(&ctx->napi_lock);
> +}
> +#endif /* CONFIG_NET_RX_BUSY_POLL */
> +
>   /*
>    * Wait until events become available, if we don't already have some. The
>    * application must reap them itself, as they reside on the shared cq ring.
> @@ -7723,6 +7925,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>   	struct io_rings *rings = ctx->rings;
>   	ktime_t timeout = KTIME_MAX;
>   	int ret;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	LIST_HEAD(local_napi_list);
> +#endif
>   
>   	do {
>   		io_cqring_overflow_flush(ctx);
> @@ -7745,13 +7950,29 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>   			return ret;
>   	}
>   
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	iowq.busy_poll_to = 0;
> +	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
> +		spin_lock(&ctx->napi_lock);
> +		list_splice_init(&ctx->napi_list, &local_napi_list);
> +		spin_unlock(&ctx->napi_lock);
> +	}
> +#endif
>   	if (uts) {
>   		struct timespec64 ts;
>   
>   		if (get_timespec64(&ts, uts))
>   			return -EFAULT;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +		if (!list_empty(&local_napi_list))
> +			io_adjust_busy_loop_timeout(&ts, &iowq);
> +#endif
>   		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
>   	}
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	else if (!list_empty(&local_napi_list))
> +		iowq.busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
> +#endif
>   
>   	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
>   	iowq.wq.private = current;
> @@ -7761,6 +7982,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>   	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>   
>   	trace_io_uring_cqring_wait(ctx, min_events);
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	if (iowq.busy_poll_to)
> +		io_blocking_napi_busy_loop(&local_napi_list, &iowq);
> +	if (!list_empty(&local_napi_list))
> +		io_putback_napi_list(ctx, &local_napi_list);
> +#endif
>   	do {
>   		/* if we can't even flush overflow, don't wait for more */
>   		if (!io_cqring_overflow_flush(ctx)) {
> @@ -9483,6 +9710,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>   	io_req_caches_free(ctx);
>   	if (ctx->hash_map)
>   		io_wq_put_hash(ctx->hash_map);
> +	io_free_napi_list(ctx);
>   	kfree(ctx->cancel_hash);
>   	kfree(ctx->dummy_ubuf);
>   	kfree(ctx);
