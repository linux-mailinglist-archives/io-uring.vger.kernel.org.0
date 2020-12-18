Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA682DE785
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 17:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgLRQjA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 11:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgLRQi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 11:38:59 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B11C0617A7;
        Fri, 18 Dec 2020 08:38:19 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id y17so2848933wrr.10;
        Fri, 18 Dec 2020 08:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+mxEeQ4ugiPE3qbCNzFG8CmaFjQ1yGKvJPL//gzbaEY=;
        b=iOwRLnUo2uzbnAKoueNszQgD8WFG3tIPcovwsSnN3YJmVRu3HZCj4XDchLrE1LHqN9
         /ph/ZxWSknc94pvTJvCstgdM72CvhoHN/bZzJdKIzuiGGZ630Cn5yTxb3fFXeOoPqNPS
         Em+dFAQda2ynwz6fssnQtkh+V/6YmBbOvHMtR5lqWZCCx3Meoj5+0ZAJRGyjMTJAKUsW
         Vnw/14d8Fm99e8Rzpb2xtaidSgGozfquo8ZzaqQw5EbdHeezASuF1N/avIPxIyZwI9aJ
         Ay17SbuaS5+c2nrg4CZp9Pxyyatc3/CH/3wIDF6oJ052DpotNzhB7XOBswr+KbLDwH3l
         Us6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+mxEeQ4ugiPE3qbCNzFG8CmaFjQ1yGKvJPL//gzbaEY=;
        b=k4hWvFpv2t89o9kc5TObl6ApdcShrXibKRIz20IjAz6/ujOa3Ztcq+rNEceILmlgtw
         Ke8lM08hFIoF71Ad4Ea2ySQr+O6r/xuQ6Qx2f3mB68jVA9DKgPPKWTAkjjSU67Vs32lr
         RGIOgpLnom8DZYFvwL4Y+Vp4tCs3hWO+koHYZqxIF9adp7JfkwMP0ItjfDtQLkaibEG+
         WofyXcn79SBIM52LpvZuql6FJzCqkr+6OxR/9YpVKf1nqdZL2BMa9bky8DChhN1QNYkZ
         ML/j4ftudBNEqDAZNCzUdtlcWwErE5eJdQb18AdCF7kpkl1SLwOLB12kGiuPvwm2wvyr
         KeOQ==
X-Gm-Message-State: AOAM532zr4bW4aL8bxrxx4iInRpRPPV+RLku1l4QDw9UWJwUFO4k6/V6
        ruddxfmzHcLTpbDXA33JBdQ=
X-Google-Smtp-Source: ABdhPJylUwzAQOwf3S9mzJMyq45QS8iUgbK2axZ8xReD0XwWQSVstiHdmgPgJ/BDEpbcCUlB04E09w==
X-Received: by 2002:a5d:4c4d:: with SMTP id n13mr5434503wrt.356.1608309497774;
        Fri, 18 Dec 2020 08:38:17 -0800 (PST)
Received: from [192.168.8.132] ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id k1sm14507350wrn.46.2020.12.18.08.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 08:38:17 -0800 (PST)
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000004d454d05b69b5bd3@google.com>
 <20201217031742.1072-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: WARNING in percpu_ref_kill_and_confirm (2)
