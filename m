Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B70462DE8
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 08:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhK3Hzr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 02:55:47 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53915 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229639AbhK3Hzq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 02:55:46 -0500
X-Greylist: delayed 1969 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2021 02:55:46 EST
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 2A831868853;
        Tue, 30 Nov 2021 18:19:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mrxQN-00Ex9f-Vi; Tue, 30 Nov 2021 18:19:36 +1100
Date:   Tue, 30 Nov 2021 18:19:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Clay Harris <bugs@claycon.org>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <20211130071935.GB3447530@dread.disaster.area>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a5d089
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=lOFz4raxAAAA:8 a=7-415B0cAAAA:8
        a=RNDbt5ElMwmBT3KWXA8A:9 a=CjuIK1q_8ugA:10 a=8mx_EjHVqIGiWU97iuXK:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 29, 2021 at 08:16:02PM -0700, Andreas Dilger wrote:
> 
> > On Nov 29, 2021, at 6:08 PM, Clay Harris <bugs@claycon.org> wrote:
> > 
> > On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
> > 
> >> This adds the xattr support to io_uring. The intent is to have a more
> >> complete support for file operations in io_uring.
> >> 
> >> This change adds support for the following functions to io_uring:
> >> - fgetxattr
> >> - fsetxattr
> >> - getxattr
> >> - setxattr
> > 
> > You may wish to consider the following.
> > 
> > Patching for these functions makes for an excellent opportunity
> > to provide a better interface.  Rather than implement fXetattr
> > at all, you could enable io_uring to use functions like:
> > 
> > int Xetxattr(int dfd, const char *path, const char *name,
> > 	[const] void *value, size_t size, int flags);
> 
> This would naturally be named "...xattrat()"?
> 
> > Not only does this simplify the io_uring interface down to two
> > functions, but modernizes and fixes a deficit in usability.
> > In terms of io_uring, this is just changing internal interfaces.
> 
> Even better would be the ability to get/set an array of xattrs in
> one call, to avoid repeated path lookups in the common case of
> handling multiple xattrs on a single file.

Been around for since the mid 1990s IIRC. XFS brought them to Linux
from Irix and they are used by xfsdump/restore via libhandle.  API
documented here:

$ man 3 attr_multi

And they are implemented through XFS ioctls.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
