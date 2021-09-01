Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC103FDAAC
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 15:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245064AbhIAMd6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 08:33:58 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40764 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244893AbhIAMc0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 08:32:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Umvgbpc_1630499486;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Umvgbpc_1630499486)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Sep 2021 20:31:27 +0800
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding sqpoll
 cpu
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210901101833.69535-1-haoxu@linux.alibaba.com>
 <20210901101833.69535-3-haoxu@linux.alibaba.com>
Message-ID: <bd6e3eef-b4ba-b185-f8bc-23f8b5886235@linux.alibaba.com>
Date:   Wed, 1 Sep 2021 20:31:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901101833.69535-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/1 下午6:18, Hao Xu 写道:
> Since sqthread is userspace like thread now, it should respect cgroup
> setting, thus we should consider current allowed cpuset when doing
> cpu binding for sqthread.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7cc458e0b636..414dfedf79a7 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -79,6 +79,7 @@
>   #include <linux/pagemap.h>
>   #include <linux/io_uring.h>
>   #include <linux/tracehook.h>
> +#include <linux/cpuset.h>
>   
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/io_uring.h>
> @@ -7102,6 +7103,14 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
>   	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>   }
>   
> +static inline int io_sq_bind_cpu(int cpu)
> +{
> +	if (test_cpu_in_current_cpuset(cpu))
> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> +
> +	return 0;
Ah, no need to return value anymore, even no need to have this function
here. I'll resend a new version.
> +}
> +
>   static int io_sq_thread(void *data)
>   {
>   	struct io_sq_data *sqd = data;
> @@ -7112,11 +7121,9 @@ static int io_sq_thread(void *data)
>   
>   	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>   	set_task_comm(current, buf);
> -
>   	if (sqd->sq_cpu != -1)
> -		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
> -	else
> -		set_cpus_allowed_ptr(current, cpu_online_mask);
> +		io_sq_bind_cpu(sqd->sq_cpu);
> +
>   	current->flags |= PF_NO_SETAFFINITY;
>   
>   	mutex_lock(&sqd->lock);
> @@ -8310,8 +8317,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>   			int cpu = p->sq_thread_cpu;
>   
>   			ret = -EINVAL;
> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
> +			    !test_cpu_in_current_cpuset(cpu))
>   				goto err_sqpoll;
> +
>   			sqd->sq_cpu = cpu;
>   		} else {
>   			sqd->sq_cpu = -1;
> 

