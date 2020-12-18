Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4F52DE79F
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 17:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgLRQuZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 11:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgLRQuZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 11:50:25 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E81C0617B0
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 08:49:45 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n16so6279247wmc.0
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 08:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kTf59CGM7Kixujahk68iHB13wf0wU4+fD57hsrtoaRg=;
        b=O6vqdVxzBMhnTQoU6PIVSqIumBlwlufwQxQGyBAD3eSP5ZrvhZmbPpVhBu35fkcLye
         DkfscAN0GHXX1vp75b0mZCEWGsKJ1fm+WPTK/ruEpXlLMsJnT/jshjTyQjrt+EcuK8qB
         DNBIdS9lqyKKEe4KxfAeZQLVrSl5Z9t/uwaLVJ0CvzbSFWvtxXsaeerp1/oKfeBxGWAT
         1djEJWpfFaYLJvPwtt7Biyxvn8bB2BkFfssVHazilv9N9/xrmQCp7nlUNNEdDb83UGB5
         fubFmCQnNNvujEQAz6425nq6XLCzISVSWD/6Jjt9QkiD55TgRLZln2c0UApRSG8O3UV4
         MFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kTf59CGM7Kixujahk68iHB13wf0wU4+fD57hsrtoaRg=;
        b=eY7xTKbV92KgfdHZ23QFD8b69pqCnRvEi+ahRJH3OMC/XbUGI8L+YChACCu5d4L4et
         a4pvinngtTmJER4SbQ7LJ0W13hF6Q2Id61Dosb3KXoK90ul1s/3R5n1fqgZUzhUF9Wnd
         jZ/cQQCnsC6jfwb945tOt09hg4mf6T4SOmz5Bo/5VkOHu6sYZEO72wW0OQ3e++yk9QPl
         Zi2DJs1g3BkHX2NwDpcxJkdvops8exPlRuUkdMgSDDVxcXJDhhQJNBGC3ZSUykNWZsoC
         UTXErgikDM9xlubIEeKMhVp3mtvC/bAgrVTmYeP6S0ltTf+3Xsk5GtOW2EmEeGNtVSeS
         zFuA==
X-Gm-Message-State: AOAM533LtPzOI0CNHMd6xfEbzfNODZQI6jsp3XY3M/ao8wXfvQJ/LVqC
        rLN9vtHuSgFXM8bJaGaaxiOVKnZvJWOEtg==
X-Google-Smtp-Source: ABdhPJwAb8hgId6wIhR6Fh5hDeh9RbdWZeydgepLScX/Cm7HFrwld8jJs35jB1vP8kN7fOUpQa0Gbw==
X-Received: by 2002:a1c:bd87:: with SMTP id n129mr5062857wmf.32.1608310183665;
        Fri, 18 Dec 2020 08:49:43 -0800 (PST)
Received: from [192.168.8.132] ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id a13sm13687875wrt.96.2020.12.18.08.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 08:49:43 -0800 (PST)
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <20201218162404.45567-1-marcelo827@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: flush timeouts that should already have expired
Message-ID: <8c9448aa-5bd3-88a5-a830-3c1229db3fe2@gmail.com>
Date:   Fri, 18 Dec 2020 16:46:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201218162404.45567-1-marcelo827@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/12/2020 16:24, Marcelo Diop-Gonzalez wrote:
> Right now io_flush_timeouts() checks if the current number of events
> is equal to ->timeout.target_seq, but this will miss some timeouts if
> there have been more than 1 event added since the last time they were
> flushed (possible in io_submit_flush_completions(), for example). The
> test below hangs before this change (unless you run with
> $ ./a.out ~/somefile 1)
> 
[...]
> 
> Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b74957856e68..ae7244f8e842 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1639,7 +1639,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
>  
>  		if (io_is_timeout_noseq(req))
>  			break;
> -		if (req->timeout.target_seq != ctx->cached_cq_tail
> +		if (req->timeout.target_seq > ctx->cached_cq_tail

There was an pretty old patch for probably that problem, which got
lost... Please consider that target_seq and others are u32 and may
easily overflow, you can't do comparisons as freely. It would be
great to finally fix it, but that can be a bit harder to do.

>  					- atomic_read(&ctx->cq_timeouts))
>  			break;
>  
> 

-- 
Pavel Begunkov
