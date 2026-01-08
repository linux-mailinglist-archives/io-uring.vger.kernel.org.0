Return-Path: <io-uring+bounces-11528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C4805D03F19
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 16:41:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 403A030090F2
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 15:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672821DF751;
	Thu,  8 Jan 2026 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JCYjElFa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="d2ChgALP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JCYjElFa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="d2ChgALP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BE27E07E
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767885883; cv=none; b=kDXS87IekFIkF9CUq+Hhy8U9y5rH5Jsu6xH/piuTHBllJLAaU7B1ZoHZ1i0og/ltRDOaLrAKVPr79248+bLvcn/h7Ow6tumQpsZhMzU4QobcCgzVqKCV9/J2c9rC/qMwE4gRYmgWJll/vP/fVB5RPV9l2FhI4c6y2OIRYx3po5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767885883; c=relaxed/simple;
	bh=vXriC1hOUec5CiDeN7Kkxns/Y4aG+yALvZFE+zmwmLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlIyPD3FEyjKnOS8aXrQqRad5fyd9zmvhL5soxvvoi2CBLy3yP5C0IX4uHjAaL5kLsRWs27UPlcQ28PPOpVHaKVRpbVF2jlnt2oahmQ/y2sbBdntlc9Nqk2dP0x4Egx+zZ65QPE+E0njevpbF9okIHnvt8mKz1I3zRd49paSFrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JCYjElFa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=d2ChgALP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JCYjElFa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=d2ChgALP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A391F5C8BF;
	Thu,  8 Jan 2026 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767885877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V+qK+dnL46nUtN+uNEFs23QanVQbnXiphSQbt6qXpT4=;
	b=JCYjElFavA1D+JD67g7P3npPC+qKEUU/TbXUobTNoT7l1cVaT7b4XmIGbh8npgaG+jLv/V
	6AckBleiCx8a50E72AwF4VkGql2Dsd8QC+IUgJ2KIt0GlENPgQOJtkIyZ+IMt5mWrZpF6P
	/r1aau7+l5M8SCkXKYQEUfSfYOfbnog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767885877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V+qK+dnL46nUtN+uNEFs23QanVQbnXiphSQbt6qXpT4=;
	b=d2ChgALPnQVQKorF2BkYW7JgTwnMO5Lu5PPBlhswk0qAlUgGRqAbHwNO++BK2PotRdsuOn
	EUNmEnGr6rkOyZAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767885877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V+qK+dnL46nUtN+uNEFs23QanVQbnXiphSQbt6qXpT4=;
	b=JCYjElFavA1D+JD67g7P3npPC+qKEUU/TbXUobTNoT7l1cVaT7b4XmIGbh8npgaG+jLv/V
	6AckBleiCx8a50E72AwF4VkGql2Dsd8QC+IUgJ2KIt0GlENPgQOJtkIyZ+IMt5mWrZpF6P
	/r1aau7+l5M8SCkXKYQEUfSfYOfbnog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767885877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V+qK+dnL46nUtN+uNEFs23QanVQbnXiphSQbt6qXpT4=;
	b=d2ChgALPnQVQKorF2BkYW7JgTwnMO5Lu5PPBlhswk0qAlUgGRqAbHwNO++BK2PotRdsuOn
	EUNmEnGr6rkOyZAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 933BE3EA63;
	Thu,  8 Jan 2026 15:24:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R8DvIzXMX2kSewAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 15:24:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4D1D8A09CF; Thu,  8 Jan 2026 16:24:37 +0100 (CET)
Date: Thu, 8 Jan 2026 16:24:37 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, io-uring@vger.kernel.org, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH 07/11] fs: add a ->sync_lazytime method
Message-ID: <w35hgsrv4xxwlq2ncsukzc5s6qwjq3qmnbpvyltj2ljmc357dh@4hcrqlekhxdh>
References: <20260108141934.2052404-1-hch@lst.de>
 <20260108141934.2052404-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108141934.2052404-8-hch@lst.de>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,nvidia.com:email,imap1.dmz-prg2.suse.org:helo,lst.de:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Thu 08-01-26 15:19:07, Christoph Hellwig wrote:
