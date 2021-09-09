Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA0C404237
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348106AbhIIAUn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241998AbhIIAUk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:20:40 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A025C061575;
        Wed,  8 Sep 2021 17:19:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i28so5821711wrb.2;
        Wed, 08 Sep 2021 17:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XcKHjEYpeBmn/GpYA6v3ROuFWFvVZsiyemg5sDvtveA=;
        b=XWJqvD8y38UjjldIYS0rVmpLK91ShJSXakxLXJO/WIGimblTch/MDHHimwL4SQUtkx
         aiopYYKczcNqEUZIzEj/nJgXKgSjjbUm7wr/WNjX8FXxWNjSDzpf2HQlv/ll9pGzREJW
         XQ59BhT90Nklj4tjp87fkDQnteigAfomJPst6AZbL1JOfICiw1enLrOSg9A2U3XeNc6a
         iW9qyKnTeI1ZUjE1btPwO9CMVREc5groCRRQl1qPjWw71M1ZuLu4jOfMGyRe4gfkzVcX
         7Y/eyLuGOEpLE8Idqk2hASDDbuUo7VjGS0aLYUzQgrVWT8d22RDWkLAmClxzOxria4+X
         D//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XcKHjEYpeBmn/GpYA6v3ROuFWFvVZsiyemg5sDvtveA=;
        b=K5ayUJCt4OYGJcl98X6cpy2i5+LoQX/9WY4kw6BBHaG/z9SXbomln2qYfya9Q2KM0t
         VwnaDvZ/Fhf4UW/pwLH0NP43wcg98YM1w0cMgxvZ5RDIrseGZUkLRheon5iVYzzGzOyn
         gNrxbhQxYq38D/dTmqu2eEFV9lF7o4HtLRQykgkMastC4gmq7ABXiq9wmLo+zapzQWpn
         C2SEJqzZ1DDmV9/gvkk+eJ1CLTK/u/8veOoZtFeEHT8zOdNwUwIfx8WNx5nNA/JhI6Ds
         0EEXmKd5N0q/gIaBIX25zqIRbsXJVkNPDojMbVAfx0rI6R9BOwF+8bFyYZvVnAptue8+
         6oWw==
X-Gm-Message-State: AOAM5322dUap0Gk6U/BUpbF7eKiNR4crIWlRRXp00TEnvUCASvSV2uGo
        VfmTSdPJXYOVnepo0ud02po=
X-Google-Smtp-Source: ABdhPJyvXliUUQSlkMcJ3OmOLJI5r8IXOZS6TSnIRDP0goUFio8HYq/tdSHc5cdB+hFqCiw5aYHxTQ==
X-Received: by 2002:a5d:6781:: with SMTP id v1mr269783wru.249.1631146770795;
        Wed, 08 Sep 2021 17:19:30 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.235.167])
        by smtp.gmail.com with ESMTPSA id d129sm82367wmd.23.2021.09.08.17.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 17:19:30 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_wq_submit_work (2)
To:     syzbot <syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000004bda3905cb84cfc0@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3ba69d23-26d0-9c94-bf9d-a0db2bef2ed4@gmail.com>
Date:   Thu, 9 Sep 2021 01:18:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0000000000004bda3905cb84cfc0@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/21 1:09 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4b93c544e90e thunderbolt: test: split up test cases in tb_..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10b7836d300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ac2f9cc43f6b17e4
> dashboard link: https://syzkaller.appspot.com/bug?extid=bc2d90f602545761f287
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e8ce0b300000
> 
> The issue was bisected to:
> 
> commit 3146cba99aa284b1d4a10fbd923df953f1d18035
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Sep 1 17:20:10 2021 +0000
> 
>     io-wq: make worker creation resilient against signals

fixed today

#syz test: git://git.kernel.dk/linux-block io_uring-5.15

> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11098e0d300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13098e0d300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15098e0d300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com
> Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8804 at fs/io_uring.c:1164 req_ref_get fs/io_uring.c:1164 [inline]
> WARNING: CPU: 1 PID: 8804 at fs/io_uring.c:1164 io_wq_submit_work+0x272/0x300 fs/io_uring.c:6731
> Modules linked in:
> CPU: 1 PID: 8804 Comm: syz-executor.0 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:req_ref_get fs/io_uring.c:1164 [inline]
> RIP: 0010:io_wq_submit_work+0x272/0x300 fs/io_uring.c:6731
> Code: e8 d3 21 91 ff 83 fb 7f 76 1b e8 89 1a 91 ff be 04 00 00 00 4c 89 ef e8 bc 62 d8 ff f0 ff 45 a4 e9 41 fe ff ff e8 6e 1a 91 ff <0f> 0b eb dc e8 65 1a 91 ff 4c 89 e7 e8 ad dc fb ff 48 85 c0 49 89
> RSP: 0018:ffffc900027b7ae8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000000000000007f RCX: 0000000000000000
> RDX: ffff8880209cb900 RSI: ffffffff81e506d2 RDI: 0000000000000003
> RBP: ffff888071824978 R08: 000000000000007f R09: ffff88807182491f
> R10: ffffffff81e506ad R11: 0000000000000000 R12: ffff8880718248c0
> R13: ffff88807182491c R14: ffff888071824918 R15: 0000000000100000
> FS:  0000000002b68400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055f33208ca50 CR3: 0000000071827000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_run_cancel fs/io-wq.c:809 [inline]
>  io_acct_cancel_pending_work.isra.0+0x2a9/0x5e0 fs/io-wq.c:950
>  io_wqe_cancel_pending_work+0x98/0x130 fs/io-wq.c:968
>  io_wq_destroy fs/io-wq.c:1185 [inline]
>  io_wq_put_and_exit+0x7d1/0xc70 fs/io-wq.c:1198
>  io_uring_clean_tctx fs/io_uring.c:9607 [inline]
>  io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9687
>  io_uring_files_cancel include/linux/io_uring.h:16 [inline]
>  do_exit+0x265/0x2a30 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4665f9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdd0a294a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000000001e RCX: 00000000004665f9
> RDX: 000000000041940b RSI: ffffffffffffffbc RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000001b2be20070 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdd0a295a0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

-- 
Pavel Begunkov
