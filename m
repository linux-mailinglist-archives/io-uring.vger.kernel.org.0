Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D53528EFC8
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 12:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgJOKBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 06:01:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730970AbgJOKBv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 06:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602756109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/HCp3iLm5qe5ugZkOhC/roOadWXquElqk22xbC0g/B0=;
        b=es3Tgts5glwZibSoQNPDou/gv6M/7+fBBl/7/xA5u58Ag6nysrqcju6zyFg0zl0sZ/hjoI
        vq9EoAuezmGdAe9i/3BbepTpAEujsYnE6cpoSb5pNq+MLyLkDOTrmFXS0iOFNlB1d1rb8h
        XpHkc12AFP7Usvi5OvUCcgKPp5fDeFQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-Pi_nP-rOPha3KGcSStdYOQ-1; Thu, 15 Oct 2020 06:01:48 -0400
X-MC-Unique: Pi_nP-rOPha3KGcSStdYOQ-1
Received: by mail-wm1-f71.google.com with SMTP id r19so1516534wmh.9
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 03:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/HCp3iLm5qe5ugZkOhC/roOadWXquElqk22xbC0g/B0=;
        b=YJrgSH4USuigY+tymvFvubEf8FD+YmsPEIlbIbm8juSN+YzuRkLkJveKkBCKGE1KgM
         Xxz66MtF/X9t4MtiQ6IqkAlCsBYNUAFAixnmj1yVcHJZS7JwUaGU466+D7T4uTBpQWBw
         3IpXy7ECqJxORMqa3RPKHdp2gsvlJ8mQBYVU1mm0wmMm66lVa2CGOjFgGIiLGUwcvpLF
         O8/LlLIa1GLzFn6Pc9B9bOLhPtdPGdwvW8pEAAoDL1x38AJvD8MWvMZzDaGItb1rBt+M
         TxakivPVN0cIVStfzLBktNwM612qrQRaadAPSjGdx5T78xvTh/zoeBeqO6IEZJPUsUXM
         WIfQ==
X-Gm-Message-State: AOAM531HYt0po820dY6Rh55AuxAck8DOSA3xlpNlYBPTa4tFxfdZ5bWj
        mKHJ11CGiUkPqLp69ler7Cqi5gkpM8sxkb9nbEbLfsGd5phgZHDfN6YJ7STmaHFo+/pEt24dYW0
        EPLSE9aIMTCppY52fufc=
X-Received: by 2002:adf:ba4f:: with SMTP id t15mr3234138wrg.335.1602756106600;
        Thu, 15 Oct 2020 03:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM/XWL1bD0KKFPctCT7or6K4T07BXU0/6ZrpvSXRTwOu0QViOmi0DKQ/XHeGT7xMpST0stSQ==
X-Received: by 2002:adf:ba4f:: with SMTP id t15mr3234125wrg.335.1602756106401;
        Thu, 15 Oct 2020 03:01:46 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id w4sm3457467wmi.10.2020.10.15.03.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 03:01:45 -0700 (PDT)
Date:   Thu, 15 Oct 2020 12:01:42 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH] io_uring: fix possible use after free to sqd
Message-ID: <20201015100142.k2uylzcwy6pu6vzw@steredhat>
References: <20201015091335.1667-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015091335.1667-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 15, 2020 at 05:13:35PM +0800, Xiaoguang Wang wrote:
> Reading codes finds a possible use after free issue to sqd:
>           thread1              |       thread2
> ==> io_attach_sq_data()        |
> ===> sqd = ctx_attach->sq_data;|
>                                | ==> io_put_sq_data()
>                                | ===> refcount_dec_and_test(&sqd->refs)
>                                |     If sqd->refs is zero, will free sqd.
>                                |
> ===> refcount_inc(&sqd->refs); |
>                                |
>                                | ====> kfree(sqd);
> ===> now use after free to sqd |
> 

IIUC the io_attach_sq_data() is called only during the setup of an
io_uring context, before that the fd is returned to the user space.

So, I'm not sure a second thread can call io_put_sq_data() while the
first thread is in io_attach_sq_data().

Can you check if this situation can really happen?

Thanks,
Stefano

> Use refcount_inc_not_zero() to fix this issue.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 33b5cf18bb51..48e230feb704 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6868,7 +6868,11 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> -	refcount_inc(&sqd->refs);
> +	if (!refcount_inc_not_zero(&sqd->refs)) {
> +		fdput(f);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	fdput(f);
>  	return sqd;
>  }
> -- 
> 2.17.2
> 