> Allow the file system to explicitly implement lazytime syncing instead
> of pigging back on generic inode dirtying.  This allows to simplify
> the XFS implementation and prepares for non-blocking lazytime timestamp
> updates.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/locking.rst |  2 ++
>  Documentation/filesystems/vfs.rst     |  6 ++++++
>  fs/fs-writeback.c                     | 13 +++++++++++--
>  include/linux/fs.h                    |  1 +
>  4 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 37a4a7fa8094..0312fba6d73b 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -82,6 +82,7 @@ prototypes::
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
>  	void (*update_time)(struct inode *inode, enum fs_update_time type,
>  			    int flags);
> +	void (*sync_lazytime)(struct inode *inode);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  				struct file *, unsigned open_flag,
>  				umode_t create_mode);
> @@ -118,6 +119,7 @@ getattr:	no
>  listxattr:	no
>  fiemap:		no
>  update_time:	no
> +sync_lazytime:	no
>  atomic_open:	shared (exclusive if O_CREAT is set in open flags)
>  tmpfile:	no
>  fileattr_get:	no or exclusive
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 51aa9db64784..d8cb181f69f8 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -487,6 +487,7 @@ As of kernel 2.6.22, the following members are defined:
>  		ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  		void (*update_time)(struct inode *inode, enum fs_update_time type,
>  				    int flags);
> +		void (*sync_lazytime)(struct inode *inode);
>  		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
>  				   unsigned open_flag, umode_t create_mode);
>  		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
> @@ -643,6 +644,11 @@ otherwise noted.
>  	an inode.  If this is not defined the VFS will update the inode
>  	itself and call mark_inode_dirty_sync.
>  
> +``sync_lazytime``:
> +	called by the writeback code to update the lazy time stamps to
> +	regular time stamp updates that get syncing into the on-disk
> +	inode.
> +
>  ``atomic_open``
>  	called on the last component of an open.  Using this optional
>  	method the filesystem can look up, possibly create and open the
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3d68b757136c..62658be2578b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1717,7 +1717,10 @@ bool sync_lazytime(struct inode *inode)
>  		return false;
>  
>  	trace_writeback_lazytime(inode);
> -	mark_inode_dirty_sync(inode);
> +	if (inode->i_op->sync_lazytime)
> +		inode->i_op->sync_lazytime(inode);
> +	else
> +		mark_inode_dirty_sync(inode);
>  	return true;
>  }
>  
> @@ -2569,6 +2572,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  	trace_writeback_mark_inode_dirty(inode, flags);
>  
>  	if (flags & I_DIRTY_INODE) {
> +		bool was_dirty_time = false;
> +
>  		/*
>  		 * Inode timestamp update will piggback on this dirtying.
>  		 * We tell ->dirty_inode callback that timestamps need to
> @@ -2579,6 +2584,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  			if (inode_state_read(inode) & I_DIRTY_TIME) {
>  				inode_state_clear(inode, I_DIRTY_TIME);
>  				flags |= I_DIRTY_TIME;
> +				was_dirty_time = true;
>  			}
>  			spin_unlock(&inode->i_lock);
>  		}
> @@ -2591,9 +2597,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		 * for just I_DIRTY_PAGES or I_DIRTY_TIME.
>  		 */
>  		trace_writeback_dirty_inode_start(inode, flags);
> -		if (sb->s_op->dirty_inode)
> +		if (sb->s_op->dirty_inode) {
>  			sb->s_op->dirty_inode(inode,
>  				flags & (I_DIRTY_INODE | I_DIRTY_TIME));
> +		} else if (was_dirty_time && inode->i_op->sync_lazytime) {
> +			inode->i_op->sync_lazytime(inode);
> +		}
>  		trace_writeback_dirty_inode(inode, flags);
>  
>  		/* I_DIRTY_INODE supersedes I_DIRTY_TIME. */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 35b3e6c6b084..7837db1ba1d2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2024,6 +2024,7 @@ struct inode_operations {
>  		      u64 len);
>  	int (*update_time)(struct inode *inode, enum fs_update_time type,
>  			   unsigned int flags);
> +	void (*sync_lazytime)(struct inode *inode);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  			   struct file *, unsigned open_flag,
>  			   umode_t create_mode);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

