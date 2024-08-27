Return-Path: <io-uring+bounces-2953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8CF95FE20
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 03:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDF371C218AB
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 01:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DD92107;
	Tue, 27 Aug 2024 01:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dKYC3BXr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vo/JpDsK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HDRnYXa8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MI5HetbI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8199110E9;
	Tue, 27 Aug 2024 01:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724720611; cv=none; b=MetSdoyvzdc5V4SfZGmXIyGQMEq8jBbLWIpH8G09xFdMQ01I7PAdkvMBGWWRkNs3LJd50XX33GM7BK3uutdOpbSuRbRmhRm7DqIRXCWb/js42YQVcdgI9wQyJgsmok6+ZQwTxB/VGuPI85pSnuomvnvxrjs/FpiOHyZhiqXhW1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724720611; c=relaxed/simple;
	bh=6dP/OAaiEq68919mEEvx1yVKBe3QKwZeVyUYLvwv4Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cza1/XSEcf4RNulkz1oSV2hgc9D4p9heqMTPnnhXU81zufQgKVjmono68fJIbKmTa8WZ0ruShfQ6uga4uSJ5RFj5VBQy8jb7beb93CpdYDnl7exNztTZa6nZEdfM7evNNeqWTAinin1NJ5nVCDiXsIvAPNjnswbFN/45UssnDP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dKYC3BXr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vo/JpDsK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HDRnYXa8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MI5HetbI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7AE5C21AE8;
	Tue, 27 Aug 2024 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724720607;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ShFHYUxU8uP4XznSRLaBsSExVDA49/Z3Xdlwzp9ozs=;
	b=dKYC3BXrDqEmWlFx/kGEBOXQLDuf/DuSRa8Hcd2kIaFtHK208/ZzJ4u435HSNI4uhIbExN
	NVnj79wdlqZm16H9DYdk/74N0iYtDl/yO2Km2MOxJ71892ziOzV5si8BOigK+Xuc9IY9og
	P31GlS5NoZYNAI6s6DYl8vKQPwzsMJ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724720607;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ShFHYUxU8uP4XznSRLaBsSExVDA49/Z3Xdlwzp9ozs=;
	b=Vo/JpDsKyeV/5gZwWyDrGCjD2U3TTdBlqYjex9jbhcfahyybzHN8IbgsELKiu9WC/jPVDH
	i+jRF0dSRjxq9YAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724720606;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ShFHYUxU8uP4XznSRLaBsSExVDA49/Z3Xdlwzp9ozs=;
	b=HDRnYXa89AKPRdjsQIdh2jcV2+Urk4NMVUGILHRadVt3XuXiMyq7cpmzgKF/lIZByGskDn
	nNtq13PkFmjbjN0eCTvNME4Bu+WDyVvh9OcphyJgOH36fsWE4JDbQu5Wf7WEzEJncMnG5L
	xUj81WaUfAYjHsNPZq9iOGchd9LYtvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724720606;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ShFHYUxU8uP4XznSRLaBsSExVDA49/Z3Xdlwzp9ozs=;
	b=MI5HetbIlT0sLLZmDn15dFDDpIg7O7lezy3BfHWsQ0GqFjZe6WCSuAe0WN17cB+i43F2fX
	8QwR6Z9vBanEzcDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 534E513724;
	Tue, 27 Aug 2024 01:03:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dj/OE94lzWaeEwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 27 Aug 2024 01:03:26 +0000
Date: Tue, 27 Aug 2024 03:03:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] btrfs: store encoded read state in struct
 btrfs_encoded_read_private
Message-ID: <20240827010325.GW25962@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20240823162810.1668399-1-maharmstone@fb.com>
 <20240823162810.1668399-3-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823162810.1668399-3-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,fb.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, Aug 23, 2024 at 05:27:44PM +0100, Mark Harmstone wrote:
> Move the various stack variables needed for encoded reads into struct
> btrfs_encoded_read_private, so that we can split it into several
> functions.

Moving local variables makes sense in some cases but I don't see reason
to move all of them.

> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>  fs/btrfs/btrfs_inode.h |  20 ++++-
>  fs/btrfs/inode.c       | 170 +++++++++++++++++++++--------------------
>  fs/btrfs/ioctl.c       |  60 ++++++++-------
>  3 files changed, 135 insertions(+), 115 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index affe70929234..5cd4308bd337 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -605,9 +605,23 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
>  					  u64 file_offset, u64 disk_bytenr,
>  					  u64 disk_io_size,
>  					  struct page **pages);
> -ssize_t btrfs_encoded_read(struct file *file, loff_t offset,
> -			   struct iov_iter *iter,
> -			   struct btrfs_ioctl_encoded_io_args *encoded);
> +
> +struct btrfs_encoded_read_private {
> +	wait_queue_head_t wait;
> +	atomic_t pending;
> +	blk_status_t status;
> +	unsigned long nr_pages;
> +	struct page **pages;
> +	struct extent_state *cached_state;

The cached state is used as a local variable that is not reused by other
functions that also take the private structure, so what's the reason to
store it here?

> +	size_t count;
> +	struct iovec iovstack[UIO_FASTIOV];
> +	struct iovec *iov;

Same, this is used in the leaf functions and not passed around.

> +	struct iov_iter iter;
> +	struct btrfs_ioctl_encoded_io_args args;
> +	struct file *file;
> +};

As a coding pattern, the structure should store data that would be
otherwise passed as parameters or repeatedly derived from the
parameters.

