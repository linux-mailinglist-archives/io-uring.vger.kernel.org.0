Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604F528006C
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbgJANrx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 09:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732018AbgJANrw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 09:47:52 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6392EC0613D0
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 06:47:51 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id g96so5402813otb.12
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 06:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=luzrohihsebckLnZy+IdRfpxBmKdKnt57hLt2DXtzO4=;
        b=NIPBEV5e7tHONbv6NqS6BeLsrRTyKLpbxr1XQlNmtGl01k8rFH0rsk2yo7FutmZ2Mh
         IJpu7PBPaa6oTb0jCPyNz57xmdOumlA4x/6nxkVerCfJjbQVkAY8hiYO0obRF358YPnF
         8x18vOxiHfhVwaKTxEcfwGuZVedpUr1hhysb0kmB00FW5kZwNIqTQd5E8pDq0pMP+xTC
         7G5My2oEBSGYeBm5Jq/SCqiZyVfz2uv1Kxeyd/ceTHdTc6gCjR44vsmHJJ41xGQSlq4f
         I89LdpzdxpuNdgkCWQh5FuaFFgBMMaHQPRC8pVAfPC45RUtFUMNg+Pp9IsQpo/+V/HF3
         PAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=luzrohihsebckLnZy+IdRfpxBmKdKnt57hLt2DXtzO4=;
        b=SKTzCDe7Y6EJTuzw3rwCHJeSUhRKN+TDgEeXfuiF+6DZiEjIPLV8YeD/85IxrMmEtr
         JAJoUW3EAaIx+3c7QfjcStBc5ym3fXM2fYYpLSWNlWyWwrRJ7Q9yDPGVjju8Qrd9tmwQ
         oI9skUF5Mum43aiGYiKWn7oWekSFdefBynQ/6rHgVW2GPrknPJ3m1uoP4IXKF58YV+vb
         5lTfztpEyeFlzw3dNAMKYBtghYksQ05pNkyjcB4ndrNJYjSDPV4+EAXQnBOh2vZM7N47
         H6GtnbIw3m3ogyqV3r5YGA5a5aqT0WgOzoIqkjl6ESEeOASpFOZhVYbHl6Vh6pBwR7JV
         iqAQ==
X-Gm-Message-State: AOAM533laIgcMBplcnWXnM2O3E/nNCXlfLYMhiIXbdA/1YJgTA7Aza1x
        RqKwaCsJfYZt+eZSZsaOp0yz4DncToH39pAJ2hlS7za8Fiw=
X-Google-Smtp-Source: ABdhPJzshuiWoD/T2FXIf+V5dBCV8qkc5wWvgCo/xxzOi8H1gSllZap0k7F7/srWI3cBYVAyHfghIYW9UHczsGDzyZ0=
X-Received: by 2002:a9d:621a:: with SMTP id g26mr5260892otj.209.1601560070650;
 Thu, 01 Oct 2020 06:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
 <20201001085900.ms5ix2zyoid7v3ra@steredhat>
