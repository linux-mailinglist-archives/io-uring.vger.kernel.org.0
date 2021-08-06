Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47BA3E2720
	for <lists+io-uring@lfdr.de>; Fri,  6 Aug 2021 11:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244189AbhHFJUp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Aug 2021 05:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243821AbhHFJUp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Aug 2021 05:20:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127EAC061798;
        Fri,  6 Aug 2021 02:20:29 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so5627128wmb.5;
        Fri, 06 Aug 2021 02:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pJx4c22vzulLGk7XpW77URZC+Og5hXOVuEDFstozkGE=;
        b=FnLyBXjQN7A0SC5OHxEVGGxeuKUZooVp5kpgf7sRznA4h5CAzw5u06+zoLYwCbqIV4
         fl7t3kXSRQJB58o1SlvSlazOwyQO86sMBrsG8vnoQcK/5AhJt/UW1Y7VF3pGFSIN6j1D
         LFNSQyjX+17OF4Mtx+DoOjQYmrud03nc+QS3r5Yz7gd8CqXWCQpQ/BUiUORHfrxYoSKx
         KN3gQoJjEaF2N7v1QtvAojFkzWhpFptdA6U98UUxe/BJhdN9JnleAkDnghMXvPMs48Tf
         sLRMJWcJbXuZZ/T1PIpu3kP4IrFVpZLvZHj/EqRHAFJhA/r9imLOf8nS6qMzNbfQ/UzM
         gysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pJx4c22vzulLGk7XpW77URZC+Og5hXOVuEDFstozkGE=;
        b=qwRXxfUtSQz87a5CHL/T/NX9Tjrmtal3B/i/K3EzWc/N3WfcRj9SkA6OSfvonlw50w
         VeKuIH3XUQDdh7Hj3TPZ9NmSYCMxZIJWu5tm/z96ZEiEjyio2DGleGxmnPTRFRzE1A6H
         M0ioBSG0tq6xjGqrInH5hc8hTbaW6aPFrQPdlqsLwEG4hZYynGPW2fPDdYNRnMMjTo+p
         05YA2+LFcjJjZCLTMkR6PzteGujs2KupT72ZlaAgDf2Dd3ZgNaluB4J36QCrWEwvxqkJ
         QXUlKyI6z6O2pNl6hdOtikmMXdto0HQCOrpdboeOM5Kp48230APx5lDmF35K2WFGvE9E
         I/Fw==
X-Gm-Message-State: AOAM533LOdfn268wE/aVKcyrUFO/wYrOZGvvAeQnleC2i/MOuo6OwZxS
        4bVAPqXO5zu+v22o1wEI3Qg=
X-Google-Smtp-Source: ABdhPJzCwU+kQ5r0C9kkmeQCfddnAjfCo7Z4uF5x3hs6XhLytxZGP8tqA+hddNFhLFPU2TquIelplg==
X-Received: by 2002:a05:600c:ac4:: with SMTP id c4mr19137702wmr.10.1628241627719;
        Fri, 06 Aug 2021 02:20:27 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.205])
        by smtp.gmail.com with ESMTPSA id u11sm8723888wrp.26.2021.08.06.02.20.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 02:20:27 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_ring_exit_work
To:     syzbot <syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com>,
        axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000cccfe405c8de9d1c@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <83e78e3f-2645-0c84-0255-da88e1b48466@gmail.com>
Date:   Fri, 6 Aug 2021 10:20:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000cccfe405c8de9d1c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/21 8:02 AM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    8d4b477da1a8 Add linux-next specific files for 20210730
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1478e4fa300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4adf4987f875c210
> dashboard link: https://syzkaller.appspot.com/bug?extid=00e15cda746c5bc70e24
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d5cd96300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1798471e300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com

#syz test: git://git.kernel.dk/linux-block io_uring-5.14


> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1182 at fs/io_uring.c:8802 io_ring_exit_work+0x24e/0x1600 fs/io_uring.c:8802
> Modules linked in:
> CPU: 1 PID: 1182 Comm: kworker/u4:5 Not tainted 5.14.0-rc3-next-20210730-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound io_ring_exit_work
> RIP: 0010:io_ring_exit_work+0x24e/0x1600 fs/io_uring.c:8802
> Code: 30 11 00 00 48 8b 05 c1 dc 80 09 31 ff 48 8b 2c 24 48 29 c5 48 89 ee e8 c0 a8 95 ff 48 85 ed 0f 89 a8 fe ff ff e8 52 a3 95 ff <0f> 0b e9 9c fe ff ff e8 46 a3 95 ff 48 c7 c2 c0 25 2a 90 48 c7 c6
> RSP: 0018:ffffc90004ed7b98 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffff88801c921c80 RSI: ffffffff81e014de RDI: 0000000000000003
> RBP: ffffffffffffffff R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff81e014d0 R11: 0000000000000000 R12: fffffbfff16c1e30
> R13: ffffed100e3f4894 R14: ffff888071fa4920 R15: ffff888071fa4000
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000488 CR3: 00000001c82cf000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 

-- 
Pavel Begunkov
