Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD13F9E04
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 19:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhH0R0x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 13:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhH0R0w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 13:26:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A866C061757;
        Fri, 27 Aug 2021 10:26:03 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u15so4330516plg.13;
        Fri, 27 Aug 2021 10:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JexU7pxLZh7dMrL0m6OI3CAh+vKRYotj43WZBu/Ai/M=;
        b=VInnHdsRt8LuVmniN9Y4sXNbMaVM8sWuIIwu0Kl5P7zmaTdTFC9Z9vUrnwPa6aujcT
         +T9xfC3lBEJNM0IjEdcdxaWsr0YxqQy4CL1LvP6XZOAECIEUOiQ3HBiwUQrNhITef2FH
         MRMJJ/j22tkoT95SIk+tzjYIIQx7Ubhb8jw/5T+2w1ykCqjYH3PF8+GwodNUy5pHza42
         DcMMAw+bPX2VET+gAZyrS3p4TmIOdcvT3r0jmdRQjicuthvWPavG5kOAP0D4DUMpNhBK
         dI5eTuSAmKwZPNTLWC3in791lzjiJplOm9FblTLRQtGB3UZjKVba1nbGZXHfY18/unqm
         vGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JexU7pxLZh7dMrL0m6OI3CAh+vKRYotj43WZBu/Ai/M=;
        b=kTotUmPlwFwKJYzWUrE3IuslBRc5VpGE6OY+Z2BVd/a9e1S8KyYWH9k/VPSHqzuSdK
         uaQmJKmBxP73sxpxzennrlV69E6lrfkgBjFH5dM+igrglXdzb48K5j+7F3X+Bva+8Skq
         LwQ4HWm/zNDpgZgzDtQ6jbULljXHjBXY+YzXd8aBxhu+jcgwFEXWxmZIoUnzScVeECZ8
         6VslcZnlYmXd4FjKVdeK/zHp988/EV29kpzCxiSTzdC3WbQ8wbx5v9lUAckkTWfOlWi1
         o7/6IcnyMAZETVFlnkckOSoM3LvK7Xisbxg+AXdWl6ZBxFub2AWJHzA1ZFfbbfGsZ9tw
         /gpg==
X-Gm-Message-State: AOAM532v4OnLDBFSl/YYbMOHk2ZEue7x0OwQjw33J3GxbUCECeFmtI0z
        sSnl4iBvr3G3m8VL/p5NuIA=
X-Google-Smtp-Source: ABdhPJzSSG08vW1lkdoGvaFHvB/nG/GNObsGh6u7V+AV2vyfJqHFy8rrAqIL1KXDFtm9duH6Qm31vA==
X-Received: by 2002:a17:902:b691:b029:12d:2b6:d116 with SMTP id c17-20020a170902b691b029012d02b6d116mr9601456pls.71.1630085162522;
        Fri, 27 Aug 2021 10:26:02 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id 26sm8919833pgx.72.2021.08.27.10.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:26:02 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 27 Aug 2021 07:26:00 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH for-5.15 v2] io_uring: consider cgroup setting when
 binding sqpoll cpu
Message-ID: <YSkgKN/LviOvmeVH@slm.duckdns.org>
References: <20210827141315.235974-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827141315.235974-1-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

On Fri, Aug 27, 2021 at 10:13:15PM +0800, Hao Xu wrote:
> +static int io_sq_bind_cpu(int cpu)
> +{
> +	if (!test_cpu_in_current_cpuset(cpu))
> +		pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
> +	else
> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> +
> +	return 0;
> +}
...
> @@ -8208,8 +8217,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>  			int cpu = p->sq_thread_cpu;
>  
>  			ret = -EINVAL;
> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
> +			    !test_cpu_in_current_cpuset(cpu))
>  				goto err_sqpoll;

Given that sq_thread is user-like thread and belongs to the right cgroup,
I'm not quite sure what the above achieves - the affinities can break
anytime, so one-time check doesn't really solve the problem. All it seems to
add is warning messages. What's the expected behavior when an io thread
can't run on the target cpu anymore?

Thanks.

-- 
tejun
