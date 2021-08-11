Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8543E943E
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhHKPJZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbhHKPJY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 11:09:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FF2C061765;
        Wed, 11 Aug 2021 08:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PbTlBXx64xIBd6bp3wQXIQvhWlAavlmN4y7TyNwbpuk=; b=tFvG5zzwmlCgeXRZyUDMVBlE7S
        dKI9BlEVxJzt59ZILch9VXb/irkBlT3ptKkeWXTwy8kG6OigcdWzVCItMu22imlFyvbzezQ6JpDBH
        MNS70mGMpScRC0Cb3UyNCkasWB3SffuTl72GmaH7FkRQkEPQteDkEEIvmLIG7iiGhRXTKie9B58q3
        y1pyIrvGtOmGZpBBfE9t2XF8EnrJdq7KC4vUo9j4OMV4Y9w5YmsYlycfsrGIazAXa81v2sg5E+Qz2
        Cf4NBawI/2eUxqQc2vjQ69oxNuJAqlU8HDmSQp8t+8ZEFeiD57B41npv7jtJAmLK79Chef1uzOo6p
        9bAvrl8A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDppu-00DXlz-Oq; Wed, 11 Aug 2021 15:08:13 +0000
Date:   Wed, 11 Aug 2021 16:08:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Enable bio recycling for polled IO
Message-ID: <YRPn1hvtALdkwevV@infradead.org>
References: <20210810163728.265939-1-axboe@kernel.dk>
 <YROJuSsUX7y236BW@infradead.org>
 <YROw06H0z0Js8yg3@infradead.org>
 <c244becd-2d94-5b49-ed33-58e6456d91d9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c244becd-2d94-5b49-ed33-58e6456d91d9@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 11, 2021 at 09:05:47AM -0600, Jens Axboe wrote:
> On 8/11/21 5:13 AM, Christoph Hellwig wrote:
> > On Wed, Aug 11, 2021 at 09:26:33AM +0100, Christoph Hellwig wrote:
> >> I really don't like all the layering violations in here.  What is the
> >> problem with a simple (optional) percpu cache in the bio_set?  Something
> >> like the completely untested patch below:
> > 
> > A slightly updated version that actually compiles and survives minimal
> > testing is here:
> > 
> > http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bio-cache
> 
> I like this approach, I've done something very similar in the past. But
> the key here is the opt-in, to avoid needing IRQ/locking for the cache
> which defeats the purpose. That's why it was done just for polling,
> obviously.
> 
> I'll test a bit and re-spin the series.

The series above now has the opt-in as I realized the same after a
little testing.
