Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7102D75AC
	for <lists+io-uring@lfdr.de>; Fri, 11 Dec 2020 13:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389290AbgLKMdk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 07:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389152AbgLKMdh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 07:33:37 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57448C0613CF
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 04:32:57 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id y23so8451657wmi.1
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 04:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iuslfmjgnn8MowxBrxtBtdx/eZlpOx0BnOCni6OrO38=;
        b=qXksfo3OBLmJE9Qhl/VTe3qVA3DSzvbUDrQ4h2KEThONqJ5BjesMKCkFWvwXYAXbp4
         uN54bNyokRRzySMDyb4hxmfEICpuI88MDqGLReqUCPKXW6Z750EytG9w0Xpo9bo8rOI5
         ozOU4VmjguElA6wcmsLsTlUtjLThF6IcyqQoqoeaClCqN9zTk5Hn9SUnWKeEgZPMjoj8
         AltTALjmZPOwr1W3vTAIX/OwbG9kAcWOKmuS8tVOGiWqRBTT+13nBrpiaW/P8cysLksE
         g7cJu5UYp+p8mtzIcc9lYV7FGkiK8mkjmGDtAWbFayvBZoaGaxGepEZSib3th1Z2/ZaI
         3gEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iuslfmjgnn8MowxBrxtBtdx/eZlpOx0BnOCni6OrO38=;
        b=PickW+eeJLvjkDkFzs+CS751j1hvECJa9nh07zhdvASusW5fpKZyn/dfsbJUpkcgbH
         NAEW6MCb3OyPmvVlP4VGZ8lfjlsWDZPni9lOUPRNu80MKDjb24aYU6He+upHuipw5woq
         l3Czz1o+nyddLJC/F+5/ZYcB1QE9XW5s97NaW/5Q/5gVG6wa0AJwJfbWFKLuLPDDuhcV
         CxxWVW0Zpl7jfM2H92IaxsauAUn6Spl6zxNHsFER++Dl5ykZHlaRO2B5Jj2lAE5nWlZc
         47fUurenuTKzPJED6mmSz/xoXwNG6l8Csmm4b0VGBdM3egIjutUn2nwdB84GqbnEmMtG
         ma6w==
X-Gm-Message-State: AOAM532PpmKbXV9yxoQ5l29F5vc4vvBqCeiUuDLITxvB5bSwf29Ghe/U
        /wcQgVQ+XwuTPIPay9Z40cI7LmvDDXUbNQ==
X-Google-Smtp-Source: ABdhPJxeNZ3/W6RU9/JL+TKpj8piqgYoQ8JHvgywcz5hbmH3UusmJ3inO837BsbAqyLdrt/gNahW8A==
X-Received: by 2002:a1c:ba44:: with SMTP id k65mr13334450wmf.188.1607689976120;
        Fri, 11 Dec 2020 04:32:56 -0800 (PST)
Received: from [192.168.8.123] ([85.255.234.121])
        by smtp.gmail.com with ESMTPSA id m21sm14350941wml.13.2020.12.11.04.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 04:32:55 -0800 (PST)
