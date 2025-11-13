Return-Path: <io-uring+bounces-10589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CDFBDC5745C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2952F4E34AE
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD09E34CFCE;
	Thu, 13 Nov 2025 11:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="blPw1ePC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WLnx8sje";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="blPw1ePC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WLnx8sje"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391134AAE0
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 11:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763034749; cv=none; b=BA58tBmUh4B22xq5n5Kg0TtJ80STWbRJhrxxzL19X2wUFhPJLpRM54MlyDdtWahASTpSJlHSiXbVHBt7N5cxe2VBMFf7zwjlaxHHfhaOxOKRsu5O3Vg9xSbfHjOs8TFGvWTfpezIUvJVBsPkAtK73lEProu5JmsuCSj4JggdoyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763034749; c=relaxed/simple;
	bh=Yy7JgJb4FCddQbs+GZYis9iRWRKBjG84eghi27iE7Ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeDo2V9KMHs4l2eOXNVBey0f/psC1aAplZeQOzHk27A4qmgpimUiahOr6v8rr59x4nWqnioQXOLwEFnAB4RpZLzvtqfvYF2xso8+/yrAuWy/VHhskKDNBmsDE0ihrNMACoXcAsR/yN9zgkVIhx5lVxi8gt7zNaZGwg9JuVw/TSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=blPw1ePC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WLnx8sje; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=blPw1ePC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WLnx8sje; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 033352186F;
	Thu, 13 Nov 2025 11:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763034746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4gKGyIlZECoAZ0pnt30zJaMvG0jDsxFuJsyG2gSarc=;
	b=blPw1ePC98gRAOVeF4FXhp+yMinjXmKBTxLvEFvnjNMwco0TdsAVmoUmpMdYnolhnMiSig
	OaGvJ6nbdF3Mea5n1yZ2fTqqzxxuvokZgz+hbry9pWKSwK+LglecjXoD6KVjY7WVYfcIvl
	ciH9Obk8QC60gOrARM5weoPNVFfCtvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763034746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4gKGyIlZECoAZ0pnt30zJaMvG0jDsxFuJsyG2gSarc=;
	b=WLnx8sjeKAW4zuUvsbbXCunFP2f8wqnkFkDisL7iyLMxNh9RDeeP5duBZZsimlXciSUBm/
	6IjS541FktMUf2Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=blPw1ePC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WLnx8sje
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763034746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4gKGyIlZECoAZ0pnt30zJaMvG0jDsxFuJsyG2gSarc=;
	b=blPw1ePC98gRAOVeF4FXhp+yMinjXmKBTxLvEFvnjNMwco0TdsAVmoUmpMdYnolhnMiSig
	OaGvJ6nbdF3Mea5n1yZ2fTqqzxxuvokZgz+hbry9pWKSwK+LglecjXoD6KVjY7WVYfcIvl
	ciH9Obk8QC60gOrARM5weoPNVFfCtvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763034746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4gKGyIlZECoAZ0pnt30zJaMvG0jDsxFuJsyG2gSarc=;
	b=WLnx8sjeKAW4zuUvsbbXCunFP2f8wqnkFkDisL7iyLMxNh9RDeeP5duBZZsimlXciSUBm/
	6IjS541FktMUf2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E605F3EA61;
	Thu, 13 Nov 2025 11:52:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B9ggOHnGFWmfBQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 11:52:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7B6A6A0976; Thu, 13 Nov 2025 12:52:25 +0100 (CET)
Date: Thu, 13 Nov 2025 12:52:25 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: enable iomap dio write completions from interrupt context
Message-ID: <yzywtpzufhambbcqrd5ijgmkzjr4l62ealwxsfsn6vhlwtpjuk@7rwvj337kfml>
References: <20251112072214.844816-1-hch@lst.de>
 <zqi5yb34w6zsqe7yiv7nryx7xl23txy5fmr5h7ydug7rjnby3l@leukbllawuv2>
 <20251113100527.GA10056@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113100527.GA10056@lst.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 033352186F
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email]
X-Spam-Score: -4.01

On Thu 13-11-25 11:05:27, Christoph Hellwig wrote:
> On Thu, Nov 13, 2025 at 10:58:00AM +0100, Jan Kara wrote:
> > On Wed 12-11-25 08:21:24, Christoph Hellwig wrote:
> > > While doing this I've also found dead code which gets removed (patch 1)
> > > and an incorrect assumption in zonefs that read completions are called
> > > in user context, which it assumes for it's error handling.  Fix this by
> > > always calling error completions from user context (patch 2).
> > 
> > Speaking of zonefs, I how is the unconditional locking of
> > zi->i_truncate_mutex in zonefs_file_write_dio_end_io() compatible with
> > inline completions?
> 
> It wouldn't, but zonefs doesn't use write inline completions because
> it marks all I/O to sequential zones as unwritten.

Ah, now I see that. Thanks for explanation.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

