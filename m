Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADF445F02A
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 15:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348782AbhKZOzG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 09:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377867AbhKZOxG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 09:53:06 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09172C06137D;
        Fri, 26 Nov 2021 06:28:03 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 137so8305437wma.1;
        Fri, 26 Nov 2021 06:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=2XEuwJuHQeP5++KA0ad4L7hKXmsZcsY1xFhTMQARjsw=;
        b=l+I4inNo2yy0clInNiXAtdQJ2Qgp9Bf7uKBg8V8iJ311MIM5OHl2pGFiVpfqy/dZzg
         Ct0UJCDYlMbwYiLj8ucnj9ulef8krtmkMXwshb3G+2XDvmA90lH03EukA2CO06iPir07
         XjvXdC/rqZSpoqX9/wu3ZOAIJjwtWkfyhjtEy6m9RKHqLvFVkWqbkjKovWFrkIUf2anq
         7UQykoXm9bKn31w1DINz8ITnLD40E1tqlKuO1lyKAzcWHNtMYetCTifK8ijq7MUew/cm
         ayLvscWWxcnT9PqKhelJjxpONA1xtiL+dA0tamEQSQm61LFX0/0etZZr9TVgngjolB46
         IFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2XEuwJuHQeP5++KA0ad4L7hKXmsZcsY1xFhTMQARjsw=;
        b=CGn+LF/8n5yDIVQTRQFPSqhmcUXqwzC02WyXXBGdMPTV8/oBCHu/dq990MZDu9UkFv
         5OAThZV9gjJJ7UvFfqXMQs89c5HX8sS7/jMns47YzjkoDjZ8KMEvtAS9Ywc7EJ1LRwKO
         DaC2I46uJE2eS9Wodq+9T0mjzOz55JxeNgVsmxDoxuGSJtttcTL44qrZFrQe4PcTbSgj
         furELBGuNMb6saEqDC0hsSAL8w54U0Sk7oSem6HTaxaIE2HlMGVyRzMBKMd33b4H+v7X
         X+DP1MsLCIp5eFNoBchLTA//eG3xHjh1YHwr7o7zHarPIJdttcyjgqTNbACh1QUXWp/Z
         23mQ==
X-Gm-Message-State: AOAM530TeWKVuXRtgJcmMY0LvJRFK8qeE1e3xcTHVSq8qLl2811sgSge
        3lgi7aUXzcULi6eFDYbKlo4=
X-Google-Smtp-Source: ABdhPJx7dxPJ2c6mXKIgj3/dP8uw+0BV5AYQ9NY8+euP6GxuhOvFcMUTd4pPWFmRjq/AkSSHfVKYiQ==
X-Received: by 2002:a05:600c:282:: with SMTP id 2mr16082544wmk.91.1637936881351;
        Fri, 26 Nov 2021 06:28:01 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id b6sm11850110wmq.45.2021.11.26.06.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 06:28:00 -0800 (PST)
Message-ID: <ab93169d-d2ba-2aac-ca66-de284f09c4bb@gmail.com>
Date:   Fri, 26 Nov 2021 14:28:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] possible deadlock in __io_commit_cqring_flush
Content-Language: en-US
To:     syzbot <syzbot+ff49a3059d49b0ca0eec@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000001729c705d1b065f7@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000001729c705d1b065f7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 12:40, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz dup: possible deadlock in io_flush_timeouts

> 
> HEAD commit:    a4849f6000e2 Merge tag 'drm-fixes-2021-11-26' of git://ano..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10d5f726b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=75f05fb8d1a152d3
> dashboard link: https://syzkaller.appspot.com/bug?extid=ff49a3059d49b0ca0eec
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ff49a3059d49b0ca0eec@syzkaller.appspotmail.com
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.16.0-rc2-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor.1/8766 is trying to acquire lock:
> ffff888096b57418 (&ctx->timeout_lock){+.+.}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:374 [inline]
> ffff888096b57418 (&ctx->timeout_lock){+.+.}-{2:2}, at: io_flush_timeouts fs/io_uring.c:1587 [inline]
> ffff888096b57418 (&ctx->timeout_lock){+.+.}-{2:2}, at: __io_commit_cqring_flush+0x108/0x50d fs/io_uring.c:1618
> 
> but task is already holding lock:
> ffff888096b57418 (&ctx->timeout_lock){+.+.}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:374 [inline]
> ffff888096b57418 (&ctx->timeout_lock){+.+.}-{2:2}, at: io_poll_remove_all+0x50/0x235 fs/io_uring.c:5702
> 
> other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&ctx->timeout_lock);
>    lock(&ctx->timeout_lock);
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation
> 
> 2 locks held by syz-executor.1/8766:
>   #0: ffff888096b573d8 (&ctx->completion_lock#2){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
>   #0: ffff888096b573d8 (&ctx->completion_lock#2){+.+.}-{2:2}, at: io_poll_remove_all+0x48/0x235 fs/io_uring.c:5701
>   #1: ffff888096b57418 (&ctx->timeout_lock){+.+.}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:374 [inline]
>   #1: ffff888096b57418 (&ctx->timeout_lock){+.+.}-{2:2}, at: io_poll_remove_all+0x50/0x235 fs/io_uring.c:5702
> 
> stack backtrace:
> CPU: 0 PID: 8766 Comm: syz-executor.1 Not tainted 5.16.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
>   check_deadlock kernel/locking/lockdep.c:2999 [inline]
>   validate_chain kernel/locking/lockdep.c:3788 [inline]
>   __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5027
>   lock_acquire kernel/locking/lockdep.c:5637 [inline]
>   lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
>   __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
>   _raw_spin_lock_irq+0x32/0x50 kernel/locking/spinlock.c:170
>   spin_lock_irq include/linux/spinlock.h:374 [inline]
>   io_flush_timeouts fs/io_uring.c:1587 [inline]
>   __io_commit_cqring_flush+0x108/0x50d fs/io_uring.c:1618
>   io_commit_cqring fs/io_uring.c:1626 [inline]
>   io_poll_remove_one fs/io_uring.c:5684 [inline]
>   io_poll_remove_one.cold+0xd/0x12 fs/io_uring.c:5674
>   io_poll_remove_all+0x1af/0x235 fs/io_uring.c:5709
>   io_ring_ctx_wait_and_kill+0x1cc/0x322 fs/io_uring.c:9534
>   io_uring_release+0x42/0x46 fs/io_uring.c:9554
>   __fput+0x286/0x9f0 fs/file_table.c:280
>   task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>   tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>   exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>   syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f087b422ae9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0878977188 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: 0000000020ffa000 RBX: 00007f087b536020 RCX: 00007f087b422ae9
> RDX: 0000000003000001 RSI: 0000000000004000 RDI: 0000000020ffa000
> RBP: 00007f087b47cf6d R08: 0000000000000003 R09: 0000000010000000
> R10: 0000000000000012 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffe7626bd9f R14: 00007f0878977300 R15: 0000000000022000
>   </TASK>
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
