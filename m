Return-Path: <io-uring+bounces-10760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C2BC80AE8
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 834643AA505
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E910C303CAC;
	Mon, 24 Nov 2025 13:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fbhNrGX8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nVxXFIXT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XgH/QFAa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2d8GVMTF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B4E2F39D1
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763989756; cv=none; b=OYC0L4UoVsjSijKYXgg6l36iSKBTtjdxUXvgllUFcPeJ3o+6PlFzfp7vLpuIuYLcm+qMLLNRFp8kgkvJ8KTt15NZBmue0ufRkMBiCS5KlD/lUSW6pEFGPTcoCB+frszZZcUNN2Z4706zsxUKZZaL7e7zbF5eR3FFViGHj5Vf5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763989756; c=relaxed/simple;
	bh=IxnUN6j1JIjilWBB58IoabhG6ksJcQEsPLiJiqLwHNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yj8u/pSYnHcF4myJFtEwIaJ7CUj8BPwoX0bE3r6gzLNT1TAGAep7VmGy2zq/L/dHAYloWl7oTnww1RJoDFAIRE7N2Zq1qg1kknpOYZ0iIbfKUEaYiJPaxdLGtZlQLJzYTZlTQone0WRrK9o1H4wfBW8EgJQsOC/K0BpjFcuvyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fbhNrGX8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nVxXFIXT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XgH/QFAa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2d8GVMTF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CCD9E5BEC6;
	Mon, 24 Nov 2025 13:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763989753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VB0YWuicgvPXomxR6M3TVXBKU7YurqUsSFo/jqmDaMc=;
	b=fbhNrGX8iw/PHX6sS3H2xeeJMdajfdjijZLWe++SFm07Hi4duhNv0HZ595X3L8bR6WXkfH
	9U2irAC1bj2tDXyEIersW84iRp+iNybn6lWkU2CeuVf+GTqaO5NpCGaMtzDjPok/+4UiTF
	yHgp0XXCadbh2mEjrZB/8X922UZiKu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763989753;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VB0YWuicgvPXomxR6M3TVXBKU7YurqUsSFo/jqmDaMc=;
	b=nVxXFIXT/hWIoCrRL67P4yeF3FV240AIGWiH/yaN4JA33x/la/yoQS0VZV8HQhbcMXv7K2
	uiqISbLaoFMHycBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XgH/QFAa";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2d8GVMTF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763989752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VB0YWuicgvPXomxR6M3TVXBKU7YurqUsSFo/jqmDaMc=;
	b=XgH/QFAaCf3U8ALq4ZpE8y1ovZzgIRoiXeN2u7xxh8m4dyyI1kNbGX4/H9LdxHdtzgsRKo
	SPpcChg16jsLf1gE0UNGhvAqPO11Uqy78vqy/1K2oI2SGpTSInFvHgHg0vdbseDk5CT7V2
	MqYxJ12BKJ7+EwnwoHbt+K1xQ6dqQ9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763989752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VB0YWuicgvPXomxR6M3TVXBKU7YurqUsSFo/jqmDaMc=;
	b=2d8GVMTFLI1AnHz8T/C8QD1pWEemj67sPdQQdlaCPIO8OwPG4dlm/UKkmaQrYisooKfUGv
	04B4Or7QA9fCzdBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C143C3EA61;
	Mon, 24 Nov 2025 13:09:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gPkuL/hYJGlVQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 13:09:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 694B9A0A04; Mon, 24 Nov 2025 14:09:12 +0100 (CET)
Date: Mon, 24 Nov 2025 14:09:12 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	io-uring@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 06/14] organgefs: use inode_update_timestamps directly
Message-ID: <sdgytii6x2ccqsxkocafhojt6h75n3e4kjdofasgo53mcgfc53@um6nkgxw2wt2>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-7-hch@lst.de>
X-Rspamd-Queue-Id: CCD9E5BEC6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Fri 14-11-25 07:26:09, Christoph Hellwig wrote:
> Orangefs has no i_version handling and __orangefs_setattr already
> explicitly marks the inode dirty.  So instead of the using
> the flags return value from generic_update_time, just call the
> lower level inode_update_timestamps helper directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Besides the typo the change looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/orangefs/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index a01400cd41fd..55f6c8026812 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -878,7 +878,9 @@ int orangefs_update_time(struct inode *inode, int flags)
>  
>  	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
>  	    get_khandle_from_ino(inode));
> -	flags = generic_update_time(inode, flags);
> +
> +	flags = inode_update_timestamps(inode, flags);
> +
>  	memset(&iattr, 0, sizeof iattr);
>          if (flags & S_ATIME)
>  		iattr.ia_valid |= ATTR_ATIME;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

