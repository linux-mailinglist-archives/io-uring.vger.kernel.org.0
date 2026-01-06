Return-Path: <io-uring+bounces-11420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DFACF8455
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 13:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 244203174FDE
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 12:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFAB32E130;
	Tue,  6 Jan 2026 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxjktiRe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E42821C173;
	Tue,  6 Jan 2026 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767701348; cv=none; b=DXHlfPo3MRDz3HB1zyXDiyiX1TDEchYMTSK3rifLiMBQy/I64G3Q3atZEoEMBTXszKud9ETskhA+ad12eN0mFU0Ove7+z27bNjb+2v6ijbtqmCLVqsVj/NuThoV1z9mPmLTgONaL7uO5IcM5mPA/IX4zkuOjuFreytmLT+1pY8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767701348; c=relaxed/simple;
	bh=zHzAmv7igNEZapvu5Mg7gJuCGbVh5GCmZk39gxy+fJk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sV9egkrKuWP3xngu87CZXgY+yNNHjiHlqgUyAVp4nTomc6T6Lv+8HF1f7YcgyrBJAjPYFY5eC64oUI8aigBOYroJKadoba+E/HOiI5pUjiIJdliarOI3D9TG2VlQkBqEIF3HNy0AKggMXrb5vkX+W70n4HvExL+FCu0f+Reg1pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxjktiRe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6715FC116C6;
	Tue,  6 Jan 2026 12:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767701348;
	bh=zHzAmv7igNEZapvu5Mg7gJuCGbVh5GCmZk39gxy+fJk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=oxjktiReypTQNdQaKnmZU31yb0GmMwimKRuybNRPQqqjHT1UBEHVBKXEb448j0n6l
	 3EGE2y+9wL8yEfcxUsPCzwyEh4Utl+fpLf71XuiNi5Nmy8zPw6DEstKfNftli8fRH+
	 6py2JKh7z3FMgNco5LGtx3kv08jW6SyjjzMwwwv2BI/tL7RCNTsyskfNxguELa6MgH
	 N8eqDAj+lGh+WzO8V3Lk7sOoJtaLoHz6H7nWt858DA5tFLEuUgln1p0RxidHSooNce
	 93g9ahsg8Nc4jAAgldLyYJt5x3vJXziEKaUo519OZsFs9VKQHwNqOkv8OE/K2q9amD
	 cr9jraA8EZpxg==
Message-ID: <b208c2a6e1a3ab44e3c820af106b5be99279d986.camel@kernel.org>
Subject: Re: [PATCH 05/11] fs: refactor ->update_time handling
From: Jeff Layton <jlayton@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan
 Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>, Martin
 Brandenburg	 <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch	 <shr@fb.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Trond Myklebust	 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, 	devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, 	linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, 	linux-nfs@vger.kernel.org
Date: Tue, 06 Jan 2026 07:09:04 -0500
In-Reply-To: <20260106075008.1610195-6-hch@lst.de>
References: <20260106075008.1610195-1-hch@lst.de>
	 <20260106075008.1610195-6-hch@lst.de>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-01-06 at 08:49 +0100, Christoph Hellwig wrote:
