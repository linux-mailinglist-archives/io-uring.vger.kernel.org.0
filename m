Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E151342D0AB
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 04:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhJNCrj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Oct 2021 22:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNCrj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Oct 2021 22:47:39 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF5DC061570;
        Wed, 13 Oct 2021 19:45:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso3737439pjb.1;
        Wed, 13 Oct 2021 19:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MCfoJNemGuhS326dx7D8bSFqRZvZkN9oEZyIS88IRyk=;
        b=gadn6qip11c28osjSMnV3BtPL4erDPdfNWxwutx/7ROAp2XDbXvSuJp76mQk+oy+tb
         7GmKt7UlUl7G5HUl4nJTI+W8aheYp2/iF/gp0Ruu4LpqnW5u2Cp40A6/dBb2vnPR0Joy
         B5LL5Gu62VXosyb55F3KG7/I92JNC+dvydRXKgFmnoKMDt+y60zcT6Ks9tEYEJ5/ErbJ
         Qxq7CfbZGdpU1MHQszmmvgHyhyNb4VbV/f9Rok+HrPrEzjVOrW0z0S9n0mRlcQQtyL0Y
         5IPaXW8rpMjV+fX+jzPDrWquzmUZDVxiGxHcCiSmF6Lo2c1d+kHErBDe9QY6W0YOlkgT
         y0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MCfoJNemGuhS326dx7D8bSFqRZvZkN9oEZyIS88IRyk=;
        b=8OWeB4RyUrJqi22EWK4s5sT70rgojmwV0WKxDBR/pghU7UjDmI8uwuw8zf+r7cIS/f
         hse66kt6bOrmVdMrtf+pgK9OLo1r0PnV7lpKw7VFFpXEHiE0PJSPMqy/CkEjRhiaousW
         p/EQf1EuzzBTq2I+qsDQ1ursPbO+z9A7uI4M+Ly/wzzO42jTREd0YL2Wt2lpef3rMveU
         LKWI5f9VMy9PdqTnrx6C2RO3QvcpHgNdM7Nj3+2TfCjB3hLPFz6mAZM0+XxV2aRelHmf
         tpzJ9obyDxMhEpfEGLYKGT+scHD3kRvh1zRUj+GOEXRuaTtTB3F1H7AEv+yEQEaRTUsH
         BhdQ==
X-Gm-Message-State: AOAM531DRiza1pEO+0u02bW0wxp+1j9z32El93vbFFIM8ehTibb9P8De
        BjoKWGVBeDSbsOgHiQjTNAZZOYSGlsPtQYlWwQ==
X-Google-Smtp-Source: ABdhPJxsb9HiW7RCoKmADM80gbih4KzUb2aq//tY4yZjU5WCX2PpvNfDJH9TrpcUQh1JGdoSB5bzxFDS33G12vK6UHM=
X-Received: by 2002:a17:902:e5cb:b0:13f:25b7:4d50 with SMTP id
 u11-20020a170902e5cb00b0013f25b74d50mr2656301plf.38.1634179534869; Wed, 13
 Oct 2021 19:45:34 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Thu, 14 Oct 2021 10:45:24 +0800
Message-ID: <CACkBjsa74dyF4TiwxH1yKuyaGcPQSEP9mvPedBCaskGU7g5vdw@mail.gmail.com>
Subject: possible deadlock in io_poll_double_wake
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
console output:
https://drive.google.com/file/d/1vA465O1bvHG4dfD07CNI-lcjbFYaD-nK/view?usp=sharing
kernel config: https://drive.google.com/file/d/1em3xgUIMNN_-LUUdySzwN-UDPc3qiiKD/view?usp=sharing
C reproducer: https://drive.google.com/file/d/13EMtDAujxvvBRb3m1gV1zXsp4gkRFJSS/view?usp=sharing
Syzlang reproducer:
https://drive.google.com/file/d/1dFk5ujvk-lnr_KzNGboFm9fvwYdETowv/view?usp=sharing

If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

