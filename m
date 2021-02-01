Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068F130A659
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 12:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhBALS5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 06:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbhBALSw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 06:18:52 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72408C061788;
        Mon,  1 Feb 2021 03:18:06 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o10so11277519wmc.1;
        Mon, 01 Feb 2021 03:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eLmzHiYkPZkgrnlZ57oXqwa/qMtAb5vaQbGy5IiUU+o=;
        b=T5ss2jAsUrzlR4Pjlby6pJlgkuIVDK9jGRYkQkM6pWhRuHlD7pUbZOfqmiW+TFyLF7
         VyqyENn7Z1lrhptg7d7XqewXcVjweuD3shH1fkfW70PnqDgPG0y+DWiPuE9G6Ols5Ck3
         ZXL2dugzeTWvSD4LVrK7vhxhC8Wrm2PGXzyiod7mEZVKk7a2ipwS5goTPcQLpBj9YbVy
         yXQuZysLYQz2econPFjK1ZP6kKFfS87OVn2kgo5qk5wcah/uWLYG7xrPakwyIPUH5rrz
         pvaYNgRRUupmeWPM1fMQgzciiljCUS+GOkHz0yP1RheqJPb0NAsNtPClRszybFQWCzrZ
         4rAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eLmzHiYkPZkgrnlZ57oXqwa/qMtAb5vaQbGy5IiUU+o=;
        b=axSmlcaCjsItV+V3heY5fACw8FinIhWfMQ9UfxqodVXGDQFumdegyeccDVjvdx34YU
         f8AFeF5lP6Ympia9hvrGKiWOsRpUH+Qwu+B9w4zv5cW2YjfWDMfX1wIDRf3eNoO1/x8R
         fujjY9W6kbAZK/gn0i+dINcxVkOS3XROVfxz+L4iwUmRQ8vrtZNeZcV4dUXQwqbEyest
         PccJ3d79IbAMgzqfz05vpMxOvPvWqWL6LGxJlOxPZk9I6A2qzYafc/PO2SoqZLVN84zb
         DQRIrqmj78/6fjVTM6ODD8cvi2oZaI94uwBIU4oUxj2R7ydhuFLrabe1S7VULb2khbha
         sSTg==
X-Gm-Message-State: AOAM533kGfx/Ck26QxBpJYZcJoUdyWmWKHllP421uKGcJCpNIn5I7I5h
        afI1cb2efjul+DIhDVuuq7w=
X-Google-Smtp-Source: ABdhPJzD3E/AwirNaYU2m/wzXy0E8kilIayZSbH7d4++Yocg0s13hZ7PDhLlthG4tp7YVUUCs8dRzQ==
X-Received: by 2002:a1c:b087:: with SMTP id z129mr10078500wme.147.1612178285101;
        Mon, 01 Feb 2021 03:18:05 -0800 (PST)
Received: from [192.168.8.166] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id k6sm27413545wro.27.2021.02.01.03.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 03:18:04 -0800 (PST)
Subject: Re: inconsistent lock state in io_dismantle_req
To:     syzbot <syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000018b9a605ba42ce81@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e0356a61-1024-6f44-b5d6-af531bfba9bd@gmail.com>
Date:   Mon, 1 Feb 2021 11:14:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000018b9a605ba42ce81@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/02/2021 09:16, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b01f250d Add linux-next specific files for 20210129
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=160cda90d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=725bc96dc234fda7
> dashboard link: https://syzkaller.appspot.com/bug?extid=81d17233a2b02eafba33
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f8a330d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c10440d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com
> 
> ================================
> WARNING: inconsistent lock state

The case is clear, I'll fix it up


