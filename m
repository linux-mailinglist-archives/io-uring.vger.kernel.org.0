Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC802F9F9B
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 13:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbhARM2G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 07:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391540AbhARM1y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 07:27:54 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4862AC061573
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 04:27:14 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id 7so9036220wrz.0
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 04:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sCYXVbz3+UP7yns1po3YK6SYcj/XUHokCcdmTfEpbGk=;
        b=dSjDyLVXPomuUUIhLmISsb30NicTj2hYe1xLAqKhxqE82XsivwkZuAp4YO+vsHZP2m
         h9ooql2ynWwsNdEM9QSLiqkxjByU3GcoN8qXqfWRnt0qxr0iGWUoet1PR2R8QbgrT8NU
         tdRwavTKkIn7yBIawD0z4mpILflyjFGW37JjmlzdOQF9Bo9RDopDIB+g2hdewYn6nXrw
         LQIo/oRYKs3AC533qY6XPuGdZ0d3SakLwK9rYWBaVT5qXVkbjkPNYPLT2pcvIxqg9xEK
         0ZltScAe0PDelTTRzD011pqvpB3cbO5RBsElK+Ftsdd8GL0pNq4Yy0JBlCNY+EeC7HGH
         +YZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sCYXVbz3+UP7yns1po3YK6SYcj/XUHokCcdmTfEpbGk=;
        b=r9diNnBk6VLix5EwsKqHu3czLY4SgswrjCq7hcPkl0o0jcof5+CZpM7IrYyG2A36YC
         21jZsscRztS7eDc4rsgOzDzlZpens0GToW7O+UDPWkFoSHa6wXu9APMnl3iAXZYB2tfs
         m4yP+3RyQ3uW+qE1IigqXmR+3jhZrlpAiMa2dXexPgksRVNNrQXJyFxlCFOtZZ7LsDHt
         19FeArsaWIknEAmqqMVd4RAgVokw+8IhqM6rv8LZO1u/g8LaXLWtOUupmc5KgvVHVtjh
         i3s08gV3kudMQ6TITqtnUjxOaJ+XVMW6pb/j1f7o+QKKzPh9wXJFWx6TPvzNQunqV4iK
         f9FA==
X-Gm-Message-State: AOAM533sFn/KqmkvDpXECBX12L5Z94KH+vlrcPUMubR7BCNR30JfoNB1
        bR24nuif/gvIJNbNlQ6wFeX1GeqHFbqp9Q==
X-Google-Smtp-Source: ABdhPJymc0+IwFAOSpjISq2dJ5M09kvMqgMkC/vVfUJewFnMw29SeCCVh2G1B1RO9dgtzS3WceJhHQ==
X-Received: by 2002:a5d:4882:: with SMTP id g2mr25348478wrq.273.1610972832978;
        Mon, 18 Jan 2021 04:27:12 -0800 (PST)
