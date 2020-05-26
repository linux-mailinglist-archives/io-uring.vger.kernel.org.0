Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484271E250C
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 17:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgEZPJ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 11:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgEZPJz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 11:09:55 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A073C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 08:09:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b91so17978335edf.3
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 08:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hi5dyk+WSKs1pelnIwaHrCNQ/dTycYEyJYzj3v7OspY=;
        b=Sato3xoN//qi2aQLnpAREM5NSOcfipc+2gnOBunTE32bF3B30gnr4yHdmYwQUAq1eo
         4lr3qcgLx/xTt59lEqRr6jw2DwaH4fi5w25oiq4TW7GDLL9YIu8bWqcjNE8v5oaOzLH0
         lr8PTTFZdyw/IX1QcQtSPDxncxo5aLE9lIgunYHBRIpizuAG4xg3TRngnbk7/w0PsVmM
         Lx7nroigD2CC5Ctr7sb7SdBzQd/UMtrJUhDCEI2M7jtkjTpvB6odnhqnwDMxHE4O8kUG
         0Pv2lQ1FBKgOcaEUDve4vluqJp5DzOBirsAv27lsC/z+ePiEKM2Uv0wwU4zBxLrfp3Vf
         DePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Hi5dyk+WSKs1pelnIwaHrCNQ/dTycYEyJYzj3v7OspY=;
        b=Vu4gwBElpvn/sLyn/EEQwqm0LqhNmsd9/EIjdWTsP8NfiKXXyvWVyt4QFWhWcaepHa
         hGNv+FROVaPGdftAYpQjHxNVIOyZCDRzooSW4VsQWL2zBsxkEyvoS5DsoTF+LKwKl18A
         TzlkvFejokMHs1v0ESfJJshMqfgy7FUJ183ezmQy1EKVCJ4E96z9iZgMiMgz8i8solA2
         3JKudwtLhzJ854p4Ix34WZcatgcuEqX7kN/c+ZFM+hP5x1VyEvbNCgBZOQEkA67H+Yph
         1zjSkhyhIzY1L7AJbg5FjlXM0SHpnElHe+6X233Bbwbkg3zIxNo8bMYVQmJ/fjy2hM1v
         KC0w==
X-Gm-Message-State: AOAM532MgrSuH8u65FrBf9BD4OLvM7lVIfy3cPy9aGWorTmR7AJ7h9UJ
        lIONS5pPwFNJm20vcotNUTRLvUa4
X-Google-Smtp-Source: ABdhPJxYKmYYtXD0EMijmPZcXi+lX1U/VOwLnzBHgnIM3/qs5dAl+ytcAV4N6xXHzE3kXGsR+lpwIg==
X-Received: by 2002:a05:6402:2211:: with SMTP id cq17mr19624416edb.171.1590505794000;
        Tue, 26 May 2020 08:09:54 -0700 (PDT)
Received: from [192.168.43.105] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id aq5sm147089ejc.112.2020.05.26.08.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 08:09:53 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
 <20200526064330.9322-2-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/3] io_uring: avoid whole io_wq_work copy for inline
 requests
Message-ID: <b57bc53a-be72-c999-98d6-a7a3055022de@gmail.com>
Date:   Tue, 26 May 2020 18:08:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200526064330.9322-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/05/2020 09:43, Xiaoguang Wang wrote:
> If requests can be submitted inline, we don't need to copy whole
> io_wq_work in io_init_req(), which is an expensive operation. I
> use my io_uring_nop_stress to evaluate performance improvement.
> 
> In my physical machine, before this patch:
> $sudo taskset -c 60 ./io_uring_nop_stress -r 120
> total ios: 749093872
> IOPS:      6242448
> 
> $sudo taskset -c 60 ./io_uring_nop_stress -r 120
> total ios: 786083712
> IOPS:      6550697
> 
> About 4.9% improvement.

Interesting, what's the contribution of fast check in *drop_env() separately
from not zeroing req->work.

> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io-wq.h    | 13 +++++++++----
>  fs/io_uring.c | 33 ++++++++++++++++++++++++++-------
>  2 files changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 5ba12de7572f..11d981a67006 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -94,10 +94,15 @@ struct io_wq_work {
>  	pid_t task_pid;
>  };
>  
> -#define INIT_IO_WORK(work, _func)				\
> -	do {							\
> -		*(work) = (struct io_wq_work){ .func = _func };	\
> -	} while (0)						\
> +static inline void init_io_work(struct io_wq_work *work,
> +		void (*func)(struct io_wq_work **))
> +{
> +	if (!work->func)

Not really a good name for a function, which expects some of the fields to be
already initialised, too subtle. Unfortunately, it'll break at some point.

I think, a flag in req->flags for that would be better.
e.g. REQ_F_WORK_INITIALIZED

And it'd be better to somehow separate field of struct io_wq_work,
1. always initialised ones like ->func (and maybe ->creds).
2. lazy initialised controlled by the mentioned flag.


> +		*(work) = (struct io_wq_work){ .func = func };
> +	else
> +		work->func = func;
> +}
> +
>
-- 
Pavel Begunkov
