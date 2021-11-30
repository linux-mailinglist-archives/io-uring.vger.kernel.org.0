Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8046329B
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 12:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhK3LoN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 06:44:13 -0500
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:18181 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234242AbhK3LoM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 06:44:12 -0500
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 5C49F8C15BA;
        Tue, 30 Nov 2021 11:40:51 +0000 (UTC)
Received: from pdx1-sub0-mail-a280.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id B93118C184B;
        Tue, 30 Nov 2021 11:40:50 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a280.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.105.57.78 (trex/6.4.3);
        Tue, 30 Nov 2021 11:40:51 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Stop-Minister: 2cca0285655215e2_1638272451062_3850990790
X-MC-Loop-Signature: 1638272451062:4154972842
X-MC-Ingress-Time: 1638272451062
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a280.dreamhost.com (Postfix) with ESMTPSA id 4J3KzQ3NRQz1Pr;
        Tue, 30 Nov 2021 03:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=claycon.org;
        s=claycon.org; t=1638272450; bh=O2WXhrHkH1XggUiIONMYJjGc2ao=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=bgxD8Czk8LHxyvV+YB0zE4rRTRGKMWDQH6U8UKEdrGm4Ersv4jtF7hnLC88K3A3Aj
         df7R3HRkdhm9OaT9hNo4/+lrdVEOEJeL0jUo/ll5QoV+00Sn6FKmv0tcYI7xo3kGoo
         KY82SYZEfMGo9fuqUP3dzjb7WK7PTo4Q0VyznAO4=
Date:   Tue, 30 Nov 2021 05:40:48 -0600
From:   Clay Harris <bugs@claycon.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <20211130114048.bzimtybhqj6ztq2u@ps29521.dreamhostps.com>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
 <20211130063703.hszzs3tg5qb37fyj@ps29521.dreamhostps.com>
 <20211130065345.actf2vrfpvtk6fcz@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130065345.actf2vrfpvtk6fcz@ps29521.dreamhostps.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 30 2021 at 00:53:45 -0600, Clay Harris quoth thus:

> On Tue, Nov 30 2021 at 00:37:03 -0600, Clay Harris quoth thus:
> 
> > On Mon, Nov 29 2021 at 20:16:02 -0700, Andreas Dilger quoth thus:
> > 
> > > 
> > > > On Nov 29, 2021, at 6:08 PM, Clay Harris <bugs@claycon.org> wrote:
> > > > 
> > > > On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
> > > > 
> > > >> This adds the xattr support to io_uring. The intent is to have a more
> > > >> complete support for file operations in io_uring.
> > > >> 
> > > >> This change adds support for the following functions to io_uring:
> > > >> - fgetxattr
> > > >> - fsetxattr
> > > >> - getxattr
> > > >> - setxattr
> > > > 
> > > > You may wish to consider the following.
> > > > 
> > > > Patching for these functions makes for an excellent opportunity
> > > > to provide a better interface.  Rather than implement fXetattr
> > > > at all, you could enable io_uring to use functions like:
> > > > 
> > > > int Xetxattr(int dfd, const char *path, const char *name,
> > > > 	[const] void *value, size_t size, int flags);
> > > 
> > > This would naturally be named "...xattrat()"?
> > 
> > Indeed!
> > 
> > > > Not only does this simplify the io_uring interface down to two
> > > > functions, but modernizes and fixes a deficit in usability.
> > > > In terms of io_uring, this is just changing internal interfaces.

One more reason, it would be very desirable if io_uring called a
*etxattrat-like interface, is that the old f*etxattr calls require an fd
open for reading (fget*) or writing (fset*).  So, you're out of luck if
you have an execute-only file or just an O_PATH descriptor!  In those
cases, you're forced to use a pathname for every call.  Not very efficient
for people who choose to use the highly optimized io_uring interface.

> > > Even better would be the ability to get/set an array of xattrs in
> > > one call, to avoid repeated path lookups in the common case of
> > > handling multiple xattrs on a single file.
> > 
> > True.
> > 
> > > > Although unnecessary for io_uring, it would be nice to at least
> > > > consider what parts of this code could be leveraged for future
> > > > Xetxattr2 syscalls.
> > s/Xetxattr2/Xetxattrat/
> 
> I forgot to mention a final thought about the interface.
> Unless there is a really good reason (security auditing??), there
> is no reason to have a removexattr() function.  That seems much
> better handled by passing NULL for value and specifying a remove
> flag in flags to setxattrat().
> 
> > > > 
> > > >> Patch 1: fs: make user_path_at_empty() take a struct filename
> > > >>  The user_path_at_empty filename parameter has been changed
> > > >>  from a const char user pointer to a filename struct. io_uring
> > > >>  operates on filenames.
> > > >>  In addition also the functions that call user_path_at_empty
> > > >>  in namei.c and stat.c have been modified for this change.
> > > >> 
> > > >> Patch 2: fs: split off setxattr_setup function from setxattr
> > > >>  Split off the setup part of the setxattr function
> > > >> 
> > > >> Patch 3: fs: split off the vfs_getxattr from getxattr
> > > >>  Split of the vfs_getxattr part from getxattr. This will
> > > >>  allow to invoke it from io_uring.
> > > >> 
> > > >> Patch 4: io_uring: add fsetxattr and setxattr support
> > > >>  This adds new functions to support the fsetxattr and setxattr
> > > >>  functions.
> > > >> 
> > > >> Patch 5: io_uring: add fgetxattr and getxattr support
> > > >>  This adds new functions to support the fgetxattr and getxattr
> > > >>  functions.
> > > >> 
> > > >> 
> > > >> There are two additional patches:
> > > >>  liburing: Add support for xattr api's.
> > > >>            This also includes the tests for the new code.
> > > >>  xfstests: Add support for io_uring xattr support.
> > > >> 
> > > >> 
> > > >> Stefan Roesch (5):
> > > >>  fs: make user_path_at_empty() take a struct filename
> > > >>  fs: split off setxattr_setup function from setxattr
> > > >>  fs: split off the vfs_getxattr from getxattr
> > > >>  io_uring: add fsetxattr and setxattr support
> > > >>  io_uring: add fgetxattr and getxattr support
> > > >> 
> > > >> fs/internal.h                 |  23 +++
> > > >> fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
> > > >> fs/namei.c                    |   5 +-
> > > >> fs/stat.c                     |   7 +-
> > > >> fs/xattr.c                    | 114 +++++++-----
> > > >> include/linux/namei.h         |   4 +-
> > > >> include/uapi/linux/io_uring.h |   8 +-
> > > >> 7 files changed, 439 insertions(+), 47 deletions(-)
> > > >> 
> > > >> 
> > > >> Signed-off-by: Stefan Roesch <shr@fb.com>
> > > >> base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
> > > >> --
> > > >> 2.30.2
> > > 
> > > 
> > > Cheers, Andreas
> > > 
> > > 
> > > 
> > > 
> > > 
> > 
