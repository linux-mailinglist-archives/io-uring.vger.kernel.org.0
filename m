Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892AD23D79C
	for <lists+io-uring@lfdr.de>; Thu,  6 Aug 2020 09:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgHFHmo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 03:42:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46606 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727998AbgHFHmk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 03:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596699758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9DgNQaGMq045VNsDMt7arHvCe+ceyFhnvLTuiY14Nyo=;
        b=coOmYURsVUB8Wc1fnoZkNNG7oMJspkWiUTOrkoVXedda/Azl4JIm5UQE2TkmCrV/G0+zT0
        lZU3W4LsdWMIRpY90S6H/Exp3pcbXlNfOqbdOHAYubLFdT0ylB0ov5kl+U/A6G0WTPvtA2
        oSOhDd0sMX86oiIkDcasEfcv+wgUHKU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-bqqwPrVIOuC7fWcJ-NBYZw-1; Thu, 06 Aug 2020 03:42:36 -0400
X-MC-Unique: bqqwPrVIOuC7fWcJ-NBYZw-1
Received: by mail-wm1-f72.google.com with SMTP id u14so2702497wml.0
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 00:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9DgNQaGMq045VNsDMt7arHvCe+ceyFhnvLTuiY14Nyo=;
        b=G0OeCsMa+oUkdVKlhobSTqtPEymbnSclEIsJnE+MEWMuajXmCeMnjIeF2Q8HTInpMA
         VqMvYm46QZWtQurbz9xBiGEmxZ7jFiX9mALNRNtt5uxtKBDVMIVexdoRPkYPKZol/lbU
         U1r/LjU/DEyy2lLyNfLkatXxhOwJQ1ls5PmmJrxRVzCfZmpqkdEcBe4P5Le3LA0I47eb
         +xcNCo79atwP51zIybrWI5X+8BbkXJV+MdZQk+1RUqG9WdCg0mR9CYj38DYIxqIg2FnF
         RqCw8iEEuf3NRzymfvnsCSaSHP42D8vzeUuyHtBAOqldZuJcxc6uH/5cKpDC5hoF0WkI
         /crQ==
X-Gm-Message-State: AOAM53228XI2cCCV0WjReGiav47j17nBB6e2nLMg2AkSK724HpoPX8n0
        CvL5MKVO1CM1hrr9BlZB5RgeiIzwpJ1XElRYOBbO4gec8dD5QvNDcKzmiK6A4E/5yBNkrQbw5DW
        1HBe0gghF92NkWFqIivc=
X-Received: by 2002:a1c:660a:: with SMTP id a10mr6335755wmc.115.1596699755564;
        Thu, 06 Aug 2020 00:42:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPMeQz/1TQGmlC78Lgr0+9xfq3YQpwVFaCo3MM8wA2VFxVsNKX2+/m3tbqdwPXiuEhF4WM/w==
X-Received: by 2002:a1c:660a:: with SMTP id a10mr6335741wmc.115.1596699755315;
        Thu, 06 Aug 2020 00:42:35 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id f15sm5214783wmj.39.2020.08.06.00.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 00:42:34 -0700 (PDT)
Date:   Thu, 6 Aug 2020 09:42:31 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring: account locked memory before potential
 error case
Message-ID: <20200806074231.mlmfbsl4shvvzodm@steredhat>
References: <20200805190224.401962-1-axboe@kernel.dk>
 <20200805190224.401962-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805190224.401962-3-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 05, 2020 at 01:02:24PM -0600, Jens Axboe wrote:
> The tear down path will always unaccount the memory, so ensure that we
> have accounted it before hitting any of them.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0d857f7ca507..7c42f63fbb0a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8341,6 +8341,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  	ctx->user = user;
>  	ctx->creds = get_current_cred();
>  
> +	/*
> +	 * Account memory _before_ installing the file descriptor. Once
> +	 * the descriptor is installed, it can get closed at any time.
> +	 */

What about update a bit the comment?
Maybe adding the commit description in this comment.

> +	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
> +		       ACCT_LOCKED);
> +	ctx->limit_mem = limit_mem;
> +
>  	ret = io_allocate_scq_urings(ctx, p);
>  	if (ret)
>  		goto err;
> @@ -8377,14 +8385,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		goto err;
>  	}
>  
> -	/*
> -	 * Account memory _before_ installing the file descriptor. Once
> -	 * the descriptor is installed, it can get closed at any time.
> -	 */
> -	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
> -		       ACCT_LOCKED);
> -	ctx->limit_mem = limit_mem;
> -
>  	/*
>  	 * Install ring fd as the very last thing, so we don't risk someone
>  	 * having closed it before we finish setup
> -- 
> 2.28.0
> 

Thanks,
Stefano

