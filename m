Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BDE3060E5
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 17:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhA0QVI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 11:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343565AbhA0QU7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 11:20:59 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658A6C061756
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 08:20:19 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b8so1293120plh.12
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 08:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xaNiYk1/yGAXMU0WN8pVITYX4Nn8mwCLDYhGUeUc5ak=;
        b=xkWcdvb3JwZJpk0GUgYFIJtdokUCoH50PemJOiXB3He68Nh2pBPoYMczsX6L2qSDaM
         JNozUDVAyIEf+2ryomVoXhFBeCrayU6AhvZNCHEIiYq+cteZmiYbzeRRgHwGCTUH+nUb
         I+pBYT6WENZtUh6sSrAxOGNhIndSX4T4dstRy2joeU6mRrnujFTm0l8a9KylSReU+tDv
         Gaqn4eYchPblszu8PGAUfKc7iSwS0y138DDdiEvR+mxSpZ3QCfB1vr54iP7P0LaNm6OJ
         w1bbvzT7nTw8z63WIThcwz2afp3hfxA6BvXnkhaZIXTK183LuBWURW7EegEA0BKBb7Ao
         MI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xaNiYk1/yGAXMU0WN8pVITYX4Nn8mwCLDYhGUeUc5ak=;
        b=Ubps75lQbBEnXeRC33bFyIfb7FnU2Yj0pzJsqXz8uWgRgMaZ2mMlu7tpmToqZmf0YS
         TSXJyoF0Wg7t9w5Ylt2z/riO9K4sMyb2+Za5PVt1wle1jUSEIkX3KYW7uPSLX7RVKKZJ
         jc4WjihuBpMZ3n8VtoxpcCTlk/33pNKefW9r5tKoXsxjynttWK5lXCRcgH7FN+8FG5zM
         HthRRbrDfq/SV1EhNLtYjEKiMtTPq07yVDimOnkHXAi4aPmScoc8HUh2NOxpnh/ucVzA
         bqlRRJSXQ+u6oANwCNPwMqUXi/oZ+oqF+SXrfpvKpyJco9FAD1wkwYj6oOFwYg/ViS4Z
         eUbQ==
X-Gm-Message-State: AOAM533gYoa8ABPIHZghdAXRhFXou3FIb0lHsPA8/m8LeKaQ32rikJkx
        0wE88i5TlyYFHLh6h7L21IrILxldAtapig==
X-Google-Smtp-Source: ABdhPJyQMQvPctiVVwV5qx1m1+TYD7O1AbsY0L7YGXhR/FAV0Oemibv4K0uFa/B48jsf9Exw8J4NLQ==
X-Received: by 2002:a17:902:ea8d:b029:e1:c81:3d23 with SMTP id x13-20020a170902ea8db02900e10c813d23mr1320416plb.47.1611764418911;
        Wed, 27 Jan 2021 08:20:18 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j17sm2858701pfh.183.2021.01.27.08.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 08:20:18 -0800 (PST)
Subject: Re: [PATCH RESEND RESEND] io_uring: fix flush cqring overflow list
 while TASK_INTERRUPTIBLE
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1611731204-171460-1-git-send-email-haoxu@linux.alibaba.com>
 <1611731649-174664-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f50094da-e987-e3dc-c7de-84a0544a607c@kernel.dk>
Date:   Wed, 27 Jan 2021 09:20:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1611731649-174664-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/21 12:14 AM, Hao Xu wrote:
> Abaci reported the follow warning:
> 
> [   27.073425] do not call blocking ops when !TASK_RUNNING; state=1 set at [] prepare_to_wait_exclusive+0x3a/0xc0
> [   27.075805] WARNING: CPU: 0 PID: 951 at kernel/sched/core.c:7853 __might_sleep+0x80/0xa0
> [   27.077604] Modules linked in:
> [   27.078379] CPU: 0 PID: 951 Comm: a.out Not tainted 5.11.0-rc3+ #1
> [   27.079637] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   27.080852] RIP: 0010:__might_sleep+0x80/0xa0
> [   27.081835] Code: 65 48 8b 04 25 80 71 01 00 48 8b 90 c0 15 00 00 48 8b 70 18 48 c7 c7 08 39 95 82 c6 05 f9 5f de 08 01 48 89 d1 e8 00 c6 fa ff  0b eb bf 41 0f b6 f5 48 c7 c7 40 23 c9 82 e8 f3 48 ec 00 eb a7
> [   27.084521] RSP: 0018:ffffc90000fe3ce8 EFLAGS: 00010286
> [   27.085350] RAX: 0000000000000000 RBX: ffffffff82956083 RCX: 0000000000000000
> [   27.086348] RDX: ffff8881057a0000 RSI: ffffffff8118cc9e RDI: ffff88813bc28570
> [   27.087598] RBP: 00000000000003a7 R08: 0000000000000001 R09: 0000000000000001
> [   27.088819] R10: ffffc90000fe3e00 R11: 00000000fffef9f0 R12: 0000000000000000
> [   27.089819] R13: 0000000000000000 R14: ffff88810576eb80 R15: ffff88810576e800
> [   27.091058] FS:  00007f7b144cf740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> [   27.092775] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   27.093796] CR2: 00000000022da7b8 CR3: 000000010b928002 CR4: 00000000003706f0
> [   27.094778] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   27.095780] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   27.097011] Call Trace:
> [   27.097685]  __mutex_lock+0x5d/0xa30
> [   27.098565]  ? prepare_to_wait_exclusive+0x71/0xc0
> [   27.099412]  ? io_cqring_overflow_flush.part.101+0x6d/0x70
> [   27.100441]  ? lockdep_hardirqs_on_prepare+0xe9/0x1c0
> [   27.101537]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
> [   27.102656]  ? trace_hardirqs_on+0x46/0x110
> [   27.103459]  ? io_cqring_overflow_flush.part.101+0x6d/0x70
> [   27.104317]  io_cqring_overflow_flush.part.101+0x6d/0x70
> [   27.105113]  io_cqring_wait+0x36e/0x4d0
> [   27.105770]  ? find_held_lock+0x28/0xb0
> [   27.106370]  ? io_uring_remove_task_files+0xa0/0xa0
> [   27.107076]  __x64_sys_io_uring_enter+0x4fb/0x640
> [   27.107801]  ? rcu_read_lock_sched_held+0x59/0xa0
> [   27.108562]  ? lockdep_hardirqs_on_prepare+0xe9/0x1c0
> [   27.109684]  ? syscall_enter_from_user_mode+0x26/0x70
> [   27.110731]  do_syscall_64+0x2d/0x40
> [   27.111296]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   27.112056] RIP: 0033:0x7f7b13dc8239
> [   27.112663] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
> [   27.115113] RSP: 002b:00007ffd6d7f5c88 EFLAGS: 00000286 ORIG_RAX: 00000000000001aa
> [   27.116562] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7b13dc8239
> [   27.117961] RDX: 000000000000478e RSI: 0000000000000000 RDI: 0000000000000003
> [   27.118925] RBP: 00007ffd6d7f5cb0 R08: 0000000020000040 R09: 0000000000000008
> [   27.119773] R10: 0000000000000001 R11: 0000000000000286 R12: 0000000000400480
> [   27.120614] R13: 00007ffd6d7f5d90 R14: 0000000000000000 R15: 0000000000000000
> [   27.121490] irq event stamp: 5635
> [   27.121946] hardirqs last  enabled at (5643): [] console_unlock+0x5c4/0x740
> [   27.123476] hardirqs last disabled at (5652): [] console_unlock+0x4e7/0x740
> [   27.125192] softirqs last  enabled at (5272): [] __do_softirq+0x3c5/0x5aa
> [   27.126430] softirqs last disabled at (5267): [] asm_call_irq_on_stack+0xf/0x20
> [   27.127634] ---[ end trace 289d7e28fa60f928 ]---

Applied, thanks.

-- 
Jens Axboe

