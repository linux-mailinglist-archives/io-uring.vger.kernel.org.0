Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132332C76B1
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgK2AAq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgK2AAq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:00:46 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BAEC0613D1;
        Sat, 28 Nov 2020 16:00:00 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b23so4462599pls.11;
        Sat, 28 Nov 2020 16:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=slYJmzzqx39E9LIz6nbC1L1HRsq2mgKeK0napme5al8=;
        b=JqwZ++iyVF52o/uv1qo/RYr4vN4zkOQQA7JOFW6+6FKWAHzSCW2eW3uM9+b0wJD8/6
         IRXqYD8vP9lFZZ6VuuQ/ijM5eMeFwmQqIKu0guJ9+K0+LDiT0iaClwdjDJsTE6GxmXUI
         Ln1GvrEt+DrpDBRcjkRqZ+YtPvNAqxmNkB983UX45ZKT++iDBbGzbnWPrNyS1IGDRlwR
         xQfZHKVmH5Y7vdBhWQVG3LHZoVnHnVqWmQIB+qPLdRSOQ5dTY7aB5p66AA3b4mrNBoQJ
         nT4mm2QGp/PyB1jHnRPhuejVbMq3l8RRqO/H8BfxGeplfd3lJOyN/gi/zyYWyKd4jzN8
         fyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=slYJmzzqx39E9LIz6nbC1L1HRsq2mgKeK0napme5al8=;
        b=c1zn8F2jXqfESevDBMPSqTUO8k6rJVM68UZNI/iApRGiL2UGOWv6zQ1YzO3w5OwACW
         405QL8Os0p15LCzZ/yVhL7XDj5PQnGVdt6IHcQy2dCGx3/GOBVqpWI5M42vNJyHLiPTG
         br+tiNQte8x7c/eKPLdK/XAskKSQRuT+g7XbTD09+8T6zC5leD8g/mAZZqQqZEW6vl/E
         1r+V/mnjua5kcV5SQASaJKOZmexM2rvvuy9/qlbheUT0tlEorCMfFPm4lRkHN6eCi6zr
         vnD9lr0pdLqTrqo9OJkBjmK/BvXM8JV4QW3zbkzqN6jmYcFtrq+Dx7FBKnuaUXBUlzVR
         eGig==
X-Gm-Message-State: AOAM533MBj9JnYXT2lkZ7IryIwH8ATINeSv2p9JLrptrf8vA8qIUbMcJ
        DAfTmP1fE574OJfr33puN0Y=
X-Google-Smtp-Source: ABdhPJwqzYWueJiV5qGDjOnr/paLsJvb8hkCiMaCYCzLoWn+S3yStDOew+kZGz18ufERYFtdNz0REw==
X-Received: by 2002:a17:902:7c16:b029:d8:ac5d:3e9c with SMTP id x22-20020a1709027c16b02900d8ac5d3e9cmr12822075pll.68.1606607999302;
        Sat, 28 Nov 2020 15:59:59 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:6913:b4f6:effe:fbd4? ([2601:647:4700:9b2:6913:b4f6:effe:fbd4])
        by smtp.gmail.com with ESMTPSA id c28sm12242534pfj.108.2020.11.28.15.59.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Nov 2020 15:59:58 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Lockdep warning on io_file_data_ref_zero() with 5.10-rc5
Message-Id: <C3012989-5B09-4A88-B271-542C1ED91ABE@gmail.com>
Date:   Sat, 28 Nov 2020 15:59:56 -0800
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Pavel,

I got the following lockdep splat while rebasing my work on 5.10-rc5 on =
the
kernel (based on 5.10-rc5+).

