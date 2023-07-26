Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4C47639C7
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 17:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjGZPBB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 11:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbjGZPA7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 11:00:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F11110F3;
        Wed, 26 Jul 2023 08:00:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CC9E61B0C;
        Wed, 26 Jul 2023 15:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D67C433C8;
        Wed, 26 Jul 2023 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690383657;
        bh=bsc9Ene8u8yk2Jp3wBSvByh1V64lsXruC8bKwMt/tBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCfVpkoI2PZJ3aR922ScxY9h/d0UFhXq906HtPJ7uEd6GIOvDYjJDI4SfDXHEaOVQ
         vkhMFLRLJl8C0fN0zO32aGGoRlO9x2dHb99CmejIle3X6cGAn53NXjzDpqa/fcG8A1
         Ptj2e9bqaOtNPHDNofo6scQW4tVw7ZlwlYUX/fHFHXH00w5AksadlJCu6kZmwMMlBy
         JseWXKGLK9zlAQOLdzsKEGa/+HXgqK0Tr+v8QxMuLrqPKSUnR2Km1pZTXAhD1d4QED
         3br+QdZ7YXzxPF8+S+ujRoOvRdfrC949dsL2PcD/nIJINEFSeCMxD04uDz7+ju8MXS
         rUWqMwfctmlcw==
Date:   Wed, 26 Jul 2023 17:00:51 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <20230726-leinen-basisarbeit-13ae322690ff@brauner>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230718132112.461218-4-hao.xu@linux.dev>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 18, 2023 at 09:21:10PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This add support for getdents64 to io_uring, acting exactly like the
> syscall: the directory is iterated from it's current's position as
> stored in the file struct, and the file's position is updated exactly as
> if getdents64 had been called.
> 
> For filesystems that support NOWAIT in iterate_shared(), try to use it
> first; if a user already knows the filesystem they use do not support
> nowait they can force async through IOSQE_ASYNC in the sqe flags,
> avoiding the need to bounce back through a useless EAGAIN return.
> 
> Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  include/uapi/linux/io_uring.h |  7 +++++
>  io_uring/fs.c                 | 55 +++++++++++++++++++++++++++++++++++
>  io_uring/fs.h                 |  3 ++
>  io_uring/opdef.c              |  8 +++++
>  4 files changed, 73 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 36f9c73082de..b200b2600622 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -65,6 +65,7 @@ struct io_uring_sqe {
>  		__u32		xattr_flags;
>  		__u32		msg_ring_flags;
>  		__u32		uring_cmd_flags;
> +		__u32		getdents_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */
> @@ -235,6 +236,7 @@ enum io_uring_op {
>  	IORING_OP_URING_CMD,
>  	IORING_OP_SEND_ZC,
>  	IORING_OP_SENDMSG_ZC,
> +	IORING_OP_GETDENTS,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> @@ -273,6 +275,11 @@ enum io_uring_op {
>   */
>  #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
>  
> +/*
> + * sqe->getdents_flags
> + */
> +#define IORING_GETDENTS_REWIND	(1U << 0)
> +
>  /*
>   * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
>   * command flags for POLL_ADD are stored in sqe->len.
> diff --git a/io_uring/fs.c b/io_uring/fs.c
> index f6a69a549fd4..480f25677fed 100644
> --- a/io_uring/fs.c
> +++ b/io_uring/fs.c
> @@ -47,6 +47,13 @@ struct io_link {
>  	int				flags;
>  };
>  
> +struct io_getdents {
> +	struct file			*file;
> +	struct linux_dirent64 __user	*dirent;
> +	unsigned int			count;
> +	int				flags;
> +};
> +
>  int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
> @@ -291,3 +298,51 @@ void io_link_cleanup(struct io_kiocb *req)
>  	putname(sl->oldpath);
>  	putname(sl->newpath);
>  }
> +
> +int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> +
> +	if (READ_ONCE(sqe->off) != 0)
> +		return -EINVAL;
> +
> +	gd->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	gd->count = READ_ONCE(sqe->len);
> +
> +	return 0;
> +}
> +
> +int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> +	struct file *file = req->file;
> +	unsigned long getdents_flags = 0;
> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;

Hm, I'm not sure what exactly the rules are for IO_URING_F_NONBLOCK.
But to point this out:

vfs_getdents()
-> iterate_dir()
   {
        if (shared)
                res = down_read_killable(&inode->i_rwsem);
        else
                res = down_write_killable(&inode->i_rwsem);
   }

which means you can still end up sleeping here before you go into a
filesystem that does actually support non-waiting getdents. So if you
have concurrent operations that grab inode lock (touch, mkdir etc) you
can end up sleeping here.

Is that intentional or an oversight? If the former can someone please
explain the rules and why it's fine in this case?

> +	bool should_lock = file->f_mode & FMODE_ATOMIC_POS;
> +	int ret;
> +
> +	if (force_nonblock) {
> +		if (!(req->file->f_mode & FMODE_NOWAIT))
> +			return -EAGAIN;
> +
> +		getdents_flags = DIR_CONTEXT_F_NOWAIT;
> +	}
> +
> +	if (should_lock) {
> +		if (!force_nonblock)
> +			mutex_lock(&file->f_pos_lock);
> +		else if (!mutex_trylock(&file->f_pos_lock))
> +			return -EAGAIN;
> +	}

That now looks like it works.

> +
> +	ret = vfs_getdents(file, gd->dirent, gd->count, getdents_flags);
> +	if (should_lock)
> +		mutex_unlock(&file->f_pos_lock);