============================================
WARNING: possible recursive locking detected
5.15.0-rc5 #3 Not tainted
--------------------------------------------
swapper/0/0 is trying to acquire lock:
ffff88810f5cd130 (&runtime->sleep){..-.}-{2:2}, at:
io_poll_double_wake+0x2be/0x800 fs/io_uring.c:5418

but task is already holding lock:
ffff88810f5cf130 (&runtime->sleep){..-.}-{2:2}, at:
__wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&runtime->sleep);
  lock(&runtime->sleep);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by swapper/0/0:
 #0: ffffc90000007d68 ((&dpcm->timer)){+.-.}-{0:0}, at:
lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #0: ffffc90000007d68 ((&dpcm->timer)){+.-.}-{0:0}, at:
call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1411
 #1: ffff888100fc6108 (&group->lock){..-.}-{2:2}, at:
_snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
 #2: ffff88810f5cf130 (&runtime->sleep){..-.}-{2:2}, at:
__wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0-rc5 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x168/0x3c3 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 io_poll_double_wake+0x2be/0x800 fs/io_uring.c:5418
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 snd_pcm_update_state+0x3d4/0x540 sound/core/pcm_lib.c:203
 snd_pcm_update_hw_ptr0+0xe79/0x2090 sound/core/pcm_lib.c:464
 snd_pcm_period_elapsed_under_stream_lock+0x15a/0x230 sound/core/pcm_lib.c:1816
 snd_pcm_period_elapsed+0x28/0x50 sound/core/pcm_lib.c:1848
 loopback_jiffies_timer_function+0x1eb/0x270 sound/drivers/aloop.c:668
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x6b0/0xa90 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb6/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x1d7/0x93b kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0xf2/0x130 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:default_idle+0xb/0x10 arch/x86/kernel/process.c:717
Code: 1b 51 88 f8 e9 6f fe ff ff e8 11 51 88 f8 e9 3d fe ff ff e8 17
31 fd ff cc cc cc cc cc cc cc eb 07 0f 00 2d 47 99 50 00 fb f4 <c3> 0f
1f 40 00 41 54 be 08 00 00 00 53 65 48 8b 1c 25 40 f0 01 00
RSP: 0018:ffffffff8b607e28 EFLAGS: 00000206
RAX: 00000000001543c3 RBX: 0000000000000000 RCX: ffffffff8932d572
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed100c7c6542
R10: ffff888063e32a0b R11: ffffed100c7c6541 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff8d6d8590 R15: 0000000000000000
 default_idle_call+0xc4/0x420 kernel/sched/idle.c:112
 cpuidle_idle_call kernel/sched/idle.c:194 [inline]
 do_idle+0x3f9/0x570 kernel/sched/idle.c:306
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
 start_kernel+0x47a/0x49b init/main.c:1141
 secondary_startup_64_no_verify+0xb0/0xbb
----------------
Code disassembly (best guess):
   0: 1b 51 88              sbb    -0x78(%rcx),%edx
   3: f8                    clc
   4: e9 6f fe ff ff        jmpq   0xfffffe78
   9: e8 11 51 88 f8        callq  0xf888511f
   e: e9 3d fe ff ff        jmpq   0xfffffe50
  13: e8 17 31 fd ff        callq  0xfffd312f
  18: cc                    int3
  19: cc                    int3
  1a: cc                    int3
  1b: cc                    int3
  1c: cc                    int3
  1d: cc                    int3
  1e: cc                    int3
  1f: eb 07                jmp    0x28
  21: 0f 00 2d 47 99 50 00 verw   0x509947(%rip)        # 0x50996f
  28: fb                    sti
  29: f4                    hlt
* 2a: c3                    retq <-- trapping instruction
  2b: 0f 1f 40 00          nopl   0x0(%rax)
  2f: 41 54                push   %r12
  31: be 08 00 00 00        mov    $0x8,%esi
  36: 53                    push   %rbx
  37: 65 48 8b 1c 25 40 f0 mov    %gs:0x1f040,%rbx
  3e: 01 00
