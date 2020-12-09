Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37CB2D4190
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 13:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbgLIL6W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 06:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730662AbgLIL6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 06:58:22 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC398C0613D6;
        Wed,  9 Dec 2020 03:57:41 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r7so1437899wrc.5;
        Wed, 09 Dec 2020 03:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cdRIiwkVJEG5Ajl0dxpUR79S5sWIGhpx5l6HK+iY5es=;
        b=vKqCSgEalD/0gQicEZyfVoA7lr+nZhQZXcIEYlFghlTlnndrLNIaQXPnzziUzCnpIe
         BoqOWxuipr2UxSO2VzhlG8pYj03hFiR3BnQlxczfK97oRNnzGIX5bYPFr0U4TFlgGYl3
         pVz8iV83/jLzQ3Pu9rkUY6OyW1ogS1m2lQLCL1zj5AW7HX1X6BcePYsTP5KGb2N1iAi6
         NdMFez3FnVLPlAJ8bT/E/tlbudYTq9xCSDxJyCAyPXkjCMpIO8BlpdgGFIo5XY1gWrlO
         hYYuy67Ggn+xS7uUsp8sFe8btIq48fO/QMgvWx0OYck8E7RmrZSXNqssXPSAHKBMvfaD
         jYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cdRIiwkVJEG5Ajl0dxpUR79S5sWIGhpx5l6HK+iY5es=;
        b=ejpdRmdak1oGoPxRMI+kTMPQPXY2AEP0M+kS4eIjsz58pQMw9Uqcp5ptLcQQEpNHKB
         7HiCUTeySXyGBbWFJLczT7nbZyYLIe8GyjRTo9pyshKVwQRKCGRcMKU8MB8BVDUmccGG
         m9PN0pDRvt4kwUMdv0VV/3qrhEHvNQlU6Cpuk/F69S0A+PXBkYkUSlUFpsCoZWrbBSFw
         9Ba3JN4wc0wNofnh+EBzhR5Ug60wBag58h12PGy93hwnH5UiQ38Nqma0EZTsThE4ojyQ
         1ChNl5uhmfCu4wgbgv/Lf8cqsYlKjGweHwlYFxaOJl1GgLha9idaQYLqVxt3w93G2FUV
         BmeQ==
X-Gm-Message-State: AOAM5322xzjW0U+ftSl0jZN4JHr6o0P05KYorQTHrywtJURIGBMHvn2e
        RwKHv8U93s/zfKBn0IaLOg4=
X-Google-Smtp-Source: ABdhPJzprwBg8zaNq5QqmC+WywEqntktJ2uHFjdkUOlPR1psMS3HMfNtAaOp+u0OQEueaNeJaKCciw==
X-Received: by 2002:adf:f146:: with SMTP id y6mr2354239wro.298.1607515060630;
        Wed, 09 Dec 2020 03:57:40 -0800 (PST)
Received: from [192.168.8.121] ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id n3sm432041wra.13.2020.12.09.03.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 03:57:40 -0800 (PST)
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
 <20201209083645.GB21968@infradead.org> <20201209090646.GA28832@infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Message-ID: <d6bc5a8f-2bfc-2b13-c307-00677f0f53b0@gmail.com>
Date:   Wed, 9 Dec 2020 11:54:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201209090646.GA28832@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/12/2020 09:06, Christoph Hellwig wrote:
> On Wed, Dec 09, 2020 at 08:36:45AM +0000, Christoph Hellwig wrote:
>> This is making the iter type even more of a mess than it already is.
>> I think we at least need placeholders for 0/1 here and an explicit
>> flags namespace, preferably after the types.
>>
>> Then again I'd much prefer if we didn't even add the flag or at best
>> just add it for a short-term transition and move everyone over to the
>> new scheme.  Otherwise the amount of different interfaces and supporting
>> code keeps exploding.

At least the flag can be ignored. Anyway sounds good to me. I'll take
your patch below to the series, thanks!

> 
> Note that the only other callers that use iov_iter_bvec and asynchronous
> read/write are loop, target and nvme-target, so this should actually
> be pretty simple.  Out of these only target needs something like this
> trivial change to keep the bvec available over the duration of the I/O,
> the other two should be fine already:
> 
> ---
> From 581a8eabbb1759e3dcfee4b1d2e419f814a8cb80 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 9 Dec 2020 10:05:04 +0100
> Subject: target/file: allocate the bvec array as part of struct target_core_file_cmd
> 
> This saves one memory allocation, and ensures the bvecs aren't freed
> before the AIO completion.  This will allow the lower level code to be
> optimized so that it can avoid allocating another bvec array.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/target/target_core_file.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 7143d03f0e027e..ed0c39a1f7c649 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -241,6 +241,7 @@ struct target_core_file_cmd {
>  	unsigned long	len;
>  	struct se_cmd	*cmd;
>  	struct kiocb	iocb;
> +	struct bio_vec	bvecs[];
>  };
>  
>  static void cmd_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
> @@ -268,29 +269,22 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  	struct target_core_file_cmd *aio_cmd;
>  	struct iov_iter iter = {};
>  	struct scatterlist *sg;
> -	struct bio_vec *bvec;
>  	ssize_t len = 0;
>  	int ret = 0, i;
>  
> -	aio_cmd = kmalloc(sizeof(struct target_core_file_cmd), GFP_KERNEL);
> +	aio_cmd = kmalloc(struct_size(aio_cmd, bvecs, sgl_nents), GFP_KERNEL);
>  	if (!aio_cmd)
>  		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  
> -	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
> -	if (!bvec) {
> -		kfree(aio_cmd);
> -		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> -	}
> -
>  	for_each_sg(sgl, sg, sgl_nents, i) {
> -		bvec[i].bv_page = sg_page(sg);
> -		bvec[i].bv_len = sg->length;
> -		bvec[i].bv_offset = sg->offset;
> +		aio_cmd->bvecs[i].bv_page = sg_page(sg);
> +		aio_cmd->bvecs[i].bv_len = sg->length;
> +		aio_cmd->bvecs[i].bv_offset = sg->offset;
>  
>  		len += sg->length;
>  	}
>  
> -	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
> +	iov_iter_bvec(&iter, is_write, aio_cmd->bvecs, sgl_nents, len);
>  
>  	aio_cmd->cmd = cmd;
>  	aio_cmd->len = len;
> @@ -307,8 +301,6 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  	else
>  		ret = call_read_iter(file, &aio_cmd->iocb, &iter);
>  
> -	kfree(bvec);
> -
>  	if (ret != -EIOCBQUEUED)
>  		cmd_rw_aio_complete(&aio_cmd->iocb, ret, 0);
>  
> 

-- 
Pavel Begunkov