Subject: Re: [PATCH] io_uring: always let io_iopoll_complete() complete polled
 io.
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20201202113151.1680-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c4fa3437-49c2-4dce-471a-930ceca3aec3@gmail.com>
Date:   Fri, 11 Dec 2020 12:29:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201202113151.1680-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/12/2020 11:31, Xiaoguang Wang wrote:
> Abaci Fuzz reported a double-free or invalid-free BUG in io_commit_cqring():
> [   95.504842] BUG: KASAN: double-free or invalid-free in io_commit_cqring+0x3ec/0x8e0
> [   95.505921]
> [   95.506225] CPU: 0 PID: 4037 Comm: io_wqe_worker-0 Tainted: G    B
> W         5.10.0-rc5+ #1
> [   95.507434] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   95.508248] Call Trace:
> [   95.508683]  dump_stack+0x107/0x163
> [   95.509323]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.509982]  print_address_description.constprop.0+0x3e/0x60
> [   95.510814]  ? vprintk_func+0x98/0x140
> [   95.511399]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.512036]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.512733]  kasan_report_invalid_free+0x51/0x80
> [   95.513431]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.514047]  __kasan_slab_free+0x141/0x160
> [   95.514699]  kfree+0xd1/0x390
> [   95.515182]  io_commit_cqring+0x3ec/0x8e0
> [   95.515799]  __io_req_complete.part.0+0x64/0x90
> [   95.516483]  io_wq_submit_work+0x1fa/0x260
> [   95.517117]  io_worker_handle_work+0xeac/0x1c00
> [   95.517828]  io_wqe_worker+0xc94/0x11a0
> [   95.518438]  ? io_worker_handle_work+0x1c00/0x1c00
> [   95.519151]  ? __kthread_parkme+0x11d/0x1d0
> [   95.519806]  ? io_worker_handle_work+0x1c00/0x1c00
> [   95.520512]  ? io_worker_handle_work+0x1c00/0x1c00
> [   95.521211]  kthread+0x396/0x470
> [   95.521727]  ? _raw_spin_unlock_irq+0x24/0x30
> [   95.522380]  ? kthread_mod_delayed_work+0x180/0x180
> [   95.523108]  ret_from_fork+0x22/0x30
> [   95.523684]
> [   95.523985] Allocated by task 4035:
> [   95.524543]  kasan_save_stack+0x1b/0x40
> [   95.525136]  __kasan_kmalloc.constprop.0+0xc2/0xd0
> [   95.525882]  kmem_cache_alloc_trace+0x17b/0x310
> [   95.533930]  io_queue_sqe+0x225/0xcb0
> [   95.534505]  io_submit_sqes+0x1768/0x25f0
> [   95.535164]  __x64_sys_io_uring_enter+0x89e/0xd10
> [   95.535900]  do_syscall_64+0x33/0x40
> [   95.536465]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   95.537199]
> [   95.537505] Freed by task 4035:
> [   95.538003]  kasan_save_stack+0x1b/0x40
> [   95.538599]  kasan_set_track+0x1c/0x30
> [   95.539177]  kasan_set_free_info+0x1b/0x30
> [   95.539798]  __kasan_slab_free+0x112/0x160
> [   95.540427]  kfree+0xd1/0x390
> [   95.540910]  io_commit_cqring+0x3ec/0x8e0
> [   95.541516]  io_iopoll_complete+0x914/0x1390
> [   95.542150]  io_do_iopoll+0x580/0x700
> [   95.542724]  io_iopoll_try_reap_events.part.0+0x108/0x200
> [   95.543512]  io_ring_ctx_wait_and_kill+0x118/0x340
> [   95.544206]  io_uring_release+0x43/0x50
> [   95.544791]  __fput+0x28d/0x940
> [   95.545291]  task_work_run+0xea/0x1b0
> [   95.545873]  do_exit+0xb6a/0x2c60
> [   95.546400]  do_group_exit+0x12a/0x320
> [   95.546967]  __x64_sys_exit_group+0x3f/0x50
> [   95.547605]  do_syscall_64+0x33/0x40
> [   95.548155]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
> we'll complete req by calling io_req_complete(), which will hold completion_lock
> to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
> hold completion_lock to call io_commit_cqring(), then there maybe concurrent
> access to ctx->defer_list, double free may happen.
> 
> To fix this bug, we always let io_iopoll_complete() complete polled io.
> 
> Reported-by: Abaci Fuzz <abaci@linux.alibaba.com>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a8c136a..901ca67 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6074,8 +6074,19 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
>  	}
>  
>  	if (ret) {
> -		req_set_fail_links(req);
> -		io_req_complete(req, ret);
> +		/*
> +		 * io_iopoll_complete() does not hold completion_lock to complete
> +		 * polled io, so here for polled io, just mark it done and still let
> +		 * io_iopoll_complete() complete it.
> +		 */
> +		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> +			struct kiocb *kiocb = &req->rw.kiocb;

Also remembered that IOPOLL apart from rw can do buf reg/unreg requests, so
it won't work for them. Could you fix it?

> +
> +			kiocb_done(kiocb, ret, NULL);
> +		} else {
> +			req_set_fail_links(req);
> +			io_req_complete(req, ret);
> +		}
>  	}
>  
>  	return io_steal_work(req);
> 

-- 
Pavel Begunkov
