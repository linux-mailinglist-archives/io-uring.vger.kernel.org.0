Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFF41D5484
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgEOPY3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 11:24:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726407AbgEOPY1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 11:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589556265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VzRPEcij2ytmRUjwXvwU3l+szvwHyZ1DrCsePgKdvx4=;
        b=Ey6g1MA0lzyzwJNq7FpSfydZQQ8rBBe5bN5xIJN+5asJNdhevJDsg5rGbdGYpPNqL+yY1K
        gQsd7PJ0sXo8nVRMskqiNl0msJROQGRyWxNDd6bfq5itxHbQmzk8Xr6mFa3EZ7LioIlj/L
        8S70jAQkr+vM5X9s6AdNpwbh/mIUWrc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-nvI9DfC1OTqAFKVAp_mvUg-1; Fri, 15 May 2020 11:24:22 -0400
X-MC-Unique: nvI9DfC1OTqAFKVAp_mvUg-1
Received: by mail-wm1-f71.google.com with SMTP id n66so1338002wme.4
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 08:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VzRPEcij2ytmRUjwXvwU3l+szvwHyZ1DrCsePgKdvx4=;
        b=PfIg0hoZm6s1WXnlArq83sKfwELpz1AILM9pq+YZR2oO9XIQlN6yOSK33dAeCj12Ap
         74Hha9F0VIHgXwfXp3/yluGdWHSbq3L0TLiRWLkoutb1HTebXRcg4f+IsVBI8WhKkPvK
         bcl1gNBuHY+w86rwWg6Qbvi0/HS6SX4jTY/8jNDlB27D4s+218aY8Q5C61ZKKcEjg1yC
         0R/QCXIq7UPOTHJ0LV4GNuPRMVB9KtYi/+lywUpWB+hHfx7aK6esoDW89O4rcvMMkWmk
         IR+x/6y/PhSrqDFlPMREqjLJK4QLRJtU3Jt0c1KhmKPYjbJQxqz8sy0wZsILjcMGbjD/
         9ibQ==
X-Gm-Message-State: AOAM533lEOVZ9VAdVgxuqTJjFxFOtThjejmQE1UQIixBa+n1mBJcaG8i
        +igcY7znSX4fTS4j1kA3p71axK/L0b6SilesMPWIPF4lqLR4isG3zamOSifYGDouDr3DGdKMEw/
        ZxWzyr0kLG299DyZWXn8=
X-Received: by 2002:a7b:c149:: with SMTP id z9mr4390244wmi.57.1589556261468;
        Fri, 15 May 2020 08:24:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/JFClA1epQedUH1J6n85nIzDyd7T1UscbMYrQgKvv7JHyXYFXRLEdr/uSOI7mJshrJFl0kQ==
X-Received: by 2002:a7b:c149:: with SMTP id z9mr4390211wmi.57.1589556261046;
        Fri, 15 May 2020 08:24:21 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id a14sm3920850wme.21.2020.05.15.08.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 08:24:20 -0700 (PDT)
Date:   Fri, 15 May 2020 17:24:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/2] io_uring: add a CQ ring flag to enable/disable
 eventfd notification
Message-ID: <20200515152418.oi6btvogplmuezfn@steredhat>
References: <20200515105414.68683-1-sgarzare@redhat.com>
 <eaab5cc7-0297-a8f8-f7a9-e00bcf12b678@kernel.dk>
 <20200515143419.f3uggj7h3nyolfqb@steredhat>
 <a7ac101d-0f5d-2ab2-b36b-b40607d65878@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7ac101d-0f5d-2ab2-b36b-b40607d65878@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 15, 2020 at 09:13:33AM -0600, Jens Axboe wrote:
> On 5/15/20 8:34 AM, Stefano Garzarella wrote:
> > On Fri, May 15, 2020 at 08:24:58AM -0600, Jens Axboe wrote:
> >> On 5/15/20 4:54 AM, Stefano Garzarella wrote:
> >>> The first patch adds the new 'cq_flags' field for the CQ ring. It
> >>> should be written by the application and read by the kernel.
> >>>
> >>> The second patch adds a new IORING_CQ_NEED_WAKEUP flag that can be
> >>> used by the application to enable/disable eventfd notifications.
> >>>
> >>> I'm not sure the name is the best one, an alternative could be
> >>> IORING_CQ_NEED_EVENT.
> >>>
> >>> This feature can be useful if the application are using eventfd to be
> >>> notified when requests are completed, but they don't want a notification
> >>> for every request.
> >>> Of course the application can already remove the eventfd from the event
> >>> loop, but as soon as it adds the eventfd again, it will be notified,
> >>> even if it has already handled all the completed requests.
> >>>
> >>> The most important use case is when the registered eventfd is used to
> >>> notify a KVM guest through irqfd and we want a mechanism to
> >>> enable/disable interrupts.
> >>>
> >>> I also extended liburing API and added a test case here:
> >>> https://github.com/stefano-garzarella/liburing/tree/eventfd-disable
> >>
> >> Don't mind the feature, and I think the patches look fine. But the name
> >> is really horrible, I'd have no idea what that flag does without looking
> >> at the code or a man page. Why not call it IORING_CQ_EVENTFD_ENABLED or
> >> something like that? Or maybe IORING_CQ_EVENTFD_DISABLED, and then you
> >> don't have to muck with the default value either. The app would set the
> >> flag to disable eventfd, temporarily, and clear it again when it wants
> >> notifications again.
> > 
> > You're clearly right! :-) The name was horrible.
> 
> Sometimes you go down that path on naming and just can't think of
> the right one. I think we've all been there.

:-)

> 
> > I agree that IORING_CQ_EVENTFD_DISABLED should be the best.
> > I'll send a v2 changing the name and removing the default value.
> 
> Great thanks, and please do queue a pull for the liburing side too.

For the liburing side do you prefer a PR on github or posting the
patches on io-uring@vger.kernel.org with 'liburing' tag?

Thanks,
Stefano

