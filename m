Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AE71D5097
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 16:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgEOOea (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 10:34:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37242 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbgEOOea (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 10:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589553267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YPPW99mhER0DTLJrY7k7qjs6mYGaRfNuIWRsMS5DxD4=;
        b=igt42rWm4p4EqajSx6DBEUjv6ehvL7SExGmclIV60PPw9lJBWQSlF3MU7M04fRlR6I9an5
        E8B0xwENYfDolObOhWUvvKaLV7uK9s92HmsCNWruWYC1gIVJ2+EcjCJ7GI1/NF6p2DNZ8a
        vO/lSnh3nzuNA532+W1HS3ZpC4/6aSw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-qKCXKSi8MF2knLNWwpFSOg-1; Fri, 15 May 2020 10:34:24 -0400
X-MC-Unique: qKCXKSi8MF2knLNWwpFSOg-1
Received: by mail-wr1-f71.google.com with SMTP id p13so123714wrt.1
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 07:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YPPW99mhER0DTLJrY7k7qjs6mYGaRfNuIWRsMS5DxD4=;
        b=RvoP+ALWOE1ONE3DslsJpnptLgXWj4FKaVCFtdFQitsJQ8IBiwH8aEl7OoHxhkkaJR
         HbW0G55E2Pxt1d8pvnR9feLSh3azChoZdbrtyBh0bqyHpMCUNIQnKw7NKRRVU7CzZcd7
         xz6sgC8QtTKSh4sWoHoq12DTmcTOGRrQXq7b3ewzQDXExbBmoQc3RLpNw3+IeTNGaQ0m
         3FT7k96R0dwoY5JQddeVcinvmwqNKLbp/LB7vmUlMVeMgrM72mESRU+uQKkFxUezOHW2
         91UX9llS8KDpcpQi6s81eylu4FcrxWYdH8TvVUGabRpml+J0Wb+VtvuqVVAhir2nBRbk
         ZfYA==
X-Gm-Message-State: AOAM531rsEOXU0NT5gSzcSz7Wz5F1catbHd0wV7iokWkBC/DPDE+FqoJ
        RrwvsR794kYi9m55HEH0cSzitlKueZIO9/fRi/xG+ieQ/dqm/v6M6CobSVbmgtfyKLQDD8ILUMq
        Iia77kJ2mMajfD+qFDds=
X-Received: by 2002:a05:600c:2146:: with SMTP id v6mr4491352wml.142.1589553263227;
        Fri, 15 May 2020 07:34:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxswSXxzRjvhiNjXtgD2tyDEe9Vc6xVHhiMSsIK2eJA3hHSpV0QUQQqX9uJlYnALaP1QwuvJQ==
X-Received: by 2002:a05:600c:2146:: with SMTP id v6mr4491326wml.142.1589553262983;
        Fri, 15 May 2020 07:34:22 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id a184sm3970985wmh.24.2020.05.15.07.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 07:34:22 -0700 (PDT)
Date:   Fri, 15 May 2020 16:34:19 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/2] io_uring: add a CQ ring flag to enable/disable
 eventfd notification
Message-ID: <20200515143419.f3uggj7h3nyolfqb@steredhat>
References: <20200515105414.68683-1-sgarzare@redhat.com>
 <eaab5cc7-0297-a8f8-f7a9-e00bcf12b678@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaab5cc7-0297-a8f8-f7a9-e00bcf12b678@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 15, 2020 at 08:24:58AM -0600, Jens Axboe wrote:
> On 5/15/20 4:54 AM, Stefano Garzarella wrote:
> > The first patch adds the new 'cq_flags' field for the CQ ring. It
> > should be written by the application and read by the kernel.
> > 
> > The second patch adds a new IORING_CQ_NEED_WAKEUP flag that can be
> > used by the application to enable/disable eventfd notifications.
> > 
> > I'm not sure the name is the best one, an alternative could be
> > IORING_CQ_NEED_EVENT.
> > 
> > This feature can be useful if the application are using eventfd to be
> > notified when requests are completed, but they don't want a notification
> > for every request.
> > Of course the application can already remove the eventfd from the event
> > loop, but as soon as it adds the eventfd again, it will be notified,
> > even if it has already handled all the completed requests.
> > 
> > The most important use case is when the registered eventfd is used to
> > notify a KVM guest through irqfd and we want a mechanism to
> > enable/disable interrupts.
> > 
> > I also extended liburing API and added a test case here:
> > https://github.com/stefano-garzarella/liburing/tree/eventfd-disable
> 
> Don't mind the feature, and I think the patches look fine. But the name
> is really horrible, I'd have no idea what that flag does without looking
> at the code or a man page. Why not call it IORING_CQ_EVENTFD_ENABLED or
> something like that? Or maybe IORING_CQ_EVENTFD_DISABLED, and then you
> don't have to muck with the default value either. The app would set the
> flag to disable eventfd, temporarily, and clear it again when it wants
> notifications again.

You're clearly right! :-) The name was horrible.

I agree that IORING_CQ_EVENTFD_DISABLED should be the best.
I'll send a v2 changing the name and removing the default value.

Thanks,
Stefano

