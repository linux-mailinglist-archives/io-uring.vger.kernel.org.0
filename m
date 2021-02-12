Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EB731A628
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhBLUnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhBLUnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 15:43:07 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFA0C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:42:26 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id z21so435106pgj.4
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fLX/+V+AQYJdK+lUaWUeFsPMKb9f4gHBbhNKR6ESJ0k=;
        b=LFugNM3dZrMLCGzscPoIB3sFD2Yr76+7xEt+nJaIBar8b2agi2mapTaZBcG8Ji5dWh
         RnAdv75mBqocdCFLcytDcO8kSlbT3NV/wxMolxAF+Pv2TE7MRMeB0WXTqZnpDPZTvbBO
         ShFExLzsO1r3p/8QV+AztX/Bsv+EAh5hNvSvkv+XFfxqYDLh4sakZqNfJzu6uFIyOacZ
         jPnonJ75MXdc4ClFKyIwGQRhqXI9f6TtyFg96YovENbdJEcYeFUaAFAJyM/LA8R1UFVv
         by3RsJUSAJTgwPurRDbZgA1m14ELgrYCKx2G3d36xmJvIzQVLQBtSmp9mCje5+eIHlZp
         zz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fLX/+V+AQYJdK+lUaWUeFsPMKb9f4gHBbhNKR6ESJ0k=;
        b=chAuwBV+QfoE7eQWZhrVMaOq+ZLow7pKWS8nFZka3LkS67kx0hEP0TGg8q32c5Tu0a
         tTcRSd6x3BwLy2RBxSf57LkAY+OuGNZn4wcP2qWy+s+bhFe7HgNNtmqWvhIY4glJKjFO
         mMvWZqHvGRCo89uMwExHazz1/LAowDCDBk3SYyxGdZSJLOpTK95NkZNb81mOlATxpEsJ
         D2o6dK8fbwYxsLfFSFLlvh9XPa9lvqdkZxvFaZxnqBvPajXJGNIstsss6fGMyxV1eUKi
         lJySDmD1rSMOlzkMrpttaCOPTZBNwVGZpXsnRKT/PNnJJQwNG5RQ8SeGpk7m4UxU7DSO
         Dfgw==
X-Gm-Message-State: AOAM530PTKNlDK3huIcXH9NOzO1R5EKegDs2WJ2wVRIE8vvUh92WL7wc
        v+0xa9os3kWKX7Tq+GsYNMG/UlqNMeIPTg==
X-Google-Smtp-Source: ABdhPJyI9iJglloMkzAIeRlC0KpSsr3n4dX2dA5A+CxDRg5dxiItJDYKveHipnBWuZSein/uMa94cg==
X-Received: by 2002:a63:7cf:: with SMTP id 198mr4876150pgh.448.1613162530805;
        Fri, 12 Feb 2021 12:42:10 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21e8::16bf? ([2620:10d:c090:400::5:2056])
        by smtp.gmail.com with ESMTPSA id e22sm8658955pjr.13.2021.02.12.12.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:42:10 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
 <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
 <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk>
 <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
 <0c813cc8-142e-15a4-de6a-ebdcf1f03b13@kernel.dk>
 <CAHk-=whB_gY_ex5CKXeVU28V-EajfRSWpAJ4aFQWrQBAC+Lc0w@mail.gmail.com>
 <bb978a7b-bf38-b03f-506a-c0a80f192cad@kernel.dk>
 <CAHk-=wgK+8CbxbHKxcJop2sq634mZYUhMeNXLUN6fGnrrKeXbg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5072a151-eed4-acaa-034c-27b4446707f1@kernel.dk>
