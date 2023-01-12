Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E80667015
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbjALKpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239943AbjALKnx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:43:53 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40ADC58D32;
        Thu, 12 Jan 2023 02:39:23 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m3so12880556wmq.0;
        Thu, 12 Jan 2023 02:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nPsmbOgu4WiAkCHyIbTzazzxL3no0eAHTiA0UIQl9P8=;
        b=m2IL9Hgm4ZBBfcf+reu18/OmWsrCUPTdah+mJ+ZIBpMNhAq/cshlEnzGOXh3mNWpey
         IjKRPx2fEveKIe+lFIlK1ez+qmH9IlwlNlmcl9uJLEKlDZfbW+mWnDGyIWW3qc7qDQuL
         01aXP0lvWzY6kT3oRhh9dxpkMDP1aWidvoZxRLwpyFIja5qq5h2dsLYeupSeyM+N2BzE
         zSO4SC0h0T6zyyOvSPics0pz5mX2u1kczAH7IXJLAemsIpKWBp/e8aqTuTaYlnWyqCxQ
         PsjjktPmveCxLwMWKNqGbtjyNcGApZm5FJdih9r9/mFzfhj6QPZuvId8FZGrlFjkmxG9
         8Rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nPsmbOgu4WiAkCHyIbTzazzxL3no0eAHTiA0UIQl9P8=;
        b=iQNMLPWHo0K4x/INgfyRADMZha1zZWTkI9TFRhQHs/l+kLqLTGul1KoPyIN5K+GkGl
         y+Wa6/p8ywWkI9vFY8MDN67BY4xBMekSl6pNQE3sE5k/Q5r3JvP27tY+LmIK1wY/7i/T
         fJlaS6ZBbDaHvedLXO29EFh/rqH/UVxncfmKfigizxJ6h+6kq1zuTJrNMT4uWyY9zmLM
         T7PBPT7fDlnUez9pg72VePhCW/6J6mDEx/tgnsMRxQRol9ShtXmwvCMUoO9me1wJstd5
         3kzHp4rA80A9BSKCPdX57WZL3h85ZaS2dMSwScxArcfJuvcUW1j/Z8zlsuAyVGIcSpke
         lPQw==
X-Gm-Message-State: AFqh2koUtnpFrO/5DrHLmtQsnz1vOTXZdKM86GsD8k+K1JuX9vlg0LWZ
        NbBEOgSKIrY21R+41f8czIiz12w/3Ys=
X-Google-Smtp-Source: AMrXdXtf5S7BHeiwOcR7AMMbUkaf0zO1SRD7LxFTOdAvPGBRQWDp9xxSLHVe4psIZuZo9Y5Ipqxp9A==
X-Received: by 2002:a05:600c:4fc5:b0:3d9:ecae:84f2 with SMTP id o5-20020a05600c4fc500b003d9ecae84f2mr12667199wmq.25.1673519961499;
        Thu, 12 Jan 2023 02:39:21 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::21ef? ([2620:10d:c092:600::2:478])
        by smtp.gmail.com with ESMTPSA id p9-20020a05600c358900b003cffd3c3d6csm23404262wmq.12.2023.01.12.02.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 02:39:21 -0800 (PST)
Message-ID: <fc382b22-6fb2-c759-fbfd-88ed23b61bc1@gmail.com>
Date:   Thu, 12 Jan 2023 10:37:53 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING in io_cqring_event_overflow
Content-Language: en-US
To:     syzbot <syzbot+6805087452d72929404e@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000000bd60905f20e785a@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000000bd60905f20e785a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 10:20, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    358a161a6a9e Merge branch 'for-next/fixes' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=14247bbe480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2573056c6a11f00d
> dashboard link: https://syzkaller.appspot.com/bug?extid=6805087452d72929404e
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1045e181480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13769f1c480000

#syz test: git://git.kernel.dk/linux.git syztest

> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/99d14e0f4c19/disk-358a161a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/23275b612976/vmlinux-358a161a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ed79195fac61/Image-358a161a.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6805087452d72929404e@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Not tainted 6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c3b3e578 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c4d2c000 x18: 00000000000000c0
> x17: ffff80000df48158 x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 620806
> hardirqs last  enabled at (620805): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (620805): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (620806): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (620784): [<ffff80000b2f555c>] neigh_managed_work+0xf8/0x118 net/core/neighbour.c:1626
> softirqs last disabled at (620780): [<ffff80000b2f5498>] neigh_managed_work+0x34/0x118 net/core/neighbour.c:1621
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c4f2f678
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c4d2c000
>   x18: 00000000000003de
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 622216
> hardirqs last  enabled at (622215): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (622215): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (622216): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (621028): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (621028): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (621026): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (621026): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c4f2fb78 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c4d2f000 x18: 000000000000031e
> x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 623616
> hardirqs last  enabled at (623615): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (623615): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (623616): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (622446): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (622446): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (622444): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (622444): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c4404378
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c93ee000
>   x18: 00000000000002ce
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 624992
> hardirqs last  enabled at (624991): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (624991): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (624992): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (623820): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (623820): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (623818): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (623818): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c995f778
>   x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c93ef000 x18: 00000000000003d1
> x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 626290
> hardirqs last  enabled at (626289): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (626289): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (626290): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (625116): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (625116): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (625114): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (625114): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c995f878
>   x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c93ef000 x18: 000000000000011c
> x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 627616
> hardirqs last  enabled at (627615): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (627615): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (627616): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (626440): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (626440): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (626438): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (626438): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c4f2f278 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c4d2f000 x18: 00000000000000c7
> x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 629014
> hardirqs last  enabled at (629013): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (629013): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (629014): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (627834): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (627834): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (627832): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (627832): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c995fb78 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c93ee000 x18: 00000000000003c2
> x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 630328
> hardirqs last  enabled at (630327): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (630327): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (630328): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (629918): [<ffff8000080102e4>] _stext+0x2e4/0x37c
> softirqs last disabled at (629893): [<ffff800008017c90>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> 
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c0d47d78
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c93ee000
>   x18: 00000000000003fd
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 631624
> hardirqs last  enabled at (631623): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (631623): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (631624): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (630450): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (630450): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (630448): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (630448): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> 
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c4f2f978
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c93ee000
>   x18: 0000000000000106
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 633024
> hardirqs last  enabled at (633023): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (633023): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (633024): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (631846): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (631846): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (631844): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (631844): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> 
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c4404978
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c93ec000
>   x18: 0000000000000061
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 634358
> hardirqs last  enabled at (634357): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (634357): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (634358): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (633180): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (633180): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (633178): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (633178): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> 
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c9688978
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c93eb000
>   x18: 0000000000000398
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 635652
> hardirqs last  enabled at (635651): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (635651): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (635652): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (634476): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (634476): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (634474): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (634474): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c995f678 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c4d28000 x18: 000000000000012e
> x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 636950
> hardirqs last  enabled at (636949): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (636949): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (636950): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (635774): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (635774): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (635772): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (635772): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c4f2f178
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c4d28000
>   x18: ffff80001912b5f0
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 638316
> hardirqs last  enabled at (638315): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (638315): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (638316): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (637136): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (637136): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (637134): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (637134): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c995fc78 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c93ef000 x18: 000000000000017e
> x17: 0000000000000000 x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 639638
> hardirqs last  enabled at (639637): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (639637): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (639638): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (638456): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (638456): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (638454): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (638454): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c995f878
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c4d2c000
>   x18: 0000000000000380
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 641034
> hardirqs last  enabled at (641033): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (641033): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (641034): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (639852): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (639852): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (639850): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (639850): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c4404978 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c93ef000 x18: 0000000000000228
> x17: ffff0001feff7268 x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 642368
> hardirqs last  enabled at (642367): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (642367): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (642368): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (641192): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (641192): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (641190): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (641190): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c4f2f978
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c93ef000
>   x18: ffff800014643720
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 643668
> hardirqs last  enabled at (643667): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (643667): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (643668): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (642486): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (642486): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (642484): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (642484): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c649e878
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c4d28000 x18: 0000000000000065
> x17: 000000000000b67e
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000 x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000 x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 644976
> hardirqs last  enabled at (644975): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (644975): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (644976): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (643798): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (643798): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (643796): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (643796): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c995f078 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c4d2a000 x18: 00000000000003c7
> x17: 0000000000000000 x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 646330
> hardirqs last  enabled at (646329): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (646329): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (646330): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (645158): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (645158): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (645156): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (645156): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c4f2f278 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c4d2f000 x18: 00000000000002d7
> x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 647682
> hardirqs last  enabled at (647681): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (647681): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (647682): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (646506): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (646506): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (646504): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (646504): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0 x28: ffff0000c995fc78 x27: ffff80000d49b000
> x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
> x20: 0000000000000000 x19: ffff0000c93ec000 x18: 00000000000003e1
> x17: 0000000000000000 x16: ffff80000dd86118 x15: ffff0000c0cf8000
> x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
> x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
> x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 649060
> hardirqs last  enabled at (649059): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (649059): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (649060): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (647884): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (647884): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (647882): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (647882): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c9688278
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c4d28000
>   x18: 0000000000000291
> 
> x17: 0000000000000000
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 650446
> hardirqs last  enabled at (650445): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (650445): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (650446): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (649612): [<ffff8000080102e4>] _stext+0x2e4/0x37c
> softirqs last disabled at (649587): [<ffff800008017c90>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> 
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff80000f7dbad0
> x29: ffff80000f7dbad0
>   x28: ffff0000c995f678
>   x27: ffff80000d49b000
> 
> x26: 0000000000000000
>   x25: 0000000000000000
>   x24: 0000000000000000
> 
> x23: 0000000000000000
>   x22: 0000000000000000
>   x21: 0000000000000000
> 
> x20: 0000000000000000
>   x19: ffff0000c93ee000
>   x18: ffff80001912b5f0
> 
> x17: ffff80000c15d8bc
>   x16: ffff80000dd86118
>   x15: ffff0000c0cf8000
> 
> x14: 00000000000000b8
>   x13: 00000000ffffffff
>   x12: ffff0000c0cf8000
> 
> x11: ff80800009594dec
>   x10: 0000000000000000
>   x9 : ffff800009594dec
> 
> x8 : ffff0000c0cf8000
>   x7 : ffff80000c109860
>   x6 : 0000000000000000
> 
> x5 : 0000000000000000
>   x4 : 0000000000000000
>   x3 : 0000000000000000
> 
> x2 : 0000000000000000
>   x1 : 0000000000000000
>   x0 : 0000000000000000
> 
> Call trace:
>   io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>   io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>   io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>   io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>   io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>   io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>   io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>   process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>   worker_thread+0x340/0x610 kernel/workqueue.c:2436
>   kthread+0x12c/0x158 kernel/kthread.c:376
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 651724
> hardirqs last  enabled at (651723): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (651723): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (651724): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (650546): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
> softirqs last  enabled at (650546): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
> softirqs last disabled at (650544): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
> softirqs last disabled at (650544): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

-- 
Pavel Begunkov
