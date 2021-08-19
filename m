Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135A03F15B0
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhHSJC3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 05:02:29 -0400
Received: from verein.lst.de ([213.95.11.211]:36643 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhHSJC2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 19 Aug 2021 05:02:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6EF4C67357; Thu, 19 Aug 2021 11:01:50 +0200 (CEST)
Date:   Thu, 19 Aug 2021 11:01:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RFC] Enable bio cache for IRQ driven IO from io_uring
Message-ID: <20210819090150.GA11498@lst.de>
References: <3bff2a83-cab2-27b6-6e67-bdae04440458@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bff2a83-cab2-27b6-6e67-bdae04440458@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 18, 2021 at 10:54:45AM -0600, Jens Axboe wrote:
> We previously enabled this for O_DIRECT polled IO, however io_uring
> completes all IO from task context these days, so it can be enabled for
> that path too. This requires moving the bio_put() from IRQ context, and
> this can be accomplished by passing the ownership back to the issuer.
> 
> Use kiocb->private for that, which should be (as far as I can tell) free
> once we get to the completion side of things. Add a IOCB_PUT_CACHE flag
> to tell the issuer that we passed back the ownership, then the issuer
> can put the bio from a safe context.
> 
> Like the polled IO ditto, this is good for a 10% performance increase.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> Just hacked this up and tested it, Works For Me. Would welcome input on
> alternative methods here, if anyone has good suggestions.

10% performance improvement looks really nice, but I don't think we can
just hardcode assumptions about bios in iomap->private.  The easiest
would be to call back into the file systems for the freeing, but that
would add an indirect call.
