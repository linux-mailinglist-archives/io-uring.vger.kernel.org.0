Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D12F70F80D
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 15:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbjEXNwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 09:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjEXNwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 09:52:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E2DA7;
        Wed, 24 May 2023 06:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0DC663385;
        Wed, 24 May 2023 13:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AF8C433EF;
        Wed, 24 May 2023 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684936371;
        bh=Q6Piz/VYzHrVX6KEUi2cQWK5oS2GYT39oeGN9zrZYuM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=BS93/9GdjzUFLYqJKTBKB4Q60Y2QqSwxN1LkQ1zb6RmTO5OxcdpEI1jB3ameL1bg4
         pxHKM+BXeo3i0vmD0gDS2DvsE9khq063ATGHxT5Z3AwpF34cgJHDKRMehLr0eyrFX0
         6tbvjr04UIQOLrz6aqihuaaE/d3xjX8CN3Uisq9PZBc1Q5aXeBmvHvN5XgQKSGcYYL
         l2AUoiPuroDgKx3+fjbWWvBxIn/baYdmg3dP71TqHuKnLHO6qi2SgCBW8NQuB3hi/e
         HB6tgNlH+wZbF5XGf9Z8c0OAmmrjXs9n03sOlPuslapaTN/2q62Ox1vPCsnpZWMjeZ
         C9TygU/Psx9EQ==
Date:   Wed, 24 May 2023 15:52:45 +0200
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
Message-ID: <20230524-monolog-punkband-4ed95d8ea852@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZG0slV2BhSZkRL_y@codewreck.org>
 <ZG0qgniV1DzIbbzi@codewreck.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 24, 2023 at 06:13:57AM +0900, Dominique Martinet wrote:
