Return-Path: <io-uring+bounces-10762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11081C80B0C
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05EFC3A1667
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E742EB86C;
	Mon, 24 Nov 2025 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gPx+Dhom";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4haRJEW1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rqzBLbAr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lJHobCq9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD972F39DC
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763989913; cv=none; b=ILfMA7x3wu/eIZIxazsMrc2k7QtZ/xFk0SsS0exNr0tNrBYuKR2dl0eVQ48JFRtDMstmlDfcfjd1DrSulg3+ShqHddoP6vjrecO2xv3yfFxbhZuH8aN4Slt6JHsropYkhoG/TMqJVVdp8sx1YKOnLbLmGLD1IArZiqELiZQxqZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763989913; c=relaxed/simple;
	bh=1IMzQbr7PSADvtAu25row0+zbBJpg1mbKYEaPaO26jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blWdd6XRz5XRb8LKgukKjSs9yFFwl4T/e9USajYETakd3PQ4Vf7N1cML1ryxpY2P3woKZPQPdFD5ofIuU98QWkHEnL5S7MGuxDZ9cY3DlcxsdrlR2CZdGRFrQvSpKN5os+O7xJf2ivOTVXClBJNejEfghZR9vQHvhPG2JA/T7Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gPx+Dhom; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4haRJEW1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rqzBLbAr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lJHobCq9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E33CA222C7;
	Mon, 24 Nov 2025 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763989910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lsXEAdncHKC+iIvFZWpZzizDLjJ9+9d0rHHBMqqOXM=;
	b=gPx+Dhom9+iDOEc/TSup2qzPx7cy/l17rb6LruIyeTd4EIY2Vv/C/do3MBWfDB3vkliBJ2
	LgBcPf7CjxmVMX1Fyzwh9QaPcE/w2wokAT64byZ9JzAig//swPOThW868+3DED7he8oGoc
	TmUkaSY6ldyeoUQcdNZ25Tnji396yhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763989910;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lsXEAdncHKC+iIvFZWpZzizDLjJ9+9d0rHHBMqqOXM=;
	b=4haRJEW17Kyv8sAgkxnqEnDSrzjB5a9hf8+hPzzVfE+bwRZ3Z1mwlJRFavfwxm8xBy1Nxr
	MCHgeGRmtIpW1PAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rqzBLbAr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lJHobCq9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763989909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lsXEAdncHKC+iIvFZWpZzizDLjJ9+9d0rHHBMqqOXM=;
	b=rqzBLbArP5u6nTdRRT+u3I1rMQcFYJ+EWaoTTUBX/Js5toMb99Vf3jjP8WIqNOXzGmLocX
	nl87VW3mmCZQuSyaTG1zUMCQLTdGW2B9RcgHmbdtYlDVaroXXnxC48TSNLfVRU9JZ6jzU9
	qeNkETY3kbCN3SFJHBv0vMrAUOB8aX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763989909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lsXEAdncHKC+iIvFZWpZzizDLjJ9+9d0rHHBMqqOXM=;
	b=lJHobCq9ur5+oUO7lAdlCx/OuCP6bm35B5HwT0ctjaGHH3lCWUV/KHMv3M+kTyeCHJqoz+
	7Q0aU6eA5dZmAiDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8ACE3EA61;
	Mon, 24 Nov 2025 13:11:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A2fjNJVZJGk3RAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 13:11:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8B407A0A04; Mon, 24 Nov 2025 14:11:49 +0100 (CET)
Date: Mon, 24 Nov 2025 14:11:49 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	io-uring@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 08/14] fs: exit early in generic_update_time when there
 is no work
Message-ID: <znjzumoxtj77t5aaaogfzr6ypreal5djcjl4uf537i66ge6gss@si5pk32ogsx3>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-9-hch@lst.de>
X-Rspamd-Queue-Id: E33CA222C7
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Fri 14-11-25 07:26:11, Christoph Hellwig wrote:
> Exit early if not attributes are to be updated, to avoid a spurious call
		^^ no

> to __mark_inode_dirty which can turn into a fairly expensive no-op due to
> the extra checks and locking.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 74e672dd90aa..57c458ee548d 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2098,6 +2098,9 @@ int generic_update_time(struct inode *inode, int flags)
>  	int updated = inode_update_timestamps(inode, flags);
>  	int dirty_flags = 0;
>  
> +	if (!updated)
> +		return 0;
> +
>  	if (updated & (S_ATIME|S_MTIME|S_CTIME))
>  		dirty_flags = inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_DIRTY_SYNC;
>  	if (updated & S_VERSION)
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

