Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCC02C76D0
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgK2ARQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgK2ARQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:17:16 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FD9C0613D1;
        Sat, 28 Nov 2020 16:16:35 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id f190so9426769wme.1;
        Sat, 28 Nov 2020 16:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H9eKp9oKMt2aHbVBUx9yJ2AE1dh6IPb/UpFyTsgAyKE=;
        b=da/a4w7DRoiwRArM0xYp6Q70qHl8frM56c4eJj8AZhuqVtQxBeYh/JhCyMLGcBhKGU
         QZq/WswVc5nER5epMlsp9ytfz60N51eQ7/QyQ2uOcZ4ncvaY2JDVmI9VAV3Wudi03+Wq
         NHNI6Bq7Fiw8nmxoBd2j+dvhiyYJsUdxK/gimdjxSSZJaeV4EoE53wVdxHvjM37FL3Fk
         ENo8RdRP2W3vewbSdm0Clndkjx+AGal3SfR60gXKTzJQxSbm6HXt2jedrY5xI8GlKIKp
         Wyz8fbit2JuatORRfjx4n8vlHdrmWF1zw3/0L4M1rDmms2U5hD4r3F28d2JXr48yoXj9
         W/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H9eKp9oKMt2aHbVBUx9yJ2AE1dh6IPb/UpFyTsgAyKE=;
        b=ex8DMCbKdjZJ8l9frexWF+eoMnLBMAXozcctY/zhGDdJ8Wrv58Cz4Dtobodizny1Fi
         jXf21DpbrzZpuAaHjhMWRVNriNouFzx9Ug6rsjR/P8ZrE0vJ4RQUBw8xZGmgERBQ78Bn
         kLSQgLVuYp4iuBpfJ7gpY+CQFpVXtLtgN9FIcee5zO3gaavEEbReVO9sQ1HoKN6389S2
         ZpaRxpg2kormQx79XOXxZ2N8jXv0dRu2EzkdWWCDnQ6OfUzO71MU5HEub1xTxaUGSBZ3
         z7aJR8KWjzrLxflDIBDFiyeA4hl+ARfe0/yIWEsc+k1rlaRAWS4QF7n3OyeMuy7erE3C
         IKfA==
X-Gm-Message-State: AOAM5339lToMDViQF3ow7faVJPV9s5MhGHZJGODlw96uIn2kjQsEvR+j
        reSRQp64NVYSxJdnqiofro0=
X-Google-Smtp-Source: ABdhPJzYlyDu7zgNL+ouORiRwdj3O/E76ZWkessspU7NbtJQ7UvdSRf8TvcHjin9JbxMvmzLoerxDQ==
X-Received: by 2002:a7b:c950:: with SMTP id i16mr16265394wml.136.1606608992947;
        Sat, 28 Nov 2020 16:16:32 -0800 (PST)
