Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE77B157D
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 10:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjI1IBd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 04:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjI1IBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 04:01:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A49997;
        Thu, 28 Sep 2023 01:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Pse9Z+N4XlTYomnLZ/c/AzQ6F1EPTLngwTiS8AhkwVM=; b=wAea2Si11Soip4KcRtIzGqAym/
        /tII41chyhGhRkmeymXBGGA79r6ggZ6FiRM5sZi3yEQuxT0/VCG1pyKlQxtAKr+nsc9+Yeiwb4/rk
        zc8zQyFsKDAHncUYF1HLwWDC0QpFA33umWWPNBER8Z0G6gzQcK9kMLPpW9kriXZcKn/8ou1qQGjwu
        xAiNPX/iBKDkvrTRauG96nxrN1FS5E5etSgN3kMp+LKka82LXi3mHvbp5WAhqHmXlQITypoJV8R2P
        gdwRPNK63l2nT+Rt62o/XFoToIctA4lzj8SzlekHfG8A3P8I+0DuwWltfEQRUG84P9b0UX4CUSEZg
        D1HSIn6w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qllxS-001Jhm-TW; Thu, 28 Sep 2023 08:01:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9202E3002E3; Thu, 28 Sep 2023 10:01:14 +0200 (CEST)
Date:   Thu, 28 Sep 2023 10:01:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xiaobing Li <xiaobing.li@samsung.com>
Cc:     mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, axboe@kernel.dk,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com
Subject: Re: [PATCH 3/3] IO_URING: Statistics of the true utilization of sq
 threads.
Message-ID: <20230928080114.GC9829@noisy.programming.kicks-ass.net>
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
 <CGME20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8@epcas5p2.samsung.com>
 <20230928022228.15770-4-xiaobing.li@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928022228.15770-4-xiaobing.li@samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 28, 2023 at 10:22:28AM +0800, Xiaobing Li wrote:
> Since the sq thread has a while(1) structure, during this process, there
> may be a lot of time that is not processing IO but does not exceed the
> timeout period, therefore, the sqpoll thread will keep running and will
> keep occupying the CPU. Obviously, the CPU is wasted at this time;Our
> goal is to count the part of the time that the sqpoll thread actually
> processes IO, so as to reflect the part of the CPU it uses to process
> IO, which can be used to help improve the actual utilization of the CPU
> in the future.
> 
> Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
> ---
>  io_uring/sqpoll.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index bd6c2c7959a5..2c5fc4d95fa8 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -11,6 +11,7 @@
>  #include <linux/audit.h>
>  #include <linux/security.h>
>  #include <linux/io_uring.h>
> +#include <linux/time.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -235,6 +236,10 @@ static int io_sq_thread(void *data)
>  		set_cpus_allowed_ptr(current, cpu_online_mask);
>  
>  	mutex_lock(&sqd->lock);
> +	bool first = true;
> +	struct timespec64 ts_start, ts_end;
> +	struct timespec64 ts_delta;
> +	struct sched_entity *se = &sqd->thread->se;
>  	while (1) {
>  		bool cap_entries, sqt_spin = false;
>  
> @@ -243,7 +248,16 @@ static int io_sq_thread(void *data)
>  				break;
>  			timeout = jiffies + sqd->sq_thread_idle;
>  		}
> -
> +		ktime_get_boottime_ts64(&ts_start);
> +		ts_delta = timespec64_sub(ts_start, ts_end);
> +		unsigned long long now = ts_delta.tv_sec * NSEC_PER_SEC + ts_delta.tv_nsec +
> +		se->sq_avg.last_update_time;
> +
> +		if (first) {
> +			now = 0;
> +			first = false;
> +		}
> +		__update_sq_avg_block(now, se);
>  		cap_entries = !list_is_singular(&sqd->ctx_list);
>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>  			int ret = __io_sq_thread(ctx, cap_entries);
> @@ -251,6 +265,16 @@ static int io_sq_thread(void *data)
>  			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
>  				sqt_spin = true;
>  		}
> +
> +		ktime_get_boottime_ts64(&ts_end);
> +		ts_delta = timespec64_sub(ts_end, ts_start);
> +		now = ts_delta.tv_sec * NSEC_PER_SEC + ts_delta.tv_nsec +
> +		se->sq_avg.last_update_time;
> +
> +		if (sqt_spin)
> +			__update_sq_avg(now, se);
> +		else
> +			__update_sq_avg_block(now, se);
>  		if (io_run_task_work())
>  			sqt_spin = true;
>  

All of this is quite insane, but the above is actually broken. You're
using wall-time to measure runtime of a preemptible thread.

On top of that, for extra insanity, you're using the frigging insane
timespec interface, because clearly the _ns() interfaces are too
complicated or something?

And that whole first thing is daft too, pull now out of the loop and
set it before, then all that goes away.

Now, I see what you're trying to do, but who actually uses this data?

Finally, please don't scream in the subject :/
