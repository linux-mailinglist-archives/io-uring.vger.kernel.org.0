Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD53DCDB3
	for <lists+io-uring@lfdr.de>; Sun,  1 Aug 2021 22:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhHAU26 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Aug 2021 16:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhHAU25 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Aug 2021 16:28:57 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1F4C06175F;
        Sun,  1 Aug 2021 13:28:49 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id s48so2271738ybi.7;
        Sun, 01 Aug 2021 13:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jVJW++KJBQFAIWwmuAI/1m/pz9H0NS90OcrEFHVUCYA=;
        b=JE6H9wMEtIWnrkGbsldluqcJ70lyv4GsQSG+Rdv55lZbIvOM5qrgpFJEIM8bXzZSOe
         4YpHx8bZ7Jhl9eHiwi0lWWDV8q9RvyuqvFZN/GP7VK5LozKeF0/8DkFy5ikns/G+nUQv
         SIqF3tZ1q8cAnBoelqauwFapygS9yvwPgaFtlVz6MhsUY3SjFjwqplgJooB7Lo6DG2uH
         r358speFuoySSQJ5EpnEk9shC6WSajCJX+y28kPok63AfBbwyT9pEzeulxcEx3/fWe7l
         xWNGBd1Yr/6MgiZf6p87Ksqlf2t/ruvN+XCIKU+jWjvc4LXmlTbXt25p8kBetjZQTf8h
         r/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVJW++KJBQFAIWwmuAI/1m/pz9H0NS90OcrEFHVUCYA=;
        b=ZgU2Zl36QR+sUzEAhTKd414N3n1G8x1CxGEBQPdtxpDdZ1eLWBq5Y3AUh7SWcP5hSK
         tG4akq+Q8kDcK7LwBaSY1HTig+UcfvM0GL7in3ekFcgICCMwiqbXWXva0h52MZ7AE8mk
         q0a7G0h3I5dFPbKnK3+BxRqHwYrx5uXk/BQt20yE6JmUBr6dfJ79+pvX9AoXBVRta0Sh
         kInMUVVafkfmriIN6XtfbjDUVofidz/PM5HwZX42MJvSLE3DNaEu9L64DEeFTYDarfsl
         6ENTen9l4PiDSzDL6umUT2XZF7P8/VzGFSixjdehZFx6gfv6UhwsID5nTjg+ttZ9uC6Z
         KLuA==
X-Gm-Message-State: AOAM530Rldhxe6imDG9CYSjXADF09bq5IjBo1Dg32JTGf54yTaY9xkYb
        isRnE+tMzDoE00NTussbXvbqq9dwT6exEy1mWHE=
X-Google-Smtp-Source: ABdhPJxL4M/7+R1r4u5n0GIIwObJ+b/Neun+AO/qqK7EDZ9JpVPc8nN9xWqYf+ommwmxtT/oTQUv3hWt4bGacu0tM50=
X-Received: by 2002:a25:bc02:: with SMTP id i2mr15631081ybh.98.1627849728604;
 Sun, 01 Aug 2021 13:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
 <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com> <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
In-Reply-To: <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sun, 1 Aug 2021 21:28:12 +0100
Message-ID: <CADVatmPwM-2oma2mCXnQViKK5DfZ2GS5FLmteEDYwOEOK-mjMg@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

On Sun, Aug 1, 2021 at 9:52 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 8/1/21 1:10 AM, Pavel Begunkov wrote:
> > On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
> >> Hi Jens, Pavel,
> >>
> >> We had been running syzkaller on v5.10.y and a "KASAN:
> >> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
> >> got some time to check that today and have managed to get a syzkaller
> >> reproducer. I dont have a C reproducer which I can share but I can use
> >> the syz-reproducer to reproduce this with v5.14-rc3 and also with
> >> next-20210730.
> >
> > Can you try out the diff below? Not a full-fledged fix, but need to
> > check a hunch.
> >
> > If that's important, I was using this branch:
> > git://git.kernel.dk/linux-block io_uring-5.14
>
> Or better this one, just in case it ooopses on warnings.

I tested this one on top of "git://git.kernel.dk/linux-block
io_uring-5.14" and the issue was still seen, but after the BUG trace I
got lots of "truncated wr" message. The trace is:

