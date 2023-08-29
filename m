Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCDB78C540
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 15:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjH2N1k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 09:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbjH2N1U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 09:27:20 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CC7CD9;
        Tue, 29 Aug 2023 06:26:39 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-76f1cc8022bso58271985a.3;
        Tue, 29 Aug 2023 06:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693315596; x=1693920396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UIne9+LRxxExtchFtuongjj44iId0sdiP6rA/57q3iM=;
        b=qvGVlNINAzKTUbBzd7qqy3U+9eHTSoI7qbK75sOWMudhknrnr8ycvV0fPOCPI31g+4
         bpIsbBAQT2+cZWSv+P8Q1NL/blvk8+M+OhqshzvZys98fYtLT1pLGuGGfNdvqJhB93MJ
         Dbzl/GhOdBLNemzq7fr6cyq/v3R9te0GKPObf2Yu25xRbuOGZU2MOWnH1TpxdTtT5qtU
         haqiRsR2USk58x3qOo+pXiAJOU2YTsvEsNXkTt6rEytgKG6rli6idG20nPihKAbeHl+Y
         wypwdAyKaoX0bX67J9eSCgujyH8WGBmOoHpL2kBKqVECxUod6ndmVpI4kuQiSkVU7TBI
         Easg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693315596; x=1693920396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UIne9+LRxxExtchFtuongjj44iId0sdiP6rA/57q3iM=;
        b=X6UD8i2JHJ+PpxPnL8OZBUMgDQVgXU74mCI7CcgMuF/8ms766ybZ1IDvPr75B0gQSV
         JV2J1meDFX60QXKfPdE0dJB6eA8CYsOhTFldiLmsh/UFoBnwnQ2d80qT6oBJdZnl2W8m
         Bcma8/wvLc4rPd1s56wrJe7GaTxUs0Pge3z0XRcdlbCNvtJLo96l+kl7Dp9p5JtK75T2
         7ZD2eKTIB+yfiry5JLxDiAM/YCCX+YzgTZV0wX0ufammgGqUN6foEHwnNW0cZFkaD8lE
         4d6plB5cbolOqivHcrhatJKh+xmk/3Iu5oyERtChrt6VW6aQv0WwiLso/DSGf8DNmYRq
         GhnQ==
X-Gm-Message-State: AOJu0Yy9hXzZvKOSyGAvtNqqtrb/ZkNCnIfjKRTgoiP5R7sWsRNhXPeZ
        b/wNlHdmJa/CocNuxu+lRcNHs8WxH23R6w==
X-Google-Smtp-Source: AGHT+IH5isqlQJCqbSNgLy1hKZ52oOwzFR/j1Kb1PxBMnikXP+G8vm7zr7ND5Eul4ZPTxW/8ZqnwTg==
X-Received: by 2002:a0c:dd81:0:b0:646:35d4:b6b8 with SMTP id v1-20020a0cdd81000000b0064635d4b6b8mr26684840qvk.27.1693315595919;
        Tue, 29 Aug 2023 06:26:35 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:290::8ef? ([2620:10d:c091:600::2:15bf])
        by smtp.gmail.com with ESMTPSA id qf17-20020a0562144b9100b0063d4c39b3dbsm1728465qvb.112.2023.08.29.06.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 06:26:35 -0700 (PDT)
Message-ID: <bf7cff91-b8ae-cc65-2660-e5d08f4dee54@gmail.com>
Date:   Tue, 29 Aug 2023 14:21:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Don't set affinity on a dying sqpoll thread
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        syzbot <syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000753fbd0603f8c10b@google.com> <87v8cybuo6.fsf@suse.de>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87v8cybuo6.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

...
> Jens,
> 
> I'm not sure I got the whole story on this one, but it seems fairly
> trivial to reproduce and I can't see another way it could be
> triggered. What do you think?

Right, it can be null and that should be checked. I haven't taken
a look at the report but the patch looks good regardless, thanks


