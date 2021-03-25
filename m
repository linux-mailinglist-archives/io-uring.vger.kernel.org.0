Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B243498D8
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 19:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCYSAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 14:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhCYSAi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 14:00:38 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DABCC06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:00:36 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id c17so2860910ilj.7
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=z4pjN5lLrhX2yHOuzAG/jxD1z0VP0bybkL9OIgTm0Wc=;
        b=LMlOpnItkELi1vW5YcrLN0yLr/qe1OyM5PENDlFsCFCEMtgKl4Xd5DfWxkhKH2UCxG
         pbbjLC2RicNVin7wCNo5Iv+d7Y8sc/3GtUXnze0vncGa36Im38ghNcblpR7IxrTQZteP
         N1/tN6AYc5Zp6msG2mkVO5Y5IsFRJn6pBGHKAbMGmylJA2gDLVB5LJW6Srmlsin9Pydg
         Z+EAleZdMGugWc9slRh8/A8aO5C4O1ngA+VN8KLJWQ2wRoPmbYx03186snBtOucQq3nG
         tNLCqdvz+w33CiD+vRj07KIPbR6WpoesLSpvXAZ/vBaRTfuxaVsv10epuQFAQlaK2nE5
         Ypew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z4pjN5lLrhX2yHOuzAG/jxD1z0VP0bybkL9OIgTm0Wc=;
        b=kjKj33hdACdlUZAv+9i5440nEDkmX2e2Y/+wb7Pfy2yz0nujRUoSu49I+GjRqGlqmO
         zoYXyXEm/qlvfxBR6cCNzX/hJLUjQX3cOncC8RlU++s3resLmypdw6P5p8MPEpH7Fx3c
         UACYQw8YQpmbc2wbi4utSTEFVxpCcz/l2VpK0WGoJ9/gQKv0LCYVwuSR/w8NbBMcEib+
         jMJgek11vk+tTLW5DJlS8M2J+7+9FZyBjJ50+5CIxytCYwrXSfmrZoalovq/D/8/Z2St
         0cqwF4hExW9gdNBlAGlG3+Q6qX6rSOHCkQwArZOQ1WcR/WG8ITIzTVLmXKNPuRCrWtiB
         QX9A==
X-Gm-Message-State: AOAM530IKNU0N6hQgsMtGXjOH/IbhHkayWlXXL82ZRFFo/HkbInAqUan
        87SNkO+8AG1W8t84bzbmwVQN8Q==
X-Google-Smtp-Source: ABdhPJzROouLj8zTEt1i/fz4nuzn4a4b3s6u4RzYHnkG0uf8lpE7JD/8J6ATnSVenpBExw48EILLuQ==
X-Received: by 2002:a05:6e02:1564:: with SMTP id k4mr7477160ilu.65.1616695235357;
        Thu, 25 Mar 2021 11:00:35 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm3028698ioz.49.2021.03.25.11.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 11:00:35 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_wq_put
To:     syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a0025805be6028a0@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ccd9749c-626f-31d3-f187-83fc3465713c@kernel.dk>
Date:   Thu, 25 Mar 2021 12:00:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000a0025805be6028a0@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 11:58 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in kvm_wait
> 
> ------------[ cut here ]------------
> raw_local_irq_restore() called with IRQs enabled
> WARNING: CPU: 1 PID: 191 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1f/0x30 kernel/locking/irqflag-debug.c:10
> Modules linked in:
> CPU: 1 PID: 191 Comm: kworker/u4:4 Not tainted 5.12.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue:  0x0 (events_unbound)
> RIP: 0010:warn_bogus_irq_restore+0x1f/0x30 kernel/locking/irqflag-debug.c:10
> Code: cc cc cc cc cc cc cc cc cc cc cc 80 3d c7 af b1 03 00 74 01 c3 c6 05 bd af b1 03 01 48 c7 c7 c0 5f ae 89 31 c0 e8 d1 dd f6 f7 <0f> 0b c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc 41 56 53 48 83
> RSP: 0018:ffffc90000dc0a08 EFLAGS: 00010246
> RAX: 6a712abdc5855100 RBX: ffffffff8f982d60 RCX: ffff8880118bb880
> RDX: 0000000000000103 RSI: 0000000000000103 RDI: 0000000000000000
> RBP: 1ffff920001b8142 R08: ffffffff81609502 R09: ffffed10173e5fe8
> R10: ffffed10173e5fe8 R11: 0000000000000000 R12: 0000000000000003
> R13: ffff88823ffe6880 R14: 0000000000000246 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f44d117d718 CR3: 000000001340a000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  kvm_wait+0x10e/0x160 arch/x86/kernel/kvm.c:860
>  pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
>  pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
>  __pv_queued_spin_lock_slowpath+0x6b5/0xb90 kernel/locking/qspinlock.c:508
>  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
>  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
>  queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
>  do_raw_spin_lock+0x430/0x810 kernel/locking/spinlock_debug.c:113
>  spin_lock include/linux/spinlock.h:354 [inline]
>  mac80211_hwsim_tx_frame_no_nl+0x60e/0x1860 drivers/net/wireless/mac80211_hwsim.c:1514
>  mac80211_hwsim_tx_frame+0x143/0x180 drivers/net/wireless/mac80211_hwsim.c:1775
>  mac80211_hwsim_beacon_tx+0x4b9/0x870 drivers/net/wireless/mac80211_hwsim.c:1829
>  __iterate_interfaces+0x23e/0x4b0 net/mac80211/util.c:793
>  ieee80211_iterate_active_interfaces_atomic+0x9b/0x120 net/mac80211/util.c:829
>  mac80211_hwsim_beacon+0xa4/0x180 drivers/net/wireless/mac80211_hwsim.c:1852
>  __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
>  __hrtimer_run_queues+0x4c9/0xa00 kernel/time/hrtimer.c:1583
>  hrtimer_run_softirq+0x176/0x1e0 kernel/time/hrtimer.c:1600
>  __do_softirq+0x318/0x714 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu+0x1d8/0x200 kernel/softirq.c:422
>  irq_exit_rcu+0x5/0x20 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
> RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
> RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
> Code: b4 fd ff 66 90 53 48 89 fb 48 83 c7 18 48 8b 74 24 08 e8 0e 56 09 f8 48 89 df e8 56 2b 0b f8 e8 41 9f 2b f8 fb bf 01 00 00 00 <e8> c6 3b ff f7 65 8b 05 c7 9f ae 76 85 c0 74 02 5b c3 e8 7b fb ac
> RSP: 0018:ffffc9000143fca0 EFLAGS: 00000286
> RAX: 6a712abdc5855100 RBX: ffff8880b9f34c40 RCX: ffffffff8f59cb03
> RDX: 0000000040000000 RSI: 0000000000000002 RDI: 0000000000000001
> RBP: ffffc9000143fd00 R08: ffffffff817eef20 R09: ffffed10173e6989
> R10: ffffed10173e6989 R11: 0000000000000000 R12: ffff8880b9f34c40
> R13: ffff8880118bb880 R14: dffffc0000000000 R15: 0000000000000000
>  finish_task_switch+0x145/0x620 kernel/sched/core.c:4193
>  context_switch kernel/sched/core.c:4327 [inline]
>  __schedule+0x9a1/0xe70 kernel/sched/core.c:5075
>  schedule+0x14b/0x200 kernel/sched/core.c:5154
>  worker_thread+0xfe6/0x1300 kernel/workqueue.c:2442
>  kthread+0x39a/0x3c0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

This is a different issue, not related to this code at all.

-- 
Jens Axboe