> Pass the type of update (atime vs c/mtime plus version) as an enum
> instead of a set of flags that caused all kinds of confusion.
> Because inode_update_timestamps now can't return a modified version
> of those flags, return the I_DIRTY_* flags needed to persist the
> update, which is what the main caller in generic_update_time wants
> anyway, and which is suitable for the other callers that only want
> to know if an update happened.
>=20
> The whole update_time path keeps the flags argument, which will be used
> to support non-blocking updates soon even if it is unused, and (the
> slightly renamed) inode_update_time also gains the possibility to return
> a negative errno to support this.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/locking.rst |   3 +-
>  Documentation/filesystems/vfs.rst     |   3 +-
>  fs/bad_inode.c                        |   3 +-
>  fs/btrfs/inode.c                      |  11 ++-
>  fs/fat/fat.h                          |   3 +-
>  fs/fat/misc.c                         |  20 ++--
>  fs/gfs2/inode.c                       |   5 +-
>  fs/inode.c                            | 134 ++++++++++++++------------
>  fs/nfs/inode.c                        |  10 +-
>  fs/orangefs/inode.c                   |  28 +++---
>  fs/orangefs/orangefs-kernel.h         |   3 +-
>  fs/overlayfs/inode.c                  |   5 +-
>  fs/overlayfs/overlayfs.h              |   3 +-
>  fs/ubifs/file.c                       |  21 ++--
>  fs/ubifs/ubifs.h                      |   3 +-
>  fs/xfs/xfs_iops.c                     |  22 ++---
>  include/linux/fs.h                    |  28 ++++--
>  17 files changed, 157 insertions(+), 148 deletions(-)
>=20
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesy=
stems/locking.rst
> index 77704fde9845..37a4a7fa8094 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -80,7 +80,8 @@ prototypes::
>  	int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *=
, u32, unsigned int);
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u=
64 len);
> -	void (*update_time)(struct inode *, struct timespec *, int);
> +	void (*update_time)(struct inode *inode, enum fs_update_time type,
> +			    int flags);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  				struct file *, unsigned open_flag,
>  				umode_t create_mode);
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystem=
s/vfs.rst
> index 670ba66b60e4..51aa9db64784 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -485,7 +485,8 @@ As of kernel 2.6.22, the following members are define=
d:
>  		int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
>  		int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat =
*, u32, unsigned int);
>  		ssize_t (*listxattr) (struct dentry *, char *, size_t);
> -		void (*update_time)(struct inode *, struct timespec *, int);
> +		void (*update_time)(struct inode *inode, enum fs_update_time type,
> +				    int flags);

nit: these are int return in the code, but are documented as void
return here. Can you fix that up while you're in here?

