Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31066589D81
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiHDOcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiHDOca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:32:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD50E2613B
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:32:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w17-20020a17090a8a1100b001f326c73df6so5469199pjn.3
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Rr2Pmo9V1ip7mpaWN6TKvPgMKQ/gdhrNUf8Hfcj3w28=;
        b=JeLiSXeWD5kKcICYxtuINTuI83kExyBVAByVqzorbfaPrFzMIUkdbtdcIl/7iWa24/
         ynamBKsxBYq9g4YE2enYvNTCrozTaFhif0QQrPXVGABzDw3vNaRhPzXtQxLuGtLpU07l
         JbjqVVcIIUw01hjT6uJrmwM0b9KPkpeTdtJQIONntn5AJAHIERliOsgzOs517JXXMocF
         oSNx8zbP3bzrKtQ+Q0U/FUvc7YXgWsZeX/rjoZmwbweV+9eak2buR2/m5cRHFRd6Vn06
         SJnFMOdEdzDr6BbtOa+kdaB0xspbzqqyZDPdq8UuZ0qscd1bJ+v6oE5oZKkm9UX5LLzW
         Iwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Rr2Pmo9V1ip7mpaWN6TKvPgMKQ/gdhrNUf8Hfcj3w28=;
        b=vtJAx7yZ5gBajI8qv9T8PZgKXWN/SXoU+z3WPkAsbXJA9HHAE3vYnASkPNSOhu4N1+
         Gi05zKahiBvDkmpd+d7QDBMNh/IlKpLgDWggwVvQdEWED/K5DeWAJ1dXpYmhJ3zBA6Nt
         PPYHH7OJG4nwmMPP6RRk/0mDkzTaTy4y5RXfZXdVR29R348MJWxux4MBVAGRWfRedsRl
         2hXRUrTYRO4vVxWmZtzA1egcaiDR2rVHs7b+/BAmhCIXKAIFqD3egJq35Elx9vD5sfxh
         s3RyMzgLX3AzOmA7oSVgy7Hu6k+IYMBa3aM8+0j5RuIaMZXs9EDTCNe/CA+6CLlPqZ+P
         /0mA==
X-Gm-Message-State: ACgBeo3SouliLRDHYAJ/WLBZKBCFiNXoR04M7CUaTb0YUGodttrZj+aS
        hdNbcE8pvmEyFHWmszbVLhPzng==
X-Google-Smtp-Source: AA6agR6ya5W9EiMXXKHhiSITfTpXmFpxuzceNoHfF8stnLD/15dphS0KEkGx6o/Lc1lNBXuUKRvaIg==
X-Received: by 2002:a17:902:e74a:b0:16e:d768:158e with SMTP id p10-20020a170902e74a00b0016ed768158emr2123220plf.12.1659623549147;
        Thu, 04 Aug 2022 07:32:29 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b0016beceac426sm1071892pla.138.2022.08.04.07.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 07:32:28 -0700 (PDT)
Message-ID: <5756a75e-ea84-a04b-be07-90e7ee6626d6@kernel.dk>
Date:   Thu, 4 Aug 2022 08:32:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] audit, io_uring, io-wq: Fix memory leak in
 io_sq_thread() and io_wqe_worker()
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Eric Paris <eparis@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
References: <20220803050230.30152-1-yepeilin.cs@gmail.com>
 <20220803222343.31673-1-yepeilin.cs@gmail.com>
 <CAHC9VhSjA444kYPEsBwWz3fuvY7ohmYb-HKWej4EmBy4mbS4Fw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhSjA444kYPEsBwWz3fuvY7ohmYb-HKWej4EmBy4mbS4Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/4/22 7:51 AM, Paul Moore wrote:
> On Wed, Aug 3, 2022 at 6:24 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>>
>> From: Peilin Ye <peilin.ye@bytedance.com>
>>
>> Currently @audit_context is allocated twice for io_uring workers:
>>
>>   1. copy_process() calls audit_alloc();
>>   2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
>>      is effectively audit_alloc()) and overwrites @audit_context,
>>      causing:
>>
>>   BUG: memory leak
>>   unreferenced object 0xffff888144547400 (size 1024):
>> <...>
>>     hex dump (first 32 bytes):
>>       00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     backtrace:
>>       [<ffffffff8135cfc3>] audit_alloc+0x133/0x210
>>       [<ffffffff81239e63>] copy_process+0xcd3/0x2340
>>       [<ffffffff8123b5f3>] create_io_thread+0x63/0x90
>>       [<ffffffff81686604>] create_io_worker+0xb4/0x230
>>       [<ffffffff81686f68>] io_wqe_enqueue+0x248/0x3b0
>>       [<ffffffff8167663a>] io_queue_iowq+0xba/0x200
>>       [<ffffffff816768b3>] io_queue_async+0x113/0x180
>>       [<ffffffff816840df>] io_req_task_submit+0x18f/0x1a0
>>       [<ffffffff816841cd>] io_apoll_task_func+0xdd/0x120
>>       [<ffffffff8167d49f>] tctx_task_work+0x11f/0x570
>>       [<ffffffff81272c4e>] task_work_run+0x7e/0xc0
>>       [<ffffffff8125a688>] get_signal+0xc18/0xf10
>>       [<ffffffff8111645b>] arch_do_signal_or_restart+0x2b/0x730
>>       [<ffffffff812ea44e>] exit_to_user_mode_prepare+0x5e/0x180
>>       [<ffffffff844ae1b2>] syscall_exit_to_user_mode+0x12/0x20
>>       [<ffffffff844a7e80>] do_syscall_64+0x40/0x80
>>
>> Then,
>>
>>   3. io_sq_thread() or io_wqe_worker() frees @audit_context using
>>      audit_free();
>>   4. do_exit() eventually calls audit_free() again, which is okay
>>      because audit_free() does a NULL check.
>>
>> As suggested by Paul Moore, fix it by deleting audit_alloc_kernel() and
>> redundant audit_free() calls.
>>
>> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
>> Suggested-by: Paul Moore <paul@paul-moore.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
>> ---
>> Change since v1:
>>   - Delete audit_alloc_kernel() (Paul Moore)
>>
>>  fs/io-wq.c            |  3 ---
>>  fs/io_uring.c         |  4 ----
>>  include/linux/audit.h |  5 -----
>>  kernel/auditsc.c      | 25 -------------------------
>>  4 files changed, 37 deletions(-)
> 
> This looks good to me, thanks!  Although it looks like the io_uring
> related changes will need to be applied by hand as they are pointing
> to the old layout under fs/ as opposed to the newer layout in
> io_uring/ introduced during this merge window.
> 
> Jens, did you want to take this via the io_uring tree or should I take
> it via the audit tree?  If the latter, an ACK would be appreciated, if
> the former my ACK is below.
> 
> Acked-by: Paul Moore <paul@paul-moore.com>

Probably better if I take it, since I need to massage it into the
current tree anyway. We can then use this one as the base for the stable
backports that are going to be required.

-- 
Jens Axboe

