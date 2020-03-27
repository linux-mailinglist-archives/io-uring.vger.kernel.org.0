Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5E11952C3
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2020 09:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgC0I0c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Mar 2020 04:26:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32808 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgC0I0b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Mar 2020 04:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585297590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cuBOlFeJE+U0RV58d4tbcWwx84WgFSiUdAysVoDUa8Q=;
        b=PIezoxNKB7fRzIy/T9KVHT5CVM6BGgWKd1WSKduO//oOpxHtILdXgDvXxH1uOD/KcdrR4Z
        nra9uRnTgguIxsahHhF38J3FOnbPniJ6F3t6YcdFeaZK+h64C/jr7EbzjnS0n9dE0Y4Khg
        tT2K403K7BZHFCi6729XXbJWoD24UMM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-9_lmGwOJMreUh8am2r9S0w-1; Fri, 27 Mar 2020 04:26:28 -0400
X-MC-Unique: 9_lmGwOJMreUh8am2r9S0w-1
Received: by mail-wr1-f71.google.com with SMTP id u16so1181746wrp.14
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2020 01:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cuBOlFeJE+U0RV58d4tbcWwx84WgFSiUdAysVoDUa8Q=;
        b=gY7uYuwCPTx+u+jx377b9AejRDP1/3nuJlFbgt/hMLY+u0dz3BzRBncqVAK+zqOGx1
         CrkPS5FFiIKZO0rwPoswevlGQ4OUwmAHQ5/zDmh76neF/CiFjhWpBMeUdXNhG960zuLQ
         401AcwIp2fjNoMLdWkiINJMslSMSLtRm1fExD9Uc5+MnpM4mmI+zRtt22LyDkl9Xunr6
         ydhzDXXDkEVmxfGjj+ciT6bCapKal3/00umvXvYrXVEPix08XkhRTSf1N7Njq/zfHm6e
         RfjhgVnuykx2q8lApXzvqRQ6WKCdowO7zjJ34f2RlkMNQxlVC7S9yN6Z7WMk5KC6QjlY
         ssSA==
X-Gm-Message-State: ANhLgQ2v1zZin8X6fAiZ3AFQXZjayiU4u+rSjQkR8sZmfBe0CSKr1iwI
        DIq8B/KD53qXfh41BNufrszUKP0S5W+7qH92PEO99U2bv1j6SrT4bshok8R0loNfbLDFhk4G7PJ
        6B4BRQmEcCMeizGNKPjs=
X-Received: by 2002:a1c:a102:: with SMTP id k2mr3932232wme.125.1585297587205;
        Fri, 27 Mar 2020 01:26:27 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtdK19l+f1eTtpwnCVAl2XI1ZSXi7cNucxbv4U/j4okhlC1W1n1URmE535UnWv+oyRsZAC09Q==
X-Received: by 2002:a1c:a102:: with SMTP id k2mr3932215wme.125.1585297586937;
        Fri, 27 Mar 2020 01:26:26 -0700 (PDT)
Received: from steredhat (host32-201-dynamic.27-79-r.retail.telecomitalia.it. [79.27.201.32])
        by smtp.gmail.com with ESMTPSA id a13sm7405741wrh.80.2020.03.27.01.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 01:26:26 -0700 (PDT)
Date:   Fri, 27 Mar 2020 09:26:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH] io_uring: cleanup io_alloc_async_ctx()
Message-ID: <20200327082624.wrugiip4jkkvmw2s@steredhat>
References: <20200327073652.2301-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327073652.2301-1-xiaoguang.wang@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 27, 2020 at 03:36:52PM +0800, Xiaoguang Wang wrote:
> Cleanup io_alloc_async_ctx() a bit, add a new __io_alloc_async_ctx(),
> so io_setup_async_rw() won't need to check whether async_ctx is true
> or false again.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Looks good to me!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3affd96a98ba..a85659eae137 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2169,12 +2169,18 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
>  	}
>  }
>  
> +static inline int __io_alloc_async_ctx(struct io_kiocb *req)
> +{
> +	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
> +	return req->io == NULL;
> +}
> +
>  static int io_alloc_async_ctx(struct io_kiocb *req)
>  {
>  	if (!io_op_defs[req->opcode].async_ctx)
>  		return 0;
> -	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
> -	return req->io == NULL;
> +
> +	return  __io_alloc_async_ctx(req);
>  }
>  
>  static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
> @@ -2184,7 +2190,7 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
>  	if (!io_op_defs[req->opcode].async_ctx)
>  		return 0;
>  	if (!req->io) {
> -		if (io_alloc_async_ctx(req))
> +		if (__io_alloc_async_ctx(req))
>  			return -ENOMEM;
>  
>  		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
> -- 
> 2.17.2
> 

