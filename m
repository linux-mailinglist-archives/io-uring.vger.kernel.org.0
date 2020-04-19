Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD7B1AFDDE
	for <lists+io-uring@lfdr.de>; Sun, 19 Apr 2020 21:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgDST4J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Apr 2020 15:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgDST4J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Apr 2020 15:56:09 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4CFC061A0C
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 12:56:08 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id hi11so2907252pjb.3
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 12:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CJbAuRv3Tw2aKt7eaH1DUG/e3OAi6rLm/vdo+eunjOY=;
        b=HG6DNDlFc0nHu2l+yVyurEhaJxTH++CRIHLr6M003g2Yg3OzW5wsMCe4qEgcNkFOhb
         07yoCX8/7qoole3P9Lq7YyCVKyjRivdZQVcTSHE8dJmiElGuMS4O1MydsolavrmdimF6
         yZ6pBf2+223WUHV55Uqw6q5+T2j8E5gZ6wTQVa7wb/y5YIv1lkSU+t+CaQF2uudrAfAL
         1koHFcVyCJTIXoYl9zvuVCK7WQEnK/VFP6OTSsf+ys/OHLGedeca20BYASQW7k/lGiRu
         Gld0arPuU9uDEVGaXu0RduMrPWuw9tLKns+/MS9kqhGIZI5PeWK4nryq5+ynEgzJId6+
         6XMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CJbAuRv3Tw2aKt7eaH1DUG/e3OAi6rLm/vdo+eunjOY=;
        b=YwbiFRU6ZC3rJJ+WFJpYmrMRapZiOQstehZ8Q9+Dvef5jgXtWUOfUzo1XQPtD4K3hH
         utCDRk6gK0MWV9pjCvDzQ+zs+x5OqmLK4Ipxyc3KD7UyqkzHSfswrli/PeOl2XzXkduV
         FmSr10iAWuoPP0kE4h115Lk9U9mnDEYHShpiQlp4hUModxwFBYPDC5dYr6e+lvbHRV/p
         Go1j3CHujQ3xklir3Vw3Pw39GD1CK6rSAFpVmmg+agI+qrF7nlgfQiKl6TjxvEGQFmuP
         Lgw0cXCo3RAwaAQydAxjZyAGgXeTis8pVpxFryR+Bxef+DK5pSlCXaw/0BbEllnFoBpP
         u5QQ==
X-Gm-Message-State: AGi0PuZl61zOx8AsF01zNr7ON7ma2tku9Subt/sreoaA0DiTz6JgCla4
        V+WeSDe2cFUxMF+uBEXfXfI9p0BNQpU7kw==
X-Google-Smtp-Source: APiQypL+8wn0p1RZa6mIs/FjoTPyFSNTfe0sXXM6BLtXcL9o+ZX41sgj21a+1eB43+QkkXPp74ycTQ==
X-Received: by 2002:a17:90a:5287:: with SMTP id w7mr18286851pjh.66.1587326167523;
        Sun, 19 Apr 2020 12:56:07 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w3sm10154115pfn.115.2020.04.19.12.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 12:56:06 -0700 (PDT)
Subject: Re: [PATCH] io_uring: only restore req->work for req that needs do
 completion
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200419020655.2261-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9401f5d1-e447-338e-e610-0497e837277c@kernel.dk>
Date:   Sun, 19 Apr 2020 13:56:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419020655.2261-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/20 8:06 PM, Xiaoguang Wang wrote:
> When testing io_uring IORING_FEAT_FAST_POLL feature, I got below panic:
> BUG: kernel NULL pointer dereference, address: 0000000000000030
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 5 PID: 2154 Comm: io_uring_echo_s Not tainted 5.6.0+ #359
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:io_wq_submit_work+0xf/0xa0
> Code: ff ff ff be 02 00 00 00 e8 ae c9 19 00 e9 58 ff ff ff 66 0f 1f
> 84 00 00 00 00 00 0f 1f 44 00 00 41 54 49 89 fc 55 53 48 8b 2f <8b>
> 45 30 48 8d 9d 48 ff ff ff 25 01 01 00 00 83 f8 01 75 07 eb 2a
> RSP: 0018:ffffbef543e93d58 EFLAGS: 00010286
> RAX: ffffffff84364f50 RBX: ffffa3eb50f046b8 RCX: 0000000000000000
> RDX: ffffa3eb0efc1840 RSI: 0000000000000006 RDI: ffffa3eb50f046b8
> RBP: 0000000000000000 R08: 00000000fffd070d R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffa3eb50f046b8
> R13: ffffa3eb0efc2088 R14: ffffffff85b69be0 R15: ffffa3eb0effa4b8
> FS:  00007fe9f69cc4c0(0000) GS:ffffa3eb5ef40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000030 CR3: 0000000020410000 CR4: 00000000000006e0
> Call Trace:
>  task_work_run+0x6d/0xa0
>  do_exit+0x39a/0xb80
>  ? get_signal+0xfe/0xbc0
>  do_group_exit+0x47/0xb0
>  get_signal+0x14b/0xbc0
>  ? __x64_sys_io_uring_enter+0x1b7/0x450
>  do_signal+0x2c/0x260
>  ? __x64_sys_io_uring_enter+0x228/0x450
>  exit_to_usermode_loop+0x87/0xf0
>  do_syscall_64+0x209/0x230
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x7fe9f64f8df9
> Code: Bad RIP value.
> 
> task_work_run calls io_wq_submit_work unexpectedly, it's obvious that
> struct callback_head's func member has been changed. After looking into
> codes, I found this issue is still due to the union definition:
>     union {
>         /*
>          * Only commands that never go async can use the below fields,
>          * obviously. Right now only IORING_OP_POLL_ADD uses them, and
>          * async armed poll handlers for regular commands. The latter
>          * restore the work, if needed.
>          */
>         struct {
>             struct callback_head	task_work;
>             struct hlist_node	hash_node;
>             struct async_poll	*apoll;
>         };
>         struct io_wq_work	work;
>     };
> 
> When task_work_run has multiple work to execute, the work that calls
> io_poll_remove_all() will do req->work restore for  non-poll request
> always, but indeed if a non-poll request has been added to a new
> callback_head, subsequent callback will call io_async_task_func() to
> handle this request, that means we should not do the restore work
> for such non-poll request. Meanwhile in io_async_task_func(), we should
> drop submit ref when req has been canceled.
> 
> Fix both issues.

Applied, with io_double_put_req() used.

-- 
Jens Axboe

