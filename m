Return-Path: <io-uring+bounces-3871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 342F09A723A
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 20:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B78451F26276
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C08F1DACA1;
	Mon, 21 Oct 2024 18:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RlatGtgO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MamAPHjh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RlatGtgO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MamAPHjh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981EC193409;
	Mon, 21 Oct 2024 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729535010; cv=none; b=OOPlxQGcDJc7PInsCnr5pHN7oBJvngP7hTM2+1jvWoqY7Qz3+qyMHRL59WgoMbEwPRmLWQYFM6jDUUKlAe3HGYuzwJyZcRMppZopAyxpnEwwtJDTKHlOpyqOPL1TQ/Z+4HTs3mkBS1jyA+RoLtLApIE/20Yr0kudSVDaXm4eOcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729535010; c=relaxed/simple;
	bh=VNUzRSbXDhZLV3Nj2QX1hw833SMLqsoKV4EiYmnqE1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJ6Fi9iqOR06fCD5udVpIl8jUj9DfS1FlvpX5Juz3H2Ltx+T8wIbyUMi76BNeib9anrUzcCGiWDknWvWzswai7KnBv0t+0ErGeEW6Pnn3K/mjLZfZS9QAkIMn7qRzrDmxK9wT9e09QT1tWBEB/RhQRM6So3KWV8Hos/TXlkm4eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RlatGtgO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MamAPHjh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RlatGtgO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MamAPHjh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB9A01F460;
	Mon, 21 Oct 2024 18:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729535005;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YEYgKOz5Gx8656Ir9rc63mprmMrVN+JVSRt7f/8F30o=;
	b=RlatGtgOoSD/jjKFckgqPufk+jY5kWfNms3LIdJ9t6wFK/yW1SWqy8MJ7WxKbP2eHYfYlu
	AgMsi37e7mJ6m+pY1Ed2W0q+P4apJ2uvd59yYYsK8H6askJkXSOWlXySyC5TEMmPtqkAzv
	Y1mcQzWHnuX3VA4aKvta9kd++VUF6Fg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729535005;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YEYgKOz5Gx8656Ir9rc63mprmMrVN+JVSRt7f/8F30o=;
	b=MamAPHjhj+VofW8NUGOfmkonmztzUKiRmhB+WjxHveIax8gNcPROBVZkDvJKKx/Mfw7LH6
	p6ElW5M14+p4nwCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729535005;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YEYgKOz5Gx8656Ir9rc63mprmMrVN+JVSRt7f/8F30o=;
	b=RlatGtgOoSD/jjKFckgqPufk+jY5kWfNms3LIdJ9t6wFK/yW1SWqy8MJ7WxKbP2eHYfYlu
	AgMsi37e7mJ6m+pY1Ed2W0q+P4apJ2uvd59yYYsK8H6askJkXSOWlXySyC5TEMmPtqkAzv
	Y1mcQzWHnuX3VA4aKvta9kd++VUF6Fg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729535005;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YEYgKOz5Gx8656Ir9rc63mprmMrVN+JVSRt7f/8F30o=;
	b=MamAPHjhj+VofW8NUGOfmkonmztzUKiRmhB+WjxHveIax8gNcPROBVZkDvJKKx/Mfw7LH6
	p6ElW5M14+p4nwCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4E08139E0;
	Mon, 21 Oct 2024 18:23:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ffuOKx2cFmcgIAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Oct 2024 18:23:25 +0000
Date: Mon, 21 Oct 2024 20:23:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@meta.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Message-ID: <20241021182324.GA24631@suse.cz>
Reply-To: dsterba@suse.cz
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-6-maharmstone@fb.com>
 <20241021135005.GC17835@twin.jikos.cz>
 <f4f64bfe-c92b-4656-adec-d073b6286451@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4f64bfe-c92b-4656-adec-d073b6286451@meta.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, Oct 21, 2024 at 05:05:20PM +0000, Mark Harmstone wrote:
> >> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> >> +				    unsigned int issue_flags)
> >> +{
> >> +	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args,
> >> +					     flags);
> >> +	size_t copy_end;
> >> +	struct btrfs_ioctl_encoded_io_args args = {0};
> >                                                  = { 0 }
> >> +	int ret;
> >> +	u64 disk_bytenr, disk_io_size;
> >> +	struct file *file = cmd->file;
> >> +	struct btrfs_inode *inode = BTRFS_I(file->f_inode);
> >> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> >> +	struct extent_io_tree *io_tree = &inode->io_tree;
> >> +	struct iovec iovstack[UIO_FASTIOV];
> >> +	struct iovec *iov = iovstack;
> >> +	struct iov_iter iter;
> >> +	loff_t pos;
> >> +	struct kiocb kiocb;
> >> +	struct extent_state *cached_state = NULL;
> >> +	u64 start, lockend;
> > 
> > The stack consumption looks quite high.
> 
> 696 bytes, compared to 672 in btrfs_ioctl_encoded_read. 
> btrfs_ioctl_encoded write is pretty big too. Probably the easiest thing 
> here would be to allocate btrfs_uring_priv early and pass that around, I 
> think.
> 
> Do you have a recommendation for what the maximum stack size of a 
> function should be?

It depends from where the function is called. For ioctl callbacks, like
btrfs_ioctl_encoded_read it's the first function using kernel stack
leaving enough for any deep IO stacks (DM/NFS/iSCSI/...). If something
similar applies to the io_uring callbacks then it's probably fine.

Using a separate off-stack structure works but it's a penalty as it
needs the allcation. The io_uring is meant for high performance so if
the on-stack allocation is safe then keep it like that.

I've checked on a release config the stack consumption and the encoded
ioctl functions are not the worst:

tree-log.c:btrfs_sync_log                       728 static
scrub.c:scrub_verify_one_metadata               552 dynamic,bounded
inode.c:print_data_reloc_error                  544 dynamic,bounded
uuid-tree.c:btrfs_uuid_scan_kthread             520 static
tree-checker.c:check_root_item                  504 static
file-item.c:btrfs_csum_one_bio                  496 static
inode.c:btrfs_start_delalloc_roots              488 static
scrub.c:scrub_raid56_parity_stripe              464 dynamic,bounded
disk-io.c:write_dev_supers                      464 static
ioctl.c:btrfs_ioctl_encoded_write               456 dynamic,bounded
ioctl.c:btrfs_ioctl_encoded_read                456 dynamic,bounded

