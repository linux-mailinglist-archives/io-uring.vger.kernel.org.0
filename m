Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBB53CB633
	for <lists+io-uring@lfdr.de>; Fri, 16 Jul 2021 12:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbhGPKlw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Jul 2021 06:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbhGPKlw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Jul 2021 06:41:52 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BFAC06175F;
        Fri, 16 Jul 2021 03:38:56 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso5527927wmj.4;
        Fri, 16 Jul 2021 03:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Vfnva+CLWBxItHixfHavnOZBnCrt1HBiZw1cBtbkz2s=;
        b=ru1A8jLDjJrwsYpIBqSkzZQgke+mxhILocRIiWQyxyZ9auQOom8L4VOvc+01dsYIpz
         bNamCHd5ynDo9G4iqRSVvYHXgMmTmfF5LwN6CdISfey4DfBFicEdiw8itKP2bEUhFrZJ
         kf6bqAg7ZHORYFtr9Q4S7YmTw7p7IA48TcrxlGYWJi1643iQJln5MhitzJL+JK4SR6Rs
         b1KGWTMyfvnpJdZlt3sy/XOFi1IuosBDTnF0gdOd/wVh10KQi3gSaA0QDilRWBRHPdFL
         xLJlAEHcqYWuPmSrpiQEVuO8bHHsPY6nRy1ViOhxkvDMxoGE1qCFmkKoxShbAHo7ebwL
         nDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vfnva+CLWBxItHixfHavnOZBnCrt1HBiZw1cBtbkz2s=;
        b=VpRwM5i4GeYbA3mU6PiOHUWudQe3oHyvK1Q0kqGODW7DyRvNTt2Kauvmr4ITuNTS2o
         Kxgw3vxNdI3VMieqieyk35/hlSCDf49H5GrTBJPQbzTZyndpHZqqgDLHSZ1sU1za5enD
         cs/f+O2YpAYj6bJ/aylfusV7hR9OvLjFgDJgKIuMtLpshqMwOC+nkBF1OBpSsNKD+wFU
         2V3mEE98xSX6g0zt0uhK869b7REleb1pmBrbdRuV6r51jNuA1s4qZ/JR0G89IRgcAKJF
         fT1hIDglpg4P9sa1U6hDqYMbqdt1hww53ABGiVKNxFXBUwmc2n2vbmtpLxMHgqWpUsIA
         eCHA==
X-Gm-Message-State: AOAM533VseQR38R1hMwQpHelo0WQBYeDZ/Wck0lGEHkd/PIm5YcUyqcY
        Ql1HASOWj07GzU8aD5v7yCQ=
X-Google-Smtp-Source: ABdhPJxv1Ukq3h0u9bFz9k5w34AJS6DO/v3AyJ123ocr0SexUhF8cQWaNQeaAI+YKUNo9R+9bxHClg==
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr10015077wmj.148.1626431935079;
        Fri, 16 Jul 2021 03:38:55 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.177])
        by smtp.gmail.com with ESMTPSA id x9sm9774116wrm.82.2021.07.16.03.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 03:38:54 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
To:     syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
References: <000000000000494b5f05c73277cd@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <632ddc1b-b664-3e60-90be-03bdf556aa49@gmail.com>
Date:   Fri, 16 Jul 2021 11:38:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000494b5f05c73277cd@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/21 1:14 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in io_uring_cancel_generic

attempt to get stats #2

#syz test: https://github.com/isilence/linux.git syztest_sqpoll_hang 

> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 25279 at fs/io_uring.c:9122 io_dump fs/io_uring.c:9117 [inline]
> WARNING: CPU: 1 PID: 25279 at fs/io_uring.c:9122 io_uring_cancel_generic+0x5fb/0xe50 fs/io_uring.c:9195
> Modules linked in:
> CPU: 1 PID: 25279 Comm: iou-sqp-25271 Tainted: G        W         5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_dump fs/io_uring.c:9122 [inline]
> RIP: 0010:io_uring_cancel_generic+0x5fb/0xe50 fs/io_uring.c:9195
> Code: 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 9e 06 00 00 48 8b 85 10 08 00 00 48 89 44 24 40 <0f> 0b 48 8b 44 24 10 48 05 98 00 00 00 48 89 c2 48 89 44 24 08 48
> RSP: 0018:ffffc9000ab87c50 EFLAGS: 00010246
> RAX: ffff88803ddb7800 RBX: ffff888049f73880 RCX: 0000000000000000
> RDX: 1ffff110093ee812 RSI: ffffffff81e2ebed RDI: ffff888049f74090
> RBP: ffff888049f73880 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff81e2ebc5 R11: 0000000000000001 R12: ffffc9000ab87d40
> R13: ffff88803ddb7858 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007fb893f40700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f68dd0c6080 CR3: 000000002b457000 CR4: 0000000000350ef0
> Call Trace:
>  io_sq_thread+0xaac/0x1250 fs/io_uring.c:6930
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 25279 Comm: iou-sqp-25271 Tainted: G        W         5.14.0-rc1-syzkaller #0
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
> RIP: 0010:io_dump fs/io_uring.c:9122 [inline]
> RIP: 0010:io_uring_cancel_generic+0x5fb/0xe50 fs/io_uring.c:9195
> Code: 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 9e 06 00 00 48 8b 85 10 08 00 00 48 89 44 24 40 <0f> 0b 48 8b 44 24 10 48 05 98 00 00 00 48 89 c2 48 89 44 24 08 48
> RSP: 0018:ffffc9000ab87c50 EFLAGS: 00010246
> RAX: ffff88803ddb7800 RBX: ffff888049f73880 RCX: 0000000000000000
> RDX: 1ffff110093ee812 RSI: ffffffff81e2ebed RDI: ffff888049f74090
> RBP: ffff888049f73880 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff81e2ebc5 R11: 0000000000000001 R12: ffffc9000ab87d40
> R13: ffff88803ddb7858 R14: 0000000000000001 R15: 0000000000000000
>  io_sq_thread+0xaac/0x1250 fs/io_uring.c:6930
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> Tested on:
> 
> commit:         d55b8f3c io_uring: add syz debug info
> git tree:       https://github.com/isilence/linux.git syztest_sqpoll_hang
> console output: https://syzkaller.appspot.com/x/log.txt?x=16f6cb80300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
> dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
> compiler:       
> 

-- 
Pavel Begunkov
