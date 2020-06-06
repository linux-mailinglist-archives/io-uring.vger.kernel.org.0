Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649191F03F6
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 02:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgFFAdo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 20:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgFFAdo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 20:33:44 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3515C08C5C2;
        Fri,  5 Jun 2020 17:33:43 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so11358153ilm.7;
        Fri, 05 Jun 2020 17:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=GbaJPOMo1RrAO9jKM9OGNFoQlN84uQHSW0gWmlEU0oA=;
        b=rWfE7BGtd7rhiIW/h2j1hSMlcKE74swIralomMs82lwNT7LwV+iSXHsBNfnRI7Brcf
         3Ef8320vTRVJKe+68lS5HEL2tkr3T2RDLhwl9sQRJ2fqs1nc9OeDI2lPqP3OAoMX8w48
         Cp2Nhqyj7uWeKtyrD2sqbU3fGzb49NvuRQSKT8wOBb8Jm5yiUJSzDQX1hqwOM0zdDNWd
         JjRRG8iZwmwXCDu+/nKvuNVWfPF03YkNz5XJcv+OpnW1bRsogmLYFN1KGjoZr5jfEUpG
         OyML0c6S5hiZe1WdeybCV1An5lqaRkaO959MCOBe80uRcOhDWHOzX/ZOUlMTG+4fDvn6
         8z4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=GbaJPOMo1RrAO9jKM9OGNFoQlN84uQHSW0gWmlEU0oA=;
        b=YzKSvtDz0wDv5kDldAKoVLY2IvXcwi0gn/N6rZwi1QNWsnIGa5oSuuvGhw0Yzo2NyK
         ftq1J9srl4rTog3+nY0aE/VqnI/bnv3aXuQnDV4dSvuP43HQ0BB+dtH9Aa4PcAcyNw3R
         27eVtMf+oKl1vX6jeZV24Ju3+LC8aRAu8HH+ylWn3gI57DXJuXHd4r7qDTwpLvh8gwfe
         /kqrX864tP6wZOWufmI9ZDAqi7oMjj9wPDVwGjh6IoT5r6pxkv54h8Pu36kERqcs7B/4
         E/612CgSyLpbzMomKji/1D9EK/jtWxx8Aj6P1jFOQcZdQYqjtOZBg58KJZAPctnWDGMM
         sgoQ==
X-Gm-Message-State: AOAM532dVXmbttIzqxIXJCo4D99nbTHAzUoTe3zFoeWHcA4RWNc+zvHu
        gNx22hxZg9Rfq2DySPneMZGt506/n9o8kV/gdwPScPdo1nE=
X-Google-Smtp-Source: ABdhPJwSkejgq81mWGhpwUserHqK8jkNCW5IUSREjAuRuZivEJblsWk2oiopescg1zSWuUAtz7ON08mxpWPZNlOXTes=
X-Received: by 2002:a92:7311:: with SMTP id o17mr11535458ilc.176.1591403622819;
 Fri, 05 Jun 2020 17:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk> <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
 <20200605202028.d57nklzpeolukni7@alap3.anarazel.de> <20200605203613.ogfilu2edcsfpme4@alap3.anarazel.de>
 <75bfe993-008d-71ce-7637-369f130bd984@kernel.dk> <3539a454-5321-0bdc-b59c-06f60cc64b56@kernel.dk>
 <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
