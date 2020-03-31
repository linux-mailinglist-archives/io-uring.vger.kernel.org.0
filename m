Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AF4199795
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbgCaNek (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 09:34:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40727 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730856AbgCaNek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 09:34:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id c9so18262451qtw.7
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2020 06:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FC6FIie4dB6bMk3AEouOio/5I8/SxWgVUF3EHcYeGKk=;
        b=JSLXv2GsMl24k0EipG86fel3qIxrznqKCbWUISfyREeUxRtG8dcuHyRcIQfgiVh/XR
         vw4t5DfPeQ1L3LW0EcUykGzi2Wp4bu68RjhmLvhMsR41TFlDi9t8kesfnUu5CTKNNwJP
         vFBhTS5afyuY6Cv6HP9u4KaXcUkzT/Rghk88lc6+MQylxn8drFFzL1mX4eStYOBq1XX5
         qO2WvCiTKHxZXgjS9eunHwCnNdqJ+5vHrBiV3ZlP5XwAuX21T/7LSKVw4ntABTWhh/SI
         Z4bYjRTOHuQIsXD4GSWmQiDFoqQzTHeGFU8stiDQe9YK27oclNz/1sx/5VPgUHEhes+T
         ctEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FC6FIie4dB6bMk3AEouOio/5I8/SxWgVUF3EHcYeGKk=;
        b=cbeRVNOi2HHq6ShW4yuhhOMPzDYNJz/i/FD2Ex5jbE6BXb6PR+fBmkUr2dRMeetJsY
         Ewr0RSuxudrhQD+xHyBMnCgZrS3zJJtdx+ug3rUI+t1aZp0aDSfJG0fUEVBCl99jlMLB
         1+Qy5Hz47g/3dL+HCfahQbXsgshlxM+dYMRxSztysVBwNfttnTRNhCRYsggv1QvtIMJL
         bcimkwMX38Ds883xBpJsyXmHyyI1NUK/MnpSyrs/yljj/MWliAmECjNkgWhzLd3MQYL1
         Qyao/vTU9f1J1OPSYeYZ4P3lkZlovPXnLIGrEzTBT4USfWCJeuJUrnRvzy6JZeJ2RGrI
         Zg4A==
X-Gm-Message-State: ANhLgQ1bNHWpbzKEtyt/c+Hd135BikmGdYGHJngprYCqFxtDdt8kscja
        uvKbkZWMpgciyFGO4JCc++2lJBKQJu+2sWLVvkwNPQ==
X-Google-Smtp-Source: ADFU+vtUeEOZn0rGavrGQ77YK5I181F1/PrUa9BYa0b8C78Gwj1gAK2n5Cl9kEZmCorTDalXgX+CB9VDENu7bBoYtus=
X-Received: by 2002:ac8:719a:: with SMTP id w26mr4993271qto.257.1585661678287;
 Tue, 31 Mar 2020 06:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000016bac605a2268a08@google.com>
In-Reply-To: <00000000000016bac605a2268a08@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 31 Mar 2020 15:34:26 +0200
Message-ID: <CACT4Y+Zk60ETzYdpSepkR+YqNvzkbEhjdDUy+bY7r=XWxoVYaA@mail.gmail.com>
Subject: Re: WARNING in percpu_ref_switch_to_atomic_rcu
To:     syzbot <syzbot+0076781e1606f479425e@syzkaller.appspotmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 31, 2020 at 3:28 PM syzbot
<syzbot+0076781e1606f479425e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    770fbb32 Add linux-next specific files for 20200228
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1414f7ade00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
> dashboard link: https://syzkaller.appspot.com/bug?extid=0076781e1606f479425e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0076781e1606f479425e@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> percpu ref (io_file_data_ref_zero) <= 0 (0) after switching to atomic

Looking at this io_file_data_ref_zero, this seems to be io_uring
related. +io_uring maintainers

> WARNING: CPU: 0 PID: 0 at lib/percpu-refcount.c:160 percpu_ref_switch_to_atomic_rcu+0x436/0x540 lib/percpu-refcount.c:160
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:221
>  __warn.cold+0x2f/0x35 kernel/panic.c:582
>  report_bug+0x27b/0x2f0 lib/bug.c:195
>  fixup_bug arch/x86/kernel/traps.c:175 [inline]
>  fixup_bug arch/x86/kernel/traps.c:170 [inline]
>  do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
>  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x436/0x540 lib/percpu-refcount.c:160
> Code: 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 f7 00 00 00 49 8b 75 e8 4c 89 e2 48 c7 c7 e0 d1 71 88 e8 02 36 b5 fd <0f> 0b e9 2b fd ff ff e8 7e 6a e3 fd be 08 00 00 00 48 89 ef e8 51
> RSP: 0018:ffffc90000007df0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000100 RSI: ffffffff815c4e91 RDI: fffff52000000fb0
> RBP: ffff88808c4b2810 R08: ffffffff8987a480 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff88808c4b2838 R14: 0000000000000002 R15: 0000000000000007
>  rcu_do_batch kernel/rcu/tree.c:2218 [inline]
>  rcu_core+0x59f/0x1370 kernel/rcu/tree.c:2445
>  __do_softirq+0x26c/0x99d kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:373 [inline]
>  irq_exit+0x192/0x1d0 kernel/softirq.c:413
>  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>  smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1146
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
> Code: cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d e4 35 65 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d d4 35 65 00 fb f4 <c3> cc 41 56 41 55 41 54 55 53 e8 f3 25 9d f9 e8 8e f7 cf fb 0f 1f
> RSP: 0018:ffffffff89807d98 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff132790a RBX: ffffffff8987a480 RCX: 0000000000000000
> RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8987ad1c
> RBP: dffffc0000000000 R08: ffffffff8987a480 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: fffffbfff130f490
> R13: 0000000000000000 R14: ffffffff8a862140 R15: 0000000000000000
>  arch_safe_halt arch/x86/include/asm/paravirt.h:144 [inline]
>  default_idle+0x49/0x350 arch/x86/kernel/process.c:698
>  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
>  do_idle+0x393/0x690 kernel/sched/idle.c:269
>  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
>  start_kernel+0x867/0x8a1 init/main.c:1001
>  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000016bac605a2268a08%40google.com.
