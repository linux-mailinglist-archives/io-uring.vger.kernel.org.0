Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135AB36B136
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhDZKFr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 06:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhDZKFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 06:05:46 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2D5C061574;
        Mon, 26 Apr 2021 03:05:03 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e5so26553789wrg.7;
        Mon, 26 Apr 2021 03:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TmEKlNOVLHeXXkMggnA8uhZU5l1gNwGDvYhSy4Iwtr0=;
        b=hnBqVha2T5JaFAz+u6uvYxKiGlbale8QnAuKRUbfEY15DtoTouRLooL20O9mtx5Nfr
         Beh0tPqIwAUpck7CPhxhfCBiJhKBi7EEGuEisxbTdppXsV59kPUD1IDF+ls8exO7lVdc
         yTTwqXAjTH/v/DoWtQM/zLPf8li+6f3vV+CwAhZtqIlBTv/O4YQIL9RBKn9Xy157w0MH
         MxmBKq5Gb/+7aslnlk7fZSJbnuKO5ipyu68hPWAo5+pFbLGUFxAyPEOhyHmG5/posuwN
         q/JD1XMOPYjpyIVdtEa1GfINFp7jXI2HOKzb427IZhorc63nCON1lBEXHl0dktHYSLHe
         KRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TmEKlNOVLHeXXkMggnA8uhZU5l1gNwGDvYhSy4Iwtr0=;
        b=CMiuO1S3hHAPE89dOAD+cN0BRj8KPvt+SvwtQ6kVD19yn44XXGPmabtO2Yv7YoJZND
         cO8Kli2dM4FOKCjH6m0t+r00YKX+vhmZADkTqzS6stPtUs3hmOseZaJUlBbFvo/ZsEj4
         o/AYBRldk8Ngk0rgoX+i7Qt0Ny/tFbIcx3dXrRXdaQaVRcjCNOizKgVv2DjLpqWc6+tR
         CN5YKRaZ4EZ88DOl/BxOlO51hi2QiEXW6UMb1xWhjMmmJkmBBUZr/njoM+IvfgXSjQkp
         OfuiPUm2QTDz3/+weXD8+LFCLjSwOBv0AO7vUEYko00s8s1lGmYd5MstpsMC2P9xqIIf
         iYDw==
X-Gm-Message-State: AOAM532zyx/dk39AOADV706kowSIHTHO7VB2rzh6c/0K2hiFUot7Dn85
        3tBc3GV0CoBNf87gv4WSpDKM57VwfU4=
X-Google-Smtp-Source: ABdhPJxSUXAcNOKBFa2QwRrCuAxFzqhk5cEkZD7tvbXz1zPh2bwv4aPRVBo1I9B3YkciWhQOFNPPOQ==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr22237503wrr.58.1619431501826;
        Mon, 26 Apr 2021 03:05:01 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id o12sm20542261wmq.21.2021.04.26.03.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 03:05:01 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: fix incorrect check for kvmalloc failure
To:     Colin King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210426093735.7932-1-colin.king@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <bb89db64-999e-7e39-745a-c8aaa35731bf@gmail.com>
Date:   Mon, 26 Apr 2021 11:04:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210426093735.7932-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/21 10:37 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently imu is being allocated but the kvmalloc failure is checking
> imu->bvec instead of imu.  Fix this by checking imu for null.

Right, that's buggy.

fwiw, was reported by lkp and I sent a fix yesterday, so take any.
https://lore.kernel.org/io-uring/d28eb1bc4384284f69dbce35b9f70c115ff6176f.1619392565.git.asml.silence@gmail.com/T/#u


> 
> Addresses-Coverity: ("Array compared against 0")
> Fixes: 41edf1a5ec96 ("io_uring: keep table of pointers to ubufs")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 57a64c7e0e69..f4ec092c23f4 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8269,7 +8269,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>  		goto done;
>  
>  	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
> -	if (!imu->bvec)
> +	if (!imu)
>  		goto done;
>  
>  	ret = 0;
> 

-- 
Pavel Begunkov
