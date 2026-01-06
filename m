Return-Path: <io-uring+bounces-11415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 65296CF8097
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 12:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 309E530109B2
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 11:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B34E22FDFF;
	Tue,  6 Jan 2026 11:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fozyANza";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qJzI0cfA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fozyANza";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qJzI0cfA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EA8203710
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767698729; cv=none; b=ru7EvSLF8omS8a/SZJAeECqiXbYM3/qVSy66BNiw+FRR0W0CWWRQtxO8+FVPj38AVoP7yniPUUSF9cyllwJPCIwiCEwml87JuKFLhjouR6c/w33yGQOfW6XIaL/oS+ZlyIi/Vo3TmjR9iqk3gNMGuxaQROe0UFrVpXBEZWZY1FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767698729; c=relaxed/simple;
	bh=EuBji/bYw0nx5yfRHVxsqg7c+z4FqEizLt2VqepQT+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQ9m01KozYqNr+FRhZUDb7uxfyemfvAKU+hO1SM6YfgLjzRQ4vf0TTzrEc7BUSgL007UETO3z5ta1CadZUkQZAnj3VCIUo/+7s3G4+jS3BGU7J4oluQXgjfUpAWgZL/ceHNnwXOhCWEX/25PML3p0idV3G5FV0X18qJX01nZ534=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fozyANza; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qJzI0cfA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fozyANza; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qJzI0cfA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1B37339E3;
	Tue,  6 Jan 2026 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767698725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xoqXUEQw/gQR60sCiYmykJAdx2Xen1POCWIrlnDZAIU=;
	b=fozyANzamKrH9z26sjY+XY02xX6to9o9MnqnwMGY3gpMULSzrHujo9FJlK0g5RBRoKFlNw
	C/SvQqwis+2NZ5GGBP6Ydu/N1sBy4J/d5QHzvos/FlZ5mIP4xAQ7VCD1V9CTxUB+feKXz7
	eaMyXYobIUrohY+zRT5LrpDNDVSQ8n4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767698725;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xoqXUEQw/gQR60sCiYmykJAdx2Xen1POCWIrlnDZAIU=;
	b=qJzI0cfAz/dmdD1tZAK6iWv9YlNzzc+RX7xqMf8ummvmrPSiG8Qx6sJrYuMhgAR4fRfPUS
	438iJDJQxKqnQ6DQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767698725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xoqXUEQw/gQR60sCiYmykJAdx2Xen1POCWIrlnDZAIU=;
	b=fozyANzamKrH9z26sjY+XY02xX6to9o9MnqnwMGY3gpMULSzrHujo9FJlK0g5RBRoKFlNw
	C/SvQqwis+2NZ5GGBP6Ydu/N1sBy4J/d5QHzvos/FlZ5mIP4xAQ7VCD1V9CTxUB+feKXz7
	eaMyXYobIUrohY+zRT5LrpDNDVSQ8n4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767698725;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xoqXUEQw/gQR60sCiYmykJAdx2Xen1POCWIrlnDZAIU=;
	b=qJzI0cfAz/dmdD1tZAK6iWv9YlNzzc+RX7xqMf8ummvmrPSiG8Qx6sJrYuMhgAR4fRfPUS
	438iJDJQxKqnQ6DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B536C3EA63;
	Tue,  6 Jan 2026 11:25:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M7g5LCXxXGkSUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 06 Jan 2026 11:25:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 75210A08E3; Tue,  6 Jan 2026 12:25:25 +0100 (CET)
Date: Tue, 6 Jan 2026 12:25:25 +0100
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
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 03/11] nfs: split nfs_update_timestamps
Message-ID: <wct2d2jrwausxgwusbnepzuegelkcl3s2veaixgrzehl6qcjyp@affaed5rinqo>
References: <20260106075008.1610195-1-hch@lst.de>
 <20260106075008.1610195-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106075008.1610195-4-hch@lst.de>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.984];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Tue 06-01-26 08:49:57, Christoph Hellwig wrote:
> The VFS paths update either the atime or ctime and mtime but never mix
> between atime and the others.  Split nfs_update_timestamps to match this
> to prepare for cleaning up the VFS interfaces.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/nfs/inode.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 84049f3cd340..3be8ba7b98c5 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -669,35 +669,31 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
>  	NFS_I(inode)->cache_validity &= ~cache_flags;
>  }
>  
> -static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
> +static void nfs_update_atime(struct inode *inode)
>  {
> -	enum file_time_flags time_flags = 0;
> -	unsigned int cache_flags = 0;
> +	inode_update_timestamps(inode, S_ATIME);
> +	NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_ATIME;
> +}
>  
> -	if (ia_valid & ATTR_MTIME) {
> -		time_flags |= S_MTIME | S_CTIME;
> -		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
> -	}
> -	if (ia_valid & ATTR_ATIME) {
> -		time_flags |= S_ATIME;
> -		cache_flags |= NFS_INO_INVALID_ATIME;
> -	}
> -	inode_update_timestamps(inode, time_flags);
> -	NFS_I(inode)->cache_validity &= ~cache_flags;
> +static void nfs_update_mtime(struct inode *inode)
> +{
> +	inode_update_timestamps(inode, S_MTIME | S_CTIME);
> +	NFS_I(inode)->cache_validity &=
> +		~(NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME);
>  }
>  
>  void nfs_update_delegated_atime(struct inode *inode)
>  {
>  	spin_lock(&inode->i_lock);
>  	if (nfs_have_delegated_atime(inode))
> -		nfs_update_timestamps(inode, ATTR_ATIME);
> +		nfs_update_atime(inode);
>  	spin_unlock(&inode->i_lock);
>  }
>  
>  void nfs_update_delegated_mtime_locked(struct inode *inode)
>  {
>  	if (nfs_have_delegated_mtime(inode))
> -		nfs_update_timestamps(inode, ATTR_MTIME);
> +		nfs_update_mtime(inode);
>  }
>  
>  void nfs_update_delegated_mtime(struct inode *inode)
> @@ -747,7 +743,10 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  						ATTR_ATIME|ATTR_ATIME_SET);
>  			}
>  		} else {
> -			nfs_update_timestamps(inode, attr->ia_valid);
> +			if (attr->ia_valid & ATTR_MTIME)
> +				nfs_update_mtime(inode);
> +			if (attr->ia_valid & ATTR_ATIME)
> +				nfs_update_atime(inode);
>  			attr->ia_valid &= ~(ATTR_MTIME|ATTR_ATIME);
>  		}
>  		spin_unlock(&inode->i_lock);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