Date:   Fri, 12 Feb 2021 13:42:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgK+8CbxbHKxcJop2sq634mZYUhMeNXLUN6fGnrrKeXbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/21 1:29 PM, Linus Torvalds wrote:
> On Fri, Feb 12, 2021 at 12:22 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>   My other idea was
>> to add a check in path resolution that catches it, for future safe
>> guards outside of send/recvmsg. That's obviously a separate change
>> from the comment, but would be nice to have.
> 
> I wonder how painful it would be to just make sure that kernel threads
> have a NULL ->fs and ->files by default.
> 
> But maybe the oops in a kernel thread ends up being too painful and
> harder to debug and deal with, and a special check is preferred just
> because a WARN_ON_ONCE() wouldn't cause any other downstream issues.

That's not a bad idea, and better than checking against init_fs etc
at runtime.

> Yes, some kernel threads do need to do pathname lookups (and io_uring
> isn't the only such thing), but I think they are generally fairly
> special cases (ie things like usermode helper, firmware loaders, etc).

Either that, or just do it for the io_uring workers and call it Good
Enough for now. The downside is that we'd crash if we did have an
issue like this, here's the example from before you pulled that revert
with explicit clearing of fs/files:

BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1351
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 29189, name: io_wqe_worker-0
CPU: 0 PID: 29189 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc7+ #9248
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 dump_stack+0x57/0x6a
 ___might_sleep.cold+0x87/0x94
 do_user_addr_fault+0x12b/0x470
 exc_page_fault+0x6d/0x150
 asm_exc_page_fault+0x1b/0x20
RIP: 0010:set_root+0x33/0xe0
Code: 41 55 41 54 65 48 8b 04 25 00 6d 01 00 53 4c 8b a0 58 07 00 00 8b 47 38 a9 00 00 18 00 0f 85 9e 00 00 00 a8 40 48 89 fb 74 50 <41> 8b 4c 24 08 f6 c1 01 75 42 49 8b 44 24 18 49 8b 54 24 20 48 89
RSP: 0018:ffffc9000074f8c0 EFLAGS: 00010202
RAX: 0000000000001041 RBX: ffffc9000074f970 RCX: ffffc9000074fa90
RDX: 0000000000000000 RSI: 0000000000000041 RDI: ffffc9000074f970
RBP: ffffc9000074f8d8 R08: 0000000000000000 R09: ffffc9000074fb28
R10: 0000000000000000 R11: ffff888100a0ae00 R12: 0000000000000000
R13: ffff888100bc5020 R14: 0000000000000040 R15: 0000000000000010
 nd_jump_root+0xc5/0x100
 path_init+0x2d7/0x400
 path_lookupat+0x1e/0x1c0
 filename_lookup+0xaa/0x170
 ? __kmalloc_node_track_caller+0x5a/0x2a0
 ? kmem_cache_alloc+0x3a/0x1e0
 ? getname_kernel+0x70/0xf0
 unix_find_other+0x47/0x2a0
 ? skb_copy_datagram_from_iter+0x61/0x1c0
 unix_dgram_sendmsg+0x550/0xa80
 sock_sendmsg+0x33/0x40
 ____sys_sendmsg+0x1f3/0x210
 __sys_sendmsg_sock+0x1d/0x30
 io_sendmsg+0x162/0x1e0
 ? free_unref_page_commit.constprop.0+0x85/0xf0
 ? unfreeze_partials+0x238/0x290
 io_issue_sqe+0x600/0x1110
 ? __io_free_req+0x6c/0xd0
 ? kmem_cache_free+0x26d/0x280
 io_wq_submit_work+0xa1/0x100
 ? io_assign_current_work+0x4e/0x70
 io_worker_handle_work+0x29f/0x4c0
 ? io_wqe_worker+0xad/0x3c0
 io_wqe_worker+0x30f/0x3c0
 ? io_worker_handle_work+0x4c0/0x4c0
 kthread+0x13b/0x160
 ? kthread_create_worker_on_cpu+0x70/0x70
 ret_from_fork+0x1f/0x30
BUG: kernel NULL pointer dereference, address: 0000000000000008

which clearly shows the path to misery. Not an easy call, because one
path is a potential security issue, the other is crashing with a NULL
pointer deref...

-- 
Jens Axboe