> -- >8 --
> Subject: [PATCH] io_uring: Don't set affinity on a dying sqpoll thread
> 
> Syzbot reported a null-ptr-deref of sqd->thread inside
> io_sqpoll_wq_cpu_affinity.  It turns out the sqd->thread can go away
> from under us during io_uring_register, in case the process gets a
> fatal signal during io_uring_register.
> 
> It is not particularly hard to hit the race, and while I am not sure
> this is the exact case hit by syzbot, it solves it.  Finally, checking
> ->thread is enough to close the race because we locked sqd while
> "parking" the thread, thus preventing it from going away.
> 
> I reproduced it fairly consistently with a program that does:
> 
> int main(void) {
>    ...
>    io_uring_queue_init(RING_LEN, &ring1, IORING_SETUP_SQPOLL);
>    while (1) {
>      io_uring_register_iowq_aff(ring, 1, &mask);
>    }
> }
> 
> Executed in a loop with timeout to trigger SIGTERM:
>    while true; do timeout 1 /a.out ; done
> 
> This will hit the following BUG() in very few attempts.
> 
> BUG: kernel NULL pointer dereference, address: 00000000000007a8
> PGD 800000010e949067 P4D 800000010e949067 PUD 10e46e067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 0 PID: 15715 Comm: dead-sqpoll Not tainted 6.5.0-rc7-next-20230825-g193296236fa0-dirty #23
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> RIP: 0010:io_sqpoll_wq_cpu_affinity+0x27/0x70
> Code: 90 90 90 0f 1f 44 00 00 55 53 48 8b 9f 98 03 00 00 48 85 db 74 4f
> 48 89 df 48 89 f5 e8 e2 f8 ff ff 48 8b 43 38 48 85 c0 74 22 <48> 8b b8
> a8 07 00 00 48 89 ee e8 ba b1 00 00 48 89 df 89 c5 e8 70
> RSP: 0018:ffffb04040ea7e70 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff93c010749e40 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffffa7653331 RDI: 00000000ffffffff
> RBP: ffffb04040ea7eb8 R08: 0000000000000000 R09: c0000000ffffdfff
> R10: ffff93c01141b600 R11: ffffb04040ea7d18 R12: ffff93c00ea74840
> R13: 0000000000000011 R14: 0000000000000000 R15: ffff93c00ea74800
> FS:  00007fb7c276ab80(0000) GS:ffff93c36f200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000007a8 CR3: 0000000111634003 CR4: 0000000000370ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   ? __die_body+0x1a/0x60
>   ? page_fault_oops+0x154/0x440
>   ? do_user_addr_fault+0x174/0x7b0
>   ? exc_page_fault+0x63/0x140
>   ? asm_exc_page_fault+0x22/0x30
>   ? io_sqpoll_wq_cpu_affinity+0x27/0x70
>   __io_register_iowq_aff+0x2b/0x60
>   __io_uring_register+0x614/0xa70
>   __x64_sys_io_uring_register+0xaa/0x1a0
>   do_syscall_64+0x3a/0x90
>   entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> RIP: 0033:0x7fb7c226fec9
> Code: 2e 00 b8 ca 00 00 00 0f 05 eb a5 66 0f 1f 44 00 00 48 89 f8 48 89
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
> f0 ff ff 73 01 c3 48 8b 0d 97 7f 2d 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffe2c0674f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb7c226fec9
> RDX: 00007ffe2c067530 RSI: 0000000000000011 RDI: 0000000000000003
> RBP: 00007ffe2c0675d0 R08: 00007ffe2c067550 R09: 00007ffe2c067550
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffe2c067750 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
> Modules linked in:
> CR2: 00000000000007a8
> ---[ end trace 0000000000000000 ]---
> 
> Reported-by: syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com
> Fixes: ebdfefc09c6d ("io_uring/sqpoll: fix io-wq affinity when IORING_SETUP_SQPOLL is used")
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>   io_uring/sqpoll.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index ee2d2c687fda..bd6c2c7959a5 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -430,7 +430,9 @@ __cold int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx,
>   
>   	if (sqd) {
>   		io_sq_thread_park(sqd);
> -		ret = io_wq_cpu_affinity(sqd->thread->io_uring, mask);
> +		/* Don't set affinity for a dying thread */
> +		if (sqd->thread)
> +			ret = io_wq_cpu_affinity(sqd->thread->io_uring, mask);
>   		io_sq_thread_unpark(sqd);
>   	}
>   

-- 
Pavel Begunkov
