Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33203D48B6
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 19:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhGXQYE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Jul 2021 12:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhGXQYD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Jul 2021 12:24:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB37C061575
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 10:04:35 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso8185638pjs.2
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 10:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3/z+b3qxyBzF4OWcSmtAaIJ6QaKD85Xdlyn7uJ/7Q6c=;
        b=t4TqcYJPQHCpVbB+GpQMlLQMvL9jEEfavOxqjRA+VDmCAUcXxo9GARAUOewC2S79sJ
         7nemAwUNpu7FE6l/onFBZ7PA+anXPS98woQ3uh366/C4150he42truH8qNVKJZeVEQ2e
         LZVHRyR6uwL0MfI2iOatO8ROfAHF7XreXGOTQsPUKrvxNcygLiU6Cwcr74S4RqTc7Yqh
         Ey+nzuitaWmsf4DDIZTvUQRhr5+xk7jekKlFUqZBviWnXqyfeclH6X8eSLncgq93c9Fs
         qjPdynOONbZQYYGXs/4Gc0tEhq9C9JH4q02COx0aHh6UStOv+9CQszvMGc33hYrZCWNU
         z4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3/z+b3qxyBzF4OWcSmtAaIJ6QaKD85Xdlyn7uJ/7Q6c=;
        b=ETsgYl5xmp4aV1uZ1LUmUtPRMzORvLjYMhtvzxocXowWUo2AoPEKWMD/atYsGdcCcw
         zI+z/RJLd26p3b3d9mfL8Hy66LBGXca19pcavHrwBuswLgngusTbsuMzoEg68wj23VAV
         N4XjKHBKpYVnwjJMNo4WNqgna1xdx/TBhd6BfH0UZm7x+PxhrRajXYkPOMlSjufX7cx+
         OkpszcbP4TBuGRKhuw5az/PcpOpI9thgTolOt5FPe+Vyd2xtvIo576gjG49BPhcCO0Vb
         QfUdl6FtPabzPq/Af19Jw39HYGGlmBvkD29Bgb3XJjQPvnrIETJFRl4Bj3OMn8jf+huI
         /0Ew==
X-Gm-Message-State: AOAM533eAuV/yC1mTlkr3BNhkQ09ZilElO8+m5VPZQT0NgXVIK4EWRpb
        FeQc41sQSCDeGq5rHI/7Qxu1yySDDR6W3wxF