Received: from [192.168.1.84] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id 9sm18678304wmo.34.2020.11.28.16.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Nov 2020 16:16:32 -0800 (PST)
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
References: <C3012989-5B09-4A88-B271-542C1ED91ABE@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Lockdep warning on io_file_data_ref_zero() with 5.10-rc5
Message-ID: <c16232dd-5841-6e87-bbd0-0c18f0fc982b@gmail.com>
Date:   Sun, 29 Nov 2020 00:13:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <C3012989-5B09-4A88-B271-542C1ED91ABE@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/11/2020 23:59, Nadav Amit wrote:
> Hello Pavel,
> 
> I got the following lockdep splat while rebasing my work on 5.10-rc5 on the
> kernel (based on 5.10-rc5+).
> 
> I did not actually confirm that the problem is triggered without my changes,
> as my iouring workload requires some kernel changes (not iouring changes),
> yet IMHO it seems pretty clear that this is a result of your commit
> e297822b20e7f ("io_uring: order refnode recycling”), that acquires a lock in
> io_file_data_ref_zero() inside a softirq context.

Yeah, that's true. It was already reported by syzkaller and fixed by Jens, but
queued for 5.11. Thanks for letting know anyway!

https://lore.kernel.org/io-uring/948d2d3b-5f36-034d-28e6-7490343a5b59@kernel.dk/T/#t


Jens, I think it's for the best to add it for 5.10, at least so that lockdep
doesn't complain.

> 
> Let me know if my analysis is wrong.
> 
> Regards,
> Nadav
> 
> [  136.349353] ================================
> [  136.350212] WARNING: inconsistent lock state
> [  136.351093] 5.10.0-rc5+ #1435 Not tainted
> [  136.352003] --------------------------------
> [  136.352891] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> [  136.354057] swapper/5/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> [  136.355078] ffff88810417d6a8 (&file_data->lock){+.?.}-{2:2}, at: io_file_data_ref_zero+0x4d/0x220
> [  136.356717] {SOFTIRQ-ON-W} state was registered at:
> [  136.357539]   lock_acquire+0x172/0x520
> [  136.358209]   _raw_spin_lock+0x30/0x40
> [  136.358880]   __io_uring_register+0x1c99/0x1fe0
> [  136.359656]   __x64_sys_io_uring_register+0xe2/0x270
> [  136.360489]   do_syscall_64+0x39/0x90
> [  136.361144]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  136.361991] irq event stamp: 835836
> [  136.362627] hardirqs last  enabled at (835836): [<ffffffff82856721>] _raw_spin_unlock_irqrestore+0x41/0x50
> [  136.364112] hardirqs last disabled at (835835): [<ffffffff828564ca>] _raw_spin_lock_irqsave+0x5a/0x60
> [  136.365553] softirqs last  enabled at (835824): [<ffffffff810cfa71>] _local_bh_enable+0x21/0x40
> [  136.366920] softirqs last disabled at (835825): [<ffffffff82a01022>] asm_call_irq_on_stack+0x12/0x20
> [  136.368335] 
> [  136.368335] other info that might help us debug this:
> [  136.369414]  Possible unsafe locking scenario:
> [  136.369414] 
> [  136.370414]        CPU0
> [  136.370907]        ----
> [  136.371403]   lock(&file_data->lock);
> [  136.372064]   <Interrupt>
> [  136.372585]     lock(&file_data->lock);
> [  136.373269] 
> [  136.373269]  *** DEADLOCK ***
> [  136.373269] 
> [  136.374319] 2 locks held by swapper/5/0:
> [  136.375005]  #0: ffffffff83c45380 (rcu_callback){....}-{0:0}, at: rcu_core+0x451/0xb70
> [  136.376284]  #1: ffffffff83c454a0 (rcu_read_lock){....}-{1:2}, at: percpu_ref_switch_to_atomic_rcu+0x139/0x320
> [  136.377849] 
> [  136.377849] stack backtrace:
> [  136.378650] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.10.0-rc5irina+ #1435
> [  136.379746] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> [  136.381550] Call Trace:
> [  136.382053]  <IRQ>
> [  136.382502]  dump_stack+0xa4/0xd9
> [  136.383116]  print_usage_bug.cold+0x217/0x220
> [  136.383871]  mark_lock+0xb90/0xe80
> [  136.384506]  ? print_usage_bug+0x180/0x180
> [  136.385223]  ? __kasan_check_read+0x11/0x20
> [  136.385946]  ? mark_lock+0x116/0xe80
> [  136.386599]  ? print_usage_bug+0x180/0x180
> [  136.387324]  ? __lock_acquire+0x8f5/0x2a80
> [  136.388039]  ? __kasan_check_read+0x11/0x20
> [  136.388776]  ? __lock_acquire+0x8f5/0x2a80
> [  136.389493]  __lock_acquire+0xdc9/0x2a80
> [  136.390190]  ? lockdep_hardirqs_on_prepare+0x210/0x210
> [  136.391039]  ? rcu_read_lock_sched_held+0xa1/0xd0
> [  136.391835]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [  136.392603]  lock_acquire+0x172/0x520
> [  136.393258]  ? io_file_data_ref_zero+0x4d/0x220
> [  136.394025]  ? lock_release+0x410/0x410
> [  136.394705]  ? lock_acquire+0x172/0x520
> [  136.395386]  ? percpu_ref_switch_to_atomic_rcu+0x139/0x320
> [  136.396277]  ? lock_release+0x410/0x410
> [  136.396961]  _raw_spin_lock+0x30/0x40
> [  136.397620]  ? io_file_data_ref_zero+0x4d/0x220
> [  136.398392]  io_file_data_ref_zero+0x4d/0x220
> [  136.399138]  percpu_ref_switch_to_atomic_rcu+0x310/0x320
> [  136.400007]  ? percpu_ref_init+0x180/0x180
> [  136.400730]  rcu_core+0x49c/0xb70
> [  136.401344]  ? rcu_core+0x451/0xb70
> [  136.401978]  ? strict_work_handler+0x150/0x150
> [  136.402740]  ? rcu_read_lock_sched_held+0xa1/0xd0
> [  136.403535]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [  136.404298]  rcu_core_si+0xe/0x10
> [  136.404914]  __do_softirq+0x104/0x59d
> [  136.405572]  asm_call_irq_on_stack+0x12/0x20
> [  136.406306]  </IRQ>
> [  136.406760]  do_softirq_own_stack+0x6f/0x80
> [  136.407484]  irq_exit_rcu+0xf3/0x100
> [  136.408134]  sysvec_apic_timer_interrupt+0x4b/0xb0
> [  136.408946]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  136.409798] RIP: 0010:default_idle+0x1c/0x20
> [  136.410536] Code: eb cd 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44 00 00 55 48 89 e5 e8 b2 b1 a6 fe e9 07 00 00 00 0f 00 2d 26 f1 5c 00 fb f4 <5d> c3 cc cc 0f 1f 44 00 00 55 48 89 e5 41 55 4c 8b 2d 8e c2 00 02
> [  136.413291] RSP: 0018:ffffc9000011fda8 EFLAGS: 00000206
> [  136.414150] RAX: 00000000000cc0ed RBX: 0000000000000005 RCX: dffffc0000000000
> [  136.415256] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8285578e
> [  136.416364] RBP: ffffc9000011fda8 R08: 0000000000000001 R09: 0000000000000001
> [  136.417474] R10: ffff8881e877546b R11: ffffed103d0eea8d R12: 0000000000000005
> [  136.418579] R13: ffffffff84538220 R14: 0000000000000000 R15: ffff888100808000
> [  136.419694]  ? default_idle+0xe/0x20
> [  136.420340]  ? default_idle+0xe/0x20
> [  136.420995]  arch_cpu_idle+0x15/0x20
> [  136.421640]  default_idle_call+0x95/0x2c0
> [  136.422343]  do_idle+0x3bd/0x480
> [  136.422947]  ? arch_cpu_idle_exit+0x40/0x40
> [  136.423679]  cpu_startup_entry+0x20/0x30
> [  136.424369]  start_secondary+0x1c7/0x220
> [  136.425067]  ? set_cpu_sibling_map+0xdc0/0xdc0
> [  136.425829]  ? set_bringup_idt_handler.constprop.0+0x84/0x90
> [  136.426746]  ? start_cpu0+0xc/0xc
> [  136.427357]  secondary_startup_64_no_verify+0xb0/0xbb
> 

-- 
Pavel Begunkov
