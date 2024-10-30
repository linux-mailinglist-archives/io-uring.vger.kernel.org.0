Return-Path: <io-uring+bounces-4176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F869B5915
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E43E01C226FF
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72740142E7C;
	Wed, 30 Oct 2024 01:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gug7oMCB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NX4e0OVU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gug7oMCB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NX4e0OVU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9C8171CD;
	Wed, 30 Oct 2024 01:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251465; cv=none; b=aqgkEcZ2zX9go0HHLMg2rHPZwUUzqI33hprj1NmDZpO+bCmG9BiRpLXeXAifAGbUO0SXu8O1P8oYE78BROGkJ1rPPsiWZsc3QnaPB7GGfezCXmyW8UQhHzLemHhbZCZbHJJYkgnzd2x5B0p0+7QUav5RX0x+EmZ1bEKZ+SDvu0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251465; c=relaxed/simple;
	bh=7bnZLOtENrYRYQRPt2oxYhyVFtWH82AiAqJu5vr3Vt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzqSLl183I1Kp9HtpbMoEZ8hmj8ixr7ZS1nzgfZ71kJwH4Nl8WcldysOfJbZFZKSIdKFzQzgNHXBAtrFk6W1ClgQ+nxXEE6hAW5ikuHFNzwUi6JatT5Hq9dUJGjlPYnkwLKnQke+7CY2fF2mh5VyUyiQPqWhxXWcg194VC+x4Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gug7oMCB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NX4e0OVU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gug7oMCB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NX4e0OVU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 680E321FCC;
	Wed, 30 Oct 2024 01:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730251460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mNkM7CdeX8tl74VBcm+oiDiSzllmIGgu8MUfGSwdnhQ=;
	b=gug7oMCBtCtdtolCo+JIBk4UZKXRcqFt8XlYzYlCfeJhlkKJPQ5TKmrFiSlpH6ztNGvFRX
	Dvm0YKwzmZzVA+oTsv5iHw/+YNKv3EMeaqDXpuUq7cnAYzPBkXD41xDs8A4dBUy3TjBtsU
	XfhdJBeTjXpio3ASuAhWYQ+sDgZ265s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730251460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mNkM7CdeX8tl74VBcm+oiDiSzllmIGgu8MUfGSwdnhQ=;
	b=NX4e0OVUKtyh7EMRK7ZGH1jRjWI2FBDbtvtfkX33Iwfo7cmBoT0yabm7pfvC17ec7HfRwh
	sXqAl/tGZ5TykDCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gug7oMCB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NX4e0OVU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730251460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mNkM7CdeX8tl74VBcm+oiDiSzllmIGgu8MUfGSwdnhQ=;
	b=gug7oMCBtCtdtolCo+JIBk4UZKXRcqFt8XlYzYlCfeJhlkKJPQ5TKmrFiSlpH6ztNGvFRX
	Dvm0YKwzmZzVA+oTsv5iHw/+YNKv3EMeaqDXpuUq7cnAYzPBkXD41xDs8A4dBUy3TjBtsU
	XfhdJBeTjXpio3ASuAhWYQ+sDgZ265s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730251460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mNkM7CdeX8tl74VBcm+oiDiSzllmIGgu8MUfGSwdnhQ=;
	b=NX4e0OVUKtyh7EMRK7ZGH1jRjWI2FBDbtvtfkX33Iwfo7cmBoT0yabm7pfvC17ec7HfRwh
	sXqAl/tGZ5TykDCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2607913721;
	Wed, 30 Oct 2024 01:24:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gPMICcSKIWe0KgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 30 Oct 2024 01:24:20 +0000
Date: Wed, 30 Oct 2024 02:24:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Message-ID: <20241030012403.GX31418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-6-maharmstone@fb.com>
 <63db1884-3170-499d-87c8-678923320699@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63db1884-3170-499d-87c8-678923320699@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: 680E321FCC
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.21
X-Spam-Flag: NO

