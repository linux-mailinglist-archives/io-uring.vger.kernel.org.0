Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A205706787
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 14:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjEQMGT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 08:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjEQMFZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 08:05:25 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D331F83CB;
        Wed, 17 May 2023 05:02:53 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64395e741fcso607287b3a.2;
        Wed, 17 May 2023 05:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684324971; x=1686916971;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OD07jlyHmaC+Y1H6rdaVkNWpp8C8xv5eKqMPzHHNibM=;
        b=dWSWR2jLY5LcphwqEmW0leB88LxKJla6iomIpizRjjIVdfIZ+lAHzxZb8hIru/Mp7P
         +CM0CBZbXNYjt6pXFSTRaz5EM0ijNuzIuBi1wxMiLYhcfgLKzymRObgaIcqRhScf13wi
         6zlcFH+MxoZXOdHjxb1ozEvrzBPSTAGPPoxYmeFnyevdgyCm4uPumFF1CVP3JjFjxLy7
         uM4sYHoG8L0GWUg4X9eYNsDLTGCSQDI72uMR462c6lKbf0X9KnEzNo9mJsKh/JJs/Tpl
         +NeP+IXqCUB2kBX5UI3TaP8fuUxa1foIZt0rxrLdi4h7HdBWmz3J+6B64zN3mGEQoJo5
         JPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684324971; x=1686916971;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OD07jlyHmaC+Y1H6rdaVkNWpp8C8xv5eKqMPzHHNibM=;
        b=bI2JyTdnZ9mXmYdjKv+vlwFnwtDJCE4a2ijg2c5pRelm1A9GZbYBLhHrXQ8oLK1d/6
         IXQYMswexMzFUMD0oCA5vYe4U+KQ43pCU2n6QDhnEdcDcm0AWt99b0dBT4N7FRLPdcUo
         WHNIXYcNMu3bRQKVmaxbE70H7EyJxXR4FJOa5e7fVRgeMqjT7UF7R3f1vsUp7KyU2ttQ
         lFSDGn5eym/2yzoU8i8qotOgWFS5kY/ZX6wHrbX+69XqbFdwgrlAK/yE0qnzgxUTxNXQ
         LsAYoJ7cHsYBQuFEA9rEBv4K/QaJluBhqcAVB5TVhPitit9BN+KZAMtrzy7VcCaIohnG
         kVYw==
X-Gm-Message-State: AC+VfDzJiOsQymiMgufY9fJWNHtWhEacFQoThmLeuHLt/JlScZpYDXld
        hpGdwIcYnWrH41GEoKy7rb2XA1ogqRM3vUPvW6g=
X-Google-Smtp-Source: ACHHUZ4fm2xaqjxZ4K2RgDfEybuyhULw6rmAbnH2k+v3kri3b1llAqOpNGcyk0iukYC1KuT8QQBkATdKg0kaferYaUY=
X-Received: by 2002:a05:6a20:440d:b0:107:1f22:10d2 with SMTP id
 ce13-20020a056a20440d00b001071f2210d2mr5809735pzb.20.1684324970740; Wed, 17
 May 2023 05:02:50 -0700 (PDT)
MIME-Version: 1.0
From:   yang lan <lanyang0908@gmail.com>
Date:   Wed, 17 May 2023 20:02:38 +0800
Message-ID: <CAAehj2kcgtRta0ou6KQiyz33O4hf+_7jgndzV_neyQRj5BjSJQ@mail.gmail.com>
Subject: [Bug report] kernel panic: System is deadlocked on memory
To:     axboe@kernel.dk, gregkh@linuxfoundation.org, sashal@kernel.org,
        asml.silence@gmail.com, dylany@fb.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We use our modified Syzkaller to fuzz the Linux kernel and found the
following issue:

Head Commit: f1b32fda06d2cfb8eea9680b0ba7a8b0d5b81eeb
Git Tree: stable

Console output: https://pastebin.com/raw/Ssz6eVA6
Kernel config: https://pastebin.com/raw/BiggLxRg
C reproducer: https://pastebin.com/raw/tM1iyfjr
Syz reproducer: https://pastebin.com/raw/CEF1R2jg

