Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1D73E8F99
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 13:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbhHKLlp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 07:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237352AbhHKLlp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 07:41:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA50C061765;
        Wed, 11 Aug 2021 04:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S0w9DeHcgeLS6gkKxBuVWVk67tNwTLQ4qu3FJRwKDHk=; b=m9AYpk3HB7wv0eJ6YA+qxPQR5E
        7S3oUpP3Bp4hY6s/kmNS5WRWm/aOZQHLKgkDJ99FqecQqNEimqrd9V3FYxYx/N2c2NxBhdhouX1nd
        vvZHbpsyxjjrZumnTLD/RqZWP+MhtfxFzgl5R2V/OabXmMFhpu72cKwVJWBTmP5C2ImvMiEonGBS/
        h9rNbycH8EhNYhPP+dIUDQqlub1/BHqwsOZj4WqcMWtCR/dzH11qKGMCra9oI43C2eCbN3aX8F4oC
        FVvCqX0SrJmlvt0XcgtW1xA7YtjQWOfWe138fAvLPqBsEeqoPP9fbU3DS0ulezoXdDV9gUFhENZLl
        LaAA+IAA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDmbA-00DJyd-6J; Wed, 11 Aug 2021 11:40:52 +0000
Date:   Wed, 11 Aug 2021 12:40:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/5] io_uring: use kiocb->private to hold rw_len
Message-ID: <YRO3OMRA6L2qx298@infradead.org>
References: <20210810163728.265939-1-axboe@kernel.dk>
 <20210810163728.265939-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810163728.265939-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 10, 2021 at 10:37:25AM -0600, Jens Axboe wrote:
> We don't need a separate member in io_rw for this, we can just use the
> kiocb->private field as we're not using it for anything else anyway.
> This saves 8 bytes in io_rw, which we'll be needing once kiocb grows
> a new member.

->private is owned by the file_operations instance, not the caller.  So
this can't work.

