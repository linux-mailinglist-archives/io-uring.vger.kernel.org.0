Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98754647A1
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 08:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347097AbhLAHOb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 02:14:31 -0500
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:46791 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232517AbhLAHOa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 02:14:30 -0500
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 45C8F6605CA;
        Wed,  1 Dec 2021 07:11:08 +0000 (UTC)
Received: from pdx1-sub0-mail-a239.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 97C75661685;
        Wed,  1 Dec 2021 07:11:07 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a239.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.127.242.146 (trex/6.4.3);
        Wed, 01 Dec 2021 07:11:08 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Desert-Slimy: 609438f53f158204_1638342668059_1381473076
X-MC-Loop-Signature: 1638342668059:3203880526
X-MC-Ingress-Time: 1638342668059
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a239.dreamhost.com (Postfix) with ESMTPSA id 4J3qxl22pLz3Z;
        Tue, 30 Nov 2021 23:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=claycon.org;
        s=claycon.org; t=1638342667; bh=3zIaAWlZUmi5p5cVvgaB8EJfYbA=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=fsEvYc1TO7vKX7M1QLqS9tFDRIseZC1iIkunmDhv0n10mF8ARMCMSE1cD3Mo+u6dY
         3sOSwK76pyru1jLl7gqPPDckViFdRcdlQpBIg0fMgpeCekBA22HJok7D9Up45LeqP8
         ro/gf1PrtNB0hQcD8W0xMksHROT2f3THtIG0N4P4=
Date:   Wed, 1 Dec 2021 01:11:01 -0600
From:   Clay Harris <bugs@claycon.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] io_uring: add getdents64 support
Message-ID: <20211201071101.6aus4oxhocztt7t6@ps29521.dreamhostps.com>
References: <20211124231700.1158521-1-shr@fb.com>
 <20211125044246.ve2433klyjua3a6d@ps29521.dreamhostps.com>
 <58fbf170-a1ae-a841-f41f-17c2d6df5503@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fbf170-a1ae-a841-f41f-17c2d6df5503@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 30 2021 at 22:01:30 -0800, Stefan Roesch quoth thus:

> 
> 
> On 11/24/21 8:42 PM, Clay Harris wrote:
> > 
> > I seem to recall making a few comments the last time a getdents64
> > for io_uring was proposed; in particular I wanted to bring up one
> > here.  This applies only to altering the internal interface, which
> > io_uring would use, although wiring up a new syscall would be a nice
> > addition.
> > 
> > The current interface has 2 issues:
> > 
> > 1)
> > getdents64 requires at least two calls to read a directory.
> > One or more to get the dents and a final call to see the EOF.
> > With small directories, this means literally 50% of the calls
> > are wasted.
> > 
> > 2)
> > The fpos cannot be changed atomically with a read, so it is not
> > possible to to safely perform concurrent reads on the same fd.
> > 
> > But, the kernel knows (most, if not all of the time) that it is at
> > EOF at the time it returns the last buffer.  So, it would be very
> > useful to get an EOF indicator back with the final buffer.  This
> > could just a flag, or for instance make an fpos parameter which is
> > both input and output, returning the (post read) fpos or zero at
> > EOF.
> > 
> > Futhermore, for input, one could supply:
> > 	0:	Start from directory beginning
> > 	-1:	Read from current position
> > 	other:	(output from previous call) Read from here
> > 

Thank you for taking the time to respond!

> While I can understand the wish to optimize the getdents call, this
> has its own set of challenges:
> 
> - The getdents API is following the logic of other read API's. None
>   of these API's has the logic you described above. This would be
>   inconsistent.

The point was that the familiar interface can be improved by changing its API.

Consider as if you were implementing a new syscall:
ssize_t getdents2(int fd, void *buf, size_t count, off_t *offset, int flags);

