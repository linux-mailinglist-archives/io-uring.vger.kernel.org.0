Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673F427FC18
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 10:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgJAI7K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 04:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbgJAI7J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 04:59:09 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601542747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JwMSHGZnSNtQNCK68FP5CoWj75RnPhMMG/QFSbLLBQM=;
        b=H2vbshY9AaWG1X37apeXGtIsVNS9L6Nh5xBIvCLPN28ag/SCCuxar0YmZ6IehVA4S2KLlw
        0aRwBfWIVeFmuoQOXHDBL0CU8EcIYgGwHgGLoiZhw9dtDStr1p1pt+KN3YuPUItkgm/tVD
        r4i93Coug5ywK4PzavBDQXw4+hIUrxw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-jo_VUrjHMT66IxN00WMa2g-1; Thu, 01 Oct 2020 04:59:05 -0400
X-MC-Unique: jo_VUrjHMT66IxN00WMa2g-1
Received: by mail-wr1-f72.google.com with SMTP id y3so1771349wrl.21
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 01:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JwMSHGZnSNtQNCK68FP5CoWj75RnPhMMG/QFSbLLBQM=;
        b=H69v1u67AXihBzP3mW/FQQMBJXHfgdqcshpqKaOWfbTJZMNCWgPFsUuc5AJyiO3+Zs
         xjlIVADECkAa9O53DBJDHzFhWZcL7NFAQi+roTMNK2RWU8HYr1VFr66MHn3Yc96Ev43q
         75JMXuYIfle/jN7RBcu9wCwxV9XSCdp6UdIXe9qQHivOx2E1+Cu7iNGxaku49dB2Fbw2
         xhHwsK65Fx4r/TLs5AEBeHowSKlZYG1Bo5pVoZpJUX9VzRrNUsFA3KkcQtgNeC1gjEqd
         kRD1AFQKaMPUSiyht4fhf5EEvIW+h4CTcrve9X2CH+kn3FMbyo750jFkip3mxyxQE+a+
         WQag==
X-Gm-Message-State: AOAM532yQKiTP+d0GqJGpNxiG334pLc05iqo5wSJGJWa9sAmtCoJBrGZ
        m/JQlpUfsaOs2P0nFZMsqrvquQwU+A7Bh72DlM9KNouSHbHS/u22d8GMOWUmTOeiFtDnrXgNMmm
        tE/Q20D2Jj8FGIu7BBWU=
X-Received: by 2002:adf:aadb:: with SMTP id i27mr7569859wrc.258.1601542743975;
        Thu, 01 Oct 2020 01:59:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+JTPJeTK41KiqBd7vRDGwFs/s8llUIYK6tPTqJHnzW3LSmvsrtXqQAHYONbNKsLJNhetsvA==
X-Received: by 2002:adf:aadb:: with SMTP id i27mr7569831wrc.258.1601542743657;
        Thu, 01 Oct 2020 01:59:03 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id n3sm7745581wmn.28.2020.10.01.01.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 01:59:03 -0700 (PDT)
Date:   Thu, 1 Oct 2020 10:59:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Ju Hyung Park <qkrwngud825@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        qemu-devel@nongnu.org
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
Message-ID: <20201001085900.ms5ix2zyoid7v3ra@steredhat>
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

+Cc: qemu-devel@nongnu.org

Hi,

On Thu, Oct 01, 2020 at 01:26:51AM +0900, Ju Hyung Park wrote:
> Hi everyone.
> 
> I have recently switched to a setup running QEMU 5.0(which supports
> io_uring) for a Windows 10 guest on Linux v5.4.63.
> The QEMU hosts /dev/nvme0n1p3 to the guest with virtio-blk with
> discard/unmap enabled.

Please, can you share the qemu command line that you are using?
This can be useful for the analysis.

Thanks,
Stefano

