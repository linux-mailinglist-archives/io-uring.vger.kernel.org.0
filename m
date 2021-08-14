Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472973EC4B4
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 21:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhHNTOM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 15:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhHNTOM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 15:14:12 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7806EC061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:13:43 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k3so14403272ilu.2
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=siAiMvwW65+yIVab3bzBC7hjr2pNDLwN5yjIgHH6bRM=;
        b=kGbs5nbQeHd++0mmVA1FWB4Pm5DvQ2pcies5VjpByxL9o6Oxotp6UlwUUnl4VLbJrd
         YawHG2/jmkFSyJDy3zvzxwQNg67vULe+ooY8mKsbMCe8HWSjW914/aDUsGfhTkr5EvPA
         ch+c0k2wBtenubB1MPOGDX/XQafCm5VjU53bdUX1GD/l4uns1Ar2s4SJ5PIkdfUg3V/y
         pEjDbctl418TDTHYHOYcirLS8gNtHC+yC/0rjFUcfO2ygMTCzKXcRXPvoUhKy1FuL3vp
         dx3mu/c+j7H2QfY+03fPfICmWvLMz6oKrABcOyVOt7/FQEr8AmUiWRl5e2nUqTywApTv
         vlPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siAiMvwW65+yIVab3bzBC7hjr2pNDLwN5yjIgHH6bRM=;
        b=bt+hvQRixWVwghz13Bh63DVMLzxZqMJU3wEaq2F2kWP8IssbazXrA0SnucSVQQkx2F
         waQppZdy/Rjh1ewMqk8mQuQq2sQBqV1eCnkFzLMbpfaV+J2gwfdUWk71U8L3RIWqntxg
         /y81LiykFaWY0OGaB5NabqEsGNCZJvABx6NeS3S+DSVW/vSS+h3grXQkJ0B+w6+gYcgS
         Et+9VBRDWsjkPhR3Ipj5M+HxokrdSz31v0qu9RW0SGVemqYG/SaMkfsRJFOWFyok8Xlt
         xsV9T4UsGkesFYFBl+v9EXfbTwJeJM72xa4/bmW0GABAw2jy2nOI/Q1gMOkwdG9eC2RE
         r3xw==
X-Gm-Message-State: AOAM530JDiPiYPF+0aoLM3PhZpqAQTQBrMs8C2ENAmdG4RyJCGuvbuiU
        vSiAkelE5p/AzApJ6s9xDwoZEc/9LO2M+b6P
X-Google-Smtp-Source: ABdhPJyIW63biA9s4/Zk0t3/tSbtBUtM4x9te0wHe4ltheYLI6OKCFxgbGkQYynYLRVXLezfOlvqOQ==
X-Received: by 2002:a05:6e02:13e1:: with SMTP id w1mr446173ilj.116.1628968422726;
        Sat, 14 Aug 2021 12:13:42 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m10sm2949085ilg.20.2021.08.14.12.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 12:13:42 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: optimise iowq refcounting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628957788.git.asml.silence@gmail.com>
 <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
Date:   Sat, 14 Aug 2021 13:13:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/21 10:26 AM, Pavel Begunkov wrote:
> If a requests is forwarded into io-wq, there is a good chance it hasn't
> been refcounted yet and we can save one req_ref_get() by setting the
> refcount number to the right value directly.

Not sure this really matters, but can't hurt either. But...

> @@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
>  	atomic_inc(&req->refs);
>  }
>  
> -static inline void io_req_refcount(struct io_kiocb *req)
> +static inline void __io_req_refcount(struct io_kiocb *req, int nr)
>  {
>  	if (!(req->flags & REQ_F_REFCOUNT)) {
>  		req->flags |= REQ_F_REFCOUNT;
> -		atomic_set(&req->refs, 1);
> +		atomic_set(&req->refs, nr);
>  	}
>  }
>  
> +static inline void io_req_refcount(struct io_kiocb *req)
> +{
> +	__io_req_refcount(req, 1);
> +}
> +

I really think these should be io_req_set_refcount() or something like
that, making it clear that we're actively setting/manipulating the ref
count.

-- 
Jens Axboe

