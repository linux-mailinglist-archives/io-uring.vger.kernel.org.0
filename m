Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4CE36500A
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 03:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhDTB7m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 21:59:42 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:35746 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhDTB7k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 21:59:40 -0400
Received: by mail-io1-f71.google.com with SMTP id l2-20020a5e82020000b02903c2fa852f92so11166184iom.2
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 18:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MO02XUl0aoNqpo6dX9XnX5kbdgf0uyAoe+pFwP29OxQ=;
        b=YQJxhIq56W63lLNnlD+30NbKAhYVLlNkDDrqOeVh/lMfw06eMtcxme+6AqITsCJ8dw
         2CyR9f3+7aWnWsSg6E2czzcOCqp4hgeHuA++O9dkxYnPDv06Mrf/Y1mGAhLaBcfVaCY3
         wtdxGU7vVzAna+kBuN7zxg/hiT9vE2y5rUbS98QcF6E3LW0f1c98TA1Snf1PY/wxsaCs
         GSb42tGYh9ZWFJLUYvBenZH0r/MK6zUCQVjQYUmtPk5UqTymvqY1skq3ItZdPko/6L5f
         dnPU9V9NHtmnaksEqIvxI+Dnqtp7S4n4kk3trQngusTeLdaoDrn0A3bV7PEXNpcheZl0
         YDcw==
X-Gm-Message-State: AOAM53146mnq7oBZRv+L144rCHj65P3k8jLma/TUKdKTw3XgNDDwFwqM
        DGrMLtOiUkRTmdBRWcQGLyi+ZDttDlCpp6IjzKGne8NWoYkd
X-Google-Smtp-Source: ABdhPJxR/C8PUCJjyQd7eoEyHWPFP1jUdDoLAa204hiUEjw39du4ftvrUV/MoG9WvgZGYb0t4ysOzShuy5VHKjCvnZZ16CUTyU3v
MIME-Version: 1.0
X-Received: by 2002:a92:6a0b:: with SMTP id f11mr19749909ilc.211.1618883948355;
 Mon, 19 Apr 2021 18:59:08 -0700 (PDT)
Date:   Mon, 19 Apr 2021 18:59:08 -0700
In-Reply-To: <02616552-d7c2-a3ea-a03d-a93d15023662@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aca64205c05dcab3@google.com>
Subject: Re: [syzbot] INFO: task hung in __io_uring_cancel
From:   syzbot <syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: null-ptr-deref Write in io_uring_cancel_sqpoll

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
BUG: KASAN: null-ptr-deref in io_uring_cancel_sqpoll+0x150/0x310 fs/io_uring.c:8930
Write of size 4 at addr 0000000000000114 by task iou-sqp-31588/31596

CPU: 0 PID: 31596 Comm: iou-sqp-31588 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:403 [inline]
 kasan_report.cold+0x5f/0xd8 mm/kasan/report.c:416
 check_region_inline mm/kasan/generic.c:180 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 io_uring_cancel_sqpoll+0x150/0x310 fs/io_uring.c:8930
 io_sq_thread+0x47e/0x1310 fs/io_uring.c:6873
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 31596 Comm: iou-sqp-31588 Tainted: G    B             5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 end_report mm/kasan/report.c:102 [inline]
 end_report.cold+0x5a/0x5a mm/kasan/report.c:88
 __kasan_report mm/kasan/report.c:406 [inline]
 kasan_report.cold+0x6a/0xd8 mm/kasan/report.c:416
 check_region_inline mm/kasan/generic.c:180 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 io_uring_cancel_sqpoll+0x150/0x310 fs/io_uring.c:8930
 io_sq_thread+0x47e/0x1310 fs/io_uring.c:6873
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


Tested on:

commit:         734551df io_uring: fix shared sqpoll cancellation hangs
git tree:       git://git.kernel.dk/linux-block for-5.13/io_uring
console output: https://syzkaller.appspot.com/x/log.txt?x=175fec6dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=601d16d8cd22e315
dashboard link: https://syzkaller.appspot.com/bug?extid=47fc00967b06a3019bd2
compiler:       

