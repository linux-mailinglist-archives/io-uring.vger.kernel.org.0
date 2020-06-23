Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF2A2052B6
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 14:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgFWMl1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 08:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729611AbgFWMl0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 08:41:26 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC92C061573;
        Tue, 23 Jun 2020 05:41:25 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t194so3044701wmt.4;
        Tue, 23 Jun 2020 05:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uudyXPmH4K+yrXT/65FBE/u5/bFJbJPus9HjMbmfelU=;
        b=b1T1QonovDjAAKw3+0p/5r+gqachr/nXLStstkoUSpbKOsP08qa7jVVE90RkGUNJgE
         9GAKldFVs/QctI0jaz9z0hKGczwJqGPPU4xFkkkj5+K51LvSMl+KE5V70CHzldzt3MYQ
         C1h0VXvBV2VadSy5SLo3cptAQU+I6de4N2PdO8uqr9rXcjeZ5NLCNYoypDMbQLeIjepL
         OV3LcqlZEbRFmAgd/FmdYBumZW73JJ0IH8prfIeCttVrUByxdCfZBbUCtX/JliL6aFki
         f/F8BCiJ6IEpUUzVu1gnvVQoLR30yX7S+9So+gfYX6jyrnlyKOt4dPHHUPhW8QMCsLN+
         0EJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uudyXPmH4K+yrXT/65FBE/u5/bFJbJPus9HjMbmfelU=;
        b=lIoSmwFVpbKG89fnAG/dJ6s6aQuqNNVzDfFeRWRZo1Vr3C093tdeYLayF3pvztU0ZV
         zb0wuyK7Y8zNTZVtt1isxJQhBsdVWXzRLGjwTYgfK8oVqrIHPJbU9MCZz30dD+63ZBya
         ge45tJ4H7IptTuGElltO1HhjFlMbKAPkpMfN1NdC06xonfF/Wq8OFyPV5jKrM994uQui
         qRlQkfWzD5M46nlzynoZTu+pGg8YOKfKK0J9TF/O+kD6L2erGL6vH5TnIOJoCshOklKD
         mCPtLhY3w4XAT8enTFoPWBllNNHF+sEK1pKfZwhZMmAKLSwcqHml956StFF2rYUOoYB6
         fO9g==
X-Gm-Message-State: AOAM530Xt9SSq43xD69zssYTmj7mcpG0Pdsz0HL+/Nc82BcrBoQUrYb9
        t8huhibxfbkIXgyZAxHPfhFpqHKb
X-Google-Smtp-Source: ABdhPJxzI5YsFNYkNy0DPB9ktvhLhkWqlcVEs8OAaanY4X48AOvK5sHWxdRfXL5P+H6zcTKaAQ9N+g==
X-Received: by 2002:a1c:dfd6:: with SMTP id w205mr5037879wmg.118.1592916084323;
        Tue, 23 Jun 2020 05:41:24 -0700 (PDT)
Received: from [192.168.43.181] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id f16sm3719586wmh.27.2020.06.23.05.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 05:41:23 -0700 (PDT)
Subject: Re: [PATCH 15/15] io_uring: support true async buffered reads, if
 file provides it
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-16-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <029947e3-7615-e446-3194-d48827730e1d@gmail.com>
Date:   Tue, 23 Jun 2020 15:39:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200618144355.17324-16-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/06/2020 17:43, Jens Axboe wrote:
> If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
> the buffered read to an io-wq worker. Instead we can rely on page
> unlocking callbacks to support retry based async IO. This is a lot more
> efficient than doing async thread offload.
> 
> The retry is done similarly to how we handle poll based retry. From
> the unlock callback, we simply queue the retry to a task_work based
> handler.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 145 +++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 137 insertions(+), 8 deletions(-)
> 
...
>  static int io_read(struct io_kiocb *req, bool force_nonblock)
>  {
>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
> @@ -2784,10 +2907,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>  		unsigned long nr_segs = iter.nr_segs;
>  		ssize_t ret2 = 0;
>  
> -		if (req->file->f_op->read_iter)
> -			ret2 = call_read_iter(req->file, kiocb, &iter);
> -		else
> -			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
> +		ret2 = io_iter_do_read(req, &iter);
>  
>  		/* Catch -EAGAIN return for forced non-blocking submission */
>  		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
> @@ -2799,17 +2919,26 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>  			ret = io_setup_async_rw(req, io_size, iovec,
>  						inline_vecs, &iter);
>  			if (ret)
> -				goto out_free;
> +				goto out;
>  			/* any defer here is final, must blocking retry */
>  			if (!(req->flags & REQ_F_NOWAIT) &&
>  			    !file_can_poll(req->file))
>  				req->flags |= REQ_F_MUST_PUNT;
> +			/* if we can retry, do so with the callbacks armed */
> +			if (io_rw_should_retry(req)) {
> +				ret2 = io_iter_do_read(req, &iter);
> +				if (ret2 == -EIOCBQUEUED) {
> +					goto out;
> +				} else if (ret2 != -EAGAIN) {
> +					kiocb_done(kiocb, ret2);
> +					goto out;
> +				}
> +			}
> +			kiocb->ki_flags &= ~IOCB_WAITQ;
>  			return -EAGAIN;
>  		}
>  	}
> -out_free:
> -	kfree(iovec);
> -	req->flags &= ~REQ_F_NEED_CLEANUP;

This looks fishy. For instance, if it fails early on rw_verify_area(), how would
it free yet on-stack iovec? Is it handled somehow?

> +out:
>  	return ret;
>  }
>  
> 

-- 
Pavel Begunkov