In-Reply-To: <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 6 Jun 2020 02:33:31 +0200
Message-ID: <CA+icZUX=sFOO7q=NYgPaXjQFeJOucFO4H335D+LhG3SgOupGEQ@mail.gmail.com>
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jun 5, 2020 at 11:24 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/5/20 3:13 PM, Jens Axboe wrote:
> > On 6/5/20 2:53 PM, Jens Axboe wrote:
> >> On 6/5/20 2:36 PM, Andres Freund wrote:
> >>> Hi,
> >>>
> >>> On 2020-06-05 13:20:28 -0700, Andres Freund wrote:
> >>>> I'll go and try to figure out why I don't see an oops...
> >>>
> >>> Err, that probably was a typo on my end in the serial console
> >>> config. After fixing that, I did get the below.
> >>>
> >>> If helpful I can try with debugging enabled or such.
> >>>
> >>> [   67.910265] tee (2577): drop_caches: 3
> >>> [   68.059674] BUG: unable to handle page fault for address: 00007f0b=
16a3c03c
> >>> [   68.062021] #PF: supervisor read access in kernel mode
> >>> [   68.063742] #PF: error_code(0x0000) - not-present page
> >>> [   68.065517] PGD 102e044067 P4D 102e044067 PUD 102bf7a067 PMD 0
> >>> [   68.067519] Oops: 0000 [#1] SMP NOPTI
> >>> [   68.068800] CPU: 2 PID: 2554 Comm: postgres Not tainted 5.7.0-andr=
es-10123-g87823242260e #44
> >>> [   68.071505] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BI=
OS 1.13.0-1 04/01/2014
> >>> [   68.074139] RIP: 0010:__mutex_lock.isra.0+0x76/0x4e0
> >>> [   68.075389] Code: b7 01 00 00 48 39 c6 0f 84 a4 03 00 00 65 48 8b =
04 25 80 7d 01 00 48 8b 00 a8 08 75 18 49 8b 06 48 83 e0 f8 0f 84 2f 02 00 =
00 <8b> 50 3c 85 d2 0f 85 12 02 00 00 65 48 8b 04 25 80 7d 01 00 48 8b
> >>> [   68.079125] RSP: 0018:ffffc90000befd50 EFLAGS: 00010206
> >>> [   68.080260] RAX: 00007f0b16a3c000 RBX: ffff889037617910 RCX: 00000=
00000000000
> >>> [   68.084115] RDX: 00007f0b16a3c000 RSI: ffff88902a4aca80 RDI: ffff8=
890376178c0
> >>> [   68.085374] RBP: ffffc90000befdf0 R08: 0000000000000001 R09: 00000=
00000000000
> >>> [   68.086409] R10: ffff889037617920 R11: ffff88903f8abaf0 R12: ffffc=
90000befe08
> >>> [   68.087447] R13: 0000000000000000 R14: ffff8890376178c0 R15: 00000=
00000000000
> >>> [   68.088697] FS:  00007f0b97743740(0000) GS:ffff88903f880000(0000) =
knlGS:0000000000000000
> >>> [   68.089903] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [   68.090776] CR2: 00007f0b16a3c03c CR3: 000000102cf7c004 CR4: 00000=
00000760ee0
> >>> [   68.091834] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> >>> [   68.092902] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> >>> [   68.093967] PKRU: 55555554
> >>> [   68.094427] Call Trace:
> >>> [   68.094845]  ? __schedule+0x2ac/0x720
> >>> [   68.095350]  ? schedule+0x55/0xc0
> >>> [   68.095797]  ? ep_read_events_proc+0xd0/0xd0
> >>> [   68.096354]  ep_scan_ready_list.constprop.0+0x16c/0x190
> >>> [   68.097016]  ep_poll+0x2a3/0x440
> >>> [   68.097449]  ? wait_woken+0x70/0x70
> >>> [   68.097904]  do_epoll_wait+0xb0/0xd0
> >>> [   68.098375]  __x64_sys_epoll_wait+0x1a/0x20
> >>> [   68.098913]  do_syscall_64+0x48/0x130
> >>> [   68.099393]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>> [   68.100030] RIP: 0033:0x7f0b97845606
> >>> [   68.100498] Code: 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f =
1f 44 00 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 e8 00 00 00 0f =
05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 18 48 89 74 24
> >>> [   68.102718] RSP: 002b:00007ffe80ffdba8 EFLAGS: 00000246 ORIG_RAX: =
00000000000000e8
> >>> [   68.103644] RAX: ffffffffffffffda RBX: 000055fb76a9a998 RCX: 00007=
f0b97845606
> >>> [   68.104533] RDX: 0000000000000001 RSI: 000055fb76a9aa10 RDI: 00000=
00000000005
> >>> [   68.105418] RBP: 0000000005000007 R08: 0000000005000007 R09: 00000=
00000000003
> >>> [   68.106296] R10: 00000000ffffffff R11: 0000000000000246 R12: 00005=
5fb76a9a998
> >>> [   68.107187] R13: 0000000000000001 R14: 0000000000000009 R15: 00005=
5fb76a9a998
> >>> [   68.108104] Modules linked in: 9pnet_virtio isst_if_common xhci_pc=
i 9pnet iTCO_wdt intel_pmc_bxt xhci_hcd iTCO_vendor_support
> >>> [   68.109505] CR2: 00007f0b16a3c03c
> >>> [   68.109962] ---[ end trace 0ca39a5ed99162ce ]---
> >>> [   68.110547] RIP: 0010:__mutex_lock.isra.0+0x76/0x4e0
> >>> [   68.111214] Code: b7 01 00 00 48 39 c6 0f 84 a4 03 00 00 65 48 8b =
04 25 80 7d 01 00 48 8b 00 a8 08 75 18 49 8b 06 48 83 e0 f8 0f 84 2f 02 00 =
00 <8b> 50 3c 85 d2 0f 85 12 02 00 00 65 48 8b 04 25 80 7d 01 00 48 8b
> >>> [   68.113435] RSP: 0018:ffffc90000befd50 EFLAGS: 00010206
> >>> [   68.114111] RAX: 00007f0b16a3c000 RBX: ffff889037617910 RCX: 00000=
00000000000
> >>> [   68.115016] RDX: 00007f0b16a3c000 RSI: ffff88902a4aca80 RDI: ffff8=
890376178c0
> >>> [   68.115902] RBP: ffffc90000befdf0 R08: 0000000000000001 R09: 00000=
00000000000
> >>> [   68.116810] R10: ffff889037617920 R11: ffff88903f8abaf0 R12: ffffc=
90000befe08
> >>> [   68.117663] R13: 0000000000000000 R14: ffff8890376178c0 R15: 00000=
00000000000
> >>> [   68.118520] FS:  00007f0b97743740(0000) GS:ffff88903f880000(0000) =
knlGS:0000000000000000
> >>> [   68.119482] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [   68.120181] CR2: 00007f0b16a3c03c CR3: 000000102cf7c004 CR4: 00000=
00000760ee0
> >>> [   68.121043] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> >>> [   68.121904] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> >>> [   68.122790] PKRU: 55555554
> >>> [   68.123401] general protection fault, probably for non-canonical a=
ddress 0xfeeda989fef06266: 0000 [#2] SMP NOPTI
> >>> [   68.125052] CPU: 2 PID: 2554 Comm: postgres Tainted: G      D     =
      5.7.0-andres-10123-g87823242260e #44
> >>> [   68.126260] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BI=
OS 1.13.0-1 04/01/2014
> >>> [   68.127274] RIP: 0010:__pv_queued_spin_lock_slowpath+0x1a1/0x2b0
> >>> [   68.128032] Code: c4 c1 ea 12 41 be 01 00 00 00 8d 42 ff 41 83 e4 =
03 4c 8d 6b 14 49 c1 e4 05 48 98 49 81 c4 00 c7 02 00 4c 03 24 c5 e0 e6 fd =
82 <49> 89 1c 24 b8 00 80 00 00 eb 15 84 c0 75 0a 41 0f b6 54 24 14 84
> >>> [   68.130221] RSP: 0018:ffffc90000befce8 EFLAGS: 00010086
> >>> [   68.130867] RAX: 0000000000003ffe RBX: ffff88903f8ac700 RCX: 00000=
00000000001
> >>> [   68.131752] RDX: 0000000000003fff RSI: 0000000000000000 RDI: 00000=
00000000000
> >>> [   68.132637] RBP: ffff889037617924 R08: 0000000000000000 R09: ffffc=
90000befdf8
> >>> [   68.133513] R10: ffff8890334d2bf0 R11: 0000000000000018 R12: feeda=
989fef06266
> >>> [   68.134399] R13: ffff88903f8ac714 R14: 0000000000000001 R15: 00000=
000000c0000
> >>> [   68.135323] FS:  00007f0b97743740(0000) GS:ffff88903f880000(0000) =
knlGS:0000000000000000
> >>> [   68.136307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [   68.137004] CR2: 00007f0b16a3c03c CR3: 000000000360a005 CR4: 00000=
00000760ee0
> >>> [   68.137866] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> >>> [   68.138748] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> >>> [   68.139606] PKRU: 55555554
> >>> [   68.139973] Call Trace:
> >>> [   68.140313]  queued_read_lock_slowpath+0x6c/0x70
> >>> [   68.140915]  _raw_read_lock_irqsave+0x26/0x30
> >>> [   68.141485]  ep_poll_callback+0x3e/0x2b0
> >>> [   68.142007]  ? set_next_entity+0xab/0x1f0
> >>> [   68.142541]  __wake_up_common+0x7a/0x140
> >>> [   68.143077]  __wake_up_common_lock+0x7c/0xc0
> >>> [   68.143651]  pipe_release+0x5b/0xd0
> >>> [   68.144150]  __fput+0xda/0x240
> >>> [   68.144574]  task_work_run+0x62/0x90
> >>> [   68.145046]  do_exit+0x35c/0xa70
> >>> [   68.145505]  ? do_epoll_wait+0xb0/0xd0
> >>> [   68.146000]  rewind_stack_do_exit+0x17/0x20
> >>> [   68.146538] RIP: 0033:0x7f0b97845606
> >>> [   68.146988] Code: Bad RIP value.
> >>> [   68.147405] RSP: 002b:00007ffe80ffdba8 EFLAGS: 00000246 ORIG_RAX: =
00000000000000e8
> >>> [   68.148314] RAX: ffffffffffffffda RBX: 000055fb76a9a998 RCX: 00007=
f0b97845606
> >>> [   68.149157] RDX: 0000000000000001 RSI: 000055fb76a9aa10 RDI: 00000=
00000000005
> >>> [   68.150021] RBP: 0000000005000007 R08: 0000000005000007 R09: 00000=
00000000003
> >>> [   68.150831] R10: 00000000ffffffff R11: 0000000000000246 R12: 00005=
5fb76a9a998
> >>> [   68.151640] R13: 0000000000000001 R14: 0000000000000009 R15: 00005=
5fb76a9a998
> >>> [   68.152459] Modules linked in: 9pnet_virtio isst_if_common xhci_pc=
i 9pnet iTCO_wdt intel_pmc_bxt xhci_hcd iTCO_vendor_support
> >>> [   68.153707] ---[ end trace 0ca39a5ed99162cf ]---
> >>> [   68.154282] RIP: 0010:__mutex_lock.isra.0+0x76/0x4e0
> >>> [   68.154884] Code: b7 01 00 00 48 39 c6 0f 84 a4 03 00 00 65 48 8b =
04 25 80 7d 01 00 48 8b 00 a8 08 75 18 49 8b 06 48 83 e0 f8 0f 84 2f 02 00 =
00 <8b> 50 3c 85 d2 0f 85 12 02 00 00 65 48 8b 04 25 80 7d 01 00 48 8b
> >>> [   68.156976] RSP: 0018:ffffc90000befd50 EFLAGS: 00010206
> >>> [   68.157614] RAX: 00007f0b16a3c000 RBX: ffff889037617910 RCX: 00000=
00000000000
> >>> [   68.158436] RDX: 00007f0b16a3c000 RSI: ffff88902a4aca80 RDI: ffff8=
890376178c0
> >>> [   68.159269] RBP: ffffc90000befdf0 R08: 0000000000000001 R09: 00000=
00000000000
> >>> [   68.160092] R10: ffff889037617920 R11: ffff88903f8abaf0 R12: ffffc=
90000befe08
> >>> [   68.160920] R13: 0000000000000000 R14: ffff8890376178c0 R15: 00000=
00000000000
> >>> [   68.161746] FS:  00007f0b97743740(0000) GS:ffff88903f880000(0000) =
knlGS:0000000000000000
> >>> [   68.162701] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [   68.163386] CR2: 00007f0b978455dc CR3: 000000000360a005 CR4: 00000=
00000760ee0
> >>> [   68.164226] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> >>> [   68.165079] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> >>> [   68.165931] PKRU: 55555554
> >>> [   68.166298] Fixing recursive fault but reboot is needed!
> >>> [  128.173729] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> >>> [  128.179267] rcu:         11-...0: (1 GPs behind) idle=3Dc56/1/0x40=
00000000000000 softirq=3D6897/6898 fqs=3D5976
> >>> [  128.182232] rcu:         19-...0: (1 GPs behind) idle=3D492/1/0x40=
00000000000000 softirq=3D1023/1023 fqs=3D5976
> >>> [  128.185217]      (detected by 10, t=3D18003 jiffies, g=3D15789, q=
=3D631)
> >>> [  128.186863] Sending NMI from CPU 10 to CPUs 11:
> >>> [  128.188902] NMI backtrace for cpu 11
> >>> [  128.188903] CPU: 11 PID: 2546 Comm: postgres Tainted: G      D    =
       5.7.0-andres-10123-g87823242260e #44
> >>> [  128.188904] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BI=
OS 1.13.0-1 04/01/2014
> >>> [  128.188904] RIP: 0010:queued_read_lock_slowpath+0x5b/0x70
> >>> [  128.188906] Code: 03 00 02 00 00 8b 03 84 c0 74 08 f3 90 8b 13 84 =
d2 75 f8 48 89 ef e8 74 e6 ff ff 66 90 5b 5d c3 8b 07 84 c0 74 08 f3 90 8b =
03 <84> c0 75 f8 5b 5d c3 89 c6 48 89 ef e8 e4 e8 ff ff 66 90 eb bf 0f
> >>> [  128.188907] RSP: 0018:ffffc90000348c08 EFLAGS: 00000086
> >>> [  128.188908] RAX: 0000000037617cc0 RBX: ffff889037617920 RCX: 00000=
000000000c3
> >>> [  128.188909] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8=
89037617920
> >>> [  128.188910] RBP: ffff889037bb1a80 R08: 00000000000000c3 R09: ffffc=
90000348cd8
> >>> [  128.188910] R10: 0100000000000000 R11: 00000000de2ee17e R12: 00000=
00000000046
> >>> [  128.188911] R13: ffff889037617920 R14: 0000000000000001 R15: 00000=
000000000c3
> >>> [  128.188912] FS:  00007f0b97743740(0000) GS:ffff88903fac0000(0000) =
knlGS:0000000000000000
> >>> [  128.188912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [  128.188913] CR2: 00007f0b16afc00e CR3: 000000102e5c6002 CR4: 00000=
00000760ee0
> >>> [  128.188914] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> >>> [  128.188914] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> >>> [  128.188915] PKRU: 55555554
> >>> [  128.188915] Call Trace:
> >>> [  128.188916]  <IRQ>
> >>> [  128.188916]  _raw_read_lock_irqsave+0x26/0x30
> >>> [  128.188917]  ep_poll_callback+0x3e/0x2b0
> >>> [  128.188917]  ? cpumask_next_and+0x19/0x20
> >>> [  128.188918]  ? update_sd_lb_stats.constprop.0+0xfe/0x810
> >>> [  128.188918]  __wake_up_common+0x7a/0x140
> >>> [  128.188919]  __wake_up_common_lock+0x7c/0xc0
> >>> [  128.188919]  sock_def_readable+0x37/0x60
> >>> [  128.188920]  __udp_enqueue_schedule_skb+0x168/0x260
> >>> [  128.188920]  udpv6_queue_rcv_one_skb+0x284/0x3c0
> >>> [  128.188921]  udp6_unicast_rcv_skb.isra.0+0x44/0xa0
> >>> [  128.188921]  ip6_protocol_deliver_rcu+0x235/0x4b0
> >>> [  128.188922]  ip6_input_finish+0x11/0x20
> >>> [  128.188922]  ip6_input+0xa2/0xb0
> >>> [  128.188923]  ? ip6_protocol_deliver_rcu+0x4b0/0x4b0
> >>> [  128.188923]  ipv6_rcv+0xc0/0xd0
> >>> [  128.188924]  ? ip6_rcv_finish_core.isra.0+0xd0/0xd0
> >>> [  128.188924]  __netif_receive_skb_one_core+0x63/0xa0
> >>> [  128.188925]  process_backlog+0x98/0x140
> >>> [  128.188925]  net_rx_action+0x13a/0x370
> >>> [  128.188926]  __do_softirq+0xe0/0x2ca
> >>> [  128.188926]  do_softirq_own_stack+0x2a/0x40
> >>> [  128.188926]  </IRQ>
> >>> [  128.188927]  do_softirq.part.0+0x2b/0x30
> >>> [  128.188927]  __local_bh_enable_ip+0x4b/0x50
> >>> [  128.188928]  ip6_finish_output2+0x264/0x5b0
> >>> [  128.188928]  ip6_output+0x73/0x120
> >>> [  128.188929]  ? __ip6_finish_output+0x110/0x110
> >>> [  128.188929]  ip6_send_skb+0x1e/0x60
> >>> [  128.188930]  udp_v6_send_skb.isra.0+0x197/0x460
> >>> [  128.188930]  udpv6_sendmsg+0xb4f/0xdb0
> >>> [  128.188931]  ? ip_reply_glue_bits+0x40/0x40
> >>> [  128.188931]  ? update_load_avg+0x78/0x630
> >>> [  128.188932]  ? update_curr+0x73/0x1d0
> >>> [  128.188932]  ? __sys_sendto+0x108/0x190
> >>> [  128.188933]  __sys_sendto+0x108/0x190
> >>> [  128.188933]  ? __fput+0x1a5/0x240
> >>> [  128.188934]  ? _cond_resched+0x19/0x30
> >>> [  128.188934]  ? task_work_run+0x67/0x90
> >>> [  128.188935]  __x64_sys_sendto+0x25/0x30
> >>> [  128.188935]  do_syscall_64+0x48/0x130
> >>> [  128.188936]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>> [  128.188936] RIP: 0033:0x7f0b97a7826c
> >>> [  128.188945] Code: c0 ff ff ff ff eb b9 0f 1f 80 00 00 00 00 41 89 =
ca 64 8b 04 25 18 00 00 00 85 c0 75 19 45 31 c9 45 31 c0 b8 2c 00 00 00 0f =
05 <48> 3d 00 f0 ff ff 77 64 c3 0f 1f 00 55 48 83 ec 20 48 89 54 24 10
> >>> [  128.188946] RSP: 002b:00007ffe80ffcea8 EFLAGS: 00000246 ORIG_RAX: =
000000000000002c
> >>> [  128.188947] RAX: ffffffffffffffda RBX: 0000000000000058 RCX: 00007=
f0b97a7826c
> >>> [  128.188948] RDX: 0000000000000058 RSI: 000055fb765264c0 RDI: 00000=
00000000009
> >>> [  128.188949] RBP: 000055fb765264c0 R08: 0000000000000000 R09: 00000=
00000000000
> >>> [  128.188949] R10: 0000000000000000 R11: 0000000000000246 R12: 00007=
ffe80ffcfc0
> >>> [  128.188950] R13: 000000000002c600 R14: 0000000000000000 R15: 00005=
5fb7629b751
> >>> [  128.188957] Sending NMI from CPU 10 to CPUs 19:
> >>> [  128.239939] NMI backtrace for cpu 19
> >>> [  128.239940] CPU: 19 PID: 2587 Comm: postgres Tainted: G      D    =
       5.7.0-andres-10123-g87823242260e #44
> >>> [  128.239940] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BI=
OS 1.13.0-1 04/01/2014
> >>> [  128.239940] RIP: 0010:kvm_wait+0x30/0x50
> >>> [  128.239941] Code: 8b 05 ac cb f4 7e a9 00 00 f0 00 75 1f 9c 58 fa =
0f b6 17 40 38 d6 75 12 f6 c4 02 75 10 e9 07 00 00 00 0f 00 2d 6f ce 54 01 =
f4 <50> 9d c3 e9 07 00 00 00 0f 00 2d 5f ce 54 01 fb f4 eb ed 66 66 2e
> >>> [  128.239942] RSP: 0018:ffffc90000cc78e8 EFLAGS: 00000046
> >>> [  128.239942] RAX: 0000000000000046 RBX: ffff88903fcec700 RCX: 00000=
00000000008
> >>> [  128.239943] RDX: 0000000000000003 RSI: 0000000000000003 RDI: ffff8=
89039049d80
> >>> [  128.239943] RBP: ffff889039049d80 R08: ffff88907ffe9f80 R09: 00000=
000000000f8
> >>> [  128.239944] R10: 0000000000000000 R11: 0000000000000001 R12: 00000=
00000000000
> >>> [  128.239944] R13: 0000000000000001 R14: 0000000000000100 R15: 00000=
00000500000
> >>> [  128.239944] FS:  00007f0b97743740(0000) GS:ffff88903fcc0000(0000) =
knlGS:0000000000000000
> >>> [  128.239945] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [  128.239945] CR2: 000055fb76a96030 CR3: 0000001035882004 CR4: 00000=
00000760ee0
> >>> [  128.239945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> >>> [  128.239946] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> >>> [  128.239946] PKRU: 55555554
> >>> [  128.239946] Call Trace:
> >>> [  128.239946]  __pv_queued_spin_lock_slowpath+0x26e/0x2b0
> >>> [  128.239947]  _raw_spin_lock_irqsave+0x25/0x30
> >>> [  128.239947]  __wake_up_common_lock+0x62/0xc0
> >>> [  128.239947]  sock_def_write_space+0x49/0x90
> >>> [  128.239948]  sock_wfree+0x68/0xb0
> >>> [  128.239948]  loopback_xmit+0x49/0xe0
> >>> [  128.239948]  dev_hard_start_xmit+0x8d/0x1e0
> >>> [  128.239948]  __dev_queue_xmit+0x721/0x8e0
> >>> [  128.239949]  ip6_finish_output2+0x250/0x5b0
> >>> [  128.239949]  ip6_output+0x73/0x120
> >>> [  128.239949]  ? __ip6_finish_output+0x110/0x110
> >>> [  128.239950]  ip6_send_skb+0x1e/0x60
> >>> [  128.239950]  udp_v6_send_skb.isra.0+0x197/0x460
> >>> [  128.239950]  udpv6_sendmsg+0xb4f/0xdb0
> >>> [  128.239950]  ? release_pages+0x28f/0x2f0
> >>> [  128.239950]  ? ip_reply_glue_bits+0x40/0x40
> >>> [  128.239951]  ? _cond_resched+0x19/0x30
> >>> [  128.239951]  ? unmap_page_range+0x678/0xa60
> >>> [  128.239951]  ? __sys_sendto+0x108/0x190
> >>> [  128.239951]  __sys_sendto+0x108/0x190
> >>> [  128.239952]  ? __fput+0x1a5/0x240
> >>> [  128.239952]  ? _cond_resched+0x19/0x30
> >>> [  128.239952]  ? task_work_run+0x67/0x90
> >>> [  128.239952]  __x64_sys_sendto+0x25/0x30
> >>> [  128.239953]  do_syscall_64+0x48/0x130
> >>> [  128.239953]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>> [  128.239953] RIP: 0033:0x7f0b97a7826c
> >>> [  128.239954] Code: c0 ff ff ff ff eb b9 0f 1f 80 00 00 00 00 41 89 =
ca 64 8b 04 25 18 00 00 00 85 c0 75 19 45 31 c9 45 31 c0 b8 2c 00 00 00 0f =
05 <48> 3d 00 f0 ff ff 77 64 c3 0f 1f 00 55 48 83 ec 20 48 89 54 24 10
> >>> [  128.239954] RSP: 002b:00007ffe80ffd7b8 EFLAGS: 00000246 ORIG_RAX: =
000000000000002c
> >>> [  128.239955] RAX: ffffffffffffffda RBX: 00000000000003a8 RCX: 00007=
f0b97a7826c
> >>> [  128.239955] RDX: 00000000000003a8 RSI: 00007ffe80ffd800 RDI: 00000=
00000000009
> >>> [  128.239955] RBP: 00007ffe80ffd800 R08: 0000000000000000 R09: 00000=
00000000000
> >>> [  128.239956] R10: 0000000000000000 R11: 0000000000000246 R12: 00007=
ffe80ffd800
> >>> [  128.239956] R13: 00007ffe80ffd800 R14: 000000000000000e R15: 00005=
5fb76b37e58
> >>
> >> I can reproduce this, and I see what it is. I'll send out a patch soon=
ish.
> >
> > Thinko, can you try with this on top?
>
> Sorry that was incomplete, please use this one!
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d22830a423f1..0075107dd09a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2779,7 +2779,7 @@ static int io_read(struct io_kiocb *req, bool force=
_nonblock)
>                         ret =3D io_setup_async_rw(req, io_size, iovec,
>                                                 inline_vecs, &iter);
>                         if (ret)
> -                               goto out_free;
> +                               goto out;
>                         /* any defer here is final, must blocking retry *=
/
>                         if (!(req->flags & REQ_F_NOWAIT) &&
>                             !file_can_poll(req->file))
> @@ -2787,18 +2787,18 @@ static int io_read(struct io_kiocb *req, bool for=
ce_nonblock)
>                         /* if we can retry, do so with the callbacks arme=
d */
>                         if (io_rw_should_retry(req)) {
>                                 ret2 =3D io_iter_do_read(req, &iter);
> -                               if (ret2 !=3D -EAGAIN) {
> +                               if (ret2 =3D=3D -EIOCBQUEUED) {
> +                                       goto out;
> +                               } else if (ret2 !=3D -EAGAIN) {
>                                         kiocb_done(kiocb, ret2);
> -                                       goto out_free;
> +                                       goto out;
>                                 }
>                         }
>                         kiocb->ki_flags &=3D ~IOCB_WAITQ;
>                         return -EAGAIN;
>                 }
>         }
> -out_free:
> -       kfree(iovec);
> -       req->flags &=3D ~REQ_F_NEED_CLEANUP;
> +out:
>         return ret;
>  }
>
> --
> Jens Axboe
>

Hi Jens,

I have tested with today's linux-block.git#async-buffered.7 and my
usual testcases:

[ FIO ]

root# echo 1 > /sys/kernel/debug/tracing/events/io_uring/io_uring_create/en=
able

root# cat /sys/kernel/debug/tracing/events/io_uring/io_uring_create/enable
1

root# cat buf-test-dileks-min
[buf-test-dileks-min]
filename=3D/mnt/backup/thinkpad-t530/home/sdi/Downloads/iso-images/iso_debi=
an-stretch/firmware-stretch-live-amd64/debian-live-9.2.0-amd64-kde+nonfree.=
iso
buffered=3D1
ioengine=3Dio_uring

root# fio ./buf-test-dileks-min
buf-test-dileks-min: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W)
4096B-4096B, (T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D1
fio-3.20
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D87.1MiB/s][r=3D22.3k IOPS][eta 00m:00s]
buf-test-dileks-min: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4076: Sat Jun=
  6
02:22:20 2020
  read: IOPS=3D20.8k, BW=3D81.2MiB/s (85.1MB/s)(2811MiB/34626msec)
    slat (usec): min=3D2, max=3D395, avg=3D 8.95, stdev=3D18.43
    clat (nsec): min=3D130, max=3D159571k, avg=3D36797.18, stdev=3D520010.1=
5
     lat (usec): min=3D2, max=3D159779, avg=3D46.04, stdev=3D528.95
    clat percentiles (nsec):
     |  1.00th=3D[     225],  5.00th=3D[     302], 10.00th=3D[     330],
     | 20.00th=3D[     358], 30.00th=3D[     378], 40.00th=3D[     390],
     | 50.00th=3D[     406], 60.00th=3D[     418], 70.00th=3D[     430],
     | 80.00th=3D[     446], 90.00th=3D[     478], 95.00th=3D[     732],
     | 99.00th=3D[ 1531904], 99.50th=3D[ 1695744], 99.90th=3D[ 3555328],
     | 99.95th=3D[ 3686400], 99.99th=3D[16711680]
   bw (  KiB/s): min=3D34235, max=3D94554, per=3D100.00%, avg=3D83141.75,
stdev=3D11118.80, samples=3D69
   iops        : min=3D 8558, max=3D23638, avg=3D20785.14, stdev=3D2779.73,=
 samples=3D69
  lat (nsec)   : 250=3D1.63%, 500=3D89.57%, 750=3D3.94%, 1000=3D0.85%
  lat (usec)   : 2=3D1.55%, 4=3D0.21%, 10=3D0.03%, 20=3D0.01%, 50=3D0.02%
  lat (usec)   : 100=3D0.01%, 250=3D0.50%, 500=3D0.11%, 750=3D0.02%, 1000=
=3D0.01%
  lat (msec)   : 2=3D1.18%, 4=3D0.34%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%
  lat (msec)   : 100=3D0.01%, 250=3D0.01%
  cpu          : usr=3D9.80%, sys=3D17.79%, ctx=3D15869, majf=3D0, minf=3D1=
5
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D719568,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D81.2MiB/s (85.1MB/s), 81.2MiB/s-81.2MiB/s
(85.1MB/s-85.1MB/s), io=3D2811MiB (2947MB), run=3D34626-34626msec

Disk stats (read/write):
  sdc: ios=3D15784/53, merge=3D0/89, ticks=3D57005/536, in_queue=3D58011, u=
til=3D99.75%

root# fio --showcmd ./buf-test-dileks-min
fio --name=3Dbuf-test-dileks-min --buffered=3D1 --ioengine=3Dio_uring
--filename=3D/mnt/backup/thinkpad-t530/home/sdi/Downloads/iso-images/iso_de=
bian-stretch/firmware-stretch-live-amd64/debian-live-9.2.0-amd64-kde+nonfre=
e.iso

root# tail /sys/kernel/debug/tracing/trace
# entries-in-buffer/entries-written: 1/1   #P:4
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
             fio-4076  [001] ....   641.669846: io_uring_create: ring
00000000a88caba9, fd 5 sq size 1, cq size 2, flags 0


[ SYSTEMD-ANALYZE ]

user$ sudo systemd-analyze --no-pager time
Startup finished in 6.228s (kernel) + 41.559s (userspace) =3D 47.787s
graphical.target reached after 41.539s in userspace

user$ sudo systemd-analyze --no-pager blame
19.800s accounts-daemon.service
19.001s udisks2.service
13.282s NetworkManager-wait-online.service
 9.956s polkit.service
 9.590s avahi-daemon.service
 9.479s NetworkManager.service
 9.436s rtkit-daemon.service
 9.367s systemd-logind.service
 9.272s switcheroo-control.service
 9.257s wpa_supplicant.service
 9.215s dev-sdc2.device
 9.079s powertop.service
 8.875s smartmontools.service
 8.108s ModemManager.service
 7.070s zramswap.service
 5.443s networking.service
 5.181s rsyslog.service
 4.870s gpm.service
 3.846s e2scrub_reap.service
 3.718s systemd-fsck@dev-disk-by\x2duuid-cfd78a9b\x2dfadd\x2d4870\x2d88c2\x=
2d5277dae4e59f.service
 3.550s apparmor.service
 1.807s systemd-journal-flush.service
 1.570s systemd-tmpfiles-setup.service
 1.269s keyboard-setup.service
 1.259s atd.service
 1.207s systemd-udevd.service
 1.055s bluetooth.service
 1.052s binfmt-support.service
  935ms exim4.service
  901ms systemd-journald.service
  850ms systemd-modules-load.service
  843ms systemd-sysusers.service
  814ms upower.service
  807ms dev-hugepages.mount
  803ms pppd-dns.service
  790ms dev-mqueue.mount
  771ms sys-kernel-debug.mount
  770ms sys-kernel-tracing.mount
  697ms systemd-timesyncd.service
  677ms modprobe@drm.service
  630ms ifupdown-wait-online.service
  604ms systemd-rfkill.service
  561ms systemd-tmpfiles-setup-dev.service
  521ms systemd-remount-fs.service
  476ms systemd-sysctl.service
  397ms systemd-random-seed.service
  394ms systemd-backlight@backlight:intel_backlight.service
  376ms systemd-tmpfiles-clean.service
  289ms kmod-static-nodes.service
  269ms user@1000.service
  194ms console-setup.service
  182ms systemd-udev-trigger.service
  134ms systemd-update-utmp.service
  125ms proc-sys-fs-binfmt_misc.mount
   69ms systemd-user-sessions.service
   52ms alsa-restore.service
   21ms user-runtime-dir@1000.service
   17ms mnt-sandisk.mount
   13ms systemd-update-utmp-runlevel.service
    6ms sys-fs-fuse-connections.mount
    4ms ifupdown-pre.service

user$ sudo systemd-analyze --no-pager critical-chain
The time when unit became active or started is printed after the "@" charac=
ter.
The time the unit took to start is printed after the "+" character.

graphical.target @41.539s
=E2=94=94=E2=94=80multi-user.target @41.538s
  =E2=94=94=E2=94=80exim4.service @40.601s +935ms
    =E2=94=94=E2=94=80network-online.target @40.599s
      =E2=94=94=E2=94=80NetworkManager-wait-online.service @27.314s +13.282=
s
        =E2=94=94=E2=94=80NetworkManager.service @17.831s +9.479s
          =E2=94=94=E2=94=80dbus.service @17.824s
            =E2=94=94=E2=94=80basic.target @17.675s
              =E2=94=94=E2=94=80sockets.target @17.672s
                =E2=94=94=E2=94=80dbus.socket @17.670s
                  =E2=94=94=E2=94=80sysinit.target @17.584s
                    =E2=94=94=E2=94=80systemd-udev-trigger.service @26.747s=
 +182ms
                      =E2=94=94=E2=94=80systemd-udevd-kernel.socket @3.027s
                        =E2=94=94=E2=94=80system.slice @2.440s
                          =E2=94=94=E2=94=80-.slice @2.440s

Hope this helps you.

If you want some further informations and/or testing, please let me
know and give clear instructions.

Thanks.

Regards,
- Sedat -
