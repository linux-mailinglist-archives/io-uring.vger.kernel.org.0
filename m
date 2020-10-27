Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C338929BF2B
	for <lists+io-uring@lfdr.de>; Tue, 27 Oct 2020 18:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815033AbgJ0RB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 13:01:26 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:40577 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1815027AbgJ0RBY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 13:01:24 -0400
Received: by mail-il1-f194.google.com with SMTP id n5so2153271ile.7
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 10:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mfyj2QnYX6FBXlsUqA4WhtGjUDjrUa7vGmbXV0YnoyU=;
        b=ZsKEzWX5BE7RF0yceWFFpHFbtou8kcb8j43OyYOLmWFMeH0CF3IX4TagCBJmkZZChH
         EkiyfcVf8jY8Hme0z4t6/90Fk7Ai5OAujM5bYIQLcw96BLJNk3aLJYirmagGUKakPCaT
         rVmatyYcCzX7lzMwJpikt/fdAbKE59K2a08Vv8VlvLfiWE9ymgjc1z5/mT53sA7nv7eW
         T5Sj4qH8Plzb4W9Y3RzblYAPnd2DprVXiveWYUOJUzstIbceaVUXAkRrh7ZhHakqa5wc
         QGidNmKqhkw5pvfdCWyCJIO1bY+gy+p853r8S6IiRCQJEHLw+QVsYOyHJQG1RdJMA6gc
         vQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mfyj2QnYX6FBXlsUqA4WhtGjUDjrUa7vGmbXV0YnoyU=;
        b=Ct6gKw+LUu9ljH/IyrYzyasGf6LMSGo0NHn9yW748lDZpESkBcUVkYSc7MlKBZK9O9
         8UfjGrUap5bLGMAssZt2DCCh4zO2FImO+EyPPnRQcttlWKamryWSlDSkJVF4FgMsZtZW
         0JE7v4GUy+FiWCULTjHjmAE7sFJchI1JDZeioV/OK3LceO816nVT0286kp/kDvDlGyH1
         Y+l8UedAGANbOiKqYUyIgUwW8pwc3QdjXsQhmVGtSgXWyLqTlTVTTCBWMuVj1YFIM8nD
         V1jqPfGikDyBzjgWJewfKR78Ek5pkLrX2IlUxkEie1zW4dZ5mXSBLJ/IAf7DmpzYGlgG
         1sQg==
X-Gm-Message-State: AOAM533WtdhwX0EIIkZErrvUWarXZcJtvZuTHAB79xfbHdUCETKu8wXb
        q7sYd21TCOSsKui3Ji6qF1wXoQ==
X-Google-Smtp-Source: ABdhPJw0Q764IypZXJgqZrWODrqP8aTPICKg65tsNPcW0JRkcIzLB2SGM2Mno/mwLf1i3wcddQzGfw==
X-Received: by 2002:a05:6e02:1304:: with SMTP id g4mr2860965ilr.105.1603818082559;
        Tue, 27 Oct 2020 10:01:22 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 18sm1165350ilg.3.2020.10.27.10.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 10:01:22 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: support multiple rings to share same poll
 thread by specifying same cpu
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
 <20201020082345.19628-3-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4498ad10-c203-99c8-092d-aa1b936cd6b4@kernel.dk>
Date:   Tue, 27 Oct 2020 11:01:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201020082345.19628-3-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/20 2:23 AM, Xiaoguang Wang wrote:
> We have already supported multiple rings to share one same poll thread
> by passing IORING_SETUP_ATTACH_WQ, but it's not that convenient to use.
> IORING_SETUP_ATTACH_WQ needs users to ensure that a parent ring instance
> has already existed, that means it will require app to regulate the
> creation oder between uring instances.
> 
> Currently we can make this a bit simpler, for those rings which will
> have SQPOLL enabled and are willing to be bound to one same cpu, add a
> capability that these rings can share one poll thread by specifying
> a new IORING_SETUP_SQPOLL_PERCPU flag, then we have 3 cases
>   1, IORING_SETUP_ATTACH_WQ: if user specifies this flag, we'll always
> try to attach this ring to an existing ring's corresponding poll thread,
> no matter whether IORING_SETUP_SQ_AFF or IORING_SETUP_SQPOLL_PERCPU is
> set.
>   2, IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
> for this case, we'll create a single poll thread to be shared by these
> rings, and this poll thread is bound to a fixed cpu.
>   3, for any other cases, we'll just create one new poll thread for the
> corresponding ring.
> 
> And for case 2, don't need to regulate creation oder of multiple uring
> instances, we use a mutex to synchronize creation, for example, say five
> rings which all have IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
> enabled, and are willing to be bound same cpu, one ring that gets the
> mutex lock will create one poll thread, the other four rings will just
> attach themselves the previous created poll thread once they get lock
> successfully.
> 
> To implement above function, define a percpu io_sq_data array:
>     static struct io_sq_data __percpu *percpu_sqd;
> When IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
> we will use struct io_uring_params' sq_thread_cpu to locate corresponding
> sqd, and use this sqd to save poll thread info.

Do you have any test results?

Not quite clear to me, but if IORING_SETUP_SQPOLL_PERCPU is set, I think
it should always imply IORING_SETUP_ATTACH_WQ in the sense that it would
not make sense to have more than one poller thread that's bound to a
single CPU, for example.

> @@ -6814,8 +6819,17 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  	return 0;
>  }
>  
> -static void io_put_sq_data(struct io_sq_data *sqd)
> +static void io_put_sq_data(struct io_ring_ctx *ctx, struct io_sq_data *sqd)
>  {
> +	int percpu_sqd = 0;
> +
> +	if ((ctx->flags & IORING_SETUP_SQ_AFF) &&
> +	    (ctx->flags & IORING_SETUP_SQPOLL_PERCPU))
> +		percpu_sqd = 1;
> +
> +	if (percpu_sqd)
> +		mutex_lock(&sqd->percpu_sq_lock);
> +
>  	if (refcount_dec_and_test(&sqd->refs)) {
>  		/*
>  		 * The park is a bit of a work-around, without it we get

For this, and the setup, you should make it dynamic. Hence don't
allocate the percpu data etc until someone asks for it, and when the
last user of it goes away, it should go away as well.

That would make the handling of it identical to what we currently have,
and no need to special case any of this like you do above.


-- 
Jens Axboe

