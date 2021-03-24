Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A223478F0
	for <lists+io-uring@lfdr.de>; Wed, 24 Mar 2021 13:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhCXMz4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Mar 2021 08:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhCXMzi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Mar 2021 08:55:38 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21CDC061763
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 05:55:37 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id l123so17269686pfl.8
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 05:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3oB9r1aWavYR/wOuWK5AzazaFayFPTACRUbZQF6JVy8=;
        b=Qv9FgYPiO29QbO95y0hQBiFgKgHoE1PtUxvd2lgA4BqHM9A7sPTzFKJvLkHo//VgzJ
         jl7DJEz6clpAVqxhbseNKLmYBITP/A1Eet6U2XJTahWa9TWwx7Xx8GAq8xlSDOdATCPI
         FYcqkh8wok+EGVUxN2HIk0BZscfsWzDtlJz3qocBgS42duuYRbFTCbdlOYCYmC2YLYC/
         3JArL7jGoSzjiNOVh9hTK1pYt9RDEK/gmsWM51DDOoJAAB1NdgWSondQkhVcPJLaGjsC
         13KXqQigcvGrmrVTK3ZZdb+F6+SsRnfX5VvGUPiI+bTGxvh8nthPiFixmGC9Qd5INxqL
         uA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3oB9r1aWavYR/wOuWK5AzazaFayFPTACRUbZQF6JVy8=;
        b=hqVacmxGkWBxUg1Gmu+ltJkp+MDiPDk+uq56MElWhaKfuUCdq0R47382yl3Pl+VL+9
         04Tdx25m8t2xs1aver8tls3/IfpQKVmDV/jYG+n5gZVtLycBnMWdIsHiI+CC8+iB4c+R
         KTSnQxbGCYZHSSGLryxBkutWzt64HVM4YzQBiYtTFGMgMj0Cl/kcUCKv1OCTH+a7J/zr
         vuvnnyQz3Pc6ua3hH7wR3aXYvWRJedeHioWPTBwuf//ke119sykI4NsM0/U1BGxrf7vY
         Cjrufsi/xvSGEj9MoiV+yZyLdakil/KmHgpAY5HLYWYM3ZZEeHPXrHKbHZp6GX6v5rVD
         LfSg==
X-Gm-Message-State: AOAM5322LsuLc3g3LOGG7FlhPx+whXPuv9SAIVGIHpfG3w1mwGuWpaBK
        u1EbyNdS8iNvPibcoSolnaj0KQ==
X-Google-Smtp-Source: ABdhPJzZCUpMKgok2Apw9F8rrPHzyHLvtqFvLppx5ayW/vmoI1yRJyZP3x4DCdYIdzGsDxxOFIvzow==
X-Received: by 2002:a63:cd09:: with SMTP id i9mr2985950pgg.407.1616590537370;
        Wed, 24 Mar 2021 05:55:37 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k15sm2638346pfi.0.2021.03.24.05.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 05:55:36 -0700 (PDT)
Subject: Re: [PATCH 5.12] io_uring: do ctx sqd ejection in a clear context
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+e3a3f84f5cecf61f0583@syzkaller.appspotmail.com
References: <e90df88b8ff2cabb14a7534601d35d62ab4cb8c7.1616496707.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e6444da0-ba50-e5ff-bcd8-90bf140b6c49@kernel.dk>
Date:   Wed, 24 Mar 2021 06:55:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e90df88b8ff2cabb14a7534601d35d62ab4cb8c7.1616496707.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/21 4:52 AM, Pavel Begunkov wrote:
> WARNING: CPU: 1 PID: 27907 at fs/io_uring.c:7147 io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
> CPU: 1 PID: 27907 Comm: iou-sqp-27905 Not tainted 5.12.0-rc4-syzkaller #0
> RIP: 0010:io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
> Call Trace:
>  io_ring_ctx_wait_and_kill+0x214/0x700 fs/io_uring.c:8619
>  io_uring_release+0x3e/0x50 fs/io_uring.c:8646
>  __fput+0x288/0x920 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:140
>  io_run_task_work fs/io_uring.c:2238 [inline]
>  io_run_task_work fs/io_uring.c:2228 [inline]
>  io_uring_try_cancel_requests+0x8ec/0xc60 fs/io_uring.c:8770
>  io_uring_cancel_sqpoll+0x1cf/0x290 fs/io_uring.c:8974
>  io_sqpoll_cancel_cb+0x87/0xb0 fs/io_uring.c:8907
>  io_run_task_work_head+0x58/0xb0 fs/io_uring.c:1961
>  io_sq_thread+0x3e2/0x18d0 fs/io_uring.c:6763
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> May happen that last ctx ref is killed in io_uring_cancel_sqpoll(), so
> fput callback (i.e. io_uring_release()) is enqueued through task_work,
> and run by same cancellation. As it's deeply nested we can't do parking
> or taking sqd->lock there, because its state is unclear. So avoid
> ctx ejection from sqd list from io_ring_ctx_wait_and_kill() and do it
> in a clear context in io_ring_exit_work().

Applied, thanks.

-- 
Jens Axboe

