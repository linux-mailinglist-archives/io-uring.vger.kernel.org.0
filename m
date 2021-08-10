Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27C3E57B8
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhHJJ7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 05:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbhHJJ7t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 05:59:49 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF93C061798;
        Tue, 10 Aug 2021 02:59:27 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q10so2192656wro.2;
        Tue, 10 Aug 2021 02:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nrbgjy+J0hwnSS2Ng90yTRhZWRCkLTPqhbhkiTM36K8=;
        b=tzECu/9sGhtYCxjGcQH8+zj4h4SbBTWvoKZYVer0rYvWSAXHarAe1LfdUFuBLla8UI
         bGPcWcAK+OFrRHo6abWwcD+6ZyfRmiMGe2s2FNloWACQUD4FvC7i4QiJl2Fn4rpOPPnD
         CFm80m2srnzTW0moXzO3153ZtVhr8LECw8r1BRPqZEWDWBji7XjpmzWm6peH5m38+H78
         tNMoBybhZT4qDBPKd7dCHfQDg1Ti6uXciNMF9VMF/5C5NjQdVsUXb1AKKfG4mWAZUXkz
         AAy+V+jjfXaktt9s0GAFU05CL/tVzkOkzKRyygQJTPOuFj+E1DzENldeX7nnNa8yqD+n
         Im2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nrbgjy+J0hwnSS2Ng90yTRhZWRCkLTPqhbhkiTM36K8=;
        b=ZdJy42MtHVjipW+XfHRTspz7zTziaOxpP8eBJPM6smppg52pP/hXU7WGF1enhLIKMF
         VDKi7+tWGb8LeycjnCWHNNZmY2VsE3YRv8YxqxPo4BxfdaQZ78WLdCPqcu0MwlJGxw2X
         x3TT4YXm+isdQTyOsVzD1axVkx0YSjZ4MsvjeQ6gJ1xcVHHR3o8DFsfrDZ8OmBXp7uXq
         Rc3EAFDPhNsCjcubAxIus7c+z46V9qhYzc6xgwiJxmfSOAivYBkxxF0i7hBpMbB8zYos
         c4BMvrBI7B+JHYdQ0Y+z1Mg8XVfoFmQa3KqiwVwjUJf25YLDkAQD4xHRigsZvQRPSJZS
         /zEQ==
X-Gm-Message-State: AOAM530NzOpko0noYpr5u6+RIpPp/grYbGRl9BJT6G2y0YuqWpCne7MO
        duKDcZQk3FXKGRnltr+qsnA=
X-Google-Smtp-Source: ABdhPJyWVin14dRLcO2iqKYpTS/vjIumCVOOi8J5uOyr2dQBXTfPWhGnRrlTz+S+qIvjS3Zc2TWRyw==
X-Received: by 2002:a5d:4983:: with SMTP id r3mr12314822wrq.232.1628589566075;
        Tue, 10 Aug 2021 02:59:26 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t1sm2321076wma.25.2021.08.10.02.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:59:25 -0700 (PDT)
Subject: Re: [BUG] io-uring triggered lockdep splat
To:     Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <87r1f1speh.ffs@tglx>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <f9260055-745a-4683-083a-a5e18f5ee073@gmail.com>
Date:   Tue, 10 Aug 2021 10:58:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87r1f1speh.ffs@tglx>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 8:57 AM, Thomas Gleixner wrote:
> Jens,
> 
> running 'rsrc_tags' from the liburing tests on v5.14-rc5 triggers the
> following lockdep splat:

Got addressed yesterday, thanks

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.14&id=c018db4a57f3e31a9cb24d528e9f094eda89a499


