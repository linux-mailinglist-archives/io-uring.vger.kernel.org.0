Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEF22F91CE
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 11:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbhAQK5W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 05:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727967AbhAQK45 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 05:56:57 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB10C061574
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 02:56:15 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m4so13665346wrx.9
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 02:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6nR4VebyATpcP5Vz0KhBIh53t0T96s0sX5wVYbweK4w=;
        b=eXhjM2Y3GyndQuxaBE9KbBQqpKVWW1XWS9MZjI3DwqyMyZyn26El1xHfewxFfCSGAk
         NLrW1JQy0/mT6nBFyAOiP+0QSZiBNy/8oiPY/se04SOSLKI/gIk/pOjSwRMTUdF4eKUL
         FZ34FVdHDSs6CseP+U0CaE+EOxKvu8yXRinjTMpGojBB497TAyMY3zJYcFM7ph/0p856
         XD+AOzvDiE7bgu/QwJP1K4MYS9RYRugutSlStJrKM0/4nwhIgZjZKdr8wch03AvvK8DS
         GsGdhVFMoL5UBq+9p1x4djd+imVDkAlPGE831Y7aT8yetaQXiEpezfDNLhZTnT7CrB+f
         5k7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6nR4VebyATpcP5Vz0KhBIh53t0T96s0sX5wVYbweK4w=;
        b=XWw+NBfm+SRkYP6tInAAfTk+21WGjec3wiBUBAenpC/uBUNclL7n38uvAssKTymi0Q
         ITXCvIpN2Hdm4oYIfHnu4Znbl36NtW6Pk1XhsqRIYt4RCj3v5MbigyMqew2bShktoqq/
         MtMYMz/aYoJRT1rfC3oPbgout6bq1bgoLnxXF61T1lnBDBnXN19Eu2UOFglDHuFopkS1
         GsH1XwpE3xG1K3cslRsnPdrU27Mu3Zy0GpVgbmOcaXArjiNYSg5emp4zFsZmaTKkn6nI
         tJGd5iK0Ru4ajTvCSX6sIsp5OL40F8zk0HAvk3xupn1hrp97QGnAysBfbVkpxQXvoTF2
         pMnw==
X-Gm-Message-State: AOAM531sPhhu4iOsH8Cr6f6ejpBS1K68BNpuu6sJzBWATp0ilnIxRi8+
        5n5Vy2XfPLrHs8MyHNnPeobHmFS5lh8=
X-Google-Smtp-Source: ABdhPJxrXr8d4LJb/ItA/py7SApYAGzcCR1G+L0sXLtGtXiKv9+z97D5iq2Xe4cUlr3fUcCKA5UsjA==
X-Received: by 2002:adf:f605:: with SMTP id t5mr20900813wrp.39.1610880973916;
        Sun, 17 Jan 2021 02:56:13 -0800 (PST)
Received: from [192.168.8.130] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id c20sm18945249wmb.38.2021.01.17.02.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 02:56:13 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <4d22e80b-0767-3e14-fc13-5eca9b1816fc@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: cancel all requests on task exit
Message-ID: <c41079a5-5f5f-ac58-e01d-792e4f007611@gmail.com>
Date:   Sun, 17 Jan 2021 10:52:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4d22e80b-0767-3e14-fc13-5eca9b1816fc@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/01/2021 04:04, Jens Axboe wrote:
> We used to have task exit tied to canceling files_struct ownership, but we
> really should just simplify this and cancel any request that the task has
> pending when it exits. Instead of handling files ownership specially, we
> do the same regardless of request type.
> 
> This can be further simplified in the next major kernel release, unifying
> how we cancel across exec and exit.

Looks good in general. See a comment below, but otherwise
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

btw, I wonder if we can incite syzbot to try to break it.

> 
> Cc: stable@vger.kernel.org # 5.9+
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 383ff6ed3734..1190296fc95f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9029,7 +9029,7 @@ static void io_uring_remove_task_files(struct io_uring_task *tctx)
>  		io_uring_del_task_file(file);
>  }
>  
> -void __io_uring_files_cancel(struct files_struct *files)
> +static void __io_uring_files_cancel(void)
>  {
>  	struct io_uring_task *tctx = current->io_uring;
>  	struct file *file;
> @@ -9038,11 +9038,10 @@ void __io_uring_files_cancel(struct files_struct *files)
>  	/* make sure overflow events are dropped */
>  	atomic_inc(&tctx->in_idle);
>  	xa_for_each(&tctx->xa, index, file)
> -		io_uring_cancel_task_requests(file->private_data, files);
> +		io_uring_cancel_task_requests(file->private_data, NULL);
>  	atomic_dec(&tctx->in_idle);
>  
> -	if (files)
> -		io_uring_remove_task_files(tctx);
> +	io_uring_remove_task_files(tctx);

This restricts cancellations to only one iteration. Just delete it,
__io_uring_task_cancel() calls it already.

-- 
Pavel Begunkov
