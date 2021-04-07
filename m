Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7A8356B74
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 13:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbhDGLnS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 07:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbhDGLnS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 07:43:18 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D9CC061756
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 04:43:08 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e12so4563461wro.11
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 04:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jpQHvfRnZ/EkRLvDCOmo2YgVf+KbCcjimrfVzcoa/rc=;
        b=hyGRROcsxKVBhvpywBjgzwpXgPPdDX0zCEGIbBfEBGzD7ip/YfRkwIYFWw5oGVMGLP
         dHD7N72A+kjbUBjrbQwsCmgReBtoXo2A/OtSqEXysJOFyw/LLHnAV2HddbHAVTUotrme
         GhmmVaqMAtremdPGC8OZAxAgQQ5ykagQ1XfHeoBEX9yGY2uSavkavf8vVwFhpXThS4Xw
         pv8IwsMeq6Ce4WrwSzcSA3TF0tTq3pG93FEf4jh1Lj2syK68qpVChCONZb1GltacVc9c
         +QZwrZuvlIVZ05N5t5cgbBzCB8zE+Gvyz8XPYGzKglVabVrHDSFY1l5cI05MX6+84p7F
         kIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jpQHvfRnZ/EkRLvDCOmo2YgVf+KbCcjimrfVzcoa/rc=;
        b=L7G+FQvLQXtteiMmp3sl0jKXWGsOcjU/omVHEhlSjjsjqiG3Bi5NBro9SENGSErOjy
         XVgGa0RKJeBPFHSTBvnUkcHN2YmRu9Wy0lJ1PyDGUjphHJYkgKgvR6UL9d+Axy4CODHi
         xOd5Q4tu96GEkXHp8P+AC3ZgaSR9rFuIRpERu50H2YIH8QjoJqBpE5fmpM12sgb32Kz6
         Lkz0G9SmukgwvDK1kNPrMjP5RA3TUQli9b0oocnRJf/fwzHKt+y3CSjVZdgcjCQKP0Me
         aQDU552c+AxSA21btjkdiceYNrs6mO0zCDx9rpQjDdjKE8b2+Ao9Uroe/Ju9rhVUDcBq
         nbYw==
X-Gm-Message-State: AOAM530uTqpbdFCvyFSSBPGySNU+KCHGIU4mqhru6r5Dno2/iUvWUEJu
        S147O/0SFqn9FzDjGMs5Vw/LhQCNLsWj9Q==
X-Google-Smtp-Source: ABdhPJy+XWNdQzEyJa5yRhDEDEQE43XAyOTQwn3WNI3vYpyhwb8gEmYOZrLDuBpQgLU5BzWkoEJCPA==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr3939080wrq.262.1617795787188;
        Wed, 07 Apr 2021 04:43:07 -0700 (PDT)
Received: from [192.168.8.145] ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id e10sm23740639wru.52.2021.04.07.04.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 04:43:06 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for
 multishot requests
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <1617794605-35748-2-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <25890431-0d42-ded6-1a10-e9cf3b3c343d@gmail.com>
Date:   Wed, 7 Apr 2021 12:38:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1617794605-35748-2-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/04/2021 12:23, Hao Xu wrote:
> Since we now have requests that may generate multiple cqes, we need a
> new flag to mark them, so that we can maintain features like drain io
> easily for them.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c                 | 5 ++++-
>  include/uapi/linux/io_uring.h | 3 +++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 81e5d156af1c..192463bb977a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -102,7 +102,7 @@
>  
>  #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
>  				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
> -				IOSQE_BUFFER_SELECT)
> +				IOSQE_BUFFER_SELECT | IOSQE_MULTI_CQES)
>  
>  struct io_uring {
>  	u32 head ____cacheline_aligned_in_smp;
> @@ -700,6 +700,7 @@ enum {
>  	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
>  	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
>  	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
> +	REQ_F_MULTI_CQES_BIT	= IOSQE_MULTI_CQES_BIT,
>  
>  	REQ_F_FAIL_LINK_BIT,
>  	REQ_F_INFLIGHT_BIT,
> @@ -766,6 +767,8 @@ enum {
>  	REQ_F_ASYNC_WRITE	= BIT(REQ_F_ASYNC_WRITE_BIT),
>  	/* regular file */
>  	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
> +	/* a request can generate multiple cqes */
> +	REQ_F_MULTI_CQES	= BIT(REQ_F_MULTI_CQES_BIT),
>  };
>  
>  struct async_poll {
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 5beaa6bbc6db..303ac8005572 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -70,6 +70,7 @@ enum {
>  	IOSQE_IO_HARDLINK_BIT,
>  	IOSQE_ASYNC_BIT,
>  	IOSQE_BUFFER_SELECT_BIT,
> +	IOSQE_MULTI_CQES_BIT,
>  };

It's user API flags, I doubt you want to touch them.
1) there are not much of bits left
2) it almost always means you add overhead in generic path,
even for those who don't care about multishots or drains.

Let's keep out of it

>  
>  /*
> @@ -87,6 +88,8 @@ enum {
>  #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
>  /* select buffer from sqe->buf_group */
>  #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
> +/* may generate multiple cqes */
> +#define IOSQE_MULTI_CQES	(1U << IOSQE_MULTI_CQES_BIT)
>  
>  /*
>   * io_uring_setup() flags
> 

-- 
Pavel Begunkov