On Wed, Oct 30, 2024 at 12:59:33AM +0000, Pavel Begunkov wrote:
> On 10/22/24 15:50, Mark Harmstone wrote:
> ...
> > +static void btrfs_uring_read_finished(struct io_uring_cmd *cmd,
> > +				      unsigned int issue_flags)
> > +{
> > +	struct btrfs_uring_priv *priv =
> > +		*io_uring_cmd_to_pdu(cmd, struct btrfs_uring_priv *);
> > +	struct btrfs_inode *inode = BTRFS_I(file_inode(priv->iocb.ki_filp));
> > +	struct extent_io_tree *io_tree = &inode->io_tree;
> > +	unsigned long i;
> > +	u64 cur;
> > +	size_t page_offset;
> > +	ssize_t ret;
> > +
> > +	if (priv->err) {
> > +		ret = priv->err;
> > +		goto out;
> > +	}
> > +
> > +	if (priv->compressed) {
> > +		i = 0;
> > +		page_offset = 0;
> > +	} else {
> > +		i = (priv->iocb.ki_pos - priv->start) >> PAGE_SHIFT;
> > +		page_offset = offset_in_page(priv->iocb.ki_pos - priv->start);
> > +	}
> > +	cur = 0;
> > +	while (cur < priv->count) {
> > +		size_t bytes = min_t(size_t, priv->count - cur,
> > +				     PAGE_SIZE - page_offset);
> > +
> > +		if (copy_page_to_iter(priv->pages[i], page_offset, bytes,
> > +				      &priv->iter) != bytes) {
> 
> If that's an iovec backed iter that might fail, you'd need to
> steal this patch
> 
> https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com/
> 
> and fail if "issue_flags & IO_URING_F_TASK_DEAD", see
> 
> https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-13-9739c753666e@ddn.com/
> 
> 
> > +			ret = -EFAULT;
> > +			goto out;
> > +		}
> > +
> > +		i++;
> > +		cur += bytes;
> > +		page_offset = 0;
> > +	}
> > +	ret = priv->count;
> > +
> > +out:
> > +	unlock_extent(io_tree, priv->start, priv->lockend, &priv->cached_state);
> > +	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> 
> When called via io_uring_cmd_complete_in_task() this function might
> not get run in any reasonable amount of time. Even worse, a
> misbehaving user can block it until the task dies.
> 
> I don't remember if rwsem allows unlock being executed in a different
> task than the pairing lock, but blocking it for that long could be a
> problem. I might not remember it right but I think Boris meantioned
> that the O_DIRECT path drops the inode lock right after submission
> without waiting for bios to complete. Is that right? Can we do it
> here as well?
> 
> > +
> > +	io_uring_cmd_done(cmd, ret, 0, issue_flags);
> > +	add_rchar(current, ret);
> > +
> > +	for (unsigned long index = 0; index < priv->nr_pages; index++)
> > +		__free_page(priv->pages[index]);
> > +
> > +	kfree(priv->pages);
> > +	kfree(priv->iov);
> > +	kfree(priv);
> > +}
> > +
> > +void btrfs_uring_read_extent_endio(void *ctx, int err)
> > +{
> > +	struct btrfs_uring_priv *priv = ctx;
> > +
> > +	priv->err = err;
> > +
> > +	*io_uring_cmd_to_pdu(priv->cmd, struct btrfs_uring_priv *) = priv;
> 
> a nit, I'd suggest to create a temp var, should be easier to
> read. It'd even be nicer if you wrap it into a structure
> as suggested last time.
> 
> struct io_btrfs_cmd {
> 	struct btrfs_uring_priv *priv;
> };
> 
> struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
> bc->priv = priv;
> 
> > +	io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished);
> > +}
> > +
> > +static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
> > +				   u64 start, u64 lockend,
> > +				   struct extent_state *cached_state,
> > +				   u64 disk_bytenr, u64 disk_io_size,
> > +				   size_t count, bool compressed,
> > +				   struct iovec *iov,
> > +				   struct io_uring_cmd *cmd)
> > +{
> > +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
> > +	struct extent_io_tree *io_tree = &inode->io_tree;
> > +	struct page **pages;
> > +	struct btrfs_uring_priv *priv = NULL;
> > +	unsigned long nr_pages;
> > +	int ret;
> > +
> > +	nr_pages = DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
> > +	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> > +	if (!pages)
> > +		return -ENOMEM;
> > +	ret = btrfs_alloc_page_array(nr_pages, pages, 0);
> > +	if (ret) {
> > +		ret = -ENOMEM;
> > +		goto fail;
> > +	}
> > +
> > +	priv = kmalloc(sizeof(*priv), GFP_NOFS);
> > +	if (!priv) {
> > +		ret = -ENOMEM;
> > +		goto fail;
> > +	}
> > +
> > +	priv->iocb = *iocb;
> > +	priv->iov = iov;
> > +	priv->iter = *iter;
> > +	priv->count = count;
> > +	priv->cmd = cmd;
> > +	priv->cached_state = cached_state;
> > +	priv->compressed = compressed;
> > +	priv->nr_pages = nr_pages;
> > +	priv->pages = pages;
> > +	priv->start = start;
> > +	priv->lockend = lockend;
> > +	priv->err = 0;
> > +
> > +	ret = btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
> > +						    disk_io_size, pages,
> > +						    priv);
> > +	if (ret && ret != -EIOCBQUEUED)
> > +		goto fail;
> 
> Turning both into return EIOCBQUEUED is a bit suspicious, but
> I lack context to say. Might make sense to return ret and let
> the caller handle it.
> 
> > +
> > +	/*
> > +	 * If we return -EIOCBQUEUED, we're deferring the cleanup to
> > +	 * btrfs_uring_read_finished, which will handle unlocking the extent
> > +	 * and inode and freeing the allocations.
> > +	 */
> > +
> > +	return -EIOCBQUEUED;
> > +
> > +fail:
> > +	unlock_extent(io_tree, start, lockend, &cached_state);
> > +	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> > +	kfree(priv);
> > +	return ret;
> > +}
> > +
> > +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> > +				    unsigned int issue_flags)
> > +{
> > +	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args,
> > +					     flags);
> > +	size_t copy_end;
> > +	struct btrfs_ioctl_encoded_io_args args = { 0 };
> > +	int ret;
> > +	u64 disk_bytenr, disk_io_size;
> > +	struct file *file = cmd->file;
> > +	struct btrfs_inode *inode = BTRFS_I(file->f_inode);
> > +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +	struct extent_io_tree *io_tree = &inode->io_tree;
> > +	struct iovec iovstack[UIO_FASTIOV];
> > +	struct iovec *iov = iovstack;
> > +	struct iov_iter iter;
> > +	loff_t pos;
> > +	struct kiocb kiocb;
> > +	struct extent_state *cached_state = NULL;
> > +	u64 start, lockend;
> > +	void __user *sqe_addr = u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));
> 
> Let's rename it, I was taken aback for a brief second why
> you're copy_from_user() from an SQE / the ring, which turns
> out to be a user pointer to a btrfs structure.
> 
> ...
> > +	ret = btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
> > +				 &disk_bytenr, &disk_io_size);
> > +	if (ret < 0 && ret != -EIOCBQUEUED)
> > +		goto out_free;
> > +
> > +	file_accessed(file);
> > +
> > +	if (copy_to_user(sqe_addr + copy_end, (char *)&args + copy_end_kernel,
> > +			 sizeof(args) - copy_end_kernel)) {
> > +		if (ret == -EIOCBQUEUED) {
> > +			unlock_extent(io_tree, start, lockend, &cached_state);
> > +			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> > +		}> +		ret = -EFAULT;
> > +		goto out_free;
> 
> It seems we're saving iov in the priv structure, who can access the iovec
> after the request is submitted? -EIOCBQUEUED in general means that the
> request is submitted and will get completed async, e.g. via callback, and
> if the bio callback can use the iov maybe via the iter, this goto will be
> a use after free.
> 
> Also, you're returning -EFAULT back to io_uring, which will kill the
> io_uring request / cmd while there might still be in flight bios that
> can try to access it.
> 
> Can you inject errors into the copy and test please?

Thanks for the comments. I get the impression that there are known
problems on the io_uring side, so until that is resolved the btrfs part
may be insecure or with known runtime bugs, but in the end it does not
need any change. We just need to wait until it's resoved on the
interface level.

The patches you point to are from FUSE trying to wire up io_uring so
this looks like an interface problem. We recently have gained a config
option level gurard for experimental and unstable features so we can add
the code but don't have to expose users to the functionality unless they
konw there are risks or known problems. The io_uring and encoded read
has a performance benefit and I'd like to get the patches in for 6.13
but if there's something serious, one option is not add the code or at
least guard it (behind a config option).

I'm open to both and we have at least one -rc kernel to decide.

