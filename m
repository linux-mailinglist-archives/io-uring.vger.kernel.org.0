Return-Path: <io-uring+bounces-200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 457F480134C
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 20:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49CBAB20D4B
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 19:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880414A9A6;
	Fri,  1 Dec 2023 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vpc97nHu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DD3AD
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 11:04:56 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-a18ebac19efso369513766b.0
        for <io-uring@vger.kernel.org>; Fri, 01 Dec 2023 11:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701457494; x=1702062294; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XWOoo7PSWHdQtoy7g10LJKBemGIkhyzEyQ0j/Qi0Wec=;
        b=Vpc97nHuB8EzysgtzkB6OyJ11QSb0D53qBh155BfEm/yR4ZARh4iRm6JhPUFfGTe4N
         hAE4Y6midaL4CuTsIjsZOVcC++kej+hH/SvOfVpNRvWBiGGmE+haz/pBsWUcs2SDXaVe
         NSdvO8PMz76q0V2yyamoMsLNamB/vqdSLzHzA4RisHLjj/mTql4HBUYOqPpiGOPuUS+7
         7SJHV704Sf9d0ML5u0ZG13sB7KPM0qoEXWtlfj20R9PShJoJ2m3WJH0hOsBlTbDn++Kh
         SR1L5A6WfdM4ioY+OqTBT8OfLVEhhQ8M85EMc3DEYgm+QsuY/hKLpJ7lFkxUCjJTupS7
         uCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701457494; x=1702062294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWOoo7PSWHdQtoy7g10LJKBemGIkhyzEyQ0j/Qi0Wec=;
        b=q5jiVBY7eVJy9dSliWSRLfoa/OJYZflsSrQLk03bR7cjydzRX+DoXlO6lIxHw4dJNe
         sor0/zZm6Ag6DM3ndjGz2vd/nWGGXgiwbo4SNoPg3AtS/4/AxNgDEQzTMh4BJea9Lvxg
         A1tBd/kyz895nAJEQr/tZ6IKvrmCWDW4vuAtN5UlRJiMXfvf1ueHPQN69ZL0vPI+ZAjO
         jaTWG9OApLXLXUZWWgREVXbb5PtZ8eE/jrucJxZ0N/grtVQ7R3bGSN8i49BHJ3dZ4tTZ
         sivcQS0eiurn8NnLLUU4ZmNH4LPFKvJw/NW+epDZ/7JZeaHSTWGutCdx0WrJrlvFEYTX
         Seew==
X-Gm-Message-State: AOJu0YwmoyrUYQCcZhC3EyJUfwD/ogdMjh39mCKJiwhK5VB7EuciBsMC
	SCL3AKS9ozyJW9Y6DvUs5yujoYY+lqM=
X-Google-Smtp-Source: AGHT+IFP/rx2R2l469LrXCkaP0Gk2gzcaw9pU33hA3aqAhT9pxDgl5qgY6ahohMvmko6QlFyiMHEfw==
X-Received: by 2002:a17:906:d28b:b0:a19:a409:37d2 with SMTP id ay11-20020a170906d28b00b00a19a40937d2mr1776078ejb.43.1701457494116;
        Fri, 01 Dec 2023 11:04:54 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.112])
        by smtp.gmail.com with ESMTPSA id e22-20020a1709067e1600b00a0c086ac173sm2189021ejr.113.2023.12.01.11.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 11:04:53 -0800 (PST)
Message-ID: <cf3b5122-a5aa-48a1-8238-3061a28f4743@gmail.com>
Date: Fri, 1 Dec 2023 19:03:34 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next 2/2] io_uring: optimise ltimeout for inline
 execution
Content-Language: en-US
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, christian.mazakas@gmail.com
References: <cover.1701390926.git.asml.silence@gmail.com>
 <8bf69c2a4beec14c565c85c86edb871ca8b8bcc8.1701390926.git.asml.silence@gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8bf69c2a4beec14c565c85c86edb871ca8b8bcc8.1701390926.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/23 00:38, Pavel Begunkov wrote:
> At one point in time we had an optimisation that would not spin up a
> linked timeout timer when the master request successfully completes
> inline (during the first nowait execution attempt). We somehow lost it,
> so this patch restores it back.
> 
> Note, that it's fine using io_arm_ltimeout() after the io_issue_sqe()
> completes the request because of delayed completion, but that that adds
> unwanted overhead.

Let's add:

Reported-by: Christian Mazakas <christian.mazakas@gmail.com>

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 21e646ef9654..6212f81ed887 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1900,14 +1900,15 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>   		return 0;
>   	}
>   
> -	if (ret != IOU_ISSUE_SKIP_COMPLETE)
> -		return ret;
> -
> -	/* If the op doesn't have a file, we're not polling for it */
> -	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> -		io_iopoll_req_issued(req, issue_flags);
> +	if (ret == IOU_ISSUE_SKIP_COMPLETE) {
> +		ret = 0;
> +		io_arm_ltimeout(req);
>   
> -	return 0;
> +		/* If the op doesn't have a file, we're not polling for it */
> +		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> +			io_iopoll_req_issued(req, issue_flags);
> +	}
> +	return ret;
>   }
>   
>   int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
> @@ -2078,9 +2079,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>   	 * We async punt it if the file wasn't marked NOWAIT, or if the file
>   	 * doesn't support non-blocking read/write attempts
>   	 */
> -	if (likely(!ret))
> -		io_arm_ltimeout(req);
> -	else
> +	if (unlikely(ret))
>   		io_queue_async(req, ret);
>   }
>   

-- 
Pavel Begunkov

