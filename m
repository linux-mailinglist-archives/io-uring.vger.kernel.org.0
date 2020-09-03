Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1D25C1C9
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 15:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgICNlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 09:41:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728954AbgICMpv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 08:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599137116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qdOwG6C0xVpRM9FxIsMJDxJopN74h908e4YUN5Qx+xA=;
        b=g6Jl5tInP+x1sxKNrqZW+aJcQdaB+nh21t0Id5bGEXp7vRuIsFpwOraRjm0MXPeeaM11bk
        ZKjDK2MN17f7pGsVU88ZxnZFSC4HOzYEPiIuMwBjUsPjKH7w8o0Pgp1gzB1vcUJ5Vq9ocP
        LPoV4U3WMvtPCaNd8wBDZ1RkII2mB4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-rF8mS_whPbGxF9Hsx2P6Ug-1; Thu, 03 Sep 2020 08:43:10 -0400
X-MC-Unique: rF8mS_whPbGxF9Hsx2P6Ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79DF01019628;
        Thu,  3 Sep 2020 12:43:09 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05F807EED2;
        Thu,  3 Sep 2020 12:43:08 +0000 (UTC)
Date:   Thu, 3 Sep 2020 08:43:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 3/4] fsstress: fix memory leak in do_aio_rw
Message-ID: <20200903124307.GC444163@bfoster>
References: <20200823063032.17297-1-zlang@redhat.com>
 <20200823063032.17297-4-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823063032.17297-4-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 23, 2020 at 02:30:31PM +0800, Zorro Lang wrote:
> If io_submit or io_getevents fails, the do_aio_rw() won't free the
> "buf" and cause memory leak.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

Can we use the same approach here as suggested in patch 1 to reduce the
number of labels? Otherwise looks Ok to me..

Brian

>  ltp/fsstress.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index ef2017a8..17b024b5 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -2099,8 +2099,7 @@ do_aio_rw(int opno, long r, int flags)
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
>  			printf("%d/%d: do_aio_rw - no filename\n", procid, opno);
> -		free_pathname(&f);
> -		return;
> +		goto aio_out3;
>  	}
>  	fd = open_path(&f, flags|O_DIRECT);
>  	e = fd < 0 ? errno : 0;
> @@ -2109,16 +2108,13 @@ do_aio_rw(int opno, long r, int flags)
>  		if (v)
>  			printf("%d/%d: do_aio_rw - open %s failed %d\n",
>  			       procid, opno, f.path, e);
> -		free_pathname(&f);
> -		return;
> +		goto aio_out3;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
>  			printf("%d/%d: do_aio_rw - fstat64 %s failed %d\n",
>  			       procid, opno, f.path, errno);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		goto aio_out2;
>  	}
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (!iswrite && stb.st_size == 0) {
> @@ -2150,6 +2146,12 @@ do_aio_rw(int opno, long r, int flags)
>  	else if (len > diob.d_maxiosz)
>  		len = diob.d_maxiosz;
>  	buf = memalign(diob.d_mem, len);
> +	if (!buf) {
> +		if (v)
> +			printf("%d/%d: do_aio_rw - memalign failed\n",
> +			       procid, opno);
> +		goto aio_out2;
> +	}
>  
>  	if (iswrite) {
>  		off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
> @@ -2166,27 +2168,26 @@ do_aio_rw(int opno, long r, int flags)
>  		if (v)
>  			printf("%d/%d: %s - io_submit failed %d\n",
>  			       procid, opno, iswrite ? "awrite" : "aread", e);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		goto aio_out1;
>  	}
>  	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
>  		if (v)
>  			printf("%d/%d: %s - io_getevents failed %d\n",
>  			       procid, opno, iswrite ? "awrite" : "aread", e);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		goto aio_out1;
>  	}
>  
>  	e = event.res != len ? event.res2 : 0;
> -	free(buf);
>  	if (v)
>  		printf("%d/%d: %s %s%s [%lld,%d] %d\n",
>  		       procid, opno, iswrite ? "awrite" : "aread",
>  		       f.path, st, (long long)off, (int)len, e);
> -	free_pathname(&f);
> + aio_out1:
> +	free(buf);
> + aio_out2:
>  	close(fd);
> + aio_out3:
> +	free_pathname(&f);
>  }
>  #endif
>  
> -- 
> 2.20.1
> 

