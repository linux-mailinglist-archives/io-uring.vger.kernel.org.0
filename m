Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CE330DFE3
	for <lists+io-uring@lfdr.de>; Wed,  3 Feb 2021 17:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBCQkQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Feb 2021 11:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhBCQkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Feb 2021 11:40:02 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E519C061573
        for <io-uring@vger.kernel.org>; Wed,  3 Feb 2021 08:39:22 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id u14so262217wmq.4
        for <io-uring@vger.kernel.org>; Wed, 03 Feb 2021 08:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jRL2H8ZutcVky/K2ZMax7tjBC21r54h3XmcfYmEi7iE=;
        b=ZDsYHK4Mg009kh0yTk59wmzoCBRsfurn8zSD3zgMk5JKT/IuyKapZ0SlZSHV3ebtqS
         11Kr5JVe1u+MLaQjog1a91znSa64Ncoi2e/fKWtA+gVszujLMiqbdydTNN6sO8oM8iPO
         L+B1DI1bWhyGQkClMFapHi5tsFTCi5UEUxOu4TBTLZzSo6/q5A0lwHW8GQhzBV+7Mwf/
         OT+IhQkKYfXLRZV1qfye5quwe01iL8/0kAtG3nNfFfEFVHnivZK8j69CWIN1or3ZWUgJ
         VyksfaTtjbj+o6Z8bAVGGmcWwCERwDnGXTOT8pntjc1CmqG2VAwNKwRivpquexwIWz9E
         FszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jRL2H8ZutcVky/K2ZMax7tjBC21r54h3XmcfYmEi7iE=;
        b=ie/jHkwIkROLGfQ+OmQ2crYKifaACYvG/S5c4GBwsEzdShyzbdlc2MF7+TnMfWVFy3
         2vu6j+a3CZwQFiy8amex83Fj32/FJNiuiKEZhdDR9ke4M3zleYsCCeut6JO9LKR/LAV7
         mJvhaED1VnCC454bJ1EEASBEc5J1hrHZ5DY9fIKqFsfVh9vlqlOn3r+A+2/G5CeoZs8p
         oTupuD+TgTMT5VWmsq5ZM0wUA48VtLsUeOqVCptXhw3b83NsPxIw+v2PxtckyRvQCgnx
         076l00c7xKpOx7Iio9IUgcqmYdtzxTg2AFerEQZMmJGioQBG2GcQIFzOAGzvritdvz9e
         vWRA==
X-Gm-Message-State: AOAM532MPGVs/ypTK40KErvv4S3z5Ai+11EgzfaQQyjhwgjNSotcz5+S
        DlEldZMcp/c3WusMLnqM1NM=
X-Google-Smtp-Source: ABdhPJz/IdOBjlVrWbTCer7qkoNTOmvrPFyMS4MSNNXG922/w2Frh9xlX43wnM/XMAVaiLrMwivu2g==
X-Received: by 2002:a7b:c76e:: with SMTP id x14mr3461248wmk.17.1612370360989;
        Wed, 03 Feb 2021 08:39:20 -0800 (PST)
Received: from [192.168.8.171] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id o17sm4396874wrm.52.2021.02.03.08.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 08:39:20 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: don't hold uring_lock when calling
 io_run_task_work*
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-3-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c97beeca-f401-3a21-5d8d-aa53a4292c03@gmail.com>
Date:   Wed, 3 Feb 2021 16:35:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1612364276-26847-3-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/02/2021 14:57, Hao Xu wrote:
> This is caused by calling io_run_task_work_sig() to do work under
> uring_lock while the caller io_sqe_files_unregister() already held
> uring_lock.
> we need to check if uring_lock is held by us when doing unlock around
> io_run_task_work_sig() since there are code paths down to that place
> without uring_lock held.

1. we don't want to allow parallel io_sqe_files_unregister()s
happening, it's synchronised by uring_lock atm. Otherwise it's
buggy.

2. probably same with unregister and submit.

> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index efb6d02fea6f..b093977713ee 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7362,18 +7362,25 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx, bool locked)
>  
>  	/* wait for all refs nodes to complete */
>  	flush_delayed_work(&ctx->file_put_work);
> +	if (locked)
> +		mutex_unlock(&ctx->uring_lock);
>  	do {
>  		ret = wait_for_completion_interruptible(&data->done);
>  		if (!ret)
>  			break;
>  		ret = io_run_task_work_sig();
> -		if (ret < 0) {
> -			percpu_ref_resurrect(&data->refs);
> -			reinit_completion(&data->done);
> -			io_sqe_files_set_node(data, backup_node);
> -			return ret;
> -		}
> +		if (ret < 0)
> +			break;
>  	} while (1);
> +	if (locked)
> +		mutex_lock(&ctx->uring_lock);
> +
> +	if (ret < 0) {
> +		percpu_ref_resurrect(&data->refs);
> +		reinit_completion(&data->done);
> +		io_sqe_files_set_node(data, backup_node);
> +		return ret;
> +	}
>  
>  	__io_sqe_files_unregister(ctx);
>  	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
> 

-- 
Pavel Begunkov
