Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB76C406B53
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhIJMYD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 08:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbhIJMYD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 08:24:03 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B73C061756
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 05:22:52 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id f6so2088514iox.0
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 05:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pyFl/0K9PYicWHb+3HWhezULSnmmE6ZLIwp8H683T8A=;
        b=EAwPAuVuvC7q2/1+ejxZqCgZkhQZIQ1RLqZcTU33QBiVpfcdEyMOe1RyxMRD4Jrheq
         Hy7A5NiEfgcCgm3hMiL6d3p7gMa3o8Lm9phn53vFOCAlOf1nsvRPMdLS3jn1krqfA/1D
         gIhMTiVbC0+aZMVgh9eGFYYHi16wbRDu5AnDGa7c2nxSkreYj7+JfuPAJA7ZCNPu1wDa
         hx4W8jLIrGK0bT9Kkh37rN5PfP44RHkmIt2o35puvSE2mrWatUeMRcBVD7HiKkqoQtss
         +TlfDCal9RAFpkjCKtq5hyX2aELeyrR+a3QdXTFn0EHXTYeZTlNbcENzockgzrIiY1X5
         H0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pyFl/0K9PYicWHb+3HWhezULSnmmE6ZLIwp8H683T8A=;
        b=VzW3w32J4l2IOV0c0AMuETTGDiD2ToBEgNSGtA8OcoECnzdUIzsAdnfpm/A6JAnE5G
         NW6KTt3PBIWOqM1lXHE2BN0t1gYKO+EsGeKYENTlBxaUYHz4zgomYn+XAAXTXQBQ5HUu
         J4hsHqNn2qajwV/rAemZjh+6skL/WHbJrSuS+TsxviGsyPDIXahA7+gGcGiVyGbRpUAn
         uDdQPn81IYsvfxjxcWU3HS4uMjCx6mWM53SFX6IlvXXwQZ48DRhZuLgSUrUyjrbcpLJd
         Kvl/ZNsLBvWkqKK3Ki0g3bghz2oDkvL+6Lw2xKRALTxVNKvffF46lErpJUrWJCjwMVny
         GbXw==
X-Gm-Message-State: AOAM532BZcH8xIpXoW7Z1qEvqJBfX2KXxpWDx7SxZ/8fflNkAv3eSaCM
        GGrvBRvqac86OVKCGyLgrQ6tEg==
X-Google-Smtp-Source: ABdhPJzqPSVKanrARM7SyxnvfhdXia3qUhDfR5icYQCEYe3ZLo+l0iLbFbZKUuzotnxcAQS7zi4bzg==
X-Received: by 2002:a6b:e905:: with SMTP id u5mr6634060iof.116.1631276571903;
        Fri, 10 Sep 2021 05:22:51 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p19sm2379669ilj.58.2021.09.10.05.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 05:22:51 -0700 (PDT)
Subject: Re: [PATCH -next v2] io-wq: Fix memory leak in create_io_worker
To:     Bixuan Cui <cuibixuan@huawei.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, john.wanghui@huawei.com
References: <20210910072910.43319-1-cuibixuan@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <813cb232-df7e-bdc4-5e89-9bf5c5be75c1@kernel.dk>
Date:   Fri, 10 Sep 2021 06:22:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210910072910.43319-1-cuibixuan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/10/21 1:29 AM, Bixuan Cui wrote:
> Kmemleak tool detected a memory leak.
> 
> ====================
> unreferenced object 0xffff888126fcd6c0 (size 192):
>   comm "syz-executor.1", pid 11934, jiffies 4294983026 (age 15.690s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81632c91>] kmalloc_node include/linux/slab.h:609 [inline]
>     [<ffffffff81632c91>] kzalloc_node include/linux/slab.h:732 [inline]
>     [<ffffffff81632c91>] create_io_worker+0x41/0x1e0 fs/io-wq.c:739
>     [<ffffffff8163311e>] io_wqe_create_worker fs/io-wq.c:267 [inline]
>     [<ffffffff8163311e>] io_wqe_enqueue+0x1fe/0x330 fs/io-wq.c:866
>     [<ffffffff81620b64>] io_queue_async_work+0xc4/0x200 fs/io_uring.c:1473
>     [<ffffffff8162c59c>] __io_queue_sqe+0x34c/0x510 fs/io_uring.c:6933
>     [<ffffffff8162c7ab>] io_req_task_submit+0x4b/0xa0 fs/io_uring.c:2233
>     [<ffffffff8162cb48>] io_async_task_func+0x108/0x1c0 fs/io_uring.c:5462
>     [<ffffffff816259e3>] tctx_task_work+0x1b3/0x3a0 fs/io_uring.c:2158
>     [<ffffffff81269b43>] task_work_run+0x73/0xb0 kernel/task_work.c:164
>     [<ffffffff812dcdd1>] tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>     [<ffffffff812dcdd1>] handle_signal_work kernel/entry/common.c:146 [inline]
>     [<ffffffff812dcdd1>] exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>     [<ffffffff812dcdd1>] exit_to_user_mode_prepare+0x151/0x180 kernel/entry/common.c:209
>     [<ffffffff843ff25d>] __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>     [<ffffffff843ff25d>] syscall_exit_to_user_mode+0x1d/0x40 kernel/entry/common.c:302
>     [<ffffffff843fa4a2>] do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>     [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> ====================
> 
> If io_should_retry_thread is false in create_io_worker() and
> io_queue_worker_create is false in io_workqueue_create(), free the worker.

A fix for this was already merged:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.15&id=66e70be722886e4f134350212baa13f217e39e42

-- 
Jens Axboe