> [  265.866713] ======================================================
> [  265.867585] WARNING: possible circular locking dependency detected
> [  265.868450] 5.14.0-rc5 #69 Tainted: G            E    
> [  265.869174] ------------------------------------------------------
> [  265.870050] kworker/3:1/86 is trying to acquire lock:
> [  265.870759] ffff88812100f0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_rsrc_put_work+0x142/0x1b0
> [  265.871957] 
>                but task is already holding lock:
> [  265.872777] ffffc900004a3e70 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}, at: process_one_work+0x218/0x590
> [  265.874334] 
>                which lock already depends on the new lock.
> 
> [  265.875474] 
>                the existing dependency chain (in reverse order) is:
> [  265.876512] 
>                -> #1 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}:
> [  265.877750]        __flush_work+0x372/0x4f0
> [  265.878343]        io_rsrc_ref_quiesce.part.0.constprop.0+0x35/0xb0
> [  265.879227]        __do_sys_io_uring_register+0x652/0x1080
> [  265.880009]        do_syscall_64+0x3b/0x90
> [  265.880598]        entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  265.881383] 
>                -> #0 (&ctx->uring_lock){+.+.}-{3:3}:
> [  265.882257]        __lock_acquire+0x1130/0x1df0
> [  265.882903]        lock_acquire+0xc8/0x2d0
> [  265.883485]        __mutex_lock+0x88/0x780
> [  265.884067]        io_rsrc_put_work+0x142/0x1b0
> [  265.884713]        process_one_work+0x2a2/0x590
> [  265.885357]        worker_thread+0x55/0x3c0
> [  265.885958]        kthread+0x143/0x160
> [  265.886493]        ret_from_fork+0x22/0x30
> [  265.887079] 
>                other info that might help us debug this:
> 
> [  265.888206]  Possible unsafe locking scenario:
> 
> [  265.889043]        CPU0                    CPU1
> [  265.889687]        ----                    ----
> [  265.890328]   lock((work_completion)(&(&ctx->rsrc_put_work)->work));
> [  265.891211]                                lock(&ctx->uring_lock);
> [  265.892074]                                lock((work_completion)(&(&ctx->rsrc_put_work)->work));
> [  265.893310]   lock(&ctx->uring_lock);
> [  265.893833] 
>                 *** DEADLOCK ***
> 
> [  265.894660] 2 locks held by kworker/3:1/86:
> [  265.895252]  #0: ffff888100059738 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x218/0x590
> [  265.896561]  #1: ffffc900004a3e70 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}, at: process_one_work+0x218/0x590
> [  265.898178] 
>                stack backtrace:
> [  265.898789] CPU: 3 PID: 86 Comm: kworker/3:1 Kdump: loaded Tainted: G            E     5.14.0-rc5 #69
> [  265.900072] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> [  265.901195] Workqueue: events io_rsrc_put_work
> [  265.901825] Call Trace:
> [  265.902173]  dump_stack_lvl+0x57/0x72
> [  265.902698]  check_noncircular+0xf2/0x110
> [  265.903270]  ? __lock_acquire+0x380/0x1df0
> [  265.903889]  __lock_acquire+0x1130/0x1df0
> [  265.904462]  lock_acquire+0xc8/0x2d0
> [  265.904967]  ? io_rsrc_put_work+0x142/0x1b0
> [  265.905596]  ? lock_is_held_type+0xa5/0x120
> [  265.906193]  __mutex_lock+0x88/0x780
> [  265.906700]  ? io_rsrc_put_work+0x142/0x1b0
> [  265.907286]  ? io_rsrc_put_work+0x142/0x1b0
> [  265.907877]  ? lock_acquire+0xc8/0x2d0
> [  265.908408]  io_rsrc_put_work+0x142/0x1b0
> [  265.908976]  process_one_work+0x2a2/0x590
> [  265.909544]  worker_thread+0x55/0x3c0
> [  265.910061]  ? process_one_work+0x590/0x590
> [  265.910655]  kthread+0x143/0x160
> [  265.911114]  ? set_kthread_struct+0x40/0x40
> [  265.911704]  ret_from_fork+0x22/0x30
> 
> Thanks,
> 
>         tglx
> 

-- 
Pavel Begunkov
