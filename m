Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBF543C73E
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhJ0KDe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 06:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbhJ0KD0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 06:03:26 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACE2C061237;
        Wed, 27 Oct 2021 03:00:19 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j35-20020a05600c1c2300b0032caeca81b7so2609977wms.0;
        Wed, 27 Oct 2021 03:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sVL40Dal23g+oTbNPT/e2XPj/Wo7WL5CwzUJYNKbLdw=;
        b=CxfHDOj6sDUACNtdKs4jVTqIEmS01m02gbVy/3TKFUkBUpWF9wPAgXDIQayPUDqCEh
         hgEVMSI3ES4LJ1GO6mIqbk6zwFo8qSRHF0o/eAb6Oy6BEGkBaRwS73YqYkZ2kvmuhnWX
         o2g8tyh1Cck19wiPg4opeNaV+gYX3hsgxNcwQF0Ot51IyRoSt8rJXDJeX5Em/kY1U6XT
         SHuTsDAzsQyO4vGZSR8VxuJwVy7SpP3FQxXNFjjPoA+MnJKfE/JdJff+q2zIdln/DYfl
         t6DF5VQl70qHFeshd8yBzgEDlprwpjRysWsrVcEPWSExBk/0poOVPRdnpMc/vH/7Yo2q
         KSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sVL40Dal23g+oTbNPT/e2XPj/Wo7WL5CwzUJYNKbLdw=;
        b=B4XUHykRENiHR9w4kmOKaAB+hiFbqRs/cNYJkNS4S9L3GJGaDSM7j00juZ8+jCJreL
         9waWk6+q8IP8x0oOe6X6hFTn0mhRiLv86icTPmuuOjWAECgj3TsSEfJGGrwdpw958U+Y
         4OzC5luDQRKOsKOcV3srqJTc44erHSPJ0oncRIrgUYTGFKrl0eUz2G7dJycs24nwrcFa
         oBTQBrDkOXcWI/DIHamJkPerKw0yahAVGJGbNaSSd2yiiIeVLvSIxbJuwJBhswd5UCA9
         hdKB9SqS/PjR6hKTVLgFpZ6FZMelGjRLy0kcvAI7iIQnFb/8m6YSrTkzAT5b6D63uo23
         Nt1Q==
X-Gm-Message-State: AOAM5321MxKGYhnL8V7G0f2JlWhlUv0sYwQAIKvhNdrzTrWDhtnhGfzk
        Nwk9hmpe9aSLgGpZv0/hfgI=
X-Google-Smtp-Source: ABdhPJyguHvObOm7lVDICq2QVmWS9gg3Gwx7YYLpgE+5/TsBcILHLhOKLVWquOQjDv3An1qomMYuoQ==
X-Received: by 2002:a7b:cc11:: with SMTP id f17mr4779203wmh.122.1635328818497;
        Wed, 27 Oct 2021 03:00:18 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.132.100])
        by smtp.gmail.com with ESMTPSA id u13sm21998993wri.50.2021.10.27.03.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 03:00:18 -0700 (PDT)
Message-ID: <27d0d7bd-a5c3-27ca-03b3-ea3c5c363380@gmail.com>
Date:   Wed, 27 Oct 2021 10:56:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] io_uring: fix a GCC warning in wq_list_for_each()
Content-Language: en-US
To:     Qian Cai <quic_qiancai@quicinc.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211025145906.71955-1-quic_qiancai@quicinc.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211025145906.71955-1-quic_qiancai@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/21 15:59, Qian Cai wrote:
> fs/io_uring.c: In function '__io_submit_flush_completions':
> fs/io_uring.c:2367:33: warning: variable 'prev' set but not used
> [-Wunused-but-set-variable]
>   2367 |  struct io_wq_work_node *node, *prev;
>        |                                 ^~~~
> 
> Fixed it by open-coded the wq_list_for_each() without an unused previous
> node pointer.

That's intentional, the var is optimised out and it's better to
not hand code it (if possible).


> Fixes: 6f33b0bc4ea4 ("io_uring: use slist for completion batching")
> Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
> ---
>   fs/io_uring.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 23641d9e0871..b8968bd43e3f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2361,11 +2361,11 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>   static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	__must_hold(&ctx->uring_lock)
>   {
> -	struct io_wq_work_node *node, *prev;
> +	struct io_wq_work_node *node;
>   	struct io_submit_state *state = &ctx->submit_state;
>   
>   	spin_lock(&ctx->completion_lock);
> -	wq_list_for_each(node, prev, &state->compl_reqs) {
> +	for (node = state->compl_reqs.first; node; node = node->next) {
>   		struct io_kiocb *req = container_of(node, struct io_kiocb,
>   						    comp_list);
>   
> 

-- 
Pavel Begunkov