> 5.11.0-rc5-next-20210129-syzkaller #0 Not tainted
> --------------------------------
> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> syz-executor217/8450 [HC1[1]:SC0[0]:HE0:SE1] takes:
> ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
> ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_req_clean_work fs/io_uring.c:1398 [inline]
> ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029
> {HARDIRQ-ON-W} state was registered at:
>   lock_acquire kernel/locking/lockdep.c:5509 [inline]
>   lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5474
>   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>   spin_lock include/linux/spinlock.h:354 [inline]
>   set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
>   init_chdir+0xdf/0x127 fs/init.c:54
>   devtmpfs_setup drivers/base/devtmpfs.c:418 [inline]
>   devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:433
>   kthread+0x3b1/0x4a0 kernel/kthread.c:292
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> irq event stamp: 786
> hardirqs last  enabled at (785): [<ffffffff8903de4f>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
> hardirqs last  enabled at (785): [<ffffffff8903de4f>] _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:199
> hardirqs last disabled at (786): [<ffffffff8901704c>] sysvec_apic_timer_interrupt+0xc/0x100 arch/x86/kernel/apic/apic.c:1096
> softirqs last  enabled at (664): [<ffffffff87abbe04>] read_pnet include/net/net_namespace.h:324 [inline]
> softirqs last  enabled at (664): [<ffffffff87abbe04>] sock_net include/net/sock.h:2550 [inline]
> softirqs last  enabled at (664): [<ffffffff87abbe04>] unix_create1+0x484/0x570 net/unix/af_unix.c:814
> softirqs last disabled at (662): [<ffffffff87abbd81>] unix_sockets_unbound net/unix/af_unix.c:133 [inline]
> softirqs last disabled at (662): [<ffffffff87abbd81>] unix_create1+0x401/0x570 net/unix/af_unix.c:808
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&fs->lock);
>   <Interrupt>
>     lock(&fs->lock);
> 
>  *** DEADLOCK ***
> 
> 1 lock held by syz-executor217/8450:
>  #0: ffff88802417c3e8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x1071/0x1f30 fs/io_uring.c:9442
> 
> stack backtrace:
> CPU: 1 PID: 8450 Comm: syz-executor217 Not tainted 5.11.0-rc5-next-20210129-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  print_usage_bug kernel/locking/lockdep.c:3806 [inline]
>  valid_state kernel/locking/lockdep.c:3817 [inline]
>  mark_lock_irq kernel/locking/lockdep.c:4020 [inline]
>  mark_lock.cold+0x61/0x8e kernel/locking/lockdep.c:4477
>  mark_usage kernel/locking/lockdep.c:4369 [inline]
>  __lock_acquire+0x1468/0x54c0 kernel/locking/lockdep.c:4853
>  lock_acquire kernel/locking/lockdep.c:5509 [inline]
>  lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5474
>  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>  spin_lock include/linux/spinlock.h:354 [inline]
>  io_req_clean_work fs/io_uring.c:1398 [inline]
>  io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029
>  __io_free_req+0x3d/0x2e0 fs/io_uring.c:2046
>  io_free_req fs/io_uring.c:2269 [inline]
>  io_double_put_req fs/io_uring.c:2392 [inline]
>  io_put_req+0xf9/0x570 fs/io_uring.c:2388
>  io_link_timeout_fn+0x30c/0x480 fs/io_uring.c:6497
>  __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
>  __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
>  hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
>  __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
>  asm_call_irq_on_stack+0xf/0x20
>  </IRQ>
>  __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
>  run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
>  sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629
> RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
> RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
> Code: 0f 1f 44 00 00 55 48 8b 74 24 08 48 89 fd 48 83 c7 18 e8 de 04 55 f8 48 89 ef e8 36 ba 55 f8 e8 71 16 75 f8 fb bf 01 00 00 00 <e8> 76 b9 49 f8 65 8b 05 5f 11 fe 76 85 c0 74 02 5d c3 e8 cb 66 fc
> RSP: 0018:ffffc9000166f978 EFLAGS: 00000206
> RAX: 0000000000000311 RBX: ffff8881416eaa00 RCX: 1ffffffff1df7d02
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: ffff88802417c480 R08: 0000000000000001 R09: ffffffff8ef738e7
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88802417c480
> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
>  spin_unlock_irq include/linux/spinlock.h:404 [inline]
>  io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6525
>  __io_queue_sqe+0x328/0x1290 fs/io_uring.c:6594
>  io_queue_sqe+0x631/0x10d0 fs/io_uring.c:6639
>  io_queue_link_head fs/io_uring.c:6650 [inline]
>  io_submit_sqe fs/io_uring.c:6697 [inline]
>  io_submit_sqes+0x19b5/0x2720 fs/io_uring.c:6960
>  __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9443
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x441619
> Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffc10aa3e28 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441619
> RDX: 0000000000000000 RSI: 0000000000004510 RDI: 0000000000000003
> RBP: 00000000006cc018 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004023c0
> R13: 0000000000402450 R14: 0000000000000000 R15: 0000000000000000
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

-- 
Pavel Begunkov
