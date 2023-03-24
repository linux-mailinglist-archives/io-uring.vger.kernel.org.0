Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8348A6C8880
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 23:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCXWmn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 18:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjCXWmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 18:42:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9807E199D6
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 15:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679697714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AhMgDN/hJJA5BWda0Bw9R5FtPni7WAd5oqP98RV1O98=;
        b=AAHdZXIEIWguE+7zxZYS019XG7f5hIzOAfdzFnSPzBPrcdYO2RGU/D1JJBJkhJ8eQelWIS
        T1AdxQmTpD6puLV0/L5e3LIEBAhPpsCznGBmouJOUlfcy/5v1F5Z25FfPY5hkdDSwWAZUF
        zjCHOSAItuADXUGiLk48OP3TL7vOQHk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-aSfzXghwOJuYKQIeo8JKoQ-1; Fri, 24 Mar 2023 18:41:50 -0400
X-MC-Unique: aSfzXghwOJuYKQIeo8JKoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A2C23801F58;
        Fri, 24 Mar 2023 22:41:50 +0000 (UTC)
Received: from ovpn-8-20.pek2.redhat.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E4032A68;
        Fri, 24 Mar 2023 22:41:47 +0000 (UTC)
Date:   Sat, 25 Mar 2023 06:41:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring/rw: transform single vector readv/writev into
 ubuf
Message-ID: <ZB4nJStBSrPR9SYk@ovpn-8-20.pek2.redhat.com>
References: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 24, 2023 at 08:35:38AM -0600, Jens Axboe wrote:
> It's very common to have applications that use vectored reads or writes,
> even if they only pass in a single segment. Obviously they should be
> using read/write at that point, but...

Yeah, it is like fixing application issue in kernel side, :-)

> 
> Vectored IO comes with the downside of needing to retain iovec state,
> and hence they require and allocation and state copy if they end up
> getting deferred. Additionally, they also require extra cleanup when
> completed as the memory as the allocated state memory has to be freed.
> 
> Automatically transform single segment IORING_OP_{READV,WRITEV} into
> IORING_OP_{READ,WRITE}, and hence into an ITER_UBUF. Outside of being
> more efficient if needing deferral, ITER_UBUF is also more efficient
> for normal processing compared to ITER_IOVEC, as they don't require
> iteration. The latter is apparent when running peak testing, where
> using IORING_OP_READV to randomly read 24 drives previously scored:
> 
> IOPS=72.54M, BW=35.42GiB/s, IOS/call=32/31
> IOPS=73.35M, BW=35.81GiB/s, IOS/call=32/31
> IOPS=72.71M, BW=35.50GiB/s, IOS/call=32/31
> IOPS=73.29M, BW=35.78GiB/s, IOS/call=32/32
> IOPS=73.45M, BW=35.86GiB/s, IOS/call=32/32
> IOPS=73.19M, BW=35.74GiB/s, IOS/call=31/32
> IOPS=72.89M, BW=35.59GiB/s, IOS/call=32/31
> IOPS=73.07M, BW=35.68GiB/s, IOS/call=32/32
> 
> and after the change we get:
> 
> IOPS=77.31M, BW=37.75GiB/s, IOS/call=32/31
> IOPS=77.32M, BW=37.75GiB/s, IOS/call=32/32
> IOPS=77.45M, BW=37.81GiB/s, IOS/call=31/31
> IOPS=77.47M, BW=37.83GiB/s, IOS/call=32/32
> IOPS=77.14M, BW=37.67GiB/s, IOS/call=32/32
> IOPS=77.14M, BW=37.66GiB/s, IOS/call=31/31
> IOPS=77.37M, BW=37.78GiB/s, IOS/call=32/32
> IOPS=77.25M, BW=37.72GiB/s, IOS/call=32/32
> 
> which is a nice win as well.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 4c233910e200..5c998754cb17 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -402,7 +402,22 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
>  			      req->ctx->compat);
>  	if (unlikely(ret < 0))
>  		return ERR_PTR(ret);
> -	return iovec;
> +	if (iter->nr_segs != 1)
> +		return iovec;
> +	/*
> +	 * Convert to non-vectored request if we have a single segment. If we
> +	 * need to defer the request, then we no longer have to allocate and
> +	 * maintain a struct io_async_rw. Additionally, we won't have cleanup
> +	 * to do at completion time
> +	 */
> +	rw->addr = (unsigned long) iter->iov[0].iov_base;
> +	rw->len = iter->iov[0].iov_len;
> +	iov_iter_ubuf(iter, ddir, iter->iov[0].iov_base, rw->len);
> +	/* readv -> read distance is the same as writev -> write */
> +	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
> +			(IORING_OP_WRITE - IORING_OP_WRITEV));
> +	req->opcode += (IORING_OP_READ - IORING_OP_READV);

It is a bit fragile to change ->opcode, which may need matched callbacks for
the two OPs, also cause inconsistent opcode in traces.

I am wondering why not play the magic in io_prep_rw() from beginning?


Thanks,
Ming

