Return-Path: <io-uring+bounces-5682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB85BA027E0
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 15:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 755FF188657F
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 14:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9331DE4D3;
	Mon,  6 Jan 2025 14:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qlh86TYw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wv6kRoLx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cXlrbb5P";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UKvhm9CM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A61127726;
	Mon,  6 Jan 2025 14:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173454; cv=none; b=l9eGyJrlys8RrHAef0TQFPsYqW0FzZYKMHW6ONMBvse6p2qKU/e+r3KwuN5PusTraxqC/RgfAvau2/7+IgXrFz28YxLJEQP9nbbEmUeYHa6G/k5p62Ea4WvFMQ0GQPk00YibrcjYI1uu/O0dw4rb1dD25XtFXsGj0TrnS9vdvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173454; c=relaxed/simple;
	bh=8pcc7gHbFLclrwUL0GrGnMA4ur0kfYCu/aN08ZplDH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XeYff5Sj1Xiq/LzyrxX//ZvAscmvGfq0/IvYkTZmF0w3HRtGJYkTwzPiRuLCdksvdTMWzUWDZyl5E0BLeymrDhIx4A8nd9qIZ3NuaOsb9YfdJpyt4+CvQoB7I7FKgDOOJ1ReKzEXmSQjRzoIALJkFoJ9eswZOyA7GB2jf9QjXzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qlh86TYw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wv6kRoLx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cXlrbb5P; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UKvhm9CM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FD2A1F399;
	Mon,  6 Jan 2025 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1736173451;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUjlqNFPvyzwOamyHIREUk4JctcwgP8ETMj3R5IQCxo=;
	b=Qlh86TYwV++ybubc55y+r5ySSqMgmEIqd5o5VOv7bPNcW1/Zx/ec5qtatiG2CFi0aEBahd
	nkeQzYmpZyosPC2VyImsIfvGSF3qyX+XPVTEOsmAN4yi6e3IOkNGmPoHldrO0bVtiTrrw+
	V71zDEq2BqVwhaeAajsz4sTMIp1n9AQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1736173451;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUjlqNFPvyzwOamyHIREUk4JctcwgP8ETMj3R5IQCxo=;
	b=Wv6kRoLx2hI/C9jaOdi+wfhVxpo3SEv2O7602+CVzw9deJ+AD7aKU+We283xBULJEAwMcP
	pyNe1SGQnEVpRPCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cXlrbb5P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UKvhm9CM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1736173450;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUjlqNFPvyzwOamyHIREUk4JctcwgP8ETMj3R5IQCxo=;
	b=cXlrbb5PqXST1qK9cjkXtmnRk3RDgfxCYfQrczcIBKgRFibvrB8XcjoIVei87oJgwHNIZZ
	71NjPT8qSu3kVTBJPlLZGiV6fFb5K6a4SrTJGsIXGzTN7X1TUDAWbix56GyHVsEJDH9JGh
	2vl7QnasHbc5Q68oJ2qgWHJiDWbs/5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1736173450;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUjlqNFPvyzwOamyHIREUk4JctcwgP8ETMj3R5IQCxo=;
	b=UKvhm9CMIr5zm4Mr80eMLXTwc8CZ95dBKlzVFZFqAXW92MvqOQXlFz4nky0Ygq5d5AJK3a
	wSCZf7LxXJdcvcCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05DFF137DA;
	Mon,  6 Jan 2025 14:24:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ld0wAYrne2cjOQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 06 Jan 2025 14:24:10 +0000
Date: Mon, 6 Jan 2025 15:24:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/4] btrfs: fix reading from userspace in
 btrfs_uring_encoded_read()
Message-ID: <20250106142408.GX31418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20250103150233.2340306-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250103150233.2340306-1-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: 1FD2A1F399
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.21
X-Spam-Flag: NO

On Fri, Jan 03, 2025 at 03:02:22PM +0000, Mark Harmstone wrote:
> Version 4 of mine and Jens' patches, to make sure that when our io_uring
> function gets called a second time, it doesn't accidentally read
> something from userspace that's gone out of scope or otherwise gotten
> corrupted.
> 
> I sent a version 3 on December 17, but it looks like that got forgotten
> about over Christmas (unsurprisingly).

V3 lacked the cover letter and it was not obvious if it's urgent fix,
new devlopemnent or a regular fix. Also it touched code outside of
btrfs, did not have any acks or word agreement that it would be ok to
take the fixes via btrfs tree.

