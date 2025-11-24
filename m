Return-Path: <io-uring+bounces-10756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AD56FC80484
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 12:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6AD504E43E2
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 11:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D0E2FFDD2;
	Mon, 24 Nov 2025 11:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nQd4dI8D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fz2/KMrd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nQd4dI8D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fz2/KMrd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FBA2FE598
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 11:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985286; cv=none; b=lXDB7qS9a3S0Ir5H3xDuf5a4aINPng1e9XlhLYsWfLexsA9ZC4YxR7YzQqWkvpAJxbtZWrJVXe0Z91g94Szob0hhUyFuauv06f1lvPEGplzHOgi7ULZaJixbPDrhAsqJSLcTfiBfPFrgeXhaxH8+JoLfSzWu1MmILhYlBONTc3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985286; c=relaxed/simple;
	bh=uzGTwPYyuxCNe79Z8UjEtXEhnzeUvMCL+qmCPxpzIyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itnG+4a/xIxCQR4IUpXqdlTH29hYhU4R/1FIAkp5TormOrxR14RzTFzm3O8msRTHB7wLORYIHtvbEhOxdrXFe8KsI6VPuWavOf4wjSPlHmp0nFNx4hG4Zd3iz3nA5Ux/PYrYrwOFIjJvmpthO+ALgJMjRfGL+Sleyp0tRyJOlZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nQd4dI8D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fz2/KMrd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nQd4dI8D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fz2/KMrd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04E29221FA;
	Mon, 24 Nov 2025 11:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763985282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXYEPN98/ffLRAchbjONXb8GdDC3sz8Urgjhuu0aKFE=;
	b=nQd4dI8DzJbdvL++gxBupED3DPdhib7fD06cyCs0h9+4MN1ilgsjN/1hHFOfgUsryiQOMn
	0oSQJt8E+C1Ui679UmjM0nZVYnfvcocnkRXAZpuQJPNngwiTZssrE8OjptnkjK4kZXiJ91
	6WyMUiGfX0Nl8X51sLHBz1930iLxkL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763985282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXYEPN98/ffLRAchbjONXb8GdDC3sz8Urgjhuu0aKFE=;
	b=Fz2/KMrdt2j6cWkJ87K4G33qKvWiMXMGPx1hWcvQ5xLnuC6o2129T7ADGgZM6sNvodCi2n
	RK+q/LJeMA4MkGAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763985282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXYEPN98/ffLRAchbjONXb8GdDC3sz8Urgjhuu0aKFE=;
	b=nQd4dI8DzJbdvL++gxBupED3DPdhib7fD06cyCs0h9+4MN1ilgsjN/1hHFOfgUsryiQOMn
	0oSQJt8E+C1Ui679UmjM0nZVYnfvcocnkRXAZpuQJPNngwiTZssrE8OjptnkjK4kZXiJ91
	6WyMUiGfX0Nl8X51sLHBz1930iLxkL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763985282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXYEPN98/ffLRAchbjONXb8GdDC3sz8Urgjhuu0aKFE=;
	b=Fz2/KMrdt2j6cWkJ87K4G33qKvWiMXMGPx1hWcvQ5xLnuC6o2129T7ADGgZM6sNvodCi2n
	RK+q/LJeMA4MkGAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E96113EA61;
	Mon, 24 Nov 2025 11:54:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +gv3OIFHJGk+eAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 11:54:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F186A0A04; Mon, 24 Nov 2025 12:54:33 +0100 (CET)
Date: Mon, 24 Nov 2025 12:54:33 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	io-uring@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 02/14] fs: lift the FMODE_NOCMTIME check into
 file_update_time_flags
Message-ID: <5wv5u2sto54yelpzkxtdoekhfix7tsh5v7cyjrbnbvdvqmlssz@zpomezchur2d>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-3-hch@lst.de>
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
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,lst.de:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Fri 14-11-25 07:26:05, Christoph Hellwig wrote:
> FMODE_NOCMTIME used to be just a hack for the legacy XFS handle-based
> "invisible I/O", but commit e5e9b24ab8fa ("nfsd: freeze c/mtime updates
> with outstanding WRITE_ATTRS delegation") started using it from
> generic callers.
> 
> I'm not sure other file systems are actually read for this in general,
						^^ ready

> so the above commit should get a closer look, but for it to make any
> sense, file_update_time needs to respect the flag.
> 
> Lift the check from file_modified_flags to file_update_time so that
> users of file_update_time inherit the behavior and so that all the
> checks are done in one place.
> 
> Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reagrdless whether FMODE_NOCMTIME works properly for all filesystems this
looks like a sensible step so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 4884ffa931e7..24dab63844db 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2320,6 +2320,8 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
>  	/* First try to exhaust all avenues to not sync */
>  	if (IS_NOCMTIME(inode))
>  		return 0;
> +	if (unlikely(file->f_mode & FMODE_NOCMTIME))
> +		return 0;
>  
>  	now = current_time(inode);
>  
> @@ -2391,8 +2393,6 @@ static int file_modified_flags(struct file *file, int flags)
>  	ret = file_remove_privs_flags(file, flags);
>  	if (ret)
>  		return ret;
> -	if (unlikely(file->f_mode & FMODE_NOCMTIME))
> -		return 0;
>  	return file_update_time_flags(file, flags);
>  }
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