Message-ID: <e8def1be-928f-5406-4f10-fbf41e6ef4f1@gmail.com>
Date:   Fri, 18 Dec 2020 16:34:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201217031742.1072-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/12/2020 03:17, Hillf Danton wrote:
> Wed, 16 Dec 2020 13:14:11 -0800
>> syzbot found the following issue on:
>>
>> HEAD commit:    7b1b868e Merge tag 'for-linus' of git://git.kernel.org/pub..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1156046b500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3416bb960d5c705d
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c9937dfb2303a5f18640
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1407c287500000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed5f07500000
>>
>> The issue was bisected to:
>>
>> commit 4d004099a668c41522242aa146a38cc4eb59cb1e
>> Author: Peter Zijlstra <peterz@infradead.org>
>> Date:   Fri Oct 2 09:04:21 2020 +0000
>>
>>     lockdep: Fix lockdep recursion
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e9d433500000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16e9d433500000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12e9d433500000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com
>> Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")
>>
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441309
>> RDX: 0000000000000002 RSI: 00000000200000c0 RDI: 0000000000003ad1
>> RBP: 000000000000f2ae R08: 0000000000000002 R09: 00000000004002c8
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
>> R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
>> ------------[ cut here ]------------
>> percpu_ref_kill_and_confirm called more than once on io_ring_ctx_ref_free!
>> WARNING: CPU: 0 PID: 8476 at lib/percpu-refcount.c:382 percpu_ref_kill_and_confirm+0x126/0x180 lib/percpu-refcount.c:382
>> Modules linked in:
>> CPU: 0 PID: 8476 Comm: syz-executor389 Not tainted 5.10.0-rc7-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:percpu_ref_kill_and_confirm+0x126/0x180 lib/percpu-refcount.c:382
>> Code: 5d 08 48 8d 7b 08 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 8b 53 08 48 c7 c6 00 4b 9d 89 48 c7 c7 60 4a 9d 89 e8 c6 97 f6 04 <0f> 0b 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02
>> RSP: 0018:ffffc9000b94fe10 EFLAGS: 00010086
>> RAX: 0000000000000000 RBX: ffff888011da4580 RCX: 0000000000000000
>> RDX: ffff88801fe84ec0 RSI: ffffffff8158c835 RDI: fffff52001729fb4
>> RBP: ffff88801539f000 R08: 0000000000000001 R09: ffff8880b9e2011b
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000293
>> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88802de28758
>> FS:  00000000014ab880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f2a7046b000 CR3: 0000000023368000 CR4: 0000000000350ef0
>> Call Trace:
>>  percpu_ref_kill include/linux/percpu-refcount.h:149 [inline]
>>  io_ring_ctx_wait_and_kill+0x2b/0x450 fs/io_uring.c:8382
>>  io_uring_release+0x3e/0x50 fs/io_uring.c:8420
>>  __fput+0x285/0x920 fs/file_table.c:281
>>  task_work_run+0xdd/0x190 kernel/task_work.c:151
>>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>>  exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
>>  exit_to_user_mode_prepare+0x17e/0x1a0 kernel/entry/common.c:191
>>  syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x441309
>> Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007ffed6545d38 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: fffffffffffffff4 RBX: 0000000000000000 RCX: 0000000000441309
>> RDX: 0000000000000002 RSI: 00000000200000c0 RDI: 0000000000003ad1
>> RBP: 000000000000f2ae R08: 0000000000000002 R09: 00000000004002c8
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
>> R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
> 
> Avoid double kill by checking ctx health.

Let's focus on _how_ it can happen. Refs may be killed by
__io_uring_register(), but this one holds a ref to the file, so
io_uring_release() -> io_ring_ctx_wait_and_kill() shouldn't even happen.
And when io_ring_ctx_wait_and_kill() is called fdget() for that ring
wouldn't be possible. That's if no other bugs are present.

We want to solve a problem rather than mask it. So, can it really
happen or a problem is somewhere else?

> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8379,7 +8379,13 @@ static void io_ring_exit_work(struct wor
>  static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  {
>  	mutex_lock(&ctx->uring_lock);
> -	percpu_ref_kill(&ctx->refs);
> +	/*
> +	 * try to avoid killing dead ctx, see the comments for dropping
> +	 * ring mutex in __io_uring_register()
> +	 */
> +	if (!percpu_ref_is_dying(&ctx->refs))
> +		percpu_ref_kill(&ctx->refs);
> +
>  	mutex_unlock(&ctx->uring_lock);
>  
>  	io_kill_timeouts(ctx, NULL);
> 

-- 
Pavel Begunkov
