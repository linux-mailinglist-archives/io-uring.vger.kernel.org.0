Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDEE462CDE
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 07:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238631AbhK3Gk3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 01:40:29 -0500
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:38487 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233463AbhK3Gk3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 01:40:29 -0500
X-Greylist: delayed 19707 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2021 01:40:27 EST
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 4ADD0860B0C;
        Tue, 30 Nov 2021 06:37:06 +0000 (UTC)
Received: from pdx1-sub0-mail-a246.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 9FEE786095B;
        Tue, 30 Nov 2021 06:37:05 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a246.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.105.57.78 (trex/6.4.3);
        Tue, 30 Nov 2021 06:37:06 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Wide-Eyed-Average: 4fa65c2e7eda005e_1638254226129_97219434
X-MC-Loop-Signature: 1638254226129:1353081103
X-MC-Ingress-Time: 1638254226129
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a246.dreamhost.com (Postfix) with ESMTPSA id 4J3CDx24PPz2r;
        Mon, 29 Nov 2021 22:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=claycon.org;
        s=claycon.org; t=1638254225; bh=xK/BaFTAtQfL8gbSawi50m+prkU=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=dhYBGQIEIb7qLoK9CxNmpbrlhzUOvXoojFkuzACK03OwckQbBkVwmSJ+9DV1z/66n
         uSiX1Ay7wk/q5XEsYP9j32cRjZRvv67VesgkacvtGBICynYfCUAKhSHN32+lqYxwbA
         VC15Qi6bUAI+iRxO2K7vODyX1Rg1wSc6Od9X8G4I=
Date:   Tue, 30 Nov 2021 00:37:03 -0600
From:   Clay Harris <bugs@claycon.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <20211130063703.hszzs3tg5qb37fyj@ps29521.dreamhostps.com>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 29 2021 at 20:16:02 -0700, Andreas Dilger quoth thus:

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

Indeed!

> > Not only does this simplify the io_uring interface down to two
> > functions, but modernizes and fixes a deficit in usability.
> > In terms of io_uring, this is just changing internal interfaces.
> 
> Even better would be the ability to get/set an array of xattrs in
> one call, to avoid repeated path lookups in the common case of
> handling multiple xattrs on a single file.

True.

> > Although unnecessary for io_uring, it would be nice to at least
> > consider what parts of this code could be leveraged for future
> > Xetxattr2 syscalls.
s/Xetxattr2/Xetxattrat/

> > 
> >> Patch 1: fs: make user_path_at_empty() take a struct filename
> >>  The user_path_at_empty filename parameter has been changed
> >>  from a const char user pointer to a filename struct. io_uring
> >>  operates on filenames.
> >>  In addition also the functions that call user_path_at_empty
> >>  in namei.c and stat.c have been modified for this change.
> >> 
> >> Patch 2: fs: split off setxattr_setup function from setxattr
> >>  Split off the setup part of the setxattr function
> >> 
> >> Patch 3: fs: split off the vfs_getxattr from getxattr
> >>  Split of the vfs_getxattr part from getxattr. This will
> >>  allow to invoke it from io_uring.
> >> 
> >> Patch 4: io_uring: add fsetxattr and setxattr support
> >>  This adds new functions to support the fsetxattr and setxattr
> >>  functions.
> >> 
> >> Patch 5: io_uring: add fgetxattr and getxattr support
> >>  This adds new functions to support the fgetxattr and getxattr
> >>  functions.
> >> 
> >> 
> >> There are two additional patches:
> >>  liburing: Add support for xattr api's.
> >>            This also includes the tests for the new code.
> >>  xfstests: Add support for io_uring xattr support.
> >> 
> >> 
> >> Stefan Roesch (5):
> >>  fs: make user_path_at_empty() take a struct filename
> >>  fs: split off setxattr_setup function from setxattr
> >>  fs: split off the vfs_getxattr from getxattr
> >>  io_uring: add fsetxattr and setxattr support
> >>  io_uring: add fgetxattr and getxattr support
> >> 
> >> fs/internal.h                 |  23 +++
> >> fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
> >> fs/namei.c                    |   5 +-
> >> fs/stat.c                     |   7 +-
> >> fs/xattr.c                    | 114 +++++++-----
> >> include/linux/namei.h         |   4 +-
> >> include/uapi/linux/io_uring.h |   8 +-
> >> 7 files changed, 439 insertions(+), 47 deletions(-)
> >> 
> >> 
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
> >> --
> >> 2.30.2
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


