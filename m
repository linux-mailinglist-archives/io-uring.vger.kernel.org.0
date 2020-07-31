Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBB1233D1A
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 04:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731099AbgGaCIE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 22:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730904AbgGaCIE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 22:08:04 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85D6C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 19:08:02 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b9so15957475plx.6
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 19:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nLMVNXFtpHSwzxcoLcpKiB2ROQqZU2Vxtotq7jh7W6E=;
        b=KoXVTiaINuYY0E/RH91J0MvozsPDygrPr+7aRqO9B/i3tLk6/C70KqShJFbpZfe/Mh
         SQ2wy4EWzK3mEtZJJc6evwSIFDnknQBoPshGPz9TS1MQHKFAbXT1a7U++nTN9bDUXoCk
         EirlXrsY79UY7IXdsxwVR6vGWTYMED0UdcqrUX+tm3NaYso2Py/MHWbRfuJduK85beDN
         nQAVEg+eijWwh3EV6NZM9LuM/Tvwqpm9RZvwDRTzcpm4IwmNxIkfemv1vMTTPCy1m/Ok
         Cn4SVzdIGijeRRxZrQTu20SUc9L5hEF98Zxtj1qCimXH/eE3EjS1H2ydTAOFQamsTcRf
         diTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nLMVNXFtpHSwzxcoLcpKiB2ROQqZU2Vxtotq7jh7W6E=;
        b=RAV8oXH62pPiXNTB6wsRs6WibtW2ioW050WwWUYLczviZvT6ERm4y/zAzHQe8q/4Z4
         jD0j+I+qG6xuozRO+mpiKKgHpvXcSZ+ngP89E3KC33C/kwQe59js1NO3gF/Z+NSl3bwJ
         HEffExvPhROKhhe+ojYq9hthfz1qbPEx0W0Il3k/AAAmIRG91LD94HKulJBKnBnS1mE4
         aW6xnIY8cWMS+FkSPyFhs55Hr/bF3+KitaqDsUZNoyrbPGM0eyPEdwDxE/KkazT8lkQ3
         JO9N4iIBkfaGKT7THbbEhOHnxRbVrjbTHXiOZTYkKenI0tO2HqX50zbByOr/nhxyGJK0
         ElPA==
X-Gm-Message-State: AOAM532wUyHrOEDMXoQYHJtZBzihmy2HVapauuj1Rt4eCsjdOlK1sbeC
        Gka0YnYGwR7s1jHfLBPgJsIKYg==
