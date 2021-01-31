Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC15309F22
	for <lists+io-uring@lfdr.de>; Sun, 31 Jan 2021 22:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhAaVrl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jan 2021 16:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhAaVrh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jan 2021 16:47:37 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC88C061573
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 13:46:56 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id e19so10270090pfh.6
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 13:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0bpqljtiVcH+BHR/dvg1VIeMgoErPS9hih0Dp2JNlLE=;
        b=as+lLywCysNmRCa7svQywQnnkFKaDW4p3xs/1jtX5AINVqOyCw7aaySqPUDzEfiavd
         9RTnLvKB8OxIgRja+X4UNUyPTG//QM+9VoGFqCS9oQrcRnYi75x2bksT8yp6C/l5MD3G
         Utj4d218AOv/T2CQWExoR4cBn8PoqWQzALym491ZwLz+bWIcspszDtR1qKbVDN5N9DRa
         bVIEGotCtZJK5MF1zUVagqR/ruw+i9w3j5ekiDvZKsUBVWSnWJ50PH5rdpgeTI00LLqG
         5pgVKgPGgh6yls/Yp+X7IXZ722rc5lJHFbZjYLLNpIWSYUuJqcTyQ/Gtb250+iKK0SHt
         BKHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0bpqljtiVcH+BHR/dvg1VIeMgoErPS9hih0Dp2JNlLE=;
        b=gJXeI7/3sG/ipe1AAm4kzjl5MJhGT8ymH/dCfmVmV7/2iMVvvkNEkoTcXGFRnFnfiO
         MiXpd+VMm9rqKMxp/xttMN63bDkyfaeF1S+ALqXsBgrvBxECbG4dXpRyqNn2SKUqRrAp
         CxLdwz3nfIiRej+n6rXTCJcEJXBhO4kRnYoxOTaQha+E5CW+OdblpBi3IFKQDhaHks9V
         I6C/O5gNzYjiWATOfYiCJ1V0LiZLh0R0rolw3AdwxWnENYrcuOILM2Du56gQXN1QBfCz
         e+Yg+AQe6A+wNrNL4+qI14746119/t1y7cQfVnXPI59Cw7CiAzvE4yGfMapCNFBuGw7g
         GcmA==
X-Gm-Message-State: AOAM531cvsbK+4jADdKKFaud3SfmRgZFHbim8/p159S7Wx438XLdfoEp
        jh1T8bJnms+UCUbYn6cWb6h9Ew==
X-Google-Smtp-Source: ABdhPJym2JE8IgN1MBy14DX36YT4SnnPdTufp3vAEBR9IHE8T/zABc6QrUwjB/DnLU1nJoqI+cKfYA==
X-Received: by 2002:aa7:814e:0:b029:1bc:fbf8:d286 with SMTP id d14-20020aa7814e0000b02901bcfbf8d286mr13131678pfn.56.1612129616347;
        Sun, 31 Jan 2021 13:46:56 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 197sm15378337pgg.43.2021.01.31.13.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 13:46:55 -0800 (PST)
