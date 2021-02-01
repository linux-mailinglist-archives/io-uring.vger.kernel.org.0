Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9344330AB90
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 16:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhBAPhN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 10:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhBAPhL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 10:37:11 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B399EC061573;
        Mon,  1 Feb 2021 07:36:30 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id g10so17066915wrx.1;
        Mon, 01 Feb 2021 07:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Io1hDqqBt5odDujW2OOi0bpS8IsMUxoXmDL819C2qRE=;
        b=S2WzmItpZ0kiP+co5licM5qC9sKFxoxEODotFJ7x3OAFLopB7VX0P9aFEVZn3IPi+x
         l+bD1dbuQWL9RxFsOWpZY10XVM0q5zQntVUSaycC9bmer4cn16K/V6yz3w6dPRIibwXX
         jALlphG/gEwXdLLN9/iZjQeeyE1c5+6e31zCKWQxmy4nCkVXYT+CC0p8DlJblm/WaB/h
         PF5n+YCpk6cNMpVYMbGB7aos1iLvPVjI1r1aXRJSQVT38TEjUzcV9GzQiSd1SjWASeGF
         YQBWYmZ+O2GwLbXnIK/8zouwuXYdqIO6OkRE4NMzyaB+lUJp79/Q7e3OO8M0Yqdi+3kw
         457Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Io1hDqqBt5odDujW2OOi0bpS8IsMUxoXmDL819C2qRE=;
        b=T+sODJ+/4kEK8h65HJtnmV04zouDxPPT8y4GakXBZ87DWUR4ISA+xKQHWghwGQvA2t
         dyni5t6L7OViVand3XyTNXaFLNKog0NiD/rfEkUsU3nzgc3SvVYenEdpSHhXnuHqcakC
         c7wNjgOUL+aH69R0r2Gq3/Bkcub2wsUag5bJiguU6U6ajl+k8QqAFw0RwJGSsWo2NUhH
         WvbScJHxNc8nz8RWl6+XioFQn/63i+ddVPz0WYspakkdF407MJgXuWyYWeikMR3DkERO
         SuBpC5x9BtoNrpBxHPSwQSJYracIWA7ucX/j14q+Sgo6meYTKIxJJqRlDn6Tu4bpXGsw
         aXWA==
X-Gm-Message-State: AOAM531HlPi0HdZbpFaasQuIZHbp1RG16KzlerIyPOSqJaHlyb8pLI2E
        9jPVXm/bTTf2icxBH6v95DY=
X-Google-Smtp-Source: ABdhPJxnT3n1o6bFCgrV69f1cb558uzCSiZJGnuwsnE9dkzfIMIxpXr5WvUEQOjoAelWX7OTAC94Ug==
X-Received: by 2002:adf:9523:: with SMTP id 32mr19439442wrs.361.1612193789489;
        Mon, 01 Feb 2021 07:36:29 -0800 (PST)
Received: from [192.168.8.166] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id a16sm26817032wrr.89.2021.02.01.07.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 07:36:28 -0800 (PST)
Subject: Re: WARNING in io_disable_sqo_submit
To:     syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>,
        axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000052e4f305ba4807ca@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <06380635-4410-477f-6b92-468ab5d289c2@gmail.com>
Date:   Mon, 1 Feb 2021 15:32:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000052e4f305ba4807ca@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/02/2021 15:30, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in io_uring_cancel_task_requests

#syz fix: io_uring: fix sqo ownership false positive warning

> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 10843 at fs/io_uring.c:9039 io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9039
> Modules linked in:
> CPU: 1 PID: 10843 Comm: syz-executor.3 Not tainted 5.11.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9039
> Code: 00 00 e9 1c fe ff ff 48 8b 7c 24 18 e8 14 21 db ff e9 f2 fc ff ff 48 8b 7c 24 18 e8 05 21 db ff e9 64 f2 ff ff e8 9b a0 98 ff <0f> 0b e9 ed f2 ff ff e8 ff 20 db ff e9 c8 f5 ff ff 4c 89 ef e8 72
> RSP: 0018:ffffc9000cc37950 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888027fcc000 RCX: 0000000000000000
> RDX: ffff888045a1a040 RSI: ffffffff81da2255 RDI: ffff888027fcc0d0
> RBP: ffff888027fcc0e8 R08: 0000000000000000 R09: ffff888045a1a047
> R10: ffffffff81da14cf R11: 0000000000000000 R12: ffff888027fcc000
> R13: ffff888045a1a040 R14: ffff88802e748000 R15: ffff88803ca86018
> FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f09d5e60d40 CR3: 0000000028319000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_uring_flush+0x47b/0x6e0 fs/io_uring.c:9224
>  filp_close+0xb4/0x170 fs/open.c:1286
>  close_files fs/file.c:403 [inline]
>  put_files_struct fs/file.c:418 [inline]
>  put_files_struct+0x1cc/0x350 fs/file.c:415
>  exit_files+0x7e/0xa0 fs/file.c:435
>  do_exit+0xc22/0x2ae0 kernel/exit.c:820
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  get_signal+0x427/0x20f0 kernel/signal.c:2773
>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x465b09
> Code: Unable to access opcode bytes at RIP 0x465adf.
> RSP: 002b:00007f21a56f2108 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
> RAX: 0000000000000004 RBX: 000000000056c0b0 RCX: 0000000000465b09
> RDX: 00000000206d4000 RSI: 00000000200002c0 RDI: 0000000000000187
> RBP: 00000000200002c0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> R13: 00000000206d4000 R14: 0000000000000000 R15: 0000000020ee7000
> 
> 
> Tested on:
> 
> commit:         1d538571 io_uring: check kthread parked flag before sqthre..
> git tree:       git://git.kernel.dk/linux-block for-5.12/io_uring
> console output: https://syzkaller.appspot.com/x/log.txt?x=14532690d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fe3e1032f57d6d25
> dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
> compiler:       
> 

-- 
Pavel Begunkov