This is close enough to pread() that no one would be slowed down by its
unfamiliarity.  It would work just like getdents64(), except that the fpos
at the end of the read would always be returned in offset.  At EOF, fpos 0
would be returned.  On the calling side, one would set a flag and set offset
to a value other than -1 to cause it to atomically change fpos before the read.

Just considering an io_uring (only) call, io_uring is already a new interface,
so the inconsistency point doesn't really seem to apply.

> - The eof needs to be stored in another field. The dirent structure
>   does not have space in the field, so a new data structure needs to be defined.

I believe the important part of the idea is the EOF processing, so I'll drop
the fpos discussion for now.  In this case you could use exactly the old
getdents64() API for io_uring with the minor addition of a returned flag bit.
My understanding, which I'll admit could be flawed, is that the directory
iterator should be testable for the EOF condition.  If correct, I'd think
that testing it and setting a bit in the cqe flags field is all you'd need.
So, as long as the internal call has access to the iterator, no new structures
are required.

> - However the goal is to provide a familiar interface to the user.
> - If the user wants to reduce the number of calls he can still provide
>   a bigger user buffer.

In io_uring, if there is no EOF flag as suggested above, the best you
could probably due is to queue two requests, IOSQE_IO_HARDLINK-ed together,
every time you want some directory entries, and then look for a zero length
return.  That's extra logic, the extra wasted call, and already doubling the
required buffering.

> 
> > On Wed, Nov 24 2021 at 15:16:57 -0800, Stefan Roesch quoth thus:
> > 
> >> This series adds support for getdents64 in liburing. The intent is to
> >> provide a more complete I/O interface for io_uring.
> >>
> >> Patch 1: fs: add parameter use_fpos to iterate_dir()
> >>   This adds a new parameter to the function iterate_dir() so the
> >>   caller can specify if the position is the file position or the
> >>   position stored in the buffer context.
> >>
> >> Patch 2: fs: split off vfs_getdents function from getdents64 system call
> >>   This splits of the iterate_dir part of the syscall in its own
> >>   dedicated function. This allows to call the function directly from
> >>   liburing.
> >>
> >> Patch 3: io_uring: add support for getdents64
> >>   Adds the functions to io_uring to support getdents64.
> >>
> >> There is also a patch series for the changes to liburing. This includes
> >> a new test. The patch series is called "liburing: add getdents support."
> >>
> >> The following tests have been performed:
> >> - new liburing getdents test program has been run
> >> - xfstests have been run
> >> - both tests have been repeated with the kernel memory leak checker
> >>   and no leaks have been reported.
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> ---
> >> V2: Updated the iterate_dir calls in fs/ksmbd, fs/ecryptfs and arch/alpha with
> >>     the additional parameter.
> >>
> >> Stefan Roesch (3):
> >>   fs: add parameter use_fpos to iterate_dir function
> >>   fs: split off vfs_getdents function of getdents64 syscall
> >>   io_uring: add support for getdents64
> >>
> >>  arch/alpha/kernel/osf_sys.c   |  2 +-
> >>  fs/ecryptfs/file.c            |  2 +-
> >>  fs/exportfs/expfs.c           |  2 +-
> >>  fs/internal.h                 |  8 +++++
> >>  fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++
> >>  fs/ksmbd/smb2pdu.c            |  2 +-
> >>  fs/ksmbd/vfs.c                |  4 +--
> >>  fs/nfsd/nfs4recover.c         |  2 +-
> >>  fs/nfsd/vfs.c                 |  2 +-
> >>  fs/overlayfs/readdir.c        |  6 ++--
> >>  fs/readdir.c                  | 64 ++++++++++++++++++++++++++---------
> >>  include/linux/fs.h            |  2 +-
> >>  include/uapi/linux/io_uring.h |  1 +
> >>  13 files changed, 121 insertions(+), 28 deletions(-)
> >>
> >>
> >> base-commit: f0afafc21027c39544a2c1d889b0cff75b346932
> >> -- 
> >> 2.30.2
