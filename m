Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E75E464E9E
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 14:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349525AbhLANRs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 08:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242786AbhLANRn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 08:17:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D3AC06174A;
        Wed,  1 Dec 2021 05:14:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A298B81EB3;
        Wed,  1 Dec 2021 13:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC23CC53FAD;
        Wed,  1 Dec 2021 13:14:17 +0000 (UTC)
Date:   Wed, 1 Dec 2021 14:14:14 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Clay Harris <bugs@claycon.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <20211201131414.neoskbfqs56e4vt2@wittgenstein>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
 <20211201074621.qzebnsb7f3t27dvo@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211201074621.qzebnsb7f3t27dvo@ps29521.dreamhostps.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 01, 2021 at 01:46:21AM -0600, Clay Harris wrote:
> On Tue, Nov 30 2021 at 22:07:47 -0800, Stefan Roesch quoth thus:
> 
> > 
> > 
> > On 11/29/21 5:08 PM, Clay Harris wrote:
> > > On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
> > > 
> > >> This adds the xattr support to io_uring. The intent is to have a more
> > >> complete support for file operations in io_uring.
> > >>
> > >> This change adds support for the following functions to io_uring:
> > >> - fgetxattr
> > >> - fsetxattr
> > >> - getxattr
> > >> - setxattr
> > > 
> > > You may wish to consider the following.
> > > 
> > > Patching for these functions makes for an excellent opportunity
> > > to provide a better interface.  Rather than implement fXetattr
> > > at all, you could enable io_uring to use functions like:
> > > 
> > > int Xetxattr(int dfd, const char *path, const char *name,
> > > 	[const] void *value, size_t size, int flags);
> > > 
> > > Not only does this simplify the io_uring interface down to two
> > > functions, but modernizes and fixes a deficit in usability.
> > > In terms of io_uring, this is just changing internal interfaces.
> > > 
> > > Although unnecessary for io_uring, it would be nice to at least
> > > consider what parts of this code could be leveraged for future
> > > Xetxattr2 syscalls.
> > 
> 
> I may have become a little over-excited when I saw someone was thinking
> about new code associated with these interfaces.  It's just that, to be
> very kind, the existing interfaces have so much room for improvement.
> I'm aware that changes in this area can be a non-trivial amount of
> work, due to specific xattr keys being handled by different security
> module hooks.
> 
> > Clay, 
> > 
> > while we can reduce the number of calls to 2, providing 4 calls will
> > ease the adoption of the interface. 
> 
> Well, there's removexattr(), but who's counting?
> I believe people use the other *at() interfaces without ever looking
> back at the old calls and that there is little point in io_uring reproducing
> all of the old baggage.
> 
> > If you look at the userspace interface in liburing, you can see the
> > following function signature:
> > 
> > static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
> > 		                           int         fd,
> > 					   const char *name,
> > 					   const char *value,
> > 					   size_t      len)
> > 
> > This is very similar to what you proposed.
> 
> Even though these functions desperately need updating, and as super nice

This code could use some serious cleanup as it is super hard to follow
right now imho. It often gives the impression of forming loops when
following callchains down into the filesystem. None of this is by
design of course. I just happened to grow that way, I guess.
However, for maintenance this is quite painful. I also don't like that
the relationship between xattr and acls and the .set_acl inode methods
is rather opaque in the code. I have a vague plan to cleanup some of
that since I had to mess with this code not too long ago.
But that'll be a bigger chunk of work.

Christian
