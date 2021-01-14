Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E45B2F6CE3
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 22:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbhANVKJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 16:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbhANVKJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 16:10:09 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0DAC061757;
        Thu, 14 Jan 2021 13:09:29 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id w5so7217491wrm.11;
        Thu, 14 Jan 2021 13:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UkUxVV8Jp1GzPWzVwNrn6NYWM99VIRha2paln9gx7LE=;
        b=etOYhQqhcjx5Xyy/edCvDyC8s763zdYDI9r59nxByn5MD4WucVuwpgMDIKei+cntKD
         Y3FoG/isma6V0EQfbbuEWfZ/yfvwx2EXGgEXAE01dTv/lB9h5LG22bcQoZnFwHKzDeQN
         ignNzje5Vm/etT9CRkzkFpoQlaiUR8uE8vYp/60ioie7bTlUH6YJUeJul0CJGL1qkbZ1
         YHXEwvsSy0LcGraRR5bAK3qxKMkk/vdzJNnRpwEK2HtRnAbyk6afuqTZqKHwimJQ/qv5
         Uz+7xBQkOj+mwxY0Y62H+VolIrozg27fY69Cs4VugIt74+MJhE+nk8PNedp6EM+ZlFJp
         XX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UkUxVV8Jp1GzPWzVwNrn6NYWM99VIRha2paln9gx7LE=;
        b=lNcdGb6cuzy8cjz9yW2JWZliJAeZd0NHNYfP/iykKQUvCNiBGgql4l6KqHucJdplBZ
         VMaeePKBqaEuQr3LHDDrE3jzqsh/r2ieAN41qfR9RYD/BhPR+scARV8TuUN84LIMqW+g
         mWDjcey36LxL9Nepl7jtjSHGJnHF9QOS6S9Z4Kl25w5YxzewGJ6FGAhHvLNWYbPmt/l6
         lbIecY3ZvLHFZzux2jcsqWKyvnA6KbvQWYoIq+RAEU4b8jJpY50ckBbyms4gmhWJbyCh
         g4nLc+bDqZCtymhN6N9v5AhEl5hdR6umMlNpBaFx0RcPKNR/Gt5EI5vAVdzIo5hgmozV
         XbtA==
X-Gm-Message-State: AOAM532b/PzF8co9S34gYiZOGgr2VESmgJBQVXOpu8WcSIHRM6R8jODi
        pIoQRL2rAY9aYXEDyzMG7y1Y1uaEGTSKKg==
X-Google-Smtp-Source: ABdhPJw5eLIMdLTYTwv3nPBOsoXRX3TooVJLqV6BnnUjTkFvdgwGWT/irVW0o/cTaer+kgzorC8GEg==
X-Received: by 2002:adf:9e47:: with SMTP id v7mr9711622wre.185.1610658567760;
        Thu, 14 Jan 2021 13:09:27 -0800 (PST)
Received: from [192.168.8.122] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id r16sm11682369wrx.36.2021.01.14.13.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:09:27 -0800 (PST)
Subject: Re: general protection fault in io_uring_setup
To:     syzbot <syzbot+06b7d55a62acca161485@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000067b86b05b8d72ff6@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <f45bb2df-5ef0-bc36-8afb-2c03257cc2c1@gmail.com>
Date:   Thu, 14 Jan 2021 21:05:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000067b86b05b8d72ff6@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/01/2021 07:27, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    65f0d241 Merge tag 'sound-5.11-rc4' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16bbcd98d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ee2266946ed36986
> dashboard link: https://syzkaller.appspot.com/bug?extid=06b7d55a62acca161485
> compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ef17fb500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1045ef67500000
> 
> The issue was bisected to:
> 
> commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Jan 8 20:57:25 2021 +0000
> 
>     io_uring: stop SQPOLL submit on creator's death
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=148ba0cf500000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=168ba0cf500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=128ba0cf500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+06b7d55a62acca161485@syzkaller.appspotmail.com
> Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")

sure it's a duplicate

#syz test: git://git.kernel.dk/linux-block 06585c497b55045ec21aa8128e340f6a6587351c

> 
> Code: e8 cc ac 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffc6a96c958 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 0000000020000200 RCX: 0000000000441889
> RDX: 0000000020ffd000 RSI: 0000000020000200 RDI: 0000000000003040
> RBP: 000000000000d8dd R08: 0000000000000001 R09: 0000000020ffd000
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000020ffd000
> R13: 0000000020ffb000 R14: 0000000000000000 R15: 0000000000000000
> general protection fault, probably for non-canonical address 0xdffffc0000000022: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000110-0x0000000000000117]
> CPU: 0 PID: 8444 Comm: syz-executor770 Not tainted 5.11.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
> RIP: 0010:io_disable_sqo_submit fs/io_uring.c:8891 [inline]
> RIP: 0010:io_uring_create fs/io_uring.c:9711 [inline]
> RIP: 0010:io_uring_setup fs/io_uring.c:9739 [inline]
> RIP: 0010:__do_sys_io_uring_setup fs/io_uring.c:9745 [inline]
> RIP: 0010:__se_sys_io_uring_setup+0x2abb/0x37b0 fs/io_uring.c:9742
> Code: c0 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 c5 31 de ff 41 be 14 01 00 00 4c 03 33 4c 89 f0 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 46 06 00 00 41 80 0e 01 48 8b 7c 24 30 e8
> RSP: 0018:ffffc90000edfca0 EFLAGS: 00010007
> RAX: 0000000000000022 RBX: ffff888021fe50c0 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffffc90000edfb80
> RBP: ffffc90000edff38 R08: dffffc0000000000 R09: 0000000000000003
> R10: fffff520001dbf71 R11: 0000000000000004 R12: 0000000000000001
> R13: dffffc0000000000 R14: 0000000000000114 R15: 00000000fffffff4
> FS:  0000000000975940(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000204 CR3: 00000000222d6000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x441889
> Code: e8 cc ac 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffc6a96c958 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 0000000020000200 RCX: 0000000000441889
> RDX: 0000000020ffd000 RSI: 0000000020000200 RDI: 0000000000003040
> RBP: 000000000000d8dd R08: 0000000000000001 R09: 0000000020ffd000
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000020ffd000
> R13: 0000000020ffb000 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace d873293344bf9303 ]---
> RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
> RIP: 0010:io_disable_sqo_submit fs/io_uring.c:8891 [inline]
> RIP: 0010:io_uring_create fs/io_uring.c:9711 [inline]
> RIP: 0010:io_uring_setup fs/io_uring.c:9739 [inline]
> RIP: 0010:__do_sys_io_uring_setup fs/io_uring.c:9745 [inline]
> RIP: 0010:__se_sys_io_uring_setup+0x2abb/0x37b0 fs/io_uring.c:9742
> Code: c0 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 c5 31 de ff 41 be 14 01 00 00 4c 03 33 4c 89 f0 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 46 06 00 00 41 80 0e 01 48 8b 7c 24 30 e8
> RSP: 0018:ffffc90000edfca0 EFLAGS: 00010007
> RAX: 0000000000000022 RBX: ffff888021fe50c0 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffffc90000edfb80
> RBP: ffffc90000edff38 R08: dffffc0000000000 R09: 0000000000000003
> R10: fffff520001dbf71 R11: 0000000000000004 R12: 0000000000000001
> R13: dffffc0000000000 R14: 0000000000000114 R15: 00000000fffffff4
> FS:  0000000000975940(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000204 CR3: 00000000222d6000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
