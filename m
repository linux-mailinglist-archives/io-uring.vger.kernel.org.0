Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9960C307C9C
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhA1Rdq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbhA1R0X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:26:23 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DB4C061793
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 09:25:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g15so4729052pjd.2
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 09:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5yVwM4UHL0nLSJMEu4SR8QYX3bM5QYXnhGMceAQjA6U=;
        b=uZS+4qQAtMzCLRNFXkB4Y07EZcr5oJ3ZhhYS7dcVJzZG4PUEEvOr7HO+4VeObyABDa
         SIo8usrHRJS+oiRB2N1I4Cfd5eRKwcYMDG0nJR2jzbRMSrvLCLucI0T3bGjbM5D9nxtH
         /V2swBq5IFsFwQScP+3fgFkidqE92r5DpIcZZeNsyT7nm7ufu7DUemWeetEWSc5S45aV
         10juggFzX/uRCiEoHNEIMlZqrsdWmf2lpDIXlqJRv0c4LJCkvt7O6QURlUhQPy04cAp8
         FhIENlLUoe6EPPnAcmLdIIwx/dNVU8q2t2SpLA+sWnHqjZsrdsxwobwbNQXw03+eIjZZ
         FF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5yVwM4UHL0nLSJMEu4SR8QYX3bM5QYXnhGMceAQjA6U=;
        b=Kn9KlPs6VSmESsKSJdilzuqVLCAmjISrtXof/IEG8vQhkUjP0E32N1l3msCVy2DVPp
         yVLeoe5b3mAgGU1lIT5C3oRFBYMooZ+jJhGv38YysVceDCH69kv5+fUCa0RLG+bxazJH
         IEoIrRkWCnqVWqglvMkyysXOgd+sFKQASVP+4yZP1rgZieE+yVZqk0kvm+uv+sx/cYNQ
         +RmfXYPVcxw28wyTjNBFLm2JvGiqG6Wzn42VzsN6QocekZH1rfAzFHdvjaZLRR/tG0+3
         kn4ua3NxotkYkIID3e6w0w6e38+ic41A5mOKowOpfjcHDvAqn0j5dzGVtzTxEvMrDj3C
         /XIg==
X-Gm-Message-State: AOAM530+DOb/oTEZIMofeGrETrgoeJeD7Pl+GQYVXO/hkcRTdwwDf0xc
        5FtMD/yFnz1W3rB9bM7UcB07rw==
X-Google-Smtp-Source: ABdhPJyCkrcPDvEyZjpYU7mZ6x+GvZJaOPMDuA4z7M/0GhU0CEAhIcu2N5Or42HVk5YqHxXymjDi6g==
X-Received: by 2002:a17:902:6543:b029:e1:1758:649f with SMTP id d3-20020a1709026543b02900e11758649fmr580270pln.38.1611854741667;
        Thu, 28 Jan 2021 09:25:41 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id z29sm6300607pfk.67.2021.01.28.09.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:25:41 -0800 (PST)
Subject: Re: BUG: corrupted list in io_file_get
To:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot <syzbot+6879187cf57845801267@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000ab74fb05b9f8cb0a@google.com>
 <944c4b9b-9c83-3167-fd43-d5118fdc2e0e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7dfb62b3-0821-5203-b34f-4400e0b1152d@kernel.dk>
Date:   Thu, 28 Jan 2021 10:25:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <944c4b9b-9c83-3167-fd43-d5118fdc2e0e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/21 10:12 AM, Pavel Begunkov wrote:
> On 28/01/2021 16:58, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    76c057c8 Merge branch 'parisc-5.11-2' of git://git.kernel...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=11959454d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=96b123631a6700e9
>> dashboard link: https://syzkaller.appspot.com/bug?extid=6879187cf57845801267
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a3872cd00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ab17a4d00000
>>
>> The issue was bisected to:
>>
>> commit 02a13674fa0e8dd326de8b9f4514b41b03d99003
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Sat Jan 23 22:49:31 2021 +0000
>>
>>     io_uring: account io_uring internal files as REQ_F_INFLIGHT
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14d1bf44d00000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16d1bf44d00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12d1bf44d00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+6879187cf57845801267@syzkaller.appspotmail.com
>> Fixes: 02a13674fa0e ("io_uring: account io_uring internal files as REQ_F_INFLIGHT")
>>
>> list_add double add: new=ffff888017eaa080, prev=ffff88801a9cb520, next=ffff888017eaa080.
>> ------------[ cut here ]------------
>> kernel BUG at lib/list_debug.c:29!
>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 0 PID: 8481 Comm: syz-executor556 Not tainted 5.11.0-rc5-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
>> Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 89 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
>> RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
>> RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
>> RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
>> RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
>> R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
>> R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
>> FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0
>> Call Trace:
>>  __list_add include/linux/list.h:67 [inline]
>>  list_add include/linux/list.h:86 [inline]
>>  io_file_get+0x8cc/0xdb0 fs/io_uring.c:6466
>>  __io_splice_prep+0x1bc/0x530 fs/io_uring.c:3866
>>  io_splice_prep fs/io_uring.c:3920 [inline]
>>  io_req_prep+0x3546/0x4e80 fs/io_uring.c:6081
>>  io_queue_sqe+0x609/0x10d0 fs/io_uring.c:6628
>>  io_submit_sqe fs/io_uring.c:6705 [inline]
>>  io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6953
>>  __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9353
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x440569
>> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007ffe38c5c5a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>> RAX: ffffffffffffffda RBX: 0000000000401e00 RCX: 0000000000440569
>> RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000004
>> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000401d70
>> R13: 0000000000401e00 R14: 0000000000000000 R15: 0000000000000000
>> Modules linked in:
>> ---[ end trace 3c68392a0f24e7a0 ]---
>> RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
>> Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 89 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
>> RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
>> RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
>> RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
>> RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
>> R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
>> R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
>> FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0
> 
> This one is simple
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ae388cc52843..39ae1f821cef 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6460,7 +6460,8 @@ static struct file *io_file_get(struct io_submit_state *state,
>  		file = __io_file_get(state, fd);
>  	}
>  
> -	if (file && file->f_op == &io_uring_fops) {
> +	if (file && file->f_op == &io_uring_fops &&
> +	    !(req->flags & REQ_F_INFLIGHT)) {
>  		io_req_init_async(req);
>  		req->flags |= REQ_F_INFLIGHT;

Curious, how is it marked in-flight already? Ah it's splice... Pavel,
can you send the fix for this one?

-- 
Jens Axboe

