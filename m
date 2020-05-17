Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2221D688E
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgEQPTY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgEQPTY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 11:19:24 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A68C061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 08:19:24 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so3639738pfb.10
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 08:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aChvVOXDtTrzTicsuCDZeQtZsdk7OrVDpZeM6DuP/0k=;
        b=dV/38bE3ktMX4c6AP99OCbIYvIdaoGe+Q8L0QizruL1lP4k97pJxioEj3NjUxMAJuS
         wN8iWiaIdNgY/pXsQJDYHF3HQema41wnMmEhKcS34VMwJeyUU6rdbY14a/1xJqkQYp6m
         86vdS4Wn4kKgD9bQi/ya6LiR5+TTzPRUu1UPZV8sBPB/FIVMr3MKaQT5bd8M1GQU2yUW
         wjxw1geSCgKs9fgICkJ/fDgz0XnDese2Sg+lk9fX5yy0+7OpmcwuDbx39HZYVnIKpg1n
         iZn/exEjU+SkPpJBo7jO1wWouBoSGwCMWUeFiq8fnhaZGX2XKWASyizIRLxoYsICOZ4p
         0vXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aChvVOXDtTrzTicsuCDZeQtZsdk7OrVDpZeM6DuP/0k=;
        b=ouxHnbR5Scz7scaG5BzwgSzgPGJ9TcgqV+ypGUJZiesJ7/jLjv27QRhcFi2ZwwbqyY
         LFKgBwOHBGCYlY5lLGv4SKeWxnpGVodQeKpVME4x+bT7g2QPMTilrfSbr4Giek10bDIn
         IGxhT4tOJ3ako7kWOiSMzigqqZ8jX+x+OdAy5A/St56tLVavogsKZqQMu0O5v3FIx61A
         dgFQWbwRg7P/53K3/Vl5TgAlU8nNSgdfVkNMN0GXJQYBWMjDttZQ4QuozSQvR9ttQbuU
         ZA8xN5N9fQAbbJa3cvZFP2wHVZzuDbtXbZbSdITMWSEgCQ59WXckFbzIg0bLjNUsI+q/
         a8TA==
X-Gm-Message-State: AOAM530Ugvf6Gqst0oBxxb5q+1E80p/GWkhKRtxs11aEEl0RXfRdBbev
        p8MuL1LMdAE7jyEpYGwxf0cm6w==
X-Google-Smtp-Source: ABdhPJy8Mtw1m+G8hWbkB0eZ9ksLVsC9OmKVlZ62NwhpsOoOXfy0qP+lvGJudNZ2+3NLvGni5QpLHw==
X-Received: by 2002:a63:4555:: with SMTP id u21mr5301124pgk.127.1589728763622;
        Sun, 17 May 2020 08:19:23 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id h9sm6458481pfo.129.2020.05.17.08.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 08:19:23 -0700 (PDT)
Subject: Re: INFO: trying to register non-static key in io_cqring_ev_posted
 (3)
To:     syzbot <syzbot+8c91f5d054e998721c57@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000009cb15805a5d080d6@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <923510f4-fd6f-dee2-dd40-d3bee55d4449@kernel.dk>
Date:   Sun, 17 May 2020 09:19:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0000000000009cb15805a5d080d6@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/20 10:30 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    ac935d22 Add linux-next specific files for 20200415
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12deaa5e100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
> dashboard link: https://syzkaller.appspot.com/bug?extid=8c91f5d054e998721c57
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d54c02100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17461e06100000
> 
> The bug was bisected to:
> 
> commit b41e98524e424d104aa7851d54fd65820759875a
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Feb 17 16:52:41 2020 +0000
> 
>     io_uring: add per-task callback handler
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1488dc3c100000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1688dc3c100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1288dc3c100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+8c91f5d054e998721c57@syzkaller.appspotmail.com
> Fixes: b41e98524e42 ("io_uring: add per-task callback handler")
> 
> RSP: 002b:00007fffb1fb9aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441319
> RDX: 0000000000000001 RSI: 0000000020000140 RDI: 000000000000047b
> RBP: 0000000000010475 R08: 0000000000000001 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402260
> R13: 00000000004022f0 R14: 0000000000000000 R15: 0000000000000000
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 1 PID: 7090 Comm: syz-executor222 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  assign_lock_key kernel/locking/lockdep.c:913 [inline]
>  register_lock_class+0x1664/0x1760 kernel/locking/lockdep.c:1225
>  __lock_acquire+0x104/0x4c50 kernel/locking/lockdep.c:4234
>  lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
>  __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122
>  io_cqring_ev_posted+0xa5/0x1e0 fs/io_uring.c:1160
>  io_poll_remove_all fs/io_uring.c:4357 [inline]
>  io_ring_ctx_wait_and_kill+0x2bc/0x5a0 fs/io_uring.c:7305
>  io_uring_create fs/io_uring.c:7843 [inline]
>  io_uring_setup+0x115e/0x22b0 fs/io_uring.c:7870
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3

I think this will likely fix it.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70ae7e840c85..79c90eb28c0d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -924,6 +924,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	init_waitqueue_head(&ctx->sqo_wait);
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->completions[0]);
@@ -6837,7 +6838,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 {
 	int ret;
 
-	init_waitqueue_head(&ctx->sqo_wait);
 	mmgrab(current->mm);
 	ctx->sqo_mm = current->mm;
 

-- 
Jens Axboe

