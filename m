Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBCA3FE035
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 18:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbhIAQmg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 12:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245469AbhIAQmd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 12:42:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF895C061575;
        Wed,  1 Sep 2021 09:41:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m4so33348pll.0;
        Wed, 01 Sep 2021 09:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3lCl2Zr4586JDbLss9c1Hxd0EDusuIq7XoCp7hO6f+s=;
        b=m3Y2MP55Y3bNEL27hIHDl3XWn7dr4Z1bU+Luwd0dxdd1NhsNWmuniHYfQxc6eVVuA6
         82IN4oQo6EAZAp0DcliksCcUhUHerSeV1Y67Fb4QDRMjuh6oCc6h7Gkf/1CceA3PNuEu
         ojvOFF2T48OlAWDnb82P4XCf7gfZY4N1hvbcxOgLT2CEkjei7Zn+wkzsL612q5ZnlmZT
         GjU65Zz70GKduLdcxpvIwBpnFQ2kvpHWdU+1P1NfKTlXE4W/5go5W21dZ9WykriCs7oN
         wwym1FkUsSrzuqyrbydk9oHWWSSqOXAzaJJspnPT5CwA88XNP8THGGmqQQycGcXjdoJp
         Ki3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3lCl2Zr4586JDbLss9c1Hxd0EDusuIq7XoCp7hO6f+s=;
        b=YzTMpxXthiiuGOKKaxrZjOQXJlomc/sryEml+0pjVyZQeJl5W0v2nCPVq2dxfGZzad
         M+j90kj6CA4XPWCbfYW5CahQGfPSJFW0QMb+rUxWxgUE9SUKUcQC3IDc9go0hmfcX6Mb
         S8RPNYj5tea8pjUxnl9OYis79kltisft5QugGAofQlaym01zvGHER+JIwBV0HY6JD/M6
         x2gtocBz2hSZHmkRboHD0paq8QnuvA1Gvr9KaJgyY8o0nuYScIxdb+iu6zR2ypIKQCxK
         FdRR17BCHJ6AFb22n7anBEC7AdG70ubt+WstN/ohcN9+4k8HheA4aFNWgMLFBg9sZU3W
         or0g==
X-Gm-Message-State: AOAM533YFP+UgIIiWEQGuS8woxy6pfzN8VHBBUI1+mWxnHX06TNZwdmN
        r+0vG6nepoWSbjw81tkmW90=
X-Google-Smtp-Source: ABdhPJw/OYh09FXV3g9FLZeUbHMfBxxLJ0mQFmV3mGzIW4w6skA/tnNkr8pjpvBw5/YBLxkoAC6kPg==
X-Received: by 2002:a17:90a:1982:: with SMTP id 2mr304644pji.112.1630514496265;
        Wed, 01 Sep 2021 09:41:36 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id s192sm214876pgc.23.2021.09.01.09.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 09:41:35 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 1 Sep 2021 06:41:34 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding
 sqpoll cpu
Message-ID: <YS+tPq1eiQLx4P3M@slm.duckdns.org>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901124322.164238-3-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

On Wed, Sep 01, 2021 at 08:43:22PM +0800, Hao Xu wrote:
> @@ -7112,11 +7113,9 @@ static int io_sq_thread(void *data)
>  
>  	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>  	set_task_comm(current, buf);
> +	if (sqd->sq_cpu != -1 && test_cpu_in_current_cpuset(sqd->sq_cpu))
>  		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
> +

Would it make sense to just test whether set_cpus_allowed_ptr() succeeded
afterwards?

> @@ -8310,8 +8309,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>  			int cpu = p->sq_thread_cpu;
>  
>  			ret = -EINVAL;
> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
> +			    !test_cpu_in_current_cpuset(cpu))
>  				goto err_sqpoll;
> +

Failing operations on transient conditions like this may be confusing. Let's
ignore cpuset for now. CPU hotplug is sometimes driven automatically for
power saving purposes, so failing operation based on whether a cpu is online
means that the success or failure of the operation can seem arbitrary. If
the operation takes place while the cpu happens to be online, it succeeds
and the thread gets unbound and rebound automatically as the cpu goes
offline and online. If the operation takes place while the cpu happens to be
offline, the operation fails.

I don't know what the intended behavior here should be and we haven't been
pretty bad at defining reasonable behavior around cpu hotplug, so it'd
probably be worthwhile to consider what the behavior should be.

Thanks.

-- 
tejun
