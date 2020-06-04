Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C025C1EDA40
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 03:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgFDBEW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 21:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgFDBEW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 21:04:22 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9C7C03E96D
        for <io-uring@vger.kernel.org>; Wed,  3 Jun 2020 18:04:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y18so1454774plr.4
        for <io-uring@vger.kernel.org>; Wed, 03 Jun 2020 18:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o1u/ed182CTWV8ow6a1sNvTj56lmdVmqwb3Ugrhvu/U=;
        b=XOG7B0UqKMUBqsmoZP8owSJl9EczK6OxwF3SJPJbA3aYLAPGTl0/f/XWkbRf+ZHI6z
         gxdhlS0G7mu/aTcyOE+Q+VY6008fSTbJhPPxx1NyyjxNyC5UHJ+hh1GxbQzKOxMn/TVS
         xpg5G65SVDRkyk8hkTf895suzz6jRplA4wMYc/XQ5B0t3HlFxK+mrEvjpvD8GL525ZFC
         XgamVRkWG8Z0XGCSND93tk/EXitp9qsShjq09fjp1Mos5xuazTOmRUzmQeLMLA9UF42h
         kdBOildx92qTrLay+BF9nH2aXnxLvzST5gkY9Y0dyOJqzeE/2AGqSCwQaPANmfTx4kqq
         BkHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o1u/ed182CTWV8ow6a1sNvTj56lmdVmqwb3Ugrhvu/U=;
        b=bkoYnuOravzxgXmQy5yNI4NAd89xEHxR2sqVYFvtJO46Rh5UoJfGemcdDtUhYpsg8x
         uRXzG9VIFDQ6rBOrgGpNMYkOinExphmKoIr7o40GPSSk8Dgz+igEZh/hb6FpO+0beFki
         d6VaH8qbCmTMBJkFo9RO4r0+fvwR7+zLFE/vAdmtMIzx6ZrTh3O4ptumY1EYXxX6nHal
         t0zNPdXdPnKiuYgmTtBWd4aEQTySrU8TwBHleRtZNMyh+v8+P/PrXOSj0sEFe2dUZb4E
         j3oSO20OohAtdygxy+lFZpIJM+R89PmFqNa/m2pb4JVGbh0qpJ7KXVDsztycAsiZCXDR
         7e5w==
X-Gm-Message-State: AOAM530Crb19P2Uy/7PUn1bWzNI3is/oEMb8LHkQT35/U7VSTQ2naJmL
        Rt5cf5bhYsAXjj3MtItAfppS4w==
X-Google-Smtp-Source: ABdhPJwbOM4D7odfCkk3PeUCFQAJ68BerkNFfcVMjPgVIAg8AgGN6Jz9Tv9I+1N2b/H1jvH+Fj92XQ==
X-Received: by 2002:a17:90a:642:: with SMTP id q2mr3082422pje.71.1591232660150;
        Wed, 03 Jun 2020 18:04:20 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b6sm2889281pfp.24.2020.06.03.18.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 18:04:19 -0700 (PDT)
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
Date:   Wed, 3 Jun 2020 19:04:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/20 6:59 PM, Andres Freund wrote:
> Hi,
> 
> I was trying to benchmark the benefits of this for the io_uring using
> postgres I am working on. The initial results where quite promising
> (reducing cpu usage significantly, to lower than non-uring sync io). But
> unfortunately trying another workload triggered both panics and before
> that seemingly returned wrong data.
> 
> I first saw that problem with b360d424ce02, which was
> linux-block/async-buffered.6 at the time. After hitting the issue, I
> updated to the current linux-block/async-buffered.6, but the problem
> persists.
> 
> The workload that triggers the bug within a few seconds is postgres
> doing a parallel sequential scan of a large table (and aggregating the
> data, but that shouldn't matter). In the triggering case that boils down
> to 9 processes sequentially reading a number of 1GB files (we chunk
> tables internally into smaller files). Each process will read a 512kB
> chunk of the file on its own, and then claim the next 512kB from a
> shared memory location. Most of the IO will be READV requests, reading
> 16 * 8kB into postgres' buffer pool (which may or may not be neighboring
> 8kB pages).

I'll try and reproduce this, any chance you have a test case that can
be run so I don't have to write one from scratch? The more detailed
instructions the better.

