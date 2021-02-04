Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7844530F54C
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbhBDOpN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 09:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236828AbhBDOoj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 09:44:39 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5385FC061573
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 06:43:58 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id m20so2739337ilj.13
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 06:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pL1ZMdFnfRd7ScmesCztto+dRpVEvKbEEQzO9hCKmPk=;
        b=jePEdVxXMeYtA/WF00zVOgpIPNR50R9CmsRW90HqxcWUBch0tdOYFYC+FNrZeBiq6L
         1qGEHeoyoW6zGPktKtnfiqAiu37ALu6CpCQra/68BspB+82npEqAMvCh8KavhhC1e4Si
         Vqv5EmBP635tkPKQRVUAwRtCBChCjEa1A4jjFK5AseXxq7/v+MsbLytsmiK7VKE3LNTf
         fCZ2+qO5c9yAaCN6BPQX7+x7fCwjFOe3rNlLChFrTnCXw8JTXfrtuhULI1k6v3M91QAH
         UbDZGQ1FhxuPdI2JIS1qth7SwNIJ6Gm392zCi4NA4elSyD2bfWFDYzpwRb6GRyJX62K0
         OAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pL1ZMdFnfRd7ScmesCztto+dRpVEvKbEEQzO9hCKmPk=;
        b=jiC3Djdh+2R/uBDoiTJbfVrh8dAbgLUw/udO8lNWcNuDyPZdxV1sT2ohngKZp3rzas
         GWTpOJhbn+SDTMnQPcRvRLxzoS8+UQ1JWhjiz/1RtV+d7BWYBsycLudaVMA2GfG4Nmbi
         6VbvV99ZeNQqM2OX2ZmFt2Wbrt3hBJNbGm87g5ABxfeh+vmujxuXMf7Sx3hrydjYYh/V
         mCDckIr12HfPg/umIHf+ELCa+n3KBe/KsUevqY9eMV1rLCf7fXRdyMQV2YLC7k8p9/Gu
         OpNact7Cv1cA3/Bt15bnuKqLB7u69qhFuc9T1rqmZM3FR1LjT+MVBYqFY0zQ2CZ/GAyq
         IDWA==
X-Gm-Message-State: AOAM532sngOZclfzW2tw7QXc0lrKW168752bssLhDpjCdFez1yVrbrbJ
        HrVWV/k3j5cSXqjUsofiNbIz7KwzXXHjgFer
X-Google-Smtp-Source: ABdhPJyaYRhk36hadfaVNIr94CxU5Uq10UdPNhjQQQq9cw1XTsV6vq91vKPJIj7b9oKH6FYXNZzwMQ==
X-Received: by 2002:a92:444e:: with SMTP id a14mr7268009ilm.215.1612449837798;
        Thu, 04 Feb 2021 06:43:57 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l14sm2596342ilh.58.2021.02.04.06.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:43:57 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't modify identity's files uncess identity
 is cowed
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20210204092056.12797-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1aef6f8e-5425-d826-b1d2-6b6695c4cd93@kernel.dk>
Date:   Thu, 4 Feb 2021 07:43:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210204092056.12797-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/21 2:20 AM, Xiaoguang Wang wrote:
> Abaci Robot reported following panic:
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 800000010ef3f067 P4D 800000010ef3f067 PUD 10d9df067 PMD 0
> Oops: 0002 [#1] SMP PTI
> CPU: 0 PID: 1869 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc3+ #1
> Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> RIP: 0010:put_files_struct+0x1b/0x120
> Code: 24 18 c7 00 f4 ff ff ff e9 4d fd ff ff 66 90 0f 1f 44 00 00 41 57 41 56 49 89 fe 41 55 41 54 55 53 48 83 ec 08 e8 b5 6b db ff  41 ff 0e 74 13 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f e9 9c
> RSP: 0000:ffffc90002147d48 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88810d9a5300 RCX: 0000000000000000
> RDX: ffff88810d87c280 RSI: ffffffff8144ba6b RDI: 0000000000000000
> RBP: 0000000000000080 R08: 0000000000000001 R09: ffffffff81431500
> R10: ffff8881001be000 R11: 0000000000000000 R12: ffff88810ac2f800
> R13: ffff88810af38a00 R14: 0000000000000000 R15: ffff8881057130c0
> FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010dbaa002 CR4: 00000000003706f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __io_clean_op+0x10c/0x2a0
>  io_dismantle_req+0x3c7/0x600
>  __io_free_req+0x34/0x280
>  io_put_req+0x63/0xb0
>  io_worker_handle_work+0x60e/0x830
>  ? io_wqe_worker+0x135/0x520
>  io_wqe_worker+0x158/0x520
>  ? __kthread_parkme+0x96/0xc0
>  ? io_worker_handle_work+0x830/0x830
>  kthread+0x134/0x180
>  ? kthread_create_worker_on_cpu+0x90/0x90
>  ret_from_fork+0x1f/0x30
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace c358ca86af95b1e7 ]---
> 
> I guess case below can trigger above panic: there're two threads which
> operates different io_uring ctxs and share same sqthread identity, and
> later one thread exits, io_uring_cancel_task_requests() will clear
> task->io_uring->identity->files to be NULL in sqpoll mode, then another
> ctx that uses same identity will panic.
> 
> Indeed we don't need to clear task->io_uring->identity->files here,
> io_grab_identity() should handle identity->files changes well, if
> task->io_uring->identity->files is not equal to current->files,
> io_cow_identity() should handle this changes well.

Applied, thanks.

-- 
Jens Axboe

