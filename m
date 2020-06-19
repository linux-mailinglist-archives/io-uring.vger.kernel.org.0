Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D81200310
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 09:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgFSH41 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 03:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730875AbgFSH41 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 03:56:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B48C06174E;
        Fri, 19 Jun 2020 00:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+6lPoVcKNlDZ05zKLgAxZCl2a/rH2CM1rj4HgNIEc9s=; b=lblZEhu1fj4HGfeB9rhLnm35e9
        3s57GAEQfeYx9h5CBtLLPeAfKEWKCz18DZbbPCosACUyBaHUXmzsIVHYCRGJVPG9fd8muPAzgwPu1
        V/71pp368G0BLs+SJP1MgF8kDjX9G90M/thlJtpGLGS6/TUykwIDqd0wDpgWHY4LmSnrbOJwFkW1u
        bmIqEbVSMPVmLVAbNEJ5TT97yQsdSJgNJgeiBPRVLvomB3zVX+sRq5JZ18lk3/mWl7wLGKMGBZxPo
        lC7rsgOSIPzShQNsWEImEJA6EBemQePknjzZd+JcfY94JHq401SFPp4B4rNlvgjY1ed3aLR1jCiWB
        Xru8sLrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmBsq-000095-Sv; Fri, 19 Jun 2020 07:56:20 +0000
Date:   Fri, 19 Jun 2020 00:56:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Message-ID: <20200619075620.GA20581@infradead.org>
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
 <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <20200618065634.GB24943@infradead.org>
 <20200618175258.GA4141152@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618175258.GA4141152@test-zns>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 18, 2020 at 11:22:58PM +0530, Kanchan Joshi wrote:
> I was thinking of raw block-access to zone device rather than pristine file
> abstraction.

Why?

> And in that context, semantics, at this point, are unchanged
> (i.e. same as direct writes) while flexibility of async-interface gets
> added.
> Synchronous-writes on single-zone sound fine, but synchronous-appends on
> single-zone do not sound that fine.

Where does synchronous access come into play?

> > What could be a useful addition is a way for O_APPEND/RWF_APPEND writes
> > to report where they actually wrote, as that comes close to Zone Append
> > while still making sense at our usual abstraction level for file I/O.
> 
> Thanks for suggesting this. O and RWF_APPEND may not go well with block
> access as end-of-file will be picked from dev inode.

No, but they go really well with zonefs.

> But perhaps a new
> flag like RWF_ZONE_APPEND can help to transform writes (aio or uring)
> into append without introducing new opcodes.

I don't think this is a good idea.  Zones are a concept for a a very
specific class of zoned devices.  Trying to shoe-horn this into the
byte address files / whole device abstraction not only is ugly
conceptually but also adds the overhead for it to the VFS.

And O_APPEND that returns the written position OTOH makes total sense
at the file level as well and not just for raw zoned devices.
