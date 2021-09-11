Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728A8407A9F
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 00:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhIKWPL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 18:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhIKWPK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 18:15:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB64C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 15:13:57 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id a15so7079129iot.2
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 15:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zhpboo7aeBXoYxjIrcmTPfxZm9hyF8cFybk8GpJYdLY=;
        b=IgAZ6h8//o+ZVOe6wo8qMb8zdTP38b0w6iCo4hGwRMgo4y6bwFCrMERN0LYkAakt3x
         c36gyuzMWHFokLpVEAbW4uw+giMynU0DwEGdz95g2Ab5Tg6xOK0+Jmhd8wq9YPoJ2h3b
         nYC6zhTYx17R9cb0wHBTMd+ZGB2x5RiTBN+XUp+lfW8W7yqRPODpXP/F1/lJClaeoinJ
         VCNY7gW7Xt92Ogt3ZMtIuGHhS9mkmT9zFDJ8vuUkM222Z3BVOQnhrRjqhljmD42Lti/I
         twTm9YIJgWUv0MT5L0GNGPvIigUr28NSdU4wNwZlmINS6FVPH+p9ef6AQA6+x4Gv6lfG
         E6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zhpboo7aeBXoYxjIrcmTPfxZm9hyF8cFybk8GpJYdLY=;
        b=dCIGVijzwddh5u53XrQgHLnziik2SSkJfNLJcoOcpnXLEvx73bIHC0e63V22YEv5hD
         Vd/TFWQ6sdg7iHZSMzS5im72HFuJlunpXVNOo8lbrsl2ImAwI01BQ9lLcSIaEyzD2pvm
         6E5XFJQtbDkq5ndgWwnwvM2yinkL4tKdV9aQq5yvVbV1AMdjuwCGf9WbDfvyGG8AOe80
         46gVb4CMbWXvyfTopnqJAi20NoSlcDgPZFTH1LaaEA7A1AGxwYYaaECJe4nxn11JLhJO
         js0W2lssBOqUW6spy6eBV8ct9D6tdxEqNNcPBmYCs7KALR1ghy9mtfdJm9y9FHGUHkRo
         Cqcw==
X-Gm-Message-State: AOAM5333tLQQ4AEXNsz92c4CCmRN7XskiPTzjqX3p8gI2XY33mdQRjxy
        G5HsjE/wLNxUm+YdkKJJuETFiTO/zyhPog==
X-Google-Smtp-Source: ABdhPJz8anYigHQZK1wCNEAHa9LNDQ7SqGiTk3EAvgokn/i5wLCgRspZuXmZh9iuBJZn/YBB5Qvzsg==
X-Received: by 2002:a5e:8e4c:: with SMTP id r12mr3249363ioo.73.1631398436964;
        Sat, 11 Sep 2021 15:13:56 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s13sm968001ilh.21.2021.09.11.15.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 15:13:56 -0700 (PDT)
Subject: Re: [PATCH 3/4] io-wq: fix worker->refcount when creating worker in
 work exit
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-4-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e9ca65e1-46d7-de2d-e897-8cb3393c88f2@kernel.dk>
Date:   Sat, 11 Sep 2021 16:13:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210911194052.28063-4-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 1:40 PM, Hao Xu wrote:
> We may enter the worker creation path from io_worker_exit(), and
> refcount is already zero, which causes definite failure of worker
> creation.
> io_worker_exit
>                               ref = 0
> ->io_wqe_dec_running
>   ->io_queue_worker_create
>     ->io_worker_get           failure since ref is 0
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 0e1288a549eb..75e79571bdfd 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -188,7 +188,9 @@ static void io_worker_exit(struct io_worker *worker)
>  	list_del_rcu(&worker->all_list);
>  	acct->nr_workers--;
>  	preempt_disable();
> +	refcount_set(&worker->ref, 1);
>  	io_wqe_dec_running(worker);
> +	refcount_set(&worker->ref, 0);

That kind of refcount manipulation is highly suspect. And in fact it
should not be needed, io_worker_exit() clears ->flags before going on
with worker teardown. Hence you can't hit worker creation from
io_wqe_dec_running().

-- 
Jens Axboe

