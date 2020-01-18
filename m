Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE94141869
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 17:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgARQel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jan 2020 11:34:41 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39430 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgARQel (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jan 2020 11:34:41 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so11222238plp.6
        for <io-uring@vger.kernel.org>; Sat, 18 Jan 2020 08:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xMFDEvWRj8MaBdHNVYJXJ8QUKiSOTRU80rGI0rv4uJs=;
        b=ZGIE2CXjajj/msR/dYQWp91xDlgC57BMTSfQXO1QFTzOJ/68miqK3qzkv0KwkakU6N
         /TfAEtLk1222VjQdALyeieiIRIJrcIATsUEim4n0jhXutbanUsAZqCuSor3g/7XBi4nG
         RV64K8oZwOOEKX4p4yjW7BqLw4MhrpgwUTM7aoOf0jUs7cfLG6lb2sRWyLcmZnM7yGGz
         1Ud7lcACM3/+fUcZEriZPrQlyhldJRsex+rVABZcq9TohblyQT1eZKt44Dsf+kj9IwIg
         ZPDX1iPUl4J42Aw3pHQEZSbz6GpbGIs/RkpewQfeTkCeZZzxq1ttS0awASuGvQUchNVX
         TB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xMFDEvWRj8MaBdHNVYJXJ8QUKiSOTRU80rGI0rv4uJs=;
        b=Cbi53ZQpwTL4hkx7FMfpK41+KwE5tcMgoaUkUeIeDBXEu2WZ7hcyy9mIqzgb2rAje7
         8bxEQp0kU54VwQTUoMxN2eMPPmTOyGJGccenetIV4qFQjDJPaU+EA7GjCeUJmYAcai+T
         6i7f3ajL/6cDkW7H3NJ+qvlNoQjaLyquDYze62cCCvVhAmrd+F/PuDmkH1+jgUyk/E3S
         eXTjy693UvaUXLMmTKaPohJ2K1cCBhYM5sb1HSswIA05rBH07zC5FOMSDZq9KSCaM6WH
         dYKBIv3a83mUjnbS+iqanJrsUzZowPIK2l19VDZMavqnTg8g9RYlYF7kY4IYi2Yj4CoF
         GHkg==
X-Gm-Message-State: APjAAAUp/ieJhao7PIPISADkBq85p06ZQ0hPiw6wZ6vj+Ltc0uh9wx1R
        gna61vfMBgLQ3BswlRijBAZVNQ==
X-Google-Smtp-Source: APXvYqxGaAAFii+9SovIezKp4nEQIrJGNIXs2ajW0kq9V+zST4DNJfKagj+qQNdZj3lDRLr9QQqjTA==
X-Received: by 2002:a17:902:16a:: with SMTP id 97mr5583527plb.163.1579365280551;
        Sat, 18 Jan 2020 08:34:40 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k44sm3194803pjb.20.2020.01.18.08.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 08:34:40 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: optimise sqe-to-req flags translation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b507d39e-ec2b-5c9f-0fd0-6ab1b0491cad@kernel.dk>
 <06bcf64774c4730b33d1ef65e4fcb67f381cae08.1579340590.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b773df2f-8873-77f3-d25d-b59c66f3a04b@kernel.dk>
Date:   Sat, 18 Jan 2020 09:34:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <06bcf64774c4730b33d1ef65e4fcb67f381cae08.1579340590.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/18/20 3:24 AM, Pavel Begunkov wrote:
> For each IOSQE_* flag there is a corresponding REQ_F_* flag. And there
> is a repetitive pattern of their translation:
> e.g. if (sqe->flags & SQE_FLAG*) req->flags |= REQ_F_FLAG*
> 
> Use the same numerical values/bits for them, and copy them instead of
> manual handling.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> v2: enum to generate bits (Jens Axboe)
>     Comments cross 80 chars, but IMHO more visually appealing
> 
> Crosses 
> 
>  fs/io_uring.c                 | 75 +++++++++++++++++++++--------------
>  include/uapi/linux/io_uring.h | 26 +++++++++---
>  2 files changed, 67 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ed1adeda370e..e3e2438a7480 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -452,6 +452,49 @@ struct io_async_ctx {
>  	};
>  };
>  
> +enum {
> +	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
> +	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
> +	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
> +	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
> +	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
> +
> +	REQ_F_LINK_NEXT_BIT,
> +	REQ_F_FAIL_LINK_BIT,
> +	REQ_F_INFLIGHT_BIT,
> +	REQ_F_CUR_POS_BIT,
> +	REQ_F_NOWAIT_BIT,
> +	REQ_F_IOPOLL_COMPLETED_BIT,
> +	REQ_F_LINK_TIMEOUT_BIT,
> +	REQ_F_TIMEOUT_BIT,
> +	REQ_F_ISREG_BIT,
> +	REQ_F_MUST_PUNT_BIT,
> +	REQ_F_TIMEOUT_NOSEQ_BIT,
> +	REQ_F_COMP_LOCKED_BIT,
> +};

Perfect

> +enum {
> +	/* correspond one-to-one to IOSQE_IO_* flags*/
> +	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),	/* ctx owns file */

I'd put the comment on top of the line instead, these lines are way too
long.

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 955fd477e530..cee59996b23a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -10,6 +10,7 @@
>  
>  #include <linux/fs.h>
>  #include <linux/types.h>
> +#include <linux/bits.h>
>  
>  /*
>   * IO submission data structure (Submission Queue Entry)
> @@ -45,14 +46,29 @@ struct io_uring_sqe {
>  	};
>  };
>  
> +enum {
> +	IOSQE_FIXED_FILE_BIT,
> +	IOSQE_IO_DRAIN_BIT,
> +	IOSQE_IO_LINK_BIT,
> +	IOSQE_IO_HARDLINK_BIT,
> +	IOSQE_ASYNC_BIT,
> +};
> +
>  /*
>   * sqe->flags
>   */
> -#define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
> -#define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
> -#define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
> -#define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
> -#define IOSQE_ASYNC		(1U << 4)	/* always go async */
> +enum {
> +	/* use fixed fileset */
> +	IOSQE_FIXED_FILE	= BIT(IOSQE_FIXED_FILE_BIT),

Let's please not use BIT() for the user visible part, though. And I'd
leave these as defines, sometimes apps do things ala:

#ifndef IOSQE_IO_LINK
#define IOSQE_IO_LINK ...
#endif

to make it easier to co-exist with old and new headers.

-- 
Jens Axboe

