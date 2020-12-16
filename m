Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3552DC87B
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 22:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgLPVrX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 16:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgLPVrX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 16:47:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71260C0617A7
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 13:46:43 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id t37so18565557pga.7
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 13:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=poAfl3bDtaKUASJKI462JFGUU+Oc+LFF2NNC85CJWOs=;
        b=cUrJuCCxp683ndejeLrG8EY4QEXqHn1D7H2UlO8fDFZ9zX1V+2NP+bpkE3eMHPK9Ua
         vsdNg8TcwoY9Xg2PAt/Agf1nBtcE79ImF54f7AZYGxhqTNiBRQagFkSe9xxNT9insXjW
         c0+neWxgAIJKsLdLzTgzQq2VZVa+YsNZRts4g3GW0Y7vPDalLqMTZwtfi7DHb3LUpEyd
         FTLzZ2w4cm+9TrIXQD49Ipw7IgUgEk3QTM7+E2D4OWV42MKOo5qJn/Oq6QIj4ZHeTy7l
         yYiHjS9synQe+vou1FAfz9iZtQYGaWS92JQvilf2i2NhqitKlvaT906gEE9TmOWn4cOF
         HAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=poAfl3bDtaKUASJKI462JFGUU+Oc+LFF2NNC85CJWOs=;
        b=J1WqFwcv72O3wOtbZ9QoLIPS0M6K+HVwGHB53P+Xu9YFEmKYS4fKkvc4TI8j6qZBMI
         q4eZu2AV09XlkjfTwEuy1IPA6n7es72ugmpgo5l4w4uSNn3vwUPNCMQp6lbDtsxpxmAZ
         1PXdReo6jVQ8Zr9hw4mttulGLs4d6Gm6kzpyPuaQbSbpL3iv83Ms716h1vsMyUl4pUmi
         yVXDFPwLZCt5/Bx3zJ1E4FG61m45sHwthcfEUIQEXITwxBiGGCi1156UV/0306X1pVOT
         5mQtiqXzHBbROrql+ajc+MEbBfefzCnQ3tvduw4nmUUvI5qj7s/rH6xo2UsZ8pnl+jkh
         geiA==
X-Gm-Message-State: AOAM5312Bdztb0px6K/MZBBomwFgnu7H8znz0WhTyvOX0i814uAi1OT4
        o66RJdX8avp6Vldr/Iyy4N2i/A==
X-Google-Smtp-Source: ABdhPJyk+DxUhJXC3y13LsRvsNxQHhpA2c6l0EwRpLeGeBGLCQIUF91JfFWlkZVg68d0q7IlikPW7A==
X-Received: by 2002:a62:1e81:0:b029:19e:2121:2df1 with SMTP id e123-20020a621e810000b029019e21212df1mr34214209pfe.1.1608155202845;
        Wed, 16 Dec 2020 13:46:42 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f24sm2969668pjj.5.2020.12.16.13.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 13:46:42 -0800 (PST)
Subject: Re: WARNING in percpu_ref_kill_and_confirm (2)
To:     syzbot <syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        will@kernel.org, Tejun Heo <tj@kernel.org>
References: <0000000000004d454d05b69b5bd3@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8694934b-7ac6-a29f-0126-4a311bea4c35@kernel.dk>
Date:   Wed, 16 Dec 2020 14:46:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000004d454d05b69b5bd3@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/20 2:14 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7b1b868e Merge tag 'for-linus' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1156046b500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3416bb960d5c705d
> dashboard link: https://syzkaller.appspot.com/bug?extid=c9937dfb2303a5f18640
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1407c287500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed5f07500000
> 
> The issue was bisected to:
> 
> commit 4d004099a668c41522242aa146a38cc4eb59cb1e
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Oct 2 09:04:21 2020 +0000
> 
>     lockdep: Fix lockdep recursion

Ehhh no... This is timing dependent, so probably why it ends up pinpointing
something totally unrelated.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e9d433500000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16e9d433500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12e9d433500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com
> Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")
> 
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441309
> RDX: 0000000000000002 RSI: 00000000200000c0 RDI: 0000000000003ad1
> RBP: 000000000000f2ae R08: 0000000000000002 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
> R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
> ------------[ cut here ]------------
> percpu_ref_kill_and_confirm called more than once on io_ring_ctx_ref_free!
> WARNING: CPU: 0 PID: 8476 at lib/percpu-refcount.c:382 percpu_ref_kill_and_confirm+0x126/0x180 lib/percpu-refcount.c:382
> Modules linked in:
> CPU: 0 PID: 8476 Comm: syz-executor389 Not tainted 5.10.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:percpu_ref_kill_and_confirm+0x126/0x180 lib/percpu-refcount.c:382
> Code: 5d 08 48 8d 7b 08 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 8b 53 08 48 c7 c6 00 4b 9d 89 48 c7 c7 60 4a 9d 89 e8 c6 97 f6 04 <0f> 0b 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02
> RSP: 0018:ffffc9000b94fe10 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: ffff888011da4580 RCX: 0000000000000000
> RDX: ffff88801fe84ec0 RSI: ffffffff8158c835 RDI: fffff52001729fb4
> RBP: ffff88801539f000 R08: 0000000000000001 R09: ffff8880b9e2011b
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000293
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88802de28758
> FS:  00000000014ab880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2a7046b000 CR3: 0000000023368000 CR4: 0000000000350ef0
> Call Trace:
>  percpu_ref_kill include/linux/percpu-refcount.h:149 [inline]
>  io_ring_ctx_wait_and_kill+0x2b/0x450 fs/io_uring.c:8382
>  io_uring_release+0x3e/0x50 fs/io_uring.c:8420
>  __fput+0x285/0x920 fs/file_table.c:281
>  task_work_run+0xdd/0x190 kernel/task_work.c:151
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
>  exit_to_user_mode_prepare+0x17e/0x1a0 kernel/entry/common.c:191
>  syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x441309
> Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffed6545d38 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: fffffffffffffff4 RBX: 0000000000000000 RCX: 0000000000441309
> RDX: 0000000000000002 RSI: 00000000200000c0 RDI: 0000000000003ad1
> RBP: 000000000000f2ae R08: 0000000000000002 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
> R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000

What I think happens here is that we switch mode, but exit before it's
done. Wonder if there's a wait to wait for that on exit. Tejun?

-- 
Jens Axboe

