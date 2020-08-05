Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D1E23D180
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 22:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHEUB5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 16:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbgHEQkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Aug 2020 12:40:06 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3053C034619
        for <io-uring@vger.kernel.org>; Wed,  5 Aug 2020 05:50:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s15so12827463pgc.8
        for <io-uring@vger.kernel.org>; Wed, 05 Aug 2020 05:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pxHZlGFs7n3hLhzw5QUyYbZXnsLYTvT69Yo2dhG5PnE=;
        b=s4mcYaszZB72uzAiUc1f6UxgpxOUVAK+bqa8bpBtpi4bAsVpiuMKN77nWwmHFGx6xu
         /aJCTtRlsTUOuOUSp9LdjxuecSIYwISApjdBOMMEYW67l/kzMq95fbtpJ5D0Bnw/B4FK
         WF6SO5eghuT6axWjy0u2JVJyCxIneYDL5u7OZKIKClodsGDMeirU4Q/r0WkaxWDSs6BC
         iNMGM5fOmMmKM4akmwx7idL7u4YkdsAOHrRxWUTDy+TEXU0ANzuTk0dmdQfoPa2RK9UQ
         W7WehElPojoe5rRSjM2qZypZ7Es1UB0SZK/aR1PpN6IdsSlmTuZe9BLzhJZRGLKQmFFM
         UikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pxHZlGFs7n3hLhzw5QUyYbZXnsLYTvT69Yo2dhG5PnE=;
        b=my9s+BJy39x12QlL9+NZgfPlqv3w1P9dX2Mn7b6U4km1kedzzn0jeqRBT7XKQXV694
         +AWzpDGvhoau9JZNH0FpVsM9nvC9Ny10ksP5Jq11Y81w+X/8AyPBdlseiMe1vit6XE5r
         FjtyOCeK1rZSqH9OyopZ0SAwfnXGvFlsLocXCaqbQHhDvYv4sXl2jSocbtDqphrK/cIa
         tpZSL7jXzO8MHI8lv2utgR9BM3q5ewO4KuE2ehsojQD2YNvp7s3K7YwzHz8DsNeotXpO
         ZPdn6F1AmbwdHAf8R+X99WDlJekjJMOItxdQK9T1nB5HvIPVoq1Y/Acsgy/PEfdvs32c
         R3Iw==
X-Gm-Message-State: AOAM531tIwKqD/zpRJFiZw1XKw7GFRxcpW8xhSwOQ2/Ti+juL4+0Ftk5
        0PnkKDPVBQ3gyQC6KqIVF5qM0Nk8X6Y=
X-Google-Smtp-Source: ABdhPJzOcIElnG1OKuAwYY+GNfFtXM3ZLcXTRiuliXNpSfqW+BynlCZ/gdnSW61DbVIUXDJycMEtjA==
X-Received: by 2002:aa7:8f0d:: with SMTP id x13mr3175421pfr.193.1596631834158;
        Wed, 05 Aug 2020 05:50:34 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e14sm3576167pfh.108.2020.08.05.05.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 05:50:33 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Fix NULL pointer dereference in loop_rw_iter()
To:     Guoyu Huang <hgy5945@gmail.com>, viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200805110247.GA103385@ubuntu>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b3cc7c68-a76d-8efd-4d2d-bd4c06efe177@kernel.dk>
Date:   Wed, 5 Aug 2020 06:50:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805110247.GA103385@ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/5/20 5:02 AM, Guoyu Huang wrote:
> loop_rw_iter() does not check whether the file has a read or
> write function. This can lead to NULL pointer dereference
> when the user passes in a file descriptor that does not have
> read or write function.
> 
> The crash log looks like this:
> 
> [   99.834071] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [   99.835364] #PF: supervisor instruction fetch in kernel mode
> [   99.836522] #PF: error_code(0x0010) - not-present page
> [   99.837771] PGD 8000000079d62067 P4D 8000000079d62067 PUD 79d8c067 PMD 0
> [   99.839649] Oops: 0010 [#2] SMP PTI
> [   99.840591] CPU: 1 PID: 333 Comm: io_wqe_worker-0 Tainted: G      D           5.8.0 #2
> [   99.842622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> [   99.845140] RIP: 0010:0x0
> [   99.845840] Code: Bad RIP value.
> [   99.846672] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
> [   99.848018] RAX: 0000000000000000 RBX: ffff92363bd67300 RCX: ffff92363d461208
> [   99.849854] RDX: 0000000000000010 RSI: 00007ffdbf696bb0 RDI: ffff92363bd67300
> [   99.851743] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
> [   99.853394] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
> [   99.855148] R13: 0000000000000000 R14: ffff92363d461208 R15: ffffa1c7c01ebc68
> [   99.856914] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
> [   99.858651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   99.860032] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0
> [   99.861979] Call Trace:
> [   99.862617]  loop_rw_iter.part.0+0xad/0x110
> [   99.863838]  io_write+0x2ae/0x380
> [   99.864644]  ? kvm_sched_clock_read+0x11/0x20
> [   99.865595]  ? sched_clock+0x9/0x10
> [   99.866453]  ? sched_clock_cpu+0x11/0xb0
> [   99.867326]  ? newidle_balance+0x1d4/0x3c0
> [   99.868283]  io_issue_sqe+0xd8f/0x1340
> [   99.869216]  ? __switch_to+0x7f/0x450
> [   99.870280]  ? __switch_to_asm+0x42/0x70
> [   99.871254]  ? __switch_to_asm+0x36/0x70
> [   99.872133]  ? lock_timer_base+0x72/0xa0
> [   99.873155]  ? switch_mm_irqs_off+0x1bf/0x420
> [   99.874152]  io_wq_submit_work+0x64/0x180
> [   99.875192]  ? kthread_use_mm+0x71/0x100
> [   99.876132]  io_worker_handle_work+0x267/0x440
> [   99.877233]  io_wqe_worker+0x297/0x350
> [   99.878145]  kthread+0x112/0x150
> [   99.878849]  ? __io_worker_unuse+0x100/0x100
> [   99.879935]  ? kthread_park+0x90/0x90
> [   99.880874]  ret_from_fork+0x22/0x30
> [   99.881679] Modules linked in:
> [   99.882493] CR2: 0000000000000000
> [   99.883324] ---[ end trace 4453745f4673190b ]---
> [   99.884289] RIP: 0010:0x0
> [   99.884837] Code: Bad RIP value.
> [   99.885492] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
> [   99.886851] RAX: 0000000000000000 RBX: ffff92363acd7f00 RCX: ffff92363d461608
> [   99.888561] RDX: 0000000000000010 RSI: 00007ffe040d9e10 RDI: ffff92363acd7f00
> [   99.890203] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
> [   99.891907] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
> [   99.894106] R13: 0000000000000000 R14: ffff92363d461608 R15: ffffa1c7c01ebc68
> [   99.896079] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
> [   99.898017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   99.899197] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0

Thanks, applied (slightly modified for current -git), and marked with the right
fixes tag and stable CC'ed.

-- 
Jens Axboe

