Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28597261A64
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 20:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbgIHSfh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 14:35:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54049 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731233AbgIHSf3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 14:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599590128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fv6gc7xhcdij2MKCbLF80ijHtpETi3w0Dc0YpgtmLiw=;
        b=FBZeSNV4iCYWQSemBFeBxWUkvc5t+251j6sHtkpRim+LWaPo6IwuksHBpFJJZKAcAkMz6x
        Xh3CsUvPElBUWvvjSnY39G10EvSkW88OP3tVM4UhrdhcydneEXNQ4U/p9QgN2dV3vgrb63
        jujrindNzADkD4/inPizrwU7u15iarQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-vLVa0lTfNIu8NPK8CYfOOA-1; Tue, 08 Sep 2020 14:35:25 -0400
X-MC-Unique: vLVa0lTfNIu8NPK8CYfOOA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA818393B1;
        Tue,  8 Sep 2020 18:35:24 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A09B5D9E8;
        Tue,  8 Sep 2020 18:35:24 +0000 (UTC)
Date:   Tue, 8 Sep 2020 14:35:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 3/5] fsstress: fix memory leak in do_aio_rw
Message-ID: <20200908183522.GC737175@bfoster>
References: <20200906175513.17595-1-zlang@redhat.com>
 <20200906175513.17595-4-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906175513.17595-4-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 07, 2020 at 01:55:11AM +0800, Zorro Lang wrote:
> If io_submit or io_getevents fails, the do_aio_rw() won't free the
> "buf" and cause memory leak.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  ltp/fsstress.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index b4a51376..c0e587a3 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
...
> @@ -2166,27 +2166,26 @@ do_aio_rw(int opno, long r, int flags)
>  		if (v)
>  			printf("%d/%d: %s - io_submit failed %d\n",
>  			       procid, opno, iswrite ? "awrite" : "aread", e);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		goto aio_out;
>  	}
>  	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
>  		if (v)
>  			printf("%d/%d: %s - io_getevents failed %d\n",
>  			       procid, opno, iswrite ? "awrite" : "aread", e);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		goto aio_out;
>  	}
>  
>  	e = event.res != len ? event.res2 : 0;
> -	free(buf);
>  	if (v)
>  		printf("%d/%d: %s %s%s [%lld,%d] %d\n",
>  		       procid, opno, iswrite ? "awrite" : "aread",
>  		       f.path, st, (long long)off, (int)len, e);
> + aio_out:
> +	if (buf)
> +		free(buf);
> +	if (fd > 0)
> +		close(fd);

Same nit here as patch 1. Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	free_pathname(&f);
> -	close(fd);
>  }
>  #endif
>  
> -- 
> 2.20.1
> 

