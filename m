Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470C63C6C15
	for <lists+io-uring@lfdr.de>; Tue, 13 Jul 2021 10:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhGMIkW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jul 2021 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbhGMIkW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Jul 2021 04:40:22 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2D4C0613DD;
        Tue, 13 Jul 2021 01:37:32 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j34so13056563wms.5;
        Tue, 13 Jul 2021 01:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7BWSTbSfHlzUqKFrbnJ8tk31HL063x9YnmUKfK19P0I=;
        b=klVSxQJYTRxK4bT8R1GhFzFx4WfZkCKimGF1EiJnxUUJ1/mzA3IFrGYFXDbYR80x5s
         dXMPAwSiBkK4Vr+LJzymiwFpWYkseUm28thEtLG30gzKBIjYkwf5EFIDDepCdL3KRqVS
         OyGhZLFVE634Jz/7eajCd1EY++NoglIrFuNR5e44gdqVN0Mm6tt+YbuBI/RDEUmJoXT3
         He9vrNgUG821bR/B5lnbxyUNkH0OhdOZVdXCDLp+gVPBQZYAdVPy8udglMT4A6bnIFJH
         41XkgbiMDyY3HwSKKG6+0Z4R6qGAtIWPG4SohIQQCVVN54gSNRmxqqdPl3K17aFZB0Ox
         mh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7BWSTbSfHlzUqKFrbnJ8tk31HL063x9YnmUKfK19P0I=;
        b=KnmHC660hREjEenyjV9pZlAXJTP9E2eq2RvNncwMoxNzyfACOe/+4jrFXw8pAIEusQ
         1Nham0yumL5veREoFH+p9IjR5lhwcOpZMmYfEsp7INH4E6iRQ/M1Arj3N360+T3ipmN3
         N7TVOXFnJcty/1ZnCUkNDgpW4cBHht9gyJtFSb1z36fWbXVK4QbsEYa/mi5nOzg9C6ti
         qQjnDK4RCvPJkQOTZKYYNCrpuxvPadq4X7EjkYcmDCAcHQoSYG+s7D3gmLg47e05HZn2
         OGQ8Noo0C4XDW1qGOkBEExkiDA0f+QTYz9cDjUuFH+PBdiRCIFS7x0k99C0VSFiJP28t
         f+EQ==
X-Gm-Message-State: AOAM5305vpN9f8XUD/Nt5jLP68G0NvtZRWVxKZzdtqoa8TpGbrUQuMrJ
        +ftdgP+pdsPC0EY6ucFEaUs=
X-Google-Smtp-Source: ABdhPJyLbX8PtDYcqNHsDNPULXKR8edSGnSVZRDAJBtfdzOGWbqRNuTcq3Kzu1Xub0qgi86npLWvBw==
X-Received: by 2002:a1c:f613:: with SMTP id w19mr3635886wmc.141.1626165451362;
        Tue, 13 Jul 2021 01:37:31 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.178])
        by smtp.gmail.com with ESMTPSA id l18sm1718260wme.29.2021.07.13.01.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 01:37:30 -0700 (PDT)
Subject: Re: [syzbot] kernel BUG in io_queue_async_work
To:     syzbot <syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000e6deea05c6f706af@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d4edc90a-23bc-34b3-4490-03cce2846283@gmail.com>
Date:   Tue, 13 Jul 2021 09:37:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000e6deea05c6f706af@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/21 2:19 AM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    7fef2edf sd: don't mess with SD_MINORS for CONFIG_DEBUG_BL..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1575c9b0300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=957eaf08bd3bb8d6
> dashboard link: https://syzkaller.appspot.com/bug?extid=d50e4f20cfad4510ec22
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104c3949d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167cc06c300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com

#syz test: https://github.com/isilence/linux.git drain_fix_syztest

> 
> ------------[ cut here ]------------
> kernel BUG at fs/io_uring.c:1293!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8139 Comm: kworker/1:3 Tainted: G        W         5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events io_fallback_req_func
> RIP: 0010:io_queue_async_work+0x539/0x5f0 fs/io_uring.c:1293
> Code: 89 be 89 00 00 00 48 c7 c7 40 53 9a 89 c6 05 de 38 78 0b 01 e8 72 6b 08 07 e9 6e ff ff ff e8 ee 68 95 ff 0f 0b e8 e7 68 95 ff <0f> 0b e8 e0 68 95 ff 0f 0b e9 1a fd ff ff e8 34 0f db ff e9 47 fb
> RSP: 0018:ffffc9000c627ba8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88802d256000 RCX: 0000000000000000
> RDX: ffff888030f4e180 RSI: ffffffff81df55c9 RDI: ffff88802ef66a50
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000019
> R10: ffffffff81df517c R11: 000000000000000f R12: ffff8880441eb6c0
> R13: 0000000000000019 R14: ffff88802d2560b0 R15: ffff8880441eb718
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000049a01d CR3: 00000000396af000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __io_queue_sqe+0x913/0xf10 fs/io_uring.c:6448
>  io_req_task_submit+0x100/0x120 fs/io_uring.c:2020
>  io_fallback_req_func+0x81/0xb0 fs/io_uring.c:2441
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Modules linked in:
> ---[ end trace aa15edd5dcdbd7e3 ]---
> RIP: 0010:io_queue_async_work+0x539/0x5f0 fs/io_uring.c:1293
> Code: 89 be 89 00 00 00 48 c7 c7 40 53 9a 89 c6 05 de 38 78 0b 01 e8 72 6b 08 07 e9 6e ff ff ff e8 ee 68 95 ff 0f 0b e8 e7 68 95 ff <0f> 0b e8 e0 68 95 ff 0f 0b e9 1a fd ff ff e8 34 0f db ff e9 47 fb
> RSP: 0018:ffffc9000c627ba8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88802d256000 RCX: 0000000000000000
> RDX: ffff888030f4e180 RSI: ffffffff81df55c9 RDI: ffff88802ef66a50
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000019
> R10: ffffffff81df517c R11: 000000000000000f R12: ffff8880441eb6c0
> R13: 0000000000000019 R14: ffff88802d2560b0 R15: ffff8880441eb718
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000444 CR3: 0000000042660000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 

-- 
Pavel Begunkov
