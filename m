Return-Path: <io-uring+bounces-3846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F19899A6AFC
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 728611F2251A
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 13:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C701DC04C;
	Mon, 21 Oct 2024 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="O0HgLyh6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kLQvQjNG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bBEbosy/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nfjM1NrQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E419D1F893A;
	Mon, 21 Oct 2024 13:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518611; cv=none; b=piyWALTjy3J+Iwl5RuA5uehVgvj2TzE0AJaJxBnA1l2GqdaZxx94A8Nl6ULNvB/5e8RUPkk8wmmQ8Eo0nMlAQH1+9c+GR7vDe8sUN5c3D5Z0pkbUl/rDo0vrGZdS5TpOiHZqfvBE7wssSrHK24J1tTX0UfBGX8WZ5dBWvozBXM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518611; c=relaxed/simple;
	bh=Mk4WP6CpZUAGBdxTK3XDp41r9HAu4WggClc7ImgtTmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozRJ71PA19zDl/WJKrEv+zdG0FLbGi0Embd0jHiY3usa2PK2oaYGTRNvcgyo29gGC+liLezwkdw+KfZRoeso4P3sDi1dmyhJ2hsURDKBXPYi6m2WCfHPgL7vjoaNI9Tc+0b0ff0v2DEVzuMQku6NezU25xOB7qlFUGX8pHrZT5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=O0HgLyh6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kLQvQjNG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bBEbosy/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nfjM1NrQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D93221FC30;
	Mon, 21 Oct 2024 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729518607;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j32sOaTX8Z5KiUM7kADyk2rsoZ2zkdVwYZam0ikQ/OQ=;
	b=O0HgLyh6YxgsuoGlgdD2WQpVs+KEi5Zw2v8IYcpjgjYZWnsnOARfXVxIbuxqKZjfFVMcNL
	x/zeL2CxYz2SClMNzHNRKOt++c0d0OrLWyjQMcDBni3PEEeCbvhesHYLJt+v8nBeMKO7gW
	La1zucr6jKahnVKBkL8/ImL4tNasfQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729518607;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j32sOaTX8Z5KiUM7kADyk2rsoZ2zkdVwYZam0ikQ/OQ=;
	b=kLQvQjNG8bKZSNhugjV0BAhwa9ruNrQpQZfY/bp1IqEuzSwNmIYclhhsKI6iiES2j7xXVM
	7OQbDuQhVlpdI9CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="bBEbosy/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nfjM1NrQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729518606;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j32sOaTX8Z5KiUM7kADyk2rsoZ2zkdVwYZam0ikQ/OQ=;
	b=bBEbosy/Z0eOAbsbdcUulY237+ovbxRxyauJGaVW0rbm92aEDsEi0p7HS8V2qZBWU04AYV
	LbcgQeD4huf85iJ7tFZYBeMSBYE6ITUGp+Xu6V25utOrFoL5HY8lFoSCjvJwhIYs/w6r9d
	TvqJ99Z0X6j+b0mO67GTwxMK4k7Shh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729518606;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j32sOaTX8Z5KiUM7kADyk2rsoZ2zkdVwYZam0ikQ/OQ=;
	b=nfjM1NrQCAA5Q8sKaX36KZH+O/Tap6ljteRhx8M4uapBvefetNPTMOV1bBPrWLhNWqPRs4
	Z+wLIBi+MsCVJCDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4FC9139E0;
	Mon, 21 Oct 2024 13:50:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bQD+Kw5cFmfsSAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Oct 2024 13:50:06 +0000
Date: Mon, 21 Oct 2024 15:50:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Message-ID: <20241021135005.GC17835@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-6-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014171838.304953-6-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: D93221FC30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.21
X-Spam-Flag: NO

On Mon, Oct 14, 2024 at 06:18:27PM +0100, Mark Harmstone wrote:
> Adds an io_uring command for encoded reads, using the same interface as

Add ...

> the existing BTRFS_IOC_ENCODED_READ ioctl.

This is probably a good summary in a changelog but the patch is quite
long so it feels like this should be described in a more detail how it's
done. Connecting two interfaces can be done in various ways, so at least
mention that it's a simple pass through, or if there are any
complications regardign locking, object lifetime and such.

> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>  fs/btrfs/file.c  |   1 +
>  fs/btrfs/ioctl.c | 283 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |   1 +
>  3 files changed, 285 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 2aeb8116549c..e33ca73fef8c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3774,6 +3774,7 @@ const struct file_operations btrfs_file_operations = {
>  	.compat_ioctl	= btrfs_compat_ioctl,
>  #endif
>  	.remap_file_range = btrfs_remap_file_range,
> +	.uring_cmd	= btrfs_uring_cmd,
>  	.fop_flags	= FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
>  };
>  
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8c9ff4898ab0..c0393575cf5e 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -29,6 +29,7 @@
>  #include <linux/fileattr.h>
>  #include <linux/fsverity.h>
>  #include <linux/sched/xacct.h>
> +#include <linux/io_uring/cmd.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "export.h"
> @@ -4723,6 +4724,288 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
>  	return ret;
>  }
>  
> +struct btrfs_uring_priv {
> +	struct io_uring_cmd *cmd;
> +	struct page **pages;
> +	unsigned long nr_pages;
> +	struct kiocb iocb;
> +	struct iovec *iov;
> +	struct iov_iter iter;
> +	struct extent_state *cached_state;
> +	u64 count;
> +	bool compressed;

This leaves a 7 byte hole.

> +	u64 start;
> +	u64 lockend;
> +};

The whole structure should be documented and the members too if it's not
obvious what they are used for.

> +
> +static void btrfs_uring_read_finished(struct io_uring_cmd *cmd,
> +				      unsigned int issue_flags)
> +{
> +	struct btrfs_uring_priv *priv = (struct btrfs_uring_priv *)*(uintptr_t*)cmd->pdu;
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(priv->iocb.ki_filp));
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	unsigned long i;

Why is this long?

> +	u64 cur;
> +	size_t page_offset;
> +	ssize_t ret;
> +
> +	if (priv->compressed) {
> +		i = 0;
> +		page_offset = 0;
> +	} else {
> +		i = (priv->iocb.ki_pos - priv->start) >> PAGE_SHIFT;
> +		page_offset = (priv->iocb.ki_pos - priv->start) & (PAGE_SIZE - 1);

Please don't open code page_offset()

> +	}
> +	cur = 0;
> +	while (cur < priv->count) {
> +		size_t bytes = min_t(size_t, priv->count - cur,
> +				     PAGE_SIZE - page_offset);
> +
> +		if (copy_page_to_iter(priv->pages[i], page_offset, bytes,
> +				      &priv->iter) != bytes) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		i++;
> +		cur += bytes;
> +		page_offset = 0;
> +	}
> +	ret = priv->count;
> +
> +out:
> +	unlock_extent(io_tree, priv->start, priv->lockend, &priv->cached_state);
> +	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> +
> +	io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +	add_rchar(current, ret);
> +
> +	for (unsigned long i = 0; i < priv->nr_pages; i++) {

Shadowing 'i' of the same type as is declared in the function. Maybe
don't call it just 'i' but index as it's used outside of a loop.

> +		__free_page(priv->pages[i]);
> +	}

Please drop the outer { } for a single statement block.

> +
> +	kfree(priv->pages);
> +	kfree(priv->iov);
> +	kfree(priv);
> +}
> +
> +static void btrfs_uring_read_extent_cb(void *ctx, int err)
> +{
> +	struct btrfs_uring_priv *priv = ctx;
> +
> +	*(uintptr_t*)priv->cmd->pdu = (uintptr_t)priv;

Isn't there a helper for that? Type casting should be done in justified
cases and as an exception.

> +	io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished);
> +}
> +
> +static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
> +				   u64 start, u64 lockend,
> +				   struct extent_state *cached_state,
> +				   u64 disk_bytenr, u64 disk_io_size,
> +				   size_t count, bool compressed,
> +				   struct iovec *iov,
> +				   struct io_uring_cmd *cmd)
> +{
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	struct page **pages;
> +	struct btrfs_uring_priv *priv = NULL;
> +	unsigned long nr_pages;
> +	int ret;
> +
> +	nr_pages = DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
> +	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> +	if (!pages)
> +		return -ENOMEM;
> +	ret = btrfs_alloc_page_array(nr_pages, pages, 0);

The allocation sizes are derived from disk_io_size that comes from the
outside, potentially making large allocatoins. Or is there some inherent
limit on the maximu size?

> +	if (ret) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	priv = kmalloc(sizeof(*priv), GFP_NOFS);
> +	if (!priv) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	priv->iocb = *iocb;
> +	priv->iov = iov;
> +	priv->iter = *iter;
> +	priv->count = count;
> +	priv->cmd = cmd;
> +	priv->cached_state = cached_state;
> +	priv->compressed = compressed;
> +	priv->nr_pages = nr_pages;
> +	priv->pages = pages;
> +	priv->start = start;
> +	priv->lockend = lockend;
> +
> +	ret = btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr,
> +						    disk_io_size, pages,
> +						    btrfs_uring_read_extent_cb,
> +						    priv);
> +	if (ret)
> +		goto fail;
> +
> +	return -EIOCBQUEUED;
> +
> +fail:
> +	unlock_extent(io_tree, start, lockend, &cached_state);
> +	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> +	kfree(priv);

Does this leak pages and priv->pages?

> +	return ret;
> +}
> +
> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args,
> +					     flags);
> +	size_t copy_end;
> +	struct btrfs_ioctl_encoded_io_args args = {0};
                                                = { 0 }
