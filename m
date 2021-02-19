Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C44131F9DD
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 14:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSNYf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 08:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBSNYd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 08:24:33 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C93C061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 05:23:52 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o63so4221680pgo.6
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 05:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oogk3lZuVEwazYr7a4aDqenQlzfsBvmU9Ngv3QaKVX4=;
        b=EIle/Y00VG7tiqFKMxQgNAC4iYx+0H7vEGpDpiYh4sCueho0wXusO/m4DCS6px1x1u
         iPPFBug/sLCoSPvksbRo7AeB8WjO8hGhzDVwe/1KqhPIAJHlCBLGs07CzBdQ/KrazWGa
         pdfrFp7PygROXw3IDGUpg14IWbxCU56b2IsnA0w8z4+X4YbeP/1tQJdLFx/4IX72+OKq
         hWdRQ2cQ2wOp8zoGnB7VzJwBlmOzKlBPOU8jf/HWrMsCOMFmLM/ACmqBRt/dhlyZPA2A
         A02QDhYSvVbnaR/tXHqzkLh2lDKmNknDgm944bHID9TKeyuklmbsZJq7u4tmO19dnbkJ
         goig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oogk3lZuVEwazYr7a4aDqenQlzfsBvmU9Ngv3QaKVX4=;
        b=B+IC62szr68orcU/8Cz8UhhMVxozNcmEk6ocZtDtOJr0wjelgDH+9hmU1MbFwFf3cE
         1eSJCncmc+F9Pg4yUmnW+YvxWSK9/aAYIhyvj2FOczAcxY1vRUrJ1klZaXiYD87bmISu
         0uW/fodDkom5CN8gu0ZxkOfIcgVNVSlBnusqLV6gH2bkFh5w3D3lz8mJPbGj9a9VCpSU
         0j0WSy/sdN89hjP7nzy3AUCEcAUKIAJy+G5j0oVB8dWwAiWws32AllRgfNuHQFvri09+
         HaeNyFNJOJzAp2/ddJ1fcqAUBbL40Razz0I45Y9D2uPiYoZT+L25h+9kuRBR86RADrj5
         cvTw==
X-Gm-Message-State: AOAM5310ItaW+/Zkh9M7kHOiZssZBbBXL5y3Mi0MTtWo+G2jIiCKJJad
        G/1NfmStvDGgkdNoyhFIwna4aEtDBOe8tg==
X-Google-Smtp-Source: ABdhPJzjeazo3U8lU5+Cq/2aL9S+0brngrj+7jbYNtl6x6YgIRxt1+W8XBjKOGNVUWru6Ae/timJDA==
X-Received: by 2002:aa7:83cf:0:b029:1ed:2318:9c29 with SMTP id j15-20020aa783cf0000b02901ed23189c29mr5360515pfn.52.1613741032069;
        Fri, 19 Feb 2021 05:23:52 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n1sm9149819pgi.78.2021.02.19.05.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 05:23:51 -0800 (PST)
Subject: Re: [PATCH 5.12 v3 RESEND] io_uring: don't hold uring_lock when
 calling io_run_task_work*
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1613723254-114070-1-git-send-email-haoxu@linux.alibaba.com>
 <1613726376-135401-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6176dabe-a6a7-bfe8-5a8b-3d3d093c78be@kernel.dk>
Date:   Fri, 19 Feb 2021 06:23:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1613726376-135401-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 2:19 AM, Hao Xu wrote:
> Abaci reported the below issue:
> [  141.400455] hrtimer: interrupt took 205853 ns
> [  189.869316] process 'usr/local/ilogtail/ilogtail_0.16.26' started with executable stack
> [  250.188042]
> [  250.188327] ============================================
> [  250.189015] WARNING: possible recursive locking detected
> [  250.189732] 5.11.0-rc4 #1 Not tainted
> [  250.190267] --------------------------------------------
> [  250.190917] a.out/7363 is trying to acquire lock:
> [  250.191506] ffff888114dbcbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __io_req_task_submit+0x29/0xa0
> [  250.192599]
> [  250.192599] but task is already holding lock:
> [  250.193309] ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
> [  250.194426]
> [  250.194426] other info that might help us debug this:
> [  250.195238]  Possible unsafe locking scenario:
> [  250.195238]
> [  250.196019]        CPU0
> [  250.196411]        ----
> [  250.196803]   lock(&ctx->uring_lock);
> [  250.197420]   lock(&ctx->uring_lock);
> [  250.197966]
> [  250.197966]  *** DEADLOCK ***
> [  250.197966]
> [  250.198837]  May be due to missing lock nesting notation
> [  250.198837]
> [  250.199780] 1 lock held by a.out/7363:
> [  250.200373]  #0: ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
> [  250.201645]
> [  250.201645] stack backtrace:
> [  250.202298] CPU: 0 PID: 7363 Comm: a.out Not tainted 5.11.0-rc4 #1
> [  250.203144] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  250.203887] Call Trace:
> [  250.204302]  dump_stack+0xac/0xe3
> [  250.204804]  __lock_acquire+0xab6/0x13a0
> [  250.205392]  lock_acquire+0x2c3/0x390
> [  250.205928]  ? __io_req_task_submit+0x29/0xa0
> [  250.206541]  __mutex_lock+0xae/0x9f0
> [  250.207071]  ? __io_req_task_submit+0x29/0xa0
> [  250.207745]  ? 0xffffffffa0006083
> [  250.208248]  ? __io_req_task_submit+0x29/0xa0
> [  250.208845]  ? __io_req_task_submit+0x29/0xa0
> [  250.209452]  ? __io_req_task_submit+0x5/0xa0
> [  250.210083]  __io_req_task_submit+0x29/0xa0
> [  250.210687]  io_async_task_func+0x23d/0x4c0
> [  250.211278]  task_work_run+0x89/0xd0
> [  250.211884]  io_run_task_work_sig+0x50/0xc0
> [  250.212464]  io_sqe_files_unregister+0xb2/0x1f0
> [  250.213109]  __io_uring_register+0x115a/0x1750
> [  250.213718]  ? __x64_sys_io_uring_register+0xad/0x210
> [  250.214395]  ? __fget_files+0x15a/0x260
> [  250.214956]  __x64_sys_io_uring_register+0xbe/0x210
> [  250.215620]  ? trace_hardirqs_on+0x46/0x110
> [  250.216205]  do_syscall_64+0x2d/0x40
> [  250.216731]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  250.217455] RIP: 0033:0x7f0fa17e5239
> [  250.218034] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
> [  250.220343] RSP: 002b:00007f0fa1eeac48 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> [  250.221360] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fa17e5239
> [  250.222272] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000008
> [  250.223185] RBP: 00007f0fa1eeae20 R08: 0000000000000000 R09: 0000000000000000
> [  250.224091] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [  250.224999] R13: 0000000000021000 R14: 0000000000000000 R15: 00007f0fa1eeb700
> 
> This is caused by calling io_run_task_work_sig() to do work under
> uring_lock while the caller io_sqe_files_unregister() already held
> uring_lock.
> To fix this issue, briefly drop uring_lock when calling
> io_run_task_work_sig(), and there are two things to concern:
> 
> - hold uring_lock in io_ring_ctx_free() around io_sqe_files_unregister()
>     this is for consistency of lock/unlock.
> - add new fixed rsrc ref node before dropping uring_lock
>     it's not safe to do io_uring_enter-->percpu_ref_get() with a dying one.
> - check if rsrc_data->refs is dying to avoid parallel io_sqe_files_unregister

Applied, thanks.

-- 
Jens Axboe