X-Google-Smtp-Source: ABdhPJwZzTyi78jaXWJhAZE9+FcdOvBVWc3Vc2wp7G0cVW0hkNEAar36GN+IYqfCdpIjyT9OWCxXUQ==
X-Received: by 2002:a17:90a:28a5:: with SMTP id f34mr9719905pjd.107.1627146274589;
        Sat, 24 Jul 2021 10:04:34 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id w22sm36866654pfu.50.2021.07.24.10.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 10:04:33 -0700 (PDT)
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Forza <forza@tnonline.net>, io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
Date:   Sat, 24 Jul 2021 11:04:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/21 9:46 AM, Forza wrote:
> Hi!
> 
> I am getting a stack trace and broken/stalled transfers with Samba I 
> have "vfs objects = io_uring" in smb.conf.
> 
> Using Samba-4.13.9, the problem occurs in at least kernel-5.12.17-19 and 
> 5.13.4. I haven't tried earlier kernels.
> 
> 
> [52928.008736] ------------[ cut here ]------------
> [52928.008740] WARNING: CPU: 3 PID: 2173 at fs/io_uring.c:8749 
> io_ring_exit_work+0xbd/0x5f0
> [52928.008753] Modules linked in: nf_conntrack_netlink vhost_net vhost 
> vhost_iotlb tap tun xt_CHECKSUM xt_MASQUERADE xt_state ip6t_REJECT 
> nf_reject_ipv6 ip6table_filter ip6table_raw ip6table_mangle ip6table_nat 
> xt_multiport xt_limit ipt_REJECT nf_reject_ipv4 xt_NFLOG nfnetlink_log 
> xt_conntrack xt_physdev iptable_filter iptable_mangle xt_nat iptable_nat 
> xt_CT iptable_raw ip_set_bitmap_port ip_set_hash_ip ip_set_hash_net 
> xt_esp ipt_ah nft_xfrm nf_tables nf_nat_pptp nf_conntrack_pptp nf_nat 
> nf_conntrack_sip nf_conntrack_irc nf_conntrack_ftp nf_conntrack_h323 
> nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_bridge 
> nf_conntrack nf_defrag_ipv6 ip6_tables ip_tables xt_recent xt_set ip_set 
> nfnetlink nf_defrag_ipv4 nf_socket_ipv4 binfmt_misc amdgpu kvm_amd 
> drm_ttm_helper kvm ttm gpu_sched k10temp uas irqbypass 8250 8250_base 
> serial_mctrl_gpio video serial_core backlight pinctrl_amd
> [52928.008821] CPU: 3 PID: 2173 Comm: kworker/u32:4 Not tainted 
> 5.13.4-gentoo-e350 #1
> [52928.008826] Hardware name: Gigabyte Technology Co., Ltd. B450M 
> DS3H/B450M DS3H-CF, BIOS F61c 05/10/2021
> [52928.008829] Workqueue: events_unbound io_ring_exit_work
> [52928.008835] RIP: 0010:io_ring_exit_work+0xbd/0x5f0
> [52928.008841] Code: 00 00 00 4c 89 fa 48 c7 c6 b0 7e 30 83 e8 5b 7f 00 
> 00 4c 89 f7 e8 43 95 ff ff 48 8b 05 9c 75 0f 01 49 39 c5 0f 89 7b ff ff 
> ff <0f> 0b e9 74 ff ff ff 48 c7 c2 c8 b0 af 84 48 c7 c6 be 99 1c 84 48
> [52928.008845] RSP: 0018:ffffa52294007df0 EFLAGS: 00010293
> [52928.008849] RAX: 0000000103237dd4 RBX: ffff89359ef92600 RCX: 
> 0000000000000008
> [52928.008852] RDX: ffff89359ef92080 RSI: 0000000000000000 RDI: 
> ffff89359ef924c0
> [52928.008855] RBP: ffffa52294007e90 R08: 0000000000000001 R09: 
> 0000000000000000
> [52928.008857] R10: 0000000000000000 R11: 0000000000000003 R12: 
> ffff89359ef925d0
> [52928.008858] R13: 0000000103237dc0 R14: 0000000000000000 R15: 
> ffff89359ef92000
> [52928.008861] FS:  0000000000000000(0000) GS:ffff8937a6ec0000(0000) 
> knlGS:0000000000000000
> [52928.008864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [52928.008867] CR2: 00007f13f7904001 CR3: 00000001b62be000 CR4: 
> 00000000003506e0
> [52928.008871] Call Trace:
> [52928.008876]  ? __switch_to+0x23b/0x420
> [52928.008882]  process_one_work+0x1af/0x300
> [52928.008889]  worker_thread+0x48/0x3c0
> [52928.008894]  ? process_one_work+0x300/0x300
> [52928.008899]  kthread+0x122/0x140
> [52928.008903]  ? set_kthread_struct+0x30/0x30
> [52928.008908]  ret_from_fork+0x22/0x30
> [52928.008914] ---[ end trace 6a275af934ed94fd ]---
> 
> 
> I set "log level = 3" in smb.conf and captured the results:
> Windows client: https://paste.tnonline.net/files/1U7Do7BKokPa_smbd-log.txt
> Linux client: https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt
> 
> 
> [2021/07/24 16:46:49.793735,  3] 
> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>    smbd_smb2_read: fnum 4007995332, file 
> media/vm/libvirt/images/NomadBSD.img, length=1048576 offset=1282408448 
> read=1048576
> [2021/07/24 16:46:49.803693,  3] 
> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>    smbd_smb2_read: fnum 4007995332, file 
> media/vm/libvirt/images/NomadBSD.img, length=1048576 offset=1283457024 
> read=1048576
> [2021/07/24 16:46:49.811478,  3] 
> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>    smbd_smb2_read: fnum 4007995332, file 
> media/vm/libvirt/images/NomadBSD.img, length=1048576 offset=1284505600 
> read=1048576
> 
> ... here it just stops adding to the log file and the client eventually 
> times out waiting for more data. No apparent error message in any of the 
> samba log files.
> 
> The stack trace "events_unbound io_ring_exit_work" only seems to occur 
> once and then doesn't come back in subsequent testing, even if I restart 
> Samba itself. It comes back after a reboot.
> 
> This happens every time I have the io_uring vfs module enabled and never 
> otherwise. It seems to be only large (several GB) file transfers that 
> are affected.

I'll see if I can reproduce this. I'm assuming samba is using buffered
IO, and it looks like it's reading in chunks of 1MB. Hopefully it's
possible to reproduce without samba with a windows client, as I don't
have any of those. If synthetic reproducing fails, I can try samba
with a Linux client.

-- 
Jens Axboe

