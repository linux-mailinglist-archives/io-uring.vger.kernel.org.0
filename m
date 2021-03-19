Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DB9341E2D
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 14:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhCSN3h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 09:29:37 -0400
Received: from verein.lst.de ([213.95.11.211]:46210 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhCSN3O (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 19 Mar 2021 09:29:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3427268C4E; Fri, 19 Mar 2021 14:29:11 +0100 (CET)
Date:   Fri, 19 Mar 2021 14:29:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 1/8] io_uring: split up io_uring_sqe into hdr + main
Message-ID: <20210319132910.GA4249@lst.de>
References: <20210317221027.366780-1-axboe@kernel.dk> <20210317221027.366780-2-axboe@kernel.dk> <20210318053454.GA28063@lst.de> <04ffff78-4a34-0848-4131-8b3cfd9a24f7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ffff78-4a34-0848-4131-8b3cfd9a24f7@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 18, 2021 at 12:40:25PM -0600, Jens Axboe wrote:
> > and use that for all new commands going forward while marking the
> > old ones as legacy.
> > 
> > io_uring_cmd_sqe would then be:
> > 
> > struct io_uring_cmd_sqe {
> >         struct io_uring_sqe_hdr	hdr;
> > 	__u33			ioc;
> > 	__u32 			len;
> > 	__u8			data[40];
> > };
> > 
> > for example.  Note the 32-bit opcode just like ioctl to avoid
> > getting into too much trouble due to collisions.
> 
> I was debating that with myself too, it's essentially making
> the existing io_uring_sqe into io_uring_sqe_v1 and then making a new
> v2 one. That would impact _all_ commands, and we'd need some trickery
> to have newly compiled stuff use v2 and have existing applications
> continue to work with the v1 format. That's very different from having
> a single (or new) opcodes use a v2 format, effectively.

I only proposed it for all new commands because we have so many
existing ones.

> Looking into the feasibility of this. But if that is done, there are
> other things that need to be factored in, as I'm not at all interested
> in having a v3 down the line as well. And I'd need to be able to do this
> seamlessly, both from an application point of view, and a performance
> point of view (no stupid conversions inline).
> 
> Things that come up when something like this is on the table
> 
> - Should flags be extended? We're almost out... It hasn't been an
>   issue so far, but seems a bit silly to go v2 and not at least leave
>   a bit of room there. But obviously comes at a cost of losing eg 8
>   bits somewhere else.
> 
> - Is u8 enough for the opcode? Again, we're nowhere near the limits
>   here, but eventually multiplexing might be necessary.
> 
> That's just off the top of my head, probably other things to consider
> too.

At some point there isn't much left of the common space if we
extend all that, but yeah.

