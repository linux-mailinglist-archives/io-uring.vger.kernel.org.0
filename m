Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BCA393000
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhE0Nqr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 09:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbhE0Nqq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 09:46:46 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58AAC061760
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 06:45:12 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so230413oth.8
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 06:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zZ100OgAiDnND5MKuUNcSvGRwi3n6jrkgirwTZqtvBg=;
        b=gbRqGxktvRNDpJhHKBHPOtxsKvnuredhB0CuEaHskvQPCL4yOMgC/+b8pSgZvHjKcv
         TSvopIpxiSz656gT8XKPsawPiFgQT1pB24j0G2sWXB/+rX2QPFYFfqVX0CHnfRCeOuXS
         zcWEmfkEkbZIF1eCbUOP1YoyJMn2cWmOM7ss947ScWLEV1HhOm5k9ZLjW0YKM3RHe0o4
         tWeE9sdJfy1eRKLaGFK33oqxubYRgT9KO72CfBCumS5aEk/Q9oQBBRDXwiU0hoorXb4V
         XTLPambzK+pC7h+XA3ENBaNgQmX1vYKH4Xn5sunS70WiPx/F0RMZu9SokTyxnLLRLiuW
         /2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zZ100OgAiDnND5MKuUNcSvGRwi3n6jrkgirwTZqtvBg=;
        b=EQAfs5gsNt4wyD1xM6+eXPOKK+qhCPV0NleZAGhuRm8RHp3exavkuW43LzO0k0eHh7
         t2+/HuR6I0b629uoz7EqDQYCk9udUE5kL5lRvF1zEMmYmSXl+jcLNPao8V16NeP2n6H3
         6b0Bu3Xrb9thzlLqYMJIdjXwy2tLDUhZeY15tQZ5TeHc0wFKAJgxozNCVWqsEyFRw+kG
         6Nxqw4384ki7BScchIp04mnsEFPpRrdYcanqe083zBUBv7+R1i9N15rOukRg1Nl+CHwu
         T9VDkmt99GQ7v6ek0RRUB4+7HDeCEg44hgO8HVrcvfiFRUEP7Jqkr8TmfbMWPT5xMWYa
         2+1w==
X-Gm-Message-State: AOAM530m4s2JKV8J2zb39l9N9XwxJtg2h+Ytnh2Rh9Grxz5vrG1+G+3t
        l5OZjV9o879JS8X9emC0Cl7TmQ==
X-Google-Smtp-Source: ABdhPJyyLtLz5hfiXO/rEMDie6ChH/diU9MrpmMhfVfQCaiuWDOoGL9lOGKSQ/S5a+SVLws/3OXrwA==
X-Received: by 2002:a9d:5c08:: with SMTP id o8mr2856752otk.261.1622123111562;
        Thu, 27 May 2021 06:45:11 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id k18sm515360otj.42.2021.05.27.06.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 06:45:11 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix data race to avoid potential NULL-deref
To:     Marco Elver <elver@google.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kasan-dev@googlegroups.com, dvyukov@google.com,
        syzbot+bf2b3d0435b9b728946c@syzkaller.appspotmail.com
References: <20210527092547.2656514-1-elver@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <893559c1-4510-3f7d-7c7f-82eb2468a5d5@kernel.dk>
Date:   Thu, 27 May 2021 07:45:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210527092547.2656514-1-elver@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 3:25 AM, Marco Elver wrote:
> Commit ba5ef6dc8a82 ("io_uring: fortify tctx/io_wq cleanup") introduced
> setting tctx->io_wq to NULL a bit earlier. This has caused KCSAN to
> detect a data race between accesses to tctx->io_wq:
> 
>   write to 0xffff88811d8df330 of 8 bytes by task 3709 on cpu 1:
>    io_uring_clean_tctx                  fs/io_uring.c:9042 [inline]
>    __io_uring_cancel                    fs/io_uring.c:9136
>    io_uring_files_cancel                include/linux/io_uring.h:16 [inline]
>    do_exit                              kernel/exit.c:781
>    do_group_exit                        kernel/exit.c:923
>    get_signal                           kernel/signal.c:2835
>    arch_do_signal_or_restart            arch/x86/kernel/signal.c:789
>    handle_signal_work                   kernel/entry/common.c:147 [inline]
>    exit_to_user_mode_loop               kernel/entry/common.c:171 [inline]
>    ...
>   read to 0xffff88811d8df330 of 8 bytes by task 6412 on cpu 0:
>    io_uring_try_cancel_iowq             fs/io_uring.c:8911 [inline]
>    io_uring_try_cancel_requests         fs/io_uring.c:8933
>    io_ring_exit_work                    fs/io_uring.c:8736
>    process_one_work                     kernel/workqueue.c:2276
>    ...
> 
> With the config used, KCSAN only reports data races with value changes:
> this implies that in the case here we also know that tctx->io_wq was
> non-NULL. Therefore, depending on interleaving, we may end up with:
> 
>               [CPU 0]                 |        [CPU 1]
>   io_uring_try_cancel_iowq()          | io_uring_clean_tctx()
>     if (!tctx->io_wq) // false        |   ...
>     ...                               |   tctx->io_wq = NULL
>     io_wq_cancel_cb(tctx->io_wq, ...) |   ...
>       -> NULL-deref                   |
> 
> Note: It is likely that thus far we've gotten lucky and the compiler
> optimizes the double-read into a single read into a register -- but this
> is never guaranteed, and can easily change with a different config!
> 
> Fix the data race by restoring the previous behaviour, where both
> setting io_wq to NULL and put of the wq are _serialized_ after
> concurrent io_uring_try_cancel_iowq() via acquisition of the uring_lock
> and removal of the node in io_uring_del_task_file().

Applied, thanks.

-- 
Jens Axboe

