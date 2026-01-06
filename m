Return-Path: <io-uring+bounces-11424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3103CFA461
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 19:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F08AE301B31D
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 18:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C634350D5D;
	Tue,  6 Jan 2026 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lgZIyPHV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BrmT0EEw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lgZIyPHV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BrmT0EEw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5538422652D
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 18:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767724889; cv=none; b=L1mJ7srF7ogh46uYQL04ASqeU5vt3kdHiKwLM358chwMRpP/SQh02vo+SzzeVUwr+bf4GGPy4+rrWNOQUVp0W51h6e8RS9LUmn/Z1tla7b6u3gZvVcv1B7WKVBbjfBmSnNnRosQsdfPn5j5aG2YNNlO8gIXNHTC9WE/j7RyBe6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767724889; c=relaxed/simple;
	bh=AeOi8MPkkJfXHwvd6kLpFmkFMmoxJ8v/kTZ6d5mVd0A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CDGe2tBH8GK6HQYp7D6Hibl/I5DniQ41lcPXawYGCkODtgvbAiaDvmGPx9Ux2zG2a/pC4hiXIehdNHFOhvvQ1PXGwRvzeelCF319cMMmM2px8m05ZtMkmBJv/6hkqbOmj9SP5122e0rCyMy0VPoiQRuP3vBFdKf6xfsA7Ub/8X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lgZIyPHV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BrmT0EEw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lgZIyPHV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BrmT0EEw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6809A33CBF;
	Tue,  6 Jan 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767724884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fRSxt9lhkRF2yc7K1Xeb8IUMc0alCSHMk9wj5gKcuj4=;
	b=lgZIyPHVEWCK2QJkfdWAeLBUN+dhptwNGxOwL8iGHJJjRkIk4gGtbiuNUwuT89cLDO+GDb
	YMwcHNr7DCIptR79aceMd5+AN9bT3aip8BJMudxOyZJwUPEXgJgma3jJXMKuhvoURsl+6P
	LrRNr0+ggKz9tHMv4sZSp/JbXCIwfR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767724884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fRSxt9lhkRF2yc7K1Xeb8IUMc0alCSHMk9wj5gKcuj4=;
	b=BrmT0EEw5/n/AtwmNAjXskdU/0W2ovMQuNXPXOSF3WyQgoWnRrNZjUv7jmujBXvBadYWLb
	rJfOOmm9TO6q+OBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767724884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fRSxt9lhkRF2yc7K1Xeb8IUMc0alCSHMk9wj5gKcuj4=;
	b=lgZIyPHVEWCK2QJkfdWAeLBUN+dhptwNGxOwL8iGHJJjRkIk4gGtbiuNUwuT89cLDO+GDb
	YMwcHNr7DCIptR79aceMd5+AN9bT3aip8BJMudxOyZJwUPEXgJgma3jJXMKuhvoURsl+6P
	LrRNr0+ggKz9tHMv4sZSp/JbXCIwfR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767724884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fRSxt9lhkRF2yc7K1Xeb8IUMc0alCSHMk9wj5gKcuj4=;
	b=BrmT0EEw5/n/AtwmNAjXskdU/0W2ovMQuNXPXOSF3WyQgoWnRrNZjUv7jmujBXvBadYWLb
	rJfOOmm9TO6q+OBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 144283EA63;
	Tue,  6 Jan 2026 18:41:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0+HZM1NXXWmDWQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 06 Jan 2026 18:41:23 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>,  Joanne Koong <joannelkoong@gmail.com>,
  io-uring@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] io_uring: use release-acquire ordering for
 IORING_SETUP_R_DISABLED
In-Reply-To: <20260105210543.3471082-1-csander@purestorage.com> (Caleb Sander
	Mateos's message of "Mon, 5 Jan 2026 14:05:39 -0700")
References: <20260105210543.3471082-1-csander@purestorage.com>
Date: Tue, 06 Jan 2026 13:41:22 -0500
Message-ID: <875x9e7fe5.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.971];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,purestorage.com:email]

Caleb Sander Mateos <csander@purestorage.com> writes:

> io_uring_enter(), __io_msg_ring_data(), and io_msg_send_fd() read
> ctx->flags and ctx->submitter_task without holding the ctx's uring_lock.
> This means they may race with the assignment to ctx->submitter_task and
> the clearing of IORING_SETUP_R_DISABLED from ctx->flags in
> io_register_enable_rings(). Ensure the correct ordering of the
> ctx->flags and ctx->submitter_task memory accesses by storing to
> ctx->flags using release ordering and loading it using acquire ordering.
>
> Using release-acquire ordering for IORING_SETUP_R_DISABLED ensures the
> assignment to ctx->submitter_task in io_register_enable_rings() can't
> race with msg_ring's accesses, so drop the unneeded {READ,WRITE}_ONCE()
> and the NULL checks.

Hi Caleb,

This looks good, I don't have any comments.  Feel free to add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks,

-- 
Gabriel Krisman Bertazi

