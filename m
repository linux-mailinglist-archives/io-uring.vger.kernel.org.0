Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12F3407E1
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 15:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhCROcP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 10:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhCROcK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 10:32:10 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDBBC06174A;
        Thu, 18 Mar 2021 07:32:10 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z2so5765121wrl.5;
        Thu, 18 Mar 2021 07:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N9C16pv3YvAGZwGMAE37iPjr2CisJKt6ekARv9UjYvE=;
        b=sLrhp0Bxsk/IUt0ULHK0cGJxL9z0G9Z+4olgI/rSzMAURuOhb6spTJ9IrPmyZesrDQ
         A8wSj1qUDqFzO41JlpxREAGLXJemwyF+btWqiPqrNpz2bHP1aXX730hpK4Q2st+wixW4
         IufWfoeJiUca91cVuVmKEy4LF9vlbsgEvI/OXYN6E+y5ERUL27BiRrY8/y1oYa2oTGE9
         rLAXVG7pOy6kf+ibYJTcWmmmIYrH2/UOx28LsBKuPeKkYDcvugM/coA4cCnelgLQaW29
         LFGWHsPNiK0O0J4rBeJzSepmlEqB2PbrCsuvmVZLF4qHp/zYh6bqg2dOnfhTDgbFGd8v
         X1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=N9C16pv3YvAGZwGMAE37iPjr2CisJKt6ekARv9UjYvE=;
        b=WYVPYASdQzst9/JXlSOl8a45WrjAqLGQNv7LPjCwmrdUfiuUau4Hqpbyr4KCZhoPjK
         mvJSM8jYy/U1uwIrShv40CYKFwXnLvVEi/pAvT+nIu6qjcI/HDq2AnC9JZIU735w4qZw
         nB2Bu8TLQ0lzbmbZ1xeO25iXgU3CyZnYJAU4kHcp8DMh+RTFqcYvIjYYqXxqKldlf0wG
         prlZdlBmqiLn11/oBs3ZNLr/kDcYcNx5/sBZEo3KBb41VU9adJguUw010DSf5Vd3HmDh
         h5uu86ZPMTKmbVvUgdLJlkImf2q8NdVJApV4ev+WJoTHbckh8L4pEg3zrMfwJ/eJ6u5z
         RKoA==
X-Gm-Message-State: AOAM530jx6o4BQkLPjvWB73d9sAerGH2NMEd0jZjJOvt6Q/v4LvfBvo5
        yI8QMhv2+IMVAS1GPO9f11GgXena4K8ZBg==
X-Google-Smtp-Source: ABdhPJyokMg1eZkshb5NMWm4U58K7jrLL+7+Bzk1fkXaSCeJEpB8/wb2x/xrPoDLgcJxOHVv+AVu1A==
X-Received: by 2002:a5d:558b:: with SMTP id i11mr9839051wrv.176.1616077929091;
        Thu, 18 Mar 2021 07:32:09 -0700 (PDT)
Received: from [192.168.8.170] ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id z2sm3814211wrm.0.2021.03.18.07.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 07:32:08 -0700 (PDT)
To:     Hillf Danton <hdanton@sina.com>, Ming Lei <ming.lei@redhat.com>
Cc:     syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000006e9e0705bd91f762@google.com>
 <20210318083340.1900-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