root@syzkaller:~# uname -a
Linux syzkaller 5.10.179 #5 SMP PREEMPT Mon May 1 23:59:32 CST 2023
x86_64 GNU/Linux
root@syzkaller:~# gcc poc_io_uring_enter.c -o poc_io_uring_enter
root@syzkaller:~# ./poc_io_uring_enter
...
[  244.945440][ T3106]
oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0-1,global_oom,task_memcg=/,task=dhclient,pid=4526,uid=0
[  244.946537][ T3106] Out of memory: Killed process 4526 (dhclient)
total-vm:20464kB, anon-rss:1112kB, file-rss:0kB, shmem-rss:0kB, UID:0
pgtables:76kB oom_score_adj:0
[  244.953740][ T9068] syz-executor.0 invoked oom-killer:
gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=1000
[  244.954411][ T9068] CPU: 0 PID: 9068 Comm: syz-executor.0 Not
tainted 5.10.179 #5
[  244.954903][ T9068] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.12.0-1 04/01/2014
[  244.955515][ T9068] Call Trace:
[  244.955738][ T9068]  dump_stack+0x106/0x162
[  244.956026][ T9068]  dump_header+0x117/0x6f8
[  244.956315][ T9068]  ? ___ratelimit+0x1fc/0x430
[  244.956621][ T9068]  oom_kill_process.cold.34+0x10/0x15
[  244.956970][ T9068]  out_of_memory+0x122c/0x1540
[  244.957283][ T9068]  ? oom_killer_disable+0x270/0x270
[  244.957627][ T9068]  ? mutex_trylock+0x249/0x2c0
[  244.957937][ T9068]  ? __alloc_pages_slowpath.constprop.104+0x9fa/0x2250
[  244.958378][ T9068]  __alloc_pages_slowpath.constprop.104+0x1bec/0x2250
[  244.958818][ T9068]  ? warn_alloc+0x130/0x130
[  244.959117][ T9068]  ? find_held_lock+0x33/0x1c0
[  244.959429][ T9068]  ? __alloc_pages_nodemask+0x3e8/0x6c0
[  244.959789][ T9068]  ? lock_downgrade+0x6a0/0x6a0
[  244.960104][ T9068]  ? lock_release+0x660/0x660
[  244.960412][ T9068]  __alloc_pages_nodemask+0x5dd/0x6c0
[  244.960762][ T9068]  ? __alloc_pages_slowpath.constprop.104+0x2250/0x2250
[  244.961210][ T9068]  ? mark_held_locks+0xb0/0x110
[  244.961531][ T9068]  alloc_pages_current+0x100/0x200
[  244.961864][ T9068]  allocate_slab+0x302/0x490
[  244.962166][ T9068]  ___slab_alloc+0x4eb/0x820
[  244.962472][ T9068]  ? io_issue_sqe+0xf26/0x5d50
[  244.962782][ T9068]  ? __slab_alloc.isra.78+0x64/0xa0
[  244.963118][ T9068]  ? io_issue_sqe+0xf26/0x5d50
[  244.963427][ T9068]  ? __slab_alloc.isra.78+0x8b/0xa0
[  244.963762][ T9068]  __slab_alloc.isra.78+0x8b/0xa0
[  244.964106][ T9068]  ? should_failslab+0x5/0x10
[  244.964419][ T9068]  ? io_issue_sqe+0xf26/0x5d50
[  244.964727][ T9068]  kmem_cache_alloc_trace+0x22a/0x270
[  244.965077][ T9068]  io_issue_sqe+0xf26/0x5d50
[  244.965379][ T9068]  ? io_write+0xf50/0xf50
[  244.965662][ T9068]  ? io_submit_flush_completions+0x6a1/0x930
[  244.966051][ T9068]  ? io_req_free_batch+0x710/0x710
[  244.966380][ T9068]  ? allocate_slab+0x38c/0x490
[  244.966690][ T9068]  __io_queue_sqe.part.124+0xb1/0xb00
[  244.967036][ T9068]  ? kasan_unpoison_shadow+0x30/0x40
[  244.967378][ T9068]  ? __kasan_kmalloc.constprop.10+0xc1/0xd0
[  244.967760][ T9068]  ? io_issue_sqe+0x5d50/0x5d50
[  244.968075][ T9068]  ? kmem_cache_alloc_bulk+0xe1/0x250
[  244.968420][ T9068]  ? io_submit_sqes+0x1c47/0x7b00
[  244.968744][ T9068]  io_submit_sqes+0x1c47/0x7b00
[  244.969080][ T9068]  ? __x64_sys_io_uring_enter+0xcdd/0x11a0
[  244.969456][ T9068]  __x64_sys_io_uring_enter+0xcdd/0x11a0
[  244.969821][ T9068]  ? __io_uring_cancel+0x20/0x20
[  244.970144][ T9068]  ? get_vtime_delta+0x23d/0x360
[  244.970467][ T9068]  ? syscall_enter_from_user_mode+0x26/0x70
[  244.970849][ T9068]  do_syscall_64+0x2d/0x70
[  244.971136][ T9068]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[  244.971514][ T9068] RIP: 0033:0x46a8c9
[  244.971771][ T9068] Code: Unable to access opcode bytes at RIP 0x46a89f.
[  244.972208][ T9068] RSP: 002b:00007f4d887e0c38 EFLAGS: 00000246
ORIG_RAX: 00000000000001aa
[  244.972747][ T9068] RAX: ffffffffffffffda RBX: 000000000057bf80
RCX: 000000000046a8c9
[  244.973253][ T9068] RDX: 0000000000000000 RSI: 00000000000051cd
RDI: 0000000000000003
[  244.973792][ T9068] RBP: 00000000004c9f3b R08: 0000000000000000
R09: 0000000000000000
[  244.974299][ T9068] R10: 0000000000000000 R11: 0000000000000246
R12: 000000000057bf80
[  244.974802][ T9068] R13: 00007ffd88d30d4f R14: 000000000057bf80
R15: 00007ffd88d30f00
[  244.980610][ T9068] Mem-Info:
[  244.980840][ T9068] active_anon:166 inactive_anon:8300 isolated_anon:0
[  244.980840][ T9068]  active_file:2 inactive_file:3 isolated_file:0
[  244.980840][ T9068]  unevictable:0 dirty:0 writeback:0
[  244.980840][ T9068]  slab_reclaimable:12481 slab_unreclaimable:279862
[  244.980840][ T9068]  mapped:52225 shmem:6769 pagetables:446 bounce:0
[  244.980840][ T9068]  free:9671 free_pcp:453 free_cma:0
...
[  245.694692][ T2959] Kernel Offset: disabled
[  245.695139][ T2959] Rebooting in 86400 seconds..

Please let me know if I can provide any more information, and I hope I
didn't mess up this bug report.

Regards,

Yang
