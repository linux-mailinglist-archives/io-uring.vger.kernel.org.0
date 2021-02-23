Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDBA32243A
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBWCg3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhBWCg0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:36:26 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2470C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 18:35:46 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d16so80063plg.0
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 18:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OS+Kx7xKhToNJGP5JPCYO0pnu5N6gZydEtshbyrAgDA=;
        b=PSZtVm4MDH22cwpGJZWMei7fVPPskIZkN3/dT+O9JT/66d5XJagUzJIEk5P8ojZ2nx
         YYQK/qSy3oeEQNEyKjoC6llQxFL+49xHD76aTfyMdIVI+bFeOi4p4j8wGipSXfPwUOF5
         DTz3tKBfsRtNtt/+6ob1qQYtsVFMSkvd0RWXomGz5a0XEJuAf20YkeQGEKwCiN06x81G
         IBQzvLC7KH9xrOZNnnC1R7/rzR1YdcSEPKYG7UK0rp6JQkE+UWdBMYURs1U2Ap9RMRaH
         PEdMKwcMHuYGVJA5eU3WRfnO6MCjZKQIuxzv81JVLl6b671EY9tfmIaxeb94TrS7myJC
         fZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OS+Kx7xKhToNJGP5JPCYO0pnu5N6gZydEtshbyrAgDA=;
        b=VZoK6AGdaRIoKoYziI12qt5ZklOvql5o31sIEWSUwDoMpam7VHkjzLIq0w0HWUWRuq
         MU7GslQYx4m0DPz1qtafIqvXM1G+K/ctDs47D/9owsCGyvekNrSnBiGDotOL3w/xwLxS
         R9yRwYEvdetbmxw1qcRMDJyn8pX+SU7/KUIxPCS29eH7pSbm69KtT7jxKmqM2MoZwdWg
         MELG4sMHzqIYSKa3RhsbmER1fWzCc+7nD28uUo0sSMLwlZGYUFv/LXUQSTSHLPGHhWor
         NVnwgINlvoKORtna5gVkTM6ORuYlKX3l0A7hR8xRr9ETE8FCE0nnpSpuHdYOn1uWWkvm
         pgoA==
X-Gm-Message-State: AOAM531HQ6WN1mxO1EN8Ay84i0R7J2vsA6S8rrpydE2UQZaGlrLUHNPF
        hdUxa42QMjWXzNV7p8UeM06g4GW5E5gm5Q==
X-Google-Smtp-Source: ABdhPJwrsAJ734gUPpO9If8JW4jOEXiYN9M9YdEYmw4X3Fjq4jHB0JTbpIIrZknpp3LU43eWjqzQDQ==
X-Received: by 2002:a17:90a:16d7:: with SMTP id y23mr12941625pje.227.1614047746182;
        Mon, 22 Feb 2021 18:35:46 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21e8::11af? ([2620:10d:c090:400::5:c361])
        by smtp.gmail.com with ESMTPSA id y12sm853624pjc.56.2021.02.22.18.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 18:35:45 -0800 (PST)
Subject: Re: KASAN: invalid-free in io_req_caches_free
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+30b4936dcdb3aafa4fb4@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000007786a205bbe9a5d6@google.com>
 <20210223022515.2846-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3eddab97-3539-51a0-e3fc-786f7ef7c93e@kernel.dk>