>  		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
>  				   unsigned open_flag, umode_t create_mode);
>  		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umo=
de_t);
> diff --git a/fs/bad_inode.c b/fs/bad_inode.c
> index 0ef9bcb744dd..acf8613f5e36 100644
> --- a/fs/bad_inode.c
> +++ b/fs/bad_inode.c
> @@ -133,7 +133,8 @@ static int bad_inode_fiemap(struct inode *inode,
>  	return -EIO;
>  }
> =20
> -static int bad_inode_update_time(struct inode *inode, int flags)
> +static int bad_inode_update_time(struct inode *inode, enum fs_update_tim=
e type,
> +				 unsigned int flags)
>  {
>  	return -EIO;
>  }
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 599c03a1c573..23fc38de9be5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6354,16 +6354,19 @@ static int btrfs_dirty_inode(struct btrfs_inode *=
inode)
>   * We need our own ->update_time so that we can return error on ENOSPC f=
or
>   * updating the inode in the case of file write and mmap writes.
>   */
> -static int btrfs_update_time(struct inode *inode, int flags)
> +static int btrfs_update_time(struct inode *inode, enum fs_update_time ty=
pe,
> +		unsigned int flags)
>  {
>  	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> -	bool dirty;
> +	int dirty;
> =20
>  	if (btrfs_root_readonly(root))
>  		return -EROFS;
> =20
> -	dirty =3D inode_update_timestamps(inode, flags);
> -	return dirty ? btrfs_dirty_inode(BTRFS_I(inode)) : 0;
> +	dirty =3D inode_update_time(inode, type, flags);
> +	if (dirty <=3D 0)
> +		return dirty;
> +	return btrfs_dirty_inode(BTRFS_I(inode));
>  }
> =20
>  /*
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 767b566b1cab..0d269dba897b 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -472,7 +472,8 @@ extern struct timespec64 fat_truncate_atime(const str=
uct msdos_sb_info *sbi,
>  #define FAT_UPDATE_CMTIME	(1u << 1)
>  void fat_truncate_time(struct inode *inode, struct timespec64 *now,
>  		unsigned int flags);
> -extern int fat_update_time(struct inode *inode, int flags);
> +int fat_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
>  extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
> =20
>  int fat_cache_init(void);
> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index f4a1fa58bf05..b154a5162764 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
> @@ -332,22 +332,14 @@ void fat_truncate_time(struct inode *inode, struct =
timespec64 *now,
>  }
>  EXPORT_SYMBOL_GPL(fat_truncate_time);
> =20
> -int fat_update_time(struct inode *inode, int flags)
> +int fat_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	int dirty_flags =3D 0;
> -
> -	if (inode->i_ino =3D=3D MSDOS_ROOT_INO)
> -		return 0;
> -
> -	if (flags & (S_ATIME | S_CTIME | S_MTIME)) {
> -		fat_truncate_time(inode, NULL, flags);
> -		if (inode->i_sb->s_flags & SB_LAZYTIME)
> -			dirty_flags |=3D I_DIRTY_TIME;
> -		else
> -			dirty_flags |=3D I_DIRTY_SYNC;
> +	if (inode->i_ino !=3D MSDOS_ROOT_INO) {
> +		fat_truncate_time(inode, NULL, type =3D=3D FS_UPD_ATIME ?
> +				FAT_UPDATE_ATIME : FAT_UPDATE_CMTIME);
> +		__mark_inode_dirty(inode, inode_time_dirty_flag(inode));

As OGAWA Hirofumi points out, patch 4 causes a regression that this
fixes. It'd be good to fix that up to be properly bisectable before
merging.

>  	}
> -
> -	__mark_inode_dirty(inode, dirty_flags);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(fat_update_time);
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index e08eb419347c..4ef39ff6889d 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -2242,7 +2242,8 @@ loff_t gfs2_seek_hole(struct file *file, loff_t off=
set)
>  	return vfs_setpos(file, ret, inode->i_sb->s_maxbytes);
>  }
> =20
> -static int gfs2_update_time(struct inode *inode, int flags)
> +static int gfs2_update_time(struct inode *inode, enum fs_update_time typ=
e,
> +		unsigned int flags)
>  {
>  	struct gfs2_inode *ip =3D GFS2_I(inode);
>  	struct gfs2_glock *gl =3D ip->i_gl;
> @@ -2257,7 +2258,7 @@ static int gfs2_update_time(struct inode *inode, in=
t flags)
>  		if (error)
>  			return error;
>  	}
> -	return generic_update_time(inode, flags);
> +	return generic_update_time(inode, type, flags);
>  }
> =20
>  static const struct inode_operations gfs2_file_iops =3D {
> diff --git a/fs/inode.c b/fs/inode.c
> index 7eb28dd45a5a..7d8709b0158c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2081,78 +2081,84 @@ static bool relatime_need_update(struct vfsmount =
*mnt, struct inode *inode,
>  	return false;
>  }
> =20
> +static int inode_update_atime(struct inode *inode)
> +{
> +	struct timespec64 atime =3D inode_get_atime(inode);
> +	struct timespec64 now =3D current_time(inode);
> +
> +	if (timespec64_equal(&now, &atime))
> +		return 0;
> +
> +	inode_set_atime_to_ts(inode, now);
> +	return inode_time_dirty_flag(inode);
> +}
> +
> +static int inode_update_cmtime(struct inode *inode)
> +{
> +	struct timespec64 now =3D inode_set_ctime_current(inode);
> +	struct timespec64 ctime =3D inode_get_ctime(inode);

I was wondering why you're sampling this separately when
inode_set_ctime_current() will return the same thing. I think Jan is
correct though that you need to sample those in reverse order.

> +	struct timespec64 mtime =3D inode_get_mtime(inode);
> +	unsigned int dirty =3D 0;
> +	bool mtime_changed;
> +
> +	mtime_changed =3D !timespec64_equal(&now, &mtime);
> +	if (mtime_changed || !timespec64_equal(&now, &ctime))
> +		dirty =3D inode_time_dirty_flag(inode);
> +	if (mtime_changed)
> +		inode_set_mtime_to_ts(inode, now);
> +
> +	if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, !!dirty))
> +		dirty |=3D I_DIRTY_SYNC;
> +
> +	return dirty;
> +}
> +
>  /**
> - * inode_update_timestamps - update the timestamps on the inode
> + * inode_update_time - update either atime or c/mtime and i_version on t=
he inode
>   * @inode: inode to be updated
> - * @flags: S_* flags that needed to be updated
> + * @type: timestamp to be updated
> + * @flags: flags for the update
>   *
> - * The update_time function is called when an inode's timestamps need to=
 be
> - * updated for a read or write operation. This function handles updating=
 the
> - * actual timestamps. It's up to the caller to ensure that the inode is =
marked
> - * dirty appropriately.
> + * Update either atime or c/mtime and version in a inode if needed for a=
 file
> + * access or modification.  It is up to the caller to mark the inode dir=
ty
> + * appropriately.
>   *
> - * In the case where any of S_MTIME, S_CTIME, or S_VERSION need to be up=
dated,
> - * attempt to update all three of them. S_ATIME updates can be handled
> - * independently of the rest.
> - *
> - * Returns a set of S_* flags indicating which values changed.
> + * Returns the positive I_DIRTY_* flags for __mark_inode_dirty() if the =
inode
> + * needs to be marked dirty, 0 if it did not, or a negative errno if an =
error
> + * happened.
>   */
> -int inode_update_timestamps(struct inode *inode, int flags)
> +int inode_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	int updated =3D 0;
> -	struct timespec64 now;
> -
> -	if (flags & (S_MTIME|S_CTIME|S_VERSION)) {
> -		struct timespec64 ctime =3D inode_get_ctime(inode);
> -		struct timespec64 mtime =3D inode_get_mtime(inode);
> -
> -		now =3D inode_set_ctime_current(inode);
> -		if (!timespec64_equal(&now, &ctime))
> -			updated |=3D S_CTIME;
> -		if (!timespec64_equal(&now, &mtime)) {
> -			inode_set_mtime_to_ts(inode, now);
> -			updated |=3D S_MTIME;
> -		}
> -		if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, updated))
> -			updated |=3D S_VERSION;
> -	} else {
> -		now =3D current_time(inode);
> -	}
> -
> -	if (flags & S_ATIME) {
> -		struct timespec64 atime =3D inode_get_atime(inode);
> -
> -		if (!timespec64_equal(&now, &atime)) {
> -			inode_set_atime_to_ts(inode, now);
> -			updated |=3D S_ATIME;
> -		}
> +	switch (type) {
> +	case FS_UPD_ATIME:
> +		return inode_update_atime(inode);
> +	case FS_UPD_CMTIME:
> +		return inode_update_cmtime(inode);
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EIO;
>  	}
> -	return updated;
>  }
> -EXPORT_SYMBOL(inode_update_timestamps);
> +EXPORT_SYMBOL(inode_update_time);
> =20
>  /**
>   * generic_update_time - update the timestamps on the inode
>   * @inode: inode to be updated
> - * @flags: S_* flags that needed to be updated
> - *
> - * The update_time function is called when an inode's timestamps need to=
 be
> - * updated for a read or write operation. In the case where any of S_MTI=
ME, S_CTIME,
> - * or S_VERSION need to be updated we attempt to update all three of the=
m. S_ATIME
> - * updates can be handled done independently of the rest.
> + * @type: timestamp to be updated
> + * @flags: flags for the update
>   *
>   * Returns a negative error value on error, else 0.
>   */
> -int generic_update_time(struct inode *inode, int flags)
> +int generic_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	int updated =3D inode_update_timestamps(inode, flags);
> -	int dirty_flags =3D 0;
> +	int dirty;
> =20
> -	if (updated & (S_ATIME|S_MTIME|S_CTIME))
> -		dirty_flags =3D inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_=
DIRTY_SYNC;
> -	if (updated & S_VERSION)
> -		dirty_flags |=3D I_DIRTY_SYNC;
> -	__mark_inode_dirty(inode, dirty_flags);
> +	dirty =3D inode_update_time(inode, type, flags);
> +	if (dirty <=3D 0)
> +		return dirty;
> +	__mark_inode_dirty(inode, dirty);
>  	return 0;
>  }
>  EXPORT_SYMBOL(generic_update_time);
> @@ -2225,9 +2231,9 @@ void touch_atime(const struct path *path)
>  	 * of the fs read only, e.g. subvolumes in Btrfs.
>  	 */
>  	if (inode->i_op->update_time)
> -		inode->i_op->update_time(inode, S_ATIME);
> +		inode->i_op->update_time(inode, FS_UPD_ATIME, 0);
>  	else
> -		generic_update_time(inode, S_ATIME);
> +		generic_update_time(inode, FS_UPD_ATIME, 0);
>  	mnt_put_write_access(mnt);
>  skip_update:
>  	sb_end_write(inode->i_sb);
> @@ -2354,7 +2360,7 @@ static int file_update_time_flags(struct file *file=
, unsigned int flags)
>  {
>  	struct inode *inode =3D file_inode(file);
>  	struct timespec64 now, ts;
> -	int sync_mode =3D 0;
> +	bool need_update =3D false;
>  	int ret =3D 0;
> =20
>  	/* First try to exhaust all avenues to not sync */
> @@ -2367,14 +2373,14 @@ static int file_update_time_flags(struct file *fi=
le, unsigned int flags)
> =20
>  	ts =3D inode_get_mtime(inode);
>  	if (!timespec64_equal(&ts, &now))
> -		sync_mode |=3D S_MTIME;
> +		need_update =3D true;
>  	ts =3D inode_get_ctime(inode);
>  	if (!timespec64_equal(&ts, &now))
> -		sync_mode |=3D S_CTIME;
> +		need_update =3D true;
>  	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
> -		sync_mode |=3D S_VERSION;
> +		need_update =3D true;
> =20
> -	if (!sync_mode)
> +	if (!need_update)
>  		return 0;
> =20
>  	if (flags & IOCB_NOWAIT)
> @@ -2383,9 +2389,9 @@ static int file_update_time_flags(struct file *file=
, unsigned int flags)
>  	if (mnt_get_write_access_file(file))
>  		return 0;
>  	if (inode->i_op->update_time)
> -		ret =3D inode->i_op->update_time(inode, sync_mode);
> +		ret =3D inode->i_op->update_time(inode, FS_UPD_CMTIME, 0);
>  	else
> -		ret =3D generic_update_time(inode, sync_mode);
> +		ret =3D generic_update_time(inode, FS_UPD_CMTIME, 0);
>  	mnt_put_write_access_file(file);
>  	return ret;
>  }
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 3be8ba7b98c5..cd6d7c6e1237 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -649,15 +649,15 @@ static void nfs_set_timestamps_to_ts(struct inode *=
inode, struct iattr *attr)
>  		struct timespec64 ctime =3D inode_get_ctime(inode);
>  		struct timespec64 mtime =3D inode_get_mtime(inode);
>  		struct timespec64 now;
> -		int updated =3D 0;
> +		bool updated =3D false;
> =20
>  		now =3D inode_set_ctime_current(inode);
>  		if (!timespec64_equal(&now, &ctime))
> -			updated |=3D S_CTIME;
> +			updated =3D true;
> =20
>  		inode_set_mtime_to_ts(inode, attr->ia_mtime);
>  		if (!timespec64_equal(&now, &mtime))
> -			updated |=3D S_MTIME;
> +			updated =3D true;
> =20
>  		inode_maybe_inc_iversion(inode, updated);
>  		cache_flags |=3D NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
> @@ -671,13 +671,13 @@ static void nfs_set_timestamps_to_ts(struct inode *=
inode, struct iattr *attr)
> =20
>  static void nfs_update_atime(struct inode *inode)
>  {
> -	inode_update_timestamps(inode, S_ATIME);
> +	inode_update_time(inode, FS_UPD_ATIME, 0);
>  	NFS_I(inode)->cache_validity &=3D ~NFS_INO_INVALID_ATIME;
>  }
> =20
>  static void nfs_update_mtime(struct inode *inode)
>  {
> -	inode_update_timestamps(inode, S_MTIME | S_CTIME);
> +	inode_update_time(inode, FS_UPD_CMTIME, 0);
>  	NFS_I(inode)->cache_validity &=3D
>  		~(NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME);
>  }
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index d7275990ffa4..eab16afb5b8a 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -872,22 +872,24 @@ int orangefs_permission(struct mnt_idmap *idmap,
>  	return generic_permission(&nop_mnt_idmap, inode, mask);
>  }
> =20
> -int orangefs_update_time(struct inode *inode, int flags)
> +int orangefs_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	struct iattr iattr;
> +	struct iattr iattr =3D { };
> +	int dirty;
> =20
> -	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
> -	    get_khandle_from_ino(inode));
> -
> -	flags =3D inode_update_timestamps(inode, flags);
> +	switch (type) {
> +	case FS_UPD_ATIME:
> +		iattr.ia_valid =3D ATTR_ATIME;
> +		break;
> +	case FS_UPD_CMTIME:
> +		iattr.ia_valid =3D ATTR_CTIME | ATTR_MTIME;
> +		break;
> +	}
> =20
> -	memset(&iattr, 0, sizeof iattr);
> -        if (flags & S_ATIME)
> -		iattr.ia_valid |=3D ATTR_ATIME;
> -	if (flags & S_CTIME)
> -		iattr.ia_valid |=3D ATTR_CTIME;
> -	if (flags & S_MTIME)
> -		iattr.ia_valid |=3D ATTR_MTIME;
> +	dirty =3D inode_update_time(inode, type, flags);
> +	if (dirty <=3D 0)
> +		return dirty;
>  	return __orangefs_setattr(inode, &iattr);
>  }
> =20
> diff --git a/fs/orangefs/orangefs-kernel.h b/fs/orangefs/orangefs-kernel.=
h
> index 29c6da43e396..1451fc2c1917 100644
> --- a/fs/orangefs/orangefs-kernel.h
> +++ b/fs/orangefs/orangefs-kernel.h
> @@ -360,7 +360,8 @@ int orangefs_getattr(struct mnt_idmap *idmap, const s=
truct path *path,
>  int orangefs_permission(struct mnt_idmap *idmap,
>  			struct inode *inode, int mask);
> =20
> -int orangefs_update_time(struct inode *, int);
> +int orangefs_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
> =20
>  /*
>   * defined in xattr.c
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index bdbf86b56a9b..c0ce3519e4af 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -555,9 +555,10 @@ int ovl_set_acl(struct mnt_idmap *idmap, struct dent=
ry *dentry,
>  }
>  #endif
> =20
> -int ovl_update_time(struct inode *inode, int flags)
> +int ovl_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	if (flags & S_ATIME) {
> +	if (type =3D=3D FS_UPD_ATIME) {
>  		struct ovl_fs *ofs =3D OVL_FS(inode->i_sb);
>  		struct path upperpath =3D {
>  			.mnt =3D ovl_upper_mnt(ofs),
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index f9ac9bdde830..315882a360ce 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -820,7 +820,8 @@ static inline struct posix_acl *ovl_get_acl_path(cons=
t struct path *path,
>  }
>  #endif
> =20
> -int ovl_update_time(struct inode *inode, int flags);
> +int ovl_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
>  bool ovl_is_private_xattr(struct super_block *sb, const char *name);
> =20
>  struct ovl_inode_params {
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index ec1bb9f43acc..0cc44ad142de 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1361,17 +1361,8 @@ static inline int mctime_update_needed(const struc=
t inode *inode,
>  	return 0;
>  }
> =20
> -/**
> - * ubifs_update_time - update time of inode.
> - * @inode: inode to update
> - * @flags: time updating control flag determines updating
> - *	    which time fields of @inode
> - *
> - * This function updates time of the inode.
> - *
> - * Returns: %0 for success or a negative error code otherwise.
> - */
> -int ubifs_update_time(struct inode *inode, int flags)
> +int ubifs_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
>  	struct ubifs_inode *ui =3D ubifs_inode(inode);
>  	struct ubifs_info *c =3D inode->i_sb->s_fs_info;
> @@ -1379,15 +1370,19 @@ int ubifs_update_time(struct inode *inode, int fl=
ags)
>  			.dirtied_ino_d =3D ALIGN(ui->data_len, 8) };
>  	int err, release;
> =20
> +	/* ubifs sets S_NOCMTIME on all inodes, this should not happen. */
> +	if (WARN_ON_ONCE(type !=3D FS_UPD_ATIME))
> +		return -EIO;
> +
>  	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
> -		return generic_update_time(inode, flags);
> +		return generic_update_time(inode, type, flags);
> =20
>  	err =3D ubifs_budget_space(c, &req);
>  	if (err)
>  		return err;
> =20
>  	mutex_lock(&ui->ui_mutex);
> -	inode_update_timestamps(inode, flags);
> +	inode_update_time(inode, type, flags);
>  	release =3D ui->dirty;
>  	__mark_inode_dirty(inode, I_DIRTY_SYNC);
>  	mutex_unlock(&ui->ui_mutex);
> diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
> index 118392aa9f2a..b62a154c7bd4 100644
> --- a/fs/ubifs/ubifs.h
> +++ b/fs/ubifs/ubifs.h
> @@ -2018,7 +2018,8 @@ int ubifs_calc_dark(const struct ubifs_info *c, int=
 spc);