I did not actually confirm that the problem is triggered without my =
changes,
as my iouring workload requires some kernel changes (not iouring =
changes),
yet IMHO it seems pretty clear that this is a result of your commit
e297822b20e7f ("io_uring: order refnode recycling=E2=80=9D), that =
acquires a lock in
io_file_data_ref_zero() inside a softirq context.

Let me know if my analysis is wrong.

Regards,
Nadav

[  136.349353] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  136.350212] WARNING: inconsistent lock state
[  136.351093] 5.10.0-rc5+ #1435 Not tainted
[  136.352003] --------------------------------
[  136.352891] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[  136.354057] swapper/5/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[  136.355078] ffff88810417d6a8 (&file_data->lock){+.?.}-{2:2}, at: =
io_file_data_ref_zero+0x4d/0x220
[  136.356717] {SOFTIRQ-ON-W} state was registered at:
[  136.357539]   lock_acquire+0x172/0x520
[  136.358209]   _raw_spin_lock+0x30/0x40
[  136.358880]   __io_uring_register+0x1c99/0x1fe0
[  136.359656]   __x64_sys_io_uring_register+0xe2/0x270
[  136.360489]   do_syscall_64+0x39/0x90
[  136.361144]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  136.361991] irq event stamp: 835836
[  136.362627] hardirqs last  enabled at (835836): [<ffffffff82856721>] =
_raw_spin_unlock_irqrestore+0x41/0x50
[  136.364112] hardirqs last disabled at (835835): [<ffffffff828564ca>] =
_raw_spin_lock_irqsave+0x5a/0x60
[  136.365553] softirqs last  enabled at (835824): [<ffffffff810cfa71>] =
_local_bh_enable+0x21/0x40
[  136.366920] softirqs last disabled at (835825): [<ffffffff82a01022>] =
asm_call_irq_on_stack+0x12/0x20
[  136.368335]=20
[  136.368335] other info that might help us debug this:
[  136.369414]  Possible unsafe locking scenario:
[  136.369414]=20
[  136.370414]        CPU0
[  136.370907]        ----
[  136.371403]   lock(&file_data->lock);
[  136.372064]   <Interrupt>
[  136.372585]     lock(&file_data->lock);
[  136.373269]=20
[  136.373269]  *** DEADLOCK ***
[  136.373269]=20
[  136.374319] 2 locks held by swapper/5/0:
[  136.375005]  #0: ffffffff83c45380 (rcu_callback){....}-{0:0}, at: =
rcu_core+0x451/0xb70
[  136.376284]  #1: ffffffff83c454a0 (rcu_read_lock){....}-{1:2}, at: =
percpu_ref_switch_to_atomic_rcu+0x139/0x320
[  136.377849]=20
[  136.377849] stack backtrace:
[  136.378650] CPU: 5 PID: 0 Comm: swapper/5 Not tainted =
5.10.0-rc5irina+ #1435
[  136.379746] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
[  136.381550] Call Trace:
[  136.382053]  <IRQ>
[  136.382502]  dump_stack+0xa4/0xd9
[  136.383116]  print_usage_bug.cold+0x217/0x220
[  136.383871]  mark_lock+0xb90/0xe80
[  136.384506]  ? print_usage_bug+0x180/0x180
[  136.385223]  ? __kasan_check_read+0x11/0x20
[  136.385946]  ? mark_lock+0x116/0xe80
[  136.386599]  ? print_usage_bug+0x180/0x180
[  136.387324]  ? __lock_acquire+0x8f5/0x2a80
[  136.388039]  ? __kasan_check_read+0x11/0x20
[  136.388776]  ? __lock_acquire+0x8f5/0x2a80
[  136.389493]  __lock_acquire+0xdc9/0x2a80
[  136.390190]  ? lockdep_hardirqs_on_prepare+0x210/0x210
[  136.391039]  ? rcu_read_lock_sched_held+0xa1/0xd0
[  136.391835]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  136.392603]  lock_acquire+0x172/0x520
[  136.393258]  ? io_file_data_ref_zero+0x4d/0x220
[  136.394025]  ? lock_release+0x410/0x410
[  136.394705]  ? lock_acquire+0x172/0x520
[  136.395386]  ? percpu_ref_switch_to_atomic_rcu+0x139/0x320
[  136.396277]  ? lock_release+0x410/0x410
[  136.396961]  _raw_spin_lock+0x30/0x40
[  136.397620]  ? io_file_data_ref_zero+0x4d/0x220
[  136.398392]  io_file_data_ref_zero+0x4d/0x220
[  136.399138]  percpu_ref_switch_to_atomic_rcu+0x310/0x320
[  136.400007]  ? percpu_ref_init+0x180/0x180
[  136.400730]  rcu_core+0x49c/0xb70
[  136.401344]  ? rcu_core+0x451/0xb70
[  136.401978]  ? strict_work_handler+0x150/0x150
[  136.402740]  ? rcu_read_lock_sched_held+0xa1/0xd0
[  136.403535]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  136.404298]  rcu_core_si+0xe/0x10
[  136.404914]  __do_softirq+0x104/0x59d
[  136.405572]  asm_call_irq_on_stack+0x12/0x20
[  136.406306]  </IRQ>
[  136.406760]  do_softirq_own_stack+0x6f/0x80
[  136.407484]  irq_exit_rcu+0xf3/0x100
[  136.408134]  sysvec_apic_timer_interrupt+0x4b/0xb0
[  136.408946]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  136.409798] RIP: 0010:default_idle+0x1c/0x20
[  136.410536] Code: eb cd 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44 =
00 00 55 48 89 e5 e8 b2 b1 a6 fe e9 07 00 00 00 0f 00 2d 26 f1 5c 00 fb =
f4 <5d> c3 cc cc 0f 1f 44 00 00 55 48 89 e5 41 55 4c 8b 2d 8e c2 00 02
[  136.413291] RSP: 0018:ffffc9000011fda8 EFLAGS: 00000206
[  136.414150] RAX: 00000000000cc0ed RBX: 0000000000000005 RCX: =
dffffc0000000000
[  136.415256] RDX: 0000000000000000 RSI: 0000000000000000 RDI: =
ffffffff8285578e
[  136.416364] RBP: ffffc9000011fda8 R08: 0000000000000001 R09: =
0000000000000001
[  136.417474] R10: ffff8881e877546b R11: ffffed103d0eea8d R12: =
0000000000000005
[  136.418579] R13: ffffffff84538220 R14: 0000000000000000 R15: =
ffff888100808000
[  136.419694]  ? default_idle+0xe/0x20
[  136.420340]  ? default_idle+0xe/0x20
[  136.420995]  arch_cpu_idle+0x15/0x20
[  136.421640]  default_idle_call+0x95/0x2c0
[  136.422343]  do_idle+0x3bd/0x480
[  136.422947]  ? arch_cpu_idle_exit+0x40/0x40
[  136.423679]  cpu_startup_entry+0x20/0x30
[  136.424369]  start_secondary+0x1c7/0x220
[  136.425067]  ? set_cpu_sibling_map+0xdc0/0xdc0
[  136.425829]  ? set_bringup_idt_handler.constprop.0+0x84/0x90
[  136.426746]  ? start_cpu0+0xc/0xc
[  136.427357]  secondary_startup_64_no_verify+0xb0/0xbb=