Date:   Mon, 22 Feb 2021 19:35:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210223022515.2846-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/21 7:25 PM, Hillf Danton wrote:
> Mon, 22 Feb 2021 01:44:21 -0800
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    31caf8b2 Merge branch 'linus' of git://git.kernel.org/pub/..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15a8afa6d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5a8f3a57fabb4015
>> dashboard link: https://syzkaller.appspot.com/bug?extid=30b4936dcdb3aafa4fb4
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+30b4936dcdb3aafa4fb4@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: double-free or invalid-free in io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
>>
>> CPU: 1 PID: 243 Comm: kworker/u4:6 Not tainted 5.11.0-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: events_unbound io_ring_exit_work
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:79 [inline]
>>  dump_stack+0xfa/0x151 lib/dump_stack.c:120
>>  print_address_description.constprop.0.cold+0x5b/0x2c6 mm/kasan/report.c:230
>>  kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:355
>>  ____kasan_slab_free+0xcc/0xe0 mm/kasan/common.c:341
>>  kasan_slab_free include/linux/kasan.h:192 [inline]
>>  __cache_free mm/slab.c:3424 [inline]
>>  kmem_cache_free_bulk+0x4b/0x1b0 mm/slab.c:3744
>>  io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
>>  io_ring_ctx_free fs/io_uring.c:8764 [inline]
>>  io_ring_exit_work+0x518/0x6b0 fs/io_uring.c:8846
>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>
>> Allocated by task 11900:
>>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>  kasan_set_track mm/kasan/common.c:46 [inline]
>>  set_alloc_info mm/kasan/common.c:401 [inline]
>>  ____kasan_kmalloc.constprop.0+0x7f/0xa0 mm/kasan/common.c:429
>>  kasan_slab_alloc include/linux/kasan.h:209 [inline]
>>  slab_post_alloc_hook mm/slab.h:512 [inline]
>>  kmem_cache_alloc_bulk+0x2c2/0x460 mm/slab.c:3534
>>  io_alloc_req fs/io_uring.c:2014 [inline]
>>  io_submit_sqes+0x18e8/0x2b60 fs/io_uring.c:6915
>>  __do_sys_io_uring_enter+0x1154/0x1f50 fs/io_uring.c:9454
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Freed by task 11900:
>>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
>>  ____kasan_slab_free+0xb0/0xe0 mm/kasan/common.c:362
>>  kasan_slab_free include/linux/kasan.h:192 [inline]
>>  __cache_free mm/slab.c:3424 [inline]
>>  kmem_cache_free_bulk+0x4b/0x1b0 mm/slab.c:3744
>>  io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
>>  io_uring_flush+0x483/0x6e0 fs/io_uring.c:9237
>>  filp_close+0xb4/0x170 fs/open.c:1286
>>  close_files fs/file.c:403 [inline]
>>  put_files_struct fs/file.c:418 [inline]
>>  put_files_struct+0x1d0/0x350 fs/file.c:415
>>  exit_files+0x7e/0xa0 fs/file.c:435
>>  do_exit+0xc27/0x2ae0 kernel/exit.c:820
>>  do_group_exit+0x125/0x310 kernel/exit.c:922
>>  get_signal+0x42c/0x2100 kernel/signal.c:2773
>>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>>  handle_signal_work kernel/entry/common.c:147 [inline]
>>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>>  exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
>>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> The buggy address belongs to the object at ffff888012eaae00
>>  which belongs to the cache io_kiocb of size 208
>> The buggy address is located 0 bytes inside of
>>  208-byte region [ffff888012eaae00, ffff888012eaaed0)
>> The buggy address belongs to the page:
>> page:0000000091458aed refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12eaa
>> flags: 0xfff00000000200(slab)
>> raw: 00fff00000000200 ffff8880188dcd50 ffff8880188dcd50 ffff888141b4ff00
>> raw: 0000000000000000 ffff888012eaa040 000000010000000c 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>  ffff888012eaad00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>  ffff888012eaad80: fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ffff888012eaae00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                    ^
>>  ffff888012eaae80: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
>>  ffff888012eaaf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ==================================================================
> 
> Fix double free by reverting 41be53e94fb0 ("io_uring: kill cached
> requests from exiting task closing the ring") - it ruins kworker's life.
> 
> --- x/fs/io_uring.c
> +++ y/fs/io_uring.c
> @@ -9234,7 +9234,6 @@ static int io_uring_flush(struct file *f
>  
>  	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
>  		io_uring_cancel_task_requests(ctx, NULL);
> -		io_req_caches_free(ctx, current);
>  	}
>  
>  	if (!tctx)

Already merged the right fix this morning:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.12/io_uring&id=8e5c66c485a8af3f39a8b0358e9e09f002016d92

-- 
Jens Axboe