>  int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasyn=
c);
>  int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
> -int ubifs_update_time(struct inode *inode, int flags);
> +int ubifs_update_time(struct inode *inode, enum fs_update_time type,
> +		      unsigned int flags);
> =20
>  /* dir.c */
>  struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 9dedb54e3cb0..d9eae1af14a8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1184,21 +1184,21 @@ xfs_vn_setattr(
>  STATIC int
>  xfs_vn_update_time(
>  	struct inode		*inode,
> -	int			flags)
> +	enum fs_update_time	type,
> +	unsigned int		flags)
>  {
>  	struct xfs_inode	*ip =3D XFS_I(inode);
>  	struct xfs_mount	*mp =3D ip->i_mount;
>  	int			log_flags =3D XFS_ILOG_TIMESTAMP;
>  	struct xfs_trans	*tp;
>  	int			error;
> -	struct timespec64	now;
> =20
>  	trace_xfs_update_time(ip);
> =20
>  	if (inode->i_sb->s_flags & SB_LAZYTIME) {
> -		if (!((flags & S_VERSION) &&
> -		      inode_maybe_inc_iversion(inode, false)))
> -			return generic_update_time(inode, flags);
> +		if (type =3D=3D FS_UPD_ATIME ||
> +		    !inode_maybe_inc_iversion(inode, false))
> +			return generic_update_time(inode, type, flags);
> =20
>  		/* Capture the iversion update that just occurred */
>  		log_flags |=3D XFS_ILOG_CORE;
> @@ -1209,16 +1209,10 @@ xfs_vn_update_time(
>  		return error;
> =20
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (flags & (S_CTIME|S_MTIME))
> -		now =3D inode_set_ctime_current(inode);
> +	if (type =3D=3D FS_UPD_ATIME)
> +		inode_set_atime_to_ts(inode, current_time(inode));
>  	else
> -		now =3D current_time(inode);
> -
> -	if (flags & S_MTIME)
> -		inode_set_mtime_to_ts(inode, now);
> -	if (flags & S_ATIME)
> -		inode_set_atime_to_ts(inode, now);
> -
> +		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, log_flags);
>  	return xfs_trans_commit(tp);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index fccb0a38cb74..35b3e6c6b084 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1717,6 +1717,13 @@ static inline struct timespec64 inode_set_ctime(st=
ruct inode *inode,
> =20
>  struct timespec64 simple_inode_init_ts(struct inode *inode);
> =20
> +static inline int inode_time_dirty_flag(struct inode *inode)
> +{
> +	if (inode->i_sb->s_flags & SB_LAZYTIME)
> +		return I_DIRTY_TIME;
> +	return I_DIRTY_SYNC;
> +}
> +
>  /*
>   * Snapshotting support.
>   */
> @@ -1983,6 +1990,11 @@ int wrap_directory_iterator(struct file *, struct =
dir_context *,
>  	static int shared_##x(struct file *file , struct dir_context *ctx) \
>  	{ return wrap_directory_iterator(file, ctx, x); }
> =20
> +enum fs_update_time {
> +	FS_UPD_ATIME,
> +	FS_UPD_CMTIME,
> +};
> +
>  struct inode_operations {
>  	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int=
);
>  	const char * (*get_link) (struct dentry *, struct inode *, struct delay=
ed_call *);
> @@ -2010,7 +2022,8 @@ struct inode_operations {
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
>  		      u64 len);
> -	int (*update_time)(struct inode *, int);
> +	int (*update_time)(struct inode *inode, enum fs_update_time type,
> +			   unsigned int flags);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  			   struct file *, unsigned open_flag,
>  			   umode_t create_mode);
> @@ -2237,13 +2250,6 @@ static inline void inode_dec_link_count(struct ino=
de *inode)
>  	mark_inode_dirty(inode);
>  }
> =20
> -enum file_time_flags {
> -	S_ATIME =3D 1,
> -	S_MTIME =3D 2,
> -	S_CTIME =3D 4,
> -	S_VERSION =3D 8,
> -};
> -
>  extern bool atime_needs_update(const struct path *, struct inode *);
>  extern void touch_atime(const struct path *);
> =20
> @@ -2398,8 +2404,10 @@ static inline void super_set_sysfs_name_generic(st=
ruct super_block *sb, const ch
>  extern void ihold(struct inode * inode);
>  extern void iput(struct inode *);
>  void iput_not_last(struct inode *);
> -int inode_update_timestamps(struct inode *inode, int flags);
> -int generic_update_time(struct inode *inode, int flags);
> +int inode_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
> +int generic_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
> =20
>  /* /sys/fs */
>  extern struct kobject *fs_kobj;

--=20
Jeff Layton <jlayton@kernel.org>

