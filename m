Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D0B1F082B
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 20:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgFFSuU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Jun 2020 14:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbgFFSuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Jun 2020 14:50:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFADC03E96A
        for <io-uring@vger.kernel.org>; Sat,  6 Jun 2020 11:50:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id h95so4235607pje.4
        for <io-uring@vger.kernel.org>; Sat, 06 Jun 2020 11:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/uDoYpv2bKP60MocQhrXLMLY7UrOiW0rzkg/PCuwskk=;
        b=hYa7N7my/ahO7orHcXEdaLVldPgCFeA/KOtWrb4gUEwcaOmu6QB/Oyoc1xRdfFHtqv
         kvpU8lZzlt0/vuvyxsDLChBoH1Zw3kaa/W31AxamekGpSoPMmZMRJN/THJI7ikF1Ehbv
         rr+7LRd1GSezCLXAPIvlDYQQmyTS4GScDXAXGoMoFgOUZyzWfYqGu8BLtOu9hs1q1Kd8
         vw4Mz5pG0yt26NVeduPZHFur9AlCGKFgStZV+pAgHa/vjv/hhlzdSSTDfq08qOM6x2ot
         +/4FXAkQ5+DpfsWdZH1depqBGctfohloWHPyr/fBiP+oVF7q9aQ5yUKGAvtba8hk7O0u
         6B6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/uDoYpv2bKP60MocQhrXLMLY7UrOiW0rzkg/PCuwskk=;
        b=DeqThnK8+hED48jGMiC1dcmBVgxdoHSmKPLgOlxFrtkFmIjPmplzOGfNPrAc34S9nu
         crkrU1Br64Ng9Gw/1tT059e9OrhPHTXXDCNfKRETR5QHpyM1rTPO1nO1eB0J/B855Xxc
         q3pBBc/UH864b/HMMGHgMuSeQkR/gsFm+sI3/vGVtuK5akgRVbK4TVF+1nVCDEw7Kp5R
         mP1i47ad2w8/Jcu1AoeYR8IrVWl4Gg0TOYia7Zf6iM5zVfAWBsqMi+naipBYwuve0VEo
         tiKDBOulljVnCXXidmZjO5vzyVXO92OLfgToZqi2QcLSGdyTyejq0krfkXNtKO0TEdVd
         zm2Q==
X-Gm-Message-State: AOAM533Dqsa+EyWpLGMl+B2vDCrYuNpbFYYWxgaXukGCEno/zAkto0Hi
        AXuIkLm4BQfmmIploTxJ4PwN2eG2i9B7Iw==
X-Google-Smtp-Source: ABdhPJz8hXxkRjnMGWbRUkvoUPoYdQAombPtWubB+h2Ro9NuXoMPQgKdFa+kxtnE2F5feDKnocmo4Q==
X-Received: by 2002:a17:90a:43c7:: with SMTP id r65mr8871182pjg.76.1591469419374;
        Sat, 06 Jun 2020 11:50:19 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j16sm2776423pfa.179.2020.06.06.11.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2020 11:50:18 -0700 (PDT)
Subject: Re: [PATCH] io_uring: execute task_work_run() before dropping mm
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a23f96f9-fbe8-8dba-a1cd-20a3f121d868@kernel.dk>
Date:   Sat, 6 Jun 2020 12:50:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/20 9:12 AM, Xiaoguang Wang wrote:
> While testing io_uring in our internal kernel, note it's not upstream
> kernel, we see below panic:
> [  872.498723] x29: ffff00002d553cf0 x28: 0000000000000000
> [  872.508973] x27: ffff807ef691a0e0 x26: 0000000000000000
> [  872.519116] x25: 0000000000000000 x24: ffff0000090a7980
> [  872.529184] x23: ffff000009272060 x22: 0000000100022b11
> [  872.539144] x21: 0000000046aa5668 x20: ffff80bee8562b18
> [  872.549000] x19: ffff80bee8562080 x18: 0000000000000000
> [  872.558876] x17: 0000000000000000 x16: 0000000000000000
> [  872.568976] x15: 0000000000000000 x14: 0000000000000000
> [  872.578762] x13: 0000000000000000 x12: 0000000000000000
> [  872.588474] x11: 0000000000000000 x10: 0000000000000c40
> [  872.598324] x9 : ffff000008100c00 x8 : 000000007ffff000
> [  872.608014] x7 : ffff80bee8562080 x6 : ffff80beea862d30
> [  872.617709] x5 : 0000000000000000 x4 : ffff80beea862d48
> [  872.627399] x3 : ffff80bee8562b18 x2 : 0000000000000000
> [  872.637044] x1 : ffff0000090a7000 x0 : 0000000000208040
> [  872.646575] Call trace:
> [  872.653139]  task_numa_work+0x4c/0x310
> [  872.660916]  task_work_run+0xb0/0xe0
> [  872.668400]  io_sq_thread+0x164/0x388
> [  872.675829]  kthread+0x108/0x138
> 
> The reason is that once io_sq_thread has a valid mm, schedule subsystem
> may call task_tick_numa() adding a task_numa_work() callback, which will
> visit mm, then above panic will happen.> 
> To fix this bug, only call task_work_run() before dropping mm.

That's a bug outside of io_uring, you'll want to backport this patch
from 5.7:

commit 18f855e574d9799a0e7489f8ae6fd8447d0dd74a
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue May 26 09:38:31 2020 -0600

    sched/fair: Don't NUMA balance for kthreads


-- 
Jens Axboe

