Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B43233FCF2
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 02:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCRB6L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 21:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhCRB5q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 21:57:46 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4154C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 18:57:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b184so2394508pfa.11
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 18:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/AblZbqG1zvhUU4AtoW11+9MHGqRD3cJF+pFxBcZ/J4=;
        b=q/ov1maYChXBxVyui08P8Y90pRBvikFIfN+RGHIIAhB4VM7OTakFDPmwOQSlWh+ZYp
         qMbrFbo0DXj1M+gJ8+iEAnR7Chywnq6e+FYSF1A743SH4l9z0O/WhzcpI1fdohdiI/u5
         H2S8Xy6j60oh/VAEdxAwt5dd9YK4R9VnvPqtww8KlaiIrJVJPgPscP+FeYEC1FVbjEj+
         dQ5NRXkXem1qQszQVds9QbO40CnTbfS/0HKaTFNQ9NyTytYri12yjER/tSXmxCABGpyK
         F0dnfW4JIRchAF1u8cpui5iXphCbwXZ1ztNPoPyjpsR1S2tA7eB1ZEelyBq2NnDPFlZQ
         AjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/AblZbqG1zvhUU4AtoW11+9MHGqRD3cJF+pFxBcZ/J4=;
        b=KvIFipa2wnc7s/sE2NDpwR+wkOay4mWmIrTVK37EAez/2JLO/W83mZdae3Vlo5Eb1s
         y9mTb4BR063TK81Oky9hMQujT48DU86rUXhQDuzLuEzCtXbeBi0mV8KGefdUtDpBRe/p
         XOJmvTAlHeAnhayZa7hewA5cc7FqUwsRhAIhhp0sgUCxmfsqca2V2gA89+URBZy9OO+h
         nd9TRi24XGKfA1WHmVc3Q9Js0NaiGmoPP3dXyHKZTFT7crUp6hENJ6ImbXNehyT/qHMs
         gN2eK3dOFDPkq3GfY/RehVIjjRybnvOIX9/VbWUvC2uHIi58KLiOoH0dkDXS6vmRIvnH
         9wlw==
X-Gm-Message-State: AOAM530mRIcspjVL3aykblMaFnaECYN7/2knFY5qYx2rVJQ0lUbEq3nw
        9DAqcgNXH96w+tWjbaAc4Q0uXHthFzbcaA==
X-Google-Smtp-Source: ABdhPJxZSYlz4Wxp13k7Kza1gBmiA3e3SuqHF6nx0sejGX3ol1ARi9dTZqDJ7opVJ6EzOwt+314Hjg==
X-Received: by 2002:a05:6a00:a83:b029:1ed:55fc:e22a with SMTP id b3-20020a056a000a83b02901ed55fce22amr1728155pfl.45.1616032666076;
        Wed, 17 Mar 2021 18:57:46 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k128sm325953pfd.137.2021.03.17.18.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 18:57:45 -0700 (PDT)
Subject: Re: [RFC PATCH v3 1/3] io_uring: add helper for uring_cmd completion
 in submitter-task
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140233epcas5p372405e7cb302c61dba5e1094fa796513@epcas5p3.samsung.com>
 <20210316140126.24900-2-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05a91368-1ba8-8583-d2ab-8db70b92df76@kernel.dk>
Date:   Wed, 17 Mar 2021 19:57:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210316140126.24900-2-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/21 8:01 AM, Kanchan Joshi wrote:
> Completion of a uring_cmd ioctl may involve referencing certain
> ioctl-specific fields, requiring original subitter context.
> Introduce 'uring_cmd_complete_in_task' that driver can use for this
> purpose. The API facilitates task-work infra, while driver gets to
> implement cmd-specific handling in a callback.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  fs/io_uring.c            | 36 ++++++++++++++++++++++++++++++++----
>  include/linux/io_uring.h |  8 ++++++++
>  2 files changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 583f8fd735d8..ca459ea9cb83 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -772,9 +772,12 @@ struct io_kiocb {
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> -
> -	/* opcode allocated if it needs to store data for async defer */
> -	void				*async_data;
> +	union {
> +		/* opcode allocated if it needs to store data for async defer */
> +		void				*async_data;
> +		/* used for uring-cmd, when driver needs to update in task */
> +		void (*driver_cb)(struct io_uring_cmd *cmd);
> +	};

I don't like this at all, it's very possible that we'd need async
data for passthrough commands as well in certain cases. And what it
gets to that point, we'll have no other recourse than to un-unionize
this and pay the cost. It also means we end up with:

> @@ -1716,7 +1719,7 @@ static void io_dismantle_req(struct io_kiocb *req)
>  {
>  	io_clean_op(req);
>  
> -	if (req->async_data)
> +	if (io_op_defs[req->opcode].async_size && req->async_data)
>  		kfree(req->async_data);
>  	if (req->file)
>  		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));

which are also very fragile.

We already have the task work, just have the driver init and/or call a
helper to get it run from task context with the callback it desires?

If you look at this:

> @@ -2032,6 +2035,31 @@ static void io_req_task_submit(struct callback_head *cb)
>  	__io_req_task_submit(req);
>  }
>  
> +static void uring_cmd_work(struct callback_head *cb)
> +{
> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> +	struct io_uring_cmd *cmd = &req->uring_cmd;
> +
> +	req->driver_cb(cmd);
> +}
> +int uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> +			void (*driver_cb)(struct io_uring_cmd *))
> +{
> +	int ret;
> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> +
> +	req->driver_cb = driver_cb;
> +	req->task_work.func = uring_cmd_work;
> +	ret = io_req_task_work_add(req);
> +	if (unlikely(ret)) {
> +		req->result = -ECANCELED;
> +		percpu_ref_get(&req->ctx->refs);
> +		io_req_task_work_add_fallback(req, io_req_task_cancel);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(uring_cmd_complete_in_task);

Then you're basically jumping through hoops to get that callback.
Why don't you just have:

io_uring_schedule_task(struct io_uring_cmd *cmd, task_work_func_t cb)
{
	struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
	int ret;

	req->task_work.func = cb;
	ret = io_req_task_work_add(req);
	if (unlikely(ret)) {
		req->result = -ECANCELED;
		io_req_task_work_add_fallback(req, io_req_task_cancel);
	}
	return ret;
}

?

Also, please export any symbol with _GPL. I don't want non-GPL drivers
using this infrastructure.

-- 
Jens Axboe

