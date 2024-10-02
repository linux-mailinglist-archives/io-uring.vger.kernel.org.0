Return-Path: <io-uring+bounces-3387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9EF98E4C4
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 23:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B5B11C21EAC
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 21:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CCAF19412A;
	Wed,  2 Oct 2024 21:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ECaauAHU"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD21D0420;
	Wed,  2 Oct 2024 21:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727903984; cv=none; b=OdUqo/5IjeF3a9rHYnAp6Mf4sLA3vCbqu8mKJMqI4zHBf8OCHfH6+AGDs8ciNeiXS83FREE3qKBr1g0//iJNtqkK7JpYspe8VroT6y/6nluPp3M2ziyEOi7IHCpalJvI3DwXyLWoMHuTL0OPrU2d39+fpavI3+c9TW8bqBzB38s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727903984; c=relaxed/simple;
	bh=HwQX9RB5Y+tKMzZF3BAxhdguhMntgPo9XEbYXFDW57E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhXMEmTMGF0hdRkCxJn9E68dc+l5AYzL11llJtj1Qp3zhLym2GGgfZUUCW0rWyufiKy6rm49o80sQ64vxTLQRBj/3Z6bSmVLEeFNPIkaeIN6urJTrHqSl4YDbP/7SFdtxfO3NRIYb/gKv9JKUPRFdGSI6nznH0GM9hYDS1zQJMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ECaauAHU; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Og0U2eIfSDg6LaiBViZHnO3uFmlD6Gy3HhCDBLsiw5g=; b=ECaauAHUww3SmIZUdAJJ6h5lLp
	eGSjl0vu5axEVnaFw1n+T8tw6G3R9pRiuien9Ajxqw59p3AePt3pHBancRpp8pneFOEKPE1z20KGT
	VVZVZcqjjsBQajwSPIGPhy4b1/6h59Hc6PU3EFjgYoyMRymvUFAWxiqv8gwKtp1P1UaWOyHUhC2Xu
	yY3fbGs0vbbFpKS/Mi2h0hO4hSbqHuC/dqXD7lrBxbuxxaMRw02tTeYo7KXTL3d+6bdAD6mPjRzpB
	PkO20Nu7u4l7pafuofNzIZjR3gbE/ZEYCQPNwm9Q9fHLY7DJrqPW0DHGxp3ItnQk6UjMpvM0OnE59
	hPFlwrhA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sw6l1-00000000JxI-2yUF;
	Wed, 02 Oct 2024 21:19:39 +0000
Date: Wed, 2 Oct 2024 22:19:39 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	io-uring@vger.kernel.org, cgzones@googlemail.com
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
Message-ID: <20241002211939.GE4017910@ZenIV>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
 <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Oct 02, 2024 at 12:00:45PM -0600, Jens Axboe wrote:
> On 10/1/24 8:08 PM, Al Viro wrote:
> > On Tue, Oct 01, 2024 at 07:34:12PM -0600, Jens Axboe wrote:
> > 
> >>> -retry:
> >>> -	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
> >>> -	if (!ret) {
> >>> -		ret = __io_setxattr(req, issue_flags, &path);
> >>> -		path_put(&path);
> >>> -		if (retry_estale(ret, lookup_flags)) {
> >>> -			lookup_flags |= LOOKUP_REVAL;
> >>> -			goto retry;
> >>> -		}
> >>> -	}
> >>> -
> >>> +	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
> >>>  	io_xattr_finish(req, ret);
> >>>  	return IOU_OK;
> >>
> >> this looks like it needs an ix->filename = NULL, as
> >> filename_{s,g}xattr() drops the reference. The previous internal helper
> >> did not, and hence the cleanup always did it. But should work fine if
> >> ->filename is just zeroed.
> >>
> >> Otherwise looks good. I've skimmed the other patches and didn't see
> >> anything odd, I'll take a closer look tomorrow.
> > 
> > Hmm...  I wonder if we would be better off with file{,name}_setxattr()
> > doing kvfree(cxt->kvalue) - it makes things easier both on the syscall
> > and on io_uring side.
> > 
> > I've added minimal fixes (zeroing ix->filename after filename_[sg]etxattr())
> > to 5/9 and 6/9 *and* added a followup calling conventions change at the end
> > of the branch.  See #work.xattr2 in the same tree; FWIW, the followup
> > cleanup is below; note that putname(ERR_PTR(-Ewhatever)) is an explicit
> > no-op, so there's no need to zero on getname() failures.
> 
> Looks good to me, thanks Al!

I'm still not sure if the calling conventions change is right - in the current
form the last commit in there leaks ctx.kvalue in -EBADF case.  It's easy to
fix up, but... as far as I'm concerned, a large part of the point of the
exercise is to come up with the right model for the calling conventions
for that family of APIs.

I really want to get rid of that ad-hoc crap.  If we are to have what amounts
to the alternative syscall interface, we'd better get it right.  I'm perfectly
fine with having a set of "this is what the syscall is doing past marshalling
arguments" primitives, but let's make sure they are properly documented and
do not have landmines for callers to step into...

Questions on the io_uring side:
	* you usually reject REQ_F_FIXED_FILE for ...at() at ->prep() time.
Fine, but... what's the point of doing that in IORING_OP_FGETXATTR case?
Or IORING_OP_GETXATTR, for that matter, since you pass AT_FDCWD anyway...
Am I missing something subtle here?
	* what's to guarantee that pointers fetched by io_file_get_fixed()
called from io_assing_file() will stay valid?  You do not bump the struct
file refcount in this case, after all; what's to prevent unregistration
from the main thread while the worker is getting through your request?
Is that what the break on node->refs in the loop in io_rsrc_node_ref_zero()
is about?  Or am I barking at the wrong tree here?  I realize that I'm about
the last person to complain about the lack of documentation, but...

	FWIW, my impression is that you have a list of nodes corresponding
to overall resource states (which includes the file reference table) and
have each borrow bump the use count on the node corresponding to the current
state (at the tail of the list?)
	Each removal adds new node to the tail of the list, sticks the
file reference there and tries to trigger io_rsrc_node_ref_zero() (which,
for some reason, takes node instead of the node->ctx, even though it
doesn't give a rat's arse about anything else in its argument).
	If there are nodes at the head of the list with zero use count,
that takes them out, stopping at the first in-use node.  File reference
stashed in a node is dropped when it's taken out.

	If the above is more or less correct (and I'm pretty sure that it
misses quite a few critical points), the rules would be equivalent to
	+ there is a use count associated with the table state.
	+ before we borrow a file reference from the table, we must bump
that use count (see the call of __io_req_set_rsrc_node() in
io_file_get_fixed()) and arrange for dropping it once we are done with
the reference (io_put_rsrc_node() when freeing request, in io_free_batch_list())
	+ any removals from the table will switch to new state; dropping
the removed reference is guaranteed to be delayed until use counts on
all earlier states drop to zero.

	How far are those rules from being accurate and how incomplete
they are?  I hadn't looked into the quiescence-related stuff, which might
or might not be relevant...

