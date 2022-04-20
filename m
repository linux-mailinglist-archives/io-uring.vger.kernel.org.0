Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A1E508848
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 14:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355156AbiDTMlp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 08:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348722AbiDTMlo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 08:41:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D242165BC;
        Wed, 20 Apr 2022 05:38:58 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k22so2102185wrd.2;
        Wed, 20 Apr 2022 05:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Lyugb7hK5Jyi9ZE/LqI1rc9rEuWbTrV1cKormgPrnmc=;
        b=DWEj/rXEv3CJiID4KCHWcF5PaTZeSLtlf7vp6wT9htMKClztzmfrdUGUGxxdtMoYvC
         nEpkXZBZB6mldPZ7WmOTRWcNq2uUGbO5LDXSFaeW6cWcHHIrSgN8DUf1QBp7Yf9Mm7b8
         zjz1RFUGB9pfgjd0oa+0w0R1xxHTxyjuhvo2lCeVLDeyDlvnZt2pgfmoX+8cOqczqjY3
         xSU5CBnQobX/06DL1IP1mqbZy0wubV65cpigb70HABsmrJobA6MlFBqeOduPu/Wgwg3L
         avzgy9uM7u7DKNRI2sd6ettGuRmF1C54VeKOXZC9/jnWBUnR5XiGxwMU4d/z/LC+r03+
         37Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lyugb7hK5Jyi9ZE/LqI1rc9rEuWbTrV1cKormgPrnmc=;
        b=IjgJSB4jHJWR6+2B85ZVJUJ4NeT1O4vnDChhjlsyNgxQHodKyNpYYg+KNlqWYLADtf
         jpIUuI4KNKMZgjfVcxjckFuENg4YgQNvBdmbboRpuhuybhwK3YTmcXBN+A6aj8KdFsgk
         kx4qDS0Yp0Mb4VPWy9jx2z5jMUzCAgMiibK2nNb1xvzKxcqZ778J5D7bb9EuxOTl0x2A
         4cALraS03Ry2P1Nlk+/fYj4PYIxFycUK9OK4ObFw4Sua6VlevVu3W16D11/n7YmIP2bW
         ou4e65HjwnoSk/3C3nqonJclWHcsDkJh8B/OweV5BQfRDhauFTgYcqp6Jmr2g/+Rpe+0
         qEzQ==
X-Gm-Message-State: AOAM531gfwlfDYscdsQSXGxmJY2GizYIhQHjVDrr1tOsIgd1iEtNuRYD
        YD0khN7BT0Rbii9QPon+xb3/igR99t8=
X-Google-Smtp-Source: ABdhPJyNd+KwjyV7BT9cbu2SHm2c2PAnD/ABSne9Qmy0HiTZqI8Z4DucOMXzq+UQvvmHRHCQvQhudQ==
X-Received: by 2002:adf:a35c:0:b0:207:aace:b28e with SMTP id d28-20020adfa35c000000b00207aaceb28emr15024777wrb.233.1650458336808;
        Wed, 20 Apr 2022 05:38:56 -0700 (PDT)
Received: from [192.168.43.77] (82-132-244-154.dab.02.net. [82.132.244.154])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm21299910wmq.35.2022.04.20.05.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 05:38:56 -0700 (PDT)
Message-ID: <9ac31ca6-7141-74c0-a22b-4d908839d8e7@gmail.com>
Date:   Wed, 20 Apr 2022 13:38:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [syzbot] possible deadlock in io_disarm_next
Content-Language: en-US
To:     syzbot <syzbot+57e67273f92d7f5f1931@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000626ce805dd13108c@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000626ce805dd13108c@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/22 11:00, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    634de1db0e9b Add linux-next specific files for 20220419
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c92db8f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bbd6f9b0a89865b0
> dashboard link: https://syzkaller.appspot.com/bug?extid=57e67273f92d7f5f1931
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a02f68f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138e3008f00000
> 
> The issue was bisected to:
> 
> commit 78bfbdd1a4977df1dded20f9783a6ec174e67ef8
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Apr 15 21:08:23 2022 +0000
> 
>      io_uring: kill io_put_req_deferred()

#syz test: https://github.com/isilence/linux.git syz_timeout_deadlock



> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13039c0cf00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10839c0cf00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17039c0cf00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+57e67273f92d7f5f1931@syzkaller.appspotmail.com
> Fixes: 78bfbdd1a497 ("io_uring: kill io_put_req_deferred()")
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.18.0-rc3-next-20220419-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor162/3588 is trying to acquire lock:
> ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:379 [inline]
> ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: io_disarm_next+0x545/0xaa0 fs/io_uring.c:2452
> 
> but task is already holding lock:
> ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:379 [inline]
> ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: io_kill_timeouts+0x4c/0x227 fs/io_uring.c:10432
> 
> other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&ctx->timeout_lock);
>    lock(&ctx->timeout_lock);
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation
> 
> 2 locks held by syz-executor162/3588:
>   #0: ffff888011a45398 (&ctx->completion_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>   #0: ffff888011a45398 (&ctx->completion_lock){+.+.}-{2:2}, at: io_kill_timeouts+0x38/0x227 fs/io_uring.c:10431
>   #1: ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:379 [inline]
>   #1: ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: io_kill_timeouts+0x4c/0x227 fs/io_uring.c:10432
> 
> stack backtrace:
> CPU: 1 PID: 3588 Comm: syz-executor162 Not tainted 5.18.0-rc3-next-20220419-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   print_deadlock_bug kernel/locking/lockdep.c:2988 [inline]
>   check_deadlock kernel/locking/lockdep.c:3031 [inline]
>   validate_chain kernel/locking/lockdep.c:3816 [inline]
>   __lock_acquire.cold+0x1f5/0x3b4 kernel/locking/lockdep.c:5053
>   lock_acquire kernel/locking/lockdep.c:5665 [inline]
>   lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
>   __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
>   _raw_spin_lock_irq+0x32/0x50 kernel/locking/spinlock.c:170
>   spin_lock_irq include/linux/spinlock.h:379 [inline]
>   io_disarm_next+0x545/0xaa0 fs/io_uring.c:2452
>   __io_req_complete_post+0x794/0xd90 fs/io_uring.c:2200
>   io_kill_timeout fs/io_uring.c:1815 [inline]
>   io_kill_timeout+0x210/0x21d fs/io_uring.c:1803
>   io_kill_timeouts+0xe2/0x227 fs/io_uring.c:10435
>   io_ring_ctx_wait_and_kill+0x1eb/0x360 fs/io_uring.c:10462
>   io_uring_release+0x42/0x46 fs/io_uring.c:10483
>   __fput+0x277/0x9d0 fs/file_table.c:317
>   task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>   exit_task_work include/linux/task_work.h:37 [inline]
>   do_exit+0xaff/0x2a00 kernel/exit.c:796
>   do_group_exit+0xd2/0x2f0 kernel/exit.c:926
>   __do_sys_exit_group kernel/exit.c:937 [inline]
>   __se_sys_exit_group kernel/exit.c:935 [inline]
>   __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:935
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f786cb8ccb9
> Code: Unable to access opcode bytes at RIP 0x7f786cb8cc8f.
> RSP: 002b:00007ffcf6b5b088 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007f786cc01350 RCX: 00007f786cb8ccb9
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f786cc01350
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

-- 
Pavel Begunkov
