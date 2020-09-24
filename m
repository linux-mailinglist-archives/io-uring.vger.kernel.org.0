Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9296276E0E
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 11:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIXJ7m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Sep 2020 05:59:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726645AbgIXJ7m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Sep 2020 05:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600941580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ao9MbHaO+l2fwpm5oX+S1psBs6WTls1VUPglc2S1lbA=;
        b=hMzqv0+u5lNN22V8cT/aEKK5lZgpm6jbygZyHEia6S9zDXQ0KDhIh1GR4Do0HNMPdhEYwN
        9KAWu9wzI3qKgTvZUumzp7TcsmB7FznyBRFik5Lm7bu+Tc6ClhMBHyHG0YhgJnaFlC1RMQ
        ePg7nPPcKsRPtQ/KXW7XL8eo50QHXZM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-vg5z_tIoNOGx1usXgQC6FA-1; Thu, 24 Sep 2020 05:59:38 -0400
X-MC-Unique: vg5z_tIoNOGx1usXgQC6FA-1
Received: by mail-wm1-f72.google.com with SMTP id a7so1043326wmc.2
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 02:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ao9MbHaO+l2fwpm5oX+S1psBs6WTls1VUPglc2S1lbA=;
        b=AxL5nXj2Lyb0jkWQpgKpmy9pCLnMD92pZkrLcTeQN1bTSgHZf0e4AbwNAu7Lae/ZKi
         QDCcd1Hq3HCWEZ/GbJvi652Orl/zIKFgO4BytYmtcppMQZ91wcjArk+AkNrBQ6N8Pzx6
         0PyXjaEXwFqZfliU7erNYWXigCq0jg44ye68TvFuH0p2QRjQ4Y7lWn8eJLUHEJ+fMy3P
         syUyvn7ngvnR759H7VOlhf8kptc6dlBSXXzru6Erlc28Vq6/a+LjyMM7Gx+Y7oz6q9qO
         WnG5GWDmgcxYFZav/QSJ6BWD+pGc8LfQbi3cBYjju4wZ+vXZmHHyZr8+9rg7tgo41PTZ
         v+pA==
X-Gm-Message-State: AOAM530vZiQU5Ng5LFo5AOIJt+NLOU6FEac58baPelB7nWb6ZWIvvJ6D
        Z7kP0hvRbQbOHnEt5YP616SzL36xz5nbYf856/x+ox0Zn1D/oiRT0sbkZLgNKGH/DA5X04DteNY
        CjFIBnM2+indf/EiVdsc=
X-Received: by 2002:a5d:444b:: with SMTP id x11mr4155099wrr.402.1600941576987;
        Thu, 24 Sep 2020 02:59:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdqdqKQ61FCOH48pyTmkB6GaXgpVZeJbgx9/u9ktuRv4mqUK0sWgJQcryln+4CA3oYgs2NOw==
X-Received: by 2002:a5d:444b:: with SMTP id x11mr4155083wrr.402.1600941576773;
        Thu, 24 Sep 2020 02:59:36 -0700 (PDT)
Received: from steredhat (host-80-116-189-193.retail.telecomitalia.it. [80.116.189.193])
        by smtp.gmail.com with ESMTPSA id 88sm2974668wrl.76.2020.09.24.02.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 02:59:36 -0700 (PDT)
Date:   Thu, 24 Sep 2020 11:59:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Ye Bin <yebin10@huawei.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Remove unneeded NULL check before free
Message-ID: <20200924095933.kqi6rblp65q5lmer@steredhat>
References: <20200924013606.93616-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924013606.93616-1-yebin10@huawei.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,
thanks for the patch, but as explained in some comments in the code,
it's seems faster to do the check and avoid to call kfree() in the
critical data path.

On Thu, Sep 24, 2020 at 09:36:06AM +0800, Ye Bin wrote:
> Fixes coccicheck warnig:
> fs//io_uring.c:5775:4-9: WARNING: NULL check before some freeing
> functions is not needed.
> fs//io_uring.c:1617:2-7: WARNING: NULL check before some freeing
> functions is not needed.
> fs//io_uring.c:3291:2-7: WARNING: NULL check before some freeing
> functions is not needed.
> fs//io_uring.c:3398:2-7: WARNING: NULL check before some freeing
> functions is not needed.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/io_uring.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 815be15c2aee..23f99ffbb480 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1613,8 +1613,7 @@ static bool io_dismantle_req(struct io_kiocb *req)
>  {
>  	io_clean_op(req);
>  
> -	if (req->async_data)
> -		kfree(req->async_data);
> +	kfree(req->async_data);
>  	if (req->file)
>  		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
>  
> @@ -3287,8 +3286,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  	ret = 0;
>  out_free:
>  	/* it's reportedly faster than delegating the null check to kfree() */
For example here ^

> -	if (iovec)
> -		kfree(iovec);
> +	kfree(iovec);
>  	return ret;
>  }
>  
> @@ -3394,8 +3392,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>  	}
>  out_free:
>  	/* it's reportedly faster than delegating the null check to kfree() */
> -	if (iovec)
> -		kfree(iovec);
> +	kfree(iovec);
>  	return ret;
>  }
>  
> @@ -5771,8 +5768,7 @@ static void __io_clean_op(struct io_kiocb *req)
>  		case IORING_OP_WRITE_FIXED:
>  		case IORING_OP_WRITE: {
>  			struct io_async_rw *io = req->async_data;
> -			if (io->free_iovec)
> -				kfree(io->free_iovec);
> +			kfree(io->free_iovec);
>  			break;
>  			}
>  		case IORING_OP_RECVMSG:
> -- 
> 2.16.2.dirty
> 

Thanks,
Stefano