> +	int ret;
> +	u64 disk_bytenr, disk_io_size;
> +	struct file *file = cmd->file;
> +	struct btrfs_inode *inode = BTRFS_I(file->f_inode);
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	struct iovec iovstack[UIO_FASTIOV];
> +	struct iovec *iov = iovstack;
> +	struct iov_iter iter;
> +	loff_t pos;
> +	struct kiocb kiocb;
> +	struct extent_state *cached_state = NULL;
> +	u64 start, lockend;

The stack consumption looks quite high.

> +
> +	if (!capable(CAP_SYS_ADMIN)) {
> +		ret = -EPERM;
> +		goto out_acct;
> +	}
> +
> +	if (issue_flags & IO_URING_F_COMPAT) {
> +#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
> +		struct btrfs_ioctl_encoded_io_args_32 args32;
> +
> +		copy_end = offsetofend(struct btrfs_ioctl_encoded_io_args_32,
> +				       flags);
> +		if (copy_from_user(&args32, (const void *)cmd->sqe->addr,
> +				   copy_end)) {
> +			ret = -EFAULT;
> +			goto out_acct;
> +		}
> +		args.iov = compat_ptr(args32.iov);
> +		args.iovcnt = args32.iovcnt;
> +		args.offset = args32.offset;
> +		args.flags = args32.flags;
> +#else
> +		return -ENOTTY;
> +#endif
> +	} else {
> +		copy_end = copy_end_kernel;
> +		if (copy_from_user(&args, (const void *)cmd->sqe->addr,
> +				   copy_end)) {
> +			ret = -EFAULT;
> +			goto out_acct;
> +		}
> +	}
> +
> +	if (args.flags != 0)
> +		return -EINVAL;
> +
> +	ret = import_iovec(ITER_DEST, args.iov, args.iovcnt, ARRAY_SIZE(iovstack),
> +			   &iov, &iter);
> +	if (ret < 0)
> +		goto out_acct;
> +
> +	if (iov_iter_count(&iter) == 0) {
> +		ret = 0;
> +		goto out_free;
> +	}
> +
> +	pos = args.offset;
> +	ret = rw_verify_area(READ, file, &pos, args.len);
> +	if (ret < 0)
> +		goto out_free;
> +
> +	init_sync_kiocb(&kiocb, file);
> +	kiocb.ki_pos = pos;
> +
> +	start = ALIGN_DOWN(pos, fs_info->sectorsize);
> +	lockend = start + BTRFS_MAX_UNCOMPRESSED - 1;
> +
> +	ret = btrfs_encoded_read(&kiocb, &iter, &args,
> +				 issue_flags & IO_URING_F_NONBLOCK,
> +				 &cached_state, &disk_bytenr, &disk_io_size);
> +	if (ret < 0 && ret != -EIOCBQUEUED)
> +		goto out_free;
> +
> +	file_accessed(file);
> +
> +	if (copy_to_user((void*)(uintptr_t)cmd->sqe->addr + copy_end,
> +			 (char *)&args + copy_end_kernel,

So many type casts again

> +			 sizeof(args) - copy_end_kernel)) {
> +		if (ret == -EIOCBQUEUED) {
> +			unlock_extent(io_tree, start, lockend, &cached_state);
> +			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> +		}
> +		ret = -EFAULT;
> +		goto out_free;
> +	}
> +
> +	if (ret == -EIOCBQUEUED) {
> +		u64 count;
> +
> +		/* If we've optimized things by storing the iovecs on the stack,
> +		 * undo this.  */

This is not proper comment formatting.

> +		if (!iov) {
> +			iov = kmalloc(sizeof(struct iovec) * args.iovcnt,
> +				      GFP_NOFS);
> +			if (!iov) {
> +				unlock_extent(io_tree, start, lockend,
> +					      &cached_state);
> +				btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> +				ret = -ENOMEM;
> +				goto out_acct;
> +			}
> +
> +			memcpy(iov, iovstack,
> +			       sizeof(struct iovec) * args.iovcnt);
> +		}
> +
> +		count = min_t(u64, iov_iter_count(&iter), disk_io_size);
> +
> +		ret = btrfs_uring_read_extent(&kiocb, &iter, start, lockend,
> +					      cached_state, disk_bytenr,
> +					      disk_io_size, count,
> +					      args.compression, iov, cmd);
> +
> +		goto out_acct;
> +	}
> +
> +out_free:
> +	kfree(iov);
> +
> +out_acct:
> +	if (ret > 0)
> +		add_rchar(current, ret);
> +	inc_syscr(current);
> +
> +	return ret;
> +}
> +
> +int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	switch (cmd->cmd_op) {
> +	case BTRFS_IOC_ENCODED_READ:
> +#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
> +	case BTRFS_IOC_ENCODED_READ_32:
> +#endif
> +		return btrfs_uring_encoded_read(cmd, issue_flags);
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {

