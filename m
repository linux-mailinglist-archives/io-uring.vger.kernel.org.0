Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07ED3E54AE
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 09:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbhHJH5w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 03:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236329AbhHJH5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 03:57:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B81AC0613D3;
        Tue, 10 Aug 2021 00:57:29 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628582247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Mza2s0hm1qVtAaBGYnBCXAXHeBZ/4aPM0t6W/sYyXXY=;
        b=fAmwgxXwWSdLPBh3uuJn2ML24/LvHPO3T7WD8eqWgdqm86EhdBiXpiDMzTfbg4gyVYmV9t
        vh9Bs0QxAEoEBbAoO9yhEEUJFGuimwV65o5VdA2lRMiiNqz6IDyZ4Tv23K5y7fOM7x3/Ct
        IHf/TRM/UcUMFTwSP7cgJtZzqqq3EZnseLa/EJn3XzmcV+QdvPVb3+GcepZdhBfkIiGAPq
        Dh5m3LqGdSpuGlKXtMkGjHPk4pGxVXFD+0eaChe3KqmcMb2BQWwnmmLaqP/pfjMaKtmAlk
        WYbaP9R5PBOLRZaBORKstvSwpJdvp7VoxwQQGBXZAq2fRlTKQsNC6UO0HnkFgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628582247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Mza2s0hm1qVtAaBGYnBCXAXHeBZ/4aPM0t6W/sYyXXY=;
        b=bY+arYJmjcY7Ut/HTS6dDzHOoQwD9gKOjY1dIbw7L+zRZhJRD5oASp7A/R5Kw5nsJkh8cY
        xWHoC/BgeHeTJXBA==
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [BUG] io-uring triggered lockdep splat
Date:   Tue, 10 Aug 2021 09:57:26 +0200
Message-ID: <87r1f1speh.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

running 'rsrc_tags' from the liburing tests on v5.14-rc5 triggers the
following lockdep splat:

[  265.866713] ======================================================
[  265.867585] WARNING: possible circular locking dependency detected
[  265.868450] 5.14.0-rc5 #69 Tainted: G            E    
[  265.869174] ------------------------------------------------------
[  265.870050] kworker/3:1/86 is trying to acquire lock:
[  265.870759] ffff88812100f0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_rsrc_put_work+0x142/0x1b0
[  265.871957] 
               but task is already holding lock:
[  265.872777] ffffc900004a3e70 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}, at: process_one_work+0x218/0x590
[  265.874334] 
               which lock already depends on the new lock.

[  265.875474] 
               the existing dependency chain (in reverse order) is:
[  265.876512] 
               -> #1 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}:
[  265.877750]        __flush_work+0x372/0x4f0
[  265.878343]        io_rsrc_ref_quiesce.part.0.constprop.0+0x35/0xb0
[  265.879227]        __do_sys_io_uring_register+0x652/0x1080
[  265.880009]        do_syscall_64+0x3b/0x90
[  265.880598]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  265.881383] 
               -> #0 (&ctx->uring_lock){+.+.}-{3:3}:
[  265.882257]        __lock_acquire+0x1130/0x1df0
[  265.882903]        lock_acquire+0xc8/0x2d0
[  265.883485]        __mutex_lock+0x88/0x780
[  265.884067]        io_rsrc_put_work+0x142/0x1b0
[  265.884713]        process_one_work+0x2a2/0x590
[  265.885357]        worker_thread+0x55/0x3c0
[  265.885958]        kthread+0x143/0x160
[  265.886493]        ret_from_fork+0x22/0x30
[  265.887079] 
               other info that might help us debug this:

[  265.888206]  Possible unsafe locking scenario:

[  265.889043]        CPU0                    CPU1
[  265.889687]        ----                    ----
[  265.890328]   lock((work_completion)(&(&ctx->rsrc_put_work)->work));
[  265.891211]                                lock(&ctx->uring_lock);
[  265.892074]                                lock((work_completion)(&(&ctx->rsrc_put_work)->work));
[  265.893310]   lock(&ctx->uring_lock);
[  265.893833] 
                *** DEADLOCK ***

[  265.894660] 2 locks held by kworker/3:1/86:
[  265.895252]  #0: ffff888100059738 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x218/0x590
[  265.896561]  #1: ffffc900004a3e70 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}, at: process_one_work+0x218/0x590
[  265.898178] 
               stack backtrace:
[  265.898789] CPU: 3 PID: 86 Comm: kworker/3:1 Kdump: loaded Tainted: G            E     5.14.0-rc5 #69
[  265.900072] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
[  265.901195] Workqueue: events io_rsrc_put_work
[  265.901825] Call Trace:
[  265.902173]  dump_stack_lvl+0x57/0x72
[  265.902698]  check_noncircular+0xf2/0x110
[  265.903270]  ? __lock_acquire+0x380/0x1df0
[  265.903889]  __lock_acquire+0x1130/0x1df0
[  265.904462]  lock_acquire+0xc8/0x2d0
[  265.904967]  ? io_rsrc_put_work+0x142/0x1b0
[  265.905596]  ? lock_is_held_type+0xa5/0x120
[  265.906193]  __mutex_lock+0x88/0x780
[  265.906700]  ? io_rsrc_put_work+0x142/0x1b0
[  265.907286]  ? io_rsrc_put_work+0x142/0x1b0
[  265.907877]  ? lock_acquire+0xc8/0x2d0
[  265.908408]  io_rsrc_put_work+0x142/0x1b0
[  265.908976]  process_one_work+0x2a2/0x590
[  265.909544]  worker_thread+0x55/0x3c0
[  265.910061]  ? process_one_work+0x590/0x590
[  265.910655]  kthread+0x143/0x160
[  265.911114]  ? set_kthread_struct+0x40/0x40
[  265.911704]  ret_from_fork+0x22/0x30

Thanks,

        tglx
