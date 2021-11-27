Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C7D45FEE4
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 14:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355017AbhK0NrR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 08:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351075AbhK0NpQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 08:45:16 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6321C061757
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:41:47 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id z8so1826284ilu.7
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=RjPFtztHsPQeRjM1TD1LlDfmpfcHyy4oJX5CJFBoO/Q=;
        b=CF1BXpMzPY9TbmzUlOcZa3Y9Nm+ifXmFjvJkySz2Woc43hGth3DhbOpF8cB0tkU0G5
         ULxyMEPm7hwC1bo5F3ZdkFm1PLs+O2nbzBV9+k0VuL0H3n+wk6nJmrI9UW2XhrPaTnpJ
         Kx9yLx65F9SKuyUYTWAy02MHKit4z+wbYN7uqUCB/SrtS6GiEMKTjOzDTHfg2sb/UcMp
         hizuLutzoViINQP1G7eyDLnn5xpcEmlW/Vd0q5GoBfpNMP58bMnB1gt/r+VrEBNZKgAu
         LELw1tV3HsqqEIFV61ikGS+VbbnHgXuh/vSmVEvZXSqeWpCrEuNOazGDCyHhqRe0gTV6
         CitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=RjPFtztHsPQeRjM1TD1LlDfmpfcHyy4oJX5CJFBoO/Q=;
        b=PSEGjnjTV2n/mVUXVzhctixd4+3GnnoVJhPx9opC8z2Icf17mDFTm+Mnwyc1Icu/Z4
         g38D+MsBuXwihs6sO73KWwZZLkwLV7bhSrrGivv6SOFZAJUtZkATBGl/PBLsSO7c1MDW
         4+x7QIz7/gXOZy4reUHYY2I7WRXbmbotQGahD/w3q5EkR2QZ4sPf1EzNVh9CqTN/0Bab
         8/XAcc1fg74dfWSfzFmhDhe8ZaYhMskEhKrl07XzA6k3kpP9qwWxUy8EJpUrGRO8/N+6
         H5n6CnjHGoHSuXk2O4rYbj16IpYF6tNxTCDUqtegzbVnkBxpMxapZjJ2wAl6eqPH2f34
         wmvg==
X-Gm-Message-State: AOAM530fr4w3z2MwFBMSzrexpUO23A2oRZFXsh0drrgVHXp+h58DjWrc
        InJGyTXi+fXkCdMirFtA1y6ODQ==
X-Google-Smtp-Source: ABdhPJx/v8h/2i1m5F5hTdhtpmQZuadJHqxu2LTf4OlL3f8+6bEfakUhVoMiQzte47WMBj8iVBE/Xg==
X-Received: by 2002:a05:6e02:1d81:: with SMTP id h1mr4977603ila.265.1638020507090;
        Sat, 27 Nov 2021 05:41:47 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o7sm5006541ilo.15.2021.11.27.05.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 05:41:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <20211122024737.2198530-1-yebin10@huawei.com>
References: <20211122024737.2198530-1-yebin10@huawei.com>
Subject: Re: [PATCH -next] io_uring: fix soft lockup when call __io_remove_buffers
Message-Id: <163802050632.624360.15274802921997252338.b4-ty@kernel.dk>
Date:   Sat, 27 Nov 2021 06:41:46 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 22 Nov 2021 10:47:37 +0800, Ye Bin wrote:
> I got issue as follows:
> [ 567.094140] __io_remove_buffers: [1]start ctx=0xffff8881067bf000 bgid=65533 buf=0xffff8881fefe1680
> [  594.360799] watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [kworker/u32:5:108]
> [  594.364987] Modules linked in:
> [  594.365405] irq event stamp: 604180238
> [  594.365906] hardirqs last  enabled at (604180237): [<ffffffff93fec9bd>] _raw_spin_unlock_irqrestore+0x2d/0x50
> [  594.367181] hardirqs last disabled at (604180238): [<ffffffff93fbbadb>] sysvec_apic_timer_interrupt+0xb/0xc0
> [  594.368420] softirqs last  enabled at (569080666): [<ffffffff94200654>] __do_softirq+0x654/0xa9e
> [  594.369551] softirqs last disabled at (569080575): [<ffffffff913e1d6a>] irq_exit_rcu+0x1ca/0x250
> [  594.370692] CPU: 2 PID: 108 Comm: kworker/u32:5 Tainted: G            L    5.15.0-next-20211112+ #88
> [  594.371891] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> [  594.373604] Workqueue: events_unbound io_ring_exit_work
> [  594.374303] RIP: 0010:_raw_spin_unlock_irqrestore+0x33/0x50
> [  594.375037] Code: 48 83 c7 18 53 48 89 f3 48 8b 74 24 10 e8 55 f5 55 fd 48 89 ef e8 ed a7 56 fd 80 e7 02 74 06 e8 43 13 7b fd fb bf 01 00 00 00 <e8> f8 78 474
> [  594.377433] RSP: 0018:ffff888101587a70 EFLAGS: 00000202
> [  594.378120] RAX: 0000000024030f0d RBX: 0000000000000246 RCX: 1ffffffff2f09106
> [  594.379053] RDX: 0000000000000000 RSI: ffffffff9449f0e0 RDI: 0000000000000001
> [  594.379991] RBP: ffffffff9586cdc0 R08: 0000000000000001 R09: fffffbfff2effcab
> [  594.380923] R10: ffffffff977fe557 R11: fffffbfff2effcaa R12: ffff8881b8f3def0
> [  594.381858] R13: 0000000000000246 R14: ffff888153a8b070 R15: 0000000000000000
> [  594.382787] FS:  0000000000000000(0000) GS:ffff888399c00000(0000) knlGS:0000000000000000
> [  594.383851] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  594.384602] CR2: 00007fcbe71d2000 CR3: 00000000b4216000 CR4: 00000000000006e0
> [  594.385540] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  594.386474] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  594.387403] Call Trace:
> [  594.387738]  <TASK>
> [  594.388042]  find_and_remove_object+0x118/0x160
> [  594.389321]  delete_object_full+0xc/0x20
> [  594.389852]  kfree+0x193/0x470
> [  594.390275]  __io_remove_buffers.part.0+0xed/0x147
> [  594.390931]  io_ring_ctx_free+0x342/0x6a2
> [  594.392159]  io_ring_exit_work+0x41e/0x486
> [  594.396419]  process_one_work+0x906/0x15a0
> [  594.399185]  worker_thread+0x8b/0xd80
> [  594.400259]  kthread+0x3bf/0x4a0
> [  594.401847]  ret_from_fork+0x22/0x30
> [  594.402343]  </TASK>
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix soft lockup when call __io_remove_buffers
      commit: 1d0254e6b47e73222fd3d6ae95cccbaafe5b3ecf

Best regards,
-- 
Jens Axboe


