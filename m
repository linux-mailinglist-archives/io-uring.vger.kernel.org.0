Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF4E7108B8
	for <lists+io-uring@lfdr.de>; Thu, 25 May 2023 11:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbjEYJWR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 May 2023 05:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjEYJWQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 May 2023 05:22:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF6A19C;
        Thu, 25 May 2023 02:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA4E64423;
        Thu, 25 May 2023 09:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DED4C433EF;
        Thu, 25 May 2023 09:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685006534;
        bh=0hZSGcHyqzdzaOuM6U5q0Dp8CKovA8zm9JgGyYfNPhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OjQxmGaHbV7EunIkCt3xbaGcUstmiCj813xkEHYDcM1QaFab5e6g4/onM4N6rcMPN
         x86+wwj5mYrxcsaQ3oar5R2jPEzIa7211iBmaIwNcTzQZpGpagdXoHDEcvp3wcNtD/
         cWfTWCoIqxIK/l8OYF/QPNIjqful4u5x7tj4Hm8J4SvpRawHnlVwvP41sFhSXyu5jh
         O8s1N6+EuC6YFHcpK/fryL7sUr/TNkhlTlZ/K1OCZxXRoEBofD/yK7LVyXPlpzFQ+r
         sXNKOcO3vbQLV/xah9lrnylrhi6kDAV3U8G/K2ybdqj0Mp8jbIqFYSIRyrrgHA+PR/
         Gx1BXlpo+1mVw==
Date:   Thu, 25 May 2023 11:22:08 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <20230525-funkanstalt-ertasten-a43443d045c8@brauner>
References: <ZG0slV2BhSZkRL_y@codewreck.org>
 <ZG0qgniV1DzIbbzi@codewreck.org>
 <20230524-monolog-punkband-4ed95d8ea852@brauner>
 <ZG6DUfdbTHS-e5P7@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZG6DUfdbTHS-e5P7@codewreck.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 25, 2023 at 06:36:17AM +0900, Dominique Martinet wrote:
> Christian Brauner wrote on Wed, May 24, 2023 at 03:52:45PM +0200:
> > The main objection in [1] was to allow specifying an arbitrary offset
> > from userspace. What [3] did was to implement a pread() variant for
> > directories, i.e., pgetdents(). That can't work in principle/is
> > prohibitively complex. Which is what your series avoids by not allowing
> > any offsets to be specified.
> 
> Yes.
> 
> > However, there's still a problem here. Updates to f_pos happen under an
> > approriate lock to guarantee consistency of the position between calls
> > that move the cursor position. In the normal read-write path io_uring
> > doesn't concern itself with f_pos as it keeps local state in
> > kiocb->ki_pos.
> > 
> > But then it still does end up running into f_pos consistency problems
> > for read-write because it does allow operating on the current f_pos if
> > the offset if struct io_rw is set to -1.
> > 
> > In that case it does retrieve and update f_pos which should take
> > f_pos_lock and a patchset for this was posted but it didn't go anywhere.
> > It should probably hold that lock. See Jann's comments in the other
> > thread how that currently can lead to issues.
> 
> Assuming that is this mail:
> https://lore.kernel.org/io-uring/CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com/
> 
> So, ok, I didn't realize fdget_pos() actually acted as a lock on the
> file's f_pos_lock (apparently only if FMODE_ATMOIC_POS is set? but it
> looks set on most if not all directories through finish_open(), that
> looks called consistently enough)

It's set for any regular file and directory.

> 
> What was confusing is that default_llseek updates f_pos under the
> inode_lock (write), and getdents also takes that lock (for read only in
> shared implem), so I assumed getdents also was just protected by this
> read lock, but I guess that was a bad assumption (as I kept pointing
> out, a shared read lock isn't good enough, we definitely agree there)
> 
> 
> In practice, in the non-registered file case io_uring is also calling
> fdget, so the lock is held exactly the same as the syscall and I wasn't

No, it really isn't. fdget() doesn't take f_pos_lock at all:

fdget()
-> __fdget()
   -> __fget_light()
      -> __fget()
         -> __fget_files()
            -> __fget_files_rcu()

If that were true then any system call that passes an fd and uses
fdget() would try to acquire a mutex on f_pos_lock. We'd be serializing
every *at based system call on f_pos_lock whenever we have multiple fds
referring to the same file trying to operate on it concurrently.

We do have fdget_pos() and fdput_pos() as a special purpose fdget() for
a select group of system calls that require this synchronization.

> so far off -- but we need to figure something for the registered file
> case.
> openat variants don't allow working with the registered variant at all
> on the parent fd, so as far as I'm concerned I'd be happy setting the
> same limitation for getdents: just say it acts on fd and not files, and
> call it a day...

I don't follow. Also this is hacky so no.

The reason why io_uring *at implementations don't work with fixed files
is that the VFS interface expect regular fds. You could very well make
this work for fixed files but why. It would mean exposing a whole new
set of vfs helpers to io_uring and would probably involve nasty corner
cases.

Also the connection between regular and fixed files in io_uring is
pretty much fluent. While fixed files can only remain pinned in an
io_uring instance it requires that the caller explicitly gave up all
references in their fdtable to that struct file by closing all fds
referring to the same file.

But there's no guarantee. For example, if another thread dups the fd or
the caller sends the fd via SCM_RIGHTS to another process or the caller
simply doesn't close the fd or another thread gets an fd to the same
file from that task via pidfd_getfd before it closed it this doesn't hold.

So it's very well possible to have an fd and a fixed io_uring reference
referring to the same file. The first one can be used with the regular
system call interface and io_uring *at requests that forbid fixed files.
And the other one can be used for i_uring fixed file operations. Doesn't
matter if that shouldn't be done, it's possible afaict.

For regular and fixed files you also have the same problem from within
the same io_uring instance where you can have concurrent getdent
requests. You'd end up producing the exact same inconsistencies.

> It'd also be possible to check if REQ_F_FIXED_FILE flag was set and
> manually take the lock somehow but we don't have any primitive that
> takes f_pos_lock from a file (the only place that takes it is fdget
> which requires a fd), so I'd rather not add such a new exception.
> I assume the other patch you mentioned about adding that lock was this
> one:
> https://lore.kernel.org/all/20220222105504.3331010-1-dylany@fb.com/T/#m3609dc8057d0bc8e41ceab643e4d630f7b91bde6
> and it just atkes the lock, but __fdget_pos also checks for
> FMODE_ATOMIC_OPS and file_count and I'm not sure I understand how it
> sets (f.flags & FDPUT_POS_UNLOCK) (for fdput_pos) so I'd rather not add
> such a code path at this point..
> 
> 
> So, ok, what do you think about just forbidding registered files?
> I can't see where that wouldn't suffice but I might be missing something
> else.

It doesn't help.
