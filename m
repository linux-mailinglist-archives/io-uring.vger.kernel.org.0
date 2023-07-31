Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D3C768FEC
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjGaIU1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 04:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGaIT6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 04:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765B912D;
        Mon, 31 Jul 2023 01:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1250860E8B;
        Mon, 31 Jul 2023 08:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED45C433C7;
        Mon, 31 Jul 2023 08:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690791510;
        bh=lnC5goDD6aT9BlzMCLQnlGp48PIa5mH4/KFThYKynpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XGY2BqsofrntwNaeVyBV+WA+AI7apkGdFMVFoHkqSpSq6+B+kz63ktcERK43/y6py
         M3NTmsKidjDlrS6eQXaY1d3iYbuSCADYYoapXwFjpZaaTZitXR5NM/2sC+z7v5e2FJ
         nUjXRi70PCMBMKYYocQhNky8ixoCOXUNZBbhQmoQZluZwag55P0rmtei0iBFYOVOuq
         lwL2ETQdzTBkFX3yUgifLzBd60ow2F9nLvquWn4MTZiBHINrL9A2jIGTqAZJWi+3lL
         3QJy1pMRVN4REEjHW/NUuzTK16ENSJh+ryxolw52gxlckvJPM6EwuEfOadsiT3CN6N
         m9vNtUpEta7Xg==
Date:   Mon, 31 Jul 2023 10:18:24 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     djwong@kernel.org, Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <20230731-jawohl-schafsfell-0a890454b2af@brauner>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <7adaea37-f84f-9415-41fa-53d36833f8f2@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7adaea37-f84f-9415-41fa-53d36833f8f2@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 31, 2023 at 02:02:25AM +0800, Hao Xu wrote:
> Hi Christian,
> 
> On 7/27/23 22:27, Christian Brauner wrote:
> > On Thu, Jul 27, 2023 at 07:51:19PM +0800, Hao Xu wrote:
> > > On 7/26/23 23:00, Christian Brauner wrote:
> > > > On Tue, Jul 18, 2023 at 09:21:10PM +0800, Hao Xu wrote:
> > > > > From: Hao Xu <howeyxu@tencent.com>
> > > > > 
> > > > > This add support for getdents64 to io_uring, acting exactly like the
> > > > > syscall: the directory is iterated from it's current's position as
> > > > > stored in the file struct, and the file's position is updated exactly as
> > > > > if getdents64 had been called.
> > > > > 
> > > > > For filesystems that support NOWAIT in iterate_shared(), try to use it
> > > > > first; if a user already knows the filesystem they use do not support
> > > > > nowait they can force async through IOSQE_ASYNC in the sqe flags,
> > > > > avoiding the need to bounce back through a useless EAGAIN return.
> > > > > 
> > > > > Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
> > > > > Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> > > > > Signed-off-by: Hao Xu <howeyxu@tencent.com>
> > > > > ---
> > > > >    include/uapi/linux/io_uring.h |  7 +++++
> > > > >    io_uring/fs.c                 | 55 +++++++++++++++++++++++++++++++++++
> > > > >    io_uring/fs.h                 |  3 ++
> > > > >    io_uring/opdef.c              |  8 +++++
> > > > >    4 files changed, 73 insertions(+)
> > > > > 
> > > > > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > > > > index 36f9c73082de..b200b2600622 100644
> > > > > --- a/include/uapi/linux/io_uring.h
> > > > > +++ b/include/uapi/linux/io_uring.h
> > > > > @@ -65,6 +65,7 @@ struct io_uring_sqe {
> > > > >    		__u32		xattr_flags;
> > > > >    		__u32		msg_ring_flags;
> > > > >    		__u32		uring_cmd_flags;
> > > > > +		__u32		getdents_flags;
> > > > >    	};
> > > > >    	__u64	user_data;	/* data to be passed back at completion time */
> > > > >    	/* pack this to avoid bogus arm OABI complaints */
> > > > > @@ -235,6 +236,7 @@ enum io_uring_op {
> > > > >    	IORING_OP_URING_CMD,
> > > > >    	IORING_OP_SEND_ZC,
> > > > >    	IORING_OP_SENDMSG_ZC,
> > > > > +	IORING_OP_GETDENTS,
> > > > >    	/* this goes last, obviously */
> > > > >    	IORING_OP_LAST,
> > > > > @@ -273,6 +275,11 @@ enum io_uring_op {
> > > > >     */
> > > > >    #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
> > > > > +/*
> > > > > + * sqe->getdents_flags
> > > > > + */
> > > > > +#define IORING_GETDENTS_REWIND	(1U << 0)
> > > > > +
> > > > >    /*
> > > > >     * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
> > > > >     * command flags for POLL_ADD are stored in sqe->len.
> > > > > diff --git a/io_uring/fs.c b/io_uring/fs.c
> > > > > index f6a69a549fd4..480f25677fed 100644
> > > > > --- a/io_uring/fs.c
> > > > > +++ b/io_uring/fs.c
> > > > > @@ -47,6 +47,13 @@ struct io_link {
> > > > >    	int				flags;
> > > > >    };
> > > > > +struct io_getdents {
> > > > > +	struct file			*file;
> > > > > +	struct linux_dirent64 __user	*dirent;
> > > > > +	unsigned int			count;
> > > > > +	int				flags;
> > > > > +};
> > > > > +
> > > > >    int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > > > >    {
> > > > >    	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
> > > > > @@ -291,3 +298,51 @@ void io_link_cleanup(struct io_kiocb *req)
> > > > >    	putname(sl->oldpath);
> > > > >    	putname(sl->newpath);
> > > > >    }
> > > > > +
> > > > > +int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > > > > +{
> > > > > +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> > > > > +
> > > > > +	if (READ_ONCE(sqe->off) != 0)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	gd->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
> > > > > +	gd->count = READ_ONCE(sqe->len);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> > > > > +{
> > > > > +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> > > > > +	struct file *file = req->file;
> > > > > +	unsigned long getdents_flags = 0;
> > > > > +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> > > > 
> > > > Hm, I'm not sure what exactly the rules are for IO_URING_F_NONBLOCK.
> > > > But to point this out:
> > > > 
> > > > vfs_getdents()
> > > > -> iterate_dir()
> > > >      {
> > > >           if (shared)
> > > >                   res = down_read_killable(&inode->i_rwsem);
> > > >           else
> > > >                   res = down_write_killable(&inode->i_rwsem);
> > > >      }
> > > > 
> > > > which means you can still end up sleeping here before you go into a
> > > > filesystem that does actually support non-waiting getdents. So if you
> > > > have concurrent operations that grab inode lock (touch, mkdir etc) you
> > > > can end up sleeping here.
> > > > 
> > > > Is that intentional or an oversight? If the former can someone please
> > > > explain the rules and why it's fine in this case?
> > > 
> > > I actually saw this semaphore, and there is another xfs lock in
> > > file_accessed
> > >    --> touch_atime
> > >      --> inode_update_time
> > >        --> inode->i_op->update_time == xfs_vn_update_time
> > > 
> > > Forgot to point them out in the cover-letter..., I didn't modify them
> > > since I'm not very sure about if we should do so, and I saw Stefan's
> > > patchset didn't modify them too.
> > > 
> > > My personnal thinking is we should apply trylock logic for this
> > > inode->i_rwsem. For xfs lock in touch_atime, we should do that since it
> > > doesn't make sense to rollback all the stuff while we are almost at the
> > > end of getdents because of a lock.
> > 
> > That manoeuvres around the problem. Which I'm slightly more sensitive
> > too as this review is a rather expensive one.
> > 
> > Plus, it seems fixable in at least two ways:
> > 
> > For both we need to be able to tell the filesystem that a nowait atime
> > update is requested. Simple thing seems to me to add a S_NOWAIT flag to
> > file_time_flags and passing that via i_op->update_time() which already
> > has a flag argument. That would likely also help kiocb_modified().
> > 
> > file_accessed()
> > -> touch_atime()
> >     -> inode_update_time()
> >        -> i_op->update_time == xfs_vn_update_time()
> > 
> > Then we have two options afaict:
> > 
> > (1) best-effort atime update
> > 
> > file_accessed() already has the builtin assumption that updating atime
> > might fail for other reasons - see the comment in there. So it is
> > somewhat best-effort already.
> > 
> > (2) move atime update before calling into filesystem
> > 
> > If we want to be sure that access time is updated when a readdir request
> > is issued through io_uring then we need to have file_accessed() give a
> > return value and expose a new helper for io_uring or modify
> > vfs_getdents() to do something like:
> > 
> > vfs_getdents()
> > {
> > 	if (nowait)
> > 		down_read_trylock()
> > 
> > 	if (!IS_DEADDIR(inode)) {
> > 		ret = file_accessed(file);
> > 		if (ret == -EAGAIN)
> > 			goto out_unlock;
> > 
> > 		f_op->iterate_shared()
> > 	}
> > }
> > 
> > It's not unprecedented to do update atime before the actual operation
> > has been done afaict. That's already the case in xfs_file_write_checks()
> > which is called before anything is written. So that seems ok.
> 
> I'm not familiar with this part(the time update), I guess we should
> revert the updated time if we succeed to do file_accessed(file) but
> fail somewhere later in f_op->iterate_shared()? Or is it definitely
> counted as an "access" as long as we start to call getdents to a file?

To answer that you can simply take a look at readdir rn

res = -ENOENT;
if (!IS_DEADDIR(inode)) {
        ctx->pos = file->f_pos;
        if (shared)
                res = file->f_op->iterate_shared(file, ctx);
        else
                res = file->f_op->iterate(file, ctx);
        file->f_pos = ctx->pos;
        fsnotify_access(file);
        file_accessed(file);
}

Also, I've said this before: touch_atime() is currently best effort. It
may fail for any kind of reason.
