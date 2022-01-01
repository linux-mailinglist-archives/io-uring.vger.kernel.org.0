Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BAF482861
	for <lists+io-uring@lfdr.de>; Sat,  1 Jan 2022 20:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiAAT7g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Jan 2022 14:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbiAAT7f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Jan 2022 14:59:35 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507A1C061574;
        Sat,  1 Jan 2022 11:59:35 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n3kXJ-00GUHD-NP; Sat, 01 Jan 2022 19:59:29 +0000
Date:   Sat, 1 Jan 2022 19:59:29 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
Message-ID: <YdCyoQNPNcaM9rqD@zeniv-ca.linux.org.uk>
References: <20211221164004.119663-1-shr@fb.com>
 <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
 <Yc+PK4kRo5ViXu0O@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc+PK4kRo5ViXu0O@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 31, 2021 at 11:15:55PM +0000, Al Viro wrote:
> On Tue, Dec 21, 2021 at 09:15:24AM -0800, Linus Torvalds wrote:
> > On Tue, Dec 21, 2021 at 8:40 AM Stefan Roesch <shr@fb.com> wrote:
> > >
> > > This series adds support for getdents64 in liburing. The intent is to
> > > provide a more complete I/O interface for io_uring.
> > 
> > Ack, this series looks much more natural to me now.
> > 
> > I think some of the callers of "iterate_dir()" could probably be
> > cleaned up with the added argument, but for this series I prefer that
> > mindless approach of just doing "&(arg1)->f_pos" as the third argument
> > that is clearly a no-op.
> > 
> > So the end result is perhaps not as beautiful as it could be, but I
> > think the patch series DTRT.
> 
> It really does not.  Think what happens if you pass e.g. an odd position
> to that on e.g. ext2/3/4.  Or just use it on tmpfs, for that matter.

[A bit of a braindump follows; my apologies for reminding of some
unpleasant parts of history]

The real problem here is the userland ABI along the lines of pread for
directories.  There's a good reason why we (as well as everybody else,
AFAIK) do not have pgetdents(2).

Handling of IO positions for directories had been causing trouble
ever since the directory layouts had grown support for long names.
Originally a directory had been an array of fixed-sized entries; back
then ls(1) simply used read(2).  No special logics for handling offsets,
other than "each entry is 16 bytes, so you want to read a multiple of
16 starting from offset that is a multiple of 16".

As soon as FFS had introduced support for names longer than 14 characters,
the things got more complicated - there's no predicting if given position
is an entry boundary.  Worse, what used to have been an entry boundary
might very well come to point to the middle of a name - all it takes is
unlink()+creat() done since the time the position used to be OK.

Details are filesystem-dependent; e.g. for original FFS all multiples of
512 are valid offsets, and each entry has its length stored in bytes 4
and 5, so one needs to read the relevant 512 bytes of contents and walk
the list of entries until they get to (or past) the position that needs
to be validated.  For ext2 it's a bit more unpleasant, since the chunk
size is not 512 bytes - it's a block size, i.e. might easily by 4Kb.
For more complex layouts it gets even nastier.

Having to do that kind of validation on each directory entry access would
be too costly.  That's somewhat mitigated since the old readdir(2) is no
longer used, and we return multiple entries per syscall (getdents(2)).
With the exclusion between directory reads and modifications, that allows
to limit validation to the first entry returned on that syscall.

It's still too costly, though.  The next part of mitigation is to use
the fact that valid position will remain valid until somebody modifies a
directory, so we don't need to validate if directory hadn't been changed
since the last time getdents(2) had gotten to this position.  Of course,
explicit change of position since that last getdents(2) means that we
can't skip validation.

Another fun part is synthetic filesystems like tmpfs - there we don't
have any persistent directory contents we could use as source of offsets.
All we have is a cyclic list of dentries; memory address of dentry is
obviously not a candidate - trying to validate _that_ would be beyond
unpleasant.  So we use the position in the list.  To avoid the O(directory
size) cost of walking the list to the position we are asked to read from,
we insert a cursor into the list and have directory reads and seeks move
it as needed.  File position is not authoritative there - the cursor is.
They can get out of sync - if you read almost to the end of directory,
unlink the first file, use lseek(fd, SEEK_CUR, 0) to find position, then
lseek to 0 and back to the position reported, you'll end up one entry
further than you would without those lseeks.  Userland is generally OK
with that (and we are within the POSIX warranties).  However, if that
kind of "out of sync" can happen without any directory modifications
involved, we have trouble.

Directories are not well-suited for random access.  Not since mid-80s.
It's possible, but not cheap and there's a lot of non-obvious corner cases
where directory modifications are involved.  Some of those must work,
or the userland will break.  Telling which ones those are is not trivial.

pgetdents(2) would be a bad idea by itself; making it asynchronous is
the stuff of nightmares.  Please, reconsider that ABI - AFAICS, there's
no way to do it cheaply and it will take modifying each ->iterate_dir()
just to avoid breaking the existing uses of those.
