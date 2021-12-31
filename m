Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74527482617
	for <lists+io-uring@lfdr.de>; Sat,  1 Jan 2022 00:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhLaXOH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Dec 2021 18:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhLaXOG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Dec 2021 18:14:06 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF60C061574;
        Fri, 31 Dec 2021 15:14:06 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n3R64-00GK7l-PI; Fri, 31 Dec 2021 23:14:04 +0000
Date:   Fri, 31 Dec 2021 23:14:04 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
Message-ID: <Yc+OvLHveebsQlAT@zeniv-ca.linux.org.uk>
References: <20211221164004.119663-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221164004.119663-1-shr@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 21, 2021 at 08:40:01AM -0800, Stefan Roesch wrote:
> This series adds support for getdents64 in liburing. The intent is to
> provide a more complete I/O interface for io_uring.
> 
> Patch 1: fs: add offset parameter to iterate_dir function.
>   This adds an offset parameter to the iterate_dir()
>   function. The new parameter allows the caller to specify
>   the offset to use.
> 
> Patch 2: fs: split off vfs_getdents function from getdents64 system call
>   This splits of the iterate_dir part of the syscall in its own
>   dedicated function. This allows to call the function directly from
>   io_uring.
> 
> Patch 3: io_uring: add support for getdents64
>   Adds the functions to io_uring to support getdents64.
> 
> There is also a patch series for the changes to liburing. This includes
> a new test. The patch series is called "liburing: add getdents support."
> 
> The following tests have been performed:
> - new liburing getdents test program has been run
> - xfstests have been run
> - both tests have been repeated with the kernel memory leak checker
>   and no leaks have been reported.

AFAICS, it completely breaks the "is the position known to be valid"
logics in a lot of ->iterate_dir() instances.  For a reasonably simple
example see e.g. ext2_readdir():

        bool need_revalidate = !inode_eq_iversion(inode, file->f_version);

.....
                if (unlikely(need_revalidate)) {
                        if (offset) {
                                offset = ext2_validate_entry(kaddr, offset, chunk_mask);
                                ctx->pos = (n<<PAGE_SHIFT) + offset;
                        }
                        file->f_version = inode_query_iversion(inode);
                        need_revalidate = false;
                }
and that, combined with
	* directory modifications bumping iversion
	* lseek explicitly cleaing ->f_version on location changes
and resulting position going back into ->f_pos, *BEFORE* we unlock the damn
file.

makes sure that we call ext2_validate_entry() for any untrusted position.

Your code breaks the living hell out of that.  First of all, the offset is
completely arbitrary and no amount of struct file-based checks is going to
be relevant.  Furthermore, this "we'd normalized the position, the valid
one will go into ->f_pos and do so before the caller does fdput_pos(), so
mark the file as known-good-position" logics also break - ->f_pos is *NOT*
locked and new positition, however valid it might be, is not going to
be put there.

How could that possibly work?  I'm not saying that the current variant is
particularly nice, but the need to avoid revalidation of position on each
getdents(2) call is real, and this revalidation is not cheap.

Furthermore, how would that work on e.g. shmem/tmpfs/ramfs/etc.?
There the validation is not an issue, simply because the position is
not used at all - a per-file cursor is, and it's moved by dcache_dir_lseek()
and dcache_readdir().

Folks, readdir from arbitrary position had been a source of pain since
mid-80s.  A plenty of PITA all around, and now you introduce another
API that shoves things into the same orifices without even a benefit of
going through lseek(2), or any of the exclusion warranties regarding
the file position?
