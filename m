Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655D442DB41
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 16:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhJNOQf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 10:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhJNOQe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 10:16:34 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9CAC061570
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 07:14:29 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id y3so20085986wrl.1
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 07:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6f/wF99HeuEbgH43K9HiGq9epdAyRq/Ql8znoonyUDw=;
        b=jmcBZgiOmSz1uL98lrwd3jKLRDOAta2Q6SNpF4uZvJJnLwFdcmafLNrcsTOWqEs1XE
         aC7ejHWvXQgLRCDdRKXBbpYfYdgXyVQJvCP7m1Levwr17VReKarZS0KOD2R6tv3mkXuQ
         xQC1SrtSZRnKvarInWeU4eQfRnr9nLn6i3U+EsDvoe6lLxU1QFiAWbJ6Inr7ooal87GL
         sGnCvgHFgQJOQujtxVh3GUWYV5dOLwSzJlrW7p8EUdkm8K8ovsp+HQH+U15kh9ZlRNXi
         MkySjrWvHNyysPhRL1z6lgtUTyujWgxHQeT+Lo7Ph+cDUZ78F/KhzpkHu/E/Zen4i9R7
         1DUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6f/wF99HeuEbgH43K9HiGq9epdAyRq/Ql8znoonyUDw=;
        b=FTewA1hJ5A+3wGupTBox/qQV2V/vjRY09n6UGmak29H+pWYi7UkwU/XU1u+UQOLYQ7
         xubUoQ/A79PfjqGD1UaMtTk0MEDBVHxsUbst/GDMMQ1Ewa9eQW0nlVCJY8YBbyqQ87Lq
         MVN69YclKrPXF5RZpIMHiGQo8YfmQVM4+nzMvgTw7PAxjPcsuGoRXK82w6J23+4GOro6
         dIh7HVTLN8ThRYL93D40K/3+2i7T1rXQ1mD68qKOdSuSZdWRbvuWF0CEUm2k1pj0plj9
         rmMW7BoDPieHtXLfo2QUS1FkAVdmyySC5qu8FTzhEYj/JujtjlLwWNAcGLifrNfRJHgO
         L6JA==
X-Gm-Message-State: AOAM532hK15vS7q244bAe1UDSs3+tw2ZyP2F/fmjMcMQ0KGV0yp7cP6K
        3UTwCDKHEwABC4gguT2JH22ArOtiUvw=
X-Google-Smtp-Source: ABdhPJycddMSMUFGmEGMNFXGc3kTMs9x2nVUm/egh6G74QK+7EzGIo9tskElYhFmUPZ6I8unA3S8DQ==
X-Received: by 2002:adf:b313:: with SMTP id j19mr7014727wrd.9.1634220868319;
        Thu, 14 Oct 2021 07:14:28 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id l124sm8525729wml.8.2021.10.14.07.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:14:27 -0700 (PDT)
Message-ID: <a8a702e8-568b-ffc4-bf6d-8e868697e825@gmail.com>
Date:   Thu, 14 Oct 2021 15:13:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] io_uring: fix wrong condition to grab uring lock
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211014140400.50235-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211014140400.50235-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/14/21 15:04, Hao Xu wrote:
> Grab uring lock when we are in io-worker rather than in the original
> or system-wq context since we already hold it in these two situation.

Good catch, lgtm


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 73135c5c6168..e2ed21c65f71 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2890,7 +2890,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>   			struct io_ring_ctx *ctx = req->ctx;
>   
>   			req_set_fail(req);
> -			if (issue_flags & IO_URING_F_NONBLOCK) {
> +			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
>   				mutex_lock(&ctx->uring_lock);
>   				__io_req_complete(req, issue_flags, ret, cflags);
>   				mutex_unlock(&ctx->uring_lock);
> 

-- 
Pavel Begunkov