> The io submissions in this case will all be done to the same io_uring,
> targeting MAP_HUGETLB | MAP_SHARED | MAP_ANONYMOUS memory. The data is
> on xfs.
> 
> The benchmark starts with dropping caches, which helpfully is visible in
> dmesg... That takes a few seconds, so the actual buffered io_uring load
> starts soon after.
> 
> [  125.526092] tee (7775): drop_caches: 3
> [  146.264327] kill_fasync: bad magic number in fasync_struct!
> 
> After this, but before the oops, I see some userspace memory or
> non-io-uring pipe reads being corrupted.
> 
> 
> [  146.264327] kill_fasync: bad magic number in fasync_struct!
> [  146.285175] kill_fasync: bad magic number in fasync_struct!
> [  146.290793] kill_fasync: bad magic number in fasync_struct!
> [  146.285175] kill_fasync: bad magic number in fasync_struct!
> [  146.290793] kill_fasync: bad magic number in fasync_struct!
> [  157.071979] BUG: kernel NULL pointer dereference, address: 0000000000000020
> [  157.078945] #PF: supervisor read access in kernel mode
> [  157.084082] #PF: error_code(0x0000) - not-present page
> [  157.089225] PGD 0 P4D 0
> [  157.091763] Oops: 0000 [#1] SMP NOPTI
> [  157.095429] CPU: 3 PID: 7756 Comm: postgres Not tainted 5.7.0-rc7-andres-00133-gc8707bf69395 #41
> [  157.104208] Hardware name: Supermicro SYS-7049A-T/X11DAi-N, BIOS 3.2 11/13/2019
> [  157.111518] RIP: 0010:xfs_log_commit_cil+0x356/0x7f0
> [  157.116478] Code: 00 00 48 89 7e 08 49 89 76 30 48 89 11 48 89 4a 08 8b 4c 24 2c 48 89 85 c0 00 00 00 48 89 85 c8 00 00 00 49 8b 46 20 45 31 c9 <8b> 70 20 85 f6 0f 84 d9 02 00 00 45 31 c0 85 c9 7e 4f 41 8b 46 2c
> [  157.135226] RSP: 0018:ffffc90021fefb00 EFLAGS: 00010246
> [  157.140452] RAX: 0000000000000000 RBX: ffff8897a9ea80b0 RCX: 0000000000000458
> [  157.147582] RDX: ffff8897a9ea80c0 RSI: ffff88afc39a1200 RDI: ffff88afb1ae2c18
> [  157.154715] RBP: ffff8897a9ea8000 R08: ffffc90021fefb30 R09: 0000000000000000
> [  157.161848] R10: 0000000000000084 R11: 0000000000000012 R12: ffff8897721bd400
> [  157.168983] R13: ffff88afb1ae2c00 R14: ffff88afb19860c0 R15: ffff8897a9ea80a0
> [  157.176115] FS:  00007ffbbe9a1980(0000) GS:ffff8897e0cc0000(0000) knlGS:0000000000000000
> [  157.184199] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  157.189946] CR2: 0000000000000020 CR3: 000000179c0ac005 CR4: 00000000007606e0
> [  157.197081] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  157.204212] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  157.211343] PKRU: 55555554
> [  157.214048] Call Trace:
> [  157.216498]  __xfs_trans_commit+0xa1/0x340
> [  157.220596]  xfs_create+0x4cc/0x5e0
> [  157.224087]  xfs_generic_create+0x241/0x310
> [  157.228274]  path_openat+0xdb7/0x1020
> [  157.231940]  do_filp_open+0x91/0x100
> [  157.235518]  ? __sys_recvfrom+0xe4/0x170
> [  157.239444]  ? _cond_resched+0x19/0x30
> [  157.243196]  do_sys_openat2+0x215/0x2d0
> [  157.247037]  do_sys_open+0x44/0x80
> [  157.250443]  do_syscall_64+0x48/0x130
> [  157.254108]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  157.259161] RIP: 0033:0x7ffbc0ded307
> [  157.262738] Code: 25 00 00 41 00 3d 00 00 41 00 74 47 64 8b 04 25 18 00 00 00 85 c0 75 6b 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 95 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
> [  157.281485] RSP: 002b:00007fff520a4940 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> [  157.289052] RAX: ffffffffffffffda RBX: 00005561dc02eca0 RCX: 00007ffbc0ded307
> [  157.296185] RDX: 0000000000000241 RSI: 00005561dc013470 RDI: 00000000ffffff9c
> [  157.303317] RBP: 00005561dc013470 R08: 0000000000000004 R09: 0000000000000001
> [  157.310447] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000241
> [  157.317575] R13: 00005561dc02eca0 R14: 0000000000000001 R15: 0000000000000000
> [  157.324705] Modules linked in: isst_if_common squashfs nls_iso8859_1 nls_cp437 snd_hda_codec_realtek vfat snd_hda_codec_generic fat iwlmvm ledtrig_audio snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp snd_hda_intel snd_intel_dspcfg iwlwifi efi_pstore btusb snd_hda_codec btrtl btbcm efivars snd_hwdep btintel snd_hda_core iTCO_wdt iTCO_vendor_support mei_me mei loop coretemp hid_logitech_hidpp hid_logitech_dj hid_lenovo amdgpu gpu_sched i40e ixgbe ast drm_vram_helper drm_ttm_helper ttm mdio xhci_pci xhci_hcd
> [  157.370249] CR2: 0000000000000020
> 
> There's a lot more of these later, some interspersed (possibly related
> to grabbing the output via serial->bmc->network->ipmitool). I've
> attached the whole dmesg and .config.
> 
> What would be helpful for debugging? Should I try the v5 branch instead?
> 
> I'll try setting up a VM + passing through NVME to be able to test this
> without fear... In one instance I did see some minor corruption on
> another device & fs (ext4 on dm-crypt on nvme). It's all backed up,
> but...

I have a known issue with request starvation, wonder if that could be it.
I'm going to rebase the branch on top of the aops->readahead() changes
shortly, and fix that issue. Hopefully that's what's plaguing your run
here, but if not, I'll hunt that one down.

Thanks for testing!

-- 
Jens Axboe

