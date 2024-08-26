Return-Path: <io-uring+bounces-2952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21AD095F4E3
	for <lists+io-uring@lfdr.de>; Mon, 26 Aug 2024 17:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F8271C213D9
	for <lists+io-uring@lfdr.de>; Mon, 26 Aug 2024 15:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97939158DD9;
	Mon, 26 Aug 2024 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vdHiV4t8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KOJRZLQR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="07xMN3os";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KA/yihGE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0D11E521;
	Mon, 26 Aug 2024 15:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724685730; cv=none; b=O8FDpPZ605J6NNi9EZfS3d3O/BlrCKSi5RSd2acMbnCT/1NZdsdpZtDdxfwYXaNHm0rIfq4z3krqOtFhxUbxppFLwLtJDf/p/o8bqGs2cHP4pN/SH0G11JE3ZaWwiyxyieoIQQRTdS+38MCwZlXPAaZo70XILAs9LbpzhOpvS0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724685730; c=relaxed/simple;
	bh=Ha8rgp3ScmzbWdOfI65XueQTm090aHq4omUQKdIyHJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1jVtnLBqqEeapAF5Qomf/mMhrXOieOJLI4apKbbKnG+7M4akmX5p5lHavE8PIYltv1MZTI50NbTpz/sriIpl5FeA1zJpwETxTXvkn8PMRdfXVWhwTgC699qzmA32G5neWlqWXjyNH8XVJv/iz+KZEy479vubz0vatbltS/gamY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vdHiV4t8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KOJRZLQR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=07xMN3os; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KA/yihGE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E016F21ABE;
	Mon, 26 Aug 2024 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724685727;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pm/piezsxxed8lMj25yPAbHQz1vX77rXtcgIrDLedTg=;
	b=vdHiV4t8RFVHG8bbkmI67sIl0BBVhnqI6/0W7gHaw0MAmq2i7UDHeCXxLblC6YEDgqQQx8
	UXgv9YsJFDvxngRp4MA45LFWu3lLKRgVP4Tb7gUZQunME1LOqVD2B1g4Jf/v3TWbfbK6o3
	QmCJeI350CC7rKrLhHuY9cwf0LCflxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724685727;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pm/piezsxxed8lMj25yPAbHQz1vX77rXtcgIrDLedTg=;
	b=KOJRZLQRLgl8THz4Iw/iEhT4x8FiMDU6rVDAEaMiIOEeEErsuGbsL/tY5iGnT87NTQHQYd
	PR9zxA+i/ZHiKzCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724685726;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pm/piezsxxed8lMj25yPAbHQz1vX77rXtcgIrDLedTg=;
	b=07xMN3osyrlmHT/5c3vFmowgLtVXJAwEpu2MPBdOnr9gdPtT7Pm4LgjcFqmD7ET/6DxT0C
	EIHojhAxFS4BpYmKBefvBIhqj8uH+wEfn1TWB+2OBQh4afQWyweSx9igKT35uTtk18HjiV
	QTjAfB0Z5xKKTmVuM41/ws1R5a5IPAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724685726;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pm/piezsxxed8lMj25yPAbHQz1vX77rXtcgIrDLedTg=;
	b=KA/yihGEjEKUjjyQC04NCq+kYvDjgYd/LQG3o+hMe861KuJzrJMQPfU5ZIPJ0ujKd+AtoQ
	F6IT6xY6U66jZeDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDE281398D;
	Mon, 26 Aug 2024 15:22:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TFwHMp6dzGZJaQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 26 Aug 2024 15:22:06 +0000
Date: Mon, 26 Aug 2024 17:22:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] btrfs: store encoded read state in struct
 btrfs_encoded_read_private
Message-ID: <20240826152205.GQ25962@twin.jikos.cz>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto]
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, Aug 23, 2024 at 05:27:44PM +0100, Mark Harmstone wrote:
> Move the various stack variables needed for encoded reads into struct
> btrfs_encoded_read_private, so that we can split it into several
> functions.
> 
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
> +	size_t count;
> +	struct iovec iovstack[UIO_FASTIOV];
> +	struct iovec *iov;
> +	struct iov_iter iter;
> +	struct btrfs_ioctl_encoded_io_args args;
> +	struct file *file;
> +};
> +
> +ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv);
>  ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>  			       const struct btrfs_ioctl_encoded_io_args *encoded);
>  
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a0cc029d95ed..c1292e58366a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9078,12 +9078,6 @@ static ssize_t btrfs_encoded_read_inline(
>  	return ret;
>  }
>  
> -struct btrfs_encoded_read_private {
> -	wait_queue_head_t wait;
> -	atomic_t pending;
> -	blk_status_t status;
> -};
> -
>  static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
>  {
>  	struct btrfs_encoded_read_private *priv = bbio->private;
> @@ -9104,33 +9098,31 @@ static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
>  	bio_put(&bbio->bio);
>  }
>  
> -int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
> -					  u64 file_offset, u64 disk_bytenr,
> -					  u64 disk_io_size, struct page **pages)
> +static void _btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,

Please don't use underscores in function names

https://btrfs.readthedocs.io/en/latest/dev/Development-notes.html#function-declarations

