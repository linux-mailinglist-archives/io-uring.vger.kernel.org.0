Return-Path: <io-uring+bounces-5846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C367A0C268
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 21:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54439188778F
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 20:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2579A1CBE95;
	Mon, 13 Jan 2025 20:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qz87lZ33";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sGa2XUBW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qz87lZ33";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sGa2XUBW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C15F1C549F;
	Mon, 13 Jan 2025 20:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736798965; cv=none; b=GZ5nNF/tSDVYmQEgdHWUi/FUkPXFYdaTHw4Vyx2FGfIRdIJKpFEsIsi7uOiaiebTSc2oUk7ApCGyKiLS4UILVX53XKh7oGgycZktadf8W1/h6DddtDI6n9fxsO/1FseghO83NyOzmY9s4kOgGGXTaSytE9TNRDlgrlkwop7K4+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736798965; c=relaxed/simple;
	bh=DUiRHdG3Wc5K1gLQ/l/Qm3Lm2kChQEDLKAuXG5Wwlj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQSSvWulR0N/jEpSIUFccHiBCRW9qc0fVe/NRDjYMhjABsvhCpXdnTM6KIHLjz2kL3jPn1GRNNk6/JULjaDoJcMcDudAwwvJfLtEUUlYZFIn/VIybau8vT3gWrRhIaTzaq1/I6cmtS11lcmIsCHi0R1YFi9LJqjN+LxUSpOQ1Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qz87lZ33; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sGa2XUBW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qz87lZ33; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sGa2XUBW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 025522116E;
	Mon, 13 Jan 2025 20:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1736798961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RU2KW34PWnBEIU/4GRDWGorYDCbJRWbXorDLz4rqd/4=;
	b=qz87lZ33mrV+1GLhxBmhdhUG5EvpdDecpkELHne949EroGAuM7Xz9b2lHMJVnfs/r8+403
	MklF55gJh/KioPpd6rXA4oiZWzpI2xk3OLMU14vz9xBwBx8IQAearvZ4fAU8WBjbrvz93a
	b6WUGFBlh+RRSMx7cejZnEyaAYFSnr4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1736798961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RU2KW34PWnBEIU/4GRDWGorYDCbJRWbXorDLz4rqd/4=;
	b=sGa2XUBWBGQlnXw0EGIfnllxsq6GeZUgrm6ge6nk2sZcp7UgfFg+KMoPnKcuzu+SVQuYDe
	JMNaz6U2kPcB7FAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1736798961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RU2KW34PWnBEIU/4GRDWGorYDCbJRWbXorDLz4rqd/4=;
	b=qz87lZ33mrV+1GLhxBmhdhUG5EvpdDecpkELHne949EroGAuM7Xz9b2lHMJVnfs/r8+403
	MklF55gJh/KioPpd6rXA4oiZWzpI2xk3OLMU14vz9xBwBx8IQAearvZ4fAU8WBjbrvz93a
	b6WUGFBlh+RRSMx7cejZnEyaAYFSnr4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1736798961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RU2KW34PWnBEIU/4GRDWGorYDCbJRWbXorDLz4rqd/4=;
	b=sGa2XUBWBGQlnXw0EGIfnllxsq6GeZUgrm6ge6nk2sZcp7UgfFg+KMoPnKcuzu+SVQuYDe
	JMNaz6U2kPcB7FAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D96F813310;
	Mon, 13 Jan 2025 20:09:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NYDTNPByhWeDJQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Jan 2025 20:09:20 +0000
Date: Mon, 13 Jan 2025 21:09:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: add io_uring interface for encoded writes
Message-ID: <20250113200919.GD12628@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20250110172427.1834686-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110172427.1834686-1-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO

On Fri, Jan 10, 2025 at 05:23:52PM +0000, Mark Harmstone wrote:
> Add an io_uring interface for encoded writes, with the same parameters
> as the BTRFS_IOC_ENCODED_WRITE ioctl.
> 
> As with the encoded reads code, there's a test program for this at
> https://github.com/maharmstone/io_uring-encoded, and I'll get this
> worked into an fstest.
> 
> How io_uring works is that it initially calls btrfs_uring_cmd with the
> IO_URING_F_NONBLOCK flag set, and if we return -EAGAIN it tries again in
> a kthread with the flag cleared.
> 
> Ideally we'd honour this and call try_lock etc., but there's still a lot
> of work to be done to create non-blocking versions of all the functions
> in our write path. Instead, just validate the input in
> btrfs_uring_encoded_write() on the first pass and return -EAGAIN, with a
> view to properly optimizing the happy path later on.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
> Changelog:
> * Version 2: switched to using io_uring_cmd_get_async_data, so that we
> only copy from userspace once

I've added this to for-next now, it hasn't been in linux-next so far but
we have at least one week before the merge window. The io_uring+read is
about to be released and there's no reason to delay the write for one
whole dev cycle. Any fixups please send as separate patches. Thanks.

