Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2AA1D5718
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgEORLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 13:11:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgEORLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 13:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589562680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F4Tn1VWmrprEpY0TBQuwzLFVUD13F3RCTylPt3QL3OM=;
        b=Mm8tOBMvGXEuE39LjfjOG2YWfWzi27xbkmWFtY2gK2K1WltBzSwJLGyuBKH9We1U+NfAr4
        R/+EnBd+PBd2mn2Jm/kp4PrqW0J0O+17hpe1ncMfeu247EQLnqzVcDTWuxlzuBQ/UNkfNl
        gmi90Qk/r5EwcWu1WM6ok5RpY0Ftfq0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-w_B-EUimNMewW8B2C8Rm8g-1; Fri, 15 May 2020 13:11:16 -0400
X-MC-Unique: w_B-EUimNMewW8B2C8Rm8g-1
Received: by mail-wm1-f72.google.com with SMTP id g10so1479435wme.0
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 10:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F4Tn1VWmrprEpY0TBQuwzLFVUD13F3RCTylPt3QL3OM=;
        b=pb4mTe1mmBwROnn5FE5BPKG1tYOp3DfTIY9oKySvp3Jc3mpG2p3CHnQn4QXl/idA+r
         1N82isKMxBbBX2iHf/Xpm2WLWx+UDCrGnRPZ3wUegg6KmQvh0MEnKYUHFFvMsWyhCPlP
         gCQ/WKz/9a8fPgviBzFk+uQSdu/ZqnUXkjaU5wAJfrvsGpxAqI9yz6OONDpifUxoqYB3
         cjzz7nTYNkWVvCqXRhR+sfiDPiY48sMI9L1Hqrp8NZMlzvFackZaz5/ykBx1LFE/LeNc
         5ZzOkDuFYMgSym6oEzcs1IjfJS05+HUGnWJgpvOA0qGv5EL+tS5g4kuRLFeN5oCLj8Qu
         zuSg==
X-Gm-Message-State: AOAM5334sewZ2i7tGISXA5eZaF0mLbckLlXK0cm01pGsqxliIYw64HeM
        4yUKScjnGVTyDG4lHmj9Q3N6wIdjM5xRROJcc80i2pRXtGx61VH1QLxRGu4rrZOiden4UUuWD9x
        kpX4ujmlioSBtK+3BsHM=
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr4902455wmj.164.1589562674499;
        Fri, 15 May 2020 10:11:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLE/6sZLYvZ8pnJZzETEaFE7fv8b4F0T1t8rqN5JDiENEWEFlvJHJaXfH6kIWOO43yyqYENw==
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr4902437wmj.164.1589562674238;
        Fri, 15 May 2020 10:11:14 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id i74sm4490290wri.49.2020.05.15.10.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 10:11:13 -0700 (PDT)
Date:   Fri, 15 May 2020 19:11:11 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH liburing 3/5] Add helpers to set and get eventfd
 notification status
Message-ID: <20200515171111.zwgblergup6a23p2@steredhat>
References: <20200515164331.236868-1-sgarzare@redhat.com>
 <20200515164331.236868-4-sgarzare@redhat.com>
 <5bee86d5-f8bf-5b61-dd26-5e7d0448a217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bee86d5-f8bf-5b61-dd26-5e7d0448a217@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 15, 2020 at 10:53:50AM -0600, Jens Axboe wrote:
> On 5/15/20 10:43 AM, Stefano Garzarella wrote:
> > This patch adds the new IORING_CQ_EVENTFD_DISABLED flag. It can be
> > used to disable/enable notifications from the kernel when a
> > request is completed and queued to the CQ ring.
> > 
> > We also add two helpers function to check if the notifications are
> > enabled and to enable/disable them.
> > 
> > If the kernel doesn't provide CQ ring flags, the notifications are
> > always enabled if an eventfd is registered.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  src/include/liburing.h          | 30 ++++++++++++++++++++++++++++++
> >  src/include/liburing/io_uring.h |  7 +++++++
> >  2 files changed, 37 insertions(+)
> > 
> > diff --git a/src/include/liburing.h b/src/include/liburing.h
> > index ea596f6..fe03547 100644
> > --- a/src/include/liburing.h
> > +++ b/src/include/liburing.h
> > @@ -9,7 +9,9 @@ extern "C" {
> >  #include <sys/socket.h>
> >  #include <sys/uio.h>
> >  #include <sys/stat.h>
> > +#include <errno.h>
> >  #include <signal.h>
> > +#include <stdbool.h>
> >  #include <inttypes.h>
> >  #include <time.h>
> >  #include "liburing/compat.h"
> > @@ -445,6 +447,34 @@ static inline unsigned io_uring_cq_ready(struct io_uring *ring)
> >  	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
> >  }
> >  
> > +static inline int io_uring_cq_eventfd_enable(struct io_uring *ring,
> > +					     bool enabled)
> > +{
> > +	uint32_t flags;
> > +
> > +	if (!ring->cq.kflags)
> > +		return -ENOTSUP;
> > +
> > +	flags = *ring->cq.kflags;
> > +
> > +	if (enabled)
> > +		flags &= ~IORING_CQ_EVENTFD_DISABLED;
> > +	else
> > +		flags |= IORING_CQ_EVENTFD_DISABLED;
> > +
> > +	IO_URING_WRITE_ONCE(*ring->cq.kflags, flags);
> > +
> > +	return 0;
> > +}
> 
> The -ENOTSUP seems a bit odd, I wonder if we should even flag that as an
> error.

Do you think it's better to ignore the enabling/disabling if we don't have
the flag field available?

> 
> The function should probably also be io_uring_cq_eventfd_toggle() or
> something like that, as it does both enable and disable.
> 
> Either that, or have two functions, and enable and disable.

Okay, I'll change it in io_uring_cq_eventfd_toggle().

> 
> The bigger question is probably how to handle kernels that don't
> have this feature. It'll succeed, but we'll still post events. Maybe
> the kernel side should have a feature flag that we can test?

I thought about that, and initially I added a
IORING_FEAT_EVENTFD_DISABLE, but then I realized that we are adding
the CQ 'flags' field together with the eventfd disabling feature.

So I supposed that if 'p->cq_off.flags' is not zero, than the kernel
supports CQ flags and also the IORING_CQ_EVENTFD_DISABLED bit.

Do you think that's okay, or should we add IORING_FEAT_EVENTFD_DISABLE
(or something similar)?

Thanks,
Stefano