Message-ID: <79ce5bcd-b314-dded-0b36-0a8fb66f5a7a@gmail.com>
Date:   Thu, 18 Mar 2021 14:28:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210318083340.1900-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/03/2021 08:33, Hillf Danton wrote:
> On Mon, 15 Mar 2021 12:18:20 +0000 Pavel Begunkov wrote:
>> On 15/03/2021 11:58, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    75013c6c Merge tag 'perf_urgent_for_v5.12-rc3' of git://gi..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=174df32ad00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=844457676c06b88c
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
>>> userspace arch: i386
>>>
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 1 PID: 53 at lib/percpu-refcount.c:113 __percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113
>>
>> if (percpu_count) {
>> 	/* non-NULL confirm_switch indicates switching in progress */
>> 	WARN_ON_ONCE(ref->data && ref->data->confirm_switch);
>> 	...
>> }
>>
>> Points to this warning. Not sure, but not yet included
>> "io_uring: halt SQO submission on ctx exit" may fix it or at least is
>> related.
> 
> Seems it does not, nor related, see below.
>>
>>> Modules linked in:
>>> CPU: 1 PID: 53 Comm: kworker/u4:2 Not tainted 5.12.0-rc2-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> Workqueue: events_unbound io_ring_exit_work
>>> RIP: 0010:__percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113
>>> Code: fd 49 8d 7c 24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 61 49 83 7c 24 10 00 74 07 e8 28 42 ac fd <0f> 0b e8 21 42 ac fd 48 89 ef e8 e9 fa da fd 48 89 da 48 b8 00 00
>>> RSP: 0018:ffffc90000f1fb78 EFLAGS: 00010293
>>> RAX: 0000000000000000 RBX: ffff88805c976000 RCX: 0000000000000000
>>> RDX: ffff888011839bc0 RSI: ffffffff83c76be8 RDI: ffff88802b2a9010
>>> RBP: 0000607f46077778 R08: 0000000000000000 R09: ffffffff8fab0967
>>> R10: ffffffff83c76b88 R11: 0000000000000009 R12: ffff88802b2a9000
>>> R13: 0000000000000001 R14: ffff88802b2a9000 R15: dffffc0000000000
>>> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00000000085a0004 CR3: 000000001896a000 CR4: 00000000001506f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> Call Trace:
>>>  percpu_ref_exit+0x3b/0x140 lib/percpu-refcount.c:134
>>>  io_ring_ctx_free fs/io_uring.c:8419 [inline]
>>>  io_ring_exit_work+0x599/0xcf0 fs/io_uring.c:8565
>>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>>>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>>>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>>
>>>
>>> ---
>>> This report is generated by a bot. It may contain errors.
>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this issue. See:
>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>>
>>
>> -- 
>> Pavel Begunkov
> 
> Thoughts for sync RCU are appreciated if the chance for the race
> between rcu and workqueue is not zero on killing io ctx.

Would you elaborate? Because your case below doesn't make much
sense.

1) io_ring_ctx_wait_and_kill() indeed kills ctx->refs
2) io_ring_exit_work() waits for a completion signaled by
ctx->refs hitting 0
3) and only then calls io_ring_ctx_free().

And 2) won't complete until the switching is over

> 
> CPU0
> ----
> io_ring_ctx_wait_and_kill
> percpu_ref_kill(&ctx->refs);
> percpu_ref_kill_and_confirm(ref, NULL);
> spin_lock_irqsave(&percpu_ref_switch_lock, flags);
> __percpu_ref_switch_mode(ref, confirm_switch);
>   __percpu_ref_switch_to_atomic
>     ref->data->confirm_switch = confirm_switch ?:
> 		percpu_ref_noop_confirm_switch;
>     call_rcu(&ref->data->rcu, percpu_ref_switch_to_atomic_rcu);
> spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
> 
> INIT_WORK(&ctx->exit_work, io_ring_exit_work);
> queue_work(system_unbound_wq, &ctx->exit_work);
> 
> 						CPU1
> 						----
> 						io_ring_exit_work
> 						io_ring_ctx_free(ctx);
> 						percpu_ref_exit(&ctx->refs);
> 						__percpu_ref_exit(ref);
> 						WARN_ON_ONCE(ref->data &&
> 							ref->data->confirm_switch);
> 
> 
> percpu_ref_switch_to_atomic_rcu
>   percpu_ref_call_confirm_rcu(rcu);
>     data->confirm_switch(ref);
>     data->confirm_switch = NULL;
>     wake_up_all(&percpu_ref_switch_waitq);
> 

-- 
Pavel Begunkov
