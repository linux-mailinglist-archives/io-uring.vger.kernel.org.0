Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790422E22AA
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 00:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgLWXS3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 18:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgLWXS3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 18:18:29 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9013DC061794;
        Wed, 23 Dec 2020 15:17:48 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r7so681928wrc.5;
        Wed, 23 Dec 2020 15:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6Z1YQfiMV12KNulwcvDymZIbv7Kgx450hggix81RygQ=;
        b=cf2Y4YvCJnniwp5BZiGxaLBUV6fE6vO5tg6xFdm/sac8i9ca85ZJ24V455jCHDCLFb
         6SH8OEpkEbAQzX31Z0JmHu1H7D+0E6m4c+VTND2eCoqk3OMdWA0DTLQnpbdYddG5/504
         /7Csm+G45ZzDkYcvmHbC//XlC3KejgtZEyNGcvDmiS/sbbjat60wKFfriFEmJe7jFMzP
         7vSmn9xoTXlIJ/9BnFMkTCaC2UFZF7ZPM5zOAGeyD0qVRfJSBRIsq4xfX9qzPdZpk5uj
         YNh5Xhb4CTXOGP57fHDNxLFd1dC+KzSqxqigMicvKzJ4VXEow04AWgSP7NB5ARy7ImDa
         SMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Z1YQfiMV12KNulwcvDymZIbv7Kgx450hggix81RygQ=;
        b=jUtC+OLTpIINoE/83zfXuSmWZ16GcpsQKV81LDKtJeVkLWSHq5OTFFbCGCYJPvCmy4
         z7zBc+a9MBIHIw6q/BdkE6qV80+UG5jwzu6YXsN5VwkZHuj2jb2rAbyJ8zHnLFcTx67m
         UtbGaWLizycH8SZUOKMzgDzogiBFAbVO0CTIFwlBnrSo6WYsh+mqNwErIDAAst14Fj0n
         LPVxOH8lt0js+9E6IgwzpuPG+a9RicyohVM9bi29SS25lbTGjQ4MUybWWhHOYWwDnChk
         Elg6vN8tAv0tPoYhlfi/pW7ZIcT5UwlqTL4kpPOMCKWJlro0cEbMCZffeXCQ/ZC1BKHC
         rpCg==
X-Gm-Message-State: AOAM533IpfNa6MchYmBp5sseOkzYo8nYf5301quaisoQiC7j++t2WNC/
        lUShIOGSQhuuCKtHMdyobPoWfSoLuYCjVA==
X-Google-Smtp-Source: ABdhPJxmRiAsfRcsV3gUC8T6uVwd/AES68LFjFovvcA7Ll/DoZrNUCds2/WbPjfku0cIGkqNpiiLGg==
X-Received: by 2002:a05:6000:11c1:: with SMTP id i1mr31924546wrx.16.1608765467298;
        Wed, 23 Dec 2020 15:17:47 -0800 (PST)
Received: from [192.168.8.148] ([85.255.233.85])
        by smtp.gmail.com with ESMTPSA id u6sm38616340wrm.90.2020.12.23.15.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 15:17:46 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in io_ring_ctx_wait_and_kill
To:     syzbot <syzbot+fef004c4db2d363bacd3@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000d26fda05b6db3298@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c92727c5-125a-3e9c-b5ba-02e1d18455fc@gmail.com>
Date:   Wed, 23 Dec 2020 23:14:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000d26fda05b6db3298@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/12/2020 01:24, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a409ed15 Merge tag 'gpio-v5.11-1' of git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1425527b500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f7c39e7211134bc0
> dashboard link: https://syzkaller.appspot.com/bug?extid=fef004c4db2d363bacd3
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.

#syz dup: WARNING in percpu_ref_kill_and_confirm (2)

> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+fef004c4db2d363bacd3@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __mutex_lock_common kernel/locking/mutex.c:938 [inline]
> BUG: KASAN: use-after-free in __mutex_lock+0x102f/0x1110 kernel/locking/mutex.c:1103
> Read of size 8 at addr ffff888073de33e0 by task syz-executor.1/13101
> 
> CPU: 1 PID: 13101 Comm: syz-executor.1 Not tainted 5.10.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  __mutex_lock_common kernel/locking/mutex.c:938 [inline]
>  __mutex_lock+0x102f/0x1110 kernel/locking/mutex.c:1103
>  io_ring_ctx_wait_and_kill+0x21/0x450 fs/io_uring.c:8648
>  io_uring_release+0x3e/0x50 fs/io_uring.c:8687
>  __fput+0x283/0x920 fs/file_table.c:280
>  task_work_run+0xdd/0x190 kernel/task_work.c:140
>  exit_task_work include/linux/task_work.h:30 [inline]
>  do_exit+0xb89/0x2a00 kernel/exit.c:823
>  do_group_exit+0x125/0x310 kernel/exit.c:920
>  get_signal+0x3e9/0x2160 kernel/signal.c:2770
>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e149
> Code: Unable to access opcode bytes at RIP 0x45e11f.
> RSP: 002b:00007f2290236be8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
> RAX: fffffffffffffff4 RBX: 0000000020000080 RCX: 000000000045e149
> RDX: 00000000200b0000 RSI: 0000000020000080 RDI: 0000000000000001
> RBP: 000000000119c080 R08: 0000000020000000 R09: 0000000020000000
> R10: 0000000020000100 R11: 0000000000000206 R12: 00000000200b0000
> R13: 00000000200a0000 R14: 0000000020000000 R15: 0000000020000100
> 
> Allocated by task 13101:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
>  kmalloc include/linux/slab.h:552 [inline]
>  kzalloc include/linux/slab.h:682 [inline]
>  io_ring_ctx_alloc fs/io_uring.c:1268 [inline]
>  io_uring_create fs/io_uring.c:9480 [inline]
>  io_uring_setup+0x1d5b/0x38b0 fs/io_uring.c:9613
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 37:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
>  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:352
>  __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
>  slab_free_hook mm/slub.c:1544 [inline]
>  slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
>  slab_free mm/slub.c:3140 [inline]
>  kfree+0xdb/0x3c0 mm/slub.c:4122
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> 
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:343
>  insert_work+0x48/0x370 kernel/workqueue.c:1331
>  __queue_work+0x5c1/0xfb0 kernel/workqueue.c:1497
>  queue_work_on+0xc7/0xd0 kernel/workqueue.c:1524
>  io_uring_create fs/io_uring.c:9586 [inline]
>  io_uring_setup+0x1358/0x38b0 fs/io_uring.c:9613
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The buggy address belongs to the object at ffff888073de3000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 992 bytes inside of
>  2048-byte region [ffff888073de3000, ffff888073de3800)
> The buggy address belongs to the page:
> page:000000002686ff6f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x73de0
> head:000000002686ff6f order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head)
> raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010842000
> raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888073de3280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888073de3300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff888073de3380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                        ^
>  ffff888073de3400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888073de3480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

-- 
Pavel Begunkov
