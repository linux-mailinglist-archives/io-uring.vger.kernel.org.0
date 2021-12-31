Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3444B48261F
	for <lists+io-uring@lfdr.de>; Sat,  1 Jan 2022 00:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhLaX13 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Dec 2021 18:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhLaX12 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Dec 2021 18:27:28 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77913C061574;
        Fri, 31 Dec 2021 15:27:28 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n3RIy-00GKEa-QQ; Fri, 31 Dec 2021 23:27:24 +0000
Date:   Fri, 31 Dec 2021 23:27:24 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] io_uring: add getdents64 support
Message-ID: <Yc+R3AacE3GHjedQ@zeniv-ca.linux.org.uk>
References: <20211124231700.1158521-1-shr@fb.com>
 <49b476cb-0de6-22ff-61b7-87ac300b9567@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49b476cb-0de6-22ff-61b7-87ac300b9567@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 15, 2021 at 02:09:52PM -0700, Jens Axboe wrote:
> On 11/24/21 4:16 PM, Stefan Roesch wrote:
> > This series adds support for getdents64 in liburing. The intent is to
> > provide a more complete I/O interface for io_uring.
> > 
> > Patch 1: fs: add parameter use_fpos to iterate_dir()
> >   This adds a new parameter to the function iterate_dir() so the
> >   caller can specify if the position is the file position or the
> >   position stored in the buffer context.
> > 
> > Patch 2: fs: split off vfs_getdents function from getdents64 system call
> >   This splits of the iterate_dir part of the syscall in its own
> >   dedicated function. This allows to call the function directly from
> >   liburing.
> > 
> > Patch 3: io_uring: add support for getdents64
> >   Adds the functions to io_uring to support getdents64.
> > 
> > There is also a patch series for the changes to liburing. This includes
> > a new test. The patch series is called "liburing: add getdents support."
> 
> Al, ping on this one as well, same question on the VFS side.

First of all, apologies for being MIA - had been sick for a couple of
months, so right now I'm digging through the huge pile of mail.

The problem is not with VFS side - it's with ->iterate_dir() *instances*.
The logics for validation of file position in there is not pretty, and
it's based upon the assumption that all position changes (other than
those from ->iterate_dir() itself) come through lseek(2), with its
per-opened-file exclusion with getdents(2).

Your API just shoves an arbitrary number at them, with no indication
as far as struct file instance is concerned that something might need
to be checked.  Hell, the file might've been just opened with no
directory-changing operations done since then; of course its position
is valid.  And has nothing whatsoever with the number you put into
ctx->pos.

Normalization is sufficiently costly to show up on real-world loads.
Even "assume it bogus" flag somewhere in ctx will seriously cost on
io_uring side.  And that doesn't help with the case of tmpfs et.al.
where position is ignored - there's a per-instance cursor moved
around on lseek/readdir and that's the authoritative thing there.

So please, use a saner userland ABI - pread-like stuff is a really,
really bad idea for directories.
