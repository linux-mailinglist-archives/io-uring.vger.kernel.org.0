Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A403DD4FD
	for <lists+io-uring@lfdr.de>; Mon,  2 Aug 2021 13:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhHBLzr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Aug 2021 07:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbhHBLzq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Aug 2021 07:55:46 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F39C06175F;
        Mon,  2 Aug 2021 04:55:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c16so21131657wrp.13;
        Mon, 02 Aug 2021 04:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wC/6xJZcuCuaJjz0CH4KySadTqqM+xCWdPjD9GdsxsM=;
        b=ELTN4vkp7VR9HF6WQbAX2WommJU8EPgXJBUs38UddrPMB5Taz+WzSTOvNuZVM9MeAR
         d/wdpTVrE3GOfBs8AA4c84BxhmJZ7/pXKeYDuWPxKV0BWKfjS+4vuE5KoVvEngul6xsb
         9YhJq3gq1de70pb27kinpHpP0PMhsPS4ALVtmqqWEpZbX6X4/MqIwjVXm1ctpJU3RQJD
         sAu1KX/ExJMb+YdpvF6mTjAeiefRw572ytdISMJZx+Yi9c/0kaSicOYIHwAsZ0QMfask
         yIQ+IPl4/mkPinPeN4No4YVUgp9hO9iUUslECaTsDVzp4BTOBBM65FY7pbQHGCbkeSYV
         0Awg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wC/6xJZcuCuaJjz0CH4KySadTqqM+xCWdPjD9GdsxsM=;
        b=Z6Jqkna2ctDFdApD7ahLGmuRcgzrAn3WNTr1DwNvQm4A7I1XU6yurhfo2eJ7swTRja
         yz+3piyqpMfgtLdWf0K+lBJ+KiRIh9M0xqjtdVO6FdLZ2bKQTbX3Ji2PuRcwI64lYM2L
         FztjsaPc4625EccORt1DpaQ0Zk5vpo3qmuy5y6Th4KLX4iEtv4NAL6FeMb/s2jQsqVUG
         CeFObXNi0GVE+MlJ1m4kUmETOz/LMgn35WFaX4QZr3XOQtC3WRhBAuSNDaHcJ+eK2aZ3
         mLAbqeieiYcLq8H3C6BNe9cVKnsQsYSMghFs3NmoHXtTQ6YcNkkOkN4YreqegpqYsD36
         xXdA==
X-Gm-Message-State: AOAM5334S8yaG5bDat+kgL7mnOa/Ro1PpjwIZbHCsZ3dFch0CB6HBI0R
        LwyZi/Luz5Je77oBQRkRsNdgkXHmboeimQ==
X-Google-Smtp-Source: ABdhPJyoLD5Fy58UNM9ykJx6IXT3D1+IIR4iwRxf1MbRsF2fbXf/30j1mqucyLEFYIMLchZA6+Bdxw==
X-Received: by 2002:a5d:5410:: with SMTP id g16mr10528006wrv.374.1627905334820;
        Mon, 02 Aug 2021 04:55:34 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.39])
        by smtp.gmail.com with ESMTPSA id c190sm2336880wma.21.2021.08.02.04.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 04:55:34 -0700 (PDT)
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
 <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com>
 <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
 <CADVatmPwM-2oma2mCXnQViKK5DfZ2GS5FLmteEDYwOEOK-mjMg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8db71657-bd61-6b1f-035f-9a69221e7cb3@gmail.com>
Date:   Mon, 2 Aug 2021 12:55:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CADVatmPwM-2oma2mCXnQViKK5DfZ2GS5FLmteEDYwOEOK-mjMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/1/21 9:28 PM, Sudip Mukherjee wrote:
> Hi Pavel,
> 
> On Sun, Aug 1, 2021 at 9:52 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 8/1/21 1:10 AM, Pavel Begunkov wrote:
>>> On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
>>>> Hi Jens, Pavel,
>>>>
>>>> We had been running syzkaller on v5.10.y and a "KASAN:
>>>> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
>>>> got some time to check that today and have managed to get a syzkaller
>>>> reproducer. I dont have a C reproducer which I can share but I can use
>>>> the syz-reproducer to reproduce this with v5.14-rc3 and also with
>>>> next-20210730.
>>>
>>> Can you try out the diff below? Not a full-fledged fix, but need to
>>> check a hunch.
>>>
>>> If that's important, I was using this branch:
>>> git://git.kernel.dk/linux-block io_uring-5.14
>>
>> Or better this one, just in case it ooopses on warnings.
> 
> I tested this one on top of "git://git.kernel.dk/linux-block
> io_uring-5.14" and the issue was still seen, but after the BUG trace I
> got lots of "truncated wr" message. The trace is:

That's interesting, thanks
Can you share the syz reproducer?


