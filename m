Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8222B14AA12
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 19:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0Sub (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 13:50:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47100 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725955AbgA0Sub (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 13:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580151030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T1Gai6vxTjkumKj6PkexgQY+X4x4Qxy3rVtAsMEidoI=;
        b=LdVqnkDPj6XqGkil2a7iClGFdn7e8anfytG2kZUGpu0Gr9o3SZA/gmq35GQdidcpPZ6AZy
        rwmxaTfrDdXS0VyExm/0y0KFeg3J1goNISgP2XTzmve2zVjGQD/kJuus7RDWrwhWYfxkaO
        Nbq8giCuRBKpDVGgEdGUNatFgvEHvco=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-hfVhIihPPPKiaA1p5v3iSA-1; Mon, 27 Jan 2020 13:50:28 -0500
X-MC-Unique: hfVhIihPPPKiaA1p5v3iSA-1
Received: by mail-wm1-f69.google.com with SMTP id b133so1918873wmb.2
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 10:50:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T1Gai6vxTjkumKj6PkexgQY+X4x4Qxy3rVtAsMEidoI=;
        b=CsyevQnS2LjOM4sFkGpNCD/888PSCmX5vdW0rvyWOTJWDk1lHFSrhRObdzMLA/WwKl
         +wRyNQJe/TOjLgh237gLq6wIK34KuGH/Ys5oAWqlHt0IdiW9ucoYbC+YvHBqmh0N4RqX
         NUNQDmuPPcMd3A4Rk21U4vhcMMKRxJQlUGFbS7qKBwj6n9vta7WkE6HC5dPUKt1fxnKQ
         4JLypMnPO04CEHhuHnn5ZBk1qfTCfeg8JQXpqsBm87HZ7K1dBW7N7s29L7UXm/PWX+9J
         cDNwW7tu5xEQYlLX3oazDejOOSHf993SzQP0MTJN73kk+BQGZcJwUJkyCelvMesG0i8N
         lxuw==
X-Gm-Message-State: APjAAAURjeWeXOe0jtuXz2IJMQg755Q1pWIb966vCrqvV9AyEvrodzi3
        CWR+83gmC3t2p8jBAYGDeQy686geb/vFCvmfKZc7gAYLJrit3i3REyqGcnKrSqPyZZtjyRvkza2
        smOABb/mpk3McRLgOHZc=
X-Received: by 2002:a1c:4144:: with SMTP id o65mr28713wma.81.1580151026731;
        Mon, 27 Jan 2020 10:50:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqzAwOQAd2U/RwoyuZU05L0e9solmdu8yt3ejwrX511RNsTq4+1QZAZv6aqaSgF3SixnfB11VA==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr28695wma.81.1580151026505;
        Mon, 27 Jan 2020 10:50:26 -0800 (PST)
Received: from steredhat ([80.188.125.198])
        by smtp.gmail.com with ESMTPSA id b10sm23618928wrt.90.2020.01.27.10.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 10:50:25 -0800 (PST)
Date:   Mon, 27 Jan 2020 19:50:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH liburing 1/1] test: add epoll test case
Message-ID: <20200127185024.zp4n3d6jktgnoznq@steredhat>
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <20200127161701.153625-2-sgarzare@redhat.com>
 <b1b26e79-507a-b339-2850-d2686661e669@kernel.dk>
 <20200127182534.5ljsj53vzpj6kkru@steredhat>
 <646cbb04-9bef-0d99-64ec-322d1584abe7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <646cbb04-9bef-0d99-64ec-322d1584abe7@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 27, 2020 at 11:46:34AM -0700, Jens Axboe wrote:
> On 1/27/20 11:25 AM, Stefano Garzarella wrote:
> > On Mon, Jan 27, 2020 at 09:32:43AM -0700, Jens Axboe wrote:
> >> On 1/27/20 9:17 AM, Stefano Garzarella wrote:
> >>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >>
> >> You're not reaping CQ events, and hence you overflow the ring. Once
> >> overflown, an attempt to submit new IO will returns in a -16/-EBUSY
> >> return value. This is io_uring telling you that it won't submit more
> >> IO until you've emptied the completion ring so io_uring can flush
> >> the overflown entries to the ring.
> > 
> > How can I reaping CQ events? (I was hoping the epoll would help me with that)
> > 
> > What I'm seeing is that the producer (EPOLLOUT) can fill the SQ without issues,
> > the consumer (read()) is receiving all the buffers produced, but the thread
> > that frees the buffers (EPOLLIN) is not woken up.
> > 
> > I tried to set a timeout to the epoll_wait(), but the io_uring_peek_cqe()
> > returns -EAGAIN.
> > 
> > If I'm using a ring with 16 entries, it seems to work better, but
> > sometimes I lose events and the thread that frees the buffer doesn't wake up.
> > 
> > Maybe I'm missing something...
> 
> OK, so that helps in terms of understanding the issue you are seeing with
> it. I'll take a look at this, but it'll probably be a few days. You can

Sure, take your time!

> try and enable tracing, I see events completed just fine. Maybe a race
> with your epoll wait and event reaping?

Could be. I'll try to investigate better enabling the tracing!

Thanks,
Stefano

