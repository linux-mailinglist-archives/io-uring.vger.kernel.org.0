Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5723DDB3
	for <lists+io-uring@lfdr.de>; Thu,  6 Aug 2020 19:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgHFRN0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 13:13:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33539 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730441AbgHFRNU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 13:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596733999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h6VQ+ld8K59/1Mk6GQHZQGHAZ42eDceDi77a6JENzsY=;
        b=fsFfmu2jmiNnLM+jm3Kn5OHrPqBUndirlU4CCVaOLygQXJhj1E6eyLfzrGp/UPzqI6803o
        u5xXKNnJnkQJql/w4fCMJwPnQ8WafEfIFtqZIBUcE90RpCH7rMEh8J+ayWjjvg2S6pYMVs
        DPK4iWgKj546ohUXMzTIXulkLBJVLXc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-c-RS1nUoPsGLybWQ45oy-Q-1; Thu, 06 Aug 2020 09:38:53 -0400
X-MC-Unique: c-RS1nUoPsGLybWQ45oy-Q-1
Received: by mail-wr1-f72.google.com with SMTP id t3so13778105wrr.5
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 06:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h6VQ+ld8K59/1Mk6GQHZQGHAZ42eDceDi77a6JENzsY=;
        b=Zihja/sWRJ/LT/L6GA4SRHU+cszMmeeHOssTKmEL7hsT5YK95cfbFey9EFwzZ1zeTs
         LF0NKpmvyn0tw++27iyzL5rzGQBP4Fr9US04a+jWPmAl2i9uQTB+1JB9PrPM3X7S31w9
         Z4fPA/eZiN+P2TKa7cIzIB3U06WvbKbm+qMat0LISF4ojgiYRNK5C4l6eyh4HI70ILYC
         akIZnsM0ucn8mBLim9JZd6p6AgH4BPrllsrpkyrzQNZ7sDrk99ky6+/bz4kyZV1/7Yqr
         czFIuUSEt96lsZrelPoSqd4hXWIRu3D6niTRC9tXKyvqjclbKPViM+vKOWw+ownI8N1W
         BVyQ==
X-Gm-Message-State: AOAM531udiw0gxJSBBmBZtO8KinszuO0PXfsGwWsuCvRn81lnN1gYyMa
        M8qg+A1+yVJPAX3zORlx8n/n5rWf3SCMPzdxD6uU05X9Dh316+TmHhDyklX+rFpMG8gH9bSQKgF
        MEv/I3POaYlPjQm6Sf4o=
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr8555077wmc.181.1596721132251;
        Thu, 06 Aug 2020 06:38:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjUWjNqPuJoUz/5m+CIYONmWRM16fFw7/ffqb4yNn7NjFPjcfPwUdNEfsqqUxYNC74sJNXyQ==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr8555062wmc.181.1596721132024;
        Thu, 06 Aug 2020 06:38:52 -0700 (PDT)
Received: from steredhat ([5.171.234.104])
        by smtp.gmail.com with ESMTPSA id i7sm6802096wrs.25.2020.08.06.06.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 06:38:51 -0700 (PDT)
Date:   Thu, 6 Aug 2020 15:38:48 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring: account locked memory before potential
 error case
Message-ID: <20200806133848.xbpueoydtemjgofy@steredhat>
References: <20200805190224.401962-1-axboe@kernel.dk>
 <20200805190224.401962-3-axboe@kernel.dk>
 <20200806074231.mlmfbsl4shvvzodm@steredhat>
 <e7d046e3-8202-4c70-c6fb-760e3da63f24@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7d046e3-8202-4c70-c6fb-760e3da63f24@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 06, 2020 at 07:21:30AM -0600, Jens Axboe wrote:
> On 8/6/20 1:42 AM, Stefano Garzarella wrote:
> > On Wed, Aug 05, 2020 at 01:02:24PM -0600, Jens Axboe wrote:
> >> The tear down path will always unaccount the memory, so ensure that we
> >> have accounted it before hitting any of them.
> >>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> >>  fs/io_uring.c | 16 ++++++++--------
> >>  1 file changed, 8 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index 0d857f7ca507..7c42f63fbb0a 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -8341,6 +8341,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
> >>  	ctx->user = user;
> >>  	ctx->creds = get_current_cred();
> >>  
> >> +	/*
> >> +	 * Account memory _before_ installing the file descriptor. Once
> >> +	 * the descriptor is installed, it can get closed at any time.
> >> +	 */
> > 
> > What about update a bit the comment?
> > Maybe adding the commit description in this comment.
> 
> I updated the comment:
> 
> /*
>  * Account memory _before_ installing the file descriptor. Once
>  * the descriptor is installed, it can get closed at any time. Also
>  * do this before hitting the general error path, as ring freeing
>  * will un-account as well.
> */

Now it looks better!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