In-Reply-To: <20201001085900.ms5ix2zyoid7v3ra@steredhat>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Thu, 1 Oct 2020 15:47:39 +0200
Message-ID: <CA+res+SW8GLrcK_fbZW09m7QDwMRgGGgaO3pY80iO2Lw5tHSDw@mail.gmail.com>
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Ju Hyung Park <qkrwngud825@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefano Garzarella <sgarzare@redhat.com> =E4=BA=8E2020=E5=B9=B410=E6=9C=881=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=8810:59=E5=86=99=E9=81=93=EF=BC=
=9A
>
> +Cc: qemu-devel@nongnu.org
>
> Hi,
>
> On Thu, Oct 01, 2020 at 01:26:51AM +0900, Ju Hyung Park wrote:
> > Hi everyone.
> >
> > I have recently switched to a setup running QEMU 5.0(which supports
> > io_uring) for a Windows 10 guest on Linux v5.4.63.
> > The QEMU hosts /dev/nvme0n1p3 to the guest with virtio-blk with
> > discard/unmap enabled.
>
> Please, can you share the qemu command line that you are using?
> This can be useful for the analysis.
>
> Thanks,
> Stefano
>
> >
> > I've been having a weird issue where the system would randomly hang
> > whenever I turn on or shutdown the guest. The host will stay up for a
> > bit and then just hang. No response on SSH, etc. Even ping doesn't
> > work.
> >
> > It's been hard to even get a log to debug the issue, but I've been
> > able to get a show-backtrace-all-active-cpus sysrq dmesg on the most
> > recent encounter with the issue and it's showing some io_uring
> > functions.
> >
> > Since I've been encountering the issue ever since I switched to QEMU
> > 5.0, I suspect io_uring may be the culprit to the issue.
> >
> > While I'd love to try out the mainline kernel, it's currently not
> > feasible at the moment as I have to stay in linux-5.4.y. Backporting
> > mainline's io_uring also seems to be a non-trivial job.
> >
> > Any tips would be appreciated. I can build my own kernel and I'm
> > willing to try out (backported) patches.
> >
> > Thanks.
> >
> > [243683.539303] NMI backtrace for cpu 1
> > [243683.539303] CPU: 1 PID: 1527 Comm: qemu-system-x86 Tainted: P
> >   W  O      5.4.63+ #1
> > [243683.539303] Hardware name: System manufacturer System Product
> > Name/PRIME Z370-A, BIOS 2401 07/12/2019
> > [243683.539304] RIP: 0010:io_uring_flush+0x98/0x140
> > [243683.539304] Code: e4 74 70 48 8b 93 e8 02 00 00 48 8b 32 48 8b 4a
> > 08 48 89 4e 08 48 89 31 48 89 12 48 89 52 08 48 8b 72 f8 81 4a a8 00
> > 40 00 00 <48> 85 f6 74 15 4c 3b 62 c8 75 0f ba 01 00 00 00 bf 02 00 00
> > 00 e8
> > [243683.539304] RSP: 0018:ffff8881f20c3e28 EFLAGS: 00000006
> > [243683.539305] RAX: ffff888419cd94e0 RBX: ffff88842ba49800 RCX:
> > ffff888419cd94e0
> > [243683.539305] RDX: ffff888419cd94e0 RSI: ffff888419cd94d0 RDI:
> > ffff88842ba49af8
> > [243683.539306] RBP: ffff88842ba49af8 R08: 0000000000000001 R09:
> > ffff88840d17aaf8
> > [243683.539306] R10: 0000000000000001 R11: 00000000ffffffec R12:
> > ffff88843c68c080
> > [243683.539306] R13: ffff88842ba49ae8 R14: 0000000000000001 R15:
> > 0000000000000000
> > [243683.539307] FS:  0000000000000000(0000) GS:ffff88843ea80000(0000)
> > knlGS:0000000000000000
> > [243683.539307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [243683.539307] CR2: 00007f3234b31f90 CR3: 0000000002608001 CR4:
> > 00000000003726e0
> > [243683.539307] Call Trace:
> > [243683.539308]  ? filp_close+0x2a/0x60
> > [243683.539308]  ? put_files_struct.part.0+0x57/0xb0
> > [243683.539309]  ? do_exit+0x321/0xa70
> > [243683.539309]  ? do_group_exit+0x35/0x90
> > [243683.539309]  ? __x64_sys_exit_group+0xf/0x10
> > [243683.539309]  ? do_syscall_64+0x41/0x160
> > [243683.539309]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [243684.753272] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> > [243684.753278] rcu: 1-...0: (1 GPs behind)
> > idle=3Da5e/1/0x4000000000000000 softirq=3D7893711/7893712 fqs=3D2955
> > [243684.753280] (detected by 3, t=3D6002 jiffies, g=3D17109677, q=3D117=
817)
> > [243684.753282] Sending NMI from CPU 3 to CPUs 1:
> > [243684.754285] NMI backtrace for cpu 1
> > [243684.754285] CPU: 1 PID: 1527 Comm: qemu-system-x86 Tainted: P
> >   W  O      5.4.63+ #1
> > [243684.754286] Hardware name: System manufacturer System Product
> > Name/PRIME Z370-A, BIOS 2401 07/12/2019
> > [243684.754286] RIP: 0010:io_uring_flush+0x83/0x140
> > [243684.754287] Code: 89 ef e8 00 36 92 00 48 8b 83 e8 02 00 00 49 39
> > c5 74 52 4d 85 e4 74 70 48 8b 93 e8 02 00 00 48 8b 32 48 8b 4a 08 48
> > 89 4e 08 <48> 89 31 48 89 12 48 89 52 08 48 8b 72 f8 81 4a a8 00 40 00
> > 00 48
> > [243684.754287] RSP: 0018:ffff8881f20c3e28 EFLAGS: 00000002
> > [243684.754288] RAX: ffff888419cd94e0 RBX: ffff88842ba49800 RCX:
> > ffff888419cd94e0
> > [243684.754288] RDX: ffff888419cd94e0 RSI: ffff888419cd94e0 RDI:
> > ffff88842ba49af8
> > [243684.754289] RBP: ffff88842ba49af8 R08: 0000000000000001 R09:
> > ffff88840d17aaf8
> > [243684.754289] R10: 0000000000000001 R11: 00000000ffffffec R12:
> > ffff88843c68c080
> > [243684.754289] R13: ffff88842ba49ae8 R14: 0000000000000001 R15:
> > 0000000000000000
> > [243684.754290] FS:  0000000000000000(0000) GS:ffff88843ea80000(0000)
> > knlGS:0000000000000000
> > [243684.754290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [243684.754291] CR2: 00007f3234b31f90 CR3: 0000000002608001 CR4:
> > 00000000003726e0
> > [243684.754291] Call Trace:
> > [243684.754291]  ? filp_close+0x2a/0x60
> > [243684.754291]  ? put_files_struct.part.0+0x57/0xb0
> > [243684.754292]  ? do_exit+0x321/0xa70
> > [243684.754292]  ? do_group_exit+0x35/0x90
> > [243684.754292]  ? __x64_sys_exit_group+0xf/0x10
> > [243684.754293]  ? do_syscall_64+0x41/0x160
> > [243684.754293]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
>
>
I got something similar
[250145.410520] general protection fault: 0000 [#1] SMP

[250145.410868] CPU: 5 PID: 39269 Comm: qemu-5.0 Kdump: loaded
Tainted: G           O      5.4.61-pserver
#5.4.61-1+develop20200831.1341+7430880~deb10

[250145.411468] Hardware name: Supermicro Super Server/X11DDW-L, BIOS
3.3 02/21/2020

[250145.412051] RIP: 0010:io_cancel_async_work+0x48/0xa0

[250145.412386] Code: fb 48 8d bf f8 02 00 00 48 89 f5 e8 02 f1 69 00
48 8b 83 e8 02 00 00 49 39 c4 74 52 48 8b 83 e8 02 00 00 48 8b 08 48
8b 50 08 <48> 89 51 08 48 8

9 0a 48 8b 70 f8 48 89 00 48 89 40 08 81 48 a8 00

[250145.413239] RSP: 0018:ffffc2d34efb7cf8 EFLAGS: 00010083

[250145.413576] RAX: ffffec9879729a80 RBX: ffff9fa2740ac400 RCX:
06ffff8000000000

[250145.414153] RDX: ffff9fa2740ac6e8 RSI: ffffec9879729a40 RDI:
ffff9fa2740ac6f8

[250145.414729] RBP: ffff9fa1cf86c080 R08: ffff9fa199ccecf8 R09:
8000002f724b7067

[250145.415307] R10: ffffc2d34efb7b8c R11: 0000000000000003 R12:
ffff9fa2740ac6e8

[250145.415884] R13: 0000000000000000 R14: 000000000000000d R15:
ffff9fa1af48e068

[250145.416461] FS:  0000000000000000(0000) GS:ffff9fa280940000(0000)
knlGS:0000000000000000

[250145.417042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

[250145.417380] CR2: 00007f5f14188000 CR3: 0000002f0c408005 CR4:
00000000007626e0

[250145.417957] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000

[250145.418535] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

[250145.419112] PKRU: 55555554

[250145.419438] Call Trace:

[250145.419768]  io_uring_flush+0x34/0x50

[250145.420101]  filp_close+0x31/0x60

[250145.420432]  put_files_struct+0x6c/0xc0

[250145.420767]  do_exit+0x347/0xa50

[250145.421097]  do_group_exit+0x3a/0x90

[250145.421429]  get_signal+0x125/0x7d0

[250145.421761]  do_signal+0x36/0x640

[250145.422090]  ? do_send_sig_info+0x5c/0x90

[250145.422423]  ? recalc_sigpending+0x17/0x50

[250145.422757]  exit_to_usermode_loop+0x61/0xd0

[250145.423090]  do_syscall_64+0xe6/0x120

[250145.423424]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[250145.423761] RIP: 0033:0x7f5f176997bb