> [   80.722255] BUG: KASAN: stack-out-of-bounds in iov_iter_revert+0x809/0x900
> [   80.723126] Read of size 8 at addr ffff8880246ff8b8 by task
> syz-executor.10/7001
> [   80.724070]
> [   80.724274] CPU: 0 PID: 7001 Comm: syz-executor.10 Not tainted 5.14.0-rc1 #1
> [   80.725200] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> [   80.726688] Call Trace:
> [   80.727031]  dump_stack_lvl+0x8b/0xb3
> [   80.727520]  print_address_description.constprop.0+0x1f/0x140
> [   80.728307]  ? iov_iter_revert+0x809/0x900
> [   80.728840]  ? iov_iter_revert+0x809/0x900
> [   80.729358]  kasan_report.cold+0x7f/0x11b
> [   80.729873]  ? iov_iter_revert+0x809/0x900
> [   80.730406]  iov_iter_revert+0x809/0x900
> [   80.730908]  io_write+0x5c9/0xe90
> [   80.731356]  ? io_read+0x1140/0x1140
> [   80.731835]  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
> [   80.732486]  ? lock_is_held_type+0x98/0x110
> [   80.733029]  ? __lock_acquire+0xbb1/0x5b00
> [   80.733541]  io_issue_sqe+0x4da/0x6a80
> [   80.734063]  ? mark_lock+0xfc/0x2d80
> [   80.734539]  ? __is_insn_slot_addr+0x14d/0x250
> [   80.735169]  ? lock_chain_count+0x20/0x20
> [   80.735702]  ? io_write+0xe90/0xe90
> [   80.736167]  ? lock_is_held_type+0x98/0x110
> [   80.736797]  ? find_held_lock+0x2c/0x110
> [   80.737363]  ? lock_release+0x1dd/0x6b0
> [   80.737897]  ? __fget_files+0x21c/0x3e0
> [   80.738445]  ? lock_downgrade+0x6d0/0x6d0
> [   80.738993]  ? lock_release+0x1dd/0x6b0
> [   80.739507]  __io_queue_sqe+0x1ac/0xe50
> [   80.740017]  ? io_issue_sqe+0x6a80/0x6a80
> [   80.740564]  ? lock_is_held_type+0x98/0x110
> [   80.741142]  io_submit_sqes+0x3f6e/0x76a0
> [   80.741688]  ? xa_load+0x158/0x290
> [   80.742173]  ? __do_sys_io_uring_enter+0x90c/0x1a20
> [   80.742817]  __do_sys_io_uring_enter+0x90c/0x1a20
> [   80.743436]  ? vm_mmap_pgoff+0xe8/0x280
> [   80.743981]  ? io_submit_sqes+0x76a0/0x76a0
> [   80.744539]  ? randomize_stack_top+0x100/0x100
> [   80.745228]  ? __do_sys_futex+0xf2/0x3d0
> [   80.745763]  ? __do_sys_futex+0xfb/0x3d0
> [   80.746339]  ? __restore_fpregs_from_fpstate+0xa0/0xe0
> [   80.747183]  ? trace_event_raw_event_x86_fpu+0x3a0/0x3a0
> [   80.747960]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
> [   80.748672]  ? syscall_enter_from_user_mode+0x1d/0x50
> [   80.749422]  do_syscall_64+0x3b/0x90
> [   80.750030]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   80.750880] RIP: 0033:0x466609
> [   80.751402] Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
> 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89
> 01 48
> [   80.754298] RSP: 002b:00007f22e8d3a188 EFLAGS: 00000246 ORIG_RAX:
> 00000000000001aa
> [   80.755441] RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 0000000000466609
> [   80.756510] RDX: 0000000000000000 RSI: 00000000000058ab RDI: 0000000000000003
> [   80.757492] RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
> [   80.758474] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
> [   80.759487] R13: 00007ffca119d4ef R14: 00007f22e8d3a300 R15: 0000000000022000
> [   80.760646]
> [   80.760908] The buggy address belongs to the page:
> [   80.761689] page:000000005ec48a9f refcount:0 mapcount:0
> mapping:0000000000000000 index:0x0 pfn:0x246ff
> [   80.763184] flags: 0x100000000000000(node=0|zone=1)
> [   80.763966] raw: 0100000000000000 0000000000000000 ffffea000091bfc8
> 0000000000000000
> [   80.765064] raw: 0000000000000000 0000000000000000 00000000ffffffff
> 0000000000000000
> [   80.766127] page dumped because: kasan: bad access detected
> [   80.767038]
> [   80.767302] addr ffff8880246ff8b8 is located in stack of task
> syz-executor.10/7001 at offset 152 in frame:
> [   80.768587]  io_write+0x0/0xe90
> [   80.769039]
> [   80.769283] this frame has 3 objects:
> [   80.769776]  [48, 56) 'iovec'
> [   80.769785]  [80, 120) '__iter'
> [   80.770195]  [160, 288) 'inline_vecs'
> [   80.770642]
> [   80.771323] Memory state around the buggy address:
> [   80.771975]  ffff8880246ff780: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   80.772970]  ffff8880246ff800: 00 00 00 00 f1 f1 f1 f1 00 00 00 f2
> f2 f2 00 00
> [   80.774020] >ffff8880246ff880: 00 00 00 f2 f2 f2 f2 f2 00 00 00 00
> 00 00 00 00
> [   80.775119]                                         ^
> [   80.775963]  ffff8880246ff900: 00 00 00 00 00 00 00 00 f3 f3 f3 f3
> 00 00 00 00
> [   80.777154]  ffff8880246ff980: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> 
> Lots of "truncated wr: 61440" and others.
> [   82.690641] truncated wr: 36864
> [   82.692929] truncated wr: 4096
> [   82.695404] truncated wr: 61440
> [   82.697840] truncated wr: 45056
> [   82.700011] truncated wr: 61440
> [   82.702401] truncated wr: 28672
> [   82.704855] truncated wr: 12288
> [   82.707070] truncated wr: 12288
> [   82.709388] truncated wr: 36864
> [   82.711758] truncated wr: 36864
> [   82.713977] truncated wr: 28672
> [   82.716176] truncated wr: 28672
> and lots more.
> 

-- 
Pavel Begunkov
