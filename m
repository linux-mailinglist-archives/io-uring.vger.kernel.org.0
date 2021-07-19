Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716DD3CD598
	for <lists+io-uring@lfdr.de>; Mon, 19 Jul 2021 15:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhGSMfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jul 2021 08:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbhGSMfQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jul 2021 08:35:16 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15370C061762
        for <io-uring@vger.kernel.org>; Mon, 19 Jul 2021 05:36:11 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k4so21969431wrc.8
        for <io-uring@vger.kernel.org>; Mon, 19 Jul 2021 06:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=B9RbvI67bk5EGxlpcVpWhTxOJihgU67KhRzzpEsRFBM=;
        b=TDh2vjFQF6jukBFvm22i8UZagc/AcqbPcIhdsJxYGQrYXUa1/9jnAZY+HWsGU+wx5E
         Sexn9fPy5poRJ7zl2mA3ydsBON2zm49ykAGLN/GoeC8UbDWXo7wAtUtRp/sWudKXdzmc
         BbePUYHubFyEGVlo30PCU70CjbtRmbc8PjSqhhOGusROpt8yBtW97HTL+kwIZaLFMfVU
         8JcF39+5UCD2+6/Fy0dCv8x1fVxPJJNMHoWgbCJZ849EeTF8B7O3kfKP+gbCpFnSZEfG
         w5JNOfAx81rleTV4k649WaMQ5eOu+AC6Fbg43WH6oXsU4rJnr9SlPjDwRtv13s4S2Dta
         JgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B9RbvI67bk5EGxlpcVpWhTxOJihgU67KhRzzpEsRFBM=;
        b=Knt2l4Zss4wPgD8bVzP5mIylVfI4eLsWfr/fzQt0sOpudBsBlTxVRIf4K1ilHsNC/w
         aYufhzHTT23AM8ehRL3PMdbEbzGKErLY1Nv/U9NZ3JUZbaynshPfIW4DgZM/YiaacYCt
         A/i/2/tubLuPMItS8wBtIqC6JoV8/9mvaROA43MxWuWH3t14vQAW79EPeLLWVUoQlmCe
         RdUST+Fgy9Usbzq2m3PNnmYo5u6/obt63KrT2ZPD6ftWj7YbLpXc70tlVryI+o2hSTtK
         gfDTXJmhRpjfrBy6QkVo2gok+nYYkjcuc04zzGw+YxtKNAQQcDJJWXaSlfKE22LvhXgZ
         Coaw==
X-Gm-Message-State: AOAM5309u3jA/rNTuzCLtBOXfBlsV5TCMavfeKsqyyEzjBU+SOXtxVue
        99ywjU7895gg+h/VzqL5Vqw=
X-Google-Smtp-Source: ABdhPJxqI0BcSPmy9vxMvnblgQUQYMI7hI0c3CuF1mlEYUvH6pnFz/HV6RQMjetNHDnVUI7aMB7BGQ==
X-Received: by 2002:a5d:4e43:: with SMTP id r3mr29568873wrt.132.1626700554497;
        Mon, 19 Jul 2021 06:15:54 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id g3sm20952807wrv.64.2021.07.19.06.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 06:15:54 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
To:     syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000e1f38205c73b72cc@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b96f1da5-4e0b-331a-0a81-9a86733c830d@gmail.com>
Date:   Mon, 19 Jul 2021 14:15:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000e1f38205c73b72cc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/21 11:57 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in io_uring_cancel_generic

Not clear yet, let's add more stats and rerun

#syz test: https://github.com/isilence/linux.git syztest_sqpoll_hang 

> 
> ctx ffff8880467ee000 submitted 1, dismantled 0, crefs 0, inflight 1, fallbacks 0, poll1 0, poll2 0, tw 0, hash 0, cs 0, issued 1 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 18216 at fs/io_uring.c:9142 io_dump fs/io_uring.c:9142 [inline]
> WARNING: CPU: 0 PID: 18216 at fs/io_uring.c:9142 io_uring_cancel_generic+0x608/0xea0 fs/io_uring.c:9198
> Modules linked in:
> CPU: 0 PID: 18216 Comm: iou-sqp-18211 Not tainted 5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_dump fs/io_uring.c:9142 [inline]
> RIP: 0010:io_uring_cancel_generic+0x608/0xea0 fs/io_uring.c:9198
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 d5 02 00 00 48 8b 44 24 10 48 8b a8 98 00 00 00 48 39 6c 24 08 0f 85 02 03 00 00 e8 f8 97 92 ff <0f> 0b e9 af fe ff ff e8 ec 97 92 ff 48 8b 74 24 20 b9 08 00 00 00
> RSP: 0018:ffffc9000afefc40 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88802a09d4c0 RCX: 0000000000000000
> RDX: ffff88802a09d4c0 RSI: ffffffff81e2f0b8 RDI: ffff8880467ee510
> RBP: ffff8880462fb788 R08: 0000000000000081 R09: 0000000000000000
> R10: ffffffff815d066e R11: 0000000000000000 R12: ffff8880462fa458
> R13: ffffc9000afefd40 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007f9295c2d700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1c3f1a3000 CR3: 0000000018755000 CR4: 0000000000350ee0
> Call Trace:
>  io_sq_thread+0xaac/0x1250 fs/io_uring.c:6932
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 18216 Comm: iou-sqp-18211 Not tainted 5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>  panic+0x306/0x73d kernel/panic.c:232
>  __warn.cold+0x35/0x44 kernel/panic.c:606
>  report_bug+0x1bd/0x210 lib/bug.c:199
>  handle_bug+0x3c/0x60 arch/x86/kernel/traps.c:239
>  exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:259
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:566
> RIP: 0010:io_dump fs/io_uring.c:9142 [inline]
> RIP: 0010:io_uring_cancel_generic+0x608/0xea0 fs/io_uring.c:9198
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 d5 02 00 00 48 8b 44 24 10 48 8b a8 98 00 00 00 48 39 6c 24 08 0f 85 02 03 00 00 e8 f8 97 92 ff <0f> 0b e9 af fe ff ff e8 ec 97 92 ff 48 8b 74 24 20 b9 08 00 00 00
> RSP: 0018:ffffc9000afefc40 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88802a09d4c0 RCX: 0000000000000000
> RDX: ffff88802a09d4c0 RSI: ffffffff81e2f0b8 RDI: ffff8880467ee510
> RBP: ffff8880462fb788 R08: 0000000000000081 R09: 0000000000000000
> R10: ffffffff815d066e R11: 0000000000000000 R12: ffff8880462fa458
> R13: ffffc9000afefd40 R14: 0000000000000001 R15: 0000000000000000
>  io_sq_thread+0xaac/0x1250 fs/io_uring.c:6932
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> Tested on:
> 
> commit:         81fee56e io_uring: add syz debug info
> git tree:       https://github.com/isilence/linux.git syztest_sqpoll_hang
> console output: https://syzkaller.appspot.com/x/log.txt?x=12bb485c300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
> dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
> compiler:       
> 

-- 
Pavel Begunkov