X-Google-Smtp-Source: ABdhPJyjFrG6R7wOWaWSmH7CBiI5qqg+IwqUSN64uX34Ls0PqERrqQHYCeRvZqWemOUKG8RaWFH2ZA==
X-Received: by 2002:a17:90a:e551:: with SMTP id ei17mr1897767pjb.224.1596161282053;
        Thu, 30 Jul 2020 19:08:02 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i21sm7983578pfa.18.2020.07.30.19.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 19:08:01 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in io_uring_setup (2)
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, Markus Elfring <Markus.Elfring@web.de>
References: <20200731014541.11944-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <51f9fd65-c4ef-3ee6-c4dc-e76c88446350@kernel.dk>
Date:   Thu, 30 Jul 2020 20:07:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731014541.11944-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 7:45 PM, Hillf Danton wrote:
> 
> Thu, 30 Jul 2020 12:21:18 -0700
>> syzbot found the following issue on:
>>
>> HEAD commit:    04b45717 Add linux-next specific files for 20200729
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=173774b8900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ec68f65b459f1ed
>> dashboard link: https://syzkaller.appspot.com/bug?extid=9d46305e76057f30c74e
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in io_account_mem fs/io_uring.c:7397 [inline]
>> BUG: KASAN: use-after-free in io_uring_create fs/io_uring.c:8369 [inline]
>> BUG: KASAN: use-after-free in io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
>> Read of size 1 at addr ffff888087a41044 by task syz-executor.5/18145
>>
>> CPU: 0 PID: 18145 Comm: syz-executor.5 Not tainted 5.8.0-rc7-next-20200729-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>>  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
>>  __kasan_report mm/kasan/report.c:513 [inline]
>>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>>  io_account_mem fs/io_uring.c:7397 [inline]
>>  io_uring_create fs/io_uring.c:8369 [inline]
>>  io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x45c429
>> Code: 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007f8f121d0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: ffffffffffffffda RBX: 0000000000008540 RCX: 000000000045c429
>> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000196
>> RBP: 000000000078bf38 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
>> R13: 00007fff86698cff R14: 00007f8f121d19c0 R15: 000000000078bf0c
>>
>> Allocated by task 18145:
>>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>>  kasan_set_track mm/kasan/common.c:56 [inline]
>>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
>>  kmem_cache_alloc_trace+0x16e/0x2c0 mm/slab.c:3550
>>  kmalloc include/linux/slab.h:554 [inline]
>>  kzalloc include/linux/slab.h:666 [inline]
>>  io_ring_ctx_alloc fs/io_uring.c:1042 [inline]
>>  io_uring_create fs/io_uring.c:8313 [inline]
>>  io_uring_setup+0x4df/0x2910 fs/io_uring.c:8400
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Freed by task 15583:
>>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
>>  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
>>  __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
>>  __cache_free mm/slab.c:3418 [inline]
>>  kfree+0x103/0x2c0 mm/slab.c:3756
>>  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>>  kthread+0x3b5/0x4a0 kernel/kthread.c:292
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>
>> Last call_rcu():
>>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>>  kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
>>  __call_rcu kernel/rcu/tree.c:2883 [inline]
>>  call_rcu+0x14f/0x7e0 kernel/rcu/tree.c:2957
>>  __percpu_ref_switch_to_atomic lib/percpu-refcount.c:192 [inline]
>>  __percpu_ref_switch_mode+0x365/0x700 lib/percpu-refcount.c:237
>>  percpu_ref_kill_and_confirm+0x94/0x350 lib/percpu-refcount.c:350
>>  percpu_ref_kill include/linux/percpu-refcount.h:136 [inline]
>>  io_ring_ctx_wait_and_kill+0x38/0x600 fs/io_uring.c:7799
>>  io_uring_release+0x3e/0x50 fs/io_uring.c:7831
>>  __fput+0x285/0x920 fs/file_table.c:281
>>  task_work_run+0xdd/0x190 kernel/task_work.c:135
>>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>>  exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
>>  exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:166
>>  syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> The buggy address belongs to the object at ffff888087a41000
>>  which belongs to the cache kmalloc-2k of size 2048
>> The buggy address is located 68 bytes inside of
>>  2048-byte region [ffff888087a41000, ffff888087a41800)
>> The buggy address belongs to the page:
>> page:000000007a29a6b9 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x87a41
>> flags: 0xfffe0000000200(slab)
>> raw: 00fffe0000000200 ffffea0002386288 ffffea000253c0c8 ffff8880aa000800
>> raw: 0000000000000000 ffff888087a41000 0000000100000001 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>  ffff888087a40f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>  ffff888087a40f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ffff888087a41000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                                            ^
>>  ffff888087a41080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>  ffff888087a41100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ==================================================================
> 
> Add the missing percpu_ref_get when creating ctx.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8318,6 +8318,7 @@ static int io_uring_create(unsigned entr
>  		free_uid(user);
>  		return -ENOMEM;
>  	}
> +	percpu_ref_get(&ctx->refs);
>  	ctx->compat = in_compat_syscall();
>  	ctx->user = user;
>  	ctx->creds = get_current_cred();
> @@ -8369,8 +8370,10 @@ static int io_uring_create(unsigned entr
>  	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
>  		       ACCT_LOCKED);
>  	ctx->limit_mem = limit_mem;
> +	percpu_ref_put(&ctx->refs);
>  	return ret;
>  err:
> +	percpu_ref_put(&ctx->refs);
>  	io_ring_ctx_wait_and_kill(ctx);
>  	return ret;
>  }

The error path doesn't care, the issue is only after fd install. Hence
we don't need to grab a reference, just make sure we don't touch the ctx
after fd install. Since you saw this one, you must have also seen my
patch. Why not comment on that instead?

-- 
Jens Axboe

