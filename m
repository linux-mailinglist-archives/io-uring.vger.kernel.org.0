Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5024A2F91D5
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 12:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbhAQLBt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 06:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbhAQLBq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 06:01:46 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352ABC061573;
        Sun, 17 Jan 2021 03:01:06 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o10so4396188wmc.1;
        Sun, 17 Jan 2021 03:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+qV6WTqvT+X27CsN21ibUaMIx6p+0rYHTTZ1ARturp8=;
        b=tHX4zvX/EFruFiEZ5iNwl/fdp0wajVgV/NpMScA0Nixyw6esYvGPZ6nhCOmAYWc4Mf
         62SEJ3/H+rDaysbqjBhqCfVDUniU5TpUpD+5H33OVj55xrkOPSesfC8Kg7wM10XhA2tz
         W2Ezbvz8BIIDw+8UGAfTcyBtmOS7RsjstlqLgr4lxSpcXuD8JuWAUc2ELqJFyKftUZKp
         WyesSp7Qdq1mdeLJDFCAv9JaLaoQyRZUwjWKMOVdMS5RhswReaFkWMlhNv+vu/nnkfVl
         pSzats2eh5s8P7QQErt3OeECdC7ONu7K/qRS+c8j2TMXOh1j3ZatIPqP9jpi2RvhKO4a
         vL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+qV6WTqvT+X27CsN21ibUaMIx6p+0rYHTTZ1ARturp8=;
        b=ObFXFEbJ/SejbteNv5VEoykRYqzesMVVk6Xm55tnYLW6ZeGJ45C8lOyZVhEEx5mWpq
         PJp0ADEUNFKzkOlglU1enmJZK94yDkfZrto3r//QGU9HU/+dCzOD7ImkFJdv1eu3yTaS
         U96Lds+xujnWbYeuAR0EuWU3X/fPeEJ1c978ULxUsy/yNiZL5UZCkK4uS4Ymfb12ooNJ
         phs79fi35UlqAYDRQUyGViR2wV1VQkt+JkZMZZ0co/9SWn5NHLiXrhQ1Jg6EcM6uhXbP
         plYRWFdwE/82sM39DelQ53/1Y6h6Kasyb9WTCh4hZBvJivT3ytMU9v50WUk0nkSqyOSf
         Xq1A==
X-Gm-Message-State: AOAM531S7AJ/GIy/9s2DEDZbqMKGcowXBqlHZagOJBODD+kPXyGJTYIe
        60LDzxbC6jedRD27ujIS2eQ=
X-Google-Smtp-Source: ABdhPJyzQhjPq1931IRYTHf8kf41WR8Ob0uYsWvVN5je03+Uuk82jDOxpjO3JSar8KlXu0rua9jFVA==
X-Received: by 2002:a1c:b3c3:: with SMTP id c186mr16703923wmf.169.1610881264872;
        Sun, 17 Jan 2021 03:01:04 -0800 (PST)
Received: from [192.168.8.130] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id z8sm5148573wmi.44.2021.01.17.03.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 03:01:04 -0800 (PST)
Subject: Re: WARNING in io_wq_submit_work
To:     syzbot <syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000dcecd505b9145f53@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <cb72af4c-57a8-dfdc-5637-bece38ee8099@gmail.com>
Date:   Sun, 17 Jan 2021 10:57:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000dcecd505b9145f53@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/01/2021 08:27, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0da0a8a0 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12f2309f500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ee2266946ed36986
> dashboard link: https://syzkaller.appspot.com/bug?extid=f655445043a26a7cfab8
> compiler:       clang version 11.0.1
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com

#syz fix: io_uring: cancel all requests on task exit

the patch makes io_uring_cancel_files() effectively unreachable.

> 
> ------------[ cut here ]------------
> do not call blocking ops when !TASK_RUNNING; state=2 set at [<00000000ced9dbfc>] prepare_to_wait+0x1f4/0x3b0 kernel/sched/wait.c:262
> WARNING: CPU: 1 PID: 19888 at kernel/sched/core.c:7853 __might_sleep+0xed/0x100 kernel/sched/core.c:7848
> Modules linked in:
> CPU: 0 PID: 19888 Comm: syz-executor.3 Not tainted 5.11.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__might_sleep+0xed/0x100 kernel/sched/core.c:7848
> Code: fc ff df 41 80 3c 06 00 74 08 48 89 ef e8 cb 2e 6c 00 48 8b 4d 00 48 c7 c7 c0 d4 0d 8a 48 89 de 48 89 ca 31 c0 e8 23 5e f3 ff <0f> 0b eb 8e 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
> RSP: 0018:ffffc900089df3c0 EFLAGS: 00010246
> RAX: 24183d53a1679b00 RBX: 0000000000000002 RCX: ffff888013853780
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffff888013854d98 R08: ffffffff8163c792 R09: ffffed10173a60b8
> R10: ffffed10173a60b8 R11: 0000000000000000 R12: ffffffff8a0e5f60
> R13: ffff888013853798 R14: 1ffff1100270a9b3 R15: 00000000000003a7
> FS:  00007fe439981700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000016b538d CR3: 0000000026e00000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  __mutex_lock_common+0xc4/0x2ef0 kernel/locking/mutex.c:935
>  __mutex_lock kernel/locking/mutex.c:1103 [inline]
>  mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
>  io_wq_submit_work+0x39a/0x720 fs/io_uring.c:6411
>  io_run_cancel fs/io-wq.c:856 [inline]
>  io_wqe_cancel_pending_work fs/io-wq.c:990 [inline]
>  io_wq_cancel_cb+0x614/0xcb0 fs/io-wq.c:1027
>  io_uring_cancel_files fs/io_uring.c:8874 [inline]
>  io_uring_cancel_task_requests fs/io_uring.c:8952 [inline]
>  __io_uring_files_cancel+0x115d/0x19e0 fs/io_uring.c:9038
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2e6/0x2490 kernel/exit.c:780
>  do_group_exit+0x168/0x2d0 kernel/exit.c:922
>  get_signal+0x16b5/0x2030 kernel/signal.c:2770
>  arch_do_signal_or_restart+0x8e/0x6a0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x48/0x190 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e219
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fe439980cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 000000000119bf88 RCX: 000000000045e219
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000119bf88
> RBP: 000000000119bf80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
> R13: 00007ffe7c5112ff R14: 00007fe4399819c0 R15: 000000000119bf8c
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
