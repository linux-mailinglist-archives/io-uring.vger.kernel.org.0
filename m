Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9F434299A
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 02:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhCTBYv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 21:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCTBYv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 21:24:51 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA54AC061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 18:24:50 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o2so3731478plg.1
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 18:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Nr81zDaX5gTwPPGBr4M07M4h3CvweqgJjllHOrL8ZMA=;
        b=o5ZFFqgel5h3KKWNa1aj1khML2X5xb2LsbhAwuXMHvKe87Z7zvzwo31unq7tfht5lQ
         dVUWP5mBW3jwnJLHCe05rXxJtdM2yKChb6tTw7c5otj2FOriofcYfnJCnAZEdbpCFgDD
         74QfqZMyukqIrGMfh9aaIPhyd7lgU4B9RZUm5yhfkSUtI0gGHKfuSYMpbpFEd6hE9VqD
         ZgW7vfuIywjISQ5nasfyKj6v/6qR5FKy+wXcO3pvyurJsUttKdhyQBWdjkEIoxsNCctA
         Si0TyJecTz2Z2Xy7WGfC8siwSi39xnW38blLAQOPnhmxgIGsM9/8zMqFotDHytcEZAZa
         bUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nr81zDaX5gTwPPGBr4M07M4h3CvweqgJjllHOrL8ZMA=;
        b=hunbMsFN7S7YqlP3l+JurfEX4lpjDltdDi45ZM+pR0GR1610FuICmC8VvLjNvSGD2X
         nFywvvLfaA/uU2VULO8z/zs3s5uyB23rBOh+m2rqNhI8/h9VeXjuXD2I/4MQJItwL2tK
         UGO2ck/l9QMa4RciJQi+EPY66c5X6a10nrZI6oN6JJzNbehQm1c+KfQZL2eh/pJUehhr
         tpW42E4m60RmwNhQKwop5BBUH5oNocLo8BVkPzO9LCgKXow6xHH6vbKIqaAWRZUI8kSI
         szfzxyho3JTnfaeR7iLeBc2GJoKdNz1762Ux+uS5Lwtq9nRvdRoOPaLNxRfSxMUH3dZU
         yo0A==
X-Gm-Message-State: AOAM5320cKKQbAw04jZOvKbxDuXsppLrtSo221+TDJXdLPRgsVh3FrbE
        HIoWnkkmZekxGKJKTV3XJPyERLBiivLDhQ==
X-Google-Smtp-Source: ABdhPJzOH1J+CxNSdRdy0eZBfnQDS0wq7b3+8alMdvGLd2UDxOygMmnAfFU5t6HA89upcTZA7XFOjg==
X-Received: by 2002:a17:902:e889:b029:e6:4c9:ef02 with SMTP id w9-20020a170902e889b02900e604c9ef02mr16819521plg.1.1616203490012;
        Fri, 19 Mar 2021 18:24:50 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id na8sm6081573pjb.2.2021.03.19.18.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 18:24:49 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] Complete setup before calling wake_up_new_task()
 and improve task->comm
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
 <cover.1616197787.git.metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <61c5e1b6-210e-fb04-5afa-4b12c3a22daa@kernel.dk>
Date:   Fri, 19 Mar 2021 19:24:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1616197787.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/19/21 6:00 PM, Stefan Metzmacher wrote:
> Hi,
> 
> now that we have an explicit wake_up_new_task() in order to start the
> result from create_io_thread(), we should things up before calling
> wake_up_new_task().
> 
> There're also some improvements around task->comm:
> - We return 0 bytes for /proc/<pid>/cmdline
> 
> While doing this I noticed a few places we check for
> PF_KTHREAD, but not PF_IO_WORKER, maybe we should
> have something like a PS_IS_KERNEL_THREAD_MASK() macro
> that should be used in generic places and only
> explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
> difference matters.
> 
> There are also quite a number of cases where we use
> same_thread_group(), I guess these need to be checked.
> Should that return true if userspace threads and their iothreds
> are compared?

Any particular ones you are worried about here?

> I did some basic testing and found the problems I explained here:
> https://lore.kernel.org/io-uring/F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk/T/#t
> They appear with and without my changes.
> 
> Changes in v2:
> 
> - I dropped/deferred these changes:
>   - We no longer allow a userspace process to change
>     /proc/<pid>/[task/<tid>]/comm
>   - We dynamically generate comm names (up to 63 chars)
>     via io_wq_worker_comm(), similar to wq_worker_comm()
> 
> Stefan Metzmacher (5):
>   kernel: always initialize task->pf_io_worker to NULL
>   io_uring: io_sq_thread() no longer needs to reset
>     current->pf_io_worker
>   io-wq: call set_task_comm() before wake_up_new_task()
>   io_uring: complete sq_thread setup before calling wake_up_new_task()
>   fs/proc: hide PF_IO_WORKER in get_task_cmdline()
> 
>  fs/io-wq.c     | 17 +++++++++--------
>  fs/io_uring.c  | 22 +++++++++++-----------
>  fs/proc/base.c |  3 +++
>  kernel/fork.c  |  1 +
>  4 files changed, 24 insertions(+), 19 deletions(-)

I don't disagree with any of this, but view them more as cleanups than
fixes. In which case I think 5.13 is fine, and that's where they should
go. That seems true for both the first two fixes, and the comm related
ones too.

If you don't agree, can you detail why? The comm changes seem fine, but
doesn't change the visible name. We can make it wider, sure, but any
reason to?

-- 
Jens Axboe

