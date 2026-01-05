Return-Path: <io-uring+bounces-11372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 509E4CF5446
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 19:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47A18302B52C
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 18:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587C333EAEC;
	Mon,  5 Jan 2026 18:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JVUOZG0w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mHdcbXk1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JVUOZG0w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mHdcbXk1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB3629D26E
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767638981; cv=none; b=qyO+S9HgLrC8RlDf+zsQNXPiMCXcYSKTbJyZm/SyOSflpTxEVagbAfxQel94rQwWgQDgjBb2yJg0Y2KMUElyupNnkb4k5lf27sH5wD0+mQptbXFTYnPz8yhiZ1R1ZPuKd3Dj46HqIgkIvXRPBAy61TZQiAXJ3SACVbT5VeijIWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767638981; c=relaxed/simple;
	bh=rSGv+BlFMGxxakwLr1BkoKCuhfW0aUzX2Fd6UW2LkpQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PlapeJ9/uxSjivmeHYHlpd2mODVjJR9rUNRiRHWY4gMV/Qk9JawttM20PlOe7+WLvCHNKZRZxJtUjBRZgfdM2+CyKzOpQi5AZPtcBR76wmNgz3zeG49bXio3R/VUkdPALjH5NtiKAIklKbdST7UYzRHbJXVvtQfscwuzCGhmQB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JVUOZG0w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mHdcbXk1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JVUOZG0w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mHdcbXk1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 395C433750;
	Mon,  5 Jan 2026 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767638977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GBlu/tOBxV908moG/lkaU3l0aelM/P8LluhY6WvfIms=;
	b=JVUOZG0wjKub8hg1ckvT7Uav4iP4X1lO88EF7wni5KHaha+AiXuo1ydzwjEl5pibd6xoZV
	w/cMDOlIq7+S7T6bLi+/XuAzKkjX9Mi+NsJXhD1AaooC9GrzVBojHxV24Q4smazIcyCoNV
	WZ5D37wpwA4xuMxFBHbcm6F2aguxmB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767638977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GBlu/tOBxV908moG/lkaU3l0aelM/P8LluhY6WvfIms=;
	b=mHdcbXk1ksd6lrLxyWE3hdAg1ZF4z5UYpHFqKPHOo/mI2kCTSK1nkxmjmfaPAIgKQhv7Gj
	WNaK8jy9ghklm6Bw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JVUOZG0w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mHdcbXk1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767638977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GBlu/tOBxV908moG/lkaU3l0aelM/P8LluhY6WvfIms=;
	b=JVUOZG0wjKub8hg1ckvT7Uav4iP4X1lO88EF7wni5KHaha+AiXuo1ydzwjEl5pibd6xoZV
	w/cMDOlIq7+S7T6bLi+/XuAzKkjX9Mi+NsJXhD1AaooC9GrzVBojHxV24Q4smazIcyCoNV
	WZ5D37wpwA4xuMxFBHbcm6F2aguxmB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767638977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GBlu/tOBxV908moG/lkaU3l0aelM/P8LluhY6WvfIms=;
	b=mHdcbXk1ksd6lrLxyWE3hdAg1ZF4z5UYpHFqKPHOo/mI2kCTSK1nkxmjmfaPAIgKQhv7Gj
	WNaK8jy9ghklm6Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EAD3A3EA63;
	Mon,  5 Jan 2026 18:49:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z2yOMsAHXGnSNwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 05 Jan 2026 18:49:36 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu,  axboe@kernel.dk,  bschubert@ddn.com,
  asml.silence@gmail.com,  io-uring@vger.kernel.org,
  csander@purestorage.com,  xiaobing.li@samsung.com,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 07/25] io_uring/kbuf: add recycling for kernel
 managed buffer rings
In-Reply-To: <CAJnrk1YRZYdEBL=6K0-7oAq6s-TfL7AnuHwZsN2miPYy1vGCOg@mail.gmail.com>
	(Joanne Koong's message of "Mon, 29 Dec 2025 17:15:42 -0800")
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
	<20251223003522.3055912-8-joannelkoong@gmail.com>
	<87tsx9ymm9.fsf@mailhost.krisman.be>
	<87ms31ylor.fsf@mailhost.krisman.be>
	<CAJnrk1YRZYdEBL=6K0-7oAq6s-TfL7AnuHwZsN2miPYy1vGCOg@mail.gmail.com>
Date: Mon, 05 Jan 2026 13:49:34 -0500
Message-ID: <87pl7n7v41.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[szeredi.hu,kernel.dk,ddn.com,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,mailhost.krisman.be:mid]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 395C433750
X-Spam-Flag: NO
X-Spam-Score: -3.01

Joanne Koong <joannelkoong@gmail.com> writes:

>> But now I see this is never exposed to userspace as an io_uring_cmd
>> command itself, it is only used internally by other fuse operations.
>> Nevertheless, it's implemented as an io_uring_cmd by
>> io_uring_cmd_kmbuffer_recycle.
>>
>> Is it eventually going to be exposed as operations to userspace? If not,
>> I'd suggest to stay out of the io_uring_cmd namespace (perhaps call
>> io_kmbuf_recycle directly from fs/fuse).  Do we need to have this
>> io_uring_cmd abstraction for some reason I'm missing?
>
> Hi Gabriel,
>
> Thanks for taking a look at the patchset.
>
> This is not going to be exposed as an operation to userspace. Only the
> kernel will be able to recycle kmbufs.
>
> I was under the impression the io_uring_cmd_* abstraction was
> preferred as the API for interfacing with io_uring from another
> subsystem.

Hello,

I don't think that's the case, no. io_uring_cmd are used to expose
backend-specific file operations to userspace, similar to an
asynchronous ioctl.  Moreover, it would just add an extra layer, without
bringing any benefits, IMO.

> In that case then, I'll get rid of the io_uring_cmd layers
> for the calls then, that will make things simpler.

-- 
Gabriel Krisman Bertazi

