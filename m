Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0AD17959F
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 17:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgCDQsO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 11:48:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59302 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCDQsO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 11:48:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583340492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iwh6ArBhNlC/QzZYMfW6WQM30EkgNyAS0AeU4Ro9sDY=;
        b=Myi8qoPFGhK2VOTViuTt9BReD3uHSNbrVNTG9JRvXP5jD0klGJDHtKHML6GwRerVeVvw08
        VQE5MD3tyqGOlEJsup8ROWVguC04KyjsuZVvlEVzQaudhgSlzLhogO5OlvIPMKLrcSEFng
        EgXlhafjrGZyCvow2uGwpouztxnT1zg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-vVAtNJiyPyeaVrlC9ctX1w-1; Wed, 04 Mar 2020 11:48:11 -0500
X-MC-Unique: vVAtNJiyPyeaVrlC9ctX1w-1
Received: by mail-wm1-f72.google.com with SMTP id f207so1075271wme.6
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 08:48:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iwh6ArBhNlC/QzZYMfW6WQM30EkgNyAS0AeU4Ro9sDY=;
        b=d6aaQiXh5UcfVBodQxBPBfAlz26jU/90UgjOnDIVBs401PB22B8YcvdsnSo3EPaJeD
         ePHr2t+8wzxJg/Mi2+5U529Ccjg7apGgUxU4oROrn9tX3JfJKUw0kV3smS24vNwXf71f
         vQxkDyfqmakOZEorxpOzgCN/czMdv3N7nMcmriYNW14vD9WlTd2drr8zrYs/vtTBYw18
         pXIkZ3vmuqXvc5OpSD+Jndt3NvKzGkOiw9FKlnpQ3J5jURejqUvrA4V4+csDMxpawgA7
         e54gxhs7Bg65sNC+aJY7SdeRJ6OSIsvOt3NjAwyMS9a+QbzU0O3Pc82rcHlqMpwFSder
         UlEQ==
X-Gm-Message-State: ANhLgQ3P09TUOtumXXBt9cRTu/gtgHTU8aUZGMUI7xCVfEbkvBs+z6iq
        0Xd5DuH62kqYu0ToX0vKZ95CO+by2YkfeZ9IUP7q02Y1xGc/ch0HxcpQ+W8oevB2B2cHt1+K+UF
        qWQc97J9u1MeNgMjdzEM=
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr4326637wmi.108.1583340489629;
        Wed, 04 Mar 2020 08:48:09 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsNyLWu0uFAuo01q9LkN1pw0Tdrpz/UjV74a4G/Kr0JlmOeAm6griIqJdEVFCpIlrxATT+Wuw==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr4326621wmi.108.1583340489391;
        Wed, 04 Mar 2020 08:48:09 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id n11sm6627994wrw.11.2020.03.04.08.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 08:48:08 -0800 (PST)
Date:   Wed, 4 Mar 2020 17:48:06 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] io_uring: Fix unused function warnings
Message-ID: <20200304164806.3bsr2v7cvpq7sw5e@steredhat>
References: <20200304075352.31132-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075352.31132-1-yuehaibing@huawei.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 04, 2020 at 03:53:52PM +0800, YueHaibing wrote:
> If CONFIG_NET is not set, gcc warns:
> 
> fs/io_uring.c:3110:12: warning: io_setup_async_msg defined but not used [-Wunused-function]
>  static int io_setup_async_msg(struct io_kiocb *req,
>             ^~~~~~~~~~~~~~~~~~
> 
> There are many funcions wraped by CONFIG_NET, move them
> together to simplify code, also fix this warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/io_uring.c | 98 ++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 57 insertions(+), 41 deletions(-)
> 

Since the code under the ifdef/else/endif blocks now are huge, would it make
sense to add some comments for better readability?

I mean something like this:

#if defined(CONFIG_NET)
...
#else /* !CONFIG_NET */
...
#endif /* CONFIG_NET */


Thanks,
Stefano

