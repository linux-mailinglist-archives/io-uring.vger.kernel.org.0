Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63707464913
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 08:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhLAHtr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 02:49:47 -0500
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:11667 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230144AbhLAHtq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 02:49:46 -0500
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8D7206209D9;
        Wed,  1 Dec 2021 07:46:23 +0000 (UTC)
Received: from pdx1-sub0-mail-a239.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id C2A11620894;
        Wed,  1 Dec 2021 07:46:22 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a239.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.109.250.6 (trex/6.4.3);
        Wed, 01 Dec 2021 07:46:23 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Harbor-Suffer: 4982dbea23ba7336_1638344783231_287088708
X-MC-Loop-Signature: 1638344783231:4208909484
X-MC-Ingress-Time: 1638344783231
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a239.dreamhost.com (Postfix) with ESMTPSA id 4J3rkQ4FV6z1Jd;
        Tue, 30 Nov 2021 23:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=claycon.org;
        s=claycon.org; t=1638344782; bh=jzLWxBpLhm1LQux+SiiHrLGTxuA=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=QayqVyXxG8djF+aeyhs2Yph1g1K0GVFDrpWMJ8z5CfLGaQOT6A5mrM8nmc0rfT67p
         ROy976nGJ5mS3nTJGRrzzyPsZUNRTusYoWvtgwk3AOnK1nLPXZ9COw49AtV/Ry27xP
         +Qs9rLFNVDaFbjjSU5cwSmCu9hZWn3qi8ol6uyLQ=
Date:   Wed, 1 Dec 2021 01:46:21 -0600
From:   Clay Harris <bugs@claycon.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <20211201074621.qzebnsb7f3t27dvo@ps29521.dreamhostps.com>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 30 2021 at 22:07:47 -0800, Stefan Roesch quoth thus:

> 
> 
> On 11/29/21 5:08 PM, Clay Harris wrote:
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
> > 
> > Not only does this simplify the io_uring interface down to two
> > functions, but modernizes and fixes a deficit in usability.
> > In terms of io_uring, this is just changing internal interfaces.
> > 
> > Although unnecessary for io_uring, it would be nice to at least
> > consider what parts of this code could be leveraged for future
> > Xetxattr2 syscalls.
> 

I may have become a little over-excited when I saw someone was thinking
about new code associated with these interfaces.  It's just that, to be
very kind, the existing interfaces have so much room for improvement.
I'm aware that changes in this area can be a non-trivial amount of
work, due to specific xattr keys being handled by different security
module hooks.

> Clay, 
> 
> while we can reduce the number of calls to 2, providing 4 calls will
> ease the adoption of the interface. 

Well, there's removexattr(), but who's counting?
I believe people use the other *at() interfaces without ever looking
back at the old calls and that there is little point in io_uring reproducing
all of the old baggage.

> If you look at the userspace interface in liburing, you can see the
> following function signature:
> 
> static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
> 		                           int         fd,
> 					   const char *name,
> 					   const char *value,
> 					   size_t      len)
> 
> This is very similar to what you proposed.

Even though these functions desperately need updating, and as super nice
as it would be, I don't expect you to implement getxattrat() and setxattrat().
If I were to name a single thing that would most increase the usability of
these functions, it would be:
	Make the fXetxattr() functions (at least the io_uring versions)
	work with an O_PATH descriptor.
That one thing would at least provide most of the desired functionality at
the cost of an extra openat() call.

> 
> > 
> >> Patch 1: fs: make user_path_at_empty() take a struct filename
> >>   The user_path_at_empty filename parameter has been changed
> >>   from a const char user pointer to a filename struct. io_uring
> >>   operates on filenames.
> >>   In addition also the functions that call user_path_at_empty
> >>   in namei.c and stat.c have been modified for this change.
> >>
> >> Patch 2: fs: split off setxattr_setup function from setxattr
> >>   Split off the setup part of the setxattr function
> >>
> >> Patch 3: fs: split off the vfs_getxattr from getxattr
> >>   Split of the vfs_getxattr part from getxattr. This will
> >>   allow to invoke it from io_uring.
> >>
> >> Patch 4: io_uring: add fsetxattr and setxattr support
> >>   This adds new functions to support the fsetxattr and setxattr
> >>   functions.
> >>
> >> Patch 5: io_uring: add fgetxattr and getxattr support
> >>   This adds new functions to support the fgetxattr and getxattr
> >>   functions.
> >>
> >>
> >> There are two additional patches:
> >>   liburing: Add support for xattr api's.
> >>             This also includes the tests for the new code.
> >>   xfstests: Add support for io_uring xattr support.
> >>
> >>
> >> Stefan Roesch (5):
> >>   fs: make user_path_at_empty() take a struct filename
> >>   fs: split off setxattr_setup function from setxattr
> >>   fs: split off the vfs_getxattr from getxattr
> >>   io_uring: add fsetxattr and setxattr support
> >>   io_uring: add fgetxattr and getxattr support
> >>
> >>  fs/internal.h                 |  23 +++
> >>  fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
> >>  fs/namei.c                    |   5 +-
> >>  fs/stat.c                     |   7 +-
> >>  fs/xattr.c                    | 114 +++++++-----
> >>  include/linux/namei.h         |   4 +-
> >>  include/uapi/linux/io_uring.h |   8 +-
> >>  7 files changed, 439 insertions(+), 47 deletions(-)
> >>
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
> >> -- 
> >> 2.30.2
