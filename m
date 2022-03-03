Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587A14CBEFA
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 14:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiCCNiz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 08:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCCNiy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 08:38:54 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DA2E02D1
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 05:38:08 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i1so4575633plr.2
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 05:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uhKqP3Knf5+HcFUmwClj74BNMns/wzNwE9V9s9mjHOk=;
        b=dJBuoScUqBESSvMxZUKCtBXOazvulrMk7+OEYrP2OrEHp7HPnKYoOCwbeS3GzO/BN3
         lR2DGsBzhRmLqEIDoUzzeH67TJrryrIIHcUqlOLrFUdYiGqIUWOAoP6FBKdN87nS1x/q
         1CT0g9F2IVi0XoR6j2AItAqYNkmxOZKl3JUyXVAac38yIkSodhsFD9IQ1BVlFgB73uxj
         gt7yTOPvHKVlPxaVuVdGUbifpviZUf6ms71g+Ej4BxH8Dts0ALEzWkL1xwR5BpheUeni
         HWyXBhaUIOIZZmjXZg0LeUTceWNrVZMCaoMhqAycTq3Bt40a4NHjPcAjGrPOjR8fZEKN
         A7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uhKqP3Knf5+HcFUmwClj74BNMns/wzNwE9V9s9mjHOk=;
        b=y+upoV7tHnPROGGT5rkDSlgoVVJpopbwva9u/fB0efvj61x1zblNCupIUfO8GGzuSm
         Gq/nHFgL196VnUF2t3fN9CNsHaUavO8YwkVfeg/lt+hXK31OnR0VHGINEOOiyXSauCqy
         fU9hCeProOhS7q+lNqvqso/8nsE/aN5uKuwhqceADbTyUvUetkv1inwcZzgdgpVL9ZGv
         k7Pd6Pvs+g/Rrop6618NZ6lP4QRUwHgSSg4PfBmlu9QaXdXg9H/R3aulTSm4WrLTFWF9
         9PNcoginWe7vBwnencsE1WQgz5wsTHTEfBg7KLXGHCiYR6QTmZLbgcIxrtPg52gTaTiA
         cHsA==
X-Gm-Message-State: AOAM530XE5vfHcOEDlPwjPS0bh1HJBhN8ib/G4qlCR33BR5+0kGVqwGq
        0vJlrE1xSKCpTaBft2BuDcPfqA==
X-Google-Smtp-Source: ABdhPJzZlKknDEIORmO3/4kM0Vcdk+rQRK7BDstUQhe5ZelLeReJuPaALhj3sI14hmW4ca+PTiHAGg==
X-Received: by 2002:a17:902:aa86:b0:150:25f4:f43d with SMTP id d6-20020a170902aa8600b0015025f4f43dmr31993815plr.141.1646314688194;
        Thu, 03 Mar 2022 05:38:08 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s14-20020a056a0008ce00b004f66dcd4f1csm2732327pfu.32.2022.03.03.05.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 05:38:07 -0800 (PST)
Message-ID: <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
Date:   Thu, 3 Mar 2022 06:38:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/22 10:28 PM, Xiaoguang Wang wrote:
> IORING_REGISTER_FILES is a good feature to reduce fget/fput overhead for
> each IO we do on file, but still left one, which is io_uring_enter(2).
> In io_uring_enter(2), it still fget/fput io_ring fd. I have observed
> this overhead in some our internal oroutine implementations based on
> io_uring with low submit batch. To totally remove fget/fput overhead in
> io_uring, we may add a small struct file cache in io_uring_task and add
> a new IORING_ENTER_FIXED_FILE flag. Currently the capacity of this file
> cache is 16, wihcih I think it maybe enough, also not that this cache is
> per-thread.

Would indeed be nice to get rid of, can be a substantial amount of time
wasted in fdget/fdput. Does this resolve dependencies correctly if
someone passes the ring fd? Adding ring registration to test/ring-leak.c
from the liburing repo would be a useful exercise.

Comments below.

> @@ -8739,8 +8742,16 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
>  	if (unlikely(!tctx))
>  		return -ENOMEM;
>  
> +	tctx->registered_files = kzalloc(sizeof(struct file *) * IO_RINGFD_REG_MAX,
> +					 GFP_KERNEL);

kcalloc()

> +static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool locked);
> +
> +static int io_ringfd_register(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +	struct io_uring_fd_reg reg;
> +	struct io_uring_task *tctx;
> +	struct file *file;
> +	int ret;
> +
> +	if (copy_from_user(&reg, arg, sizeof(struct io_uring_fd_reg)))
> +		return -EFAULT;
> +	if (reg.offset > IO_RINGFD_REG_MAX)
> +		return -EINVAL;
> +
> +	ret = io_uring_add_tctx_node(ctx, true);
> +	if (unlikely(ret))
> +		return ret;

Can we safely drop ctx->uring_lock around this call instead? The locked
argument is always kind of ugly, and you currently have a deadlock as
far as I can tell from io_uring_alloc_task_context() that now holds
ctx->uring_lock, and then calling io_init_wq_offload() which will grab
it again.

Why not just use io_uring_rsrc_update here rather than add a new type?

-- 
Jens Axboe