[   80.722255] BUG: KASAN: stack-out-of-bounds in iov_iter_revert+0x809/0x900
[   80.723126] Read of size 8 at addr ffff8880246ff8b8 by task
syz-executor.10/7001
[   80.724070]
[   80.724274] CPU: 0 PID: 7001 Comm: syz-executor.10 Not tainted 5.14.0-rc1 #1
[   80.725200] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   80.726688] Call Trace:
[   80.727031]  dump_stack_lvl+0x8b/0xb3
[   80.727520]  print_address_description.constprop.0+0x1f/0x140
[   80.728307]  ? iov_iter_revert+0x809/0x900
[   80.728840]  ? iov_iter_revert+0x809/0x900
[   80.729358]  kasan_report.cold+0x7f/0x11b
[   80.729873]  ? iov_iter_revert+0x809/0x900
[   80.730406]  iov_iter_revert+0x809/0x900
[   80.730908]  io_write+0x5c9/0xe90
[   80.731356]  ? io_read+0x1140/0x1140
[   80.731835]  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
[   80.732486]  ? lock_is_held_type+0x98/0x110
[   80.733029]  ? __lock_acquire+0xbb1/0x5b00
[   80.733541]  io_issue_sqe+0x4da/0x6a80
[   80.734063]  ? mark_lock+0xfc/0x2d80
[   80.734539]  ? __is_insn_slot_addr+0x14d/0x250
[   80.735169]  ? lock_chain_count+0x20/0x20
[   80.735702]  ? io_write+0xe90/0xe90
[   80.736167]  ? lock_is_held_type+0x98/0x110
[   80.736797]  ? find_held_lock+0x2c/0x110
[   80.737363]  ? lock_release+0x1dd/0x6b0
[   80.737897]  ? __fget_files+0x21c/0x3e0
[   80.738445]  ? lock_downgrade+0x6d0/0x6d0
[   80.738993]  ? lock_release+0x1dd/0x6b0
[   80.739507]  __io_queue_sqe+0x1ac/0xe50
[   80.740017]  ? io_issue_sqe+0x6a80/0x6a80
[   80.740564]  ? lock_is_held_type+0x98/0x110
[   80.741142]  io_submit_sqes+0x3f6e/0x76a0
[   80.741688]  ? xa_load+0x158/0x290
[   80.742173]  ? __do_sys_io_uring_enter+0x90c/0x1a20
[   80.742817]  __do_sys_io_uring_enter+0x90c/0x1a20
[   80.743436]  ? vm_mmap_pgoff+0xe8/0x280
[   80.743981]  ? io_submit_sqes+0x76a0/0x76a0
[   80.744539]  ? randomize_stack_top+0x100/0x100
[   80.745228]  ? __do_sys_futex+0xf2/0x3d0
[   80.745763]  ? __do_sys_futex+0xfb/0x3d0
[   80.746339]  ? __restore_fpregs_from_fpstate+0xa0/0xe0
[   80.747183]  ? trace_event_raw_event_x86_fpu+0x3a0/0x3a0
[   80.747960]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
[   80.748672]  ? syscall_enter_from_user_mode+0x1d/0x50
[   80.749422]  do_syscall_64+0x3b/0x90
[   80.750030]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   80.750880] RIP: 0033:0x466609
[   80.751402] Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89
01 48
[   80.754298] RSP: 002b:00007f22e8d3a188 EFLAGS: 00000246 ORIG_RAX:
00000000000001aa
[   80.755441] RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 0000000000466609
[   80.756510] RDX: 0000000000000000 RSI: 00000000000058ab RDI: 0000000000000003
[   80.757492] RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
[   80.758474] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
[   80.759487] R13: 00007ffca119d4ef R14: 00007f22e8d3a300 R15: 0000000000022000
[   80.760646]
[   80.760908] The buggy address belongs to the page:
[   80.761689] page:000000005ec48a9f refcount:0 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x246ff
[   80.763184] flags: 0x100000000000000(node=0|zone=1)
[   80.763966] raw: 0100000000000000 0000000000000000 ffffea000091bfc8
0000000000000000
[   80.765064] raw: 0000000000000000 0000000000000000 00000000ffffffff
0000000000000000
[   80.766127] page dumped because: kasan: bad access detected
[   80.767038]
[   80.767302] addr ffff8880246ff8b8 is located in stack of task
syz-executor.10/7001 at offset 152 in frame:
[   80.768587]  io_write+0x0/0xe90
[   80.769039]
[   80.769283] this frame has 3 objects:
[   80.769776]  [48, 56) 'iovec'
[   80.769785]  [80, 120) '__iter'
[   80.770195]  [160, 288) 'inline_vecs'
[   80.770642]
[   80.771323] Memory state around the buggy address:
[   80.771975]  ffff8880246ff780: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   80.772970]  ffff8880246ff800: 00 00 00 00 f1 f1 f1 f1 00 00 00 f2
f2 f2 00 00
[   80.774020] >ffff8880246ff880: 00 00 00 f2 f2 f2 f2 f2 00 00 00 00
00 00 00 00
[   80.775119]                                         ^
[   80.775963]  ffff8880246ff900: 00 00 00 00 00 00 00 00 f3 f3 f3 f3
00 00 00 00
[   80.777154]  ffff8880246ff980: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00

Lots of "truncated wr: 61440" and others.
[   82.690641] truncated wr: 36864
[   82.692929] truncated wr: 4096
[   82.695404] truncated wr: 61440
[   82.697840] truncated wr: 45056
[   82.700011] truncated wr: 61440
[   82.702401] truncated wr: 28672
[   82.704855] truncated wr: 12288
[   82.707070] truncated wr: 12288
[   82.709388] truncated wr: 36864
[   82.711758] truncated wr: 36864
[   82.713977] truncated wr: 28672
[   82.716176] truncated wr: 28672
and lots more.

-- 
Regards
Sudip
