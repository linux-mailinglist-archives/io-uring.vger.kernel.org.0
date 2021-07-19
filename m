Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32363CE7AE
	for <lists+io-uring@lfdr.de>; Mon, 19 Jul 2021 19:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346086AbhGSQay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jul 2021 12:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348993AbhGSQ2U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jul 2021 12:28:20 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7949FC0613B8;
        Mon, 19 Jul 2021 09:36:35 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id m2so22929883wrq.2;
        Mon, 19 Jul 2021 09:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5+QOzmPrwqlbL8vra0BGb2Ncq2IXwGOQ5UDn3gWSHlI=;
        b=rnts9UdrzhohLVh+9ixRtTD7Qb07WM3ssUiEmddB71N4D1TswgPQ6DHWQIf0HzaA+i
         mnEtgjp5b05QUZ0NQOPia4dKSZ/fcv74pfyMNB7At207tw4WCj33lzzYv3W6OrJL21/S
         +y/zS0BstF87nbZzwfsuSN2g3vnFjqaLFhngtCaXgp4IAykUsWM1Kny9Zq+nCtB0Ym/7
         KC54WKfkgOH5W0E66RJ/mlAVTwjiJcApbgIaH0A4idEvAT51evpwNqyzoLT/axRyqJwx
         xBT7KUdIZsbgPtMa+V78pHhFMMBNZSKobFQnMrkAFW0xt3/eRl2qjFs5CXzSi3G217r7
         3wrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5+QOzmPrwqlbL8vra0BGb2Ncq2IXwGOQ5UDn3gWSHlI=;
        b=P/gQzI01RlS8jglyWFNurgfYog7VyY8JJQFKnTSGQlCkIFE0VlrEnpyb33CN6vXz3t
         KYAe2ao1TYO4k92WpKyqouUkghb0ZE6De1qFdYzg7PrpLvO37BlwIA+Y7GQQaxc396yy
         +4gjKmiuErRMYPFBEHgwvyzUNql9xz3SAobRQ2+hmZyFFZ/Utt1YNL7AfuVhGoaHAflZ
         smOf5OO/T8gFCsgkP9zHZqiMHInyw3ObvzcieELOVL01b9YwTxdW1ZGecfpXnUJOE17y
         lVskegfTl/VY9HajJglRNqh/kwRSO53/2MaWYhuf4rv4A4dI0Aop0Vf8N8KDRztyu3i0
         FdRw==
X-Gm-Message-State: AOAM5311YpcjVQQNzKPridml+CdtruCy5uLToVHoXakM7X52ZaVXiINR
        EfRMsV+7tldHzf6mqDRRxqY=
X-Google-Smtp-Source: ABdhPJxbQbtOZ2Yshkhwdtv7MbXI/CWSa+ZztPy+mDMVONsDCVZELhY3bccQHDdCn40QSRaHTc3k5w==
X-Received: by 2002:adf:e586:: with SMTP id l6mr31611423wrm.26.1626713869284;
        Mon, 19 Jul 2021 09:57:49 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id n11sm67677wms.0.2021.07.19.09.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 09:57:48 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
To:     syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
References: <000000000000e1f38205c73b72cc@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c57f80f7-440b-9f12-a7b7-a58ed7ab400a@gmail.com>
Date:   Mon, 19 Jul 2021 17:57:25 +0100
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

__arm_poll doesn't remove a second poll entry in case of failed
__io_queue_proc(), it's most likely the cause here.

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
