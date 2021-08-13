Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4142A3EBD6A
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 22:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhHMUcI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 16:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234059AbhHMUcI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 13 Aug 2021 16:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A0060560;
        Fri, 13 Aug 2021 20:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628886700;
        bh=BUbSjlv5kAyggU4+gTGFHocSDae9xsROsNjawPGZ8xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UwHArndTasdDjL9J9Id1MCDiNSLOJ0cmY7zH3R2V+KqKFhcuPjUPkMSF14DEhx4iw
         GeZTl5+FFjeORNv7XVGVtRXECIiOgffQXbyLn9EolmWmGSnW8xmGReNCYAstrXZLou
         Rn2afCd5wtQJhmO1onL4tpld2pGgiqC3PrywOl0MXDfnSpVbDS8b4wIoEjAA5icoi6
         EkjTbZQIxbxXfWJLHJulfREnZmVRvPOS3Aj1AqfsRfzFejOStWgBEVBrxovY2krxKC
         +WqUHd3EP8SzrwXGD+N2Ti01PnJl9MJ5i33HHbzo4hoDWbMF/zBvhRAkHtiuNrgq5n
         CuEnjtHU00ioA==
Date:   Fri, 13 Aug 2021 13:31:38 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 4/6] block: clear BIO_PERCPU_CACHE flag if polling isn't
 supported
Message-ID: <20210813203138.GA2761@dhcp-10-100-145-180.wdc.com>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-5-axboe@kernel.dk>
 <20210812173143.GA3138953@dhcp-10-100-145-180.wdc.com>
 <b60e0031-77b0-fe27-2b52-437ba21babcb@kernel.dk>
 <20210813201722.GB2661@dhcp-10-100-145-180.wdc.com>
 <33d05811-a9c6-c1d3-8b9c-7b95bdadd457@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33d05811-a9c6-c1d3-8b9c-7b95bdadd457@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 13, 2021 at 02:19:11PM -0600, Jens Axboe wrote:
> On 8/13/21 2:17 PM, Keith Busch wrote:
> > On Thu, Aug 12, 2021 at 11:41:58AM -0600, Jens Axboe wrote:
> >> Indeed. Wonder if we should make that a small helper, as any clear of
> >> REQ_HIPRI should clear BIO_PERCPU_CACHE as well.
> >>
> >>
> >> diff --git a/block/blk-core.c b/block/blk-core.c
> >> index 7e852242f4cc..d2722ecd4d9b 100644
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -821,11 +821,8 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
> >>  		}
> >>  	}
> >>  
> >> -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) {
> >> -		/* can't support alloc cache if we turn off polling */
> >> -		bio_clear_flag(bio, BIO_PERCPU_CACHE);
> >> -		bio->bi_opf &= ~REQ_HIPRI;
> >> -	}
> >> +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> >> +		bio_clear_hipri(bio);
> > 
> > Since BIO_PERCPU_CACHE doesn't work without REQ_HIRPI, should this check
> > look more like this?
> > 
> > 	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> > 		bio->bi_opf &= ~REQ_HIPRI;
> > 	if (!(bio->bi_opf & REQ_HIPRI))
> > 		bio_clear_flag(bio, BIO_PERCPU_CACHE);
> > 
> > I realise the only BIO_PERCPU_CACHE user in this series never sets it
> > without REQ_HIPRI, but it looks like a problem waiting to happen if
> > nothing enforces this pairing: someone could set the CACHE flag on a
> > QUEUE_FLAG_POLL enabled queue without setting HIPRI and get the wrong
> > bio_put() action.
> 
> I'd rather turn that into a WARN_ON or similar. But probably better to
> do that on the freeing side, honestly. That'll be the most reliable way,
> but a shame to add cycles to the hot path...

Yeah, it is a coding error if that happened, so a WARN sounds okay. I
also don't like adding these kinds of checks, so please feel free to not
include it if you think the usage is clear enough.