> Christian Brauner wrote on Tue, May 23, 2023 at 05:39:08PM +0200:
> > > @@ -362,11 +369,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
> > >  	};
> > >  	int error;
> > >  
> > > -	f = fdget_pos(fd);
> > > -	if (!f.file)
> > > -		return -EBADF;
> > > -
> > > -	error = iterate_dir(f.file, &buf.ctx);
> > > +	error = iterate_dir(file, &buf.ctx);
> > 
> > So afaict this isn't enough.
> > If you look into iterate_shared() you should see that it uses and
> > updates f_pos. But that can't work for io_uring and also isn't how
> > io_uring handles read and write. You probably need to use a local pos
> > similar to what io_uring does in rw.c for rw->kiocb.ki_pos. But in
> > contrast simply disallow any offsets for getdents completely. Thus not
> > relying on f_pos anywhere at all.
> 
> Using a private offset from the sqe was the previous implementation
> discussed around here[1], and Al Viro pointed out that the iterate
> filesystem implementations don't validate the offset makes sense as it's
> either costly or for some filesystems downright impossible, so I went
> into a don't let users modify it approach.
> 
> [1] https://lore.kernel.org/all/20211221164004.119663-1-shr@fb.com/T/#m517583f23502f32b040c819d930359313b3db00c
> 
> 
> I agree it's not how io_uring usually works -- it dislikes global
> states -- but it works perfectly well as long as you don't have multiple
> users on the same file, which the application can take care of.
> 
> Not having any offsets would work for small directories but make reading
> large directories impossible so some sort of continuation is required,
> which means we need to keep the offset around; I also suggested keeping
> the offset in argument as the previous version but only allowing the
> last known offset (... so ultimately still updating f_pos anyway as we
> don't have anywhere else to store it) or 0, but if we're going to do
> that it looks much simpler to me to expose the same API as getdents.
> 
> -- 
> Dominique Martinet | Asmadeus

On Wed, May 24, 2023 at 06:05:06AM +0900, Dominique Martinet wrote:
> Christian Brauner wrote on Tue, May 23, 2023 at 04:30:14PM +0200:
> > > index b15ec81c1ed2..f6222b0148ef 100644
> > > --- a/io_uring/fs.c
> > > +++ b/io_uring/fs.c
> > > @@ -322,6 +322,7 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> > >  {
> > >  	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> > >  	unsigned long getdents_flags = 0;
> > > +	u32 cqe_flags = 0;
> > >  	int ret;
> > >  
> > >  	if (issue_flags & IO_URING_F_NONBLOCK) {
> > > @@ -338,13 +339,16 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> > >  			goto out;
> > >  	}
> > >  
> > > -	ret = vfs_getdents(req->file, gd->dirent, gd->count, getdents_flags);
> > > +	ret = vfs_getdents(req->file, gd->dirent, gd->count, &getdents_flags);
> > 
> > I don't understand how synchronization and updating of f_pos works here.
> > For example, what happens if a concurrent seek happens on the fd while
> > io_uring is using vfs_getdents which calls into iterate_dir() and
> > updates f_pos?
> 
> I don't see how different that is from a user spawning two threads and
> calling getdents64 + lseek or two getdents64 in parallel?
> (or any two other users of iterate_dir)
> 
> As far as I understand you'll either get the old or new pos as
> obtained/updated by iterate_dir()?
> 
> That iterate_dir probably ought to be using READ_ONCE/WRITE_ONCE or some
> atomic read/update wrappers as the shared case only has a read lock
> around these, but that's not a new problem; and for all I care
> about I'm happy to let users shoot themselves in the foot.
> (although I guess that with filesystems not validating the offset as
> was pointed out in a previous version comment having non-atomic update
> might be a security issue at some point on architectures that don't
> guarantee atomic 64bit updates, but if someone manages to abuse it
> it's already possible to abuse it with the good old syscalls, so I'd
> rather leave that up to someone who understand how atomicity in the
> kernel works better than me...)

There's multiple issues here.

The main objection in [1] was to allow specifying an arbitrary offset
from userspace. What [3] did was to implement a pread() variant for
directories, i.e., pgetdents(). That can't work in principle/is
prohibitively complex. Which is what your series avoids by not allowing
any offsets to be specified.

However, there's still a problem here. Updates to f_pos happen under an
approriate lock to guarantee consistency of the position between calls
that move the cursor position. In the normal read-write path io_uring
doesn't concern itself with f_pos as it keeps local state in
kiocb->ki_pos.

But then it still does end up running into f_pos consistency problems
for read-write because it does allow operating on the current f_pos if
the offset if struct io_rw is set to -1.

In that case it does retrieve and update f_pos which should take
f_pos_lock and a patchset for this was posted but it didn't go anywhere.
It should probably hold that lock. See Jann's comments in the other
thread how that currently can lead to issues.

For getdents() not protecting f_pos is equally bad or worse. The patch
doesn't hold f_pos_lock and just updates f_pos prior _and_ post
iterate_dir() arguing that this race is fine. But again, f_version and
f_pos are consistent after each system call invocation.

But without that you can have a concurrent seek running and can end up
with an inconsistent f_pos position within the same system call. IOW,
you're breaking f_pos being in a well-known state. And you're not doing
that just for io_uring you're doing it for the regular system call
interface as well as both can be used on the same fd simultaneously.
So that's a no go imho.

> I don't see how different that is from a user spawning two threads and
> calling getdents64 + lseek or two getdents64 in parallel?
> (or any two other users of iterate_dir)

The difference is that in both cases f_pos_lock for both getdents and
lseek is held. So f_pos is in a good known state. You're not taking any
locks so now we're risking inconsistency within the same system call if
getdents and lseek run concurrently. Jens also mentioned that you could
even have this problem from within io_uring itself.

So tl;dr, there's no good reason to declare this an acceptable race
afaict. So either this is fixed properly or we're not doing it as far as
I'm concerned.

[1] https://lore.kernel.org/all/20211221164004.119663-1-shr@fb.com/T/#m517583f23502f32b040c819d930359313b3db00c
[2] https://lore.kernel.org/io-uring/20211221164004.119663-4-shr@fb.com
[3] https://lore.kernel.org/io-uring/20211221164004.119663-1-shr@fb.com
