Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF7F18E420
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2020 21:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgCUUDa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Mar 2020 16:03:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45925 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgCUUD3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Mar 2020 16:03:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id j10so5216850pfi.12
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2020 13:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VhLHmm7mM/YYfseYUiXhWM3gRNmI2PGmUnaBYcNtVic=;
        b=xJiUaepwPJg9pgeHDP6umTDoui94yJr1IYc7QGE5q0bIJcc+guOGVpRwVOD/xzpRTX
         ZYGWRZnUjSoomXI+BaRiwMjAPYobGpJGnlJvMGn9RpNVZaJv7DXQ56Acnk3L2pZhsvzQ
         QQbqs4+99tAY/0BQuXBQKQATROOpil5J2VIv8FbKLLFcqdcmPPmCvSqbsE1NpirLrPS0
         4XxNGL21cQT16CF6HzqBRhRVNR8PhBGKHMS1gFZV9vY2H/qdrNeN7jD2rYj0xDXScgg8
         fZ7vm7RsqED/olhzdUSENZiCHgUecaVgz1vUBCzc6db2SN5Y2pa0wXidcUK2N9uie0Sh
         dmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VhLHmm7mM/YYfseYUiXhWM3gRNmI2PGmUnaBYcNtVic=;
        b=pwB/+XAWF8CHtBZawbU34UhvhvK5dxmW2RRqc2UEgkKXJ59eAw7qTn77K7XdOuVGt5
         o7YYTIwW64vDL/k8+R+XrfLSsUCMn2QlyLNgrcVgzrpzMw/RBLn7xvkMer6VdNkm9pek
         3Vpn3P7rlXvRwQ94QKKXfa93hyLqhWCYPJ7c/y95ItUs+TNWtToqfUlzamCmicEITkyF
         GjE6nCeWlEfDIRXJL3jHTIfNOmB3lyQgKmOTGFJhys4tLBu2LtHSC8yYozptxMz0yXu8
         +pEwgMh3UnF6Ao7D2V1w+OQ1G6NsHiQ2a7phBgFIwODAv3O2HW7MpPbpx29VIKEiBuMy
         i8Vg==
X-Gm-Message-State: ANhLgQ3FCcNs0L9kXqF1qwrIOgyR6VnLOD/MNvWTOjKNbk5lflG2sYUy
        BS7pkM7NX5zCOPxrx77Rjyt4qg==
X-Google-Smtp-Source: ADFU+vtOWxrQzhUyK0pEnZk0DIoOrKpgtDCrBWOJWKpF6rO20MeJh1dvw/NcATKHA6gKFG0g0QGhrw==
X-Received: by 2002:a65:678e:: with SMTP id e14mr13457598pgr.299.1584821007210;
        Sat, 21 Mar 2020 13:03:27 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e126sm8930914pfa.122.2020.03.21.13.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 13:03:26 -0700 (PDT)
