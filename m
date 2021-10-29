Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CAD43FC9C
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 14:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhJ2Mv0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 08:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhJ2MvY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 08:51:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C5AC061570
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 05:48:56 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id n67so12343379iod.9
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 05:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q1Lr7Qx+BcGePYDmwEe5BOEjGVPGzTPbtrZpmw5OzGs=;
        b=4qa7AxgnJqhF0AkAaylEIt2NGuBOEoEuu7LvbAkNzcsCHbMp8zzAhR3Glyf+9tUNHe
         D0qgX5lrbrRw3dmOe1HuCi9bIjQrF4/qhDaasTM0BfR9NUQCC1LtVGYhrZJQcihQTvxm
         4aiJAQ8gO73npAmlWpWKBKm62FkFl3XYwbwvztuLw3IssCmxn6taoWoXMKEZSh5wdk7Z
         ZHfCN4bWlmTaBQtXPJJsZ06VCI1O5ZpuQ/hQv0PhiAic8EkduPvnFU/zBIVJvVpAvZbt
         L4WBkewe06V95X0IxidgYWz6bm+LMkEEN6C9FslVutnPfbzPb9JxaKKg/RaPpgYWIYFL
         HQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q1Lr7Qx+BcGePYDmwEe5BOEjGVPGzTPbtrZpmw5OzGs=;
        b=YuqLAjYWJwujzg9tCX3bRtg1K9sjYK5z2KhPUYcUuibdoVnlkAKljdHbPDqGZDbJBD
         2Y9bwdUTUrhxDVswNoFDYie2G5eZiACdUB+Jyz9Ij9nGre0dJxCGAa5B3nlkF1P5t5VR
         vsAniY4z5+OsrvE8zaH4oVPd9rCKRkk1dQt5A6K+fpiPuVHFL7ZUJUrR6GkzYggmHz+x
         l/QpuuBHWQhtMOSRXGYskWrgD1m65b4uYmhQI6d8m2vuMc1Zj5kwZPwAQqAOtAUeJH1W
         HxoJY11pr4dfGwN/hh9g1cuoDW64lMneHDuz6WkvXMGE3OrnzUYTv2PHQPlU+6RQPpTG
         s4fg==
X-Gm-Message-State: AOAM533AixGUygS8mK5QrGhLBvgVdJrm/+xEaeiUFHU5xaC4tIX/WKg+
        90YNmadsvTs73si+ORCn56pmsmWfoCsFHA==
X-Google-Smtp-Source: ABdhPJwcLsPDSoQRBbZPr+9tFmlDbf9kcGt9Ha9+FbB4Zs4W7FHruEDNWwOolx3oheFJROXGezSLcQ==
X-Received: by 2002:a05:6602:140d:: with SMTP id t13mr7782366iov.176.1635511735584;
        Fri, 29 Oct 2021 05:48:55 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id w2sm3136493iou.0.2021.10.29.05.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 05:48:54 -0700 (PDT)
Subject: Re: [PATCH] io-wq: remove worker to owner tw dependency
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com
References: <142a716f4ed936feae868959059154362bfa8c19.1635509451.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <92cb711c-e484-b7c3-e79c-fa0739444621@kernel.dk>
Date:   Fri, 29 Oct 2021 06:48:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <142a716f4ed936feae868959059154362bfa8c19.1635509451.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/29/21 6:11 AM, Pavel Begunkov wrote:
> INFO: task iou-wrk-6609:6612 blocked for more than 143 seconds.
>       Not tainted 5.15.0-rc5-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-wrk-6609    state:D stack:27944 pid: 6612 ppid:  6526 flags:0x00004006
> Call Trace:
>  context_switch kernel/sched/core.c:4940 [inline]
>  __schedule+0xb44/0x5960 kernel/sched/core.c:6287
>  schedule+0xd3/0x270 kernel/sched/core.c:6366
>  schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
>  io_worker_exit fs/io-wq.c:183 [inline]
>  io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> io-wq worker may submit a task_work to the master task and upon
> io_worker_exit() wait for the tw to get executed. The problem appears
> when the master task is waiting in coredump.c:
> 
> 468                     freezer_do_not_count();
> 469                     wait_for_completion(&core_state->startup);
> 470                     freezer_count();
> 
> Apparently having some dependency on children threads getting everything
> stuck. Workaround it by cancelling the taks_work callback that causes it
> before going into io_worker_exit() waiting.
> 
> p.s. probably a better option is to not submit tw elevating the refcount
> in the first place, but let's leave this excercise for the future.

I've applied this for 5.16. It does look good to me, but not comfortable
adding this to 5.15 so late in the process.

-- 
Jens Axboe

