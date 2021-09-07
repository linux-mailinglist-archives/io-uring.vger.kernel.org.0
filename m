Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F03F402D3D
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 18:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344982AbhIGQzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 12:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbhIGQzv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 12:55:51 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B65C061575;
        Tue,  7 Sep 2021 09:54:44 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f65so5064972pfb.10;
        Tue, 07 Sep 2021 09:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7X+MAD+O4i6lx7LuI7hH2on7g8eQNGgU/wJ36NpdYh4=;
        b=eubzwKVVC4VzgcIyTRLt0pLO0CCnZWAqROHlGfIrLGLWAWPaAY7wEQANFU9gvN95Qe
         +TOfD7/ccTYy+P00LLTJhWiJEa6BwfYgmPrrKECC5dS/vWSv30uJpL8oAQE4J2kM6B5q
         yxFR37qDVhzUg/OrwyaRADeaW5QiTucbod20aglj3guXezrQML+P6UJAc/3AsDO6LWRC
         cgtdRKlH8zoxr2XXhyl9p1k9vyODaGdEhhB8Ey5p6RQ1eTziKxQgcLkjMGT/l1g92HsS
         00FJ7AZANZADEmq2sKjR4xKRVbWuYS72GmV36DO2FYswoL9oeTTNIFs070pXCwdbk2lD
         ++EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7X+MAD+O4i6lx7LuI7hH2on7g8eQNGgU/wJ36NpdYh4=;
        b=JqCQBNPJKgKR+cfyO8Ca5dLfUu9Tmwdv/SECIDe/VYfTz5COyY3V+7AsCSC8oPbezL
         9aJmR+s11vWyTF6F1Zri1zaXoRtAtPzLpjW1p/9bvGNvmcAJzOriSssdFakyt7+lykTR
         uSCM4J3vRS+uM+Asu0HRfK17AN+eZcon8oR/Enj+VyUCKvUcRSxwbHMik62/sKTomDVZ
         VgSZY0F/xQpd6kNAKHkJE3bHOtJwWeGfk4JxFX4dQ8+CicEysYxxEqVy/8qM0CF/R0E1
         8VDaRxn19eI4V6cfDUCM+qxLpLg6z1AgCSJeEzBLnF2e/ahtQuSYy3AVBkMXVNWvs95V
         bwhA==
X-Gm-Message-State: AOAM531XFt7uRtBQFlbtOF2uEsUu43C32sy0GJjoT02uxsvmNV7Ui1kO
        aviltJtSrgi+W+iO03U2ZCRpCSLeHmY=
X-Google-Smtp-Source: ABdhPJx4ILtH1Nn3AA8DM/7Ij5iNIm7H/i7jcwyo5BKZeSR60Ctoaal5gRh+e6HPAfvfkeUdsLXfmA==
X-Received: by 2002:a05:6a00:882:b0:416:3ddd:afae with SMTP id q2-20020a056a00088200b004163dddafaemr2409333pfj.72.1631033684164;
        Tue, 07 Sep 2021 09:54:44 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id u2sm2963486pjv.10.2021.09.07.09.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 09:54:43 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 7 Sep 2021 06:54:42 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding
 sqpoll cpu
Message-ID: <YTeZUnshr+mgf5GS@slm.duckdns.org>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
 <YS+tPq1eiQLx4P3M@slm.duckdns.org>
 <c49d9b26-1c74-316a-c933-e6964695a286@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c49d9b26-1c74-316a-c933-e6964695a286@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

On Fri, Sep 03, 2021 at 11:04:07PM +0800, Hao Xu wrote:
> > Would it make sense to just test whether set_cpus_allowed_ptr() succeeded
> > afterwards?
> Do you mean: if (sqd->sq_cpu != -1 && !set_cpus_allowed_ptr(current,
> cpumask_of(sqd->sq_cpu)))
> 
> I'm not familiar with set_cpus_allowed_ptr(), you mean it contains the
> similar logic of test_cpu_in_current_cpuset?

It's kinda muddy unfortunately. I think it rejects if the target cpu is
offline but accept and ignores if the cpu is excluded by cpuset.

> This is a bit beyond of my knowledge, so you mean if the cpu back
> online, the task will automatically schedule to this cpu? if it's true,
> I think the code logic here is fine.
>
> > offline and online. If the operation takes place while the cpu happens to be
> > offline, the operation fails.
> It's ok that it fails, we leave the option of retry to users themselves.

I think the first thing to do is defining the desired behavior, hopefully in
a consistent manner, rather than letting it be defined by implementation.
e.g. If the desired behavior is the per-cpu helper failing, then it should
probably exit when the target cpu isn't available for whatever reason. If
the desired behavior is best effort when cpu goes away (ie. ignore
affinity), the creation likely shouldn't fail when the target cpu is
unavailable but can become available in the future.

Thanks.

-- 
tejun
