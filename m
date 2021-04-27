Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380B536BF4E
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 08:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhD0Gal (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 02:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhD0Gal (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 02:30:41 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AF7C061574
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 23:29:58 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id z2so22028416qkb.9
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 23:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/pV0AqXqbkthcwk38nLrMq1WVbt4ZRnRJR4uUDC7/ME=;
        b=LtDpQqhqRKg1LRrtuXslfNLH06XS3SHGL9cCs8S3kZEwfU5eTHjLzs0OzeRM5EF10c
         S67kZcrBH0t/iesFTHoQiBzEThBqwY0mW/paDJ7Tu/hbKKLPfbGDCFYxkwQgOEaejDot
         3wLqdp2bRQOqL2Zk0JGdW1NqJazdjWJ9NLsDT3KM0Z2bmzmzy8uv5yzPv0cvmCVmtb67
         59nQfRu4YKXM3NY/tdlfKESTQ29rEjHtQZh83psbcOSg9ho0Pf61O7k+PZQhxgQJLYPj
         ub2S14D82/4NZXeJyjyE66oyEHrR8cq81GMDIw8yluLM0IsuZjZADBWZTx/yyn6icyih
         uySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/pV0AqXqbkthcwk38nLrMq1WVbt4ZRnRJR4uUDC7/ME=;
        b=HGCylWu7SpygX/NSEMxbILcfMizplJtDkkArS0nJNds0duhB432xanByn2Ta7cDgWj
         WGWQPDErDwghHbVQaQVyV6HjBtlDyfV3ZzvfR7ZYcTLCl12Ygk2bpjl6ZaTBFNRafdWD
         rcLv5yr6uLLa2FD+aSendmOZLGvgkTwni7nZHY2OiBW1OjQ72fdBLzZXI1fl/2zDzI7M
         EVXduQ4GKvbt7cxczvN0YzEHVPJZPeUHW8FgeFEGmj3dMrRUeijuwgi4Dj38E/FOjVLI
         WvWzjQBxj3kK5KG6GwIOS5PYol9sX+lb83pEOS3t71KkhOOGoY1vKQBiaMbqb+S7Vye8
         cN+A==
X-Gm-Message-State: AOAM531vTKH5IxGj7eVMJc9Mkc5qlpmOSbR5b5xWenzbmYw4HGLgS00V
        IGn+k5BLEjtjTLFBrWd08ndAOhGGCjxd4qS0XLD/eA==
X-Google-Smtp-Source: ABdhPJxcsBydfmT6CZ7+3NAVrZkaZgOaWm1qGfP6YqLXcJtvGOQAQ3vF/Xnv4j286mRezb1Vtgyx1G7mSO4SapbWyiQ=
X-Received: by 2002:a37:8f06:: with SMTP id r6mr21527712qkd.424.1619504997400;
 Mon, 26 Apr 2021 23:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000022ebeb05bc39f582@google.com> <e939af11-7ce8-46af-8c76-651add0ae56bn@googlegroups.com>
In-Reply-To: <e939af11-7ce8-46af-8c76-651add0ae56bn@googlegroups.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 27 Apr 2021 08:29:46 +0200
Message-ID: <CACT4Y+aPRCZcLvkuWgK=A_rR0PqdEAM+xssWU4N7hNRSm9=mSA@mail.gmail.com>
Subject: Re: KASAN: null-ptr-deref Write in io_uring_cancel_sqpoll
To:     Palash Oswal <oswalpalash@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc:     syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 26, 2021 at 5:58 PM Palash Oswal <oswalpalash@gmail.com> wrote:
> On Friday, February 26, 2021 at 3:03:16 PM UTC+5:30 syzbot wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit: d01f2f7e Add linux-next specific files for 20210226
>> git tree: linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D108dc5a8d000=
00
>> kernel config: https://syzkaller.appspot.com/x/.config?x=3Da1746d2802a82=
a05
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbe51ca5a4d97f0=
17cd50
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+be51ca...@syzkaller.appspotmail.com
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux=
/instrumented.h:101 [inline]
>> BUG: KASAN: null-ptr-deref in atomic_inc include/asm-generic/atomic-inst=
rumented.h:240 [inline]
>> BUG: KASAN: null-ptr-deref in io_uring_cancel_sqpoll+0x2c7/0x450 fs/io_u=
ring.c:8871
>> Write of size 4 at addr 0000000000000110 by task iou-sqp-19439/19447
>>
>> CPU: 0 PID: 19447 Comm: iou-sqp-19439 Not tainted 5.11.0-next-20210226-s=
yzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/01/2011
>> Call Trace:
>> __dump_stack lib/dump_stack.c:79 [inline]
>> dump_stack+0xfa/0x151 lib/dump_stack.c:120
>> __kasan_report mm/kasan/report.c:403 [inline]
>> kasan_report.cold+0x5f/0xd8 mm/kasan/report.c:416
>> check_region_inline mm/kasan/generic.c:180 [inline]
>> kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
>> instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>> atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
>> io_uring_cancel_sqpoll+0x2c7/0x450 fs/io_uring.c:8871
>> io_sq_thread+0x1109/0x1ae0 fs/io_uring.c:6782
>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 0 PID: 19447 Comm: iou-sqp-19439 Tainted: G B 5.11.0-next-20210226-=
syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/01/2011
>> Call Trace:
>> __dump_stack lib/dump_stack.c:79 [inline]
>> dump_stack+0xfa/0x151 lib/dump_stack.c:120
>> panic+0x306/0x73d kernel/panic.c:231
>> end_report mm/kasan/report.c:102 [inline]
>> end_report.cold+0x5a/0x5a mm/kasan/report.c:88
>> __kasan_report mm/kasan/report.c:406 [inline]
>> kasan_report.cold+0x6a/0xd8 mm/kasan/report.c:416
>> check_region_inline mm/kasan/generic.c:180 [inline]
>> kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
>> instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>> atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
>> io_uring_cancel_sqpoll+0x2c7/0x450 fs/io_uring.c:8871
>> io_sq_thread+0x1109/0x1ae0 fs/io_uring.c:6782
>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> Kernel Offset: disabled
>> Rebooting in 86400 seconds..
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzk...@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
>
> My syzkaller instance reported a syz-repro for this bug:
> Syzkaller reproducer: # {Threaded:true Collide:true Repeat:true RepeatTim=
es:0 Procs:2 Slowdown:1 Sandbox:none Fault:false FaultCall:-1 FaultNth:0 Le=
ak:false NetInjection:true NetDevices:true NetReset:true Cgroups:true Binfm=
tMisc:true CloseFDs:true KCSAN:false DevlinkPCI:false USB:false VhciInjecti=
on:false Wifi:false IEEE802154:false Sysctl:true UseTmpDir:true HandleSegv:=
true Repro:false Trace:false}
> r0 =3D fsmount(0xffffffffffffffff, 0x1, 0xc)
> syz_io_uring_setup(0x329b, &(0x7f0000000080)=3D{0x0, 0x850e, 0x2, 0x2, 0x=
1b4}, &(0x7f0000ffc000/0x4000)=3Dnil, &(0x7f0000ffa000/0x4000)=3Dnil, 0x0, =
0x0)
> syz_io_uring_setup(0x3de2, &(0x7f0000001480)=3D{0x0, 0x4f62, 0x4, 0x2, 0x=
75}, &(0x7f0000ffb000/0x3000)=3Dnil, &(0x7f0000ffd000/0x3000)=3Dnil, 0x0, 0=
x0)
> fsetxattr$trusted_overlay_nlink(r0, &(0x7f0000000140), 0x0, 0x0, 0x0)
>
> I'm working to get a c reproducer for it that is consistent. This syz-rep=
ro does not produce a working reproducer for me just yet.
> Initial suspicion is that io_sq_thread_stop sets set_bit(IO_SQ_THREAD_SHO=
ULD_STOP, &sqd->state);
> And subsequently after a return from fork, where the process receives a S=
IGKILL and io_uring_cancel_sqpoll(ctx) is called with a NULL ctx in io_sq_t=
hread(). I haven't connected all of the dots yet, working on it.

+kernel lists and syzbot email
(almost nobody is reading syzkaller-bugs@ itself)