Subject: Re: [PATCH v3] io_uring: check kthread parked flag before sqthread
 goes to sleep
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612103944-208132-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5950d8be-1965-674b-6859-4fed81ab657f@kernel.dk>
Date:   Sun, 31 Jan 2021 14:46:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1612103944-208132-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/21 7:39 AM, Hao Xu wrote:
> Abaci reported this issue:
> 
> #[  605.170872] INFO: task kworker/u4:1:53 blocked for more than 143 seconds.
> [  605.172123]       Not tainted 5.10.0+ #1
> [  605.172811] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  605.173915] task:kworker/u4:1    state:D stack:    0 pid:   53 ppid:     2 flags:0x00004000
> [  605.175130] Workqueue: events_unbound io_ring_exit_work
> [  605.175931] Call Trace:
> [  605.176334]  __schedule+0xe0e/0x25a0
> [  605.176971]  ? firmware_map_remove+0x1a1/0x1a1
> [  605.177631]  ? write_comp_data+0x2a/0x80
> [  605.178272]  schedule+0xd0/0x270
> [  605.178811]  schedule_timeout+0x6b6/0x940
> [  605.179415]  ? mark_lock.part.0+0xca/0x1420
> [  605.180062]  ? usleep_range+0x170/0x170
> [  605.180684]  ? wait_for_completion+0x16d/0x280
> [  605.181392]  ? mark_held_locks+0x9e/0xe0
> [  605.182079]  ? rwlock_bug.part.0+0x90/0x90
> [  605.182853]  ? lockdep_hardirqs_on_prepare+0x286/0x400
> [  605.183817]  wait_for_completion+0x175/0x280
> [  605.184713]  ? wait_for_completion_interruptible+0x340/0x340
> [  605.185611]  ? _raw_spin_unlock_irq+0x24/0x30
> [  605.186307]  ? migrate_swap_stop+0x9c0/0x9c0
> [  605.187046]  kthread_park+0x127/0x1c0
> [  605.187738]  io_sq_thread_stop+0xd5/0x530
> [  605.188459]  io_ring_exit_work+0xb1/0x970
> [  605.189207]  process_one_work+0x92c/0x1510
> [  605.189947]  ? pwq_dec_nr_in_flight+0x360/0x360
> [  605.190682]  ? rwlock_bug.part.0+0x90/0x90
> [  605.191430]  ? write_comp_data+0x2a/0x80
> [  605.192207]  worker_thread+0x9b/0xe20
> [  605.192900]  ? process_one_work+0x1510/0x1510
> [  605.193599]  kthread+0x353/0x460
> [  605.194154]  ? _raw_spin_unlock_irq+0x24/0x30
> [  605.194910]  ? kthread_create_on_node+0x100/0x100
> [  605.195821]  ret_from_fork+0x1f/0x30
> [  605.196605]
> [  605.196605] Showing all locks held in the system:
> [  605.197598] 1 lock held by khungtaskd/25:
> [  605.198301]  #0: ffffffff8b5f76a0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire.constprop.0+0x0/0x30
> [  605.199914] 3 locks held by kworker/u4:1/53:
> [  605.200609]  #0: ffff888100109938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x82a/0x1510
> [  605.202108]  #1: ffff888100e47dc0 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x85e/0x1510
> [  605.203681]  #2: ffff888116931870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park.part.0+0x19/0x50
> [  605.205183] 3 locks held by systemd-journal/161:
> [  605.206037] 1 lock held by syslog-ng/254:
> [  605.206674] 2 locks held by agetty/311:
> [  605.207292]  #0: ffff888101097098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x27/0x80
> [  605.208715]  #1: ffffc900000332e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x222/0x1bb0
> [  605.210131] 2 locks held by bash/677:
> [  605.210723]  #0: ffff88810419a098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x27/0x80
> [  605.212105]  #1: ffffc900000512e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x222/0x1bb0
> [  605.213777]
> [  605.214151] =============================================
> 
> I believe this is caused by the follow race:
> 
> (ctx_list is empty now)
> => io_put_sq_data               |
> ==> kthread_park(sqd->thread);  |
> ====> set KTHREAD_SHOULD_PARK	|
> ====> wake_up_process(k)        | sq thread is running
> 				|
> 				|
> 				| needs_sched is true since no ctx,
> 				| so TASK_INTERRUPTIBLE set and schedule
> 				| out then never wake up again
> 				|
> ====> wait_for_completion	|
> 	(stuck here)
> 
> So check if sqthread gets park flag right before schedule().
> since ctx_list is always empty when this problem happens, here I put
> kthread_should_park() before setting the wakeup flag(ctx_list is empty
> so this for loop is fast), where is close enough to schedule(). The
> problem doesn't show again in my repro testing after this fix.

Applied, thanks.

-- 
Jens Axboe

