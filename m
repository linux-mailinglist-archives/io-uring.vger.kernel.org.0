Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C99225189D
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 14:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHYMdn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 08:33:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727839AbgHYMdk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 08:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598358819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l1c0I//3+o4PplxXwn5lYS594Owtge+mj2VPKsZJJmk=;
        b=NbYVuqsXWOuB1cu+TmTnXljabBvHdcU4HSNT7yf8sF/eSFneRKor9pTxiACH8xAsnDz3tN
        jzBhIDjpfcd0FE7V2+LNL20Z77DQoWxR4YIH/H4ZVsQCz40Yn5la9XaAZhoufurTyHzfh3
        I8cNjEcKsprre2K7Uh8sVEvTVnusSPk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-445jnCDgMVCpYsoDyS7jnQ-1; Tue, 25 Aug 2020 08:33:37 -0400
X-MC-Unique: 445jnCDgMVCpYsoDyS7jnQ-1
Received: by mail-wr1-f71.google.com with SMTP id u10so3756548wrp.3
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 05:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l1c0I//3+o4PplxXwn5lYS594Owtge+mj2VPKsZJJmk=;
        b=eFMQw2CmHbPpAlrXH+l5e9+EsNUQdPjNbpFrEhoxXWHQaN618OrlvAykhgw4HM/iSt
         MykLCqTS9EjqPkt5UT6diqyIm9+cZPz7VJ6Uz+r4LXQNiG3zJ+i0Dsq44tiT41croP+7
         tLeIiAVl2inz/yaCW6PhtSPI/+nu2piDyagm412IGfE+wx6+txwCU6qZGgunF5iJl7Z3
         P0ogoLH/siUSam4iDxCk/AI2OR+IPk8HheuFuGRy8mdsls9bNgr3Asx7EBfliZ3hBS+m
         xB/2R3ab5Es30j8j0/NoShQJtmqmsMoIJAd+q8Nmv5EKRSU6J9hw31c8BKjfhuZP//iu
         S5xg==
X-Gm-Message-State: AOAM530YpRTTNZU2ns1GCdsbtAI7cxlLzz55yj4kiP7Z4SukMreC0nob
        O01KzzhErPtOLOQ0Nz/N41uf0BbV6Wmm6HRS+2YNhqzxlZVthqqPd4SYmjabkjaipnH64oZzDWl
        FhR27hBCamhIH0XmIB1k=
X-Received: by 2002:a5d:6692:: with SMTP id l18mr10379714wru.211.1598358815489;
        Tue, 25 Aug 2020 05:33:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO82QXNM3kkHJRMgFwSJOviAhAObsBWPDECsT5Tj4hfH8S1o8QH99AK5cbgWnuP+aJLE5iTA==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr10379694wru.211.1598358815181;
        Tue, 25 Aug 2020 05:33:35 -0700 (PDT)
Received: from steredhat (host-79-51-197-141.retail.telecomitalia.it. [79.51.197.141])
        by smtp.gmail.com with ESMTPSA id n21sm5311455wmc.11.2020.08.25.05.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 05:33:34 -0700 (PDT)
Date:   Tue, 25 Aug 2020 14:33:32 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: revert consumed iov_iter bytes on error
Message-ID: <20200825123332.lb3o5ah53jar7mbw@steredhat>
References: <a2e5bc52-d31a-3447-c4be-46d6bb1fd4b8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2e5bc52-d31a-3447-c4be-46d6bb1fd4b8@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 24, 2020 at 11:48:44AM -0600, Jens Axboe wrote:
> Some consumers of the iov_iter will return an error, but still have
> bytes consumed in the iterator. This is an issue for -EAGAIN, since we
> rely on a sane iov_iter state across retries.
> 
> Fix this by ensuring that we revert consumed bytes, if any, if the file
> operations have consumed any bytes from iterator. This is similar to what
> generic_file_read_iter() does, and is always safe as we have the previous
> bytes count handy already.
> 
> Fixes: ff6165b2d7f6 ("io_uring: retain iov_iter state over io_read/io_write calls")
> Reported-by: Dmitry Shulyak <yashulyak@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c9d526ff55e0..e030b33fa53e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3153,6 +3153,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  	} else if (ret == -EAGAIN) {
>  		if (!force_nonblock)
>  			goto done;
> +		/* some cases will consume bytes even on error returns */
> +		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>  		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
>  		if (ret)
>  			goto out_free;
> @@ -3294,6 +3296,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>  	if (!force_nonblock || ret2 != -EAGAIN) {
>  		kiocb_done(kiocb, ret2, cs);
>  	} else {
> +		/* some cases will consume bytes even on error returns */
> +		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>  copy_iov:
>  		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
>  		if (!ret)
> 

What about moving iov_iter_revert() in io_setup_async_rw(), passing
iov_initial_count as parameter?

Maybe it's out of purpose since we use it even when we're not trying again.


Anyway the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

