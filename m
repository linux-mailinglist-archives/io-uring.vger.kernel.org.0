Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7223E943A
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhHKPHV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 11:07:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232736AbhHKPHV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 11:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628694417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JIEk0Gmm2g5IFWgCAxpSj2TbN/IiL85I8mQs7mN65ao=;
        b=iARuhhzYk3/7DstORFje8WHEaEIvVo4Dfnth1t3inhF+9xQ1DPnLEDUX+jNtFjB+kfe31g
        WJPpRbb/fmVO6tmifHMVDnLyEludExJjYp7J6s9M75wxAi75QlSX9pfQvdzuQqF4+N0Dqa
        FtBt5Xh6z2YPyFAlEoOW0OfJ5zyN7vE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-bKoWpn5SNj6kDEbLqkdnMg-1; Wed, 11 Aug 2021 11:06:55 -0400
X-MC-Unique: bKoWpn5SNj6kDEbLqkdnMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0357193F561;
        Wed, 11 Aug 2021 15:06:54 +0000 (UTC)
Received: from T590 (ovpn-12-52.pek2.redhat.com [10.72.12.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 437FA1B4B8;
        Wed, 11 Aug 2021 15:06:47 +0000 (UTC)
Date:   Wed, 11 Aug 2021 23:06:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Enable bio recycling for polled IO
Message-ID: <YRPng+SoCG/wndY2@T590>
References: <20210810163728.265939-1-axboe@kernel.dk>
 <YROJuSsUX7y236BW@infradead.org>
 <YROw06H0z0Js8yg3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YROw06H0z0Js8yg3@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 11, 2021 at 12:13:23PM +0100, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 09:26:33AM +0100, Christoph Hellwig wrote:
> > I really don't like all the layering violations in here.  What is the
> > problem with a simple (optional) percpu cache in the bio_set?  Something
> > like the completely untested patch below:
> 
> A slightly updated version that actually compiles and survives minimal
> testing is here:
> 
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bio-cache

Just wondering if the percpu bio cache may perform better than slab which
should be very similar with percpu allocation. And here the cached bio is
just one fixed length bio with inline bvecs.

BTW, in the patch of 'io_uring: ask for bio caching', you have to not
set IOCB_ALLOC_CACHE just like what Jens did, otherwise it will break 
when using io_uring over queue without POLL capability.

Thanks,
Ming

