Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF502530054
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 04:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiEVCmk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 May 2022 22:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiEVCmj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 May 2022 22:42:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60B73EAA9
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 19:42:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l14so11120806pjk.2
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 19:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BEYJzOXAgO3ju6y7nFXErlj0Xnqfz03ITvQGsQDwCZ0=;
        b=JnC8DONHOKbMHJlWqL5gqPhE+zhCxFt7bABMG+fLtN36KqqGRHJ3mbyEAnOhFMhpTY
         +lSi9cG3TWQ7kWfIS9IaxOV9aQz/mzgCJ/aeYz1Yc8WODc2EIK7R+GJhVu0IOiSeyd1h
         uHL/ejOiKiJOzQRBHGSFF3Ji4W9MTOVQefsrCyCMUd0w6s47MIHtNllHKoCjMFIGe5TC
         XOIWUt8HFzjFBEacpvz747zfOKkrSfTKFdXY/7JsQgsWOYucgQsHRdcPchAFXvTYzRc8
         IAMLroDnwV/obMSxVvHhzLe0EgkXHZGykQ1dufSDmPQIzAW5D1uMGaS11AuTKDGe+Z20
         cXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BEYJzOXAgO3ju6y7nFXErlj0Xnqfz03ITvQGsQDwCZ0=;
        b=xETPNe11tRi29dKuuqnbk6UT+8y7FA+d0wWqyxmhSU1npv8aJO0xvXU75ELNeVHlSh
         ga6sYbSNcCXQxZyr76iAIIjakwXzRwVah3nD1icW3iV4ahZCApeoh+baKL5t2knz5Wdf
         Yk7lkxQmQeMYASaxrRMKqz2/REUD59UEZi9EbK8RS6pWSh2Z+Ig/pPNxi+NAj8OeBAoF
         McfZvguIayTy7984xpFu5n2T+TheyDnwB6Ta9uNDYy6LMI4TfwVu2p7C4uDwBoxa+1J7
         ihRh5Z0Y8Apu0VZso3O5HSGyqqf9Il5vLOlE3XG5bOtyENUB67c5jSzjWDTw3kZDFL/x
         KECQ==
X-Gm-Message-State: AOAM533zxOcl+5WXbDRR7wk0LjgAvvRK55SVtqYVqWeQZSDoF5+uBlmh
        3+wvNL0UwTp4IsQdIgnu7+pDQwVASaZeZg==
X-Google-Smtp-Source: ABdhPJzMZgaEWwQGObsTlQmGTkipXRR0npY/AmvuEuoWsjgz23PZqwcIr60ULjdDsDCLU5IhX5ltgA==
X-Received: by 2002:a17:903:2304:b0:162:ed1:ed9c with SMTP id d4-20020a170903230400b001620ed1ed9cmr3619063plh.122.1653187357427;
        Sat, 21 May 2022 19:42:37 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i62-20020a636d41000000b003c14af505f6sm2155924pgc.14.2022.05.21.19.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 May 2022 19:42:36 -0700 (PDT)
Message-ID: <00772002-8df8-3a41-6e6c-20e3854ad3f0@kernel.dk>
Date:   Sat, 21 May 2022 20:42:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: add a schedule condition in io_submit_sqes
Content-Language: en-US
To:     Guo Xuenan <guoxuenan@huawei.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
Cc:     houtao1@huawei.com, yi.zhang@huawei.com, chengzhihao1@huawei.com,
        linux-kernel@vger.kernel.org
References: <20220521143327.3959685-1-guoxuenan@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220521143327.3959685-1-guoxuenan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/21/22 8:33 AM, Guo Xuenan wrote:
> when set up sq ring size with IORING_MAX_ENTRIES, io_submit_sqes may
> looping ~32768 times which may trigger soft lockups. add need_resched
> condition to avoid this bad situation.
> 
> set sq ring size 32768 and using io_sq_thread to perform stress test
> as follows:
> watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [iou-sqp-600:601]
> Kernel panic - not syncing: softlockup: hung tasks
> CPU: 2 PID: 601 Comm: iou-sqp-600 Tainted: G L 5.18.0-rc7+ #3
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  dump_backtrace+0x218/0x228
>  show_stack+0x20/0x68
>  dump_stack_lvl+0x68/0x84
>  dump_stack+0x1c/0x38
>  panic+0x1ec/0x3ec
>  watchdog_timer_fn+0x28c/0x300
>  __hrtimer_run_queues+0x1d8/0x498
>  hrtimer_interrupt+0x238/0x558
>  arch_timer_handler_virt+0x48/0x60
>  handle_percpu_devid_irq+0xdc/0x270
>  generic_handle_domain_irq+0x50/0x70
>  gic_handle_irq+0x8c/0x4bc
>  call_on_irq_stack+0x2c/0x38
>  do_interrupt_handler+0xc4/0xc8
>  el1_interrupt+0x48/0xb0
>  el1h_64_irq_handler+0x18/0x28
>  el1h_64_irq+0x74/0x78
>  console_unlock+0x5d0/0x908
>  vprintk_emit+0x21c/0x470
>  vprintk_default+0x40/0x50
>  vprintk+0xd0/0x128
>  _printk+0xb4/0xe8
>  io_issue_sqe+0x1784/0x2908
>  io_submit_sqes+0x538/0x2880
>  io_sq_thread+0x328/0x7b0
>  ret_from_fork+0x10/0x20
> SMP: stopping secondary CPUs
> Kernel Offset: 0x40f1e8600000 from 0xffff800008000000
> PHYS_OFFSET: 0xfffffa8c80000000
> CPU features: 0x110,0000cf09,00001006
> Memory Limit: none
> ---[ end Kernel panic - not syncing: softlockup: hung tasks ]---
> 
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 92ac50f139cd..d897c6798f00 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7864,7 +7864,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>  			if (!(ctx->flags & IORING_SETUP_SUBMIT_ALL))
>  				break;
>  		}
> -	} while (submitted < nr);
> +	} while (submitted < nr && !need_resched());
>  
>  	if (unlikely(submitted != nr)) {
>  		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;

This is wrong, you'll potentially end up doing random short submits for
non-sqpoll as well.

sqpoll already supports capping how many it submits in one go, it just
doesn't do it if it's only running one ring. As simple as the below,
with 1024 pulled out of thin air. Would be great if you could experiment
and submit a v2 based on this principle instead. Might still need a
cond_resched() carefully placed in io_sq_thread().

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0823f58f795..3830d7b493b9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7916,7 +7916,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 	unsigned int to_submit;
 	int ret = 0;
 
-	to_submit = io_sqring_entries(ctx);
+	/* cap at 1024 to avoid doing too much in one submit round */
+	to_submit = min(io_sqring_entries(ctx), 1024U);
 	/* if we're handling multiple rings, cap submit size for fairness */
 	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;

-- 
Jens Axboe