Received: from [192.168.8.130] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id i7sm30944447wrv.12.2021.01.18.04.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 04:27:12 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix NULL pointer dereference for async cancel
 close
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <4f1a8b42-8440-0e9a-ca01-497ccd438b56@gmail.com>
Date:   Mon, 18 Jan 2021 12:23:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/01/2021 09:50, Joseph Qi wrote:
> Abaci reported the following crash:
> 
> [   31.252589] BUG: kernel NULL pointer dereference, address: 00000000000000d8
> [   31.253942] #PF: supervisor read access in kernel mode
> [   31.254945] #PF: error_code(0x0000) - not-present page
> [   31.255964] PGD 800000010b76f067 P4D 800000010b76f067 PUD 10b462067 PMD 0
> [   31.257221] Oops: 0000 [#1] SMP PTI
> [   31.257923] CPU: 1 PID: 1788 Comm: io_uring-sq Not tainted 5.11.0-rc4 #1
> [   31.259175] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   31.260232] RIP: 0010:__lock_acquire+0x19d/0x18c0
> [   31.261144] Code: 00 00 8b 1d fd 56 dd 08 85 db 0f 85 43 05 00 00 48 c7 c6 98 7b 95 82 48 c7 c7 57 96 93 82 e8 9a bc f5 ff 0f 0b e9 2b 05 00 00 <48> 81 3f c0 ca 67 8a b8 00 00 00 00 41 0f 45 c0 89 04 24 e9 81 fe
> [   31.264297] RSP: 0018:ffffc90001933828 EFLAGS: 00010002
> [   31.265320] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
> [   31.266594] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000d8
> [   31.267922] RBP: 0000000000000246 R08: 0000000000000001 R09: 0000000000000000
> [   31.269262] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [   31.270550] R13: 0000000000000000 R14: ffff888106e8a140 R15: 00000000000000d8
> [   31.271760] FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> [   31.273269] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   31.274330] CR2: 00000000000000d8 CR3: 0000000106efa004 CR4: 00000000003706e0
> [   31.275613] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   31.276855] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   31.278065] Call Trace:
> [   31.278649]  lock_acquire+0x31a/0x440
> [   31.279404]  ? close_fd_get_file+0x39/0x160
> [   31.280276]  ? __lock_acquire+0x647/0x18c0
> [   31.281112]  _raw_spin_lock+0x2c/0x40
> [   31.281821]  ? close_fd_get_file+0x39/0x160
> [   31.282586]  close_fd_get_file+0x39/0x160
> [   31.283338]  io_issue_sqe+0x1334/0x14e0
> [   31.284053]  ? lock_acquire+0x31a/0x440
> [   31.284763]  ? __io_free_req+0xcf/0x2e0
> [   31.285504]  ? __io_free_req+0x175/0x2e0
> [   31.286247]  ? find_held_lock+0x28/0xb0
> [   31.286968]  ? io_wq_submit_work+0x7f/0x240
> [   31.287733]  io_wq_submit_work+0x7f/0x240
> [   31.288486]  io_wq_cancel_cb+0x161/0x580
> [   31.289230]  ? io_wqe_wake_worker+0x114/0x360
> [   31.290020]  ? io_uring_get_socket+0x40/0x40
> [   31.290832]  io_async_find_and_cancel+0x3b/0x140
> [   31.291676]  io_issue_sqe+0xbe1/0x14e0
> [   31.292405]  ? __lock_acquire+0x647/0x18c0
> [   31.293207]  ? __io_queue_sqe+0x10b/0x5f0
> [   31.293986]  __io_queue_sqe+0x10b/0x5f0
> [   31.294747]  ? io_req_prep+0xdb/0x1150
> [   31.295485]  ? mark_held_locks+0x6d/0xb0
> [   31.296252]  ? mark_held_locks+0x6d/0xb0
> [   31.297019]  ? io_queue_sqe+0x235/0x4b0
> [   31.297774]  io_queue_sqe+0x235/0x4b0
> [   31.298496]  io_submit_sqes+0xd7e/0x12a0
> [   31.299275]  ? _raw_spin_unlock_irq+0x24/0x30
> [   31.300121]  ? io_sq_thread+0x3ae/0x940
> [   31.300873]  io_sq_thread+0x207/0x940
> [   31.301606]  ? do_wait_intr_irq+0xc0/0xc0
> [   31.302396]  ? __ia32_sys_io_uring_enter+0x650/0x650
> [   31.303321]  kthread+0x134/0x180
> [   31.303982]  ? kthread_create_worker_on_cpu+0x90/0x90
> [   31.304886]  ret_from_fork+0x1f/0x30
> 
> This is caused by NULL files when async cancel close, which has
> IO_WQ_WORK_NO_CANCEL set and continue to do work. Fix it by also setting
> needs_files for IORING_OP_ASYNC_CANCEL.

Looks good enough for a quick late-rc fix,
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

But we need need to rework this NO_CANCEL case for the future. A
reproducer would help much, do you have one? Or even better a liburing
test?

> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Cc: stable@vger.kernel.org # 5.6+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/io_uring.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 985a9e3..8eb1349 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -883,7 +883,10 @@ struct io_op_def {
>  		.pollin			= 1,
>  		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES,
>  	},
> -	[IORING_OP_ASYNC_CANCEL] = {},
> +	[IORING_OP_ASYNC_CANCEL] = {
> +		/* for async cancel close */
> +		.needs_file		= 1,
> +	},
>  	[IORING_OP_LINK_TIMEOUT] = {
>  		.needs_async_data	= 1,
>  		.async_size		= sizeof(struct io_timeout_data),
> 

-- 
Pavel Begunkov