> 
> I've been having a weird issue where the system would randomly hang
> whenever I turn on or shutdown the guest. The host will stay up for a
> bit and then just hang. No response on SSH, etc. Even ping doesn't
> work.
> 
> It's been hard to even get a log to debug the issue, but I've been
> able to get a show-backtrace-all-active-cpus sysrq dmesg on the most
> recent encounter with the issue and it's showing some io_uring
> functions.
> 
> Since I've been encountering the issue ever since I switched to QEMU
> 5.0, I suspect io_uring may be the culprit to the issue.
> 
> While I'd love to try out the mainline kernel, it's currently not
> feasible at the moment as I have to stay in linux-5.4.y. Backporting
> mainline's io_uring also seems to be a non-trivial job.
> 
> Any tips would be appreciated. I can build my own kernel and I'm
> willing to try out (backported) patches.
> 
> Thanks.
> 
> [243683.539303] NMI backtrace for cpu 1
> [243683.539303] CPU: 1 PID: 1527 Comm: qemu-system-x86 Tainted: P
>   W  O      5.4.63+ #1
> [243683.539303] Hardware name: System manufacturer System Product
> Name/PRIME Z370-A, BIOS 2401 07/12/2019
> [243683.539304] RIP: 0010:io_uring_flush+0x98/0x140
> [243683.539304] Code: e4 74 70 48 8b 93 e8 02 00 00 48 8b 32 48 8b 4a
> 08 48 89 4e 08 48 89 31 48 89 12 48 89 52 08 48 8b 72 f8 81 4a a8 00
> 40 00 00 <48> 85 f6 74 15 4c 3b 62 c8 75 0f ba 01 00 00 00 bf 02 00 00
> 00 e8
> [243683.539304] RSP: 0018:ffff8881f20c3e28 EFLAGS: 00000006
> [243683.539305] RAX: ffff888419cd94e0 RBX: ffff88842ba49800 RCX:
> ffff888419cd94e0
> [243683.539305] RDX: ffff888419cd94e0 RSI: ffff888419cd94d0 RDI:
> ffff88842ba49af8
> [243683.539306] RBP: ffff88842ba49af8 R08: 0000000000000001 R09:
> ffff88840d17aaf8
> [243683.539306] R10: 0000000000000001 R11: 00000000ffffffec R12:
> ffff88843c68c080
> [243683.539306] R13: ffff88842ba49ae8 R14: 0000000000000001 R15:
> 0000000000000000
> [243683.539307] FS:  0000000000000000(0000) GS:ffff88843ea80000(0000)
> knlGS:0000000000000000
> [243683.539307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [243683.539307] CR2: 00007f3234b31f90 CR3: 0000000002608001 CR4:
> 00000000003726e0
> [243683.539307] Call Trace:
> [243683.539308]  ? filp_close+0x2a/0x60
> [243683.539308]  ? put_files_struct.part.0+0x57/0xb0
> [243683.539309]  ? do_exit+0x321/0xa70
> [243683.539309]  ? do_group_exit+0x35/0x90
> [243683.539309]  ? __x64_sys_exit_group+0xf/0x10
> [243683.539309]  ? do_syscall_64+0x41/0x160
> [243683.539309]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [243684.753272] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> [243684.753278] rcu: 1-...0: (1 GPs behind)
> idle=a5e/1/0x4000000000000000 softirq=7893711/7893712 fqs=2955
> [243684.753280] (detected by 3, t=6002 jiffies, g=17109677, q=117817)
> [243684.753282] Sending NMI from CPU 3 to CPUs 1:
> [243684.754285] NMI backtrace for cpu 1
> [243684.754285] CPU: 1 PID: 1527 Comm: qemu-system-x86 Tainted: P
>   W  O      5.4.63+ #1
> [243684.754286] Hardware name: System manufacturer System Product
> Name/PRIME Z370-A, BIOS 2401 07/12/2019
> [243684.754286] RIP: 0010:io_uring_flush+0x83/0x140
> [243684.754287] Code: 89 ef e8 00 36 92 00 48 8b 83 e8 02 00 00 49 39
> c5 74 52 4d 85 e4 74 70 48 8b 93 e8 02 00 00 48 8b 32 48 8b 4a 08 48
> 89 4e 08 <48> 89 31 48 89 12 48 89 52 08 48 8b 72 f8 81 4a a8 00 40 00
> 00 48
> [243684.754287] RSP: 0018:ffff8881f20c3e28 EFLAGS: 00000002
> [243684.754288] RAX: ffff888419cd94e0 RBX: ffff88842ba49800 RCX:
> ffff888419cd94e0
> [243684.754288] RDX: ffff888419cd94e0 RSI: ffff888419cd94e0 RDI:
> ffff88842ba49af8
> [243684.754289] RBP: ffff88842ba49af8 R08: 0000000000000001 R09:
> ffff88840d17aaf8
> [243684.754289] R10: 0000000000000001 R11: 00000000ffffffec R12:
> ffff88843c68c080
> [243684.754289] R13: ffff88842ba49ae8 R14: 0000000000000001 R15:
> 0000000000000000
> [243684.754290] FS:  0000000000000000(0000) GS:ffff88843ea80000(0000)
> knlGS:0000000000000000
> [243684.754290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [243684.754291] CR2: 00007f3234b31f90 CR3: 0000000002608001 CR4:
> 00000000003726e0
> [243684.754291] Call Trace:
> [243684.754291]  ? filp_close+0x2a/0x60
> [243684.754291]  ? put_files_struct.part.0+0x57/0xb0
> [243684.754292]  ? do_exit+0x321/0xa70
> [243684.754292]  ? do_group_exit+0x35/0x90
> [243684.754292]  ? __x64_sys_exit_group+0xf/0x10
> [243684.754293]  ? do_syscall_64+0x41/0x160
> [243684.754293]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 

