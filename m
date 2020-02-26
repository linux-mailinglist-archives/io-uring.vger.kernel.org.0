Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5D1170359
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 16:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgBZP53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 10:57:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53260 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgBZP53 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 10:57:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q6+/Qd2Y2JYGSuVZkpzMJBymUWB4oioDyaoc9EA54Mk=; b=LXgY2HyV62m0jZoriJzn9lW1Vo
        1rcWuVS6DQyaDEyT8m1/KLrbKN+DKjK6bih5KPHbY+pNX3P1JcdIk4UcTZkyZmHVyWUuLbZzGvJkw
        EmGuKm0Ss0qYMWC8JrCq8ttlOMOgmg80NINVJNFRzkotRIvbQ9Ejby2QJN1aO2aWGleI6pnBHVoxn
        kdNVPOhsUpmkoTyzhKEVYzWscEIxwqWbThBQwtgQHrTbxlcm17f/TLO+tZaLPA/fQxBf5CF9DnTBy
        nFySCmtHbzeRTJcRe/SOiQM7g0vULK3XTyVDzhGtDDSTkPAojrMopVqqRCLezZ27CY/s3yUWrQKSS
        3Urlv3IQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6z3w-00007H-7d; Wed, 26 Feb 2020 15:57:28 +0000
Date:   Wed, 26 Feb 2020 07:57:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/4] io_uring: add IORING_OP_READ{WRITE}V_PI cmd
Message-ID: <20200226155728.GA32543@infradead.org>
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-2-bob.liu@oracle.com>
 <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 26, 2020 at 07:24:06AM -0700, Jens Axboe wrote:
> On 2/26/20 1:37 AM, Bob Liu wrote:
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index a3300e1..98fa3f1 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -62,6 +62,8 @@ enum {
> >  	IORING_OP_NOP,
> >  	IORING_OP_READV,
> >  	IORING_OP_WRITEV,
> > +	IORING_OP_READV_PI,
> > +	IORING_OP_WRITEV_PI,
> >  	IORING_OP_FSYNC,
> >  	IORING_OP_READ_FIXED,
> >  	IORING_OP_WRITE_FIXED,
> 
> So this one renumbers everything past IORING_OP_WRITEV, breaking the
> ABI in a very bad way. I'm guessing that was entirely unintentional?
> Any new command must go at the end of the list.
> 
> You're also not updating io_op_defs[] with the two new commands,
> which means it won't compile at all. I'm guessing you tested this on
> an older version of the kernel which didn't have io_op_defs[]?

And the real question is why we need ops insted of just a flag and
using previously reserved fields for the PI pointer.
