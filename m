Return-Path: <io-uring+bounces-1391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6718983D3
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 11:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59DAF28883A
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 09:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAF5745D6;
	Thu,  4 Apr 2024 09:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dZK3ZZRu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xtS7kPy3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024C2745DC;
	Thu,  4 Apr 2024 09:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712221943; cv=none; b=M+cA67SwrR+5VHMvqQcA2wGfztLMsO8/apuAVpKgB6MsT8CQepodMdwXUJotzcsrGjJzqQJtaKqgf9IJcsfbjXijYPTwRwURk9hnf6D7uswhkHQ7AtZ2vgfpVW6lCgsTCOLgZlQv7ZBYrcBRaDJb7y3bbqicSRWbi40fIOYOveQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712221943; c=relaxed/simple;
	bh=wV+wep/PyFiCmFVihUQrj6YPkK8sgvSCmFa8mlUU5uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5aYZDdpSSpA4IBPiFDZ5BMJ1iUt4fDuBBCw99iTaOEXeKJzYpe4bKn7EANXdwCrCr32Fo6EyIyuOG2vq/JjbmHn4+hM5mzxmu8tU+YkLN4GD0K5GEqNH2/k5KKi8aYSZr3CPp0Ksm+yLKwnQEuRkdw3lxoWnowm85BNr1GRL2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dZK3ZZRu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xtS7kPy3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0F753379D7;
	Thu,  4 Apr 2024 09:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712221940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XEI/UA9qRwZAHfwA8fIVNsXvi2sGl1uyVdknjBcM3s=;
	b=dZK3ZZRu9HbcuH4Qvbe6Ivaosw6Q8hq2K8gstee7mF6iCGKvHx67q7+bPxqem/5nbXjbhb
	/e8hsK/0Jbuy4T89pOEseA6j25/pVGImwEgkOdrYy3dtFS/Y4AFpH+ndOBsdLGG55nQKnq
	QQIHPEJWJdIZaeKHZu9X49zzuLG3i5c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712221940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XEI/UA9qRwZAHfwA8fIVNsXvi2sGl1uyVdknjBcM3s=;
	b=xtS7kPy3RV0XD4sSKQzjEwn5xVgJOiP+a8mBl2h0nS1suiEZd57haJSEKXZFc7EL6y007T
	p3NQ/RVuEp5OAACQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id E6DA0139E8;
	Thu,  4 Apr 2024 09:12:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id IVcNOPNuDmbxHgAAn2gu4w
	(envelope-from <jack@suse.cz>); Thu, 04 Apr 2024 09:12:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93D7AA0816; Thu,  4 Apr 2024 11:12:15 +0200 (CEST)
Date: Thu, 4 Apr 2024 11:12:15 +0200
From: Jan Kara <jack@suse.cz>
To: Mark Brown <broonie@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240404091215.kpphfowf5ktmouu7@quack3>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
 <9bb5e9ad-d788-441e-96f3-489a031bb387@sirena.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bb5e9ad-d788-441e-96f3-489a031bb387@sirena.org.uk>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.55 / 50.00];
	BAYES_HAM(-0.75)[84.08%];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.971];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_DKIM_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap2.dmz-prg2.suse.org:rdns,imap2.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -0.55
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 0F753379D7

On Wed 03-04-24 22:12:45, Mark Brown wrote:
> On Thu, Mar 28, 2024 at 01:27:24PM +0100, Christian Brauner wrote:
> > There's a bunch of flags that are purely based on what the file
> > operations support while also never being conditionally set or unset.
> > IOW, they're not subject to change for individual files. Imho, such
> > flags don't need to live in f_mode they might as well live in the fops
> > structs itself. And the fops struct already has that lonely
> > mmap_supported_flags member. We might as well turn that into a generic
> > fop_flags member and move a few flags from FMODE_* space into FOP_*
> > space. That gets us four FMODE_* bits back and the ability for new
> > static flags that are about file ops to not have to live in FMODE_*
> > space but in their own FOP_* space. It's not the most beautiful thing
> > ever but it gets the job done. Yes, there'll be an additional pointer
> > chase but hopefully that won't matter for these flags.
> 
> For the past couple of days several LTP tests (open_by_handle_at0[12]
> and name_to_handle_at01) have been failing on all the arm64 platforms
> we're running these tests on.  I ran a bisect which came back to this

Do you have some LTP logs / kernel logs available for the failing runs?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

