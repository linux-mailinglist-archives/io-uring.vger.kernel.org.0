Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF10D1DB4AB
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgETNMa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 09:12:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35283 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726435AbgETNM3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 09:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589980347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fVHAlLCiyxf/3Z46XdaOnIX/MSI+az66ksiZXhLsP5Q=;
        b=MgWWdHWFVdKaOszZgmRz5aFzR1/cfR7sl3DFTXjZkojtaDtwOibbRnskRjoFVJzu7zRuTQ
        RmhvnA82r6FBqdQ1/aVw7TiPI1Y8yz6dB1KMno2WAVy9rdk3tn/uLcXAxda6AVW58ckM2j
        vkssVVREgFuGTs6dxeJQn4B2XJ6vtNQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-tpBKwqO7NsqWM-WRjJsTUg-1; Wed, 20 May 2020 09:12:26 -0400
X-MC-Unique: tpBKwqO7NsqWM-WRjJsTUg-1
Received: by mail-wm1-f71.google.com with SMTP id f62so1238177wme.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fVHAlLCiyxf/3Z46XdaOnIX/MSI+az66ksiZXhLsP5Q=;
        b=rhXP/c2u9nr+ZWN1Wwxd6WSVs3h4y4McNAUuseXgMM4tD8SxCwjoR5Tv6PJPYDtRZ6
         oWZYoxqSVPUXBfdw6a25rxHoQyJoBC94tv7GThkMg7OLW6Hw2RIXIF/lRcD+ZdbnIMZy
         SOFCKJsI66sseGWTKYdVnrM6vFdNmr80C62Zs1HwfKT1BWVsi61a1K/GwsUsrhb0IDTT
         jiIHsl4T+dDAxnnaMJ1xsPRBPC+F14PyTgabgvYZC5DZmH+wR0NVP2mOACpAorpu7dhs
         AAnb/LQk9EP+e3BWT/6XXqWbPoAMSDvgo/3WBOw9MwhpFEgazUMbXvNqaVjS4iwAypB1
         8R0w==
X-Gm-Message-State: AOAM533RrVexFNPVygQMjVXVlO70VPj3B6FYEIeeTCVrHgEts/KDIIiv
        swZieneMz8FeKNavenn5ArMBQYNY5zyamF0/IekjMg1Pbw33DeRDaNjNhq3K07jph27/udVbr8o
        bbFfNM5aQcWV8Hmk2HOM=
X-Received: by 2002:a7b:c8d2:: with SMTP id f18mr4522008wml.174.1589980344594;
        Wed, 20 May 2020 06:12:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIbe446scm+P/ErDZNdpdoEb0+ye1vFBqygzAcTqE4hxtBSqxjlyeGG8ma4j1+4knl2egzFA==
X-Received: by 2002:a7b:c8d2:: with SMTP id f18mr4521991wml.174.1589980344276;
        Wed, 20 May 2020 06:12:24 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u10sm2999780wmc.31.2020.05.20.06.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 06:12:23 -0700 (PDT)
Date:   Wed, 20 May 2020 15:12:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH liburing 3/5] Add helpers to set and get eventfd
 notification status
Message-ID: <20200520131221.rktn7dy42e633rvg@steredhat>
References: <20200515164331.236868-1-sgarzare@redhat.com>
 <20200515164331.236868-4-sgarzare@redhat.com>
 <5bee86d5-f8bf-5b61-dd26-5e7d0448a217@kernel.dk>
 <20200515171111.zwgblergup6a23p2@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515171111.zwgblergup6a23p2@steredhat>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 15, 2020 at 07:11:11PM +0200, Stefano Garzarella wrote:
> On Fri, May 15, 2020 at 10:53:50AM -0600, Jens Axboe wrote:
> > On 5/15/20 10:43 AM, Stefano Garzarella wrote:
> > > This patch adds the new IORING_CQ_EVENTFD_DISABLED flag. It can be
> > > used to disable/enable notifications from the kernel when a
> > > request is completed and queued to the CQ ring.
> > > 
> > > We also add two helpers function to check if the notifications are
> > > enabled and to enable/disable them.
> > > 
> > > If the kernel doesn't provide CQ ring flags, the notifications are
> > > always enabled if an eventfd is registered.
> > > 
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >  src/include/liburing.h          | 30 ++++++++++++++++++++++++++++++
> > >  src/include/liburing/io_uring.h |  7 +++++++
> > >  2 files changed, 37 insertions(+)
> > > 
> > > diff --git a/src/include/liburing.h b/src/include/liburing.h
> > > index ea596f6..fe03547 100644
> > > --- a/src/include/liburing.h
> > > +++ b/src/include/liburing.h
> > > @@ -9,7 +9,9 @@ extern "C" {
> > >  #include <sys/socket.h>
> > >  #include <sys/uio.h>
> > >  #include <sys/stat.h>
> > > +#include <errno.h>
> > >  #include <signal.h>
> > > +#include <stdbool.h>
> > >  #include <inttypes.h>
> > >  #include <time.h>
> > >  #include "liburing/compat.h"
> > > @@ -445,6 +447,34 @@ static inline unsigned io_uring_cq_ready(struct io_uring *ring)
> > >  	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
> > >  }
> > >  
> > > +static inline int io_uring_cq_eventfd_enable(struct io_uring *ring,
> > > +					     bool enabled)
> > > +{
> > > +	uint32_t flags;
> > > +
> > > +	if (!ring->cq.kflags)
> > > +		return -ENOTSUP;
> > > +
> > > +	flags = *ring->cq.kflags;
> > > +
> > > +	if (enabled)
> > > +		flags &= ~IORING_CQ_EVENTFD_DISABLED;
> > > +	else
> > > +		flags |= IORING_CQ_EVENTFD_DISABLED;
> > > +
> > > +	IO_URING_WRITE_ONCE(*ring->cq.kflags, flags);
> > > +
> > > +	return 0;
> > > +}
> > 
> > The -ENOTSUP seems a bit odd, I wonder if we should even flag that as an
> > error.
> 
> Do you think it's better to ignore the enabling/disabling if we don't have
> the flag field available?
> 
> > 
> > The function should probably also be io_uring_cq_eventfd_toggle() or
> > something like that, as it does both enable and disable.
> > 
> > Either that, or have two functions, and enable and disable.
> 
> Okay, I'll change it in io_uring_cq_eventfd_toggle().
> 
> > 
> > The bigger question is probably how to handle kernels that don't
> > have this feature. It'll succeed, but we'll still post events. Maybe
> > the kernel side should have a feature flag that we can test?
> 
> I thought about that, and initially I added a
> IORING_FEAT_EVENTFD_DISABLE, but then I realized that we are adding
> the CQ 'flags' field together with the eventfd disabling feature.
> 
> So I supposed that if 'p->cq_off.flags' is not zero, than the kernel
> supports CQ flags and also the IORING_CQ_EVENTFD_DISABLED bit.
> 
> Do you think that's okay, or should we add IORING_FEAT_EVENTFD_DISABLE
> (or something similar)?

Hi Jens,
I'm changing io_uring_cq_eventfd_enable() to io_uring_cq_eventfd_toggle().

Any advice on the error and eventual feature flag?

Thank you very much,
Stefano

