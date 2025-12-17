Return-Path: <io-uring+bounces-11151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81372CC7BA9
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 14:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C1AF3300E4F1
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 13:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9743502B9;
	Wed, 17 Dec 2025 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a56aVGMj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EM2At4C2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a56aVGMj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EM2At4C2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA52A350A19
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 12:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765975351; cv=none; b=YHPSCv2W63N0dUEOlmnPaSo1tw7m+yxlMyqIonUMFkCggOdVvMy0PMNWMfgBLoj3k7ajBRq+0F/XP/PBw1AXA5C4pzlt6Y7VQR5Nm/EuXLuLEsPvsitviRXbot92vCwnxOOAeWHuyke+zcrI8g0bv67+OGefoMGlU7RoN/KnfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765975351; c=relaxed/simple;
	bh=BgyZH9Lq6PUbACHJrPVyiXxQg8gNucfjWaGUktOVPvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CC0vIs2+SRu+rH1vhYVeDQWFK3rIXorS6hv9I2bYgF3VDJ+r0YOuBDILIW6IGDl3ldH/Qefa7IPWfZi300xP/N9rayPC0QoKFa+zoh0r6T0KOUmIKEO/gW1tW4rPYCQXM52wQDFXf/f/BpnJTMjnGtTA340Gahjd4gCE5II6dOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a56aVGMj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EM2At4C2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a56aVGMj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EM2At4C2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 186F85BCF8;
	Wed, 17 Dec 2025 12:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765975345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvZL3WPwwLagDUEBdiS3N24cxsJRy97UBGLmu0SgiWg=;
	b=a56aVGMj0kst528k5fM83MBSiUUP1ExJ6+hm7lKF4DuthbszXMhLRK/4prA/Xi3veetPsL
	1FxXQGEYI6xeyYruR72CLCodkv7S0DG7gCJocLY2hiU3g32mscOCAVLKTQfytgbtlvc/h3
	N3zyCJl7agpHI8TlOxMklJ9D7MzAOPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765975345;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvZL3WPwwLagDUEBdiS3N24cxsJRy97UBGLmu0SgiWg=;
	b=EM2At4C2BKWwLeD76Gc7lnI11b5w81+nDNLjgylvh8PQ29xLBA5OEhNJCJw0CzZQrz9PFD
	EowZTDQSfM684EDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a56aVGMj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EM2At4C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765975345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvZL3WPwwLagDUEBdiS3N24cxsJRy97UBGLmu0SgiWg=;
	b=a56aVGMj0kst528k5fM83MBSiUUP1ExJ6+hm7lKF4DuthbszXMhLRK/4prA/Xi3veetPsL
	1FxXQGEYI6xeyYruR72CLCodkv7S0DG7gCJocLY2hiU3g32mscOCAVLKTQfytgbtlvc/h3
	N3zyCJl7agpHI8TlOxMklJ9D7MzAOPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765975345;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvZL3WPwwLagDUEBdiS3N24cxsJRy97UBGLmu0SgiWg=;
	b=EM2At4C2BKWwLeD76Gc7lnI11b5w81+nDNLjgylvh8PQ29xLBA5OEhNJCJw0CzZQrz9PFD
	EowZTDQSfM684EDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E58B43EA63;
	Wed, 17 Dec 2025 12:42:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZTlhNzClQmnEJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 12:42:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3CC90A0927; Wed, 17 Dec 2025 13:42:20 +0100 (CET)
Date: Wed, 17 Dec 2025 13:42:20 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, io-uring@vger.kernel.org, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 08/10] fs: add support for non-blocking timestamp updates
Message-ID: <2hnq54zc4x2fpxkpuprnrutrwfp3yi5ojntu3e3xfcpeh6ztei@2fwwsemx4y5z>
References: <20251217061015.923954-1-hch@lst.de>
 <20251217061015.923954-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217061015.923954-9-hch@lst.de>
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 186F85BCF8
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,lst.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Wed 17-12-25 07:09:41, Christoph Hellwig wrote:
> Currently file_update_time_flags unconditionally returns -EAGAIN if any
> timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
> non-blocking direct writes impossible on file systems with granular
> enough timestamps.
> 
> Add a S_NOWAIT to ask for timestamps to not block, and return -EAGAIN in
> all methods for now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

...

> @@ -2110,12 +2110,26 @@ int inode_update_timestamps(struct inode *inode, int *flags)
>  		now = inode_set_ctime_current(inode);
>  		if (!timespec64_equal(&now, &ctime))
>  			updated |= S_CTIME;
> -		if (!timespec64_equal(&now, &mtime)) {
> -			inode_set_mtime_to_ts(inode, now);
> +		if (!timespec64_equal(&now, &mtime))
>  			updated |= S_MTIME;
> +
> +		if (IS_I_VERSION(inode)) {
> +			if (*flags & S_NOWAIT) {
> +				/*
> +				 * Error out if we'd need timestamp updates, as
> +				 * the generally requires blocking to dirty the
> +				 * inode in one form or another.
> +				 */
> +				if (updated && inode_iversion_need_inc(inode))
> +					goto bail;

I'm confused here. What the code does is that if S_NOWAIT is set and
i_version needs increment we bail. However the comment as well as the
changelog speaks about timestamps needing update and not about i_version.
And intuitively I agree that if any timestamp is updated, inode needs
dirtying and thus we should bail regardless of whether i_version is updated
as well or not. What am I missing?

								Honza

> +			} else {
> +				if (inode_maybe_inc_iversion(inode, updated))
> +					updated |= S_VERSION;
> +			}
>  		}
> -		if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, updated))
> -			updated |= S_VERSION;
> +
> +		if (updated & S_MTIME)
> +			inode_set_mtime_to_ts(inode, now);
>  	} else {
>  		now = current_time(inode);
>  	}
> @@ -2131,6 +2145,9 @@ int inode_update_timestamps(struct inode *inode, int *flags)
>  
>  	*flags = updated;
>  	return 0;
> +bail:
> +	*flags = 0;
> +	return -EAGAIN;
>  }
>  EXPORT_SYMBOL(inode_update_timestamps);
>  
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