Subject: Re: INFO: task hung in io_queue_file_removal
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+538d1957ce178382a394@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <20200321123827.15256-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5f0ccfab-e5d3-193a-b964-2f909ab6f985@kernel.dk>
Date:   Sat, 21 Mar 2020 14:03:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200321123827.15256-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/20 6:38 AM, Hillf Danton wrote:
> 
> On Fri, 20 Mar 2020 22:50:12 -0700
>> syzbot found the following crash on:
>>
>> HEAD commit:    cd607737 Merge tag '5.6-rc6-smb3-fixes' of git://git.samba..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1730c023e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
>> dashboard link: https://syzkaller.appspot.com/bug?extid=538d1957ce178382a394
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108ebbe3e00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139fb973e00000
>>
>> The bug was bisected to:
>>
>> commit 05f3fb3c5397524feae2e73ee8e150a9090a7da2
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Mon Dec 9 18:22:50 2019 +0000
>>
>>     io_uring: avoid ring quiesce for fixed file set unregister and update
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1237ad73e00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1137ad73e00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1637ad73e00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+538d1957ce178382a394@syzkaller.appspotmail.com
>> Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
>>
>> INFO: task syz-executor975:9880 blocked for more than 143 seconds.
>>       Not tainted 5.6.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> syz-executor975 D27576  9880   9878 0x80004000
>> Call Trace:
>>  schedule+0xd0/0x2a0 kernel/sched/core.c:4154
>>  schedule_timeout+0x6db/0xba0 kernel/time/timer.c:1871
>>  do_wait_for_common kernel/sched/completion.c:83 [inline]
>>  __wait_for_common kernel/sched/completion.c:104 [inline]
>>  wait_for_common kernel/sched/completion.c:115 [inline]
>>  wait_for_completion+0x26a/0x3c0 kernel/sched/completion.c:136
>>  io_queue_file_removal+0x1af/0x1e0 fs/io_uring.c:5826
>>  __io_sqe_files_update.isra.0+0x3a1/0xb00 fs/io_uring.c:5867
>>  io_sqe_files_update fs/io_uring.c:5918 [inline]
>>  __io_uring_register+0x377/0x2c00 fs/io_uring.c:7131
>>  __do_sys_io_uring_register fs/io_uring.c:7202 [inline]
>>  __se_sys_io_uring_register fs/io_uring.c:7184 [inline]
>>  __x64_sys_io_uring_register+0x192/0x560 fs/io_uring.c:7184
>>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x440659
>> Code: Bad RIP value.
>> RSP: 002b:00007ffc4689a358 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
>> RAX: ffffffffffffffda RBX: 00007ffc4689a360 RCX: 0000000000440659
>> RDX: 0000000020000300 RSI: 0000000000000006 RDI: 0000000000000003
>> RBP: 0000000000000005 R08: 0000000000000001 R09: 00007ffc46890031
>> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401f40
>> R13: 0000000000401fd0 R14: 0000000000000000 R15: 0000000000000000
>>
>> Showing all locks held in the system:
>> 1 lock held by khungtaskd/1137:
>>  #0: ffffffff897accc0 (rcu_read_lock){....}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5331
>> 1 lock held by rsyslogd/9761:
>>  #0: ffff8880a8f3ada0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xe3/0x100 fs/file.c:821
>> 2 locks held by getty/9850:
>>  #0: ffff88809fad3090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
>>  #1: ffffc900017bb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
>> 2 locks held by getty/9851:
>>  #0: ffff8880a7b96090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
>>  #1: ffffc900017cb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
>> 2 locks held by getty/9852:
>>  #0: ffff88809e41c090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
>>  #1: ffffc900017eb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
>> 2 locks held by getty/9853:
>>  #0: ffff888090392090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
>>  #1: ffffc900017ab2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
>> 2 locks held by getty/9854:
>>  #0: ffff88809fb1b090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
>>  #1: ffffc900017db2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
>> 2 locks held by getty/9855:
>>  #0: ffff88809a302090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
>>  #1: ffffc9000178b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
>> 2 locks held by getty/9856:
>>  #0: ffff88809d9dc090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
>>  #1: ffffc9000172b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
>> 1 lock held by syz-executor975/9880:
>>  #0: ffff88808f392320 (&ctx->uring_lock){+.+.}, at: __do_sys_io_uring_register fs/io_uring.c:7201 [inline]
>>  #0: ffff88808f392320 (&ctx->uring_lock){+.+.}, at: __se_sys_io_uring_register fs/io_uring.c:7184 [inline]
>>  #0: ffff88808f392320 (&ctx->uring_lock){+.+.}, at: __x64_sys_io_uring_register+0x181/0x560 fs/io_uring.c:7184
>>
>> =============================================
>>
>> NMI backtrace for cpu 1
>> CPU: 1 PID: 1137 Comm: khungtaskd Not tainted 5.6.0-rc6-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>>  nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
>>  nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
>>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>>  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
>>  watchdog+0xa8c/0x1010 kernel/hung_task.c:289
>>  kthread+0x357/0x430 kernel/kthread.c:255
>>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>> Sending NMI from CPU 1 to CPUs 0:
>> NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:60
> 
> Flush work before waiting for completion.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5823,8 +5823,8 @@ static bool io_queue_file_removal(struct
>  
>  	if (pfile == &pfile_stack) {
>  		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
> -		wait_for_completion(&done);
>  		flush_work(&data->ref_work);
> +		wait_for_completion(&done);
>  		return false;
>  	}
>  
> --
> 
> And perhaps a tiny cleanup: no deed to wait for completion as
> flushing work itself will wait until the work is done.

Care to send this version as a real patch? Seems kind of pointless to
just do the above change with that in mind. And then at the same time
turn ->done into ->do_file_put or something, and make it a bool.

-- 
Jens Axboe

