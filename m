Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9299F7B162E
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjI1Iik (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 04:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjI1Iii (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 04:38:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155BDAC
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 01:38:36 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9b28dee4de8so195121066b.1
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 01:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695890314; x=1696495114; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wuYxot8Q91wdZ8ud9VYjbykM6rJR3TDzyBn5TR9Ntpk=;
        b=WkQrBe9fCwE32iO+/k4MhqCMkiOXBVM+LYFQ6RFNw4YgZkhlW4nYWj4Ir0zp58ArSl
         aaMyr3gYtKNOYZcIvjr8xfunsGUom8bMwcW1iTkJvFy5HzLoT+aqUaczm6XLkQzIcF4k
         LgUmBaDDEtkL78zzHHgdpLF6tZoLf1aiQR47cKZJRPt+7n9L8/yNugU6EChvgZf4+h0d
         jEFfQpvC9x/fFCeDVhojhVpt4xcUPmi4r5r4zL0rHSVZntwy+AEAniKYsmhYp19oT6ot
         DLUwP7emL/IC3Vj7kNZORzqEVVgT5gA3Ur8hgN0eBFP8L5iffAhChh6oc1RiKhcKYw2A
         SKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695890314; x=1696495114;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wuYxot8Q91wdZ8ud9VYjbykM6rJR3TDzyBn5TR9Ntpk=;
        b=n23H8v6gUttV9FHg4qOyiF+LfcfedtnZeu2frhPSGpvtWLzOYa2C9jdiFzSk00w3wG
         J45/6OVB+/d28ncrK3RgdMwT69nrfPzw3rz88eRn/iOKxm7El4zWodx6mfmBJ5+Ts2k1
         iUy6SC22jq6LGsYs/zx5WQkGJW7zqWgcEYG+IuQgzXlzBEwMi870uuJRzRz2dkNl0f96
         /IvKZ4/maT1ympP73llDfNLU/BjkmWTK9H9mZjxO4HqzNlTDHAL1A1bj95dKOMKkQtrb
         ZWoZxkOy4aNcgI2Iu4c/qWNf4GC5Q73pDLC6JLoszYhKWLSNE3G/TSNR/D1yMyxpZU/I
         zN2A==
X-Gm-Message-State: AOJu0YyWzMTbE+tqhvXqt0TLkk8Y5w0yuhPN0B/WnapnVnLrHCWS3HjC
        GgVZyhDGam04DAJbzs7JtDoILQ==
X-Google-Smtp-Source: AGHT+IFU7Pu/SQr5RMBMykXCBrA3nYMjr/Id6q5BU6eCMZpnrzzT8v2mhrxgPMYMqhs1nYLMiqpyqw==
X-Received: by 2002:a17:906:19b:b0:9ad:e1e2:3595 with SMTP id 27-20020a170906019b00b009ade1e23595mr585205ejb.7.1695890314316;
        Thu, 28 Sep 2023 01:38:34 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id i13-20020a1709061ccd00b00989828a42e8sm10521652ejh.154.2023.09.28.01.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 01:38:33 -0700 (PDT)
Message-ID: <c4598c93-fe5d-49d3-b737-e78b7abcea77@kernel.dk>
Date:   Thu, 28 Sep 2023 02:38:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] io_uring: cancelable uring_cmd
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
References: <20230923025006.2830689-1-ming.lei@redhat.com>
 <20230923025006.2830689-3-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230923025006.2830689-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/23 8:50 PM, Ming Lei wrote:
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index ae08d6f66e62..a0307289bdc7 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -20,9 +20,13 @@ enum io_uring_cmd_flags {
>  	IO_URING_F_SQE128		= (1 << 8),
>  	IO_URING_F_CQE32		= (1 << 9),
>  	IO_URING_F_IOPOLL		= (1 << 10),
> +
> +	/* set when uring wants to cancel one issued command */
> +	IO_URING_F_CANCEL		= (1 << 11),
>  };

I'd make that comment:

/* set when uring wants to cancel a previously issued command */

> @@ -125,6 +132,15 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
>  {
>  	return -EOPNOTSUPP;
>  }
> +static inline int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> +		unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}

Do we need this to return an error? Presumably this will never get
called if IO_URING isn't defined, but if it does, it obviously doesn't
need to do anything anyway. Seems like it should just be a void, and
ditto for the enabled version which can't return an error anyway.

>  	return ret;
>  }
>  
> +static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> +		struct task_struct *task, bool cancel_all)
> +{
> +	struct hlist_node *tmp;
> +	struct io_kiocb *req;
> +	bool ret = false;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
> +			hash_node) {
> +		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
> +				struct io_uring_cmd);
> +		struct file *file = req->file;
> +
> +		if (WARN_ON_ONCE(!file->f_op->uring_cmd))
> +			continue;

That check belongs in the function that marks it cancelable and adds it
to the list.

Outside of those minor nits, looks fine to me, and patch 1 does too.

-- 
Jens Axboe

