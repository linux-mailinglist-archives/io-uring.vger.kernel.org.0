Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F551DB7CB
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 17:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgETPLx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 11:11:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51455 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgETPLw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 11:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589987511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FnZGaYB5JEoh43LNsVZ3gtObekp0nEgqfONUbbcPSIg=;
        b=gXcWug3ZXUYfoBuFpLDUN6hfV0LgMj7dcGD5D7XioT7EqHIjjcdyJW6+hGX4UPOcp8yC7v
        7KtH5CjDbbVlesDrB7bpO3QHdCtmNo6ZuarSZu8+VywXYUko+biFbHfH4Premylb6ugtxU
        wQxzA/C+oqLFG1Sus4Q4Lcqx0Np/qQU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-UTVZfp58MhirmRSAU0TWxQ-1; Wed, 20 May 2020 11:11:47 -0400
X-MC-Unique: UTVZfp58MhirmRSAU0TWxQ-1
Received: by mail-wr1-f72.google.com with SMTP id p8so1533254wrj.5
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 08:11:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FnZGaYB5JEoh43LNsVZ3gtObekp0nEgqfONUbbcPSIg=;
        b=KO0GuJcfxIXfobF0CcL5B6b+I0zxetm8iOiYzBqMPiW+25s+TK7DhIeSAnJu4y/ZB9
         9raJibx8ezX21BtISYACP+qnQtszUTW3iCGN+KhahKb93BIpyBAIipZB3y1E39WX4tDR
         5JaOajUg1ggUheJ2Ap0RwGzRKBaSLq45hy+azBaUbjFsrg7IfgJy81DdC/jQZbkSNoZL
         r91VsKl9kvuAI59s7GdNsLFf25/Na6tQm2t0xvg4Uzno6AJDT2DgAoE6WeJonK7LJxQQ
         NW7IPuNxzb5WMcE8HA98lXgDim4kTW+h0fDQ9S9guzLYDN11KUDzvPQhDwdnZg61JTyb
         uKOw==
X-Gm-Message-State: AOAM530bHSTwEvfOPtzaF952kweXlBX4MeL5a5DHAWB23OvoANkKSybm
        PKvJvkSGi/Zq5igXjdLhZUS99BDD3m2vh3XtDPxS6ELCM+PeCa4yk0mZvRUn8cE0rSPTmGHpjP7
        +0LlyLGu3Z2dwsTe9ukE=
X-Received: by 2002:adf:ce90:: with SMTP id r16mr4377434wrn.86.1589987506218;
        Wed, 20 May 2020 08:11:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4wLnX+Zx4SBdZdbWRzRSPr65uAJiMNTtpwBqQICsLDHlOgq0VOm0LXW+pehtNLzEMDczxtg==
X-Received: by 2002:adf:ce90:: with SMTP id r16mr4377419wrn.86.1589987505922;
        Wed, 20 May 2020 08:11:45 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id q2sm3516771wmq.23.2020.05.20.08.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 08:11:45 -0700 (PDT)
Date:   Wed, 20 May 2020 17:11:43 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH liburing 3/5] Add helpers to set and get eventfd
 notification status
Message-ID: <20200520151143.22n3jkv2byfhioqj@steredhat>
References: <20200515164331.236868-1-sgarzare@redhat.com>
 <20200515164331.236868-4-sgarzare@redhat.com>
 <5bee86d5-f8bf-5b61-dd26-5e7d0448a217@kernel.dk>
 <20200515171111.zwgblergup6a23p2@steredhat>
 <20200520131221.rktn7dy42e633rvg@steredhat>
 <dc504f4a-6fbf-114a-086a-f6392baac84e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc504f4a-6fbf-114a-086a-f6392baac84e@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 20, 2020 at 07:43:43AM -0600, Jens Axboe wrote:
> On 5/20/20 7:12 AM, Stefano Garzarella wrote:
> >>> The bigger question is probably how to handle kernels that don't
> >>> have this feature. It'll succeed, but we'll still post events. Maybe
> >>> the kernel side should have a feature flag that we can test?
> >>
> >> I thought about that, and initially I added a
> >> IORING_FEAT_EVENTFD_DISABLE, but then I realized that we are adding
> >> the CQ 'flags' field together with the eventfd disabling feature.
> >>
> >> So I supposed that if 'p->cq_off.flags' is not zero, than the kernel
> >> supports CQ flags and also the IORING_CQ_EVENTFD_DISABLED bit.
> >>
> >> Do you think that's okay, or should we add IORING_FEAT_EVENTFD_DISABLE
> >> (or something similar)?
> > 
> > Hi Jens,
> > I'm changing io_uring_cq_eventfd_enable() to io_uring_cq_eventfd_toggle().
> 
> Sounds good.
> 
> > Any advice on the error and eventual feature flag?
> 
> I guess we can use cq_off.flags != 0 to tell if we have this feature or
> not, even though it's a bit quirky. But at the same time, probably not
> worth adding a specific feature flag for.

Agree.

> 
> For the error, -EOPNOTSUPP seems fine if we don't have the feature. Just
> don't flag errors for enabling when already enabled, or vice versa. It's

Okay.

> inherently racy in that completions can come in while the app is calling
> the helper, so we should make the interface relaxed.

Yes, do you think we should also provide an interface to do double
check while re-enabling notifications?
Or we can leave this to the application?

I mean something like this:

    bool io_uring_cq_eventfd_safe_enable(struct io_uring *ring)
    {
        /* enable notifications */
        io_uring_cq_eventfd_toggle(ring, true);

        /* Do we have any more cqe in the ring? */
        if (io_uring_cq_ready(ring)) {
            io_uring_cq_eventfd_toggle(ring, false);
            return false;
        }

        return true;
    }

Thanks,
Stefano

